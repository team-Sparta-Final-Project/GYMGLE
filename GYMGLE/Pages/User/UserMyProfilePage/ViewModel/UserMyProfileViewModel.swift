//
//  UserMyProfieViewModel.swift
//  GYMGLE
//
//  Created by 박성원 on 11/12/23.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import Combine


final class UserMyProfileViewModel {
    
    private let ref = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid
    var dataManager: DataManager
    
    
    @Published var gymName: String?
    @Published var userUid: String?
    var keys: [String] = []
    @Published var post: [Board] = []
    @Published var nickName: String?
    @Published var url: URL?
    
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
    }

    var numberOfRowsInSection: Int {
        return 1
    }
    
    var heightForHeaderInSection: CGFloat {
        return 10
    }
    

    func getProfile() {
        guard let userUid = self.userUid else {return}
        let ref = Database.database().reference().child("accounts").child("\(userUid)").child("profile")
        ref.observeSingleEvent(of: .value) { dataSnapshot in
            if let profileData = dataSnapshot.value as? [String: Any] {
                if let nickName = profileData["nickName"] as? String,
                   let imageUrlString = profileData["image"] as? String,
                   let imageUrl = URL(string: imageUrlString) {
                    self.nickName = nickName
                    self.url = imageUrl
                } else {
                }
            }
        }
    }
    
    func getPost(completion: @escaping (Result<Void,Error>) -> Void) {
        self.post.removeAll()
        let ref = Database.database().reference().child("boards")
        let query = ref.queryOrdered(byChild: "uid").queryEqual(toValue: "\(userUid!)")
        query.observeSingleEvent(of: .value) { dataSnapshot in
            if dataSnapshot.exists() {
                guard let value = dataSnapshot.value as? [String: [String: Any]] else { return }
                do {
                    let jsonArray = value.values.compactMap { $0 as [String: Any] }
                    let jsonData = try JSONSerialization.data(withJSONObject: jsonArray)
                    let posts = try JSONDecoder().decode([Board].self, from: jsonData)
                    self.post.append(contentsOf: posts)
                    completion(.success(()))
                } catch let error {
                    completion(.failure(error))
                }
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getBoardKeys() {
        self.keys.removeAll()
        let ref = Database.database().reference().child("boards")
        let query = ref.queryOrdered(byChild: "uid").queryEqual(toValue: "\(userUid!)").queryLimited(toLast: 500)
        query.observeSingleEvent(of: .value) { dataSnapshot, arg  in
            for childSnapshot in dataSnapshot.children {
                if let snapshot = childSnapshot as? DataSnapshot,
                   let key = snapshot.key as? String  {
                    self.keys.insert(key, at: 0)
                }
            }
        }
    }
    
    func getGymName() {
        let ref = Database.database().reference().child("accounts").child("\(userUid!)").child("adminUid")
        ref.observeSingleEvent(of: .value) { dataSnapshot in
            if let adminUid = dataSnapshot.value as? String {
                let gymRef = Database.database().reference().child("users").child("\(adminUid)").child("gymInfo/gymName")
                gymRef.observeSingleEvent(of: .value) { DataSnapshot in
                    if let gymName = DataSnapshot.value as? String {
                        self.gymName = gymName
                    }
                }
            }
        }
    }
    func block() {
        let userRef = Database.database().reference().child("accounts/\(Auth.auth().currentUser!.uid)/blockedUserList")
        let blockedUserUid = self.userUid
        userRef.child("\(blockedUserUid!)").setValue(true)
    }
}
