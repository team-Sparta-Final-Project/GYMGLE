//
//  AdminNoticeDetailViewModel.swift
//  GYMGLE
//
//  Created by 박성원 on 11/11/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

final class AdminNoticeDetailViewModel {
    
    private var dataManager: DataManager
    private let ref = Database.database().reference()
    private let userID = Auth.auth().currentUser?.uid
    
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
    }
    
    func createdNoticeData(notice: Notice, completion: @escaping () -> Void) {
        do {
            let userID = Auth.auth().currentUser?.uid
            let ref = Database.database().reference().child("users").child(userID!).child("noticeList")
            
            let noticeData = try JSONEncoder().encode(notice)
            let noticeJSON = try JSONSerialization.jsonObject(with: noticeData, options: [])
            
            ref.childByAutoId().setValue(noticeJSON)
            completion()
        } catch {
            completion()
        }
    }
    
    func updatedNoticeData(oldContent: String, newNotice: Notice, completion: @escaping () -> Void) {
        guard let userID = userID else {
            completion()
            return
        }
        do {
            let noticeData = try JSONEncoder().encode(newNotice)
            let noticeJSON = try JSONSerialization.jsonObject(with: noticeData, options: [])
            
            ref.child("users").child(userID).child("noticeList").queryOrdered(byChild: "content").queryEqual(toValue: oldContent).observeSingleEvent(of: .value) { snapshot in
                
                if let snapshotValue = snapshot.value as? [String: Any],
                   let key = snapshotValue.keys.first {
                    let updatedNoticeRef = self.ref.child("users").child(userID).child("noticeList").child(key)
                    updatedNoticeRef.setValue(noticeJSON)
                    completion()
                } else {
                    completion()
                }
            }
        } catch {
            completion()
        }
    }
    
    func deletedNotice(notice: Notice, completion: @escaping () -> Void) {
        guard let userID = userID else {
            completion()
            return
        }
        do {
            ref.child("users").child(userID).child("noticeList")
                .queryOrdered(byChild: "content")
                .queryEqual(toValue: notice.content)
                .observeSingleEvent(of: .value) { snapshot in
                    guard let value = snapshot.value as? [String: Any],
                          let key = value.keys.first else {
                        completion()
                        return
                    }
                    self.ref.child("users").child(userID).child("noticeList").child(key).removeValue()
                    completion()
                }
        } catch let error {
            completion()
        }
    }
}
