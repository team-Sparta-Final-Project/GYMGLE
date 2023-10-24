import UIKit

class DataManager {

    static let shared = DataManager()
    private init(){}
    
    var gymUid: String?
    var realGymInfo: GymInfo?
    var userInfo: User?
    var id: String?
    var pw: String?
    
    var userList:[User] = []
    var noticeList:[Notice] = []
    var log:[InAndOut] = []
  
    // TODO: 임시로 주석처리 해 놓았습니다 - 데이터모델 공사중
    
//    func makeNoticeList(_ notice: Notice) {
//        self.gymInfo.noticeList.append(notice)
//    }
//
    func updateNotice(_ notice: Notice) {
        for (index, existednotice) in noticeList.enumerated() {
            if existednotice.date == notice.date {
                noticeList[index] = notice
            }
        }
    }
//
//    func updateIsInGym(id: String) { //큐알코드를 찍었을 때
//        for (index, gymUserList) in gymInfo.gymUserList.enumerated() {
//            if gymUserList.account.id == id {
//                gymInfo.gymUserList[index].isInGym = true
//            }
//        }
//    }
    

    
    //MARK: - 싱글톤 메서드
    
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
