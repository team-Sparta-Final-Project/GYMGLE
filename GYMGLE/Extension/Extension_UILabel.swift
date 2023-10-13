//
//  Extension_UILabel.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/13.
//

import UIKit

extension UILabel {
    func labelMakeUI(textColor: UIColor, font: UIFont, textAligment: NSTextAlignment) {
        self.textColor = textColor
        self.font = font
        self.sizeToFit()
        self.numberOfLines = 0
        self.textAlignment = textAligment
        self.lineBreakMode = .byTruncatingTail // 마지막 라인의 뒷 부분을 잘라내 말 줄임표 (...) 표시
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
