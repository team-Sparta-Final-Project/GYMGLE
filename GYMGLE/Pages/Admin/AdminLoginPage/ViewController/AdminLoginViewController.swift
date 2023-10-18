//
//  AdminLoginViewController.swift
//  GYMGLE
//
//  Created by 조규연 on 10/13/23.
//

import UIKit

class AdminLoginViewController: UIViewController {
    
    private let adminLoginView = AdminLoginView()
    let dataTest = DataManager.shared
    
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
        
        for gymInfo in dataTest.gymList {
            if gymInfo.gymAccount.id == adminLoginView.idTextField.text && gymInfo.gymAccount.password == adminLoginView.passwordTextField.text {
                let vc = AdminRootViewController()
                vc.gymInfo = gymInfo
                navigationController?.pushViewController(vc, animated: true)
                return
            }
        }
        
        let alert = UIAlertController(title: "로그인 실패",
                                      message: "유효한 계정이 아닙니다.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
