//
//  AppDelegate.swift
//  AppCentProject
//
//  Created by ahmet on 9.06.2021.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let tabBarVC = TabBarController()
                        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = tabBarVC

        IQKeyboardManager.shared.enable = true

        return true
    }




}

