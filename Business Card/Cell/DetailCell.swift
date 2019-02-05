//
//  DetailCell.swift
//  Business Card
//
//  Created by Arsalan Iravani on 2/5/19.
//  Copyright © 2019 Arsalan Iravani. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet weak var propertyName: UILabel!
    @IBOutlet weak var propertyValue: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
