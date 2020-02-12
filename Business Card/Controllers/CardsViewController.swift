//
//  FirstViewController.swift
//  Business Card
//
//  Created by Arsalan Iravani on 12/1/18.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import WeScan
import FoldingCell
import JGProgressHUD

struct Card: Decodable {
    var cardID: String?
    var imageURL: String?
    var title: String?
    
    var phone: String?
}

var cards: [Card] = []


class CardsViewController: UIViewController {

    @IBOutlet weak var suggestionsTableView: UITableView!

    @IBOutlet weak var titleLabel: UILabel!

    let searchController = UISearchController(searchResultsController: nil)

    var selectedCard: Card?

    var filteredCards: [Card] = []

    let activityIndicator = UIActivityIndicatorView(style: .white)

    override func viewDidLoad() {
        super.viewDidLoad()

        //        setupSearchBar()
        setupLoadingView()
        setGradientBackground(colorTop: .lightGray, colorBottom: .cyan)
    }

    func setupLoadingView() {

//        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50)
        ])

    }

    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //        navigationController?.setNavigationBarHidden(true, animated: animated)
    //    }
    //
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //        navigationController?.setNavigationBarHidden(false, animated: animated)
    //    }

    @IBAction func openMenu() {
        perform(#selector(SSASideMenu.presentLeftMenuViewController))
    }

    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        //        gradientLayer.locations = [0, 1]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    @IBAction func open() {
        let scannerViewController = ImageScannerController()
        scannerViewController.imageScannerDelegate = self
        present(scannerViewController, animated: true)
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

        //        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menuIcon"), style: .plain, target: self, action: #selector(SSASideMenu.presentLeftMenuViewController))
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
        print("cancelled")
    }


}

//extension CardsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return cards.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell
//
//        cell.layer.cornerRadius = 10
//
//        cell.titleLabel.text = cards[indexPath.row].title
//        cell.cardImageView.sd_setImage(with: Storage.storage().reference().child("\(cards[indexPath.row].imageURL ?? "")"))
//        cell.callButton.isEnabled = cards[indexPath.row].phone != nil
//        cell.card = cards[indexPath.row]
//5
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
//        selectedCard = cards[indexPath.row]
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.frame.size.width - 20
//        return CGSize(width: width, height: width / 1.75 )
//    }
//}

// search
//extension CardsViewController: UITableViewDataSource, UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return filteredCards.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCard", for: indexPath) as! SearchCardCell
//        cell.cardImageView.sd_setImage(with: Storage.storage().reference().child("\(filteredCards[indexPath.row].imageURL ?? "")"))
//        cell.nameLabel.text = filteredCards[indexPath.row].title
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedCard = filteredCards[indexPath.row]
//        performSegue(withIdentifier: "showDetail", sender: nil)
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
//}

extension CardsViewController: ImageScannerControllerDelegate {

    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {

        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        notificationFeedbackGenerator.prepare()

        guard let image = results.scannedImage.jpeg(.lowest)?.pngData() else {return}

        let imageRef = Storage.storage().reference().child("images").child("\(Auth.auth().currentUser?.uid ?? "no user id")_\(Date().timeIntervalSince1970)")

        activityIndicator.startAnimating()

        // Upload to Storage
        imageRef.putData(image, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {return}
            let size = metadata.size
            print("size: \(size)")

            if let error = error {
                let alert = UIAlertController(title: "Oups!", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
                notificationFeedbackGenerator.notificationOccurred(.error)
                return
            }

            notificationFeedbackGenerator.notificationOccurred(.success)

            // Add to Firestore
            db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("cards").addDocument(data: [
                "imageURL": imageRef.fullPath,
                "timestamp": Timestamp.init()
            ]) { (error) in
                self.activityIndicator.stopAnimating()
            }
        }



        scanner.dismiss(animated: true)
        //        present(alert, animated: true)
    }

    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true)
    }

    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        print(error)
    }
}
