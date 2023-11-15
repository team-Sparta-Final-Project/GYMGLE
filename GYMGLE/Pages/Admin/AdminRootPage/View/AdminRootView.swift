//
//  AdminRootView.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/13.
//
import UIKit
import SnapKit


final class AdminRootView: UIView {
    
    // MARK: - UIProperties
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isScrollEnabled = true
        scroll.showsVerticalScrollIndicator = false
        scroll.backgroundColor = ColorGuide.background
        scroll.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var pageTitleLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size36Bold, textAligment: .left)
        label.text = "헬스장 관리"
        return label
    }()
    private lazy var gymNameLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size16Bold, textAligment: .left)
        label.text = "JP 헬스장"
        return label
    }()
    private lazy var gymNumberLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size14, textAligment: .left)
        label.text = "010-0000-0000"
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
        button.buttonMakeUI(backgroundColor: .white, cornerRadius: 16, borderWidth: 0, borderColor: ColorGuide.textHint.cgColor, setTitle: "로그아웃", font: FontGuide.size16Bold, setTitleColor: ColorGuide.main)
        return button
    }()

    lazy var adminTableView = AdminTableView()
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        adminTableView.sectionHeaderTopPadding = 0
        viewMakeUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - custom func
    func dataSetting(_ gymName: String,_ gymNumber: String) {
        gymNameLabel.text = gymName
        gymNumberLabel.text = gymNumber
    }
}

// MARK: - extension
private extension AdminRootView {
    func viewMakeUI() {
        
        topMakeUI()
    }
    func topMakeUI() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let allView = [pageTitleLabel, gymLabelStackView, gymSettingButton, adminTableView]
        for view in allView {
            self.contentView.addSubview(view)
        }
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo:  self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: 0),
            contentView.heightAnchor.constraint(equalToConstant: 700),
            
            pageTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 22),
            pageTitleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 90),
            pageTitleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -22),
            
            gymLabelStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 22),
            gymLabelStackView.topAnchor.constraint(equalTo: self.pageTitleLabel.bottomAnchor, constant: 20),
            gymLabelStackView.trailingAnchor.constraint(equalTo: self.gymSettingButton.leadingAnchor, constant: 0),
            
            gymSettingButton.centerYAnchor.constraint(equalTo: self.gymLabelStackView.centerYAnchor),
            gymSettingButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -22),
            gymSettingButton.widthAnchor.constraint(equalToConstant: 85),
            gymSettingButton.heightAnchor.constraint(equalToConstant: 34)
        ])
        adminTableView.snp.makeConstraints {
            $0.top.equalTo(gymLabelStackView.snp.bottom).offset(14)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(52*9 + 20)
        }
    }
   
}
