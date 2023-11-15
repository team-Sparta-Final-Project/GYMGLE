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
        $0.text = ""
        $0.font = FontGuide.size36Bold
        $0.textColor = ColorGuide.black
    }
    
    lazy var adminNameTextField = UITextField().then {
        $0.borderStyle = .none
        $0.placeholder = "사업장 이름"
        $0.autocapitalizationType = .none // 자동으로 맨 앞을 대문자로 할건지
        $0.autocorrectionType = .no // 틀린글자 있을 때 자동으로 잡아 줄지
        $0.spellCheckingType = .no
        $0.font = FontGuide.size14
        
        let placeholderPadding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: $0.frame.height))
        $0.leftView = placeholderPadding
        $0.leftViewMode = .always
        $0.frame.size.width = 344.5
        $0.frame.size.height = 30
        $0.layer.addBorder([.bottom], color: .gray, width: 0.5)
    }
    
//    lazy var adminNumberTextField = UITextField().then {
//        $0.borderStyle = .none
//        $0.placeholder = "사업자 전화 번호"
//        $0.keyboardType = .numbersAndPunctuation
//        $0.font = FontGuide.size14
//        
//        let placeholderPadding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: $0.frame.height))
//        $0.leftView = placeholderPadding
//        $0.leftViewMode = .always
//        $0.frame.size.width = 344.5
//        $0.frame.size.height = 30
//        $0.layer.addBorder([.bottom], color: .gray, width: 0.5)
//    }
    
    lazy var phoneTextField = UITextField().then {
        $0.borderStyle = .none
        $0.placeholder = "핸드폰 번호 (ex. 010-xxxx-xxxx)"
        $0.keyboardType = .numbersAndPunctuation
        $0.font = FontGuide.size14
        
        let placeholderPadding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: $0.frame.height))
        $0.leftView = placeholderPadding
        $0.leftViewMode = .always
        $0.frame.size.width = 344.5
        $0.frame.size.height = 30
        $0.layer.addBorder([.bottom], color: .gray, width: 0.5)
    }
    
    lazy var registerNumberTextField = UITextField().then {
        $0.borderStyle = .none
        $0.placeholder = "사업자 등록 번호 (ex. xxxxxxxxxx)"
        $0.font = FontGuide.size14
        
        let placeholderPadding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: $0.frame.height))
        $0.leftView = placeholderPadding
        $0.leftViewMode = .always
        $0.frame.size.width = 344.5
        $0.frame.size.height = 30
        $0.layer.addBorder([.bottom], color: .gray, width: 0.5)
    }
    
    lazy var validCheckButton = UIButton().then {
        $0.buttonMakeUI(backgroundColor: .systemGray6, cornerRadius: 16, borderWidth: 0.5, borderColor: ColorGuide.shadowBorder.cgColor, setTitle: "확인", font: UIFont.systemFont(ofSize: 13), setTitleColor: ColorGuide.black)
    }
    
    lazy var idTextField = UITextField().then {
        $0.borderStyle = .none
        $0.placeholder = "아이디 (example@example.com)"
        $0.autocapitalizationType = .none // 자동으로 맨 앞을 대문자로 할건지
        $0.autocorrectionType = .no // 틀린글자 있을 때 자동으로 잡아 줄지
        $0.spellCheckingType = .no
        $0.font = FontGuide.size14
        
        let placeholderPadding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: $0.frame.height))
        $0.leftView = placeholderPadding
        $0.leftViewMode = .always
        $0.frame.size.width = 344.5
        $0.frame.size.height = 30
        $0.layer.addBorder([.bottom], color: .gray, width: 0.5)
    }
    
    lazy var duplicationCheckButton = UIButton().then {
        $0.buttonMakeUI(backgroundColor: .systemGray6, cornerRadius: 16, borderWidth: 0.5, borderColor: ColorGuide.shadowBorder.cgColor, setTitle: "중복확인", font: UIFont.systemFont(ofSize: 13), setTitleColor: ColorGuide.black)
    }
    
    lazy var passwordTextField = UITextField().then {
        $0.borderStyle = .none
        $0.placeholder = "비밀번호 (8~16자리 영문, 숫자, 특수문자 모두 포함)"
        $0.autocapitalizationType = .none // 자동으로 맨 앞을 대문자로 할건지
        $0.autocorrectionType = .no // 틀린글자 있을 때 자동으로 잡아 줄지
        $0.spellCheckingType = .no
        $0.font = FontGuide.size14
        
        let placeholderPadding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: $0.frame.height))
        $0.leftView = placeholderPadding
        $0.leftViewMode = .always
        $0.frame.size.width = 344.5
        $0.frame.size.height = 30
        $0.layer.addBorder([.bottom], color: .gray, width: 0.5)
    }
    
    lazy var checkButton = UIButton().then {
        $0.setImage(UIImage(systemName: "rectangle")?.resized(to: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.rectangle")?.resized(to: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate), for: .selected)
        $0.tintColor = ColorGuide.textHint
    }
    
    private lazy var loginServiceLabel = UILabel().then {
        $0.textColor = ColorGuide.black
        $0.font = FontGuide.size14
        $0.text = "귀하는 GYMGLE의 서비스 이용에 필요한 최소한의 개인정보 수집 및 이용에 동의하지 않을 수 있으나 동의를 거부할 경우 회원 서비스 이용이 불가합니다."
        $0.numberOfLines = 0
    }
    lazy var registerButton: UIButton = UIButton.GYMGLEButtonPreset("등록")

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = ColorGuide.background
        
        addSubviews(titleLabel, adminNameTextField, phoneTextField, registerNumberTextField, validCheckButton, idTextField, duplicationCheckButton, passwordTextField, registerButton, checkButton, loginServiceLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(88)
            $0.left.equalToSuperview().offset(22)
        }
        
        adminNameTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(44)
            $0.left.right.equalToSuperview().inset(24)
        }
        
//        adminNumberTextField.snp.makeConstraints {
//            $0.top.equalTo(adminNameTextField.snp.bottom).offset(52)
//            $0.left.right.equalToSuperview().inset(24)
//        }
        
        phoneTextField.snp.makeConstraints {
            $0.top.equalTo(adminNameTextField.snp.bottom).offset(52)
            $0.left.right.equalToSuperview().inset(24)
        }
        
        registerNumberTextField.snp.makeConstraints {
            $0.top.equalTo(phoneTextField.snp.bottom).offset(52)
            $0.left.right.equalToSuperview().inset(24)
        }
        
        validCheckButton.snp.makeConstraints {
            $0.centerY.equalTo(registerNumberTextField.snp.centerY)
            $0.right.equalToSuperview().offset(-24)
            $0.width.equalTo(54)
            $0.height.equalTo(32)
        }
        
        idTextField.snp.makeConstraints {
            $0.top.equalTo(registerNumberTextField.snp.bottom).offset(52)
            $0.left.right.equalToSuperview().inset(24)
        }
        
        duplicationCheckButton.snp.makeConstraints {
            $0.centerY.equalTo(idTextField.snp.centerY)
            $0.right.equalToSuperview().offset(-24)
            $0.width.equalTo(84)
            $0.height.equalTo(32)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(52)
            $0.left.right.equalToSuperview().inset(24)
        }
        
        registerButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-40)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        checkButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(24)
            $0.top.equalTo(passwordTextField.snp.bottom).offset(52)
        }
        
        loginServiceLabel.snp.makeConstraints {
            $0.left.equalTo(checkButton.snp.right).offset(8)
            $0.top.equalTo(checkButton.snp.top)
            $0.right.equalToSuperview().offset(-24)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
