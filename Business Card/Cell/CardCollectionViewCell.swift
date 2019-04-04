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

    @IBOutlet weak var containerView: UIView!

    var card: Card?

    override func awakeFromNib() {
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
    }

    @IBAction func call() {
        if let number = card?.phone {
            guard let number = URL(string: "tel://" + number) else { return }
            UIApplication.shared.open(number)
        }
    }

}
