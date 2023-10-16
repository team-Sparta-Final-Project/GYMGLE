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
        $0.backgroundColor = ColorGuide.notice
        $0.layer.cornerRadius = 20
        $0.layer.shadowColor = ColorGuide.main.cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        addSubview(qrViewPlace)
        
        qrViewPlace.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(0)
            $0.leading.equalToSuperview().offset(0)
            $0.height.equalTo(800)
        }
    }

    
}
