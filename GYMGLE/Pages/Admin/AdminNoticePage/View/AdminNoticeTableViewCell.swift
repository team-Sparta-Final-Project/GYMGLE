//
//  AdminNoticeTableViewCell.swift
//  GYMGLE
//
//  Created by 조규연 on 10/16/23.
//
import UIKit

final class AdminNoticeTableViewCell: UITableViewCell {
    
    static let identifier = "AdminNoticeTableViewCell"
    // MARK: - CellUIProperties
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size16, textAligment: .left)
        return label
    }()
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size16, textAligment: .center)
        return label
    }()
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size16, textAligment: .right)
        return label
    }()
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
        let views = [nameLabel, contentLabel, dateLabel]
        for view in views {
            self.contentView.addSubview(view)
        }
        NSLayoutConstraint.activate([
            //nameLabel
            nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 14),
            nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            
            //contentLabel
            contentLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 14),
            contentLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            contentLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 0),
            contentLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            
            //dateLabel
            dateLabel.topAnchor.constraint(equalTo: self.contentLabel.bottomAnchor, constant: 14),
            dateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -14),
        ])
    }
}
