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
                let fbId: String = result["id"] as? String,
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

func downloadCards(_ completion: @escaping() -> Void) {
    let docRef = db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("cards")

    docRef.getDocuments(source: .cache) { (snapshot, error) in
        if let error = error {
            print("Error getting documents: \(error)")
        } else {
            cards.removeAll()
            for document in snapshot!.documents {
//                print("\(document.documentID) => \(document.data())")
                var card = try! FirestoreDecoder().decode(Card.self, from: document.data())
                card.cardID = document.documentID
                cards.append(card)
            }
            completion()
        }
    }
}
