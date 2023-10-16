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
        let vc = UserRootViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
