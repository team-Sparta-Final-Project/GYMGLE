//
//  AdminNoticeViewModel.swift
//  GYMGLE
//
//  Created by 박성원 on 11/11/23.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

final class AdminNoticeViewModel {
    
    
    private let ref = Database.database().reference()
    private let userID = Auth.auth().currentUser?.uid
    
    private var dataManager: DataManager
    
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
    }
    var numberOfSections: Int {
        return DataManager.shared.noticeList.count
    }
    
    var numberOfRowsInSection: Int {
        return 1
    }
    
    var heightForHeaderInSection: CGFloat {
        return 10
    }
    
    var notice: [Notice] {
        return dataManager.noticeList
    }
    
    func getNoticeList( completion: @escaping () -> Void) {
        ref.child("users/\(dataManager.gymUid!)/noticeList").observeSingleEvent(of: .value) { DataSnapshot in
            guard let value = DataSnapshot.value as? [String:[String:Any]] else { return
                completion()
            }
            do {
                let jsonArray = value.values.compactMap { $0 as [String: Any] }
                let jsonData = try JSONSerialization.data(withJSONObject: jsonArray)
                let notices = try JSONDecoder().decode([Notice].self, from: jsonData)
                self.dataManager.noticeList = notices
                completion()
            } catch let error {
                print("테스트 - \(error)")
                completion()
            }
        }
    }
    
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .full
        formatter.dateFormat = "MM/dd"
        
        return formatter.string(from: date)
    }
}
