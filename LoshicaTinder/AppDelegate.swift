//
//  AppDelegate.swift
//  SwipeFoodFirestore
//
//  Created by Vasily Mordus on 26.10.21.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = RegistrationController()

        FirebaseApp.configure()
        return true
    }

}

