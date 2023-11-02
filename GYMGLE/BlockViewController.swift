//
//  BlockViewController.swift
//  GYMGLE
//
//  Created by 조규연 on 11/1/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

class BlockViewController: UIViewController {
    
    let profile = Profile(image: URL(fileURLWithPath: "www.naver.com"), nickName: "example")
    var blockedUsers: [String] = []
    var posts: [Board] = []
    
    private let blockView = BlockView()
    
    override func loadView() {
        view = blockView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPosts()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension BlockViewController {
    func setButton() {
        blockView.blockButton.addTarget(self, action: #selector(blockButtonTapped), for: .touchUpInside)
    }
    
    @objc func blockButtonTapped() {
        let alert = UIAlertController(title: "차단하기",
                                              message: "정말로 차단하시겠습니까?",
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                    self.block()
                }))
                alert.addAction(UIAlertAction(title: "취소", style: .cancel))
                present(alert, animated: true, completion: nil)
    }
    // 차단리스트에 차단유저 uid 등록
    func block() {
        let ref = Database.database().reference().child("profiles")
        let userRef = Database.database().reference().child("profiles/\(Auth.auth().currentUser!.uid)/blockedUserList")
        // 프로필 닉네임으로 uid 검색
        let query = ref.child("nickName").queryEqual(toValue: profile.nickName)
        query.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                if let data = snapshot.value as? [String: Any] {
                    let blockedUserUidArray = data.keys
                    let blockedUserUid = blockedUserUidArray.first
                    // 사용자 차단리스트에 차단유저uid 등록
                    userRef.child("\(blockedUserUid!)").setValue(true)
                }
            }
        }
//        navigationController?.popViewController(animated: true)
    }
    // 게시글 배열 업데이트 하는 함수
    func fetchPosts() {
        let ref = Database.database().reference().child("profiles/\(Auth.auth().currentUser!.uid)/blockedUserList")
//        let ref = Database.database().reference().child("profiles/\(Auth.auth().currentUser?.uid)/blockedUserList")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                if let blockedUserData = snapshot.value as? [String: Bool] {
                    // 차단 유저 리스트 배열로 저장
                    self.blockedUsers = Array(blockedUserData.keys)
                    
                    let postRef = Database.database().reference().child("boards")
                    postRef.observe(.childAdded) { postSnapshot in
                        if let postData = postSnapshot.value as? [String: Any],
                           let uid = postData["uid"] as? String {
                            if !self.blockedUsers.contains(uid) {
                                // 차단되지 않은 작성자의 게시물 posts 배열에 추가
                                do {
                                    
                                    let postInfoData = try JSONSerialization.data(withJSONObject: postData, options: [])
                                    let postInfo = try JSONDecoder().decode(Board.self, from: postInfoData)
                                    
                                    self.posts.append(postInfo)
                                } catch {
                                    print("디코딩 에러")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
