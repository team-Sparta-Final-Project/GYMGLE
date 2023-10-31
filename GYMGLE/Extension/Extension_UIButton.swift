//
//  Extension_UIButton.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/12.
//

import UIKit

extension UIButton {
    
    //텍스트 버튼
    func buttonMakeUI(backgroundColor: UIColor,cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: CGColor, setTitle: String, font: UIFont, setTitleColor:  UIColor) {
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        self.setTitle(setTitle, for: .normal)
        self.setTitleColor(setTitleColor, for: .normal)
        self.titleLabel?.font = font
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    static func GYMGLEButtonPreset(_ title:String) -> UIButton{
        // 짐블 메인 색 버튼 생성 메서드
        lazy var button = UIButton().then {
            $0.buttonMakeUI(backgroundColor: ColorGuide.main, cornerRadius: 10.0, borderWidth: 0.0, borderColor: UIColor
                .clear.cgColor, setTitle: title, font: FontGuide.size16Bold, setTitleColor: UIColor.white)
        }
        return button
    }
    
    //그림자 있는 텍스트 버튼
    func shadowButtonMakeUI(backgroundColor: UIColor, cornerRadius: CGFloat, shadowColor: CGColor, shadowOpacity: Float, shadowRadius: CGFloat, setTitle: String, font: UIFont, setTitleColor:  UIColor) {
        self.backgroundColor = backgroundColor
        self.setTitle(setTitle, for: .normal)
        self.setTitleColor(setTitleColor, for: .normal)
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = shadowRadius
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //그림자가 있는 이미지버튼
    func shadowButtonImageMakeUI(image: String, color: UIColor, backgroundColor: UIColor, cornerRadius: CGFloat, shadowColor: CGColor, shadowOpacity: Float, shadowRadius: CGFloat) {
        self.backgroundColor = backgroundColor
        self.setImage(UIImage(systemName: "\(image)"), for: .normal) //선택 x
        self.setImage(UIImage(systemName: "\(image)"), for: .selected) //선택 o
        self.tintColor = color // 아이콘 색상
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = shadowRadius
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // 이미지 버튼
    func buttonImageMakeUI(backgroundColor: UIColor, image: String, color: UIColor, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: CGColor) {
        self.backgroundColor = backgroundColor
        self.setImage(UIImage(systemName: "\(image)"), for: .normal) //선택 x
        self.tintColor = color // 아이콘 색상
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func buttonImageMakeUI(image: String, color: UIColor) {
        self.setImage(UIImage(systemName: "\(image)")?.resized(to: CGSize(width: 28, height: 28)).withRenderingMode(.alwaysTemplate), for: .normal) //선택 x
        self.tintColor = color // 아이콘 색상

        self.translatesAutoresizingMaskIntoConstraints = false
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

