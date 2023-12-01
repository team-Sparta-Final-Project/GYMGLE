//
//  AdminRootView.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/13.
//
import UIKit
import SnapKit
import Then

final class AdminRootView: UIView {
    
    // MARK: - UIProperties
    
    private lazy var scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = ColorGuide.background
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private lazy var contentView = UIView()

    private lazy var pageTitleLabel = UILabel().then {
        $0.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size36Bold, textAligment: .left)
        $0.text = "헬스장 관리"
    }
    private lazy var gymNameLabel = UILabel().then {
        $0.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size16Bold, textAligment: .left)
        $0.text = "JP 헬스장"
    }
    private lazy var gymNumberLabel = UILabel().then {
        $0.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size14, textAligment: .left)
        $0.text = "010-0000-0000"
    }
    
    private lazy var gymLabelStackView = UIStackView().then {
        $0.spacing = 2
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    lazy var gymSettingButton = UIButton().then {
        $0.buttonMakeUI(backgroundColor: .white, cornerRadius: 16, borderWidth: 0, borderColor: ColorGuide.textHint.cgColor, setTitle: "로그아웃", font: FontGuide.size16Bold, setTitleColor: ColorGuide.main)
    }

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
        addSubviews(scrollView)
        scrollView.addSubview(contentView)
        
        [pageTitleLabel, gymLabelStackView, gymSettingButton, adminTableView].forEach {
            self.contentView.addSubview($0)
        }
        
        [gymNameLabel,gymNumberLabel].forEach {
            self.gymLabelStackView.addArrangedSubview($0)
        }
        
        //scrollView
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(0)
        }
        
        //contentView
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(scrollView)
        }
        
        //pageTitleLabel
        pageTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(22)
            make.top.equalTo(contentView.snp.top).offset(90)
            make.trailing.equalTo(contentView.snp.trailing).offset(-22)
        }
        
        //gymLabelStackView
        gymLabelStackView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(22)
            make.top.equalTo(pageTitleLabel.snp.bottom).offset(20)
            make.trailing.equalTo(gymSettingButton.snp.leading)
        }
        
        //gymSettingButton
        gymSettingButton.snp.makeConstraints { make in
            make.centerY.equalTo(gymLabelStackView.snp.centerY)
            make.trailing.equalTo(contentView.snp.trailing).offset(-22)
            make.height.equalTo(34)
            make.width.equalTo(85)
        }

        //adminTableView
        adminTableView.snp.makeConstraints { make in
            make.top.equalTo(gymLabelStackView.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(52*9 + 20)
        }
    }
}
