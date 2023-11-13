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
    
    // MARK: - properties
    private let adminNoticeView = AdminNoticeView()
    private var viewModel: AdminNoticeViewModel!
    var isAdmin: Bool?
    // MARK: - life cycle
    override func loadView() {
        view = adminNoticeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        allSetting()
        viewModel = AdminNoticeViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        setCustomBackButton()
        viewModel.getNoticeList {
            self.adminNoticeView.noticeTableView.reloadData()
        }
    }
}

// MARK: - extension custom func
private extension AdminNoticeViewController {
    
    func allSetting() {
        adminNoticeView.backgroundColor = ColorGuide.background
        self.adminNoticeView.pageTitleLabel.text = "공지사항"
        buttonTappedSetting()
        tableSetting()
    }
    func buttonTappedSetting() {
        adminNoticeView.noticeCreateButton.addTarget(self, action: #selector(noticeCreateButtonTapped), for: .touchUpInside)
        switch isAdmin {
        case false: 
            adminNoticeView.noticeCreateButton.isHidden = true
        default:
            adminNoticeView.noticeCreateButton.isHidden = false
        }
    }
    func tableSetting() {
        adminNoticeView.noticeTableView.dataSource = self
        adminNoticeView.noticeTableView.delegate = self
        adminNoticeView.noticeTableView.estimatedRowHeight = UITableView.automaticDimension
        adminNoticeView.noticeTableView.rowHeight = UITableView.automaticDimension
        adminNoticeView.noticeTableView.register(AdminNoticeTableViewCell.self, forCellReuseIdentifier: AdminNoticeTableViewCell.identifier)
    }

    func setCustomBackButton() {
        navigationController?.navigationBar.topItem?.title = "공지사항"
        navigationController?.navigationBar.tintColor = .black
    }
}

// MARK: -  @objc func
extension AdminNoticeViewController {
    @objc private func noticeCreateButtonTapped() {
        let adminNoticeDetailVC = AdminNoticeDetailViewController()
        self.navigationController?.pushViewController(adminNoticeDetailVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension AdminNoticeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AdminNoticeTableViewCell.identifier, for: indexPath) as! AdminNoticeTableViewCell

        cell.nameLabel.text = DataManager.shared.realGymInfo?.gymName
        cell.contentLabel.text = viewModel.notice.sorted{ $0.date > $1.date }[indexPath.section].content
        cell.dateLabel.text = viewModel.dateToString(date: viewModel.notice.sorted{ $0.date > $1.date }[indexPath.section].date)
        
        cell.selectionStyle = .none
        return cell
    }
    
}
// MARK: - UITableViewDelegate
extension AdminNoticeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let adminNoticeDetailVC = AdminNoticeDetailViewController()
        adminNoticeDetailVC.isUser = isAdmin
        adminNoticeDetailVC.noticeInfo = viewModel.notice.sorted{ $0.date > $1.date }[indexPath.section]
        navigationController?.pushViewController(adminNoticeDetailVC, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.heightForHeaderInSection
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.isUserInteractionEnabled = false
        header.backgroundColor = UIColor.clear
        header.frame.size.height = 1
        return header
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
