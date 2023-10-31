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
    private lazy var qrViewImage = UIImageView().then {
        $0.layer.cornerRadius = 20
    }
    
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
        
        qrViewPlace.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(0)
            $0.leading.equalToSuperview().offset(0)
            $0.top.bottom.equalToSuperview().offset(0)
        }
        qrViewImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-62)
            $0.leading.equalToSuperview().offset(62)
            $0.height.equalTo(270)
            $0.top.equalToSuperview().offset(100)
        }
        qrLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-72)
            $0.leading.equalToSuperview().offset(72)
            $0.top.equalTo(qrViewImage.snp.bottom).offset(60)
        }
        backButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.leading.equalToSuperview().offset(24)
            $0.bottom.equalToSuperview().offset(-100)
        }
    }
}
