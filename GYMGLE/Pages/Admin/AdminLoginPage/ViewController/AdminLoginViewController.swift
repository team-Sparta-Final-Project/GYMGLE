//
//  AdminLoginViewController.swift
//  GYMGLE
//
//  Created by 조규연 on 10/13/23.
//

import UIKit
import Firebase

class AdminLoginViewController: UIViewController {
    
    private let adminLoginView = AdminLoginView()
    private var viewModel: LoginViewModel!
    
    override func loadView() {
        view = adminLoginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginViewModel()
        viewModel.delegate = self
        addButtonMethod()
        configureNav()
    }
    
    override func viewWillAppear(_ animated: Bool) { // 네비게이션바 숨기기
        navigationController?.navigationBar.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        adminLoginView.endEditing(true)
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
        guard let id = adminLoginView.idTextField.text else { return }
        guard let pw = adminLoginView.passwordTextField.text else { return }
        viewModel.AdminSignIn(id: id, password: pw)
    }
}

extension AdminLoginViewController: LoginViewModelDelegate {
    func tempLogin() {
        let alert = UIAlertController(title: "로그인 실패",
                                      message: "유효한 계정이 아닙니다.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        self.viewModel.signOut()
    }
    
    func adminLogin() {
        let vc = UINavigationController(rootViewController: AdminRootViewController())
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func userLogin() {
        let vc = TabbarViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func trainerLogin() {
        let adminRootVC = AdminRootViewController()
        adminRootVC.viewModel.isAdmin = false
        let vc = UINavigationController(rootViewController: adminRootVC)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func loginFailure() {
        let alert = UIAlertController(title: "로그인 실패",
                                      message: "유효한 계정이 아닙니다.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
