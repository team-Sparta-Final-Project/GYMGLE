//
//  AdminLoginView.swift
//  GYMGLE
//
//  Created by 조규연 on 10/13/23.
//

import UIKit

class AdminLoginView: UIView {
    
    // MARK: - Properties

    private lazy var imageView = UIImageView().then {
        $0.image = UIImage(named: "GYMGLE")
    }
    
    private lazy var loginLabel = UILabel().then {
        $0.textColor = ColorGuide.main
        $0.font = FontGuide.size19Bold
        $0.text = "관리자 로그인"
    }
    
    private lazy var idTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "아이디"
        $0.textAlignment = .center
        $0.font = FontGuide.size14
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.25
        $0.layer.shadowRadius = 2.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    private lazy var passwordTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "비밀번호"
        $0.textAlignment = .center
        $0.font = FontGuide.size14
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.25
        $0.layer.shadowRadius = 2.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    private lazy var loginButton = UIButton().then {
        $0.buttonMakeUI(backgroundColor: .white, cornerRadius: 10, borderWidth: 0.5, borderColor: ColorGuide.shadowBorder.cgColor, setTitle: "로그인", font: FontGuide.size14Bold, setTitleColor: ColorGuide.main)
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.25
        $0.layer.shadowRadius = 2.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    private lazy var divider = UIView().then {
        $0.backgroundColor = .gray
    }
    
    private lazy var registerButton = UIButton().then {
        $0.buttonMakeUI(backgroundColor: .white, cornerRadius: 10, borderWidth: 0, borderColor: UIColor.clear.cgColor, setTitle: "새로운 헬스장 등록", font: FontGuide.size14Bold, setTitleColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.61))
    }
    
    private lazy var userButton = UIButton().then {
        $0.buttonMakeUI(backgroundColor: .white, cornerRadius: 20, borderWidth: 0.5, borderColor: ColorGuide.shadowBorder.cgColor, setTitle: "회원모드", font: FontGuide.size14Bold, setTitleColor: ColorGuide.main)
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.25
        $0.layer.shadowRadius = 2.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.backgroundColor = .white
        
        addSubviews(imageView, loginLabel, idTextField, passwordTextField, loginButton, divider, registerButton, userButton)
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(220)
            $0.left.right.equalToSuperview().inset(124)
            $0.height.equalTo(30)
        }
        
        loginLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(62)
            $0.left.equalToSuperview().offset(50)
        }
        
        idTextField.snp.makeConstraints {
            $0.top.equalTo(loginLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(45)
            $0.height.equalTo(46)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(45)
            $0.height.equalTo(46)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(45)
            $0.height.equalTo(55)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(25)
            $0.left.right.equalToSuperview().inset(30)
            $0.height.equalTo(0.5)
        }
        
        registerButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(30)
            $0.left.right.equalToSuperview().inset(45)
            $0.height.equalTo(46)
        }
        
        userButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-60)
            $0.right.equalToSuperview().offset(-45)
            $0.width.equalTo(90)
            $0.height.equalTo(44)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
