//
//  CustomFlowLayout.swift
//  Business Card
//
//  Created by Arsalan Iravani on 2/3/19.
//  Copyright © 2019 Arsalan Iravani. All rights reserved.
//

import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {

    var numberOfCellsInRow: CGFloat = 2

    init(numberOfColumns: Int = 2) {
        super.init()

        numberOfCellsInRow = CGFloat(numberOfColumns)
        minimumLineSpacing = 10
        minimumInteritemSpacing = minimumLineSpacing
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var itemSize: CGSize {
        get {
            if collectionView != nil {
                sectionInset = UIEdgeInsets(top: 10, left: minimumInteritemSpacing, bottom: 10, right: minimumInteritemSpacing)

                let a = (collectionView?.contentSize.width)! - sectionInset.left - sectionInset.right - (numberOfCellsInRow - 1) * minimumInteritemSpacing
                let widthOfCell = a / numberOfCellsInRow
                return CGSize(width: widthOfCell, height: widthOfCell)
            }

            // Default fallback
            return CGSize(width: 100, height: 100)
        }
        set {
            super.itemSize = newValue
        }
    }

}
