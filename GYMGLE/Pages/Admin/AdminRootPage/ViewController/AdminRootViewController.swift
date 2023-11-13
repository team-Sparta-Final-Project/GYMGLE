//
//  AdminRootViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/13.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import SafariServices

final class AdminRootViewController: UIViewController, SFSafariViewControllerDelegate {
    
    // MARK: - properties
    
    private let adminRootView = AdminRootView()
    private var viewModel: AdminRootViewModel!
    
    var isAdmin: Bool?
    
    // MARK: - life cycle
    override func loadView() {
        view = adminRootView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AdminRootViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        configuredView()
    }
}

// MARK: - extension
private extension AdminRootViewController {
    func configuredView() {
        navigationController?.navigationBar.isHidden = true
        adminRootView.adminTableView.adminRootDelegate = self
        viewModel?.delegate = self
        guard let gymName = viewModel.dataManager.realGymInfo?.gymName, let gymPhoneNumber = viewModel.dataManager.realGymInfo?.gymPhoneNumber else { return }
        adminRootView.dataSetting("\(gymName)", "\(gymPhoneNumber)")
        allButtonTapped()
    }
    
    func allButtonTapped() {
        adminRootView.gymSettingButton.addTarget(self, action: #selector(gymSettingButtonTapped), for: .touchUpInside)
    }
}

// MARK: - @objc func
extension AdminRootViewController {
    @objc private func gymSettingButtonTapped() {
        let alert = UIAlertController(title: "로그아웃",
                                      message: "로그아웃 하시겠습니까?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.viewModel.signOut()
            self.dismiss(animated: true) {
                let vc = AdminLoginViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
}

extension AdminRootViewController: AdminTableViewDelegate {
    func didSelectCell(at indexPath: IndexPath) {
        viewModel?.didSelectCell(index: indexPath)
    }
}

// MARK: - AdminRootViewModelDelegate
extension AdminRootViewController: AdminRootViewModelDelegate {
    func presentWebView(url: String) {
        guard let appleUrl = URL(string: url)   else { return }
        let safariViewController = SFSafariViewController(url: appleUrl)
        safariViewController.delegate = self
        safariViewController.modalPresentationStyle = .fullScreen
        self.present(safariViewController, animated: true, completion: nil)
    }
    func navigationVC(VC: UIViewController) {
        self.navigationController?.pushViewController(VC, animated: true)
    }
    func deleteGym() {
        if isAdmin == false {
            showToast(message: "이 아이디는 탈퇴할 수 없습니다!", view: self.view, bottomAnchor: -120, widthAnchor: 220, heightAnchor: 30)
        } else {
            let alert = UIAlertController(title: "계정 탈퇴",
                                          message: "정말로 계정 탈퇴를 하시겠습니까?",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                self.viewModel?.deleteAccount()
            }))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            present(alert, animated: true, completion: nil)
        }
    }
}
