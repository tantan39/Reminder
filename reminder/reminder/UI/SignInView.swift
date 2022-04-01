//
//  SignInView.swift
//  reminder
//
//  Created by Tan Tan on 4/1/22.
//

import Foundation
import SwiftUI

struct SignInView: View {
    @State var signInHandler: AppleSignInButtonCoordinator?
    
    var body: some View {
        VStack {
            Text("Sign in")
                .font(.headline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            
            Spacer()
            
            AppleSignInButton()
                .frame(width: 280, height: 45)
                .onTapGesture {
                    signIn()
                }
        }
    }
    
    func signIn() {
        
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
