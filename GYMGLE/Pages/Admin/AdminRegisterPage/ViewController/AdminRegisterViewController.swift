//
//  AdminRegisterViewController.swift
//  GYMGLE
//
//  Created by 조규연 on 10/13/23.
//

import UIKit
import Combine

class AdminRegisterViewController: UIViewController {
    
    // MARK: - Properties
    private let adminRegisterView = AdminRegisterView()
    private var isServiceCheck: Bool = false
    var viewModel: AdminRegisterViewModel = AdminRegisterViewModel()
    var disposableBag = Set<AnyCancellable>()
    var gymInfo: GymInfo?
    var parameters: [String: [String]] = [:]
    
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
        setBindings()
        
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
        adminRegisterView.checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
    }
    
    @objc func validCheckButtonTapped() {
        viewModel.numberDuplicateCheck(registerNumber: adminRegisterView.registerNumberTextField.text) { [weak self] isDuplicated in
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
                viewModel.voidCheck(textField: adminRegisterView.registerNumberTextField) {
                    let alert = UIAlertController(title: "경고",
                                                  message: "아무것도 입력하지 않았습니다. 다시 입력해주세요.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                parameters = ["b_no":[adminRegisterView.registerNumberTextField.text!]]
                self.viewModel.loadAPI(parameters: parameters) { [weak self] in
                    guard let self else { return }
                    DispatchQueue.main.async {
                        self.viewModel.validCheck { isValid in
                            if isValid {
                                let alert = UIAlertController(title: "사업자 등록번호 확인",
                                                              message: "유효한 사업자 등록번호입니다.",
                                                              preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                let alert = UIAlertController(title: "사업자 등록번호 확인",
                                                              message: "유효하지 않은 사업자 등록번호입니다. 다시 입력해주세요.",
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
    
    @objc func duplicationCheckButtonTapped() {
        viewModel.emailDuplicateCheck(email: adminRegisterView.idTextField.text!) { [weak self] isDuplicated in
            guard let self else { return }
            if isDuplicated {
                self.viewModel.isIdDuplicated = true
                let alert = UIAlertController(title: "아이디 중복확인",
                                              message: "중복된 아이디입니다. 다시 입력해주세요.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            } else {
                self.viewModel.isIdDuplicated = false
                viewModel.voidCheck(textField: adminRegisterView.idTextField, completion: {
                    let alert = UIAlertController(title: "경고",
                                                  message: "아무것도 입력하지 않았습니다. 다시 입력해주세요.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                })
                let alert = UIAlertController(title: "아이디 중복확인",
                                              message: "사용할 수 있는 아이디입니다.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func registerButtonTapped() {
        if !viewModel.isIdDuplicated && !viewModel.isNumberDuplicated && viewModel.isValid && viewModel.allValid && isServiceCheck {
            viewModel.createUser(id: adminRegisterView.idTextField.text!, pw: adminRegisterView.passwordTextField.text!, gymName: adminRegisterView.adminNameTextField.text!, gymPhoneNumber: adminRegisterView.phoneTextField.text!, gymNumber: adminRegisterView.registerNumberTextField.text!)
        }
        else if (self.adminRegisterView.adminNameTextField.text?.isEmpty != nil && self.adminRegisterView.phoneTextField.text?.isEmpty != nil && DataManager.shared.realGymInfo != nil) {
            viewModel.updatedAdminInfo(gymName: adminRegisterView.adminNameTextField.text ?? "", gymPhoneNumber: adminRegisterView.phoneTextField.text ?? "")
        }
        else {
            let alert = UIAlertController(title: "등록할 수 없습니다.",
                                          message: "올바르지 않은 정보가 있습니다. 다시 입력해주세요.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    @objc func checkButtonTapped(sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected == true {
            isServiceCheck = true
        } else {
            isServiceCheck = false
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
}

// MARK: - UITextFieldDelegate
extension AdminRegisterViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let registerButton = adminRegisterView.registerButton
        if let id = adminRegisterView.idTextField.text,
           let password = adminRegisterView.passwordTextField.text,
           let gymName = adminRegisterView.adminNameTextField.text,
           let gymPhoneNumber = adminRegisterView.phoneTextField.text,
           let gymNumber = adminRegisterView.registerNumberTextField.text {
            // 유효성 검사
            let isDataValid = id.count >= 1 && password.count >= 1 && gymName.count >= 1 && gymPhoneNumber.count == 13 && gymNumber.count == 10
            
            self.viewModel.checkID(id: id)
            self.viewModel.checkPW(pw: password)
            self.viewModel.checkAll()
            registerButton.isEnabled = isDataValid
            registerButton.backgroundColor = isDataValid ? ColorGuide.main : UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1)
        }
    }
}

// MARK: 뷰모델 관련
extension AdminRegisterViewController {
    fileprivate func setBindings() {
        self.viewModel.$gymInfo.sink { (gymInfo: GymInfo?) in
            self.gymInfo = gymInfo
            if self.gymInfo != nil {
                self.adminRegisterView.adminNameTextField.text = gymInfo?.gymName
                self.adminRegisterView.phoneTextField.text = gymInfo?.gymPhoneNumber
                self.adminRegisterView.registerNumberTextField.text = gymInfo?.gymnumber
                self.adminRegisterView.idTextField.text = gymInfo?.gymAccount.id
                self.adminRegisterView.passwordTextField.text = gymInfo?.gymAccount.password
                self.adminRegisterView.idTextField.isEnabled = false
                self.adminRegisterView.passwordTextField.isEnabled = false
                self.adminRegisterView.registerNumberTextField.isEnabled = false
                self.adminRegisterView.validCheckButton.isEnabled = false
                self.adminRegisterView.duplicationCheckButton.isEnabled = false
                self.adminRegisterView.checkButton.isEnabled = false
                self.adminRegisterView.registerButton.setTitle("수정", for: .normal)
            }
        }.store(in: &disposableBag)
    }
}
