//
//  UserMyProfileBoardTableViewCell.swift
//  GYMGLE
//
//  Created by 박성원 on 11/6/23.
//

import UIKit
import Then
import SnapKit

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

    private lazy var contentLabel = UILabel().then {
        $0.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size16, textAligment: .left)
        $0.numberOfLines = 3
    }
    
    private lazy var likeCountLabel = UILabel().then {
        $0.labelMakeUI(textColor: ColorGuide.textHint, font: FontGuide.size14, textAligment: .left)
        $0.text = "좋아요 20개"
    }
    
    lazy var commentCountLabel = UILabel().then {
        $0.labelMakeUI(textColor: ColorGuide.textHint, font: FontGuide.size14, textAligment: .left)
        $0.text = "답글 12개"
    }
    
    private lazy var countLabelStackView = UIStackView().then {
        $0.spacing = 10
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    private lazy var timeLabel = UILabel().then {
        $0.labelMakeUI(textColor: ColorGuide.textHint, font: FontGuide.size14, textAligment: .right)
        $0.text = "20시간 전"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
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
        configuredCell()
    }
    
    func configuredCell() {
        [contentLabel, countLabelStackView, timeLabel].forEach {
            contentView.addSubview($0)
        }
        
        [likeCountLabel, commentCountLabel].forEach {
            self.countLabelStackView.addArrangedSubview($0)
        }
        
        //contentLabel
        contentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(14)
            make.top.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().offset(-60)
        }
        //countLabelStackView
        countLabelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(14)
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(12)
        }
        //timeLabel
        timeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(14)
            make.centerY.equalTo(countLabelStackView.snp.centerY)
        }
    }
}
