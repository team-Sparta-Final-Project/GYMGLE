//
//  BoardDetailTableView.swift
//  GYMGLE
//
//  Created by t2023-m0078 on 2023/11/01.
//

import UIKit

class BoardDetailTableView: UITableView {

    
    override init(frame: CGRect, style: UITableView.Style) {
        super .init(frame: frame, style: style)
        
        self.backgroundColor = .clear
//        self.separatorStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
