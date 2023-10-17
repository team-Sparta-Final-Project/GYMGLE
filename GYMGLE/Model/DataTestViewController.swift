//
//  DataTestViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/16.
//

import UIKit

class DataTest {
    //test1
    var test: GymInfo = GymInfo(gymAccount: Account(id: "1@test.com",
                                           password: "123456",
                                           accountType: 1),
                       gymName: "만나짐",
                       gymPhoneNumber: "031-979-1234",
                       gymnumber: "010-0000-0000",
                       
                       gymUserList: [
                        User(account: Account(id: "tjddnjs549",
                                              password: "aaaaaaaa",
                                              accountType: 1),
                                              name: "박성원",
                                              number: "010-3333-3333",
                                              startSubscriptionDate: datecomponent(1, 1, 12),
                                              endSubscriptionDate: datecomponent(3, 1, 23),
                                              userInfo: "운동 못함",
                                              isInGym: true),
                        
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
                                           content: "추석에 맛있는거 많이드시면안됩니다~회원여러분 친정 가셔서 스퀃100개씩 하십쇼 추석에 맛있는거 많이드시면안됩니다~회원여러분 친정 가셔서 스퀃100개씩 하십쇼 추석에 맛있는거 많이드시면안됩니다~회원여러분 친정 가셔서 스퀃100개씩 하십쇼 추석에 맛있는거 많이드시면안됩니다~회원여러분 친정 가셔서 스퀃100개씩 하십쇼"),
                                    Notice(date: datecomponent(1, 8, 12),
                                                        content: "추석에 맛있는거 많이드시면안됩니다~회원여러분 친정 가셔서 스퀃100개씩 하십쇼 추석에 맛있는거 많이드시면안됩니다~회원여러분 친정 가셔서 스퀃100개씩 하십쇼"),
                                    Notice(date: datecomponent(1, 1, 12),
                                                        content: "추석에 맛있는거 많이드시면안됩니다~회원여러분 친정 가셔서 스퀃100개씩 하십쇼")
                       ],
                       
                       gymInAndOutLog: [InAndOut(id: "tjddnjs549",
                                                 inTime: datecomponent(1, 8, 12),
                                                 outTime: datecomponent(1, 8, 14)),
                                        
                                        InAndOut(id: "tjddnjs549",
                                                 inTime: datecomponent(1, 1, 12),
                                                 outTime: datecomponent(1, 1, 14))
                       ]
    )
                           

    func getDummyData() -> GymInfo {
        return self.test
    }
    
    
    
    static func datecomponent(_ month: Int,_ day: Int,_ hour: Int) -> Date {
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
