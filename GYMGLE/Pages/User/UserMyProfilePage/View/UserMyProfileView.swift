//
//  UserMyProfileView.swift
//  GYMGLE
//
//  Created by 박성원 on 10/31/23.
//

import UIKit
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
        addSubviews(containerView)
        
        [containerView, labelStackView, updateButton, postCountLabel, postTableview].forEach {
            self.containerView.addSubview($0)
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
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(containerView.snp.top).offset(-50)
        }
        
        //labelStackView
        labelStackView.snp.makeConstraints { make in
            make.centerX.equalTo(containerView.snp.centerX)
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.width.equalTo(240)
        }
        NSLayoutConstraint.activate([
            labelStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0),
            labelStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            labelStackView.widthAnchor.constraint(equalToConstant: 240),
            
            updateButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            updateButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            updateButton.topAnchor.constraint(equalTo: self.labelStackView.bottomAnchor, constant: 10),
            
            postCountLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            postCountLabel.topAnchor.constraint(equalTo: self.updateButton.bottomAnchor, constant: 30),
            postCountLabel.bottomAnchor.constraint(equalTo: self.postTableview.topAnchor, constant: 0),
            
            postTableview.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            postTableview.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            postTableview.topAnchor.constraint(equalTo: postCountLabel.bottomAnchor, constant: 6),
            postTableview.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 180),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            
            profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -50),
            profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
// MARK: - extension custom func

extension UserMyProfileView {
    func dataSetting(gym: String, name: String, postCount: Int, imageUrl: URL) {
        gymName.text = gym
        nickName.text = name
        postCountLabel.text = "작성한 글 \(postCount)개"
        profileImageView.kf.setImage(with: imageUrl)
    }
}
