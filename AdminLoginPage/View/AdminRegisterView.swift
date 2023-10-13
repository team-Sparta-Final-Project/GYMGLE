//
//  AdminRegisterView.swift
//  GYMGLE
//
//  Created by 조규연 on 10/13/23.
//

import UIKit

class AdminRegisterView: UIView {
    
    // MARK: - Properties
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "헬스장 등록"
        $0.font = FontGuide.size32Bold
        $0.textColor = ColorGuide.black
    }
    
    private lazy var adminNameTextField = UITextField().then {
        $0.borderStyle = .none
        $0.placeholder = "사업장 이름"
        $0.font = FontGuide.size14
        
        let placeholderPadding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: $0.frame.height))
        $0.leftView = placeholderPadding
        $0.leftViewMode = .always
        $0.frame.size.width = 303
        $0.frame.size.height = 30
        $0.layer.addBorder([.bottom], color: .gray, width: 0.5)
    }
    
    private lazy var adminNumberTextField = UITextField().then {
        $0.borderStyle = .none
        $0.placeholder = "사업자 전화 번호"
        $0.font = FontGuide.size14
        
        let placeholderPadding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: $0.frame.height))
        $0.leftView = placeholderPadding
        $0.leftViewMode = .always
        $0.frame.size.width = 303
        $0.frame.size.height = 30
        $0.layer.addBorder([.bottom], color: .gray, width: 0.5)
    }
    
    private lazy var phoneTextField = UITextField().then {
        $0.borderStyle = .none
        $0.placeholder = "핸드폰 번호"
        $0.font = FontGuide.size14
        
        let placeholderPadding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: $0.frame.height))
        $0.leftView = placeholderPadding
        $0.leftViewMode = .always
        $0.frame.size.width = 303
        $0.frame.size.height = 30
        $0.layer.addBorder([.bottom], color: .gray, width: 0.5)
    }
    
    private lazy var registerNumberTextField = UITextField().then {
        $0.borderStyle = .none
        $0.placeholder = "사업자 등록 번호"
        $0.font = FontGuide.size14
        
        let placeholderPadding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: $0.frame.height))
        $0.leftView = placeholderPadding
        $0.leftViewMode = .always
        $0.frame.size.width = 303
        $0.frame.size.height = 30
        $0.layer.addBorder([.bottom], color: .gray, width: 0.5)
    }
    
    private lazy var validCheckButton = UIButton().then {
        $0.buttonMakeUI(backgroundColor: .white, cornerRadius: 16, borderWidth: 0.5, borderColor: ColorGuide.shadowBorder.cgColor, setTitle: "확인", font: FontGuide.size14, setTitleColor: ColorGuide.black)
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.25
        $0.layer.shadowRadius = 2.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    private lazy var idTextField = UITextField().then {
        $0.borderStyle = .none
        $0.placeholder = "아이디"
        $0.font = FontGuide.size14
        
        let placeholderPadding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: $0.frame.height))
        $0.leftView = placeholderPadding
        $0.leftViewMode = .always
        $0.frame.size.width = 303
        $0.frame.size.height = 30
        $0.layer.addBorder([.bottom], color: .gray, width: 0.5)
    }
    
    private lazy var duplicationCheckButton = UIButton().then {
        $0.buttonMakeUI(backgroundColor: .white, cornerRadius: 16, borderWidth: 0.5, borderColor: ColorGuide.shadowBorder.cgColor, setTitle: "중복확인", font: FontGuide.size14, setTitleColor: ColorGuide.black)
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.25
        $0.layer.shadowRadius = 2.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    private lazy var passwordTextField = UITextField().then {
        $0.borderStyle = .none
        $0.placeholder = "비밀번호"
        $0.font = FontGuide.size14
        
        let placeholderPadding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: $0.frame.height))
        $0.leftView = placeholderPadding
        $0.leftViewMode = .always
        $0.frame.size.width = 303
        $0.frame.size.height = 30
        $0.layer.addBorder([.bottom], color: .gray, width: 0.5)
    }
    
    private var registerButton: UIButton = UIButton.GYMGLEButtonPreset("등록")

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addSubviews(titleLabel, adminNameTextField, adminNumberTextField, phoneTextField, registerNumberTextField, validCheckButton, idTextField, duplicationCheckButton, passwordTextField, registerButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(140)
            $0.left.equalToSuperview().offset(40)
        }
        
        adminNameTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(44)
            $0.left.right.equalToSuperview().inset(45)
        }
        
        adminNumberTextField.snp.makeConstraints {
            $0.top.equalTo(adminNameTextField.snp.bottom).offset(52)
            $0.left.right.equalToSuperview().inset(45)
        }
        
        phoneTextField.snp.makeConstraints {
            $0.top.equalTo(adminNumberTextField.snp.bottom).offset(52)
            $0.left.right.equalToSuperview().inset(45)
        }
        
        registerNumberTextField.snp.makeConstraints {
            $0.top.equalTo(phoneTextField.snp.bottom).offset(52)
            $0.left.right.equalToSuperview().inset(45)
        }
        
        validCheckButton.snp.makeConstraints {
            $0.centerY.equalTo(registerNumberTextField.snp.centerY)
            $0.right.equalToSuperview().offset(-45)
            $0.width.equalTo(76)
            $0.height.equalTo(33)
        }
        
        idTextField.snp.makeConstraints {
            $0.top.equalTo(registerNumberTextField.snp.bottom).offset(52)
            $0.left.right.equalToSuperview().inset(45)
        }
        
        duplicationCheckButton.snp.makeConstraints {
            $0.centerY.equalTo(idTextField.snp.centerY)
            $0.right.equalToSuperview().offset(-45)
            $0.width.equalTo(76)
            $0.height.equalTo(33)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(52)
            $0.left.right.equalToSuperview().inset(45)
        }
        
        registerButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-80)
            $0.left.right.equalToSuperview().inset(116.5)
            $0.height.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
