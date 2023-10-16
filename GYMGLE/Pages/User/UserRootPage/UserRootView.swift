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
    
    var currentValue = 0
    let targetValue = 66
    let animationDuration = 2.0
    
    private lazy var healthName = UILabel().then {
        $0.textColor = ColorGuide.black
        $0.font = FontGuide.size26Bold
        $0.text = "김기호"
    }
    private lazy var healthNameSub = UILabel().then {
        $0.textColor = ColorGuide.black
        $0.font = FontGuide.size14Bold
        $0.text = "님 오늘도 힘내볼까요!"
    }
    private lazy var noticePlace = UIView().then {
        $0.backgroundColor = ColorGuide.white
        $0.layer.cornerRadius = 20
        $0.tintColor = .white
        $0.layer.shadowColor = ColorGuide.main.cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 2
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(noticePlaceTapped)))

    }
    private lazy var noticeBell = UIImageView().then {
        $0.image = UIImage(named: "bell.fill")
        $0.backgroundColor = ColorGuide.black
    }
    private lazy var noticeText = UILabel().then {
        $0.textColor = ColorGuide.black
        $0.font = FontGuide.size14Bold
        $0.text = """
이번 주 일요일 휴무입니다! 즐거운 휴일 되세요~
이번 주 일요일 휴무입니다! 즐거운 휴일 되세요~
이번 주 일요일 휴무입니다! 즐거운 휴일 되세요~
이번 주 일요일 휴무입니다! 즐거운 휴일 되세요~
이번 주 일요일 휴무입니다! 즐거운 휴일 되세요~

"""
    }
    private lazy var yesterUserPlace = UIView().then {
        $0.backgroundColor = ColorGuide.white
        $0.layer.cornerRadius = 20
        $0.layer.shadowColor = ColorGuide.main.cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 2
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startNumberAnimation)))
    }
    private lazy var yesterUserNumberPlace = UIView().then {
        $0.backgroundColor = ColorGuide.white
        $0.clipsToBounds = true
        $0.addSubview(yesterUserNumber)
    }
    private lazy var yesterUserNumber = UILabel().then {
        $0.textColor = ColorGuide.main
        $0.font = FontGuide.size50Bold
        $0.text = "66"
    }
    private lazy var yesterUserMyung = UILabel().then {
        $0.textColor = ColorGuide.main
        $0.font = FontGuide.size14Bold
        $0.text = "명"
    }
    private lazy var yesterUserText = UILabel().then {
        $0.textColor = ColorGuide.main
        $0.font = FontGuide.size14Bold
        $0.text = "어제 이시간 이용객 수"
    }
    private lazy var nowUserPlace = UIView().then {
        $0.backgroundColor = ColorGuide.main
        $0.layer.cornerRadius = 20
        $0.layer.shadowColor = ColorGuide.black.cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 2
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startNumberAnimation2)))
    }
    private lazy var nowUserNumberPlace = UIView().then {
        $0.backgroundColor = ColorGuide.main
        $0.clipsToBounds = true
        $0.addSubview(nowUserNumber)
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
        $0.textColor = ColorGuide.white
        $0.font = FontGuide.size14Bold
        $0.text = "지금 헬스장 이용객 수"
    }
    private lazy var chartPlace = UIView().then {
        $0.backgroundColor = ColorGuide.white
        $0.layer.cornerRadius = 20
        $0.layer.shadowColor = ColorGuide.goldTier.cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chartPlaceTapped)))
    }
    private lazy var chartTopText = UILabel().then {
        $0.textColor = ColorGuide.main
        $0.font = FontGuide.size14Bold
        $0.text = "저번주 나의 운동량은.."
    }
    
    private lazy var chartMidText = UILabel().then {
        $0.textColor = ColorGuide.goldTier
        $0.font = FontGuide.size32Bold
        $0.text = "상위 4% 에요!"
    }
    private lazy var chartBottomText = UILabel().then {
        $0.textColor = ColorGuide.main
        $0.font = FontGuide.size14Bold
        $0.text = "와우! 운동 러버시군요!"
    }
    var inBtn = UIButton().then {
        $0.backgroundColor = ColorGuide.main
        $0.setBackgroundColor(ColorGuide.black, for: .highlighted)
        $0.setTitleColor(ColorGuide.white, for: .normal)
        $0.setTitleColor(ColorGuide.main, for: .highlighted)
        $0.setTitle("입실하기", for: .normal)
        $0.titleLabel?.font = FontGuide.size14Bold
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    private lazy var outBtn = UIButton().then {
        $0.backgroundColor = ColorGuide.main
        $0.setBackgroundColor(ColorGuide.black, for: .highlighted)
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
    var isNoticePlaceExpanded = false

        @objc func noticePlaceTapped() {
            if isNoticePlaceExpanded {
                UIView.animate(withDuration: 0.3) {
                    self.noticePlace.snp.updateConstraints { make in
                        make.height.equalTo(50)
                        self.noticeText.numberOfLines = 1

                    }
                    
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.noticePlace.snp.updateConstraints { make in
                        make.height.equalTo(300)
                        self.noticeText.numberOfLines = 0

                        // 다른 제약을 변경하려면 여기에 추가
                    }
                }
            }
            isNoticePlaceExpanded.toggle()
        }
    
    @objc func chartPlaceTapped() {
        UIView.animate(withDuration: 0.5, animations: {
                self.chartPlace.layer.shadowOpacity = 1
                self.chartPlace.layer.shadowRadius = 15
                self.chartPlace.layer.shadowOffset = CGSize(width: 0, height: 0)
            }) { (completed) in
                // 2초 후에 사라지는 애니메이션
                UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseOut, animations: {
                    self.chartPlace.layer.shadowOpacity = 1
                    self.chartPlace.layer.shadowRadius = 4
                    self.chartPlace.layer.shadowOffset = CGSize(width: 0, height: 0)
                }, completion: nil)
            }
    }
    @objc func startNumberAnimation(){
        let transition = CATransition()
                transition.duration = 1
                transition.timingFunction = .init(name: .easeInEaseOut)
                transition.type = .push
                transition.subtype = .fromTop
                yesterUserNumber.layer.add(transition, forKey: CATransitionType.push.rawValue)
    }
    @objc func startNumberAnimation2(){
        let transition = CATransition()
                transition.duration = 1
                transition.timingFunction = .init(name: .easeInEaseOut)
                transition.type = .push
                transition.subtype = .fromTop
                nowUserNumber.layer.add(transition, forKey: CATransitionType.push.rawValue)
    }
    @objc func reloadView(){
        
    }
    func setupUI(){
        self.backgroundColor = ColorGuide.white
        addSubview(healthName)
        addSubview(healthNameSub)
        addSubview(noticePlace)
        addSubview(noticeBell)
        addSubview(noticeText)
        addSubview(yesterUserPlace)
        addSubview(yesterUserNumberPlace)
//        addSubview(yesterUserNumber)
        addSubview(yesterUserMyung)
        addSubview(yesterUserText)
        addSubview(nowUserPlace)
        addSubview(nowUserNumberPlace)
//        addSubview(nowUserNumber)
        addSubview(nowUserMyung)
        addSubview(nowUserText)
        addSubview(chartPlace)
        addSubview(chartTopText)
        addSubview(chartMidText)
        addSubview(chartBottomText)
        addSubview(inBtn)
        addSubview(outBtn)
        
        healthName.snp.makeConstraints {
            $0.top.equalToSuperview().offset(90)
            $0.leading.equalToSuperview().offset(20)
        }
        healthNameSub.snp.makeConstraints {
            $0.bottom.equalTo(healthName.snp.bottom).offset(-4)
            $0.leading.equalTo(healthName.snp.trailing).offset(4)
        }
        noticePlace.snp.makeConstraints {
            $0.top.equalTo(healthName.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(50)
        }
        noticeBell.snp.makeConstraints {
            $0.top.equalTo(noticePlace.snp.top).offset(18)
            $0.leading.equalTo(noticePlace.snp.leading).offset(16)
            $0.height.equalTo(16)
            $0.width.equalTo(16)
        }
        noticeText.snp.makeConstraints {
            $0.top.equalTo(noticePlace.snp.top).offset(18)
            $0.leading.equalTo(noticePlace.snp.leading).offset(42)
        }
        yesterUserPlace.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(170)
            $0.top.equalTo(noticePlace.snp.bottom).offset(12)
            $0.height.equalTo(170)
        }
        yesterUserNumberPlace.snp.makeConstraints {
            $0.centerY.equalTo(yesterUserPlace.snp.centerY).offset(-5)
            $0.centerX.equalTo(yesterUserPlace.snp.centerX).offset(-10)
            $0.width.equalTo(120)
            $0.height.equalTo(50)
        }
        yesterUserNumber.snp.makeConstraints {
            $0.centerY.equalTo(yesterUserNumberPlace.snp.centerY).offset(0)
            $0.centerX.equalTo(yesterUserNumberPlace.snp.centerX).offset(0)
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
        nowUserNumberPlace.snp.makeConstraints {
            $0.centerY.equalTo(nowUserPlace.snp.centerY).offset(-5)
            $0.centerX.equalTo(nowUserPlace.snp.centerX).offset(-10)
            $0.width.equalTo(120)
            $0.height.equalTo(50)
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
        chartTopText.snp.makeConstraints {
            $0.top.equalTo(chartPlace.snp.top).offset(22)
            $0.leading.equalTo(chartPlace.snp.leading).offset(30)
        }
        chartMidText.snp.makeConstraints {
            $0.centerX.equalTo(chartPlace.snp.centerX)
            $0.centerY.equalTo(chartPlace.snp.centerY)
        }
        chartBottomText.snp.makeConstraints {
            $0.bottom.equalTo(chartPlace.snp.bottom).offset(-22)
            $0.trailing.equalTo(chartPlace.snp.trailing).offset(-30)
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
