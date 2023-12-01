//
//  AdminNoticeDetailViewModel.swift
//  GYMGLE
//
//  Created by 박성원 on 11/11/23.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Combine

final class AdminNoticeDetailViewModel {
    
    private let ref = Database.database().reference()
    private let userID = Auth.auth().currentUser?.uid
    
    @Published var isUser: Bool = true
    @Published var noticeInfo: Notice?
    
    func createdNoticeData(notice: Notice, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let userID = Auth.auth().currentUser?.uid
            let ref = Database.database().reference().child("users").child(userID!).child("noticeList")
            
            let noticeData = try JSONEncoder().encode(notice)
            let noticeJSON = try JSONSerialization.jsonObject(with: noticeData, options: [])
            
            ref.childByAutoId().setValue(noticeJSON)
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func updatedNoticeData(oldContent: String, newNotice: Notice, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userID = userID else {
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
                    completion(.success(()))
                } 
            }
        } catch let error{
            completion(.failure(error))
        }
    }
    
    func deletedNotice(notice: Notice, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userID = userID else {
            return
        }
        do {
            ref.child("users").child(userID).child("noticeList")
                .queryOrdered(byChild: "content")
                .queryEqual(toValue: notice.content)
                .observeSingleEvent(of: .value) { snapshot in
                    guard let value = snapshot.value as? [String: Any],
                          let key = value.keys.first else {
                        return
                    }
                    self.ref.child("users").child(userID).child("noticeList").child(key).removeValue { error, _ in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(()))
                        }
                    }
                }
        }
    }
}
