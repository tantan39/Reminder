//
//  AppleSignInButton.swift
//  reminder
//
//  Created by Tan Tan on 4/1/22.
//

import Foundation
import SwiftUI
import AuthenticationServices

struct AppleSignInButton: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        if colorScheme == .light {
            AppleSignInButtonUIView(color: .dark)
        } else {
            AppleSignInButtonUIView(color: .light)
        }
    }
}

struct AppleSignInButton_Preview: PreviewProvider {
    static var previews: some View {
        AppleSignInButton()
    }
}

fileprivate struct AppleSignInButtonUIView: UIViewRepresentable {
    var color: ColorScheme
    
    func makeUIView(context: Context) -> some ASAuthorizationAppleIDButton {
        switch color {
        case .light:
            return ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)
        default:
            return ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
        }
        
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
