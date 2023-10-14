//
//  AdminNoticeViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/14.
//

import UIKit

final class AdminNoticeViewController: UIViewController {

    private let adminNoticeView = AdminNoticeView()
    
    override func loadView() {
        view = adminNoticeView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        allSetting()
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
        //adminNoticeView.noticeTableView.dataSource = self
        adminNoticeView.noticeTableView.delegate = self
        //adminNoticeView.noticeTableView.register(AdminNoticeViewController.self, forCellReuseIdentifier: "MovieCell")
    }
}

// MARK: -  @objc func

extension AdminNoticeViewController {
    @objc private func noticeCreateButtonTapped() {
        let adminNoticeDetailVC = AdminNoticeDetailViewController()
        self.navigationController?.pushViewController(adminNoticeDetailVC, animated: true)
    }
}

//extension AdminNoticeViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return UITableViewCell()
//    }
//}

extension AdminNoticeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
