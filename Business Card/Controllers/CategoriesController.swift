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

class CategoriesController: UIViewController, UIViewControllerPreviewingDelegate {

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {

        // First, get the index path and view for the previewed cell.

        //        let pointInTable: CGPoint = sender.convertPoint(sender.bounds.origin, toView: self.tableView)

        guard let indexPath = collectionView.indexPathForItem(at: location),
            let cell = collectionView.layoutAttributesForItem(at: indexPath)
            //            let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
            else { return nil }

        //        print(cell.titleLabel.text!)
        // Enable blurring of other UI elements, and a zoom in animation while peeking.
        previewingContext.sourceRect = cell.frame

        // Create and configure an instance of the color item view controller to show for the peek.
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "a") as? CategoriesController
            else { preconditionFailure("Expected a ColorItemViewController") }

        // Pass over a reference to the ColorData object and the specific ColorItem being viewed.

        return viewController
    }


    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }


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

        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
    }
    

    @IBAction func showMenu() {
        print("salam")
        performSelector(onMainThread: #selector(SSASideMenu.presentLeftMenuViewController), with: nil, waitUntilDone: true)
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
