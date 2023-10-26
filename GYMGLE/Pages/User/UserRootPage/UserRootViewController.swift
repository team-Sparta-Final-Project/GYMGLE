//
//  UserRootViewController.swift
//  GYMGLE
//
//  Created by t2023-m0088 on 2023/10/13.
//

import SnapKit
import UIKit
import SwiftUI
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth

class UserRootViewController: UIViewController {
    let databaseRef = Database.database().reference()
    
    let first = UserRootView()
    //    var user: User?
    //    var gymInfo: GymInfo?
    var num = 0
    var totalExerciseForUser: Double = 0
    var totalExercise: Double = 0
    var totalUserCount: Double = 0
    
    override func loadView() {
        view = first
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        first.inBtn.addTarget(self, action: #selector(inButtonClick), for: .touchUpInside)
        first.outBtn.addTarget(self, action: #selector(outButtonClick), for: .touchUpInside)
        // 테스트데이터생성기
        decoyLogMaker()
        getLastWeekUserNumber()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        getLastWeek()
        //        setNowUserNumber()
        checkEndSub()
        calculateTotalExerciseTimeForUser() {
            self.calculateTotalExerciseTime {
                self.getTotalUserCount {
                    let average = self.totalExercise / self.totalUserCount
                    let times = (self.totalExerciseForUser / average - 1) * 100
                    let roundedTimes = times.rounded()
                    if roundedTimes >= 0 {
                        self.first.chartMidText.text = String("평균보다 \(roundedTimes)% 많습니다!")
                    } else {
                        self.first.chartMidText.text = String("평균보다 \(abs(roundedTimes))% 적습니다.")
                        self.first.chartBottomText.text = "꾸준함이 중요하죠!"
                    }
                }
            }
        }
        
        let timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(gogogo), userInfo: nil, repeats: true)
        //공지사항 읽어옴
        noticeRead {
            self.first.noticeText.text = DataManager.shared.noticeList[0].content
        }
    }
    
    
    @objc func gogogo(){
        getWorkingUser {
            self.first.nowUserNumber.text = "\(self.num)"
            
        }
    }
    
    @objc func inButtonClick() {
        let QrCodeViewController = QrCodeViewController()
        QrCodeViewController.user = DataManager.shared.userInfo// ❗️수정
        self.present(QrCodeViewController, animated: true)
    }
    
    @objc func outButtonClick() {
        updateIsInGym(id: (DataManager.shared.userInfo?.account.id)!)
        let alert = UIAlertController(title: "퇴실하기",
                                      message: "퇴실이 완료되었습니다.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateIsInGym(id: String) {
        let ref = Database.database().reference().child("users/\(DataManager.shared.gymUid!)/gymInAndOutLog")
        let query = ref.queryOrdered(byChild: "id").queryEqual(toValue: id)
        
        query.observeSingleEvent(of: .value) { (snapshot) in
            for childSnapshot in snapshot.children {
                guard let snapshot = childSnapshot as? DataSnapshot,
                      var logData = snapshot.value as? [String: Any],
                      let outTime = logData["outTime"] as? TimeInterval else {
                    continue
                }
                
                if outTime > Date().timeIntervalSinceReferenceDate {
                    logData["outTime"] = Date().timeIntervalSinceReferenceDate
                    
                    snapshot.ref.updateChildValues(logData) { (error, _) in
                        if let error = error {
                            print("outTime 업데이트 오류: \(error.localizedDescription)")
                        } else {
                            print("outTime이 업데이트되었습니다.")
                        }
                    }
                    
                }
            }
        }
    }
    // 등록기간 만료시 accountType 변경
    func checkEndSub() {
        if DataManager.shared.userInfo!.endSubscriptionDate < Date() {
            let ref = Database.database().reference().child("accounts/\(Auth.auth().currentUser!.uid)/account")
            
            ref.updateChildValues(["accountType": 3])
            first.inBtn.isEnabled = false
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
    
    func noticeRead(completion: @escaping() -> Void) {
        databaseRef.child("users/\(DataManager.shared.gymUid!)/noticeList").observeSingleEvent(of: .value) { DataSnapshot in
            guard let value = DataSnapshot.value as? [String:[String:Any]] else { return }
            do {
                let jsonArray = value.values.compactMap { $0 as [String: Any] }
                let jsonData = try JSONSerialization.data(withJSONObject: jsonArray)
                let notices = try JSONDecoder().decode([Notice].self, from: jsonData)
                DataManager.shared.noticeList = notices
                completion()
            } catch {
                completion()
            }
        }
    }
    
    //    Date().timeIntervalSinceReferenceDate > 파이어 베이스에 저장되는 타입
    //    Date().timeIntervalSinceNow > 현재시간
    
    func getLastWeekUserNumber(day: Int? = nil, hour: Int? = nil, minute: Int? = nil) {
        let oneWeekAgo = Date().addingTimeInterval(-7*24*60*60).timeIntervalSinceReferenceDate
        let ref = Database.database().reference().child("users").child(DataManager.shared.gymUid!).child("gymInAndOutLog")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            let numberOfUser = data.filter { userSnapshot in
                if let userData = userSnapshot.value as? [String: Any],
                   let inTime = userData["inTime"] as? TimeInterval,
                   let outTime = userData["outTime"] as? TimeInterval {
                    if inTime <= oneWeekAgo && outTime >= oneWeekAgo {
                        return true
                    }
                }
                return false
            }.count
            self.first.yesterUserNumber.text = String(numberOfUser)
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
    
    func decoyLogMaker(){
        //        let user = Auth.auth().currentUser
        //        let userUid = user?.uid ?? ""
        //
        //        let oneDay:Double = 60*60*24
        //        let oneWeek:Double = oneDay*7
        //        for i in 1...10 {
        //            let userLog = InAndOut(id: "1분후 테스트", inTime: Date(), outTime: Date(timeIntervalSinceNow: Double(5*i)), sinceInAndOutTime: 0.0)
        //            do {
        //                let userData = try JSONEncoder().encode(userLog)
        //                let userJSON = try JSONSerialization.jsonObject(with: userData, options: [])
        //                databaseRef.child("users/\(DataManager.shared.gymUid!)/gymInAndOutLog").childByAutoId().setValue(userJSON)
        //
        //
        //            }catch{
        //                print("테스트 - 캐치됨")
        //            }
        //        }
        
        //서버에 올리기 테스트
        
        
        
        
    }
    
    
    func getWorkingUser( completion: @escaping () -> () ){
        //        let refDateNow = Date().timeIntervalSinceReferenceDate
        //
        //        databaseRef.child("users/\(DataManager.shared.gymUid!)/gymInAndOutLog").queryOrdered(byChild: "outTime").queryStarting(afterValue: refDateNow ).observeSingleEvent(of: .value) { DataSnapshot in
        //            guard let value = DataSnapshot.value as? [String:Any] else { return }
        //            //print("테스트 - \(value)")
        //            self.num = value.values.count
        //            completion()
        //        }
    }
    
    func calculateTotalExerciseTimeForUser(completion: @escaping () -> Void) {
        let ref = Database.database().reference().child("users/\(DataManager.shared.gymUid!)/gymInAndOutLog")
        
        let oneWeekAgo = Date().addingTimeInterval(-7*24*60*60).timeIntervalSinceReferenceDate
        
        let query = ref.queryOrdered(byChild: "id").queryEqual(toValue: DataManager.shared.userInfo?.account.id)
        
        query.observeSingleEvent(of: .value) { (snapshot) in
            var totalExerciseTime: TimeInterval = 0
            
            for childSnapshot in snapshot.children {
                guard let snapshot = childSnapshot as? DataSnapshot,
                      let logData = snapshot.value as? [String: Any],
                      let inTime = logData["inTime"] as? TimeInterval,
                      let outTime = logData["outTime"] as? TimeInterval else {
                    continue
                }
                
                if outTime > oneWeekAgo {
                    let exerciseTime = outTime - inTime
                    totalExerciseTime += exerciseTime
                }
            }
            self.totalExerciseForUser = totalExerciseTime
            completion()
        }
    }
    
    func calculateTotalExerciseTime(completion: @escaping () -> Void) {
        let ref = Database.database().reference().child("users/\(DataManager.shared.gymUid!)/gymInAndOutLog")
        
        let oneWeekAgo = Date().addingTimeInterval(-7*24*60*60).timeIntervalSinceReferenceDate
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            var totalExerciseTime: TimeInterval = 0
            
            for childSnapshot in snapshot.children {
                guard let snapshot = childSnapshot as? DataSnapshot,
                      let logData = snapshot.value as? [String: Any],
                      let inTime = logData["inTime"] as? TimeInterval,
                      let outTime = logData["outTime"] as? TimeInterval else {
                    continue
                }
                
                if outTime > oneWeekAgo {
                    let exerciseTime = outTime - inTime
                    totalExerciseTime += exerciseTime
                }
            }
            self.totalExercise = totalExerciseTime
            completion()
        }
    }
    
    func getTotalUserCount(completion: @escaping () -> Void) {
        let ref = Database.database().reference().child("accounts")
        let query = ref.queryOrdered(byChild: "adminUid").queryEqual(toValue: DataManager.shared.gymUid)
        
        query.observeSingleEvent(of: .value) { (snapshot) in
            let count = snapshot.childrenCount
            self.totalUserCount = Double(count)
            completion()
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
