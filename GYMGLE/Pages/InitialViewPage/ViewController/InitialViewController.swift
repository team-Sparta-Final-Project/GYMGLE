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
        signIn()
    }
}

// MARK: - Login Check

private extension InitialViewController {
    func checkLogin() {
        if let currentUser = Auth.auth().currentUser {
            let userRef = Database.database().reference().child("users").child(currentUser.uid)
            let userRef2 = Database.database().reference().child("accounts").child(currentUser.uid)
            
            userRef.observeSingleEvent(of: .value) { (snapshot) in
                if let userData = snapshot.value as? [String: Any],
                   let gymInfo = userData["gymInfo"] as? [String: Any],
                   let gymAccount = gymInfo["gymAccount"] as? [String: Any],
                   let accountType = gymAccount["accountType"] as? Int {
                    if accountType == 0 {
                        DataManager.shared.gymUid = currentUser.uid
                        let vc = UINavigationController(rootViewController: AdminRootViewController())
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true)
                    }
                }
            }
            
            userRef2.observeSingleEvent(of: .value) { (snapshot) in
                if let userData = snapshot.value as? [String: Any],
                   let data = userData["userData"] as? [String: Any],
                   let account = data["account"] as? [String: Any],
                   let accountType = account["accountType"] as? Int {
                    // 트레이너 일때
                    if accountType == 1 {
                        let vc = TabbarViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true)
                        // 회원 일때
                    } else if accountType == 2 {
                        let vc = TabbarViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true)
                    }
                }
            }
        }
    }
}

// MARK: - Firebase Auth

extension InitialViewController {
    
    // MARK: - 로그인
    func signIn() {
        guard let id = initialView.idTextField.text else { return }
        guard let pw = initialView.passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: id, password: pw) { result, error in
            if let error = error {
                print(error)
                let alert = UIAlertController(title: "로그인 실패",
                                              message: "유효한 계정이 아닙니다.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                if let user = result?.user {
                    let userRef = Database.database().reference().child("accounts").child(user.uid)
                    
                    userRef.observeSingleEvent(of: .value) { (snapshot)  in
                        if let userData = snapshot.value as? [String: Any],
                           let data = userData["userData"] as? [String: Any],
                           let account = data["account"] as? [String: Any],
                           let accountType = account["accountType"] as? Int {
                            // 트레이너 일때
                            if accountType == 1 {
                                let vc = TabbarViewController()
                                vc.modalPresentationStyle = .fullScreen
                                self.present(vc, animated: true)
                                // 회원 일때
                            } else if accountType == 2 {
                                let vc = TabbarViewController()
                                vc.modalPresentationStyle = .fullScreen
                                self.present(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}
