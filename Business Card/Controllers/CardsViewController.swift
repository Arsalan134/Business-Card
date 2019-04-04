//
//  FirstViewController.swift
//  Business Card
//
//  Created by Arsalan Iravani on 12/1/18.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseFirestore
import FirebaseAuth
import CodableFirebase
import Nuke

struct Card: Decodable {
    var cardID: String?
    var imageURL: String?
    var title: String?
    
    var phone: String?
}

var cards: [Card] = []


class CardsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var suggestionsTableView: UITableView!

    let searchController = UISearchController(searchResultsController: nil)

    var selectedCard: Card?

    var filteredCards: [Card] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .newCardWasAdded, object: nil)

        setupSearchBar()

        let docRef = db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("cards")

        docRef.addSnapshotListener { (documentSnapshot, error) in
            downloadCards {
                self.filteredCards = cards
                self.collectionView.reloadData()
            }
        }

//        navigationController?.navigationBar.isTranslucent = false
        navigationController?.title = "Cards"
//        navigationController?.navigationBar.tintColor = .yellow
//        navigationController?.navigationBar.barTintColor = pink2

//        if traitCollection.forceTouchCapability == .available {
//            registerForPreviewing(with: self, sourceView: view)
//        }

    }

    @objc func reload() {
        collectionView.reloadData()
    }

//    imageView.sd_setImage(with: Storage.storage().reference().child("\(car.imageURL ?? "")"))

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CardDetailViewController {
            destination.card = selectedCard
        }
    }

    func setupSearchBar() {

        navigationItem.title = "Cards"
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        definesPresentationContext = true

        searchController.obscuresBackgroundDuringPresentation = false
        //        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = false

        searchController.searchBar.delegate = self
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.autocapitalizationType = .words
        searchController.searchBar.tintColor = pink1
        searchController.searchBar.barTintColor = .red
        //        searchController.searchBar.setValue("İmtina", forKey: "_cancelButtonText")
        searchController.searchBar.enablesReturnKeyAutomatically = true
        searchController.searchBar.returnKeyType = .done

        searchController.searchBar.scopeButtonTitles = ["All", "Some", "None"]

//        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "_searchField") as? UITextField
//        textFieldInsideSearchBar?.backgroundColor = UIColor(red: 0.01, green: 0.01, blue: 0.01, alpha: 0.09)

        navigationItem.searchController = searchController

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menuIcon"), style: .plain, target: self, action: #selector(SSASideMenu.presentLeftMenuViewController))
    }

}

extension CardsViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {

    func updateSearchResults(for searchController: UISearchController) {
//        print("update")
        if searchController.searchBar.text?.count ?? 0 > 0 {
            suggestionsTableView.isHidden = false

            let scope = searchController.searchBar.scopeButtonTitles![searchController.searchBar.selectedScopeButtonIndex]

            if scope == "All" {
                //                filteredCards = cards.filter("name CONTAINS[c] '\(searchController.searchBar.text)'")
                filteredCards = cards.filter { (card) -> Bool in
                    return card.title?.localizedCaseInsensitiveContains(searchController.searchBar.text ?? "") ?? false
                }
            } else {
                //                filteredCards = cards.filter("name CONTAINS[c] '\(searchText)' AND type.name = '\(scope)'")
                filteredCards = cards.filter { (card) -> Bool in
                    return card.title?.localizedCaseInsensitiveContains(searchController.searchBar.text ?? "") ?? false
                }
            }
        } else {
            suggestionsTableView.isHidden = true
        }
        suggestionsTableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        print("salsldkalsdk")
    }

    //        func willDismissSearchController(_ searchController: UISearchController) {
    //            navigationController?.setNavigationBarHidden(true, animated: true)
    //        }

}

extension CardsViewController: UIViewControllerPreviewingDelegate {

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


}

extension CardsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell

        cell.layer.cornerRadius = 10

        cell.titleLabel.text = cards[indexPath.row].title
        cell.cardImageView.sd_setImage(with: Storage.storage().reference().child("\(cards[indexPath.row].imageURL ?? "")"))
        cell.callButton.isEnabled = cards[indexPath.row].phone != nil
        cell.card = cards[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        selectedCard = cards[indexPath.row]
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 20, height: 250)
    }


}

extension CardsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCards.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCard", for: indexPath) as! SearchCardCell
        cell.cardImageView.sd_setImage(with: Storage.storage().reference().child("\(filteredCards[indexPath.row].imageURL ?? "")"))
        cell.nameLabel.text = filteredCards[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCard = filteredCards[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }


}
