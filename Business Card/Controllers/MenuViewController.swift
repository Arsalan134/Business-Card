//
//  MenuViewController.swift
//  Business Card
//
//  Created by Arsalan Iravani on 12/1/18.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import Nuke
import StoreKit

class MenuViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageViewX!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!

    struct MenuItem {
        var image: UIImage?
        var title: String?
    }

    let menuItems: [MenuItem] = [
        //                                MenuItem(image: #imageLiteral(resourceName: "Booking"), title: "Home"),
        MenuItem(image: #imageLiteral(resourceName: "user"), title: "My Account"),
        MenuItem(image: #imageLiteral(resourceName: "settings"), title: "Settings"),
        MenuItem(image: #imageLiteral(resourceName: "life-buoy"), title: "Support"),
        MenuItem(image: #imageLiteral(resourceName: "star"), title: "Rate the app")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUserProfile { (user) in
            if let url = URL(string: user?.imageURL ?? "") {
                Nuke.loadImage(with: url, into: self.profileImageView)
            }
        }

        nameLabel.text = Auth.auth().currentUser?.displayName

    }

    @IBAction func logOut() {

        let alertConrtoller = UIAlertController(title: "Salam", message: "necesen?", preferredStyle: .actionSheet)
        alertConrtoller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertConrtoller.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (action) in
            do {
                let v = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
                self.present(v, animated: true)

                try Auth.auth().signOut()
                FBSDKLoginManager().logOut()
                print("Log out")
            } catch {}
        }))

        present(alertConrtoller, animated: true)

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


extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableViewCell

        cell.iconImageView.image = menuItems[indexPath.row].image
        cell.titleLabel.text = menuItems[indexPath.row].title
        cell.selectionStyle = .none
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)

        switch indexPath.row {
            case 3:
                SKStoreReviewController.requestReview()
        default:
            break
        }
        sideMenuViewController?.hideMenuViewController()
    }

}
