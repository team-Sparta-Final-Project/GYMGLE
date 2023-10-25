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
import FirebaseAuth

class UserRootViewController: UIViewController {
    let databaseRef = Database.database().reference()

    let first = UserRootView()
    //    var user: User?
    //    var gymInfo: GymInfo?
    var num = 0
    
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
        //    파이어베이스 경로에서 하위폴더인 gymInAndOutLog를 조회
        let ref = Database.database().reference().child("users").child(DataManager.shared.gymUid!).child("gymInAndOutLog")
        let currentDate = Date()
        // 현재 날짜에서 7일을 뺀 날짜를 계산
        let calendar = Calendar.current
//        일주일전 데이터 조회
        let lastWeekDate = calendar.date(byAdding: .weekOfYear, value: -1, to: currentDate)!
//        Query를 사용하여 지난주 같은 요일, 같은 시간대에 입장한 사용자를 필터링
//        adminUid 필드값을 기준으로 데이터를 정렬
//        adminUid 필드값이 DataManager.shared.gymUid 와 일치하는 데이터만 검색 ( 같은 헬스장인지 확인 절차 )
//            .queryStarting(atValue: oneWeekAgo, childKey: "inTime" )
//        Firebase 데이터 베이스에서 데이터를 한번만 읽어오도록 하는 관찰 작업 시작 ( .value 이벤트를 관찰하기때문에 데이터 변경시마다 이 작업 실행 )
        ref.observeSingleEvent(of: .value) { (snapshot) in
//        스냅샷에서 데이터를 가져온 후 처리하기전 언래핑과 형변환 해주는 부분
            guard let data = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
//          data 배열에 있는 각 데이터 스냅샷 userSnapShot 에 대한 필터링
            let numberOfUser = data.filter { userSnapshot in
//          각 데이터 스냅샷 userSnapShot 의 값에서 필요한 데이터를 추출 ( inTime, outTime ) 추출한 데이터는 userData에 딕셔너리 형태로 저장
                if let userData = userSnapshot.value as? [String: Any],
                   let inTime = userData["inTime"] as? TimeInterval,
                   let outTime = userData["outTime"] as? TimeInterval {
//                    inTime과 outTime을 이용하여 inDate와 outDate 라는 날짜객체 생성
                    let inDate = Date(timeIntervalSinceReferenceDate: inTime)
                    let outDate = Date(timeIntervalSinceReferenceDate: outTime)
//                    inDate의 요일과 lastWeekDate가 같은요일인지 확인 /
                    if calendar.component(.weekday, from: inDate) == calendar.component(.weekday, from: lastWeekDate) &&
//                    inDate가 lastWeekDate보다 크거나 같고 , lastWeekDate가 outDate보다 이전이거나 같은 경우를 확인
//                    ( lastWeekDate가 입실시간 & 퇴실시간 사이에 있는지 확인 )
                       inDate >= lastWeekDate && lastWeekDate <= outDate {
                        return true
                    }
                }
                return false
//               count > 필터링된 데이터의 수를 세어서 반환 ( lastWeekDate와 일치하는 조건을 가진 사용자 수를 나타냄 )
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
//        
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
