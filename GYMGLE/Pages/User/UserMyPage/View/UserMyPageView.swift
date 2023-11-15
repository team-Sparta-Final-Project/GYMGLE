//
//  UserMyPageView.swift
//  GYMGLE
//
//  Created by 조규연 on 10/18/23.
//

import UIKit

final class UserMyPageView: UIView {
    
    // MARK: - Properties
    
    private let myPageLabel = UILabel().then {
        $0.textColor = ColorGuide.main
        $0.font = UIFont.boldSystemFont(ofSize: 32)
        $0.text = "마이페이지"
    }
    
    lazy var tableView = MyPageTableView()
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetting()
        tableView.sectionHeaderTopPadding = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension UserMyPageView {
    
    func viewSetting() {
        self.backgroundColor = ColorGuide.background
        self.addSubviews(myPageLabel, tableView)
        
        myPageLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(90)
            $0.left.equalToSuperview().offset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(myPageLabel.snp.bottom).offset(48)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(52*8 + 20)
        }
    }
}
