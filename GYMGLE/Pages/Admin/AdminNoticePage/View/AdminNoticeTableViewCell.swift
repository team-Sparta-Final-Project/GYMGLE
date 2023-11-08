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
//        label.textAlignment = .center
        return label
    }()
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.textHint, font: FontGuide.size16, textAligment: .right)
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
    private func addTopBorder(withColor color: UIColor, andWidth borderWidth: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        layer.addSublayer(border)
    }

    private func addBottomBorder(withColor color: UIColor, andWidth borderWidth: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        layer.addSublayer(border)
    }
    
    func cellSetting() {
//        self.layer.cornerRadius = 28
        self.backgroundColor = ColorGuide.background
        self.layer.shadowColor = ColorGuide.shadowBorder.withAlphaComponent(0.2).cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
        self.layer.shadowRadius = 1
//        self.addTopBorder(withColor: ColorGuide.textHint, andWidth: 1.0)
//        self.addBottomBorder(withColor: ColorGuide.textHint, andWidth: 1.0)
    }
    
    func cellMakeUI() {
        let views = [nameLabel, contentLabel, dateLabel]
        for view in views {
            self.contentView.addSubview(view)
        }
        NSLayoutConstraint.activate([
            //nameLabel
            nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24),
            nameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0),
//            nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
//            nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24),
            
            //contentLabel
//            contentLabel.topAnchor.constraint(equalTo: self.nameLabel.topAnchor, constant: 0),
            contentLabel.leadingAnchor.constraint(equalTo: self.nameLabel.trailingAnchor, constant: 8),
            contentLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 0),
            contentLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0),
            contentLabel.trailingAnchor.constraint(equalTo: self.dateLabel.leadingAnchor, constant: -8),
            
            //dateLabel
            dateLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0),
//            dateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24),
//            dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -14),
        ])
    }
}
