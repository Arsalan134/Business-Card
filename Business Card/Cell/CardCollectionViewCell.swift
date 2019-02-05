//
//  CardCollectionViewCell.swift
//  Business Card
//
//  Created by Arsalan Iravani on 12/1/18.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var callButton: UIButton!

    var card: Card?

    @IBAction func call() {
        if let number = card?.phone {
            guard let number = URL(string: "tel://" + number) else { return }
            UIApplication.shared.open(number)
        }
    }

}
