//
//  LoginManager.swift
//  GYMGLE
//
//  Created by 조규연 on 10/19/23.
//

import Foundation

class LoginManager {
    static func updateLoginStatus(isLoggedIn: Bool, userType: UserType) {
        UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
        UserDefaults.standard.set(userType.rawValue, forKey: "userType")
    }
}
