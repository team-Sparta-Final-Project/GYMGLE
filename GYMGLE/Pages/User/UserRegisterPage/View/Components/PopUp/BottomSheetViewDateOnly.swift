//
//  BottomSheetView.swift
//  GYMGLE
//
//  Created by t2023-m0078 on 2023/10/26.
//

import UIKit
import SnapKit
import Then



class BottomSheetViewDateOnly: UIView {

    let titleLabel = UILabel().then{
        $0.text = "등록일"
    }
    let datePicker = UIDatePicker().then{
        $0.tintColor = ColorGuide.main
        $0.preferredDatePickerStyle = .inline
        $0.datePickerMode = .date
    }
    
    let doneButton = UIButton.GYMGLEButtonPreset("확인")
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        self.backgroundColor = ColorGuide.background
        
        
        
        subViewsLayoutConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func subViewsLayoutConfigure(){
        self.addSubview(datePicker)
        datePicker.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(76)
            $0.left.right.equalToSuperview().inset(29)
            $0.top.equalToSuperview().inset(36)
        }
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.bottom.equalTo(datePicker.snp.top).inset(16)
            $0.top.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }
        self.addSubview(doneButton)
        doneButton.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(32)
            $0.left.right.equalToSuperview().inset(29)
            $0.height.equalTo(44)
        }

        
    }
    
    

}
