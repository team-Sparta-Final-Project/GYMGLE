//
//  MyPageTableViewCell.swift
//  GYMGLE
//
//  Created by 조규연 on 10/22/23.
//

import UIKit

class MyPageTableViewCell: UITableViewCell {
    
    lazy var label = UILabel()
    
    lazy var arrowImageView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = .black
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews(label, arrowImageView)
        
        arrowImageView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
