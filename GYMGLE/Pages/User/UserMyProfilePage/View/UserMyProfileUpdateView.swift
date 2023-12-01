//
//  UserMyProfileUpdateView.swift
//  GYMGLE
//
//  Created by 박성원 on 10/31/23.
//

import UIKit
import Then
import SnapKit

final class UserMyProfileUpdateView: UIView {

    // MARK: - UIProperties
    lazy var pageLabel = UILabel().then {
        $0.text = "프로필 수정"
        $0.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size19Bold, textAligment: .center)
    }
    
    lazy var backButton = UIButton().then {
        $0.buttonImageMakeUI(backgroundColor: UIColor.clear, image: "xmark", color: ColorGuide.black, cornerRadius: 0.0, borderWidth: 0.0, borderColor: UIColor.white.cgColor)
    }
    
    lazy var successedButton = UIButton().then {
        $0.buttonMakeUI(backgroundColor: UIColor.clear, cornerRadius: 0.0, borderWidth: 0.0, borderColor: UIColor.clear.cgColor, setTitle: "완료", font: FontGuide.size19, setTitleColor: ColorGuide.black)
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = ColorGuide.textHint.withAlphaComponent(0.5)
    }
    
    lazy var profileImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person.fill")?.resized(to: CGSize(width: 100, height: 100))
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.tintColor = ColorGuide.main.withAlphaComponent(0.4)
        $0.backgroundColor = ColorGuide.textHint.withAlphaComponent(0.4)
    }
    
    lazy var imageButton = UIButton().then {
        $0.buttonImageMakeUI(image: "camera.circle.fill", color: ColorGuide.textHint)
        $0.backgroundColor = ColorGuide.white
        $0.layer.cornerRadius = 14
        $0.layer.borderWidth = 0.2
        $0.layer.borderColor = ColorGuide.textHint.cgColor
    }
    
    private lazy var nickNameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size16Bold, textAligment: .left)
    }
    
    lazy var nickNameTextField = UITextField().then {
        $0.layer.cornerRadius = 8.0
        $0.layer.borderColor = ColorGuide.textHint.cgColor
        $0.layer.borderWidth = 1.0
        $0.textColor = ColorGuide.black
        $0.placeholder = "닉네임을 입력해주세요."
        $0.autocapitalizationType = .none // 자동으로 맨 앞을 대문자로 할건지
        $0.autocorrectionType = .no // 틀린글자 있을 때 자동으로 잡아 줄지
        $0.spellCheckingType = .no
    }

    private lazy var nickNameHintLabel = UILabel().then {
        $0.text = """
                     * 띄어쓰기 없이 한글, 영문, 숫자로 20자만 가능해요.
                    """
        $0.numberOfLines = 2
        $0.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size14, textAligment: .left)
    }
    
    lazy var activityIndicator = UIActivityIndicatorView().then {
        $0.color = ColorGuide.main
        $0.hidesWhenStopped = true
        $0.style = .large
        $0.stopAnimating()
    }
    
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
        bottomViewSetting()
        self.backgroundColor = ColorGuide.userBackGround
    }
    
    func topViewSetting() {
        addSubviews(backButton, pageLabel, successedButton, dividerView, activityIndicator)
        
        //backButton
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalTo(pageLabel.snp.centerY)
            make.width.height.equalTo(60)
        }
        //pageLabel
        pageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(70)
            make.centerX.equalToSuperview()
        }
        
        //successedButton
        successedButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.centerY.equalTo(pageLabel.snp.centerY)
        }
        
        //dividerView
        dividerView.snp.makeConstraints { make in
            make.height.equalTo(1.2)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(pageLabel.snp.bottom).offset(12)
        }
        
        //activityIndicator
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func middleViewSetting() {
        addSubviews(profileImageView, imageButton)
        
        //profileImageView
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(dividerView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        //imageButton
        imageButton.snp.makeConstraints { make in
            make.trailing.equalTo(profileImageView.snp.trailing).offset(4)
            make.bottom.equalTo(profileImageView.snp.bottom).offset(-8)
        }
    }
    
    func bottomViewSetting() {
        
        addSubviews(nickNameLabel, nickNameTextField, nickNameHintLabel)
        
        //nickNameLabel
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(32)
            make.bottom.equalTo(nickNameTextField.snp.top).offset(-10)
        }
        
        //nickNameTextField
        nickNameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.bottom.equalTo(nickNameHintLabel.snp.top).offset(-10)
            make.height.equalTo(44)
        }
        
        //nickNameHintLabel
        nickNameHintLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(32)
            make.top.equalTo(nickNameTextField.snp.bottom).offset(10)
        }
    }
    
    func addLeftPadding() {
        nickNameTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 12.0, height: 0.0))
        nickNameTextField.leftViewMode = .always
    }
}

// MARK: - extension func

extension UserMyProfileUpdateView {
    
    func dataSetting(nickName: String, imageUrl: URL) {
        profileImageView.kf.setImage(with: imageUrl)
        nickNameTextField.text = nickName
    }
    
    func profileImageViewSetting(image: UIImage) {
        profileImageView.image = image
    }
}
