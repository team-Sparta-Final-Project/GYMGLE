import UIKit
import Firebase

class InitialViewController: UIViewController {
    
    private let initialView = InitialView()
    private var viewModel: LoginViewModel!
    
    // MARK: - Life Cycles
    
    override func loadView() {
        view = initialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginViewModel()
        viewModel.delegate = self
        addButtonMethod()
        configureNav()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.checkLogin()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        initialView.endEditing(true)
    }
}

// MARK: - Configure

private extension InitialViewController {
    func configureNav() {
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - Actions

private extension InitialViewController {
    func addButtonMethod() {
        initialView.adminButton.addTarget(self, action: #selector(adminButtonTapped), for: .touchUpInside)
        initialView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc func adminButtonTapped() {
        let vc = AdminLoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func loginButtonTapped() {
        guard let id = initialView.idTextField.text, let pw = initialView.passwordTextField.text else { return }
        viewModel.signIn(id: id, password: pw)
    }
}

extension InitialViewController: LoginViewModelDelegate {
    func loginFailure() {
        let alert = UIAlertController(title: "로그인 실패",
                                      message: "유효한 계정이 아닙니다.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
}
