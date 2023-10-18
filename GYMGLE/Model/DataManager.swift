import Foundation

class DataManager {
    static let shared = DataManager()
    private init(){}
    
    static func randomGymUser(id:String,name:String,isIn:Bool){
        
        gyms.gymUserList.append(
        User(account: Account(id: id,
                              password: "회원비번",
                              accountType: 2),
                              name: name,
                              number: "010-\(Int.random(in: 1000...9999))-\(Int.random(in: 1000...9999))",
                              startSubscriptionDate: Date(),
                              endSubscriptionDate: Date(),
                              userInfo: "추가정보",
                              isInGym: isIn)
        )
    }
    
    static func addGymUser(name:String,number:String){
        
        gyms.gymUserList.append(
        User(account: Account(id: "회원기본아이디",
                              password: "회원비번",
                              accountType: 2),
                              name: name,
                              number: number,
                              startSubscriptionDate: Date(),
                              endSubscriptionDate: Date(),
                              userInfo: "추가정보",
                              isInGym: true)
        )
    }
}

var gyms:GymInfo = GymInfo(gymAccount: Account(id: "D",
                                               password: "D",
                                               accountType: 0),
                           gymName: "만나짐",
                           gymPhoneNumber: "01088884444",
                           gymnumber: "사업자등록번호",
                           
                           gymUserList: [],
                           
                           noticeList: [Notice(date: Date(),
                                               content: "추석에 맛있는거 많이드시면안됩니다~회원여러분 친정 가셔서 스퀃100개씩 하십쇼")
                           ],
                           
                           gymInAndOutLog: [InAndOut(id: "회원1",
                                                     inTime: Date(),
                                                     outTime: Date(), sinceInAndOutTime: 12),
                                            
                                            InAndOut(id: "회원2",
                                                     inTime: Date(),
                                                     outTime: Date(), sinceInAndOutTime: 12)
                           ]
        )
