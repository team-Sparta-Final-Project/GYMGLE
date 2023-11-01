//
//  ReportView.swift
//  GYMGLE
//
//  Created by 조규연 on 10/31/23.
//

import UIKit
import SnapKit

class ReportView: UIView {
    
    lazy var reportButton = UIButton().then {
        $0.setTitle("신고", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = ColorGuide.background
        
        addSubview(reportButton)
        
        reportButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
