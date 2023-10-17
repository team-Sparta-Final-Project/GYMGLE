//
//  AdminNoticeViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/14.
//

import UIKit

final class AdminNoticeViewController: UIViewController {

    // MARK: - dummyData
    private let dummyDataManager = DataTest()
    var dummyDataList: [GymInfo] = []

    private let adminNoticeView = AdminNoticeView()
    
    override func loadView() {
        view = adminNoticeView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        allSetting()
        dummyDataList.append(dummyDataManager.test)
        print(dummyDataList[0].noticeList)
        adminNoticeView.noticeTableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) { // 네비게이션바 보여주기
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
        return dummyDataList.first(where: {$0.gymName == "만나짐"})!.noticeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AdminNoticeTableViewCell.identifier, for: indexPath) as! AdminNoticeTableViewCell
        var date = dateToString(date: dummyDataList.first(where: {$0.gymName == "만나짐"})!.noticeList[indexPath.row].date)
        cell.nameLabel.text = "만나짐"
        cell.contentLabel.text = dummyDataList.first(where: {$0.gymName == "만나짐"})!.noticeList[indexPath.row].content
        cell.dateLabel.text = date
        
        cell.selectionStyle = .none
        tableView.separatorStyle = .none
        return cell
    }
}

extension AdminNoticeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // 클릭 시 코드 구현❗️
    }
}
