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
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        self.setTitle(setTitle, for: .normal)
        self.setTitleColor(setTitleColor, for: .normal)
        self.titleLabel?.font = font
        self.translatesAutoresizingMaskIntoConstraints = false
//        self.clipsToBounds = true 트루로 설정할시 그림자 잘리는 문제 발생함
    }

    static func GYMGLEButtonPreset(_ title:String) -> UIButton{
        // 짐블 메인 색 버튼 생성 메서드
        lazy var button = UIButton().then {
            $0.buttonMakeUI(backgroundColor: ColorGuide.main, cornerRadius: 10.0, borderWidth: 0.0, borderColor: UIColor
                .clear.cgColor, setTitle: title, font: FontGuide.size16Bold, setTitleColor: UIColor.white)
        }
        return button
    }
    
    static func GYMGLEWhiteButtonPreset(_ title:String) -> UIButton{
        // 짐블 흰색 색 버튼 생성 메서드
        lazy var button = UIButton().then {
            $0.buttonMakeUI(backgroundColor: UIColor(red: 0.946, green: 0.946, blue: 0.946, alpha: 1), cornerRadius: 14.0, borderWidth: 0.0, borderColor: UIColor
                .clear.cgColor, setTitle: title, font: FontGuide.size14, setTitleColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.61))
        }
        return button
    }
    
    
    
}
