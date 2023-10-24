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
        userMyPageView.tableView.myPageDelegate = self
    }
}

// MARK: - Actions

extension UserMyPageViewController: MyPageTableViewDelegate {
    
    func didSelectCell(at indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            // 이름을 선택한 경우
            break
        case 1:
            // 공지사항을 선택한 경우
            let vc = UINavigationController(rootViewController: AdminNoticeViewController())
            present(vc, animated: true)
            break
        case 2:
            // 로그아웃을 선택한 경우
            signOut()
            dismiss(animated: true) {
                let vc = InitialViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
            break
        case 3:
            // 탈퇴하기를 선택한 경우
            deleteAccount()
            break
        default:
            break
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
                    self.signOut()
                    let vc = UINavigationController(rootViewController: InitialViewController())
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                    // 데이터베이스에서 삭제
                    let userRef = Database.database().reference().child("accounts").child(user.uid)
                    userRef.removeValue()
                }
            }
        } else {
            print("로그인 정보가 존재하지 않습니다.")
        }
    }
}
