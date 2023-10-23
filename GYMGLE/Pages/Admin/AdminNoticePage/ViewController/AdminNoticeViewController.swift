//
//  AdminNoticeViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/14.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

final class AdminNoticeViewController: UIViewController {
    

    private let adminNoticeView = AdminNoticeView()
    var isAdmin: Bool?
    
    override func loadView() {
        view = adminNoticeView
    }

//    userRef.observeSingleEvent(of: .value) { (snapshot)  in
//        if let userData = snapshot.value as? [String: Any],
//           let gymInfoJSON = userData["gymInfo"] as? [String: Any],
//            let gymAccount = gymInfoJSON["gymAccount"] as? [String: Any],
//            let accountType = gymAccount["accountType"] as? Int {
//            if accountType == 0 {
//                do {
//                    let gymInfoData = try JSONSerialization.data(withJSONObject: gymInfoJSON, options: [])
//                    let gymInfo = try JSONDecoder().decode(GymInfo.self, from: gymInfoData)
//                    DataManager.shared.realGymInfo = gymInfo
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allSetting()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        adminNoticeView.noticeTableView.reloadData()
     
    }
}

// MARK: - extension
private extension AdminNoticeViewController {
    func allSetting() {
        adminNoticeView.backgroundColor = UIColor.white
        buttonTappedSetting()
        tableSetting()
    }
    func buttonTappedSetting() {
        adminNoticeView.noticeCreateButton.addTarget(self, action: #selector(noticeCreateButtonTapped), for: .touchUpInside)
        //        switch isAdmin {
        //        case false: //트레이너 일 때
        //            adminNoticeView.noticeCreateButton.isHidden = true
        //        default:
        //            adminNoticeView.noticeCreateButton.isHidden = false
        //        }
    }
    func tableSetting() {
        adminNoticeView.noticeTableView.dataSource = self
        adminNoticeView.noticeTableView.delegate = self
        adminNoticeView.noticeTableView.estimatedRowHeight = UITableView.automaticDimension
        adminNoticeView.noticeTableView.rowHeight = UITableView.automaticDimension
        adminNoticeView.noticeTableView.register(AdminNoticeTableViewCell.self, forCellReuseIdentifier: AdminNoticeTableViewCell.identifier)
    }
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .full
        formatter.dateFormat = "MM/dd"
        
        return formatter.string(from: date)
    }
    
}

// MARK: -  @objc func

extension AdminNoticeViewController {
    @objc private func noticeCreateButtonTapped() {
        let adminNoticeDetailVC = AdminNoticeDetailViewController()
        self.navigationController?.pushViewController(adminNoticeDetailVC, animated: true)
    }
}

extension AdminNoticeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let noticeList = DataManager.shared.realGymInfo?.noticeList else {return 1 }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AdminNoticeTableViewCell.identifier, for: indexPath) as! AdminNoticeTableViewCell

        if let gymInfo = DataManager.shared.realGymInfo {
            cell.nameLabel.text = gymInfo.gymName
//            cell.contentLabel.text = gymInfo.noticeList[indexPath.row].content
//            cell.dateLabel.text = dateToString(date: gymInfo.noticeList[indexPath.row].date)
        }

        cell.selectionStyle = .none
        tableView.separatorStyle = .none
        return cell
    }
    
}

extension AdminNoticeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let adminNoticeDetailVC = AdminNoticeDetailViewController()
//        adminNoticeDetailVC.noticeInfo = DataManager.shared.realGymInfo?.noticeList[indexPath.row]
        adminNoticeDetailVC.index = indexPath.row
        navigationController?.pushViewController(adminNoticeDetailVC, animated: true)
    }
    
}
