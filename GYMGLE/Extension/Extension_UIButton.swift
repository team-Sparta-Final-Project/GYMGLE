//
//  Extension_UIButton.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/12.
//

import UIKit

extension UIButton {
    
    func buttonMakeUI(backgroundColor: UIColor,cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: CGColor, setTitle: String, font: UIFont, setTitleColor:  UIColor) {
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        self.setTitle(setTitle, for: .normal)
        self.setTitleColor(setTitleColor, for: .normal)
        self.titleLabel?.font = font
        self.translatesAutoresizingMaskIntoConstraints = false
    }

}
