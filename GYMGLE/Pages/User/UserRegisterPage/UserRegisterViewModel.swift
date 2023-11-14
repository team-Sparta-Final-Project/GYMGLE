import Foundation
import Firebase
import Combine

class UserRegisterViewModel: ObservableObject {
    let ref = Database.database().reference()
    
    func update(user:User){
        do {
            let userData = try JSONEncoder().encode(user)
            let userJSON = try JSONSerialization.jsonObject(with: userData, options: [])
            
            
            // 어카운트 접근해서 id값이 편집하려는 유저 id와 동일한 것 받아와서 uid값 찾아내기
            ref.child("accounts").queryOrdered(byChild: "account/id").queryEqual(toValue: "\(user.account.id)").observeSingleEvent(of: .value) { DataSnapshot in
                guard let value = DataSnapshot.value as? [String:Any] else { return }
                var uid = ""
                for i in value.keys {
                    uid = i
                }
                self.ref.child("accounts/\(uid)").setValue(userJSON)
            }
        }
        catch{
            print("JSON 인코딩 에러")
        }
    }
    
    
    func register(uid:String,start:Date,end:Date,userInfo:String){
        ref.child("accounts/\(uid)").updateChildValues(["adminUid":"로그인된 짐uid","startSubscriptionDate":Int(start.timeIntervalSinceReferenceDate),"endSubscriptionDate":Int(end.timeIntervalSinceReferenceDate),"userInfo":userInfo])
    }
    
    func observe(uid:String){
        ref.child("accounts/\(uid)/adminUid").observe(.value) { snapshot in
            print("테스트 - \(snapshot)")
            
        }
    }
}
