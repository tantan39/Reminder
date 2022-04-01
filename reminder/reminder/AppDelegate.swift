//
//  AppDelegate.swift
//  reminder
//
//  Created by Tan Tan on 4/1/22.
//

import Firebase
import UIKit
import Resolver

class AppDelegate: NSObject, UIApplicationDelegate {
    @Injected var authenticationService: AuthenticationService
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        authenticationService.signIn()
        
        return true
    }
}
