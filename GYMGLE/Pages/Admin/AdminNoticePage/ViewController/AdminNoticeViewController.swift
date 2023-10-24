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
    private let ref = Database.database().reference()
    private let userID = Auth.auth().currentUser?.uid
    
    override func loadView() {
        view = adminNoticeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allSetting()
        print("ddd")
        ref.child("users/\(userID!)/noticeList").observeSingleEvent(of: .value) { DataSnapshot in
            guard let value = DataSnapshot.value as? [String:[String:Any]] else { return }
            do {
                let jsonArray = value.values.compactMap { $0 as? [String: Any] }
                let jsonData = try JSONSerialization.data(withJSONObject: jsonArray)
                let notices = try JSONDecoder().decode([Notice].self, from: jsonData)
                DataManager.shared.noticeList = notices
                
            } catch let error {
                print("테스트 - \(error)")
            }
        }
        adminNoticeView.noticeTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
       
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
        return DataManager.shared.noticeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AdminNoticeTableViewCell.identifier, for: indexPath) as! AdminNoticeTableViewCell
        ref.child("users/\(userID!)/gymInfo").observeSingleEvent(of: .value) { DataSnapshot in
            guard let value = DataSnapshot.value as? [String:Any] else { return }
            guard let gymName = value["gymName"] as? String else {return}
        }
        cell.nameLabel.text = DataManager.shared.realGymInfo?.gymName
        cell.contentLabel.text = DataManager.shared.noticeList.sorted{ $0.date > $1.date }[indexPath.row].content
        cell.dateLabel.text = self.dateToString(date: DataManager.shared.noticeList.sorted{ $0.date > $1.date }[indexPath.row].date)
        
       
        cell.selectionStyle = .none
        tableView.separatorStyle = .none
        return cell
    }
    
}

extension AdminNoticeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let adminNoticeDetailVC = AdminNoticeDetailViewController()
        adminNoticeDetailVC.noticeInfo = DataManager.shared.noticeList.sorted{ $0.date > $1.date }[indexPath.row]
        navigationController?.pushViewController(adminNoticeDetailVC, animated: true)
    }
    
}
