//
//  User.swift
//  Business Card
//
//  Created by Arsalan Iravani on 1/7/19.
//  Copyright © 2019 Arsalan Iravani. All rights reserved.
//

import Foundation

struct User: Decodable {
    var name: String?
    var surname: String?
    var email: String?
    var imageURL: String?
}
