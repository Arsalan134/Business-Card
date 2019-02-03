//
//  CameraViewController.swift
//  Business Card
//
//  Created by Arsalan Iravani on 12/1/18.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.selectedIndex = 2
    }

}
