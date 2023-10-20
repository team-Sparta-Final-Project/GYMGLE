//
//  User.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/16.
//

import UIKit

struct User: Codable { //일반 유저
    
    var account: Account
    let name: String
    let number: String // phone
    var startSubscriptionDate: Date
    var endSubscriptionDate: Date
    var userInfo: String
    var isInGym: Bool
    var adminUid: String
}
