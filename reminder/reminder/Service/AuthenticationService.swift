//
//  AuthenticationService.swift
//  reminder
//
//  Created by Tan Tan on 4/1/22.
//

import Foundation
import Firebase

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
}
