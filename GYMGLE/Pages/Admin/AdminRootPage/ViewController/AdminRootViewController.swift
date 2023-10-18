//
//  AdminRootViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/13.
//

import UIKit

final class AdminRootViewController: UIViewController {

    private let adminRootView = AdminRootView()
    private let DataManager = DataTest.shared
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
        if let adminLoginVC = self.navigationController?.viewControllers[1] {
            self.navigationController?.popToViewController(adminLoginVC, animated: true)
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
        DataManager.gymList.removeAll(where: {$0.gymAccount.id == gymInfo?.gymAccount.id})
        print(DataManager.gymList)
        if let adminLoginVC = self.navigationController?.viewControllers[1] {
            self.navigationController?.popToViewController(adminLoginVC, animated: true)
        }
    }
}
