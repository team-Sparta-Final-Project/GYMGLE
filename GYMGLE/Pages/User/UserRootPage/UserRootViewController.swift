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
    let databaseRef = Database.database().reference()

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
        getThisWeek()
    }
    
    @objc func inButtonClick() {
        let QrCodeViewController = QrCodeViewController()
        QrCodeViewController.user = DataManager.shared.userInfo// ❗️수정
        self.present(QrCodeViewController, animated: true)
        databaseRef.child("yourDataNode").child("isInGym").setValue(true) { (error, ref) in
                   if let error = error {
                       print("Firebase 업데이트 오류: \(error.localizedDescription)")
                   } else {
                       print("Firebase 데이터 업데이트 완료: isInGym을 true로 설정")
                   }
               }
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
    
    func getThisWeek() {

        // 데이터베이스 참조에서 'isInGym' 값을 모니터링
        databaseRef.child("userData").child("isInGym").observe(.value) { (snapshot) in
            if let isInGym = snapshot.value as? Bool, isInGym == true {
                // 'isInGym' 값이 true인 경우에만 실행
                // 'nowUserNumber' 값을 가져와 1을 추가하고 다시 데이터베이스에 업데이트
                self.databaseRef.child("userData").child("nowUserNumber").observeSingleEvent(of: .value) { (numberSnapshot) in
                    if var nowUserNumber = numberSnapshot.value as? Int {
                        nowUserNumber += 1
                        self.databaseRef.child("userData").child("nowUserNumber").setValue(nowUserNumber)
                        // 'first.nowUserNumber.text' 업데이트 (메인 스레드에서 실행)
                        DispatchQueue.main.async {
                            self.first.nowUserNumber.text = "\(nowUserNumber)"
//                            퇴실시 -1 되는거랑 , 입실하기 버튼눌렀을때 이 메서드 실행되게 하기.
                        }
                    }
                }
            }
        }
//        위 코드에서 'yourDataNode'을 실제 데이터베이스 경로로 변경해야 합니다. 또한 이 코드에서는 데이터베이스를 모니터링하고, 'isInGym' 값이 true로 변경될 때 'nowUserNumber'를 증가시킵니다. 마지막으로 first.nowUserNumber.text를 업데이트하려면 메인 스레드에서 수행해야 하므로 DispatchQueue.main.async를 사용하여 업데이트 코드를 메인 스레드에서 실행합니다.

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
