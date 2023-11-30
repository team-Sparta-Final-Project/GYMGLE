//
//  UserMyProfileView.swift
//  GYMGLE
//
//  Created by 박성원 on 10/31/23.
//

import UIKit
import Then
import SnapKit
import Kingfisher

final class UserMyProfileView: UIView {

    // MARK: - UIProperties
    private lazy var containerView = UIView().then {
        $0.backgroundColor = ColorGuide.background
    }
    
    private lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private lazy var gymName = UILabel().then {
        $0.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size14, textAligment: .center)
    }
    
    private lazy var nickName = UILabel().then {
        $0.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size19Bold, textAligment: .center)
    }
    
    lazy var postCountLabel = UILabel().then {
        $0.labelMakeUI(textColor: ColorGuide.textHint, font: FontGuide.size14, textAligment: .center)
    }
    
    private lazy var labelStackView = UIStackView().then {
        $0.spacing = 2
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    lazy var postTableview = UITableView().then {
        $0.backgroundColor = ColorGuide.userBackGround
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.sectionHeaderTopPadding = 0
    }
    
    lazy var updateButton = UIButton().then {
        $0.buttonMakeUI(backgroundColor: ColorGuide.profileButton, cornerRadius: 8, borderWidth: 0.0, borderColor: UIColor.clear.cgColor, setTitle: "프로필 수정", font: FontGuide.size19, setTitleColor: ColorGuide.profileButtonLabel)
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
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

private extension UserMyProfileView {
    
    func configureView() {
        containerViewSetting()
        self.backgroundColor = ColorGuide.profileBackground
    }
    
    func containerViewSetting() {
        [containerView, labelStackView, profileImageView, updateButton, postCountLabel, postTableview].forEach {
            addSubview($0)
        }
        
        [gymName, nickName].forEach {
            self.labelStackView.addArrangedSubview($0)
        }
        
        //containerView
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(180)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        //profileImageView
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerX.equalToSuperview()
            make.top.equalTo(containerView.snp.top).offset(-50)
        }
        
        //labelStackView
        labelStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.width.equalTo(240)
        }
        
        //updateButton
        updateButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(labelStackView.snp.bottom).offset(10)
        }
        
        //postCountLabel
        postCountLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(updateButton.snp.bottom).offset(30)
            make.bottom.equalTo(postTableview.snp.top)
        }
        
        //postTableview
        postTableview.snp.makeConstraints { make in
            make.leading.equalTo(containerView.snp.leading).offset(20)
            make.trailing.equalTo(containerView.snp.trailing).offset(-20)
            make.top.equalTo(postCountLabel.snp.bottom).offset(6)
            make.bottom.equalTo(containerView.snp.bottom)
        }
    }
}
// MARK: - extension custom func

extension UserMyProfileView {
    func dataSetting(gym: String, name: String) {
        gymName.text = gym
        nickName.text = name
    }
    func imageSetting(imageUrl: URL) {
        profileImageView.kf.setImage(with: imageUrl)
    }
}
