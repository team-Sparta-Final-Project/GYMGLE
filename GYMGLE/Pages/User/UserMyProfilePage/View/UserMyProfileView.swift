//
//  UserMyProfileView.swift
//  GYMGLE
//
//  Created by 박성원 on 10/31/23.
//

import UIKit

final class UserMyProfileView: UIView {

    // MARK: - UIProperties
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorGuide.background
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "person")?.resized(to: CGSize(width: 80, height: 80)).withRenderingMode(.alwaysOriginal)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var gymName: UILabel = {
        let label = UILabel()
        label.text = "만나짐"
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size14, textAligment: .center)
        return label
    }()
    
    private lazy var nickName: UILabel = {
        let label = UILabel()
        label.text = "포메돈까스"
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size16Bold, textAligment: .center)
        return label
    }()
    
    private lazy var postCountLabel: UILabel = {
        let label = UILabel()
        label.text = "작성한 글 12개"
        label.labelMakeUI(textColor: ColorGuide.textHint, font: FontGuide.size14, textAligment: .center)
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [gymName, nickName, postCountLabel])
        stack.spacing = 10
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var postTableview: UITableView = {
        let table = UITableView()
        table.backgroundColor = ColorGuide.userBackGround
        table.translatesAutoresizingMaskIntoConstraints = false
        table.layer.borderWidth = 3.0
        table.layer.borderColor = ColorGuide.main.cgColor
        return table
    }()
    
    lazy var updateButton: UIButton = {
        let button = UIButton()
        button.buttonImageMakeUI(backgroundColor: ColorGuide.white, image: "pencil", color: ColorGuide.black, cornerRadius: 20, borderWidth: 0.0, borderColor: UIColor.white.cgColor)
        return button
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = ColorGuide.profileBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - extension custom func

private extension UserMyProfileView {
    
    func configureView() {
        let views = [containerView, profileImageView, updateButton]
        for view in views {
            self.addSubview(view)
        }
        
       
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 120),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            
            updateButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            updateButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            
            profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -44),
            profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        ])
    }
    
    func containerViewSetting() {
        containerView.addSubview(labelStackView)
        containerView.addSubview(postTableview)
        
        NSLayoutConstraint.activate([
            labelStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0),
            labelStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            labelStackView.widthAnchor.constraint(equalToConstant: 70),
            
            postTableview.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            postTableview.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            postTableview.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 20),
            postTableview.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
        ])
    }
}
