//
//  AdminNoticeViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/14.
//

import UIKit
import Combine

final class AdminNoticeViewController: UIViewController {
    
    // MARK: - properties
    private let adminNoticeView = AdminNoticeView()
    var viewModel: AdminNoticeViewModel = AdminNoticeViewModel()
    var disposableBag = Set<AnyCancellable>()

    // MARK: - life cycle
    override func loadView() {
        view = adminNoticeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        allSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        setCustomBackButton()
        viewModel.getNoticeList { result in
            switch result {
            case .success:
                self.adminNoticeView.noticeTableView.reloadData()
            case .failure:
                self.showToast(message: "공지사항을 불러오지 못했습니다.", view: self.view, bottomAnchor: -120, widthAnchor: 260, heightAnchor: 40)
            }
        }
    }
}

// MARK: - extension custom func
private extension AdminNoticeViewController {
    
    func allSetting() {
        adminNoticeView.backgroundColor = ColorGuide.background
        buttonTappedSetting()
        tableSetting()
    }
    func buttonTappedSetting() {
        adminNoticeView.noticeCreateButton.addTarget(self, action: #selector(noticeCreateButtonTapped), for: .touchUpInside)
        self.viewModel.$isAdmin.sink { isAdmin in
            switch isAdmin {
            case false:
                self.adminNoticeView.noticeCreateButton.isHidden = true
            default:
                self.adminNoticeView.noticeCreateButton.isHidden = false
            }
        }.store(in: &disposableBag)
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
        return  viewModel.noticeList.count == 0 ? 0 : viewModel.numberOfRowsInSection
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.noticeList.count == 0 ? 0 : viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AdminNoticeTableViewCell.identifier, for: indexPath) as! AdminNoticeTableViewCell
        if viewModel.noticeList.count == 0 {
            return UITableViewCell()
        }
        
        cell.nameLabel.text = viewModel.dataManager.realGymInfo?.gymName
        cell.contentLabel.text = viewModel.noticeList.sorted{ $0.date > $1.date }[indexPath.section].content
        cell.dateLabel.text = viewModel.dateToString(date: viewModel.noticeList.sorted{ $0.date > $1.date }[indexPath.section].date)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AdminNoticeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let adminNoticeDetailVC = AdminNoticeDetailViewController()
        adminNoticeDetailVC.viewModel.isUser = viewModel.isAdmin
        adminNoticeDetailVC.viewModel.noticeInfo = viewModel.noticeList.sorted{ $0.date > $1.date }[indexPath.section]
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
