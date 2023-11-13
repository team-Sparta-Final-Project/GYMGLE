//
//  UserRootModel.swift
//  GYMGLE
//
//  Created by t2023-m0088 on 2023/10/13.
//

import SnapKit
import UIKit

//struct UserRootList{
//    var healthName: String
//    var noticeList: String
//    var nowUser: Int
//    var yesterUser: Int
//}

struct UserLog {
    let id: String
    let inTime: TimeInterval
    let outTime: TimeInterval
}

class GymViewModel {
    private let dataManager: DataManager
    private var userLogs: [UserLog] = []
    
    var currentUsersCount: Int {
        return userLogs.filter { $0.outTime > Date().addingTimeInterval(-7*24*60*60).timeIntervalSinceReferenceDate }.count
    }
    
    var lastWeekUsersCount: Int {
        return userLogs.filter {
            $0.inTime <= Date().addingTimeInterval(-7*24*60*60).timeIntervalSinceReferenceDate &&
            $0.outTime >= Date().addingTimeInterval(-7*24*60*60).timeIntervalSinceReferenceDate
        }.count
    }
    
    var totalExerciseForUser: Double = 0
    var totalExercise: Double = 0
    var totalUserCount: Double = 0
    var roundedTimes: Double = 0
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
//    func fetchData() {
//        dataManager.fetchUserLogs { [weak self] userLogs in
//            self?.userLogs = userLogs
//            // 여기서 필요한 UI 업데이트를 호출할 수 있습니다.
//        }
//    }
    
}
