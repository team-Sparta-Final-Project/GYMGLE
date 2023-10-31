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
    private lazy var topDivider: UIView = {
        let divider = UIView()
        divider.backgroundColor = ColorGuide.textHint
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size16, textAligment: .left)
        return label
    }()
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size16, textAligment: .center)
        return label
    }()
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size16, textAligment: .right)
        return label
    }()
    private lazy var bottomDivider: UIView = {
        let divider = UIView()
        divider.backgroundColor = ColorGuide.textHint
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        cellMakeUI()
        self.contentView.backgroundColor = ColorGuide.background
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
    func cellMakeUI() {
        let views = [topDivider, nameLabel, contentLabel, dateLabel, bottomDivider]
        for view in views {
            self.contentView.addSubview(view)
        }
        NSLayoutConstraint.activate([
            
            //topDivider
            topDivider.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            topDivider.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            topDivider.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant:-0),
            topDivider.heightAnchor.constraint(equalToConstant: 1.0),
            
            //nameLabel
            nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 48),
            nameLabel.topAnchor.constraint(equalTo: self.topDivider.bottomAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -48),
            
            //contentLabel
            contentLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 10),
            contentLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 48),
            contentLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -48),
            
            //dateLabel
            dateLabel.topAnchor.constraint(equalTo: self.contentLabel.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 48),
            dateLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -48),
            dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20),
            
            //bottomDivider
            bottomDivider.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            bottomDivider.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -0),
            bottomDivider.heightAnchor.constraint(equalToConstant: 0.6),
            bottomDivider.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0)
        ])
    }
}
