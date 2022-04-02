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
            Image("tasks")
                .resizable()
                .frame(width: 150, height: 150)
                .aspectRatio(contentMode: .fit)
                .padding(.top, 20)
            
            HStack {
                Text("Welcome to")
                    .font(.title)
                Text("Reminder")
                    .font(.title)
                    .fontWeight(.semibold)
            }
            .padding(.top, 40)
            
            Text("Create an account to save your tasks and access them anywhere. It's free. \n Forever.")
                    .font(.headline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
            
            Spacer()
            
            AppleSignInButton()
                .frame(height: 60)
                .onTapGesture {
                    signIn()
                }
            
            Divider()
                    .padding(.top, 20.0)
                    .padding(.bottom, 15.0)
            
            Text("By using Reminder you agree to our Terms of Use and Service Policy")
                    .multilineTextAlignment(.center)
        }
        .padding()
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
