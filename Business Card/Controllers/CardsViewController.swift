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

        setupSearchBar()
        navigationController?.title = "Cards"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        navigationController?.setNavigationBarHidden(true, animated: false)
        downloadCards {
            self.filteredCards = cards
            self.collectionView.reloadData()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

//        navigationController?.setNavigationBarHidden(false, animated: false)
        suggestionsTableView.isHidden = true
        searchController.searchBar.text = ""
    }

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
//        searchController.hidesNavigationBarDuringPresentation = false

        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.autocapitalizationType = .words
        searchController.searchBar.tintColor = pink1
        searchController.searchBar.barTintColor = .white
        //        searchController.searchBar.setValue("İmtina", forKey: "_cancelButtonText")
        //        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = .done
//        searchController.searchBar.showsBookmarkButton = true
//        searchController.searchBar.showsSearchResultsButton = true
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = ["All", "Some", "None"]

//        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "_searchField") as? UITextField
//        textFieldInsideSearchBar?.backgroundColor = UIColor(red: 0.01, green: 0.01, blue: 0.01, alpha: 0.09)

        navigationItem.searchController = searchController

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menuIcon"), style: .plain, target: self, action: #selector(SSASideMenu.presentLeftMenuViewController))
    }

}

extension CardsViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text?.count ?? 0 > 0 {
            suggestionsTableView.isHidden = false
            filteredCards = cards.filter { (card) -> Bool in
                return card.title?.contains(searchController.searchBar.text ?? "") ?? false
            }
        } else {
            suggestionsTableView.isHidden = true
        }
        suggestionsTableView.reloadData()
    }

//    func willDismissSearchController(_ searchController: UISearchController) {
//        navigationController?.setNavigationBarHidden(true, animated: true)
//    }

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

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCard = cards[indexPath.row]
//        navigationController?.setNavigationBarHidden(false, animated: true)
        performSegue(withIdentifier: "showDetail", sender: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 40, height: 250)
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
