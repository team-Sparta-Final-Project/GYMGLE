//
//  QrCodeView.swift
//  GYMGLE
//
//  Created by t2023-m0088 on 2023/10/16.
//

import SnapKit
import UIKit
import SwiftUI
import Then

class QrCodeView: UIView {
    
    private lazy var qrViewPlace = UIView().then {
        $0.backgroundColor = ColorGuide.userBackGround
        $0.layer.cornerRadius = 20
        $0.layer.shadowColor = ColorGuide.userBackGround.cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    private lazy var qrViewImage = UIImageView()
    
    private lazy var qrLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size19Bold, textAligment: .center)
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.buttonMakeUI(backgroundColor: ColorGuide.main, cornerRadius: 10.0, borderWidth: 0.0, borderColor: UIColor
            .clear.cgColor, setTitle: "닫기", font: FontGuide.size24Bold, setTitleColor: UIColor.white)
        return button
    }()
    
    lazy var deletedUserButton: UIButton = {
        let button = UIButton()
        button.buttonMakeUI(backgroundColor: .white, cornerRadius: 16, borderWidth: 0, borderColor: ColorGuide.textHint.cgColor, setTitle: "탈퇴하기", font: FontGuide.size16Bold, setTitleColor: ColorGuide.main)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dataSetting(image: UIImage, text: String) {
        qrViewImage.image = image
        qrLabel.text = text
    }
}

private extension QrCodeView {
    
    func setupUI(){
        addSubview(qrViewPlace)
        addSubview(qrViewImage)
        addSubview(qrLabel)
        addSubview(backButton)
        addSubview(deletedUserButton)
        
        qrViewPlace.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(0)
            $0.leading.equalToSuperview().offset(0)
            $0.top.bottom.equalToSuperview().offset(0)
        }
        qrViewImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-62)
            $0.leading.equalToSuperview().offset(62)
            $0.height.equalTo(270)
            $0.top.equalToSuperview().offset(180)
        }
        qrLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-72)
            $0.leading.equalToSuperview().offset(72)
            $0.top.equalTo(qrViewImage.snp.bottom).offset(60)
        }
        backButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.leading.equalToSuperview().offset(24)
            $0.bottom.equalToSuperview().offset(-80)
        }
        deletedUserButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-28)
            $0.top.equalToSuperview().offset(80)
            $0.width.equalTo(85)
            $0.height.equalTo(34)
        }
    }
}


