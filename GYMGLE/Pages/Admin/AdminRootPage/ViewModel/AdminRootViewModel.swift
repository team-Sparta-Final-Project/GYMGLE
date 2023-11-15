//
//  AdminRootViewModel.swift
//  GYMGLE
//
//  Created by 박성원 on 11/10/23.
//

import FirebaseAuth
import FirebaseDatabase
import Foundation
import Combine

final class AdminRootViewModel: ObservableObject {
    
    let ref = Database.database().reference()
    var dataManager: DataManager
    @Published var isAdmin: Bool = true
    
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            dataManager.realGymInfo = nil
        } catch _ as NSError { }
    }
    
    func deleteAccount(completion: @escaping () -> Void) {
        // 계정 삭제
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if error != nil {
                } else {
                    completion()
                }
            }
            //탈퇴한 헬스장의 유저들 삭제
            let query = ref.child("accounts").queryOrdered(byChild: "adminUid").queryEqual(toValue: dataManager.gymUid!)
            query.observeSingleEvent(of: .value) { snapshot in
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot {
                        snapshot.ref.removeValue()
                    }
                }
            }
            // 헬스장 관리자를 데이터베이스에서 삭제
            let userRef = Database.database().reference().child("users").child(user.uid)
            userRef.removeValue()
            self.signOut()
        } else {}
        completion()
    }
}
