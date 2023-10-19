//
//  AdminRegisterViewController.swift
//  GYMGLE
//
//  Created by 조규연 on 10/13/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore

class AdminRegisterViewController: UIViewController {
    
    // MARK: - Properties
    private let adminRegisterView = AdminRegisterView()
    private var isIdDuplicated: Bool = false
    private var isNumberDuplicated: Bool = false
    private var isValid: Bool = false
    private var emailValid: Bool = false
    private var pwValid: Bool = false
    private var allValid: Bool = false
    
    let dataTest = DataManager.shared
    
    var parameters: [String: [String]] = [:]
    // 이메일 정규식: 알파벳과 숫자 중간에 @가 포함되며 끝 2~3자리 앞에 .이 포함
    let emailPattern = "^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\\.[a-zA-Z]{2,3}$"
    // 비밀번호 정규식: 8~16자리 알파벳, 영어, 특수문자가 포함
    let pwPattern = "^.*(?=^.{8,16}$)(?=.*\\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$"
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = adminRegisterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButtonMethod()
        configureNav()
        setRegisterButton()
        setTextField()
        
    }
    override func viewWillAppear(_ animated: Bool) { // 네비게이션바 보여주기
        navigationController?.navigationBar.isHidden = false
    }
}

// MARK: - Configure

private extension AdminRegisterViewController {
    func configureNav() {
        navigationController?.navigationBar.isHidden = true
    }
    
    func setRegisterButton() {
        let registerButton = adminRegisterView.registerButton
        registerButton.isEnabled = false
        registerButton.backgroundColor = UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1)
    }
    
    func setTextField() {
        adminRegisterView.idTextField.delegate = self
        adminRegisterView.passwordTextField.delegate = self
        adminRegisterView.adminNameTextField.delegate = self
        adminRegisterView.adminNumberTextField.delegate = self
        adminRegisterView.phoneTextField.delegate = self
        adminRegisterView.registerNumberTextField.delegate = self
    }
}

// MARK: - Actions

