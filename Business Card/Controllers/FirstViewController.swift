//
//  FirstViewController.swift
//  Business Card
//
//  Created by Arsalan Iravani on 1/7/19.
//  Copyright © 2019 Arsalan Iravani. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "a", sender: nil)
        } else {
            performSegue(withIdentifier: "b", sender: nil)
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
