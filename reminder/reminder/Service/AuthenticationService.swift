//
//  AuthenticationService.swift
//  reminder
//
//  Created by Tan Tan on 4/1/22.
//

import Foundation
import Firebase
import FirebaseAuth

class AuthenticationService: ObservableObject {
    @Published var user: User?
    
    func signIn() {
        registerStateListener()
        Auth.auth().signInAnonymously(completion: { _, _ in })
    }
    
    private func registerStateListener() {
        Auth.auth().addStateDidChangeListener { auth, user in
            self.user = user
            if let user = user {
                let anonymous = user.isAnonymous
            }
        }
    }
    
    func updateDisplayName(displayName: String, completion: @escaping (Result<User, Error>) -> Void) {
        if let user = Auth.auth().currentUser {
          let changeRequest = user.createProfileChangeRequest()
          changeRequest.displayName = displayName
          changeRequest.commitChanges { error in
            if let error = error {
                completion(.failure(error))
            } else {
                print("Successfully updated display name for user [\(user.uid)] to [\(displayName)]")
                completion(.success(user))
            }
          }
        }
      }
}
