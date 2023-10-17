//
//  Admin.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/16.
//

import Foundation


struct GymInfo { //관리자
    
    var gymAccount: Account
    var gymName: String
    var gymPhoneNumber: String
    let gymnumber: String
    var gymUserList: [User]
    var noticeList: [Notice]
    var gymInAndOutLog: [InAndOut]
    
}
