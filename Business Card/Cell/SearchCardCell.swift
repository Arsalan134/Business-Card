//
//  SearchCardCell.swift
//  Business Card
//
//  Created by Arsalan Iravani on 12/3/18.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

import UIKit

class SearchCardCell: UITableViewCell {

    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
