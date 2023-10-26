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
                   let gymInfoJSON = userData["gymInfo"] as? [String: Any],
                   let gymAcoount = gymInfoJSON["gymAccount"] as? [String: Any],
                   let id = gymAcoount["id"] as? String,
                   let pw = gymAcoount["password"] as? String {
                    do {
                        let gymInfoData = try JSONSerialization.data(withJSONObject: gymInfoJSON, options: [])
                        let gymInfo = try JSONDecoder().decode(GymInfo.self, from: gymInfoData)
                        DataManager.shared.realGymInfo = gymInfo
                    } catch DecodingError.dataCorrupted(let context) {
                        print("Data corrupted: \(context.debugDescription)")
                    } catch DecodingError.keyNotFound(let key, let context) {
                        print("Key '\(key.stringValue)' not found: \(context.debugDescription)")
                    } catch DecodingError.valueNotFound(let type, let context) {
                        print("Value of type '\(type)' not found: \(context.debugDescription)")
                    } catch DecodingError.typeMismatch(let type, let context) {
                        print("Type mismatch for type '\(type)' : \(context.debugDescription)")
                    } catch {
                        print("Decoding error: \(error.localizedDescription)")
                    }
                    DataManager.shared.gymUid = currentUser.uid
                    DataManager.shared.id = id
                    DataManager.shared.pw = pw
                    let vc = UINavigationController(rootViewController: AdminRootViewController())
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            }
            
            userRef2.observeSingleEvent(of: .value) { (snapshot, _) in
                if let userData = snapshot.value as? [String: Any],
                   let adminUid = userData["adminUid"] as? String,
                   let account = userData["account"] as? [String: Any],
                   let accountType = account["accountType"] as? Int {
                    // 트레이너 일때
                    if accountType == 1 {
                        Database.database().reference().child("users").child(adminUid).observeSingleEvent(of: .value) { (snapshot) in
                            if let userData = snapshot.value as? [String: Any],
                               let gymInfoJSON = userData["gymInfo"] as? [String: Any],
                               let gymAcoount = gymInfoJSON["gymAccount"] as? [String: Any],
                               let id = gymAcoount["id"] as? String,
                               let pw = gymAcoount["password"] as? String {
                                do {
                                    let gymInfoData = try JSONSerialization.data(withJSONObject: gymInfoJSON, options: [])
                                    let gymInfo = try JSONDecoder().decode(GymInfo.self, from: gymInfoData)
                                    DataManager.shared.realGymInfo = gymInfo
                                } catch {
                                    print("Decoding error: \(error.localizedDescription)")
                                }
                                DataManager.shared.gymUid = currentUser.uid
                                DataManager.shared.id = id
                                DataManager.shared.pw = pw
                                let vc = UINavigationController(rootViewController: AdminRootViewController())
                                vc.modalPresentationStyle = .fullScreen
                                self.present(vc, animated: true)
                            }
                        }
                        // 회원 일때
                    } else if accountType == 2 {
                        do {
                            let userInfoData = try JSONSerialization.data(withJSONObject: userData, options: [])
                            let userInfo = try JSONDecoder().decode(User.self, from: userInfoData)
                            DataManager.shared.userInfo = userInfo
                        } catch DecodingError.dataCorrupted(let context) {
                            print("Data corrupted: \(context.debugDescription)")
                        } catch DecodingError.keyNotFound(let key, let context) {
                            print("Key '\(key.stringValue)' not found: \(context.debugDescription)")
                        } catch DecodingError.valueNotFound(let type, let context) {
                            print("Value of type '\(type)' not found: \(context.debugDescription)")
                        } catch DecodingError.typeMismatch(let type, let context) {
                            print("Type mismatch for type '\(type)' : \(context.debugDescription)")
                        } catch {
                            print("Decoding error: \(error.localizedDescription)")
                        }
                        DataManager.shared.gymUid = adminUid
                        self.getGymInfo() {
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
                    let userRef2 = Database.database().reference().child("users").child(user.uid)
                    
                    userRef.observeSingleEvent(of: .value) { (snapshot, _)  in
                        if let userData = snapshot.value as? [String: Any],
                           let adminUid = userData["adminUid"] as? String,
                           let account = userData["account"] as? [String: Any],
                           let accountType = account["accountType"] as? Int {
                            // 트레이너 일때
                            if accountType == 1 {
                                do {
                                    let userInfoData = try JSONSerialization.data(withJSONObject: userData, options: [])
                                    let userInfo = try JSONDecoder().decode(User.self, from: userInfoData)
                                    DataManager.shared.userInfo = userInfo
                                } catch {
                                    print("Decoding error: \(error.localizedDescription)")
                                }
                                DataManager.shared.gymUid = adminUid
                                self.getGymInfo() {
                                    let vc = TabbarViewController()
                                    vc.modalPresentationStyle = .fullScreen
                                    self.present(vc, animated: true)
                                }
                                // 회원 일때
                            } else if accountType == 2 {
                                do {
                                    let userInfoData = try JSONSerialization.data(withJSONObject: userData, options: [])
                                    let userInfo = try JSONDecoder().decode(User.self, from: userInfoData)
                                    DataManager.shared.userInfo = userInfo
                                } catch {
                                    print("Decoding error: \(error.localizedDescription)")
                                }
                                DataManager.shared.gymUid = adminUid
                                self.getGymInfo() {
                                    let vc = TabbarViewController()
                                    vc.modalPresentationStyle = .fullScreen
                                    self.present(vc, animated: true)
                                }
                            }
                        }
                    }
                    
                    userRef2.observeSingleEvent(of: .value) { (snapshot) in
                        if let userData = snapshot.value as? [String: Any],
                           let gymInfo = userData["gymInfo"] as? [String: Any],
                           let gymAccount = gymInfo["gymAccount"] as? [String: Any],
                           let accountType = gymAccount["accountType"] as? Int {
                            if accountType == 0 {
                                self.signOut()
                                let alert = UIAlertController(title: "로그인 실패",
                                                              message: "유효한 계정이 아닙니다.",
                                                              preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - 로그아웃
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

extension InitialViewController {
    // 헬스장 정보 가져오기
    func getGymInfo(completion: @escaping () -> Void) {
        let userRef = Database.database().reference().child("users").child(DataManager.shared.gymUid!)
        
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            if let userData = snapshot.value as? [String: Any],
               let gymInfoJSON = userData["gymInfo"] as? [String: Any] {
                do {
                    let gymInfoData = try JSONSerialization.data(withJSONObject: gymInfoJSON, options: [])
                    let gymInfo = try JSONDecoder().decode(GymInfo.self, from: gymInfoData)
                    DataManager.shared.realGymInfo = gymInfo
                    completion()
                } catch DecodingError.dataCorrupted(let context) {
                    print("Data corrupted: \(context.debugDescription)")
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key.stringValue)' not found: \(context.debugDescription)")
                } catch DecodingError.valueNotFound(let type, let context) {
                    print("Value of type '\(type)' not found: \(context.debugDescription)")
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type mismatch for type '\(type)' : \(context.debugDescription)")
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                }
            }
        }
    }
}
