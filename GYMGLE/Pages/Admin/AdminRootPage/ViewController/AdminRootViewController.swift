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
    // MARK: - properties
    
    private let adminRootView = AdminRootView()
    var isAdmin: Bool?
    var ref = Database.database().reference()
    
    // MARK: - life cycle
    
    override func loadView() {
        view = adminRootView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        allButtonTapped()
        fireBaseRead()
    }
    override func viewWillAppear(_ animated: Bool) {
        configuredView()
    }
}

// MARK: - extension
private extension AdminRootViewController {
    func configuredView() {
        navigationController?.navigationBar.isHidden = true
        deletedButtonHidden()
    }
    
    func fireBaseRead() {
        let gymName = DataManager.shared.realGymInfo?.gymName
        let gymPhoneNumber = DataManager.shared.realGymInfo?.gymPhoneNumber
        adminRootView.dataSetting("\(gymName!)", "\(gymPhoneNumber!)")
    }
    
    func allButtonTapped() {
        adminRootView.gymSettingButton.addTarget(self, action: #selector(gymSettingButtonTapped), for: .touchUpInside)
        adminRootView.gymUserRegisterButton.addTarget(self, action: #selector(gymUserRegisterButtonTapped), for: .touchUpInside)
        adminRootView.gymUserManageButton.addTarget(self, action: #selector(gymUserManageButtonTapped), for: .touchUpInside)
        adminRootView.gymQRCodeButton.addTarget(self, action: #selector(gymQRCodeButtonTapped), for: .touchUpInside)
        adminRootView.gymNoticeButton.addTarget(self, action: #selector(gymNoticeButtonTapped), for: .touchUpInside)
        adminRootView.logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
    }
    
    func deletedButtonHidden() {
        switch isAdmin {
        case false: //트레이너 일 때
            adminRootView.logOutButton.isHidden = true
        default:
            adminRootView.logOutButton.isHidden = false
        }
    }
}

// MARK: - @objc func
extension AdminRootViewController {
    //로그아웃 버튼
    @objc private func gymSettingButtonTapped() {
        signOut()
        dismiss(animated: true) {
            let vc = AdminLoginViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
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
        let qrcodeCheckVC = QRcodeCheckViewController()
        self.navigationController?.pushViewController(qrcodeCheckVC, animated: true)
    }
    //공지사항 버튼
    @objc private func gymNoticeButtonTapped() {
        let adminNoticeVC = AdminNoticeViewController()
        self.navigationController?.pushViewController(adminNoticeVC, animated: true)
    }
    //탈퇴 버튼
    @objc private func logOutButtonTapped() {
        deleteAccount()
        dismiss(animated: true) {
            let vc = AdminLoginViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
}

// MARK: - Firebase Auth
private extension AdminRootViewController {
    
    // MARK: - 로그아웃
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch _ as NSError { }
    }
    
    // MARK: - 회원탈퇴
    func deleteAccount() {
        // 계정 삭제
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if error != nil {
                } else {
                    let adminLoginVC = AdminLoginViewController()
                    self.navigationController?.pushViewController(adminLoginVC, animated: true)
                }
            }
            // 데이터베이스에서 삭제
            let userRef = Database.database().reference().child("users").child(user.uid)
            userRef.removeValue()
            signOut()
        } else {}
    }
}
