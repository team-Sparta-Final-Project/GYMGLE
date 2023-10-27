//
//  AdminRegisterViewController.swift
//  GYMGLE
//
//  Created by 조규연 on 10/13/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

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
        registerForKeyboardNotifications()
    }
    override func viewWillAppear(_ animated: Bool) { // 네비게이션바 보여주기
        navigationController?.navigationBar.isHidden = false
        setCustomBackButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        adminRegisterView.endEditing(true)
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
//        adminRegisterView.adminNumberTextField.delegate = self
        adminRegisterView.phoneTextField.delegate = self
        adminRegisterView.registerNumberTextField.delegate = self
    }
    
    func setCustomBackButton() {
        navigationController?.navigationBar.topItem?.title = "헬스장 등록"
        navigationController?.navigationBar.tintColor = .black
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
        numberDuplicateCheck() { [weak self] isDuplicated in
            guard let self else { return }
            
            if isDuplicated {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "사업자 등록 번호 중복확인",
                                                  message: "중복된 사업자 등록 번호입니다. 다시 입력해주세요.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                voidCheck(textField: adminRegisterView.registerNumberTextField)
                parameters = ["b_no":[adminRegisterView.registerNumberTextField.text!]]
                loadAPI(parameters: parameters) { [weak self] in
                    guard let self else { return }
                    DispatchQueue.main.async {
                        self.validCheck()
                    }
                }
            }
        }
    }
    
    @objc func duplicationCheckButtonTapped() {
        emailDuplicateCheck(email: adminRegisterView.idTextField.text!) { [weak self] isDuplicated in
            guard let self else { return }
            if isDuplicated {
                isIdDuplicated = true
                let alert = UIAlertController(title: "아이디 중복확인",
                                              message: "중복된 아이디입니다. 다시 입력해주세요.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            } else {
                isIdDuplicated = false
                voidCheck(textField: adminRegisterView.idTextField)
                let alert = UIAlertController(title: "아이디 중복확인",
                                              message: "사용할 수 있는 아이디입니다.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
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
    //키보드 올라오면 화면 올리기
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            let textFieldFrameInWindow = adminRegisterView.passwordTextField.convert(adminRegisterView.passwordTextField.bounds, to: nil)
            let maxY = textFieldFrameInWindow.maxY
            if maxY > (adminRegisterView.frame.size.height - keyboardHeight) {
                let scrollOffset = maxY - (adminRegisterView.frame.size.height - keyboardHeight)
                adminRegisterView.frame.origin.y = -scrollOffset - 20
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        adminRegisterView.frame.origin.y = 0
    }
    
    func numberDuplicateCheck(completion: @escaping (Bool) -> Void) {
        
        let ref = Database.database().reference().child("users")
        let target = adminRegisterView.registerNumberTextField.text
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? [String: Any] {
                for (_, userData) in data {
                    if let userDic = userData as? [String: Any],
                       let gymInfo = userDic["gymInfo"] as? [String: Any],
                       let gymNumber = gymInfo["gymnumber"] as? String {
                        if gymNumber == target {
                            completion(true)
                            return
                        }
                    }
                }
                completion(false)
            }
            
        }
    }
    
    func emailDuplicateCheck(email: String, completion: @escaping (Bool) -> Void) {
        let ref = Database.database().reference().child("accounts")

        // 해당 이메일 주소를 사용하는 사용자가 있는지 확인
        ref.queryOrdered(byChild: "account/id").queryEqual(toValue: email).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                // 이미 사용 중인 이메일 주소가 존재
                completion(true)
            } else {
                // 사용 가능한 이메일 주소
                completion(false)
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
    }
    
    func registerGym() {
        if let id = adminRegisterView.idTextField.text,
           let password = adminRegisterView.passwordTextField.text,
           let gymName = adminRegisterView.adminNameTextField.text,
           let gymPhoneNumber = adminRegisterView.phoneTextField.text,
           let gymNumber = adminRegisterView.registerNumberTextField.text {
            let account = Account(id: id, password: password, accountType: 0)
            let gymInfo = GymInfo(gymAccount: account, gymName: gymName, gymPhoneNumber: gymPhoneNumber, gymnumber: gymNumber)
            
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
//           let adminNumber = adminRegisterView.adminNumberTextField.text,
           let gymPhoneNumber = adminRegisterView.phoneTextField.text,
           let gymNumber = adminRegisterView.registerNumberTextField.text {
            // 유효성 검사
            let isDataValid = id.count >= 1 && password.count >= 1 && gymName.count >= 1 && gymPhoneNumber.count == 13 && gymNumber.count == 10
            
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
        guard let gymName = adminRegisterView.adminNameTextField.text else { return }
        guard let gymPhoneNumber = adminRegisterView.phoneTextField.text else { return }
        guard let gymNumber = adminRegisterView.registerNumberTextField.text else { return }
        let gymInfo = GymInfo(gymAccount: Account(id: id, password: pw, accountType: 0),
                              gymName: gymName,
                              gymPhoneNumber: gymPhoneNumber,
                              gymnumber: gymNumber)
        let gymUserList = User(account: Account(id: "default",
                                                 password: "default",
                                                 accountType: 2),
                                name: "default",
                                number: "default",
                                startSubscriptionDate: Date(),
                                endSubscriptionDate: Date(),
                                userInfo: "default",
                                isInGym: false,
                                adminUid: "default")
        let noticeList = Notice(date: Date(), content: "default")
        let gymInAndOutLog = InAndOut(id: "default", inTime: Date(), outTime: Date(), sinceInAndOutTime: 0)
        Auth.auth().createUser(withEmail: id, password: pw) { result, error in
            if let error = error {
                print(error)
            } else {
                do {
                    let gymInfoData = try JSONEncoder().encode(gymInfo)
                    let gymInfoJSON = try JSONSerialization.jsonObject(with: gymInfoData, options: [])
                    
                    let noticeListData = try JSONEncoder().encode(noticeList)
                    let noticeListJSON = try JSONSerialization.jsonObject(with: noticeListData, options: [])

                    let gymInAndOutLogData = try JSONEncoder().encode(gymInAndOutLog)
                    let gymInAndOutLogJSON = try JSONSerialization.jsonObject(with: gymInAndOutLogData, options: [])

                    
                    if let user = result?.user {
                        let userRef = Database.database().reference().child("users").child(user.uid)
                        userRef.child("gymInfo").setValue(gymInfoJSON)
                        userRef.child("noticeList").childByAutoId().setValue(noticeListJSON)
                        userRef.child("gymInAndOutLog").childByAutoId().setValue(gymInAndOutLogJSON)
                    }
                    
                    let vc = AdminLoginViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                } catch {
                    print("JSON 인코딩 에러")
                }
            }
        }
    }
    
}
