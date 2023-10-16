//
//  AdminRootViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/13.
//

import UIKit

final class AdminRootViewController: UIViewController {

    private let adminRootView = AdminRootView()
    
    // MARK: - life cycle

    override func loadView() {
        view = adminRootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allButtonTapped()
    }

}

// MARK: - extension
private extension AdminRootViewController {
    
    func allButtonTapped() {
        adminRootView.gymSettingButton.addTarget(self, action: #selector(gymSettingButtonTapped), for: .touchUpInside)
        adminRootView.gymUserRegisterButton.addTarget(self, action: #selector(gymUserRegisterButtonTapped), for: .touchUpInside)
        adminRootView.gymQRCodeButton.addTarget(self, action: #selector(gymQRCodeButtonTapped), for: .touchUpInside)
        adminRootView.gymNoticeButton.addTarget(self, action: #selector(gymNoticeButtonTapped), for: .touchUpInside)
        adminRootView.logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
    }
}

// MARK: - @objc func
extension AdminRootViewController {
    //개인/보안 버튼
    @objc private func gymSettingButtonTapped() {
        
    }
    //회원등록 버튼
    @objc private func gymUserRegisterButtonTapped() {
        
    }
    //회원 관리버튼
    @objc private func gymUserManageButtonTapped() {
        
    }
    //큐알코드 버튼
    @objc private func gymQRCodeButtonTapped() {
        
    }
    //공지사항 버튼
    @objc private func gymNoticeButtonTapped() {
        let adminNoticeVC = AdminNoticeViewController()
        self.navigationController?.pushViewController(adminNoticeVC, animated: true)
    }
    //로그아웃 버튼
    @objc private func logOutButtonTapped() {
        
    }
}
