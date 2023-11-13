//
//  AdminRootViewModel.swift
//  GYMGLE
//
//  Created by 박성원 on 11/10/23.
//

import FirebaseAuth
import FirebaseDatabase
import UIKit


protocol AdminRootViewModelDelegate: AnyObject {
    func navigationVC(VC: UIViewController)
    func deleteGym()
    func presentWebView(url: String)
}

final class AdminRootViewModel {
    
    weak var delegate: AdminRootViewModelDelegate?
    
    var dataManager: DataManager
    
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            dataManager.realGymInfo = nil
        } catch _ as NSError { }
    }
    
    func deleteAccount() {
        // 계정 삭제
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if error != nil {
                } else {
                    self.delegate?.navigationVC(VC: AdminLoginViewController())
                }
            }
            //탈퇴한 헬스장의 유저들 삭제
            let ref = Database.database().reference()
            let query = ref.child("accounts").queryOrdered(byChild: "adminUid").queryEqual(toValue: dataManager.gymUid!)
            query.observeSingleEvent(of: .value) { snapshot in
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot {
                        snapshot.ref.removeValue()
                    }
                }
            }
            // 헬스장 관리자를 데이터베이스에서 삭제
            let userRef = Database.database().reference().child("users").child(user.uid)
            userRef.removeValue()
            self.signOut()
        } else {}
    }
    
    func didSelectCell(index: IndexPath) {
        switch (index.section, index.row) {
        case (0, 0):
            delegate?.navigationVC(VC: AdminNoticeViewController())
            break
        case (0, 1):
            delegate?.navigationVC(VC: UserRegisterViewController())
            break
        case (0, 2):
            delegate?.navigationVC(VC: UserManageViewController())
            break
        case (0, 3):
            delegate?.navigationVC(VC: QRcodeCheckViewController())
            break
        case (0, 4):
            let adminRegisterVC = AdminRegisterViewController()
            adminRegisterVC.gymInfo = DataManager.shared.realGymInfo
            delegate?.navigationVC(VC: adminRegisterVC)
            break
        case (0, 5):
            delegate?.deleteGym()
            break
        case (1, 0):
            delegate?.presentWebView(url: "https://difficult-shock-122.notion.site/e56d3be418464be0b3262bff1afaeaca?pvs=4")

            break
        case (1, 1):
             delegate?.presentWebView(url:"https://difficult-shock-122.notion.site/f5ff3433117749c5a8bdc527eff556d1")
            break
        default:
            break
        }
    }
}
