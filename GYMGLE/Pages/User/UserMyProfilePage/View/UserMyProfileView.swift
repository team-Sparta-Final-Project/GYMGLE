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
        image.image = UIImage(named: "person")
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
    
    lazy var postTableview: UITableView = {
        let table = UITableView()
        table.backgroundColor = ColorGuide.userBackGround
        table.translatesAutoresizingMaskIntoConstraints = false
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
    
}
