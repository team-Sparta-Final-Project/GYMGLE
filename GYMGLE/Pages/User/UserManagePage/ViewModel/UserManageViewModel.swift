//
//  UserCommunityViewModel.swift
//  GYMGLE
//
//  Created by t2023-m0078 on 2023/11/12.
//

import Foundation
import Firebase
import Combine

class UserManageViewModel : ObservableObject {
    @Published var cells:[User] = []
    
    func userDataRead() {
        let ref = Database.database().reference()
        ref.child("accounts").queryOrdered(byChild: "adminUid").queryEqual(toValue: DataManager.shared.gymUid!).observeSingleEvent(of: .value) { DataSnapshot  in
            guard let value = DataSnapshot.value as? [String:Any] else { return }
            var temp:[User] = []
            for i in value.values {
                do {
                    let JSONdata = try JSONSerialization.data(withJSONObject: i)
                    let user = try JSONDecoder().decode(User.self, from: JSONdata)
                    temp.append(user)
                } catch let error {
                    print("테스트 - \(error)")
                }
            }
            self.cells = temp.sorted(by: { $0.startSubscriptionDate < $1.startSubscriptionDate })
        }
    }
    func userDelete(completion: @escaping () -> Void, id: String) {
        // 회원삭제 - 서버
        let ref = Database.database().reference()
        ref.child("accounts").queryOrdered(byChild: "account/id").queryEqual(toValue: "\(id)").observeSingleEvent(of: .value) { DataSnapshot in
            guard let value = DataSnapshot.value as? [String:Any] else { return }
            var uid = ""
            for i in value.keys {
                uid = i
            }
            ref.child("accounts/\(uid)").removeValue()
            completion()
        }
    }
    
}
