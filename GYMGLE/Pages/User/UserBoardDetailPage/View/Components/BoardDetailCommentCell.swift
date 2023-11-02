//
//  TableViewCell.swift
//  GYMGLE
//
//  Created by t2023-m0078 on 2023/11/01.
//

import UIKit
import SnapKit

class BoardDetailCommentCell: UITableViewCell {

    let profileLine = BoardProfileLine()
    let contentLabel = UILabel().then{
        $0.numberOfLines = 0
        $0.font = FontGuide.size14
        $0.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

        //"오늘도 운동 완료!\n하제하기 싫은거 인정?"
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        
        self.contentView.addSubviews(profileLine,contentLabel)
        
        profileLine.snp.makeConstraints{
            $0.top.left.right.equalToSuperview().inset(20)
        }
        
        contentLabel.snp.makeConstraints{
            $0.top.equalTo(profileLine.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(52)
            $0.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }


    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
