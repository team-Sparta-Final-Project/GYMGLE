//
//  UserRootViewController.swift
//  GYMGLE
//
//  Created by t2023-m0088 on 2023/10/13.
//

import SnapKit
import UIKit
import SwiftUI

class UserRootViewController: UIViewController {
    
    let first = UserRootView()
    var userListArray: [User] = []
    let userDataManager = UserDataManager()
    override func loadView() {
        view = first
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        first.inBtn.addTarget(self, action: #selector(inButtonClick), for: .touchUpInside)
        userDataManager.makeUserList()
        userListArray = userDataManager.getUserList()
        print(userListArray)
        dataSetting()
    }
    
    @objc func inButtonClick(){
        let QrCodeViewController = QrCodeViewController()
        
        self.present(QrCodeViewController, animated: true)
    }
    
    func dataSetting() {
        var name = userListArray[0].name //김기호
        var gymInCount = String(userListArray.filter{$0.isInGym == true}.count) // 4
        
        
        first.userDataSetting(userName: name, gymInUserCount: gymInCount, yesterUserCount: "22")
    }
    
    
    
}
    


//시간 차이나오게 하는 코드
//let timeDifference = endSubscriptionDate.timeIntervalSince(startSubscriptionDate)

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
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
