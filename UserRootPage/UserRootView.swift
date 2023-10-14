//
//  UserRootView.swift
//  GYMGLE
//
//  Created by t2023-m0088 on 2023/10/13.
//

import SnapKit
import UIKit
import SwiftUI
import Then
import Charts

class UserRootView: UIView {
    
    let players = ["ozil", "ramsy", "lasu", "auba"]
    let goals = [5, 2, 15, 53]
    
    private lazy var healthName = UILabel().then {
        $0.textColor = ColorGuide.white
        $0.font = FontGuide.size26Bold
        $0.text = "만나 짐"
    }
    private lazy var healthNameSub = UILabel().then {
        $0.textColor = ColorGuide.white
        $0.font = FontGuide.size14Bold
        $0.text = "오늘도 힘내볼까요!"
    }
    private lazy var noticePlace = UIView().then {
        $0.backgroundColor = ColorGuide.notice
        $0.layer.cornerRadius = 20
        $0.tintColor = .white
    }
    private lazy var noticeBell = UIImageView().then {
        $0.image = UIImage(named: "bell.fill")
        $0.backgroundColor = .white
    }
    private lazy var noticeText = UILabel().then {
        $0.textColor = ColorGuide.white
        $0.font = FontGuide.size14
        $0.text = "이번 주 일요일 휴무입니다! 즐거운 휴일 되세요~"
    }
    private lazy var yesterUserPlace = UIView().then {
        $0.backgroundColor = ColorGuide.userBackGround
        $0.layer.cornerRadius = 20
        $0.layer.shadowColor = ColorGuide.main.cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    private lazy var yesterUserNumber = UILabel().then {
        $0.textColor = ColorGuide.white
        $0.font = FontGuide.size50Bold
        $0.text = "66"
    }
    private lazy var yesterUserMyung = UILabel().then {
        $0.textColor = ColorGuide.white
        $0.font = FontGuide.size14Bold
        $0.text = "명"
    }
    private lazy var yesterUserText = UILabel().then {
        $0.textColor = ColorGuide.main
        $0.font = FontGuide.size14Bold
        $0.text = "어제 이시간 이용객 수"
    }
    private lazy var nowUserPlace = UIView().then {
        $0.backgroundColor = ColorGuide.userBackGround
        $0.layer.cornerRadius = 20
        $0.layer.shadowColor = ColorGuide.main.cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    private lazy var nowUserNumber = UILabel().then {
        $0.textColor = ColorGuide.white
        $0.font = FontGuide.size50Bold
        $0.text = "12"
    }
    private lazy var nowUserMyung = UILabel().then {
        $0.textColor = ColorGuide.white
        $0.font = FontGuide.size14Bold
        $0.text = "명"
    }
    private lazy var nowUserText = UILabel().then {
        $0.textColor = ColorGuide.main
        $0.font = FontGuide.size14Bold
        $0.text = "지금 헬스장 이용객 수"
    }
    private lazy var chartPlace = UIView().then {
        $0.backgroundColor = ColorGuide.notice
        $0.layer.cornerRadius = 20
    }
    private lazy var inBtn = UIButton().then {
        $0.backgroundColor = ColorGuide.white
        $0.setBackgroundColor(ColorGuide.main, for: .highlighted)
        $0.setTitleColor(ColorGuide.main, for: .normal)
        $0.setTitleColor(ColorGuide.white, for: .highlighted)
        $0.setTitle("입실하기", for: .normal)
        $0.titleLabel?.font = FontGuide.size14Bold
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    private lazy var outBtn = UIButton().then {
        $0.backgroundColor = ColorGuide.main
        $0.setBackgroundColor(ColorGuide.white, for: .highlighted)
        $0.setTitleColor(ColorGuide.white, for: .normal)
        $0.setTitleColor(ColorGuide.main, for: .highlighted)
        $0.setTitle("퇴실하기", for: .normal)
        $0.layer.cornerRadius = 20
        $0.titleLabel?.font = FontGuide.size14Bold
        $0.clipsToBounds = true
    }
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupUI()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//
//    func action(){
//        inBtn.addTarget(self, action: #selector(colorSwitch), for: .touchUpInside)
//    }
//    @objc func colorSwitch(){
//        inBtn.backgroundColor = ColorGuide.main
//        inBtn.setTitleColor(ColorGuide.white, for: .normal)
//    }
    
    func setupUI(){
        self.backgroundColor = ColorGuide.userBackGround
        addSubview(healthName)
        addSubview(healthNameSub)
        addSubview(noticePlace)
        addSubview(noticeBell)
        addSubview(noticeText)
        addSubview(yesterUserPlace)
        addSubview(yesterUserNumber)
        addSubview(yesterUserMyung)
        addSubview(yesterUserText)
        addSubview(nowUserPlace)
        addSubview(nowUserNumber)
        addSubview(nowUserMyung)
        addSubview(nowUserText)
        addSubview(chartPlace)
        addSubview(inBtn)
        addSubview(outBtn)
        
        healthName.snp.makeConstraints {
            $0.top.equalToSuperview().offset(90)
            $0.leading.equalToSuperview().offset(20)
        }
        healthNameSub.snp.makeConstraints {
            $0.bottom.equalTo(healthName.snp.bottom).offset(0)
            $0.leading.equalTo(healthName.snp.trailing).offset(4)
        }
        noticePlace.snp.makeConstraints {
            $0.top.equalTo(healthName.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(50)
        }
        noticeBell.snp.makeConstraints {
            $0.centerY.equalTo(noticePlace.snp.centerY)
            $0.leading.equalTo(noticePlace.snp.leading).offset(16)
            $0.height.equalTo(16)
            $0.width.equalTo(16)
        }
        noticeText.snp.makeConstraints {
            $0.centerY.equalTo(noticePlace.snp.centerY)
            $0.leading.equalTo(noticePlace.snp.leading).offset(42)
        }
        yesterUserPlace.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(170)
            $0.top.equalTo(noticePlace.snp.bottom).offset(12)
            $0.height.equalTo(170)
        }
        yesterUserNumber.snp.makeConstraints {
            $0.centerY.equalTo(yesterUserPlace.snp.centerY).offset(-5)
            $0.centerX.equalTo(yesterUserPlace.snp.centerX).offset(-10)
        }
        yesterUserMyung.snp.makeConstraints {
            $0.bottom.equalTo(yesterUserNumber.snp.bottom).offset(-10)
            $0.leading.equalTo(yesterUserNumber.snp.trailing).offset(10)
        }
        yesterUserText.snp.makeConstraints {
            $0.centerX.equalTo(yesterUserPlace.snp.centerX)
            $0.bottom.equalTo(yesterUserPlace.snp.bottom).offset(-22)
        }
        nowUserPlace.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.equalTo(170)
            $0.top.equalTo(noticePlace.snp.bottom).offset(12)
            $0.height.equalTo(170)
        }
        nowUserNumber.snp.makeConstraints {
            $0.centerY.equalTo(nowUserPlace.snp.centerY).offset(-5)
            $0.centerX.equalTo(nowUserPlace.snp.centerX).offset(-10)
        }
        nowUserMyung.snp.makeConstraints {
            $0.bottom.equalTo(nowUserNumber.snp.bottom).offset(-10)
            $0.leading.equalTo(nowUserNumber.snp.trailing).offset(10)
        }
        nowUserText.snp.makeConstraints {
            $0.centerX.equalTo(nowUserPlace.snp.centerX)
            $0.bottom.equalTo(nowUserPlace.snp.bottom).offset(-22)
        }
        chartPlace.snp.makeConstraints {
            $0.top.equalTo(yesterUserPlace.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(190)
        }
        inBtn.snp.makeConstraints {
            $0.top.equalTo(chartPlace.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(56)
        }
        outBtn.snp.makeConstraints {
            $0.top.equalTo(inBtn.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(56)
        }
        
    }
    
//    private func animate(){
//        let animation = CATransition()
//        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//        animation.duration = duration
//        animation.type = .moveIn
//        animation.subtype = .fromTop
//        animation.delegate = self
//
//        self.layer.add(animation, forKey: CATransitionType.push.rawValue)
//    }
    
//    func customizeChart(dataPoints: [String], values:[Double]){
//        var dataEntries: [ChartDataEntry] = []
//        for i in 0..<dataPoints.count {
//            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
//            dataEntries.append(dataEntry)
//
//        }
//        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
//        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
//        private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
//          var colors: [UIColor] = []
//          for _ in 0..<numbersOfColor {
//            let red = Double(arc4random_uniform(256))
//            let green = Double(arc4random_uniform(256))
//            let blue = Double(arc4random_uniform(256))
//            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
//            colors.append(color)
//          }
//            return colors
//        }
//    }
    
}

extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        self.setBackgroundImage(backgroundImage, for: state)
    }
}
