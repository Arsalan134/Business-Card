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
import ParallaxHeader

class CardDetailViewController: UIViewController {


    //    @IBOutlet weak var imageView: UIImageView!
    //    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var testTableView: UITableView!

    var card: Card?

    let properties: [[String]] = [["Name", "Phone"], ["About", "Delete"]]
    let sectionHeaderTitles: [String] = ["Details", "About"]


    override func viewDidLoad() {
        super.viewDidLoad()


        //        titleLabel.adjustsFontSizeToFitWidth = true
        //        titleLabel.text = card?.title
        title = card?.title
//        navigationItem.rightBarButtonItem = editButtonItem
    }

    private func deleteFromFirebase() {
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
        let imageView = UIImageView()

        if let url = URL(string: card?.imageURL ?? "") {
            imageView.sd_setImage(with: url)
        }

        imageView.backgroundColor = .red

        return section == 0 ? imageView : nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 200 : 0
    }


}
