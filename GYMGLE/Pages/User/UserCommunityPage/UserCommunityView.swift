//
//  UserCommunityView.swift
//  GYMGLE
//
//  Created by t2023-m0088 on 2023/10/18.
//

import UIKit

class UserCommunityView: UIView,UITableViewDelegate {
    
    private let dummyDataManager = DataManager.shared
    var gymInfo: GymInfo?
    var userName: User?
        
    private lazy var GymgleName = UILabel().then {
        $0.textColor = ColorGuide.main
        $0.font = FontGuide.size26Bold
        $0.text = "GYMGLE"
    }
    private lazy var healthName = UILabel().then {
        $0.textColor = ColorGuide.main
        $0.font = FontGuide.size26Bold
        $0.text = "만나 짐"
        $0.isHidden = true
    }
    private(set) lazy var writePlace = UIButton().then {
        $0.backgroundColor = ColorGuide.main
        $0.setImage(UIImage(systemName: "pencil"), for: .normal)
        $0.layer.cornerRadius = 30
        $0.tintColor = ColorGuide.white
        $0.layer.shadowColor = ColorGuide.black.cgColor
        $0.layer.shadowOpacity = 0.25
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
//    private lazy var mirrorPlace = UIButton().then {
//        $0.backgroundColor = ColorGuide.white
//        $0.setImage(UIImage(systemName: "circle.grid.2x1.left.filled"), for: .normal)
//        $0.tintColor = ColorGuide.black
//        $0.layer.cornerRadius = 16
////        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mirrorPlaceTap)))
//    }
    private lazy var appNoticePlace = UISearchBar().then {
        $0.layer.cornerRadius = 20
        $0.searchTextField.placeholder = "검색"
        $0.searchTextField.textColor = ColorGuide.textHint
        $0.searchTextField.clearButtonMode = .whileEditing
        $0.searchTextField.layer.borderWidth = 0
        $0.searchTextField.layer.cornerRadius = 10
        $0.searchTextField.layer.borderColor = ColorGuide.textHint.cgColor
        $0.searchBarStyle = .minimal

    }
    private(set) lazy var appTableView = UITableView().then {
        $0.backgroundColor = .clear
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
        self.backgroundColor = ColorGuide.userBackGround
        addSubview(GymgleName)
        addSubview(healthName)
//        addSubview(mirrorPlace)
        addSubview(appNoticePlace)
        addSubview(appTableView)
        addSubview(writePlace)

//        writePlace.addSubview(yourTableView)
//        appTableView.addSubview(yourTableView)
        
        GymgleName.snp.makeConstraints {
            $0.top.equalToSuperview().offset(90)
            $0.leading.equalToSuperview().offset(20)
        }
        healthName.snp.makeConstraints {
            $0.top.equalToSuperview().offset(90)
            $0.leading.equalToSuperview().offset(20)
        }
        writePlace.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-122)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.equalTo(60)
            $0.height.equalTo(60)
        }
//        mirrorPlace.snp.makeConstraints {
//            $0.centerY.equalTo(GymgleName.snp.centerY)
//            $0.trailing.equalTo(writePlace.snp.leading).offset(-6)
//            $0.width.equalTo(32)
//            $0.height.equalTo(32)
//        }
        appNoticePlace.snp.makeConstraints {
            $0.top.equalTo(GymgleName.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(50)
        }
        appTableView.snp.makeConstraints {
            $0.top.equalTo(appNoticePlace.snp.bottom).offset(0)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-90)
        }
        
    }

}
extension UserCommunityView:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 // TODO: 데이터모델 공사중입니다
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CommunityCell
        cell.selectionStyle = .none
//        var date = dateToString(date: dummyDataManager.gymInfo.noticeList[indexPath.row].date)
//        cell.nameLabel.text = dummyDataManager.gymInfo.gymName
//        cell.ctextLabel.text = dummyDataManager.gymInfo.noticeList[indexPath.row].content
//        cell.dateLabel.text = date
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension // 셀의 높이 (예: 100)에 간격 (예: 12)을 더해 설정
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // 셀을 클릭했을 때 호출됩니다.
            let pp = UserCommunityViewController()
        
         let adminNoticeDetailVC = AdminNoticeDetailViewController()
//         adminNoticeDetailVC.noticeInfo = dummyDataManager.gymInfo.noticeList[indexPath.row] 데이터모델 공사중입니다
            // 새로운 뷰를 모달로 표시합니다.
//            self.present(pp, animated: true, completion: nil)
        }

}
