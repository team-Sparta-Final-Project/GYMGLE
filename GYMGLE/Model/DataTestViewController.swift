//
//  DataTestViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/16.
//

import UIKit

class DataTest {
    //test1

    static let shared = DataTest()
    
    lazy var test = GymInfo(gymAccount: Account(id: "asdff",
                                           password: "asdff",
                                           accountType: 0),
                       gymName: "aksd",
                       gymPhoneNumber: "010-0313-2222",
                       gymnumber: "0123456789",
                       
                       gymUserList: [
                        User(account: Account(id: "asd",
                                              password: "asd",
                                              accountType: 2),
                                              name: "asd",
                                              number: "01031023",
                                              startSubscriptionDate: Date(),
                                              endSubscriptionDate: Date(),
                                              userInfo: "addwd",
                                              isInGym: true),
                        
                        User(account: Account(id: "asdf",
                                              password: "asdf",
                                              accountType: 2),
                                              name: "asdf",
                                              number: "01031024",
                                              startSubscriptionDate: Date(),
                                              endSubscriptionDate: Date(),
                                              userInfo: "addwdf",
                                              isInGym: true)
                       ],
                       
                       noticeList: [Notice(date: Date(),
                                           content: "추석에 맛있는거 많이드시면안됩니다~회원여러분 친정 가셔서 스퀃100개씩 하십쇼 추석에 맛있는거 많이드시면안됩니다~회원여러분 친정 가셔서 스퀃100개씩 하십쇼 추석에 맛있는거 많이드시면안됩니다~회원여러분 친정 가셔서 스퀃100개씩 하십쇼 추석에 맛있는거 많이드시면안됩니다~회원여러분 친정 가셔서 스퀃100개씩 하십쇼"),
                                    Notice(date: datecomponent(month: 1, day: 8, hour: 12),
                                                        content: "추석에 맛있는거 많이드시면안됩니다~회원여러분 친정 가셔서 스퀃100개씩 하십쇼 추석에 맛있는거 많이드시면안됩니다~회원여러분 친정 가셔서 스퀃100개씩 하십쇼"),
                                    Notice(date: datecomponent(month: 1, day: 1, hour: 12),
                                                        content: "추석에 맛있는거 많이드시면안됩니다~회원여러분 친정 가셔서 스퀃100개씩 하십쇼")
                       ],
                   

                       gymInAndOutLog: [InAndOut(id: "sdasd",
                                                 inTime: Date(timeIntervalSinceNow: -604800),
                                                 outTime: Date(timeIntervalSinceNow: -601200), sinceInAndOutTime: 12),
                                        
                                        InAndOut(id: "sdas",
                                                 inTime: Date(timeIntervalSinceNow: -604800),
                                                 outTime: Date(timeIntervalSinceNow: -601200), sinceInAndOutTime: 12)
                       ]
    )
    
    lazy var gymList: [GymInfo] = [test]
  
  
      func getDummyData() -> GymInfo {
        return self.test
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
