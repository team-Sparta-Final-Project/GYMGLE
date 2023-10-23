//
//  Extension_ToastView.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/18.
//

import UIKit

final class ToastView: UILabel {
    func configure() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.textColor = UIColor.white
        self.font = UIFont.systemFont(ofSize: 16)
        self.textAlignment = .center
        self.alpha = 1.0
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.numberOfLines = 2
    }
    
    
}
