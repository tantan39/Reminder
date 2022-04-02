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
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
        signInHandler = AppleSignInButtonCoordinator(window: self.window)
        signInHandler?.link(onSignIn: { user in
            print("User signed in \(user.uid)")
            presentationMode.wrappedValue.dismiss()
        })
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
