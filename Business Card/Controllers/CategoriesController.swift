//
//  CategoriesController.swift
//  Business Card
//
//  Created by Arsalan Iravani on 2/3/19.
//  Copyright © 2019 Arsalan Iravani. All rights reserved.
//

import UIKit

var categories: [Category] = []

struct Category {
    let title: String
    let image: UIImage
}

class CategoriesController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        categories.append(Category(title: "Marble", image: #imageLiteral(resourceName: "falcon")))
        categories.append(Category(title: "Finance", image: #imageLiteral(resourceName: "falcon")))

        categories.append(Category(title: "Finance", image: #imageLiteral(resourceName: "falcon")))
        categories.append(Category(title: "Finance", image: #imageLiteral(resourceName: "falcon")))
        categories.append(Category(title: "Finance", image: #imageLiteral(resourceName: "falcon")))
        categories.append(Category(title: "Finance", image: #imageLiteral(resourceName: "falcon")))
        categories.append(Category(title: "Finance", image: #imageLiteral(resourceName: "falcon")))
        categories.append(Category(title: "Finance", image: #imageLiteral(resourceName: "falcon")))
        categories.append(Category(title: "Finance", image: #imageLiteral(resourceName: "falcon")))
        categories.append(Category(title: "Finance", image: #imageLiteral(resourceName: "falcon")))
        categories.append(Category(title: "Finance", image: #imageLiteral(resourceName: "falcon")))
        categories.append(Category(title: "Finance", image: #imageLiteral(resourceName: "falcon")))
        categories.append(Category(title: "Finance", image: #imageLiteral(resourceName: "falcon")))

        collectionView.setCollectionViewLayout(CustomFlowLayout(numberOfColumns: 2), animated: false)
        collectionView.layoutIfNeeded()
        collectionView.reloadData()
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


extension CategoriesController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        cell.imageView.image = categories[indexPath.row].image
        cell.titleLabel.text = categories[indexPath.row].title
        return cell
    }


}
