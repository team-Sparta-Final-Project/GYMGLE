//
//  AdminRootViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/13.
//

import UIKit
import SafariServices
import Combine

final class AdminRootViewController: UIViewController, SFSafariViewControllerDelegate {
    
    // MARK: - properties
    
    private let adminRootView = AdminRootView()
    lazy var viewModel: AdminRootViewModel = AdminRootViewModel()
    lazy var loginViewModel = LoginViewModel()
    weak var delegate: AdminTableViewDelegate?
    var disposableBag = Set<AnyCancellable>()
    
    // MARK: - life cycle
    override func loadView() {
        view = adminRootView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            switch (indexPath.section, indexPath.row) {
            case (0, 0):
                // 공지사항을 선택한 경우
                self.navigationController?.pushViewController(AdminNoticeViewController(), animated: true)
                break
            case (0, 1):
                // 회원관리를 선택한 경우
                self.navigationController?.pushViewController(UserManageViewController(), animated: true)
                break
            case (0, 2):
                // QR스캐너를 선택한 경우
                self.navigationController?.pushViewController(QRcodeCheckViewController(), animated: true)
                break
            case (0, 3):
                // 정보변경을 선택한 경우
                let adminRegisterVC = AdminRegisterViewController()
                adminRegisterVC.viewModel.gymInfo = self.viewModel.dataManager.realGymInfo
                self.navigationController?.pushViewController(adminRegisterVC, animated: true)
                break
            case (0, 4):
                // 비밀번호 재설정
                guard let userEmail = viewModel.userEmail else { return }
                loginViewModel.resetPassword(email: userEmail) { [weak self] reset in
                    if reset {
                        let alert = UIAlertController(title: "비밀번호 재설정", message: "비밀번호 재설정 이메일이 전송되었습니다. 이메일을 확인해주세요.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default))
                        self?.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "비밀번호 재설정", message: "비밀번호 재설정 이메일 전송에 실패했습니다..", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default))
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
                break
            case (0, 5):
                self.viewModel.$isAdmin.sink { [weak self] isAdmin in
                    guard let self = self else { return }
                    if isAdmin == false {
                        showToast(message: "이 아이디는 탈퇴할 수 없습니다!", view: self.view, bottomAnchor: -120, widthAnchor: 220, heightAnchor: 30)
                    } else {
                        let alert = UIAlertController(title: "계정 탈퇴",
                                                      message: "정말로 계정 탈퇴를 하시겠습니까?",
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                            self.viewModel.deleteAccount { result in
                                switch result {
                                case .success:
                                    self.navigationController?.pushViewController(AdminLoginViewController(), animated: true)
                                case .failure:
                                    self.showToast(message: "삭제하지 못했습니다.", view: self.view, bottomAnchor: -120, widthAnchor: 260, heightAnchor: 40)
                                }
                            }
                        }))
                        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
                        present(alert, animated: true, completion: nil)
                    }
                }.store(in: &disposableBag)
                break
            case (1, 0):
                guard let url = URL(string: "https://difficult-shock-122.notion.site/e56d3be418464be0b3262bff1afaeaca?pvs=4")   else { return }
                let safariViewController = SFSafariViewController(url: url)
                safariViewController.delegate = self
                safariViewController.modalPresentationStyle = .fullScreen
                self.present(safariViewController, animated: true, completion: nil)
                break
            case (1, 1):
                guard let url = URL(string: "https://difficult-shock-122.notion.site/f5ff3433117749c5a8bdc527eff556d1")   else { return }
                let safariViewController = SFSafariViewController(url: url)
                safariViewController.delegate = self
                safariViewController.modalPresentationStyle = .fullScreen
                self.present(safariViewController, animated: true, completion: nil)
                break
            default:
                break
        }
    }
}


