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
        first.outBtn.addTarget(self, action: #selector(outButtonClick), for: .touchUpInside)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        getLastWeek()
        setNowUserNumber()
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
    
    @objc func outButtonClick() {
        let alert = UIAlertController(title: "퇴실하기",
                                      message: "퇴실이 완료되었습니다.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        updateIsInGym(id: (DataManager.shared.userInfo?.account.id)!)
    }
    
    func updateIsInGym(id: String) {
        let ref = Database.database().reference().child("accounts")
        let query = ref.queryOrdered(byChild: "account/id").queryEqual(toValue: id)
        
        query.observeSingleEvent(of: .value) { (snapshot) in
            guard let userSnapshot = snapshot.children.allObjects.first as? DataSnapshot else {
                self.dismiss(animated: true)
                return
            }
            
            if var userData = userSnapshot.value as? [String: Any] {
                userData["isInGym"] = false
                // 해당 유저 정보 업데이트
                userSnapshot.ref.updateChildValues(userData) { (error, _) in
                    if let error = error {
                        print("isInGym 업데이트 오류: \(error.localizedDescription)")
                    } else {
                        print("isInGym이 업데이트되었습니다.")
                    }
                }
            }
        }
    }
    
    //    func getLastWeek() {
    //        let log = DataManager.shared.realGymInfo?.gymInAndOutLog
    //
    //        let currentDate = Date()
    //
    //        let calendar = Calendar.current
    //        let lastWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: currentDate)!
    //
    //        let filteredUsers = log?.filter { user in
    //            let inTime = user.inTime
    //            let outTime = user.outTime
    //            if inTime <= lastWeek && outTime >= lastWeek {
    //                return true
    //            }
    //            return false
    //        }
    //        if let userCount = filteredUsers?.count {
    //            first.yesterUserNumber.text = String(userCount)
    //        }
    //    }
    
    func getLastWeek() {
        
        // 데이터베이스 참조에서 'isInGym' 값을 모니터링
        databaseRef.child("userData").child("isInGym").observe(.value) { (snapshot) in
            if let isInGym = snapshot.value as? Bool, isInGym == false {
                // 'isInGym' 값이 false인 경우에만 실행
                // 'yesterUserNumber' 값을 가져와 1을 추가하고 다시 데이터베이스에 업데이트
                self.databaseRef.child("userData").child("yesterUserNumber").observeSingleEvent(of: .value) { (numberSnapshot) in
                    if var yesterUserNumber = numberSnapshot.value as? Int {
                        yesterUserNumber += 1
                        self.databaseRef.child("userData").child("yesterUserNumber").setValue(yesterUserNumber)
                        // 'first.yesterUserNumber.text' 업데이트 (메인 스레드에서 실행)
                        DispatchQueue.main.async {
                            self.first.yesterUserNumber.text = "\(yesterUserNumber)"
                        }
                    }
                }
            }
        }
    }
    
    func setNowUserNumber() {
        let ref = Database.database().reference().child("accounts")
        let query = ref.queryOrdered(byChild: "adminUid").queryEqual(toValue: DataManager.shared.gymUid)
        
        query.observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            let numberOfUser = data.filter { userSnapshot in
                if let userData = userSnapshot.value as? [String: Any],
                   let isInGym = userData["isInGym"] as? Bool {
                    return isInGym
                }
                return false
            }.count
            
            self.first.nowUserNumber.text = String(numberOfUser)
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
