//
//  UserRootViewController.swift
//  GYMGLE
//
//  Created by t2023-m0088 on 2023/10/13.
//

import SnapKit
import UIKit
import SwiftUI
import FirebaseDatabase

class UserRootViewController: UIViewController {
    
    let first = UserRootView()
//    var user: User?
//    var gymInfo: GymInfo?
    
    
    override func loadView() {
        view = first
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        first.inBtn.addTarget(self, action: #selector(inButtonClick), for: .touchUpInside)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLastWeek()
        
    }
    
    @objc func inButtonClick() {
        let QrCodeViewController = QrCodeViewController()
        QrCodeViewController.user = DataManager.shared.userInfo// ❗️수정
        self.present(QrCodeViewController, animated: true)
    }
    
    func getLastWeek() {
        let log = DataManager.shared.realGymInfo?.gymInAndOutLog
        
        let currentDate = Date()
        
        let calendar = Calendar.current
        let lastWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: currentDate)!
        
        let filteredUsers = log?.filter { user in
            let inTime = user.inTime
            let outTime = user.outTime
            if inTime <= lastWeek && outTime >= lastWeek {
                return true
            }
            return false
        }
        if let userCount = filteredUsers?.count {
            first.yesterUserNumber.text = String(userCount)
        }
    }
}

//#if DEBUG
//
//struct ViewControllerRepresentable: UIViewControllerRepresentable{
//
//    //    update
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//
//    }
//    @available(iOS 13.0, *)
//    func makeUIViewController(context: Context) -> UIViewController {
//        UserRootViewController()
//    }
//    //    makeui
//
//}
//
//
//struct ViewController_Previews: PreviewProvider{
//    static var previews: some View{
//        ViewControllerRepresentable()
//            .previewDisplayName("아이폰 14")
//
//    }
//}
//
//
//#endif
