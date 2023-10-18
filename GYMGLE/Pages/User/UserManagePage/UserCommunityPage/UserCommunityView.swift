//
//  UserCommunityView.swift
//  GYMGLE
//
//  Created by t2023-m0088 on 2023/10/18.
//

import UIKit

class UserCommunityView: UIView,UITableViewDelegate {
    
    private lazy var GymgleName = UILabel().then {
        $0.textColor = ColorGuide.main
        $0.font = FontGuide.size26Bold
        $0.text = "GYMGLE"
    }
    private lazy var healthName = UILabel().then {
        $0.textColor = ColorGuide.black
        $0.font = FontGuide.size26Bold
        $0.text = "만나 짐"
    }
    private lazy var appNoticePlace = UIView().then {
        $0.backgroundColor = ColorGuide.white
        $0.layer.cornerRadius = 20
        $0.tintColor = .white
        $0.layer.shadowColor = ColorGuide.main.cgColor
//        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(noticePlaceTapped)))

    }
    private lazy var appNoticeBell = UIImageView().then {
        $0.image = UIImage(named: "bell.fill")
        $0.backgroundColor = ColorGuide.black
    }
    private lazy var appNoticeText = UILabel().then {
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
    private lazy var myNoticePlace = UIView().then {
        $0.backgroundColor = ColorGuide.white
        $0.layer.cornerRadius = 20
        $0.tintColor = .white
        $0.layer.shadowColor = ColorGuide.main.cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 2
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
//        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(noticePlaceTapped)))

    }
    private lazy var myNoticeBell = UIImageView().then {
        $0.image = UIImage(named: "bell.fill")
        $0.backgroundColor = ColorGuide.black
    }
    private lazy var myNoticeText = UILabel().then {
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
    private lazy var appTableView = UITableView().then {
        $0.backgroundColor = .clear
//        $0.layer.cornerRadius = 20
//        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(noticePlaceTapped)))
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupUI()
        appTableView.dataSource = self
        appTableView.delegate = self
        appTableView.register(CommunityCell.self, forCellReuseIdentifier: "Cell")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI(){
        self.backgroundColor = .lightGray
        addSubview(GymgleName)
        addSubview(appNoticePlace)
        addSubview(appNoticeBell)
        addSubview(appNoticeText)
        addSubview(appTableView)
        
        GymgleName.snp.makeConstraints {
            $0.top.equalToSuperview().offset(90)
            $0.leading.equalToSuperview().offset(20)
        }
        appNoticePlace.snp.makeConstraints {
            $0.top.equalTo(GymgleName.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(50)
        }
        appNoticeBell.snp.makeConstraints {
            $0.top.equalTo(appNoticePlace.snp.top).offset(18)
            $0.leading.equalTo(appNoticePlace.snp.leading).offset(16)
            $0.height.equalTo(16)
            $0.width.equalTo(16)
        }
        appNoticeText.snp.makeConstraints {
            $0.top.equalTo(appNoticePlace.snp.top).offset(18)
            $0.leading.equalTo(appNoticePlace.snp.leading).offset(42)
        }
        appTableView.snp.makeConstraints {
            $0.top.equalTo(appNoticePlace.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
    }

}
extension UserCommunityView:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CommunityCell
        //        cell.itemNameLabel.text = self.itemName[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension // 셀의 높이 (예: 100)에 간격 (예: 12)을 더해 설정
    }
}
