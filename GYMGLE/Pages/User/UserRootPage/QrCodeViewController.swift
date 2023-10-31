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


final class QrCodeViewController: UIViewController {
    
    private let qrcodeView = QrCodeView()
    lazy var dataTest = DataManager.shared
    var isHidden: Bool = true
    var user: User?
    
    override func loadView() {
        view = qrcodeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuredView()
        view.backgroundColor = ColorGuide.userBackGround
    }
}

private extension QrCodeViewController {
    
    func configuredView() {
        let userId = DataManager.shared.userInfo?.account.id
        let qrCodeImage = generateQRCode(data: "\(userId ?? "")")
        let welcomeName = "\(userId ?? "")님\n 오늘도 즐거운 운동 하세요!"
        qrcodeView.dataSetting(image: qrCodeImage, text: welcomeName)
        if isHidden == true {
            qrcodeView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        } else {
            qrcodeView.backButton.isHidden = true
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
}
