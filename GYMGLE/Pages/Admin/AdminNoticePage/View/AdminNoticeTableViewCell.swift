//
//  AdminNoticeTableViewCell.swift
//  GYMGLE
//
//  Created by 조규연 on 10/16/23.
//
import UIKit
import Then
import SnapKit

final class AdminNoticeTableViewCell: UITableViewCell {
    
    static let identifier = "AdminNoticeTableViewCell"
    // MARK: - CellUIProperties
    lazy var nameLabel = UILabel().then {
        $0.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size16, textAligment: .left)
    }
    lazy var contentLabel = UILabel().then {
        $0.numberOfLines = 3
        $0.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size16, textAligment: .center)
    }
    lazy var dateLabel = UILabel().then {
        $0.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size16, textAligment: .right)
    }
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        cellMakeUI()
        cellSetting()
       
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        contentLabel.text = nil
        dateLabel.text = nil
    }
}
// MARK: - extension
private extension AdminNoticeTableViewCell {
    
    func cellSetting() {
        self.layer.cornerRadius = 28
        self.backgroundColor = .white
        self.layer.shadowColor = ColorGuide.shadowBorder.withAlphaComponent(0.2).cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 1
    }
    
    func cellMakeUI() {
        [nameLabel, contentLabel, dateLabel].forEach {
            self.contentView.addSubview($0)
        }
        //nameLabel
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(14)
            make.trailing.equalToSuperview().inset(20)
        }
        //contentLabel
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(14)
            make.leading.equalToSuperview().inset(20)
            make.centerX.equalTo(self.contentView.snp.centerX)
            make.trailing.equalToSuperview().inset(20)
        }
        //dateLabel
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(14)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(14)
        }
    }
}
