//
//  UserMyProfileView.swift
//  GYMGLE
//
//  Created by 박성원 on 10/31/23.
//

import UIKit
import FirebaseStorage

final class UserMyProfileView: UIView {

    // MARK: - UIProperties
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorGuide.background
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var profileImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var gymName: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size14, textAligment: .center)
        return label
    }()
    
    private lazy var nickName: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size19Bold, textAligment: .center)
        return label
    }()
    
    lazy var postCountLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.textHint, font: FontGuide.size14, textAligment: .center)
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [gymName, nickName])
        stack.spacing = 2
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var postTableview: UITableView = {
        let table = UITableView()
        table.backgroundColor = ColorGuide.userBackGround
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    lazy var updateButton: UIButton = {
        let button = UIButton()
        button.buttonMakeUI(backgroundColor: ColorGuide.profileButton, cornerRadius: 8, borderWidth: 0.0, borderColor: UIColor.clear.cgColor, setTitle: "프로필 수정", font: FontGuide.size19, setTitleColor: ColorGuide.profileButtonLabel)
        return button
    }()
    
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
        self.addSubviews(containerView)
        containerView.addSubview(profileImageView)
        containerView.addSubview(labelStackView)
        containerView.addSubview(updateButton)
        containerView.addSubview(postCountLabel)
        containerView.addSubview(postTableview)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 180),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            
            profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -50),
            profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 90),
            profileImageView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
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
