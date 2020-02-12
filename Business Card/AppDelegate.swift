//
//  AppDelegate.swift
//  Business Card
//
//  Created by Arsalan Iravani on 11/29/18.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FBSDKCoreKit
import FirebaseStorage

var db: Firestore!

@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if let font = UIFont(name: "Montserrat", size: 20) {
            let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: pink1]
            UINavigationBar.appearance().titleTextAttributes = attributes
            UINavigationBar.appearance().tintColor = .red
        }

        UINavigationBar.appearance().tintColor = pink1

        FirebaseApp.configure()

        db = Firestore.firestore()

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        print("ID:\t", Auth.auth().currentUser?.uid ?? "no id")
        print("NAME:\t", Auth.auth().currentUser?.displayName ?? "no name")
        print("EMAIL:\t", Auth.auth().currentUser?.email ?? "no email")

//        do {
//            try Auth.auth().signOut()
//        } catch {}

//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.makeKeyAndVisible()
//        window?.backgroundColor = .yellow
//
//        if FBSDKAccessToken.current() != nil {
//            let vc = ViewController()
//            window?.rootViewController = vc
//        } else {
//            let vc = LoginViewController()
//            window?.rootViewController = vc
//        }

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        //        Add the following to your AppDelegate class. This initializes the SDK when your app launches, and lets the SDK handle results from the native Facebook app when you perform a Login or Share action.
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

