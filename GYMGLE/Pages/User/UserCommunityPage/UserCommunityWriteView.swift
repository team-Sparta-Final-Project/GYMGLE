//
//  UserCommunityWriteView.swift
//  GYMGLE
//
//  Created by t2023-m0088 on 2023/10/19.
//

import UIKit

class UserCommunityWriteView: UIView {
    
    private lazy var GymgleName = UILabel().then {
        $0.textColor = ColorGuide.main
        $0.font = FontGuide.size26Bold
        $0.text = "GYMGLE"
    }
    private lazy var mirrorPlace = UIButton().then {
        $0.backgroundColor = ColorGuide.white
        $0.setImage(UIImage(systemName: "circle.grid.2x1.left.filled"), for: .normal)
        $0.tintColor = ColorGuide.black
        $0.layer.cornerRadius = 16
//        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mirrorPlaceTap)))
    }
    private(set) lazy var writePlace = UITextView().then {
        $0.backgroundColor = ColorGuide.white
        $0.text = "내용을 입력하세요."

    }
    private(set) lazy var countNumberLabel = UILabel().then {
        $0.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size16, textAligment: .center)
        $0.text = "\(writePlace.text.count)/400"
    }
    private lazy var addButton = UIButton().then {
        $0.backgroundColor = ColorGuide.main
        $0.setTitleColor(ColorGuide.white, for: .normal)
        $0.setTitle("등록하기", for: .normal)
        $0.layer.cornerRadius = 8

    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        self.backgroundColor = .lightGray
        addSubview(GymgleName)
        addSubview(writePlace)
        addSubview(mirrorPlace)
        addSubview(addButton)
        addSubview(countNumberLabel)
        
        GymgleName.snp.makeConstraints {
            $0.top.equalToSuperview().offset(90)
            $0.leading.equalToSuperview().offset(20)
        }
        mirrorPlace.snp.makeConstraints {
            $0.centerY.equalTo(GymgleName.snp.centerY)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.equalTo(32)
            $0.height.equalTo(32)
        }
        writePlace.snp.makeConstraints {
            $0.top.equalTo(GymgleName.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().multipliedBy(0.6)
        }
        addButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().multipliedBy(0.9)
            $0.height.equalTo(44)
        }
        countNumberLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(writePlace.snp.bottom).offset(2)
        }
    }
}
