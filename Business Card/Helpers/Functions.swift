//
//  Functions.swift
//  Business Card
//
//  Created by Arsalan Iravani on 1/7/19.
//  Copyright © 2019 Arsalan Iravani. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FirebaseAuth
import CodableFirebase
import FirebaseStorage
import FoldingCell

func fetchUserProfile(_ completion: @escaping (_ user: User?) -> Void) {
    let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, email, name, first_name, last_name, picture.type(large)"])

    var user: User?
    graphRequest.start { (connection, result, error) in
        if error != nil {
            print("Error took place: \(error!)")
        } else {
            print(result ?? 0)
            // Handle vars
            if let result = result as? [String : Any],
//                let fbId: String = result["id"] as? String,
                let name: String = result["first_name"] as? String,
                let lastname: String = result["last_name"] as? String,
                // Add this lines for get image
                let picture: NSDictionary = result["picture"] as? NSDictionary,
                let data: NSDictionary = picture["data"] as? NSDictionary,
                let url: String = data["url"] as? String {

                user = User(name: name, surname: lastname, email: nil, imageURL: url)

                if let email: String = result["email"] as? String {
                    user?.email = email
                }

                completion(user)
            }
        }
    }
}

func deleteCard(card: Card, _ completion: (() -> Void)? = nil) {
    db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("cards").document((card.cardID)!).delete() { error in
        if let error = error {
            print("Error removing document: \(error)")
        } else {
            print("Document successfully removed!")

            guard let url = card.imageURL else {return}
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
        completion?()
    }
}

func downloadCards(_ completion: @escaping() -> Void) {
    let docRef = db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("cards").order(by: "timestamp", descending: true)

    docRef.getDocuments(source: .cache) { (snapshot, error) in
        if let error = error {
            print("Error getting documents: \(error)")
        } else {
            cards.removeAll()
            for document in snapshot!.documents {
                var card = try! FirestoreDecoder().decode(Card.self, from: document.data())
                card.cardID = document.documentID
                cards.append(card)
            }

            if cards.isEmpty {
                docRef.getDocuments(source: .default) { (snapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        cards.removeAll()
                        for document in snapshot!.documents {
                            var card = try! FirestoreDecoder().decode(Card.self, from: document.data())
                            card.cardID = document.documentID
                            cards.append(card)
                        }
                        completion()
                    }
                }
            } else {
                completion()
            }
        }
    }


}
