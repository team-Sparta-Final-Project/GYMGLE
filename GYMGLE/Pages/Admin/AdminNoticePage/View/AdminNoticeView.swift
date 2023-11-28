//
//  AdminNoticeView.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/14.
//

import UIKit
import SnapKit
import Then

final class AdminNoticeView: UIView {

    // MARK: - UI Properties
    private lazy var pageTitleLabel =  UILabel().then {
        $0.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size36Bold, textAligment: .center)
        $0.text = "공지사항"
    }
    
    lazy var noticeCreateButton =  UIButton().then {
        $0.buttonImageMakeUI(backgroundColor: .white, image: "pencil", color: ColorGuide.black, cornerRadius: 10, borderWidth: 2.0, borderColor: ColorGuide.shadowBorder.cgColor)
    }
    
    lazy var noticeTableView = UITableView().then {
        $0.backgroundColor = ColorGuide.background
        $0.sectionHeaderTopPadding = 0
        $0.separatorStyle = .none
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewMakeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - extension
private extension AdminNoticeView {
    func viewMakeUI() {

        addSubviews(pageTitleLabel,noticeCreateButton,noticeTableView)
        
        pageTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(22)
            make.top.equalToSuperview().inset(140)
        }
        
        noticeCreateButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(140)
            make.trailing.equalToSuperview().inset(22)
            make.height.equalTo(46)
            make.width.equalTo(46)
        }
        
        noticeTableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(22)
            make.trailing.equalToSuperview().inset(22)
            make.bottom.equalToSuperview().inset(0)
            make.top.equalTo(pageTitleLabel.snp.bottom).offset(40)
        }
    }
}
