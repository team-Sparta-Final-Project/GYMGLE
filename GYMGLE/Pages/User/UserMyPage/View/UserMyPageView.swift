//
//  UserMyPageView.swift
//  GYMGLE
//
//  Created by 조규연 on 10/18/23.
//

import UIKit

class UserMyPageView: UIView {
    
    // MARK: - Properties
    
    lazy var profileImage = UIImageView().then {
        $0.image = UIImage(systemName: "person.fill")
        $0.layer.cornerRadius = $0.bounds.width / 2
        $0.layer.masksToBounds = true
    }
    
    lazy var nameLabel = UILabel().then {
        $0.font = FontGuide.size16Bold
        $0.text = "조규연"
    }
    
    lazy var descriptionLabel = UILabel().then {
        $0.font = FontGuide.size16
        $0.text = "안녕하세요. 잘부탁드립니다."
    }
    
    lazy var logOutButton = UIButton.GYMGLEButtonPreset("로그아웃")
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = ColorGuide.background
        
        addSubviews(profileImage, nameLabel, descriptionLabel, logOutButton)
        
        profileImage.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.3)
            $0.height.equalTo(profileImage.snp.width)
            $0.top.equalToSuperview().offset(88)
            $0.left.equalToSuperview().offset(28)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.top).offset(20)
            $0.left.equalTo(profileImage.snp.right).offset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
            $0.left.equalTo(nameLabel.snp.left)
        }
        
        logOutButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-100)
            $0.left.right.equalToSuperview().inset(28)
            $0.height.equalTo(44)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
