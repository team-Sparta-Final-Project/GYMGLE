//
//  AdminRootViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/13.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

final class AdminRootViewController: UIViewController {

    private let adminRootView = AdminRootView()
    private let dataManager = DataManager.shared
    var gymInfo: GymInfo?
    // MARK: - life cycle

    override func loadView() {
        view = adminRootView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allButtonTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        adminRootView.dataSetting(gymInfo?.gymName ?? "", gymInfo?.gymPhoneNumber ?? "")
    }

}

// MARK: - extension
private extension AdminRootViewController {
    
    func allButtonTapped() {
        adminRootView.gymSettingButton.addTarget(self, action: #selector(gymSettingButtonTapped), for: .touchUpInside)
        adminRootView.gymUserRegisterButton.addTarget(self, action: #selector(gymUserRegisterButtonTapped), for: .touchUpInside)
        adminRootView.gymUserManageButton.addTarget(self, action: #selector(gymUserManageButtonTapped), for: .touchUpInside)
        adminRootView.gymQRCodeButton.addTarget(self, action: #selector(gymQRCodeButtonTapped), for: .touchUpInside)
        adminRootView.gymNoticeButton.addTarget(self, action: #selector(gymNoticeButtonTapped), for: .touchUpInside)
        adminRootView.logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
    }
}

// MARK: - @objc func
extension AdminRootViewController {
    //로그아웃 버튼
    @objc private func gymSettingButtonTapped() {
        signOut()
        let adminLoginVC = AdminLoginViewController()
        self.navigationController?.pushViewController(adminLoginVC, animated: true)
    }
    //회원등록 버튼
    @objc private func gymUserRegisterButtonTapped() {
        let userRegisterVC = UserRegisterViewController()
        self.navigationController?.pushViewController(userRegisterVC, animated: true)
    }
    //회원 관리버튼
    @objc private func gymUserManageButtonTapped() {
        let userManageVC = UserManageViewController()
        self.navigationController?.pushViewController(userManageVC, animated: true)
    }
    //큐알코드 버튼
    @objc private func gymQRCodeButtonTapped() {
        let adminNoticeVC = AdminNoticeViewController()
        self.navigationController?.pushViewController(adminNoticeVC, animated: true)
    }
    //공지사항 버튼
    @objc private func gymNoticeButtonTapped() {
        let adminNoticeVC = AdminNoticeViewController()
        adminNoticeVC.gymInfo = gymInfo
        self.navigationController?.pushViewController(adminNoticeVC, animated: true)
    }
    //탈퇴 버튼
    @objc private func logOutButtonTapped() {
//        dataManager.gymList.removeAll(where: {$0.gymAccount.id == gymInfo?.gymAccount.id})
        deleteAccount()
    }
}

// MARK: - Firebase Auth

extension AdminRootViewController {
    
    // MARK: - 로그아웃
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    // MARK: - 회원탈퇴
    
    func deleteAccount() {
        // 계정 삭제
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if let error = error {
                    print("delete Error : ", error)
                } else {
                    let adminLoginVC = AdminLoginViewController()
                    self.navigationController?.pushViewController(adminLoginVC, animated: true)
                }
            }
            // 데이터베이스에서 삭제
            let userRef = Database.database().reference().child("users").child(user.uid)
            userRef.removeValue()
        } else {
            print("로그인 정보가 존재하지 않습니다.")
        }
    }
}
