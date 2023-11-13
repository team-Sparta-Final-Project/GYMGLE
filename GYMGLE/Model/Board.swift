//
//  Board.swift
//  GYMGLE
//
//  Created by 박성원 on 10/31/23.
//

import Foundation

struct Board: Codable {
    let uid: String
    var content: String
    var date: Date
    var isUpdated: Bool
    var likeCount: Int
    var commentCount: Int
}

//프로필
struct Profile: Codable {
    var image: URL
    var nickName: String

    enum CodingKeys: String, CodingKey {
        case image
        case nickName
    }
}


//코멘트
struct Comment: Codable {
    let uid: String
    var comment: String
    var date: Date
    var isUpdated: Bool
    var profile: Profile
}


