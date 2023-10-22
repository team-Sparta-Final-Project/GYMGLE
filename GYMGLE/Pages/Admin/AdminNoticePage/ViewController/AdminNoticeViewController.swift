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

    // MARK: - dummyData
    var ref = Database.database().reference()
    private let adminNoticeView = AdminNoticeView()
    var isAdmin: Bool?
    
    //❗️삭제 예정
    private let dataTest = DataManager.shared
    var gymInfo: GymInfo?
    
    override func loadView() {
        view = adminNoticeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allSetting()
        func fireBaseRead() {
            let userID = Auth.auth().currentUser?.uid
            ref.child("users").child(userID!).child("gymInfo").observeSingleEvent(of: .value, with: { snapshot in
                let value = snapshot.value as? NSDictionary
                let noticeList = value?["noticeList"] as? String ?? ""
               print(noticeList)
            }) { error in
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) { // 네비게이션바 보여주기
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
        return dataTest.gymInfo.noticeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AdminNoticeTableViewCell.identifier, for: indexPath) as! AdminNoticeTableViewCell
        var date = dateToString(date: dataTest.gymInfo.noticeList[indexPath.row].date)
        cell.nameLabel.text = gymInfo?.gymName
        cell.contentLabel.text = dataTest.gymInfo.noticeList[indexPath.row].content
        cell.dateLabel.text = date
        
        cell.selectionStyle = .none
        tableView.separatorStyle = .none
        return cell
    }
}

extension AdminNoticeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let adminNoticeDetailVC = AdminNoticeDetailViewController()
        adminNoticeDetailVC.noticeInfo = dataTest.gymInfo.noticeList[indexPath.row]
        navigationController?.pushViewController(adminNoticeDetailVC, animated: true)
    }
}
