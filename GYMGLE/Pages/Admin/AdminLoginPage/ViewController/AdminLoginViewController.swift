//
//  AdminLoginViewController.swift
//  GYMGLE
//
//  Created by 조규연 on 10/13/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

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
        signIn()
    }
}

// MARK: - Firebase Auth

extension AdminLoginViewController {
    
    // MARK: - 로그인
    
    func signIn() {
        guard let id = adminLoginView.idTextField.text else { return }
        guard let pw = adminLoginView.passwordTextField.text else { return }
        

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
                    let userRef = Database.database().reference().child("users").child(user.uid)
                    
                    userRef.observeSingleEvent(of: .value) { (snapshot)  in
                        if let userData = snapshot.value as? [String: Any],
                           let gymInfoJSON = userData["gymInfo"] as? [String: Any] {
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
                        }
                        
                        let vc = UINavigationController(rootViewController: AdminRootViewController())
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true)
                        DataManager.shared.gymUid = user.uid
                    }
                }
            }
        }
    }
}
