import UIKit

final class DataManager {

    static let shared = DataManager()
    private init(){}
    
    var gymUid: String?
    var realGymInfo: GymInfo?
    var userInfo: User?
    var id: String?
    var pw: String?
    var profile: Profile?
    
    var userList:[User] = []
    var noticeList:[Notice] = []
    var log:[InAndOut] = []
    
    }
