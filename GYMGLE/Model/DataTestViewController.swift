//
//  DataTestViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/16.
//

import UIKit

class DataTest {
    //test1
    var test = GymInfo(gymAccount: Account(id: "asd",
                                           password: "asd",
                                           accountType: 1),
                       gymName: "aksd",
                       gymPhoneNumber: "01-03132",
                       gymnumber: "123123",
                       
                       gymUserList: [
                        User(account: Account(id: "asd",
                                              password: "asd",
                                              accountType: 1),
                                              name: "asd",
                                              number: "01031023",
                                              startSubscriptionDate: Date(),
                                              endSubscriptionDate: Date(),
                                              userInfo: "addwd",
                                              isInGym: false),
                        
                        User(account: Account(id: "asd",
                                              password: "asd",
                                              accountType: 1),
                                              name: "asd",
                                              number: "01031023",
                                              startSubscriptionDate: Date(),
                                              endSubscriptionDate: Date(),
                                              userInfo: "addwd",
                                              isInGym: false)
                       ],
                       
                       noticeList: [Notice(date: Date(),
                                           content: "추석에 맛있는거 많이드시면안됩니다~회원여러분 친정 가셔서 스퀃100개씩 하십쇼")
                       ],
                       
                       gymInAndOutLog: [InAndOut(id: "sdasd",
                                                 inTime: Date(),
                                                 outTime: Date()),
                                        
                                        InAndOut(id: "sdasd",
                                                 inTime: Date(),
                                                 outTime: Date())
                       ]
    )

    
    
    
//    var id: String
//    var inTime: Date
//    var outTime: Date
    
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
