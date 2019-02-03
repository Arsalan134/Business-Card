//
//  LoginViewController.swift
//  Business Card
//
//  Created by Arsalan Iravani on 1/7/19.
//  Copyright © 2019 Arsalan Iravani. All rights reserved.
//

import UIKit

import Firebase
import FirebaseFirestore

import FBSDKCoreKit
import FBSDKLoginKit

// easy
//import FacebookCore
//import FacebookLogin

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = FBSDKLoginButton()
        loginButton.center = view.center
        loginButton.delegate = self
        loginButton.readPermissions = ["public_profile", "email"]

        view.addSubview(loginButton)

        if FBSDKAccessToken.current() != nil {
            print("\talready LOGGED IN with fb")
        }

        if Auth.auth().currentUser != nil {
            print(1)
            //            let vc = SecondViewController()
            //            window?.rootViewController = vc
        } else {
            print(2)
            //            let vc = ViewController()
            //            window?.rootViewController = vc
        }
    }
}



extension LoginViewController: FBSDKLoginButtonDelegate {

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {

        if result.isCancelled {
            return
        }

        if let error = error {
            print(error.localizedDescription)
            return
        }

        print("Login fb")

        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)

        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)

                let alertController = UIAlertController(title: "Login Failed", message: error.localizedDescription, preferredStyle: .alert)

                let permitAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(permitAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            print("User is signed in", authResult ?? "kj")
            print("ssss ", Auth.auth().currentUser ?? "no user")

            let v = self.storyboard?.instantiateViewController(withIdentifier: "menu") as! SSASideMenu
            self.present(v, animated: true)

//            // old:
//            let date: Date = documentSnapshot.get("created_at") as! Date
//            // new:
//            let timestamp: Timestamp = documentSnapshot.get("created_at") as! Timestamp
//            let date: Date = timestamp.dateValue()


            fetchUserProfile({ (user) in
                let ref: DocumentReference? = db.collection("users").document((Auth.auth().currentUser?.uid)!)

                ref?.setData([
                    "name": user?.name,
                    "lastname": user?.surname,
                    "email": Auth.auth().currentUser?.email
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("🍓 Document added with ID: \(ref!.documentID)")
                    }
                }
            })


        }
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        do {
            try Auth.auth().signOut()
            print("Log out")
        } catch {}
    }

}
