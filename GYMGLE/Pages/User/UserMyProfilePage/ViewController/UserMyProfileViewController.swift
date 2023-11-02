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
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
        self.userMyProfileView.postTableview.reloadData()
        
        getProfile() {
            self.downloadImage(imageView: self.userMyProfileView.profileImageView)
            self.userMyProfileView.nickName.text = DataManager.shared.profile?.nickName
            print("프로필: \(DataManager.shared.profile!)")
        }
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
    func getProfile(completion: @escaping () -> Void) {
        let ref = Database.database().reference().child("profiles")
        let query = ref.queryOrdered(byChild: "profile/nickName").queryEqual(toValue: "\(userMyProfileView.nickName.text!)")
        query.observeSingleEvent(of: .value) { dataSnapshot in
            if let profileData = dataSnapshot.value as? [String: Any] {
                if let nickName = profileData["nickName"] as? String,
                   let imageUrlString = profileData["image"] as? String,
                   let imageUrl = URL(string: imageUrlString) {
                    DataManager.shared.profile = Profile(image: imageUrl, nickName: nickName)
                    
                }
            }
        }
        completion()
    }
    func downloadImage(imageView: UIImageView) {
        guard let url = DataManager.shared.profile?.image else  {return}
        Storage.storage().reference(forURL: "\(url)").downloadURL { url, error  in
            URLSession.shared.dataTask(with: url!) { data, response, error in
                 if let error = error {
                     print("오류 - \(error.localizedDescription)")
                     return
                 }
                 if let data = data, let image = UIImage(data: data) {
                     DispatchQueue.main.async {
                         imageView.image = image
                     }
                 }
             }.resume()
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
