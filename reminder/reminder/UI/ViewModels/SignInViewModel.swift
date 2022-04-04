//
//  SignInViewModel.swift
//  reminder
//
//  Created by Tan Tan on 4/2/22.
//

import Foundation
import FirebaseAuth

class SignInViewModel: ObservableObject {
    @Published var user: User?
    
    init() {
        self.user = Auth.auth().currentUser
    }
}
