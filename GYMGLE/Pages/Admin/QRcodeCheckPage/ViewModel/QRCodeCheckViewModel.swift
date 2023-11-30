//
//  QRCodeCheckViewModel.swift
//  GYMGLE
//
//  Created by 박성원 on 11/15/23.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import 
final class QRCodeCheckViewModel {
    
    
    var userUidList: [String] = []
    var userList: [User] = []
    func readAdminUid(completion: @escaping () -> Void){
        let ref = Database.database().reference().child("accounts")
        let query = ref.queryOrdered(byChild: "adminUid").queryEqual(toValue: DataManager.shared.gymUid)
        query.observeSingleEvent(of: .value) { snapshot in
            guard let userSnapshot = snapshot.value as? [String:[String:Any]] else {
                return
            }
            do {
                let jsonArray = userSnapshot.values.compactMap { $0 as [String: Any] }
                let jsonData = try JSONSerialization.data(withJSONObject: jsonArray)
                let user = try JSONDecoder().decode([User].self, from: jsonData)
                DataManager.shared.userList = user
                completion()
            } catch let error {
            }
        }
    }
    
    func readUserUid(completion: @escaping () -> Void) {
        self.userUidList.removeAll()
        let ref = Database.database().reference().child("accounts")
        let query = ref.queryOrdered(byChild: "adminUid").queryEqual(toValue: "임시")
        query.observeSingleEvent(of: .value) { snapshot in
            guard let userSnapshot = snapshot.value as? [String:[String:Any]] else {
                return
            }
            self.userUidList.append(contentsOf: userSnapshot.keys)
            completion()
        }
    }
    
    func createdInAndOutLog(id: String) { //큐알코드를 찍었을 때
        let ref = Database.database().reference().child("users").child(DataManager.shared.gymUid!)
        if let currentedTimePlusOne = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) {
            let nAndOutLog = InAndOut(id: id, inTime: Date(), outTime: currentedTimePlusOne, sinceInAndOutTime: 0.0)
            do {
                let inAndOutLogData = try JSONEncoder().encode(nAndOutLog)
                let inAndOutLogJSON = try JSONSerialization.jsonObject(with: inAndOutLogData, options: [])
                ref.child("gymInAndOutLog").childByAutoId().setValue(inAndOutLogJSON)
            } catch {
            }
        }
    }
}
