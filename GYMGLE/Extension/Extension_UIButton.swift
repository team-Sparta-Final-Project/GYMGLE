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
            $0.buttonMakeUI(backgroundColor: UIColor.white, cornerRadius: 15.0, borderWidth: 0.0, borderColor: UIColor
                .clear.cgColor, setTitle: title, font: FontGuide.size14, setTitleColor: ColorGuide.textHint)
            
            $0.layer.shadowColor = ColorGuide.black.cgColor
            $0.layer.shadowOpacity = 0.25
            $0.layer.shadowOffset = CGSize(width: 0, height: 1)
            $0.layer.shadowRadius = 6 / UIScreen.main.scale
            
        }
        return button
    }
    
    
    
}
