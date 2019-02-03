//
//  CardDetailViewController.swift
//  Business Card
//
//  Created by Arsalan Iravani on 1/12/19.
//  Copyright © 2019 Arsalan Iravani. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseAuth

class CardDetailViewController: UIViewController {


    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    var card: Card?

    override func viewDidLoad() {
        super.viewDidLoad()


        titleLabel.adjustsFontSizeToFitWidth = true

        if let url = URL(string: card?.imageURL ?? "") {
            imageView.sd_setImage(with: url)
        }

        titleLabel.text = card?.title
        title = card?.title
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func delete() {
        db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("cards").document((card?.cardID)!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")

                guard let url = self.card?.imageURL else {return}
                let desertRef = Storage.storage().reference().child(url)

                // Delete the file
                desertRef.delete { error in
                    if error != nil {
                        // Uh-oh, an error occurred!
                    } else {

                        print("Image successfully removed!")
                    }
                }
            }
            self.navigationController?.popViewController(animated: true)
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
