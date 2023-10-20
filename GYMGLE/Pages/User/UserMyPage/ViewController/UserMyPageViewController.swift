//
//  UserMyPageViewController.swift
//  GYMGLE
//
//  Created by 조규연 on 10/18/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

class UserMyPageViewController: UIViewController {
    
    // MARK: - Properties
    
    private let userMyPageView = UserMyPageView()
    
    // MARK: - LifeCycles
    
    override func loadView() {
        view = userMyPageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton()
    }
}

// MARK: - Actions

private extension UserMyPageViewController {
    
    func addButton() {
        userMyPageView.logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
    }
    
    @objc func logOutButtonTapped() {
        signOut()
        dismiss(animated: true) {
            let vc = InitialViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
}

// MARK: - Firebase Auth

extension UserMyPageViewController {
    
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
            let userRef = Database.database().reference().child("accounts").child(user.uid)
            userRef.removeValue()
            signOut()
        } else {
            print("로그인 정보가 존재하지 않습니다.")
        }
    }
}
