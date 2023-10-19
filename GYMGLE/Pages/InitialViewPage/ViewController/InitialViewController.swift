import UIKit

class InitialViewController: UIViewController {
    
    private let initialView = InitialView()
    
    override func loadView() {
        view = initialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButtonMethod()
        configureNav()
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
        let datatest = DataManager.shared
        
        for gymInfo in datatest.gymList {
            for user in gymInfo.gymUserList {
                if user.account.id == initialView.idTextField.text && user.account.password == initialView.passwordTextField.text {
                    LoginManager.updateLoginStatus(isLoggedIn: true, userType: .user)
                    let vc = TabbarViewController()
                    vc.user = user
                    vc.gymInfo = gymInfo
                    navigationController?.pushViewController(vc, animated: true)
                    return
                }
            }
        }
        
        let alert = UIAlertController(title: "로그인 실패",
                                      message: "유효한 계정이 아닙니다.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
