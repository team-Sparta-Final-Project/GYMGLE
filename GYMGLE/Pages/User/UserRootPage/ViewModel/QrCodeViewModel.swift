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
    @Published var adminUid: String = ""
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
    
    func deleteAccount(completion: @escaping () -> ()) {
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if let error = error {
                    print("delete Error : ", error)
                } else {
                    self.signOut()
                    let userRef = Database.database().reference().child("accounts").child(user.uid)
                    userRef.removeValue()
                    completion()
                }
            }
        } else {}
    }
    
    func getAdminUid() {
        let ref = Database.database().reference().child("accounts")
        ref.child("\(Auth.auth().currentUser!.uid)").child("adminUid").observeSingleEvent(of: .value) { DataSnapshot in
            if let value = DataSnapshot.value as? String {
                self.adminUid = value
            }
        }
    }
    
    func observe(_ completion: @escaping () -> ()){
        let ref = Database.database().reference()
        ref.child("accounts/\(Auth.auth().currentUser!.uid)/adminUid").observe(.value) { snapshot in
            guard let value = snapshot.value as? String else {return}
            if value != "임시"{
                ref.removeAllObservers()
                completion()
            }
            
        }
    }

}
