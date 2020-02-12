//
//  CardsTableViewController.swift
//  Business Card
//
//  Created by Arsalan Iravani on 4/6/19.
//  Copyright © 2019 Arsalan Iravani. All rights reserved.
//

import UIKit
import FoldingCell
import FirebaseAuth
import CodableFirebase
import FirebaseStorage
import FirebaseUI

class CardsTableViewController: UITableViewController {

    enum Const {
        static let closeCellHeight: CGFloat = 179
        static let openCellHeight: CGFloat = 488
    }

    var cellHeights: [CGFloat] = []
    let durations: [TimeInterval] = [0.3,0.2,0.2]

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadCards()
    }

    private func downloadCards() {
        let docRef = db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("cards").order(by: "timestamp", descending: true)

        docRef.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                cards.removeAll()
                for document in snapshot!.documents {
                    var card = try! FirestoreDecoder().decode(Card.self, from: document.data())
                    card.cardID = document.documentID
                    cards.append(card)
                }
                self.setup()
                self.tableView.reloadSections([0], with: .automatic)
            }
        }
    }

    private func setup() {
        cellHeights = Array(repeating: Const.closeCellHeight, count: cards.count)
        tableView.estimatedRowHeight = Const.closeCellHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
//        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
    }

    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        })
    }
}

//    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
//        selectedCard = cards[indexPath.row]
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.frame.size.width - 20
//        return CGSize(width: width, height: width / 1.75 )
//    }

// MARK: - TableView

extension CardsTableViewController {

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return cards.count
    }

    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as DemoCell = cell else {
            return
        }

        cell.backgroundColor = .clear

        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }

        cell.set(with: cards[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var impact: UIImpactFeedbackGenerator? = UIImpactFeedbackGenerator()

        impact?.prepare()
        impact?.impactOccurred()

        let feedback = UIFeedbackGenerator()
        let selection = UISelectionFeedbackGenerator()
        let notification = UINotificationFeedbackGenerator()

        impact = nil

        guard let cell = tableView.cellForRow(at: indexPath) as? FoldingCell else {
            return
        }
        
        if cell.isAnimating() {
            return
        }


        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight

        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true)

            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                tableView.beginUpdates()
                tableView.endUpdates()
            })
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                    tableView.beginUpdates()
                    tableView.endUpdates()
                })
            }
        }


    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }

    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexpath) in
            let alert = UIAlertController(title: "Delete?", message: "Sure?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                deleteCard(card: cards[indexPath.row])
            }))

            self.present(alert, animated: true)
        }

        let normal = UITableViewRowAction(style: .normal, title: "Normal") { (action, indexPath) in

        }

        let defaultAction = UITableViewRowAction(style: .default, title: "Default") { (action, indexPath) in

        }
        
        return [deleteAction, normal, defaultAction]
    }

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addAction = UIContextualAction(style: .normal, title: nil) { (action, view, handler) in
            print("Add Action Tapped")
        }

        addAction.image = #imageLiteral(resourceName: "star")

        let configuration = UISwipeActionsConfiguration(actions: [addAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, nil) in
            let alert = UIAlertController(title: "Delete?", message: "Sure?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                deleteCard(card: cards[indexPath.row])
            }))

            self.present(alert, animated: true)
        }

        deleteAction.image = #imageLiteral(resourceName: "trashicon")

        let conf = UISwipeActionsConfiguration(actions: [deleteAction])
        conf.performsFirstActionWithFullSwipe = false
        return conf
    }




}
