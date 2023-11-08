//
//  UserMyProfileBoardTableViewCell.swift
//  GYMGLE
//
//  Created by 박성원 on 11/6/23.
//

import UIKit

final class UserMyProfileBoardTableViewCell: UITableViewCell {

    static let identifier = "UserMyProfileBoardTableViewCell"
    
    var board: Board? {
        didSet {
            guard let board = board else {return}
            contentLabel.text = board.content
            likeCountLabel.text = "좋아요 \(board.likeCount)개"
            commentCountLabel.text = "답글 \(board.commentCount)개"
            timeLabel.text = "\(board.date.timeAgo())"
        }
    }
    // MARK: - UIProperties

    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size16, textAligment: .left)
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var likeCountLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.textHint, font: FontGuide.size14, textAligment: .left)
        label.text = "좋아요 20개"
        return label
    }()
    
    lazy var commentCountLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.textHint, font: FontGuide.size14, textAligment: .left)
        label.text = "답글 12개"
        return label
    }()
    
    private lazy var countLabelStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [likeCountLabel, commentCountLabel])
        stack.spacing = 10
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.textHint, font: FontGuide.size14, textAligment: .right)
        label.text = "20시간 전"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        configuredCell()
        cellSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}

private extension UserMyProfileBoardTableViewCell {
    
    func cellSetting() {
        self.layer.cornerRadius = 20
        self.backgroundColor = .white
        self.layer.shadowColor = ColorGuide.shadowBorder.withAlphaComponent(0.2).cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 1
    }
    
    func configuredCell() {
        let views = [contentLabel, countLabelStackView, timeLabel]
        for view in views {
            contentView.addSubview(view)
        }
        
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 14),
            contentLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
            contentLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -60),
            
            countLabelStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 14),
            countLabelStackView.topAnchor.constraint(equalTo: self.contentLabel.bottomAnchor, constant: 8),
            countLabelStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12),
            
            timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -14),
            timeLabel.centerYAnchor.constraint(equalTo: self.countLabelStackView.centerYAnchor, constant: 0)
        ])
    }
}
