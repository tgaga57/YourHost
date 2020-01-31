//
//  AppDelegate.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/01/30.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FacebookLogin



@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate{
    

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  
        // firebaseを使う前に宣言
        FirebaseApp.configure()
        
        // Facebook Login
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    func application(_ application: UIApplication,open url: URL,sourceApplication: String?,annotation: Any) -> Bool {
           
           return ApplicationDelegate.shared.application(application, open: url,sourceApplication: sourceApplication, annotation: annotation)
       }
       
       func applicationDidBecomeActive(_ application: UIApplication) {
           
           AppEvents.activateApp()
           
       }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }


    
    
    
}

