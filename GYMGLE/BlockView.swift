//
//  BlockView.swift
//  GYMGLE
//
//  Created by 조규연 on 11/1/23.
//

import UIKit
import SnapKit

class BlockView: UIView {
    
    lazy var blockButton = UIButton().then {
        $0.setTitle("차단하기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = ColorGuide.background
        
        addSubview(blockButton)
        
        blockButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
