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
    
    // MARK: - life cycle

    override func loadView() {
        view = userMyProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allSetting()
        if DataManager.shared.profile?.nickName == nil {
            let userMyProfileUpdateVC = UserMyProfileUpdateViewController()
            userMyProfileUpdateVC.modalPresentationStyle = .overCurrentContext
            present(userMyProfileUpdateVC, animated: true)
        }
        print("테스트 - \(userMyProfileView.nickName.text!)")
        getProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
        self.userMyProfileView.postTableview.reloadData()
    }
    
}

// MARK: - private extension custom func

private extension UserMyProfileViewController {
  
    func allSetting() {
        buttonTapped()
        setCustomBackButton()
        userMyProfileView.postTableview.dataSource = self
        userMyProfileView.postTableview.delegate = self
        userMyProfileView.postTableview.register(CommunityCell.self, forCellReuseIdentifier: "CommunityCell")
        //userMyProfileView.dataSetting(gym: <#T##String#>, nick: <#T##String#>, postCount: <#T##Int#>) ->❗️ 나중에 작성
    }
    
    func buttonTapped() {
        userMyProfileView.updateButton.addTarget(self, action: #selector(updateButtonButtoned), for: .touchUpInside)
        userMyProfileView.banButton.addTarget(self, action: #selector(banButtonButtoned), for: .touchUpInside)
    }
    
    func setCustomBackButton() {
        navigationController?.navigationBar.topItem?.title = "마이페이지"
        navigationController?.navigationBar.tintColor = .black
    }

//    let ref = Database.database().reference().child("profiles/\(Auth.auth().currentUser!.uid)/profile")
//    ref.observeSingleEvent(of: .value) { DataSnapshot in
//        guard let value = DataSnapshot.value as? [String: Any] else {
//            print("테스트 - 값")
//            return
//        }
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
//            let profile = try JSONDecoder().decode(Profile.self, from: jsonData)
//            print("테스트 - \(profile)")
//        } catch {
//            print("테스트 - error")
//        }
//    }
    func getProfile() {
        let ref = Database.database().reference().child("profiles")
        let query = ref.queryOrdered(byChild: "profile/nickName").queryEqual(toValue: "ddd")
        query.observeSingleEvent(of: .value) { dataSnapshot in
            if dataSnapshot.exists() {
                if let profileData = dataSnapshot.value as? [String: Any] {
                    do {
                        // JSON 데이터를 [Profile] 배열로 디코딩
                        let jsonData = try JSONSerialization.data(withJSONObject: profileData, options: [])
                        let profiles = try JSONDecoder().decode(Profile.self, from: jsonData)
                       
                        
                        print("테스트 - \(profiles)")
                    } catch {
                        print("테스트 - 오류: \(error)")
                    }
                } else {
                    print("테스트 - profileData를 딕셔너리로 변환하는 중 오류 발생")
                }
            } else {
                // 데이터가 존재하지 않는 경우
                print("테스트 - 데이터가 존재하지 않습니다.")
            }
        }
    }
}

// MARK: - extension @objc func

extension UserMyProfileViewController {
    
    @objc private func updateButtonButtoned() {
        let userMyProfileUpdateVC = UserMyProfileUpdateViewController()
        userMyProfileUpdateVC.modalPresentationStyle = .overCurrentContext
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
        return 10 //❗️
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
