//
//  UserDataManager.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/17.
//

import UIKit

class UserDataManager {
    
    lazy var userList: [User] = []
    
    func makeUserList() {
        
        self.userList = [
            User(account: Account(id: "asdff", password: "asdff", accountType: 0), name: "김기호", number: "01066146889", startSubscriptionDate: datecomponent(month: 10, day: 10, hour: 10), endSubscriptionDate: datecomponent(month: 10, day: 10, hour: 12), userInfo: "운동 똑바로 시킬것", isInGym: false),
            
            User(account: Account(id: "asdff", password: "asdff", accountType: 0), name: "공성표", number: "01066146889", startSubscriptionDate: datecomponent(month: 10, day: 10, hour: 10), endSubscriptionDate: datecomponent(month: 10, day: 10, hour: 12), userInfo: "운동 똑바로 시킬것", isInGym: true),
            
            User(account: Account(id: "asdff", password: "asdff", accountType: 0), name: "박성원", number: "01066146889", startSubscriptionDate: datecomponent(month: 10, day: 10, hour: 10), endSubscriptionDate: datecomponent(month: 10, day: 10, hour: 12), userInfo: "운동 똑바로 시킬것", isInGym: false),
            
            User(account: Account(id: "asdff", password: "asdff", accountType: 0), name: "조규연", number: "01066146889", startSubscriptionDate: datecomponent(month: 10, day: 10, hour: 10), endSubscriptionDate: datecomponent(month: 10, day: 10, hour: 12), userInfo: "운동 똑바로 시킬것", isInGym: true),
            // ----------
            User(account: Account(id: "asdff", password: "asdff", accountType: 0), name: "김기호2", number: "01066146889", startSubscriptionDate: datecomponent(month: 10, day: 3, hour: 10), endSubscriptionDate: datecomponent(month: 10, day: 3, hour: 12), userInfo: "운동 똑바로 시킬것", isInGym: false),
            
            User(account: Account(id: "asdff", password: "asdff", accountType: 0), name: "공성표2", number: "01066146889", startSubscriptionDate: datecomponent(month: 10, day: 3, hour: 10), endSubscriptionDate: datecomponent(month: 10, day: 3, hour: 12), userInfo: "운동 똑바로 시킬것", isInGym: true),
            
            User(account: Account(id: "asdff", password: "asdff", accountType: 0), name: "박성원2", number: "01066146889", startSubscriptionDate: datecomponent(month: 10, day: 3, hour: 10), endSubscriptionDate: datecomponent(month: 10, day: 3, hour: 12), userInfo: "운동 똑바로 시킬것", isInGym: false),
            
            User(account: Account(id: "asdff", password: "asdff", accountType: 0), name: "조규연2", number: "01066146889", startSubscriptionDate: datecomponent(month: 10, day: 3, hour: 10), endSubscriptionDate: datecomponent(month: 10, day: 3, hour: 12), userInfo: "운동 똑바로 시킬것", isInGym: true)
        ]
    }
    
    func getUserList() -> [User] {
        return self.userList
    }
    
    
    func datecomponent(month: Int, day: Int, hour: Int) -> Date {
        var components = DateComponents()
        components.year = 2023
        components.month = month
        components.day = day
        
        components.hour = hour
        components.minute = 30
        components.second = 0
        
        let specifiedDate: Date = Calendar.current.date(from: components)!
        return specifiedDate
    }
    
}
