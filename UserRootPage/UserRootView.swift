//
//  UserRootView.swift
//  GYMGLE
//
//  Created by t2023-m0088 on 2023/10/13.
//

import SnapKit
import UIKit
import SwiftUI

class UserRootView: UIView {
    
    var healthRoomName: UILabel
    var healthNameSub: UILabel
    var noticePlace: UIButton
    var notice: UILabel
    var doingUserPlace: UIView
    var doingUserNumber: UILabel
    var doingUserText: UILabel
    var inAndOutPlace: UIView
    var inAndOutChart: UIView
    var inAndOutBtn: UIButton
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupUI()
        self.healthRoomName = UserRootList(healthName: "만나 짐", noticeList: "안녕하세요", nowUser: 22, yesterUser: 13)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        healthRoomName = UILabel()
        healthNameSub = UILabel()
        noticePlace = UIButton()
        notice = UILabel()
        doingUserPlace = UIView()
        doingUserNumber = UILabel()
        doingUserText = UILabel()
        inAndOutPlace = UIView()
        inAndOutChart = UIView()
        inAndOutBtn = UIButton()
        
        addSubview(healthRoomName)
    }
}
