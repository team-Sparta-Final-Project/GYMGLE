//
//  AdminRegisterViewController.swift
//  GYMGLE
//
//  Created by 조규연 on 10/13/23.
//

import UIKit

class AdminRegisterViewController: UIViewController {
    
    // MARK: - Properties
    private let adminRegisterView = AdminRegisterView()
    private var isIdDuplicated: Bool = false
    private var isNumberDuplicated: Bool = false
    let dataTest = DataTest.shared

    // MARK: - Life Cycle
    
    override func loadView() {
        view = adminRegisterView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addButtonMethod()
        configureNav()
        
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
}

// MARK: - Actions

private extension AdminRegisterViewController {
    func addButtonMethod() {
        adminRegisterView.validCheckButton.addTarget(self, action: #selector(validCheckButtonTapped), for: .touchUpInside)
        adminRegisterView.duplicationCheckButton.addTarget(self, action: #selector(duplicationCheckButtonTapped), for: .touchUpInside)
        adminRegisterView.registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    @objc func validCheckButtonTapped() {
        validCheck()
        let alert = UIAlertController(title: "사업자 등록 번호 중복확인",
                                      message: "중복되지 않는 사업자 등록 번호입니다.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
        isNumberDuplicated = false
    }
    
    @objc func duplicationCheckButtonTapped() {
        idDuplicationCheck()
        let alert = UIAlertController(title: "아이디 중복확인",
                                      message: "사용할 수 있는 아이디입니다.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
        isIdDuplicated = false
    }
    
    @objc func registerButtonTapped() {
        if !isIdDuplicated && !isNumberDuplicated {
            registerGym()
            let vc = AdminRootViewController()
            navigationController?.pushViewController(vc, animated: true)
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
    
    func validCheck() {
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
    
    func registerGym() {
        if let id = adminRegisterView.idTextField.text,
           let password = adminRegisterView.passwordTextField.text,
           let gymName = adminRegisterView.adminNameTextField.text,
           let gymPhoneNumber = adminRegisterView.adminNameTextField.text,
           let gymNumber = adminRegisterView.registerNumberTextField.text {
            let account = Account(id: id, password: password, accountType: 3)
            let gymInfo = GymInfo(gymAccount: account, gymName: gymName, gymPhoneNumber: gymPhoneNumber, gymnumber: gymNumber, gymUserList: [], noticeList: [], gymInAndOutLog: [])
            
            if id.count >= 1 && password.count >= 1 && gymName.count >= 1 && gymPhoneNumber.count >= 1 && gymNumber.count == 10 {
                dataTest.gymList.append(gymInfo)
                print(dataTest.gymList)
            } else {
                let alert = UIAlertController(title: "등록할 수 없습니다.",
                                              message: "올바르지 않은 정보가 있습니다. 다시 입력해주세요.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return
            }
        }
    }
}
