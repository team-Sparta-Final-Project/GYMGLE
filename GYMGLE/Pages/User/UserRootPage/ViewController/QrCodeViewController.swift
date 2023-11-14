//
//  QrCodeViewController.swift
//  GYMGLE
//
//  Created by t2023-m0088 on 2023/10/16.
//


import UIKit
import CoreImage.CIFilterBuiltins
import Combine
import FirebaseAuth

final class QrCodeViewController: UIViewController {
    
    private let qrcodeView = QrCodeView()
    var viewModel: QrCodeViewModel = QrCodeViewModel()
    var disposableBag = Set<AnyCancellable>()
    
    override func loadView() {
        view = qrcodeView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configuredView()
    }

}

private extension QrCodeViewController {
    
    func configuredView() {
        if self.viewModel.dataManager.userInfo?.adminUid == "임시" { // 첫 등록 화면 시 큐알 코드
            guard let userUid = Auth.auth().currentUser?.uid else {return}
            let qrCodeImage = viewModel.generateQRCode(data: "\(userUid)")
            let welcomeName = "사장님께 보여주시면 등록이 됩니다."
            qrcodeView.dataSetting(image: qrCodeImage, text: welcomeName)
            qrcodeView.backButton.isHidden = true
            qrcodeView.deletedUserButton.isHidden = false
            qrcodeView.deletedUserButton.addTarget(self, action: #selector(deletedUserButtonTapped), for: .touchUpInside)
        } else { // 출입 인증 시스템 큐알 코드
            let userId = DataManager.shared.userInfo?.account.id
            let qrCodeImage = viewModel.generateQRCode(data: "\(userId ?? "")")
            let welcomeName = "\(userId ?? "")님\n 오늘도 즐거운 운동 하세요!"
            qrcodeView.dataSetting(image: qrCodeImage, text: welcomeName)
            qrcodeView.deletedUserButton.isHidden = true
            self.viewModel.$isHidden.sink(receiveValue: { [weak self] in
                guard let self else { return }
               if $0 == true {
                   self.qrcodeView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
               } else {
                   self.qrcodeView.backButton.isHidden = true
               }
            }).store(in: &disposableBag)
        }
    }
}

// MARK: -  @objc private func
extension QrCodeViewController {
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    @objc private func deletedUserButtonTapped() {
        let alert = UIAlertController(title: "계정 탈퇴",
                                      message: "정말로 계정 탈퇴를 하시겠습니까?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.viewModel.deleteAccount {
                self.navigationController?.pushViewController(AdminLoginViewController(), animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
}
