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


    //    @IBOutlet weak var imageView: UIImageView!
    //    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var testTableView: UITableView!

    var card: Card?

    let properties: [[String]] = [["Name", "Phone"], ["About", "Delete"]]
    let sectionHeaderTitles: [String] = ["Details", "About"]


    override func viewDidLoad() {
        super.viewDidLoad()

        print(card)

        //        titleLabel.adjustsFontSizeToFitWidth = true
        //        titleLabel.text = card?.title
        title = card?.title
        //        navigationItem.rightBarButtonItem = editButtonItem

        
    }

    override var previewActionItems: [UIPreviewActionItem] {
        let editAction = UIPreviewAction(title: "Edit", style: .default) {
            [weak self] (action, controller) in

        }
        let deleteAction = UIPreviewAction(title: "Delete", style: .destructive) {
            [weak self] (action, controller) in

        }
        return [editAction, deleteAction]
    }

    private func deleteFromFirebase() {
        db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("cards").document((card?.cardID)!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")

                guard let url = self.card?.imageURL else {return}
                let imageReference = Storage.storage().reference().child(url)

                // Delete the file
                imageReference.delete { error in
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

    @IBAction func delete() {

        let alert = UIAlertController(title: "Delete \(card?.title ?? "the card")?", message: "This action could not be undo", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            self.deleteFromFirebase()
        }))

        present(alert, animated: true)

    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */


    //    private(set) lazy var orderedViewControllers: [UIViewController] = {
    //        let v = UIViewController()
    //        return [v,v]
    //    }()

}


extension CardDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties[section].count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return properties.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaderTitles[section]
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = testTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DetailCell
        cell.propertyName.text = properties[indexPath.section][indexPath.row]

        cell.card = card

        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: cell.propertyValue.text = card?.title
            case 1:
                cell.propertyValue.text = card?.phone
                cell.propertyValue.keyboardType = .phonePad
            default: break
            }

        case 1: break
        default:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 1 {
            delete()
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        //        pageController.delegate = self
        //        pageController.dataSource = self

        //        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        //        pageController.view.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        //        pageController.view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        //        pageController.view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        //        pageController.view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        //        pageController.view.backgroundColor = .red

        //        if let firstVC = orderedViewControllers.first
        //        {
        //            firstVC.view.backgroundColor = .yellow
        //            pageController.setViewControllers([firstVC], direction: .forward, animated: true)
        //        }

        //        pageController.setViewControllers(orderedViewControllers, direction: .forward, animated: true)
        let imageView = UIImageView()

        //        pageController.view.addSubview(imageView)

        if let url = URL(string: card?.imageURL ?? "") {
            imageView.sd_setImage(with: url)
        }

        imageView.backgroundColor = .red
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        return section == 0 ? imageView : nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 200 : 0
    }


}

//extension CardDetailViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        let pageIndexFeatured = returnPageIndex(currentIndex: 0, numberOfPages: orderedViewControllers.count, isForward: true)
//        let v = orderedViewControllers[pageIndexFeatured]
//        v.view.backgroundColor = .red
//        return v
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        let pageIndexFeatured = returnPageIndex(currentIndex: 0, numberOfPages: orderedViewControllers.count, isForward: false)
//        return orderedViewControllers[pageIndexFeatured]
//    }
//
//
//    func returnPageIndex(currentIndex: Int, numberOfPages: Int,  isForward: Bool) -> Int{
//        var currentPageIndex = currentIndex
//
//        //    print("currentIndex", currentIndex)
//        //    print("numberOfPages", numberOfPages)
//        //    print("isForward", isForward)
//
//        if isForward {
//            currentPageIndex += 1
//
//            if currentPageIndex == numberOfPages {
//                currentPageIndex = 0
//            }
//        } else {
//            currentPageIndex -= 1
//
//            if currentPageIndex == -1 {
//                currentPageIndex = numberOfPages - 1
//            }
//        }
//
//        print("NewIndex", currentPageIndex)
//        return currentPageIndex
//    }
//}
