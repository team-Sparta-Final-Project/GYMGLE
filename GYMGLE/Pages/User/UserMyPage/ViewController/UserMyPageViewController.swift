//
//  UserMyPageViewController.swift
//  GYMGLE
//
//  Created by 조규연 on 10/18/23.
//

import UIKit
import Firebase
import SafariServices

class UserMyPageViewController: UIViewController {
    
    // MARK: - Properties
    
    private let userMyPageView = UserMyPageView()
    private var viewModel: LoginViewModel = LoginViewModel()
    
    // MARK: - LifeCycles
    
    override func loadView() {
        view = userMyPageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userMyPageView.tableView.myPageDelegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
        userMyPageView.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
    }
   
}

// MARK: - Actions

extension UserMyPageViewController: MyPageTableViewDelegate {
    
    func didSelectCell(at indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let userMyProfileVC = UserMyProfileViewController()
            userMyProfileVC.viewModel.userUid = Auth.auth().currentUser?.uid
            self.navigationController?.pushViewController(userMyProfileVC, animated: true)
            break
        case (0, 1):
            // 공지사항을 선택한 경우
            let adminNoticeVC = AdminNoticeViewController()
            adminNoticeVC.isAdmin = false
            let vc = UINavigationController(rootViewController: adminNoticeVC)
            present(vc, animated: true)
            break
        case (0, 2):
            // 로그아웃
            self.viewModel.signOut()
            dismiss(animated: true) {
                let vc = InitialViewController()
                vc.modalPresentationStyle = .fullScreen
                DataManager.shared.profile = nil
                self.present(vc, animated: true)
            }
            break
        case (0, 3):
            // 탈퇴하기
            let alert = UIAlertController(title: "탈퇴하기",
                                          message: "정말로 탈퇴하시겠습니까?",
                                          preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                self.viewModel.deleteAccount() {
                    let vc = UINavigationController(rootViewController: InitialViewController())
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            }))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            present(alert, animated: true, completion: nil)
            break
        case (1, 0):
            guard let appleUrl = URL(string: "https://difficult-shock-122.notion.site/e56d3be418464be0b3262bff1afaeaca?pvs=4")   else { return }
            let safariViewController = SFSafariViewController(url: appleUrl)
            safariViewController.delegate = self
            safariViewController.modalPresentationStyle = .fullScreen
            self.present(safariViewController, animated: true, completion: nil)
            break
        case (1, 1):
            guard let appleUrl = URL(string: "https://difficult-shock-122.notion.site/f5ff3433117749c5a8bdc527eff556d1")   else { return }
            let safariViewController = SFSafariViewController(url: appleUrl)
            safariViewController.delegate = self
            safariViewController.modalPresentationStyle = .fullScreen
            self.present(safariViewController, animated: true, completion: nil)
            break
        default:
            break
        }
    }
}

extension UserMyPageViewController: SFSafariViewControllerDelegate {}
