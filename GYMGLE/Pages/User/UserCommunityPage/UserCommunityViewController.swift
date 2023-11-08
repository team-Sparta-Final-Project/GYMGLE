//
//  UserCommunityViewController.swift
//  GYMGLE
//
//  Created by t2023-m0088 on 2023/10/18.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UserCommunityViewController: UIViewController, CommunityTableViewDelegate {
    
    func didSelectCell(at indexPath: IndexPath) {
        let destinationViewController = BoardDetailViewController()
        if first.nowSearching {
            let data = first.filteredPost[indexPath.row]
            let key = first.filteredKeys[indexPath.row]
            destinationViewController.board = data
            destinationViewController.boardUid = key

        }else {
            let data = first.posts[indexPath.row]
            let key = first.keys[indexPath.row]
            destinationViewController.board = data
            destinationViewController.boardUid = key
        }
        
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    let first = UserCommunityView()
    let second = CommunityCell()
    
    var blockedUsers: [String] = [] // 차단한 유저
    
    override func loadView() {
        view = first
        
    }
    
    deinit{
        removeAllObserve()
        print("테스트 - deinit removeObserve")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        first.writePlace.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(writePlaceTap)))
        first.delegate = self
        self.view = first
        observeFirebaseDataChanges()
    }
    
    override func viewWillAppear(_ animated: Bool) { // 네비게이션바 보여주기
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
//        if DataManager.shared.profile == nil {
//            let userMyProfileVC = UserMyProfileViewController()
//            present(userMyProfileVC, animated: true) {
//                
//            }
//        }
        
        self.first.appTableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        first.endEditing(true)
    }
    
    @objc func writePlaceTap() {
        let userCommunityWriteViewController = UserCommunityWriteViewController()
        //        navigationController?.pushViewController(userCommunityWriteViewController, animated: true)
//        userCommunityWriteViewController.modalPresentationStyle = .fullScreen
        self.present(userCommunityWriteViewController, animated: true)
    }
    
    func getBlockedUserList(completion: @escaping () -> ()) {
        let ref = Database.database().reference().child("accounts/\(Auth.auth().currentUser!.uid)/blockedUserList")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                if let blockedUserData = snapshot.value as? [String: Bool] {
                    // 차단 유저 리스트 배열로 저장
                    self.blockedUsers = Array(blockedUserData.keys)
                }
            }
            completion()
        }
    }
}

extension UserCommunityViewController {
    func decodeData(completion: @escaping () -> Void) {
        let databaseRef = Database.database().reference().child("boards")
        
        let numberOfPostsToRetrieve = 30  // 가져올 게시물 개수 (원하는 개수로 수정)
        databaseRef.queryOrdered(byChild: "date")
            .queryLimited(toLast: UInt(numberOfPostsToRetrieve))
            .observeSingleEvent(of: .value) { snapshot in
                self.first.posts.removeAll() // 데이터를 새로 받을 때 배열 비우기
                self.first.keys.removeAll()
                for childSnapshot in snapshot.children {
                    if let snapshot = childSnapshot as? DataSnapshot,
                       let data = snapshot.value as? [String: Any],
                       let key = snapshot.key as? String,
                       let uid = data["uid"] as? String {
                        
                        // 차단한 유저인지 확인
                        if !self.blockedUsers.contains(uid) {
                            do {
                                let dataInfoJSON = try JSONSerialization.data(withJSONObject: data, options: [])
                                let dataInfo = try JSONDecoder().decode(Board.self, from: dataInfoJSON)
                                self.first.posts.insert(dataInfo, at: 0)
                                self.first.keys.insert(key, at: 0)
                            } catch {
//                                print("디코딩 에러2")
                            }
                        }
                    }
                }
                completion()
                // 테이블 뷰에 업데이트된 순서대로 표시
                //                self.appTableView.reloadData()
            }
    }
    
    func downloadProfiles( complition: @escaping () -> () ){
        self.first.profiles.removeAll()
        var count = self.first.posts.count {
            didSet(oldVal){
                if count == 0 {
                    
                    for i in temp {
                        self.first.profiles.append(tempProfiles[i]!)
                    }
                    complition()
                }
            }
        }
        
        let ref = Database.database().reference()
        var temp:[String] = []
        var tempProfiles:[String:Profile] = [:]
        for i in self.first.posts {
            temp.append(i.uid)
            ref.child("accounts/\(i.uid)/profile").observeSingleEvent(of: .value) {DataSnapshot    in
                do {
                    let JSONdata = try JSONSerialization.data(withJSONObject: DataSnapshot.value!)
                    let profile = try JSONDecoder().decode(Profile.self, from: JSONdata)
                    tempProfiles.updateValue(profile, forKey: i.uid)
                    self.first.profilesWithKey.updateValue(profile, forKey: i.uid)
                    count -= 1
                }catch {
                    print("테스트 - fail - 커뮤니티뷰 프로필 불러오기 실패")
                }
                
            }
            
        }
        
    }
    func observeFirebaseDataChanges() {
        let databaseRef = Database.database().reference().child("boards")
        
        databaseRef.observe(.value) { snapshot in
            self.getBlockedUserList {
                print("테스트 - a")
                self.decodeData {
                    print("테스트 - b")
                    self.downloadProfiles {
                        print("테스트 - c")
                        self.first.appTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func removeAllObserve() {
        let databaseRef = Database.database().reference().child("boards")
        databaseRef.removeAllObservers()
    }

    
    func getCommentCountForBoard(boardUid: String, completion: @escaping (Int) -> Void) {
        let databaseRef = Database.database().reference()
        let boardRef = databaseRef.child("boards").child(boardUid)
        
        boardRef.observeSingleEvent(of: .value) { snapshot in
            if let boardData = snapshot.value as? [String: Any] {
                if let commentCount = boardData["commentCount"] as? Int {
                    completion(commentCount)
                } else {
                    completion(0)
                }
            } else {
                completion(0)
            }
        }
    }
    
}
