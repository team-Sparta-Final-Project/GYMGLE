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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userMyProfileView.postTableview.reloadData()
    }
    
}

// MARK: - private extension custom func

private extension UserMyProfileViewController {
  
    func allSetting() {
        buttonTapped()
        userMyProfileView.postTableview.dataSource = self
        userMyProfileView.postTableview.delegate = self
        userMyProfileView.postTableview.register(CommunityCell.self, forCellReuseIdentifier: "CommunityCell")
        //userMyProfileView.dataSetting(gym: <#T##String#>, nick: <#T##String#>, postCount: <#T##Int#>) ->❗️ 나중에 작성
    }
    
    func buttonTapped() {
        userMyProfileView.updateButton.addTarget(self, action: #selector(updateButtonButtoned), for: .touchUpInside)
        userMyProfileView.banButton.addTarget(self, action: #selector(banButtonButtoned), for: .touchUpInside)
    }
}

// MARK: - extension @objc func

extension UserMyProfileViewController {
    
    @objc private func updateButtonButtoned() {
        print("테스트 - click")
        let userMyProfileUpdateVC = UserMyProfileUpdateViewController()
        userMyProfileUpdateVC.modalPresentationStyle = .fullScreen
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
        return 0 //❗️
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
        
    }
}
