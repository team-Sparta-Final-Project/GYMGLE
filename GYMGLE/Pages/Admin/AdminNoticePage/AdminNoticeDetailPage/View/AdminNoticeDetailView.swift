//
//  AdminNoticeDetailView.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/14.
//

import UIKit
import Then
import SnapKit

final class AdminNoticeDetailView: UIView {
    // MARK: - UI Properties
    private lazy var pageTitleLabel = UILabel().then {
        $0.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size36Bold, textAligment: .center)
        $0.text = "내용"
    }
    
    lazy var deletedButton = UIButton().then {
        $0.buttonMakeUI(backgroundColor: ColorGuide.main, cornerRadius: 10, borderWidth: 0.0, borderColor: UIColor.clear.cgColor, setTitle: "삭제", font: FontGuide.size19, setTitleColor: .white)
    }
    
    lazy var contentTextView = UITextView().then {
        $0.text = "500자 이내로 공지사항을 적어주세요!"
        $0.font = FontGuide.size16
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 30
        $0.textContainerInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
    }
    
    lazy var contentNumberLabel = UILabel().then {
        $0.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size16, textAligment: .center)
        $0.text = "\(contentTextView.text.count)/500"
    }
    
    lazy var createButton = UIButton().then {
        $0.buttonMakeUI(backgroundColor: ColorGuide.main, cornerRadius: 10.0, borderWidth: 0.0, borderColor: UIColor
            .clear.cgColor, setTitle: "등록하기", font: FontGuide.size19Bold, setTitleColor: UIColor.white)
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = ColorGuide.background
        viewMakeUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - extension
private extension AdminNoticeDetailView {
    func viewMakeUI() {
        addSubviews(pageTitleLabel, deletedButton, contentTextView, contentNumberLabel,createButton)
        
        //pageTitleLabel
        pageTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(28)
            make.bottom.equalTo(contentTextView.snp.top).offset(-20)
            make.top.equalToSuperview().inset(120)
        }
        
        //deletedButton
        deletedButton.snp.makeConstraints { make in
            make.centerY.equalTo(pageTitleLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(28)
            make.leading.equalToSuperview().inset(300)
        }
        
        //contentTextView
        contentTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(22)
            make.trailing.equalToSuperview().inset(22)
        }
        
        //contentNumberLabel
        contentNumberLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(36)
            make.top.equalTo(contentTextView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(240)
        }
        
        //createButton
        createButton.snp.makeConstraints{ make in
            make.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-16)
            make.left.equalTo(self.snp.left).offset(22)
            make.right.equalTo(self.snp.right).offset(-22)
            make.height.equalTo(48)
        }
    }
}
