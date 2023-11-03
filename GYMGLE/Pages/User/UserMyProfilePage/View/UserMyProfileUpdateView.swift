//
//  UserMyProfileUpdateView.swift
//  GYMGLE
//
//  Created by 박성원 on 10/31/23.
//

import UIKit

final class UserMyProfileUpdateView: UIView {

    
    // MARK: - UIProperties
    lazy var pageLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 수정"
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size19Bold, textAligment: .center)
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.buttonImageMakeUI(backgroundColor: UIColor.clear, image: "xmark", color: ColorGuide.black, cornerRadius: 0.0, borderWidth: 0.0, borderColor: UIColor.white.cgColor)
        return button
    }()
    
    lazy var successedButton: UIButton = {
        let button = UIButton()
        button.buttonMakeUI(backgroundColor: UIColor.clear, cornerRadius: 0.0, borderWidth: 0.0, borderColor: UIColor.clear.cgColor, setTitle: "완료", font: FontGuide.size19, setTitleColor: ColorGuide.black)
        return button
    }()
    
    private let dividerView: UIView = {
        let divider = UIView()
        divider.backgroundColor = ColorGuide.textHint.withAlphaComponent(0.5)
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    lazy var profileImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.fill")?.resized(to: CGSize(width: 100, height: 100))
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.tintColor = ColorGuide.main.withAlphaComponent(0.4)
        image.backgroundColor = ColorGuide.textHint.withAlphaComponent(0.4)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var imageButton: UIButton = {
        let button = UIButton()
        button.buttonImageMakeUI(image: "camera.circle.fill", color: ColorGuide.textHint)
        button.backgroundColor = ColorGuide.white
        button.layer.cornerRadius = 14
        button.layer.borderWidth = 0.2
        button.layer.borderColor = ColorGuide.textHint.cgColor
        return button
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size16Bold, textAligment: .left)
        return label
    }()
    
    lazy var nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 8.0
        textField.layer.borderColor = ColorGuide.textHint.cgColor
        textField.layer.borderWidth = 1.0
        textField.textColor = ColorGuide.black
        textField.placeholder = "닉네임을 입력해주세요."
        textField.autocapitalizationType = .none // 자동으로 맨 앞을 대문자로 할건지
        textField.autocorrectionType = .no // 틀린글자 있을 때 자동으로 잡아 줄지
        textField.spellCheckingType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var nickNameHintLabel: UILabel = {
        let label = UILabel()
        label.text = """
                     * 띄어쓰기 없이 한글, 영문, 숫자로 20자만 가능해요.
                    """
        label.numberOfLines = 2
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size14, textAligment: .left)
        return label
    }()
    

    
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuredView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
    }
}

// MARK: - extension custom func

private extension UserMyProfileUpdateView {
    
    func configuredView() {
        addLeftPadding()
        topViewSetting()
        middleViewSetting()
        self.backgroundColor = ColorGuide.userBackGround
        bottomViewSetting()
    }
    
    func topViewSetting() {
        let views = [backButton, pageLabel, successedButton, dividerView]
        for view in views { self.addSubview(view) }
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            backButton.centerYAnchor.constraint(equalTo: pageLabel.centerYAnchor, constant: 0),
            backButton.widthAnchor.constraint(equalToConstant: 60),
            backButton.heightAnchor.constraint(equalToConstant: 60),
            
            pageLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 70),
            pageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            
            successedButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            successedButton.centerYAnchor.constraint(equalTo: pageLabel.centerYAnchor, constant: 0),
            
            dividerView.heightAnchor.constraint(equalToConstant: 1.2),
            dividerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            dividerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            dividerView.topAnchor.constraint(equalTo: pageLabel.bottomAnchor, constant: 12)
        ])
    }
    
    func middleViewSetting() {
        let views = [profileImageView, imageButton]
        for view in views { self.addSubview(view) }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 40),
            profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            imageButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 4),
            imageButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -8),
        ])
    }
    
    func bottomViewSetting() {
        let views = [nickNameLabel, nickNameTextField, nickNameHintLabel]
        for view in views { self.addSubview(view) }
        
        NSLayoutConstraint.activate([
            nickNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40),
            nickNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            nickNameLabel.bottomAnchor.constraint(equalTo: nickNameTextField.topAnchor, constant: -10),

            nickNameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            nickNameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            nickNameTextField.heightAnchor.constraint(equalToConstant: 44),
            nickNameTextField.bottomAnchor.constraint(equalTo: nickNameHintLabel.topAnchor, constant: -10),

            nickNameHintLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            nickNameHintLabel.topAnchor.constraint(equalTo: nickNameTextField.bottomAnchor, constant: 10),
            
        ])
    }
    
    func addLeftPadding() {
        nickNameTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 12.0, height: 0.0))
        nickNameTextField.leftViewMode = .always
    }
}
