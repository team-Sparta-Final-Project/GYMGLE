//
//  UserMyProfieViewModel.swift
//  GYMGLE
//
//  Created by 박성원 on 11/12/23.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

final class UserMyProfileViewModel {
    
    
    private let ref = Database.database().reference()
    private let userID = Auth.auth().currentUser?.uid
    
    private var dataManager: DataManager
    
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
    }

    
    var numberOfRowsInSection: Int {
        return 1
    }
    
    var heightForHeaderInSection: CGFloat {
        return 10
    }
    

//    func getPost(completion: @escaping () -> Void) {
//        self.post.removeAll()
//        let ref = Database.database().reference().child("boards")
//        let query = ref.queryOrdered(byChild: "uid").queryEqual(toValue: "\(userUid!)")
//        query.observeSingleEvent(of: .value) { dataSnapshot in
//            guard let value = dataSnapshot.value as? [String: [String: Any]] else { return }
//            do {
//                let jsonArray = value.values.compactMap { $0 as [String: Any] }
//                let jsonData = try JSONSerialization.data(withJSONObject: jsonArray)
//                let posts = try JSONDecoder().decode([Board].self, from: jsonData)
//                self.post.append(contentsOf: posts)
//                completion()
//            } catch let error {
//                print("테스트 - \(error)")
//                completion()
//            }
//        }
//    }
}
