//
//  UserMyProfileViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 10/31/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import FirebaseStorage
import Firebase

final class UserMyProfileViewController: UIViewController {

    // MARK: - prirperties
    let userMyProfileView = UserMyProfileView()
    var userUid: String?
    var post: [Board] = [] // 셀 나타내기
    var keys: [String] = []
    var nickName: String = ""
    var url: URL?
    var gymName: String = ""
    var viewModel: UserMyProfileViewModel!
    
    // MARK: - life cycle

    override func loadView() {
        view = userMyProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadSetting()
        viewModel = UserMyProfileViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearSetting()
    }
}

// MARK: - private extension custom func

private extension UserMyProfileViewController {
  
    func viewDidLoadSetting() {
        tableViewSetting()
        profileIsNil()
        buttonSetting()
        setCustomBackButton()
    }
    
    func viewWillAppearSetting() {
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
        dataSetting()
    }
    
    func tableViewSetting() {
        userMyProfileView.postTableview.dataSource = self
        userMyProfileView.postTableview.delegate = self
        userMyProfileView.postTableview.register(UserMyProfileBoardTableViewCell.self, forCellReuseIdentifier: UserMyProfileBoardTableViewCell.identifier)
    }
    
    func buttonSetting() {
        if userUid == Auth.auth().currentUser?.uid { // 내 프로필 진입 시
            userMyProfileView.updateButton.addTarget(self, action: #selector(updateButtonButtoned), for: .touchUpInside)
            userMyProfileView.updateButton.titleLabel?.text = "프로필 수정"
        } else { //다른 사람 프로필 진입 시
            userMyProfileView.updateButton.setTitle("사용자 차단", for: .normal)
            userMyProfileView.updateButton.addTarget(self, action: #selector(banButtonButtoned), for: .touchUpInside)
        }
    }
    func setCustomBackButton() {
        if userUid == Auth.auth().currentUser?.uid {
            navigationController?.navigationBar.topItem?.title = "마이페이지"
            navigationController?.navigationBar.tintColor = .black
        }
    }
    
    func profileIsNil() {
        if DataManager.shared.profile?.nickName == nil {
            let userMyProfileUpdateVC = UserMyProfileUpdateViewController()
            userMyProfileUpdateVC.modalPresentationStyle = .currentContext
            present(userMyProfileUpdateVC, animated: true)
            return
        }
    }
    func dataSetting() {
        //자기가 들어오는 거면 싱글톤으로 보여주기
        if userUid == Auth.auth().currentUser?.uid {
            getBoardKeys{}
            DispatchQueue.main.async {
                guard let gymName = DataManager.shared.realGymInfo?.gymName else { return }
                guard let nickName = DataManager.shared.profile?.nickName else { return }
                guard let url = DataManager.shared.profile?.image else { return }
                self.userMyProfileView.dataSetting(gym: "\(gymName)", name: nickName, postCount: self.post.count,imageUrl: url)
            }
            self.getPost {
                self.userMyProfileView.postCountLabel.text = "작성한 글 \(self.post.count)개"
                self.userMyProfileView.postTableview.reloadData()
            }
        } else { // 다른 사람이 들어오는거면 싱글톤이 아닌 uid를 사용해 서버를 통해서 보여주기
            getProfile {
                self.getBoardKeys {
                }
                self.getGymName {
                    guard let url = self.url else { return }
                    self.userMyProfileView.dataSetting(gym: "\(self.gymName)", name: self.nickName, postCount: self.post.count, imageUrl: url)
                    self.getPost {
                        self.userMyProfileView.postCountLabel.text = "작성한 글 \(self.post.count)개"
                        self.userMyProfileView.postTableview.reloadData()
                    }
                }
            }
        }
    }
}

// MARK: - private extension data func logic

private extension UserMyProfileViewController {
    //쓰는 이유: 다른 사람이 다른 사람 프로필을 들어가면 userUid를 통해 프로필을 얻어야 함 -> 그리고 변수에 저장
    func getProfile(completion: @escaping () -> Void) {
        guard let userUid = self.userUid else {return}
        let ref = Database.database().reference().child("accounts").child("\(userUid)").child("profile")
        ref.observeSingleEvent(of: .value) { dataSnapshot in
            if let profileData = dataSnapshot.value as? [String: Any] {
                if let nickName = profileData["nickName"] as? String,
                   let imageUrlString = profileData["image"] as? String,
                   let imageUrl = URL(string: imageUrlString) {
                    self.nickName = nickName
                    self.url = imageUrl
                    completion()
                } else {
                    completion()
                }
            }
        }
    }
    // 포스트 얻기 위해 사용
    func getPost(completion: @escaping () -> Void) {
        self.post.removeAll()
        let ref = Database.database().reference().child("boards")
        let query = ref.queryOrdered(byChild: "uid").queryEqual(toValue: "\(userUid!)")
        query.observeSingleEvent(of: .value) { dataSnapshot in
            guard let value = dataSnapshot.value as? [String: [String: Any]] else { return }
            do {
                let jsonArray = value.values.compactMap { $0 as [String: Any] }
                let jsonData = try JSONSerialization.data(withJSONObject: jsonArray)
                let posts = try JSONDecoder().decode([Board].self, from: jsonData)
                self.post.append(contentsOf: posts)
                completion()
            } catch let error {
                print("테스트 - \(error)")
                completion()
            }
        }
    }
    
  
    func getGymName(completion: @escaping () -> Void) {
        let ref = Database.database().reference().child("accounts").child("\(userUid!)").child("adminUid")
        ref.observeSingleEvent(of: .value) { dataSnapshot in
            if let adminUid = dataSnapshot.value as? String {
                let gymRef = Database.database().reference().child("users").child("\(adminUid)").child("gymInfo/gymName")
                gymRef.observeSingleEvent(of: .value) { DataSnapshot in
                    if let gymName = DataSnapshot.value as? String {
                        self.gymName = gymName
                        completion()
                    }
                }
            }
        }
    }
    func getBoardKeys(completion: @escaping () -> Void) {
        self.keys.removeAll()
        let ref = Database.database().reference().child("boards")
        let query = ref.queryOrdered(byChild: "uid").queryEqual(toValue: "\(userUid!)").queryLimited(toLast: 500)
        query.observeSingleEvent(of: .value) { dataSnapshot, arg  in
            for childSnapshot in dataSnapshot.children {
                if let snapshot = childSnapshot as? DataSnapshot,
                   let key = snapshot.key as? String  {
                    self.keys.insert(key, at: 0)
                    completion()
                }
            }
        }
    }
}

// MARK: - extension @objc func

extension UserMyProfileViewController {
    
    @objc private func updateButtonButtoned() {
        let userMyProfileUpdateVC = UserMyProfileUpdateViewController()
        userMyProfileUpdateVC.modalPresentationStyle = .currentContext
        present(userMyProfileUpdateVC, animated: true)
    }
    @objc private func banButtonButtoned() {
        if userUid != Auth.auth().currentUser?.uid {
            let alert = UIAlertController(title: "차단", message: "사용자를 차단하시겠습니까?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default) { _ in
                self.block()
                self.userMyProfileView.updateButton.setTitle("차단됨", for: .normal)
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel) { cancelAction in
                print("취소")
            }
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func block() {
        let userRef = Database.database().reference().child("accounts/\(Auth.auth().currentUser!.uid)/blockedUserList")
        let blockedUserUid = userUid
        userRef.child("\(blockedUserUid!)").setValue(true)
    }
}

// MARK: - UITableViewDataSource

extension UserMyProfileViewController: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.post.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserMyProfileBoardTableViewCell.identifier, for: indexPath) as! UserMyProfileBoardTableViewCell
        
        cell.board = self.post.sorted(by: {$0.date > $1.date})[indexPath.section]
        cell.selectionStyle = .none
        return cell
    }

}


// MARK: - UITableViewDelegate

extension UserMyProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let boardDetailVC = BoardDetailViewController()
        boardDetailVC.boardUid = keys[indexPath.section]
        boardDetailVC.board = post.sorted(by: {$0.date > $1.date})[indexPath.section]
        navigationController?.pushViewController(boardDetailVC, animated: true)
    }    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.isUserInteractionEnabled = false
        header.backgroundColor = UIColor.clear
        header.frame.size.height = 1
        return header
    }
 }

