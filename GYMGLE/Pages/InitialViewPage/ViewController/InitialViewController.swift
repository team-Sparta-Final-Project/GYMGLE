import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

class InitialViewController: UIViewController {
    
    private let initialView = InitialView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        view = initialView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLogin()
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

// MARK: - Login Check

private extension InitialViewController {
    func checkLogin() {
        if let currentUser = Auth.auth().currentUser {
            let userRef = Database.database().reference().child("users").child(currentUser.uid)
            
            userRef.observeSingleEvent(of: .value) { (snapshot) in
                if let userData = snapshot.value as? [String: Any],
                   let gymInfo = userData["gymInfo"] as? [String: Any],
                   let gymAccount = gymInfo["gymAccount"] as? [String: Any],
                   let accountType = gymAccount["accountType"] as? Int {
                    if accountType == 0 {
                        self.navigationController?.pushViewController(AdminRootViewController(), animated: true)
                    } 
//                    User.account.acccountType 으로 해야함
//                    else if accountType == 2 {
//                        self.navigationController?.pushViewController(TabbarViewController(), animated: true)
//                    }
                }
            }
        }
    }
}
