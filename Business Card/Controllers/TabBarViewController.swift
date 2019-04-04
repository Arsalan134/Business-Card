//
//  TabBarViewController.swift
//  Business Card
//
//  Created by Arsalan Iravani on 12/1/18.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

import UIKit
import WeScan
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.unselectedItemTintColor = pink1
        tabBar.tintColor = pink2

    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.selectedImage == UIImage(named: "camera") {
            open()
        }
    }

    func open() {
        let scannerViewController = ImageScannerController()
        scannerViewController.imageScannerDelegate = self
        present(scannerViewController, animated: true)
    }
}


extension TabBarViewController: ImageScannerControllerDelegate {

    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {

        let alert = UIAlertController(title: "Title", message: "Enter a text", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Name of the Card"
            textField.autocapitalizationType = .words
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]

            let imageRef = Storage.storage().reference().child("images").child("\(Auth.auth().currentUser?.uid ?? "no user id")_\(Date().timeIntervalSince1970)")

            guard let image = results.scannedImage.jpeg(.lowest)?.pngData() else {return}

            imageRef.putData(image, metadata: nil) { (metadata, error) in
                //                guard let metadata = metadata else {return}
                //                let size = metadata.size
                //                print("size: \(size)")

                NotificationCenter.default.post(name: .newCardWasAdded, object: nil)

                db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("cards").addDocument(data: [
                    "title": textField!.text as Any,
                    "imageURL": imageRef.fullPath
                ])
            }.resume()

        }))

        scanner.dismiss(animated: true)
        present(alert, animated: true)
    }

    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true)
    }

    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        print(error)
    }
}
