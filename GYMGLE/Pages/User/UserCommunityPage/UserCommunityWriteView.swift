//
//  UserCommunityWriteView.swift
//  GYMGLE
//
//  Created by t2023-m0088 on 2023/10/19.
//

import UIKit

class UserCommunityWriteView: UIView, UITextViewDelegate {
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.buttonImageMakeUI(backgroundColor: UIColor.clear, image: "xmark", color: ColorGuide.black, cornerRadius: 0.0, borderWidth: 0.0, borderColor: UIColor.white.cgColor)
        return button
    }()
    
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
    lazy var writePlace = UITextView().then {
        $0.backgroundColor = ColorGuide.white
        $0.text = ""
        $0.layer.cornerRadius = 20
        $0.textContainerInset = .init(top: 20, left: 20, bottom: 0, right: 0)
        $0.isUserInteractionEnabled = true
        $0.delegate = self // 델리게이트 설정
//        텍스트뷰의 델리게이트를 이용해서 델리게이트 함수 / 텍스트뷰값을 가져올 수 있는 함수가 있음
//        텍스트뷰에 쓰여진 텍스트값을 가져오는것
    }
//    private(set) lazy var countNumberLabel = UILabel().then {
//        $0.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size16, textAligment: .center)
//        $0.text = "\(writePlace.text.count)/400"
//    }
    private(set) lazy var addButton = UIButton().then {
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
        self.backgroundColor = ColorGuide.userBackGround
        addSubview(GymgleName)
        addSubview(writePlace)
        addSubview(mirrorPlace)
        addSubview(addButton)
//        addSubview(countNumberLabel)
        addSubview(backButton)
        
        backButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }
        
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
//        countNumberLabel.snp.makeConstraints {
//            $0.trailing.equalToSuperview().offset(-20)
//            $0.top.equalTo(writePlace.snp.bottom).offset(2)
//        }
    }
}
