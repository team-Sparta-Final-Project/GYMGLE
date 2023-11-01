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
}

//프로필
struct Profile: Codable {
    var nickName: String
    var image: URL
}

//코멘트
struct Comment: Codable {
    let uid: String
    var comment: String
    var date: Date
    var isUpdated: Bool
}

