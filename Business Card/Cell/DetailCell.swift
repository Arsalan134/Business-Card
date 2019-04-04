//
//  DetailCell.swift
//  Business Card
//
//  Created by Arsalan Iravani on 2/5/19.
//  Copyright © 2019 Arsalan Iravani. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DetailCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var propertyName: UILabel!
    @IBOutlet weak var propertyValue: UITextField!

    var card: Card?

    enum S: String {
        case a = "asd"
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        propertyValue.delegate = self
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let uid = Auth.auth().currentUser?.uid else {return}

        var key = ""

        switch propertyName.text ?? "" {
        case "Name":
            key = "title"
        case "Phone":
            key = "phone"
        default:
            break
        }

        db.collection("users").document(uid).collection("cards").document((card?.cardID)!).updateData([key: propertyValue.text?.isEmpty ?? true ? nil : propertyValue.text])
    }


}