private extension AdminRegisterViewController {
    func addButtonMethod() {
        adminRegisterView.validCheckButton.addTarget(self, action: #selector(validCheckButtonTapped), for: .touchUpInside)
        adminRegisterView.duplicationCheckButton.addTarget(self, action: #selector(duplicationCheckButtonTapped), for: .touchUpInside)
        adminRegisterView.registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    @objc func validCheckButtonTapped() {
        numberDuplicateCheck()
        voidCheck(textField: adminRegisterView.registerNumberTextField)
        parameters = ["b_no":[adminRegisterView.registerNumberTextField.text!]]
        loadAPI(parameters: parameters) { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.validCheck()
                let alert = UIAlertController(title: "사업자 등록 번호 중복확인",
                                              message: "중복되지 않는 사업자 등록 번호입니다.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                self.isNumberDuplicated = false
            }
        }
    }
    
    @objc func duplicationCheckButtonTapped() {
        idDuplicationCheck()
        voidCheck(textField: adminRegisterView.idTextField)
        let alert = UIAlertController(title: "아이디 중복확인",
                                      message: "사용할 수 있는 아이디입니다.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
        isIdDuplicated = false
    }
    
    @objc func registerButtonTapped() {
        if !isIdDuplicated && !isNumberDuplicated && isValid && allValid {
            registerGym()
        } else {
            let alert = UIAlertController(title: "등록할 수 없습니다.",
                                          message: "올바르지 않은 정보가 있습니다. 다시 입력해주세요.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func idDuplicationCheck() {
        for gymInfo in dataTest.gymList {
            if gymInfo.gymAccount.id == adminRegisterView.idTextField.text {
                let alert = UIAlertController(title: "중복된 아이디",
                                              message: "중복된 아이디입니다. 다른 아이디를 입력해주세요.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                
                isIdDuplicated = true
                
                return
            }
        }
    }
    
    func numberDuplicateCheck() {
        for gymInfo in dataTest.gymList {
            if gymInfo.gymnumber == adminRegisterView.registerNumberTextField.text {
                let alert = UIAlertController(title: "사업자 등록 번호 중복",
                                              message: "사업자 등록 번호 중복입니다. 다시 입력해주세요.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                
                isNumberDuplicated = true
                
                return
            }
        }
    }
    
    func voidCheck(textField: UITextField) {
        if textField.text?.isEmpty == true {
            let alert = UIAlertController(title: "경고",
                                          message: "아무것도 입력하지 않았습니다. 다시 입력해주세요.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
    }
    
    func validCheck() {
        if isValid {
            let alert = UIAlertController(title: "사업자 등록번호 확인",
                                          message: "유효한 사업자 등록번호입니다.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "사업자 등록번호 확인",
                                          message: "유효하지 않은 사업자 등록번호입니다. 다시 입력해주세요.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        return
    }
    
    
    
    func registerGym() {
        if let id = adminRegisterView.idTextField.text,
           let password = adminRegisterView.passwordTextField.text,
           let gymName = adminRegisterView.adminNameTextField.text,
           let gymPhoneNumber = adminRegisterView.phoneTextField.text,
           let gymNumber = adminRegisterView.registerNumberTextField.text {
            let account = Account(id: id, password: password, accountType: 0)
            let gymInfo = GymInfo(gymAccount: account, gymName: gymName, gymPhoneNumber: gymPhoneNumber, gymnumber: gymNumber, gymUserList: [], noticeList: [], gymInAndOutLog: [])

            // 헬스장 추가
            dataTest.gymList.append(gymInfo)
            // 회원가입
            createUser()
        }
    }
}

// MARK: - 사업자등록번호 진위확인 API

extension AdminRegisterViewController {
    // 사업자 등록번호
    func loadAPI(parameters: [String: [String]], completion: @escaping () -> Void) {
        let url = URL(string: "https://api.odcloud.kr/api/nts-businessman/v1/status?serviceKey=%2BOc%2FfCL8SbceIGb1K%2FNBvoWNBA1SLS153VGLIDJIFQ3yt0m3Hui01FHuxVVSWZg8gDmPL8rhc1IIlvssUA7utw%3D%3D")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = jsonData
        // URLSession을 사용하여 요청 보내기
        URLSession.shared.dataTask(with: request) {[weak self] (data, response, error) in
            guard let self else { return }
          if let error = error {
            print("오류: \(error)")
          } else if let data = data {
            guard let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
              return
            }
            if let data = result["data"] as? [[String:String]],
              let b_stt_cd = data.first?["b_stt_cd"] {
              print("사업자유효:\(b_stt_cd)")
                if b_stt_cd == "01" {
                    self.isValid = true
                } else {
                    self.isValid = false
                }
              // if b_stt_cd = "01" 계속사업자
              // "02" 휴업자
              // "03" 폐업자
            }
          }
            completion()
        }
        .resume()
      }
}

// MARK: - UITextFieldDelegate

extension AdminRegisterViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let registerButton = adminRegisterView.registerButton
        if let id = adminRegisterView.idTextField.text,
           let password = adminRegisterView.passwordTextField.text,
           let gymName = adminRegisterView.adminNameTextField.text,
           let adminNumber = adminRegisterView.adminNumberTextField.text,
           let gymPhoneNumber = adminRegisterView.phoneTextField.text,
           let gymNumber = adminRegisterView.registerNumberTextField.text {
            // 유효성 검사
            let isDataValid = id.count >= 1 && password.count >= 1 && gymName.count >= 1 && adminNumber.count >= 1 && gymPhoneNumber.count == 13 && gymNumber.count == 10
            
            checkID()
            checkPW()
            checkAll()
            registerButton.isEnabled = isDataValid
            registerButton.backgroundColor = isDataValid ? ColorGuide.main : UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1)
        }
    }
}

// MARK: - Firebase Auth

extension AdminRegisterViewController {
    
    // MARK: - 이메일 비밀번호 정규식 체크

    func isValid(text: String, pattern: String) -> Bool {
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: text)
    }
    
    func checkID() {
        if isValid(text: adminRegisterView.idTextField.text!, pattern: emailPattern) {
            emailValid = true
        } else {
            emailValid = false
        }
    }
    
    func checkPW() {
        if isValid(text: adminRegisterView.passwordTextField.text!, pattern: pwPattern) {
            pwValid = true
        } else {
            pwValid = false
        }
    }
    
    func checkAll() {
        if emailValid && pwValid {
            allValid = true
        } else {
            allValid = false
        }
    }
    
    // MARK: - 회원가입
    
    func createUser() {
        guard let id = adminRegisterView.idTextField.text else { return }
        guard let pw = adminRegisterView.passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: id, password: pw) { result, error in
            if let error = error {
                print(error)
            }
            
            if let result = result {
                let vc = AdminLoginViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
