//
//  AppleSignInButtonCoordinator.swift
//  reminder
//
//  Created by Tan Tan on 4/1/22.
//

import UIKit
import FirebaseAuth
import Resolver

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
}
