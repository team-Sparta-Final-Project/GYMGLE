//
//  QrCodeViewModel.swift
//  GYMGLE
//
//  Created by 박성원 on 11/14/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

final class QrCodeViewModel: ObservableObject { //ObservableObject: 이벤트를 방출할 수 있는 인스턴스 (해당 인스턴스를 Subscriber가 구독하여 사용할 수 있다는 의미)
    
    @Published var isHidden: Bool = true
    var dataManager: DataManager
    
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
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
                        snapshot.ref.removeValue()
                    }
                }
            }
            self.signOut()
        } else {}
        completion()
    }
    
}
