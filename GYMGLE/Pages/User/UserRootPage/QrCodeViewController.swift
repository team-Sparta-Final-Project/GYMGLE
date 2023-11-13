//
//  QrCodeViewController.swift
//  GYMGLE
//
//  Created by t2023-m0088 on 2023/10/16.
//

import SnapKit
import UIKit
import Then
import CoreImage.CIFilterBuiltins
import FirebaseAuth
import FirebaseDatabase


final class QrCodeViewController: UIViewController {
    
    private let qrcodeView = QrCodeView()
    var isHidden: Bool = true
    
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
        if DataManager.shared.userInfo?.adminUid == "default" { // 첫 등록 화면 시 큐알 코드
            guard let userUid = Auth.auth().currentUser?.uid else {return}
            let qrCodeImage = generateQRCode(data: "\(userUid)")
            let welcomeName = "사장님께 보여주시면 등록이 됩니다."
            qrcodeView.dataSetting(image: qrCodeImage, text: welcomeName)
            qrcodeView.backButton.isHidden = true
            qrcodeView.deletedUserButton.isHidden = false
            qrcodeView.deletedUserButton.addTarget(self, action: #selector(deletedUserButtonTapped), for: .touchUpInside)
        } else { // 출입 인증 시스템 큐알 코드
            let userId = DataManager.shared.userInfo?.account.id
            let qrCodeImage = generateQRCode(data: "\(userId ?? "")")
            let welcomeName = "\(userId ?? "")님\n 오늘도 즐거운 운동 하세요!"
            qrcodeView.dataSetting(image: qrCodeImage, text: welcomeName)
            qrcodeView.deletedUserButton.isHidden = true
            if isHidden == true {
                qrcodeView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            } else {
                qrcodeView.backButton.isHidden = true
            }
        }
       
    }
    
    func generateQRCode(data: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        let qrData = data
        filter.setValue(qrData.data(using: .utf8), forKey: "inputMessage")
        
        if let qrCodeImage = filter.outputImage {
            let transform = CGAffineTransform(scaleX: 5, y: 5)
            let scaledCIImage = qrCodeImage.transformed(by: transform)
            if let qrCodeCGImage = context.createCGImage(scaledCIImage, from: scaledCIImage.extent) {
                return UIImage(cgImage: qrCodeCGImage)
            }
        }
        return UIImage()
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
            self.deleteAccount {
                self.navigationController?.pushViewController(AdminLoginViewController(), animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
    
    func signOut() { // 로그아웃
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch _ as NSError { }
    }
    
    func deleteAccount(completion: @escaping () -> Void) {
        // 계정 삭제
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if error != nil {
                } else {
                    completion()
                }
            }
            //탈퇴한 헬스장의 유저들 삭제
            let ref = Database.database().reference()
            let query = ref.child("accounts").queryOrdered(byChild: "account/id").queryEqual(toValue: DataManager.shared.userInfo?.account.id)
            query.observeSingleEvent(of: .value) { snapshot in
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot {
                        //snapshot.ref.removeValue()
                    }
                }
            }
            self.signOut()
        } else {}
        completion()
    }
    
}
