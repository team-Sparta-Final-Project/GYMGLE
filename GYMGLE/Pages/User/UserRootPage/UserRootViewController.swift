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
import Firebase


class UserRootViewController: UIViewController {
    let databaseRef = Database.database().reference()
    
    let specificDay = "Monday" // 검색할 요일
    let specificHour = 8 // 검색할 시간 (8시)
    let specificMinute = 0 // 검색할 분 (0분)

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
        //        updateYesterUserNumber { userCount in
        //            DispatchQueue.main.async {
        //                // 'userCount'를 문자열로 변환하고 'first.yesterUserNumber.text'에 할당
        //                self.first.yesterUserNumber.text = String(userCount)
        //            }
        //        }
        
        
        getUsersCountOnSpecificDayAndTime(day: specificDay, hour: specificHour, minute: specificMinute) { count in
            DispatchQueue.main.async {
                self.first.yesterUserNumber.text = String(count)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        let ref = Database.database().reference().child("users/\(DataManager.shared.gymUid!)/gymUserList")
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
//    func getUsersCountOnSpecificDayAndTime(day: String, hour: Int, minute: Int, completion: @escaping (Int) -> Void) {
//        let gymLogRef = databaseRef.child(uid).child("gymInAndOutLog") // 해당 헬스장 UID로 경로 설정
//
//        // 요일, 시간, 분에 해당하는 시간을 계산
//        let calendar = Calendar.current
//        var lastWeek: Date? = calendar.date(byAdding: .day, value: -7, to: Date()) // 현재 날짜로부터 7일 전
//        if let lastWeekUnwrapped = lastWeek {
//            lastWeek = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: lastWeekUnwrapped) // 특정 시간으로 설정
//        }
//        
//        // 특정 요일과 시간과 일치하는 사용자 수 확인
//        gymLogRef.observeSingleEvent(of: .value) { (snapshot) in
//            if snapshot.exists() {
//                var userCount = 0
//                for child in snapshot.children {
//                    if let childSnapshot = child as? DataSnapshot {
//                        let inTime = childSnapshot.childSnapshot(forPath: "inTime").value as? TimeInterval ?? 0
//                        let inDate = Date(timeIntervalSince1970: inTime)
//                        if calendar.isDate(inDate, inSameDayAs: lastWeek) {
//                            userCount += 1
//                        }
//                    }
//                }
//                completion(userCount)
//            } else {
//                completion(0) // 일치하는 데이터가 없는 경우 0을 반환
//            }
//        }
//    }

    // 사용 예시

//    func updateYesterUserNumber(completion: @escaping (Int) -> Void) {
//        //        파이어 베이스의 경로 찾기 / child 를 통해서 하위폴더 조회 가능
//        let gymLogRef = databaseRef.child("gymInAndOutLog")
//        //        날짜 데이터를 받기위한 Calendar 변수선언
//        let calendar = Calendar.current
//        // 현재 날짜 및 시간 가져오기
//        let currentDate = Date()
//        // 이전 주의 시작 날짜 가져오기 (현재 날짜로부터 -7일)
//        let lastWeek = calendar.date(byAdding: .day, value: -7, to: currentDate)!
//        // 요일과 시간대 가져오기 (예: 월요일, 8AM)
//        let day = calendar.component(.weekday, from: lastWeek)
//        let hour = calendar.component(.hour, from: lastWeek)
//        let minute = calendar.component(.minute, from: lastWeek)
//        // 'isInGym'이 True이고 'sinceInAndOutTime'가 0보다 큰 사용자 수 확인
//        gymLogRef.observeSingleEvent(of: .value) { (snapshot) in
//            if snapshot.exists() {
////                user 인원 0 명으로 시작해서 추가되는 형식
//                var userCount = 0
//                for child in snapshot.children {
//                    if let childSnapshot = child as? DataSnapshot, let userData = childSnapshot.value as? [String: Any] {
//                        if let isInGym = userData["isInGym"] as? Bool {
//                            // 현재 요일 및 시간대와 일치하며 'isInGym'이 True이고 'sinceInAndOutTime'이 0보다 큰 경우
////                       calendar.component(.weekday, from: lastWeek) > 날짜의 요일을 가져오는 부분 /                        day는 lastWeek에서 가져온 요일 / hour는 저번주 시간 / minute은 저번주 분
//                            if calendar.component(.weekday, from: lastWeek) == day &&
//                               calendar.component(.hour, from: lastWeek) == hour &&
//                               calendar.component(.minute, from: lastWeek) == minute &&
////        저번주 같은요일 시간 분에 isInGym이 true 였고 , sinceInAndOutTime값이 0보다 컸으면 userCount를 +1
//                               isInGym == true {
////                                userCount를 +1 시키는것을 viewDidLoad에서 비동기작업 실행코드로써 사용
//                                userCount += 1
////                                self.first.yesterUserNumber.text = String(userCount)
//                            }
//                        }
//                    }
//                }
//                // userCount를 이용하여 first.yesterUserNumber.text 값을 업데이트
//                completion(userCount)
//            } else {
//                completion(0) // 일치하는 데이터가 없는 경우 0을 반환
//            }
//        }
//        // 사용 예시
//        updateYesterUserNumber { count in
//            print("저번주 같은 요일과 시간에 'isInGym'이 True인 사용자 수: \(count)")
//            // first.yesterUserNumber.text 업데이트 코드를 여기에 추가
//            // count 값을 사용하여 텍스트 업데이트
//        }

    
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
//    func getUsersCountOnSpecificDayAndTime(day: String, time: String, completion: @escaping (Int) -> Void) {
//        let gymLogRef = databaseRef.child("gymInAndOutLog")
//
//        // 'inTime', 'outTime', 및 'sinceInAndOutTime' 값을 가져오기
//        // 'sinceInAndOutTime' 값이 0보다 큰 경우를 'isGymTrue'로 간주하는 방식
//        gymLogRef.observeSingleEvent(of: .value) { (snapshot) in
//            if snapshot.exists() {
//                var userCount = 0
//
//                for child in snapshot.children {
//                    if let childSnapshot = child as? DataSnapshot, let userData = childSnapshot.value as? [String: Any] {
//                        if let inTime = userData["inTime"] as? TimeInterval,
//                           let outTime = userData["outTime"] as? TimeInterval,
//                           let sinceInAndOutTime = userData["sinceInAndOutTime"] as? Int {
//                            let calendar = Calendar.current
//                            let inDate = Date(timeIntervalSince1970: inTime)
//                            let outDate = Date(timeIntervalSince1970: outTime)
//                            let currentDate = Date()
//                            let lastWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: currentDate)!
//                            // 요일 및 시간대에 해당하는 사용자만 필터링
//                            if calendar.component(.weekday, from: inDate) == inDate.day == && inDate.hour == 8 && inDate.minute == 0{
//                                // 'sinceInAndOutTime'이 0보다 크면 'isGymTrue'인 사용자로 간주
//                                if sinceInAndOutTime > 0 {
//                                    userCount += 1
//                                }
//                            }
//                        }
//                    }
//                }
//                completion(userCount)
//            } else {
//                completion(0) // 일치하는 데이터가 없는 경우 0을 반환
//            }
//        }
//        // 사용 예시
//        getUsersCountOnSpecificDayAndTime(day: "Monday", time: "8AM") { count in
//            print("월요일 8AM에 'isGymTrue'인 사용자 수: \(count)")
//        }
//    }
    
    func setNowUserNumber() {
        let ref = Database.database().reference().child("users").child(DataManager.shared.gymUid!).child("gymUserList")
        let query = ref.queryOrdered(byChild: "isInGym").queryEqual(toValue: true)
        
        query.observeSingleEvent(of: .value) { (snapshot) in
            let count = snapshot.childrenCount
            self.first.nowUserNumber.text = String(count)
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
