//
//  AppleSignInButtonCoordinator.swift
//  reminder
//
//  Created by Tan Tan on 4/1/22.
//

import UIKit
import FirebaseAuth
import Resolver
import AuthenticationServices
import CryptoKit

enum SignInState: String {
    case signIn
    case link
    case reauth
}

class AppleSignInButtonCoordinator: NSObject {
    @Injected private var taskRepository: TaskRepository
    @Injected private var authenticationService: AuthenticationService
    
    private weak var window: UIWindow!
    private var onSignedIn: ((User) -> Void)?
    
    private var currentNonce: String?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    private func appleIDRequest(with state: SignInState) -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.state = state.rawValue
        
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
        
        return request
    }
    
    func link(onSignIn: @escaping (User) -> Void) {
        self.onSignedIn = onSignIn
        let request = appleIDRequest(with: .link)
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // MARK: - Helpers
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

extension AppleSignInButtonCoordinator: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
                return
            }
            guard let stateRaw = appleIDCredential.state, let state = SignInState(rawValue: stateRaw) else {
                print("Invalid state: request must be started with one of the SignInStates")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            guard let currentUser = Auth.auth().currentUser else { return }
            
            switch state {
            case .signIn:
                Auth.auth().signIn(with: credential) { (result, error) in
                    if let error = error {
                        print("Error authenticating: \(error.localizedDescription)")
                        return
                    }
                    if let user = result?.user {
                        if let onSignedInHandler = self.onSignedIn {
                            onSignedInHandler(user)
                        }
                    }
                }
            case .link:
                currentUser.link(with: credential, completion: { result, error in
                    if let error = error, (error as NSError).code == AuthErrorCode.credentialAlreadyInUse.rawValue {
                        print("The user you're signing in with has already been linked, signing in to the new user and migrating the anonymous users [\(currentUser.uid)] tasks.")
                        
                        if let updatedCredential = (error as NSError).userInfo[AuthErrorUserInfoUpdatedCredentialKey] as? OAuthCredential {
                            print("Signing in using the updated credentials")
                            Auth.auth().signIn(with: updatedCredential) { (result, error) in
                                if let user = result?.user {
                                    // TODO: handle data migration
                                    
                                    self.doSignIn(appleIDCredential: appleIDCredential, user: user)
                                }
                            }
                        }
                    }
                    else if let error = error {
                        print("Error trying to link user: \(error.localizedDescription)")
                    }
                    else {
                        if let user = result?.user {
                            self.doSignIn(appleIDCredential: appleIDCredential, user: user)
                        }
                    }
                    
                })
                
            case .reauth:
                Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
                    if let error = error {
                        print("Error authenticating: \(error.localizedDescription)")
                        return
                    }
                    if let user = result?.user {
                        self.doSignIn(appleIDCredential: appleIDCredential, user: user)
                    }
                })
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("authorizationController didCompleteWithError \(error.localizedDescription)")
    }
    
    private func doSignIn(appleIDCredential: ASAuthorizationAppleIDCredential, user: User) {
        if let fullName = appleIDCredential.fullName {
            if let givenName = fullName.givenName, let familyName = fullName.familyName {
                let displayName = "\(givenName) \(familyName)"
                self.authenticationService.updateDisplayName(displayName: displayName) { result in
                    switch result {
                    case .success(let user):
                        print("Succcessfully update the user's display name: \(String(describing: user.displayName))")
                    case .failure(let error):
                        print("Error when trying to update the display name: \(error.localizedDescription)")
                    }
                    self.callSignInHandler(user: user)
                }
            }
            else {
                self.callSignInHandler(user: user)
            }
        }
    }
    
    private func callSignInHandler(user: User) {
        if let onSignedInHandler = self.onSignedIn {
            onSignedInHandler(user)
        }
    }
}

extension AppleSignInButtonCoordinator: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.window
    }
}
