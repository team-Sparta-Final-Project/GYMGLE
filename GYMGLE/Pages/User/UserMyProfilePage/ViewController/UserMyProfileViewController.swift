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
    var userUid: String? //❗️ 전페이지에서 uid를 받아와 이걸로 검색을 해 정보들을 가져와야 함⭐️⭐️⭐️⭐️⭐️
    var post: [Board] = [] // 셀 나타내기
    var nickName: String = ""
    var url: URL?
    
    // MARK: - life cycle

    override func loadView() {
        view = userMyProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
        allSetting()
    }
}

// MARK: - private extension custom func

private extension UserMyProfileViewController {
  
    func allSetting() {
        buttonTapped()
        setCustomBackButton()
        tableViewSetting()
        profileIsNil()
        buttonSetting()
        dataSetting()
    }
    
    func tableViewSetting() {
        userMyProfileView.postTableview.dataSource = self
        userMyProfileView.postTableview.delegate = self
        userMyProfileView.postTableview.register(CommunityCell.self, forCellReuseIdentifier: "CommunityCell")
    }
    
    func buttonTapped() {
        userMyProfileView.updateButton.addTarget(self, action: #selector(updateButtonButtoned), for: .touchUpInside)
        userMyProfileView.banButton.addTarget(self, action: #selector(banButtonButtoned), for: .touchUpInside)
    }
    func buttonSetting() {
        if userUid == Auth.auth().currentUser?.uid { // 내 프로필 진입 시
            userMyProfileView.banButton.isHidden = true
            userMyProfileView.updateButton.isHidden = false
        } else { //다른 사람 프로필 진입 시
            userMyProfileView.banButton.isHidden = false
            userMyProfileView.updateButton.isHidden = true
        }
    }
    func setCustomBackButton() {
        navigationController?.navigationBar.topItem?.title = "마이페이지"
        navigationController?.navigationBar.tintColor = .black
    }
    
    func profileIsNil() {
        if DataManager.shared.profile?.nickName == nil {
            let userMyProfileUpdateVC = UserMyProfileUpdateViewController()
            userMyProfileUpdateVC.modalPresentationStyle = .overFullScreen
            userMyProfileUpdateVC.delegate = self
            present(userMyProfileUpdateVC, animated: true)
            return
        }
    }
    func dataSetting() {
        //자기가 들어오는 거면 싱글톤으로 보여주기
        if userUid == Auth.auth().currentUser?.uid {
            guard let gymName = DataManager.shared.realGymInfo?.gymName else { return }
            guard let nickName = DataManager.shared.profile?.nickName else { return }
            guard let url = DataManager.shared.profile?.image else { return }
            userMyProfileView.dataSetting(gym: gymName, name: nickName, imageUrl: url)
            getPost {
                self.userMyProfileView.postCountLabel.text = "작성한 글 \(self.post.count)개"
                self.userMyProfileView.postTableview.reloadData()
            }
        } else { // 다른 사람이 들어오는거면 싱글톤이 아닌 uid를 사용해 서버를 통해서 보여주기
            getProfile {
                guard let gymName = DataManager.shared.realGymInfo?.gymName else { return }
                guard let url = self.url else { return }
                self.userMyProfileView.dataSetting(gym: gymName, name: self.nickName, imageUrl: url)
                self.getPost { 
                    self.userMyProfileView.postCountLabel.text = "작성한 글 \(self.post.count)개"
                    self.userMyProfileView.postTableview.reloadData()
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
}

// MARK: - extension @objc func

extension UserMyProfileViewController {
    
    @objc private func updateButtonButtoned() {
        let userMyProfileUpdateVC = UserMyProfileUpdateViewController()
        userMyProfileUpdateVC.delegate = self
        userMyProfileUpdateVC.modalPresentationStyle = .overFullScreen
        present(userMyProfileUpdateVC, animated: true)
    }
    @objc private func banButtonButtoned() {
            let alert = UIAlertController(title: "차단", message: "사용자를 차단하시겠습니까?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default) { okAction in
                print("확인")
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel) { cancelAction in
                print("취소")
            }
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension UserMyProfileViewController: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.post.count //❗️
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityCell", for: indexPath) as! CommunityCell
        
        
        cell.selectionStyle = .none
        return cell
    }
}



// MARK: - UITableViewDelegate

extension UserMyProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let boardDetailVC = BoardDetailViewController()
        navigationController?.pushViewController(boardDetailVC, animated: true)
    }
}

// MARK: - SendUpdatedDataProtocol

extension UserMyProfileViewController: SendUpdatedDataProtocol {
    func updatedProfileData(viewController: UserMyProfileUpdateViewController, updatedData: Profile) {
        guard let gymName = DataManager.shared.realGymInfo?.gymName else { return }
            self.userMyProfileView.dataSetting(gym: gymName, name: updatedData.nickName, postCount: self.post.count, imageUrl: updatedData.image)
        let newProfile = Profile(image: updatedData.image, nickName: updatedData.nickName)
        let ref = Database.database().reference().child("accounts/\(Auth.auth().currentUser!.uid)/profile")
        do {
            let profileData = try JSONEncoder().encode(newProfile)
            let profileJSON = try JSONSerialization.jsonObject(with: profileData, options: [])
            ref.setValue(profileJSON)
        } catch {
            print("테스트 - error")
        }
    }
}
