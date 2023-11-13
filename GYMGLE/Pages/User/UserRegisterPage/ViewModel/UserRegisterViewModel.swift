//
//  UserRegisterViewModel.swift
//  GYMGLE
//
//  Created by t2023-m0078 on 2023/11/12.
//

import Foundation
import Firebase
import Combine

class UserRegisterViewModel: ObservableObject {
    
    
    func update(user:User){
        do {
            let userData = try JSONEncoder().encode(user)
            let userJSON = try JSONSerialization.jsonObject(with: userData, options: [])
            
            let ref = Database.database().reference()
            // 어카운트 접근해서 id값이 편집하려는 유저 id와 동일한 것 받아와서 uid값 찾아내기
            ref.child("accounts").queryOrdered(byChild: "account/id").queryEqual(toValue: "\(user.account.id)").observeSingleEvent(of: .value) { DataSnapshot in
                guard let value = DataSnapshot.value as? [String:Any] else { return }
                var uid = ""
                for i in value.keys {
                    uid = i
                }
                ref.child("accounts/\(uid)").setValue(userJSON)
            }
        }
        catch{
            print("JSON 인코딩 에러")
        }
    }
    
}
