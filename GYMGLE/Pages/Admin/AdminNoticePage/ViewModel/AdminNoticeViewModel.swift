//
//  AdminNoticeViewModel.swift
//  GYMGLE
//
//  Created by 박성원 on 11/11/23.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Combine


final class AdminNoticeViewModel: ObservableObject {
    
    private let ref = Database.database().reference()
    private let userID = Auth.auth().currentUser?.uid
    
    var noticeList: [Notice] = []
    @Published var isAdmin: Bool = true
    
    var dataManager: DataManager
    
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
    }
    
    var numberOfSections: Int {
        return self.noticeList.count
    }
    
    var numberOfRowsInSection: Int {
        return 1
    }
    
    var heightForHeaderInSection: CGFloat {
        return 10
    }
    
    func getNoticeList( completion: @escaping (Result<Void, Error>) -> Void) {
        noticeList.removeAll()
        guard let gymUid = dataManager.gymUid else { return }
        ref.child("users/\(gymUid)/noticeList").observeSingleEvent(of: .value) { DataSnapshot in
            
            if DataSnapshot.exists() {
                guard let value = DataSnapshot.value as? [String:[String:Any]] else { return }
                do {
                    let jsonArray = value.values.map { $0 as [String: Any] }
                    let jsonData = try JSONSerialization.data(withJSONObject: jsonArray)
                    let notices = try JSONDecoder().decode([Notice].self, from: jsonData)
                    self.noticeList.insert(contentsOf: notices, at: 0)
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.success(()))
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
