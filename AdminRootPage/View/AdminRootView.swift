//
//  AdminRootView.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/13.
//

import UIKit

final class AdminRootView: UIView {

    // MARK: - UIProperties

    
    private lazy var pageTitleLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size32Bold, textAligment: .center)
        return label
    }()
    
    private lazy var gymNameLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size14, textAligment: .center)
        return label
    }()
    
    private lazy var gymNumberLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size14, textAligment: .center)
        return label
    }()
    
    private lazy var gymLabelStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [gymNameLabel,gymNumberLabel])
        stack.spacing = 2
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var gymSettingButton: UIButton = {
        let button = UIButton()
        button.buttonMakeUI(backgroundColor: ColorGuide.main, cornerRadius: 10.0, borderWidth: 0.0, borderColor: UIColor
            .clear.cgColor, setTitle: "개인/보안", font: FontGuide.size16Bold, setTitleColor: UIColor.white)
        return button
    }()
    
    // 회원등록 버튼
    private lazy var gymUserRegisterButton: UIButton = {
        let button = UIButton()
        button.buttonMakeUI(backgroundColor: ColorGuide.main, cornerRadius: 10.0, borderWidth: 0.0, borderColor: UIColor
            .clear.cgColor, setTitle: "개인/보안", font: FontGuide.size16Bold, setTitleColor: UIColor.white)
        return button
    }()
    
    //회원관리 버튼
    private lazy var gymUserManageButton: UIButton = {
        let button = UIButton()
        button.buttonMakeUI(backgroundColor: ColorGuide.main, cornerRadius: 10.0, borderWidth: 0.0, borderColor: UIColor
            .clear.cgColor, setTitle: "개인/보안", font: FontGuide.size16Bold, setTitleColor: UIColor.white)
        return button
    }()
    
    //QR 스캐너 버튼
    private lazy var gymQRCodeButton: UIButton = {
        let button = UIButton()
        button.buttonMakeUI(backgroundColor: ColorGuide.main, cornerRadius: 10.0, borderWidth: 0.0, borderColor: UIColor
            .clear.cgColor, setTitle: "개인/보안", font: FontGuide.size16Bold, setTitleColor: UIColor.white)
        return button
    }()
    
    
    //공지사항 버튼
    private lazy var gymNoticeButton: UIButton = {
        let button = UIButton()
        button.buttonMakeUI(backgroundColor: ColorGuide.main, cornerRadius: 10.0, borderWidth: 0.0, borderColor: UIColor
            .clear.cgColor, setTitle: "개인/보안", font: FontGuide.size16Bold, setTitleColor: UIColor.white)
        return button
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
