//
//  BottomSheetView.swift
//  GYMGLE
//
//  Created by t2023-m0078 on 2023/10/26.
//

import UIKit
import SnapKit
import Then



class BottomSheetView: UIView {

    let titleLabel = UILabel().then{
        $0.text = "등록 기간"
    }
    let datePicker = UIDatePicker().then{
        $0.minimumDate = Date()
        $0.preferredDatePickerStyle = .wheels
        $0.datePickerMode = .date
    }
    
    let miniLabel = UILabel().then{
        $0.text = "Presets"
    }
    
    let stackView = UIStackView().then{
        $0.backgroundColor = .clear
        $0.axis = .horizontal
        
    }
    
    let monthButton = UIButton().then{
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("1개월", for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = ColorGuide.shadowBorder.cgColor
    }
    let month3Button = UIButton().then{
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("3개월", for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = ColorGuide.shadowBorder.cgColor
    }
    let month6Button = UIButton().then{
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("6개월", for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = ColorGuide.shadowBorder.cgColor
    }
    let month12Button = UIButton().then{
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("12개월", for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = ColorGuide.shadowBorder.cgColor
    }
    
    
    let doneButton = UIButton.GYMGLEButtonPreset("확인")
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        self.backgroundColor = ColorGuide.background
        
        
        
        subViewsConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func subViewsConfigure(){
        self.addSubview(doneButton)
        doneButton.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(32)
            $0.left.right.equalToSuperview().inset(29)
            $0.height.equalTo(44)
        }
        self.addSubview(stackView)
        stackViewConfigure()
        stackView.snp.makeConstraints{
            $0.bottom.equalTo(doneButton.snp.top).inset(-20)
            $0.left.right.equalToSuperview().inset(29)
            $0.height.equalTo(44)
        }
        self.addSubview(miniLabel)
        miniLabel.snp.makeConstraints{
            $0.bottom.equalTo(stackView.snp.top).inset(-12)
            $0.left.equalTo(doneButton.snp.left)
        }
        self.addSubview(datePicker)
        datePicker.snp.makeConstraints{
            $0.bottom.equalTo(miniLabel).inset(4)
            $0.left.right.equalToSuperview().inset(29)
            $0.top.equalToSuperview().inset(32)
        }
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().inset(24)
            $0.bottom.equalTo(datePicker.snp.top).inset(16)
            $0.centerX.equalToSuperview()
        }
    }
    
    func stackViewConfigure(){
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(monthButton)
        stackView.addArrangedSubview(month3Button)
        stackView.addArrangedSubview(month6Button)
        stackView.addArrangedSubview(month12Button)
        stackView.spacing = 4
    }
    
    

}
