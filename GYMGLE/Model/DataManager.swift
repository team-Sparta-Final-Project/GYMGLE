import UIKit

class DataManager {

    static let shared = DataManager()
    private init(){}
    
    var gymUid: String?
    var realGymInfo: GymInfo?
    lazy var gymInfo = GymInfo(gymAccount: Account(id: "",
                                           password: "",
                                           accountType: 0),
                       gymName: "aksd",
                       gymPhoneNumber: "010-0313-2222",
                       gymnumber: "0123456789",
                       
                       gymUserList: [
                        User(account: Account(id: "1",
                                              password: "1",
                                              accountType: 1), //트레이너
                                              name: "asd",
                                              number: "01031023",
                                              startSubscriptionDate: Date(),
                                              endSubscriptionDate: Date(),
                                              userInfo: "addwd",
                             isInGym: true, adminUid: "1"),
                        
                        User(account: Account(id: "2",
                                              password: "2",
                                              accountType: 2),
                                              name: "asdf",
                                              number: "01031024",
                                              startSubscriptionDate: Date(),
                                              endSubscriptionDate: Date(),
                                              userInfo: "addwdf",
                             isInGym: true, adminUid: "2"),
                        
                        User(account: Account(id: "2",
                                              password: "2",
                                              accountType: 2),
                                              name: "박성원",
                                              number: "01031024",
                                              startSubscriptionDate: Date(),
                                              endSubscriptionDate: Date(),
                                              userInfo: "addwdf",
                             isInGym: true, adminUid: "2"),
                        
                        User(account: Account(id: "2",
                                              password: "2",
                                              accountType: 2),
                                              name: "박성원",
                                              number: "01031024",
                                              startSubscriptionDate: Date(),
                                              endSubscriptionDate: Date(),
                                              userInfo: "addwdf",
                             isInGym: true, adminUid: "2")
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
    
    lazy var gymList: [GymInfo] = [gymInfo] // 나중에 수정할것?..
  
    func makeNoticeList(_ notice: Notice) {
        self.gymInfo.noticeList.append(notice)
    }
    
    func updateNotice(_ notice: Notice) {
        for (index, existednotice) in gymInfo.noticeList.enumerated() {
            if existednotice.date == notice.date {
                gymInfo.noticeList[index] = notice
            }
        }
    }
    
    func updateIsInGym(id: String) { //큐알코드를 찍었을 때
        for (index, gymUserList) in gymInfo.gymUserList.enumerated() {
            if gymUserList.account.id == id {
                gymInfo.gymUserList[index].isInGym = true
            }
        }
    }
    
    func getUserList() -> [User] {
        var userList = self.gymInfo.gymUserList
        return userList
    }
    
    //MARK: - 싱글톤 메서드
    
    //회원 추가
    func addGymUser(id:String, password:String, type:Int, name:String, number:String){
        
        self.gymInfo.gymUserList.append(
        User(account: Account(id: id,
                              password: password,
                              accountType: type),
                              name: name,
                              number: number,
                              startSubscriptionDate: Date(),
                              endSubscriptionDate: Date(),
                              userInfo: "추가정보",
             isInGym: true, adminUid: "1")
        )
    }
    
    func addFullGymUser(id:String, password:String, type:Int, name:String, number:String, startDate:Date, endDate:Date, userInfo:String){
        
        self.gymInfo.gymUserList.append(
        User(account: Account(id: id,
                              password: password,
                              accountType: type),
                              name: name,
                              number: number,
                              startSubscriptionDate: Date(),
                              endSubscriptionDate: Date(),
                              userInfo: "추가정보",
             isInGym: true, adminUid: "1")
        )
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
