//
//  AdminLoginViewController.swift
//  GYMGLE
//
//  Created by 조규연 on 10/13/23.
//

import UIKit

class AdminLoginViewController: UIViewController {
    
    private let adminLoginView = AdminLoginView()
    
    override func loadView() {
        view = adminLoginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addButtonMethod()
        configureNav()
    }
    
    override func viewWillAppear(_ animated: Bool) { // 네비게이션바 숨기기
        navigationController?.navigationBar.isHidden = true
    }

}

// MARK: - Configure

private extension AdminLoginViewController {
    func configureNav() {
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - Actions

private extension AdminLoginViewController {
    func addButtonMethod() {
        adminLoginView.userButton.addTarget(self, action: #selector(userButtonTapped), for: .touchUpInside)
        adminLoginView.registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        adminLoginView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc func userButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func registerButtonTapped() {
        let vc = AdminRegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func loginButtonTapped() {
        let vc = AdminRootViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
