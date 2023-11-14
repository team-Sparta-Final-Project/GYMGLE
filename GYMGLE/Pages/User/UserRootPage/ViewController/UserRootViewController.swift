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

class UserRootViewController: UIViewController {
    let databaseRef = Database.database().reference()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    
    let first = UserRootView()
    var num = 0
    var totalExerciseForUser: Double = 0
    var totalExercise: Double = 0
    var totalUserCount: Double = 0
    var roundedTimes: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setChartPlace()
        first.inBtn.addTarget(self, action: #selector(inButtonClick), for: .touchUpInside)
        first.outBtn.addTarget(self, action: #selector(outButtonClick), for: .touchUpInside)
        getLastWeekUserNumber()
        view = scrollView
        
        view.backgroundColor = ColorGuide.userBackGround
        scrollView.addSubview(first)
        
        first.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
            make.bottom.equalTo(first.outBtn.snp.bottom).offset(20)
            
        }
        firebaseObserveDataChange()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkEndSub()
        calculateTotalExerciseTimeForUser() {
            self.calculateTotalExerciseTime {
                self.getTotalUserCount {
                    let average = self.totalExercise / self.totalUserCount
                    let times = (self.totalExerciseForUser / average - 1) * 100
                    let roundedTimes = times.rounded()
                    if roundedTimes >= 0 {
                        self.first.chartMidText.text = String("평균보다 \(roundedTimes)% 많습니다!")
                        switch roundedTimes {
                        case 0..<20:
                            self.borderAnimation(color: .systemBrown) // 브론즈
                            self.first.chartMidText.textColor = .systemBrown
                            self.roundedTimes = roundedTimes
                        case 20..<40:
                            self.borderAnimation(color: .lightGray) // 실버
                            self.first.chartMidText.textColor = .lightGray
                            self.roundedTimes = roundedTimes
                        case 40..<60:
                            self.borderAnimation(color: UIColor(red: 200/255, green: 155/255, blue: 60/255, alpha: 1)) // 골드
                            self.first.chartMidText.textColor = UIColor(red: 200/255, green: 155/255, blue: 60/255, alpha: 1)
                            self.roundedTimes = roundedTimes
                        case 60..<80:
                            self.borderAnimation(color: .systemGreen) // 플레
                            self.first.chartMidText.textColor = .systemGreen
                            self.roundedTimes = roundedTimes
                        case 80...:
                            self.borderAnimation(color: .systemBlue) // 다이아
                            self.first.chartMidText.textColor = .systemBlue
                            self.roundedTimes = roundedTimes
                        default:
                            break
                        }
                    } else {
                        self.first.chartMidText.text = String("평균보다 \(abs(roundedTimes))% 적습니다.")
                        self.first.chartMidText.textColor = .black
                        self.first.chartBottomText.text = "꾸준함이 중요하죠!"
                        self.borderAnimation(color: .black) // 아이언
                    }
                }
            }
        }
//        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(gogogo), userInfo: nil, repeats: true)
        //공지사항 읽어옴
        noticeRead {
            self.first.noticeText.text = DataManager.shared.noticeList[0].content
        }
    }
    
    
//    @objc func gogogo(){
//        getWorkingUser {
//            self.first.nowUserNumber.text = "\(self.num)"
//        }
//    }
    
    @objc func inButtonClick() {
        let QrCodeViewController = QrCodeViewController()
        //QrCodeViewController.user = DataManager.shared.userInfo
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
        guard let endSubscription = DataManager.shared.userInfo?.endSubscriptionDate else { return }
        if endSubscription < Date() {
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
    
    func getWorkingUser( completion: @escaping () -> () ){
        let refDateNow = Date().timeIntervalSinceReferenceDate
        
        databaseRef.child("users/\(DataManager.shared.gymUid!)/gymInAndOutLog").queryOrdered(byChild: "outTime").queryStarting(atValue: refDateNow).observeSingleEvent(of: .value) { DataSnapshot in
            if let value = DataSnapshot.value as? [String:Any] {
                self.num = value.values.count
            } else {
                self.num = 0
            }
            completion()
        }
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
    
    func borderAnimation(color: UIColor) {
        let path = UIBezierPath()
        let rect = self.first.chartPlace.bounds
        path.move(to: CGPoint(x: rect.minX + 176, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + 20, y: rect.maxY))
        path.addArc(
            withCenter: CGPoint(x: rect.minX + 20, y: rect.maxY - 20),
            radius: 20,
            startAngle: CGFloat.pi / 2,
            endAngle: CGFloat.pi,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + 20))
        path.addArc(
            withCenter: CGPoint(x: rect.minX + 20, y: rect.minY + 20),
            radius: 20,
            startAngle: CGFloat.pi,
            endAngle: -CGFloat.pi / 2,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: rect.maxX - 20, y: rect.minY))
        path.addArc(
            withCenter: CGPoint(x: rect.maxX - 20, y: rect.minY + 20),
            radius: 20,
            startAngle: -CGFloat.pi / 2,
            endAngle: 0,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 20))
        path.addArc(
            withCenter: CGPoint(x: rect.maxX - 20, y: rect.maxY - 20),
            radius: 20,
            startAngle: 0,
            endAngle: CGFloat.pi / 2,
            clockwise: true
        )
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2.0 // 보더 두께
        
        // 애니메이션 설정
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2.0 // 애니메이션 시간 (초)
        
        // 애니메이션을 shapeLayer에 추가
        shapeLayer.add(animation, forKey: "borderFillAnimation")
        // 뷰에 레이어 추가
        self.first.chartPlace.layer.addSublayer(shapeLayer)
    }
    
    func clearBorder() {
        let path = UIBezierPath()
        let rect = self.first.chartPlace.bounds
        path.move(to: CGPoint(x: rect.minX + 176, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + 20, y: rect.maxY))
        path.addArc(
            withCenter: CGPoint(x: rect.minX + 20, y: rect.maxY - 20),
            radius: 20,
            startAngle: CGFloat.pi / 2,
            endAngle: CGFloat.pi,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + 20))
        path.addArc(
            withCenter: CGPoint(x: rect.minX + 20, y: rect.minY + 20),
            radius: 20,
            startAngle: CGFloat.pi,
            endAngle: -CGFloat.pi / 2,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: rect.maxX - 20, y: rect.minY))
        path.addArc(
            withCenter: CGPoint(x: rect.maxX - 20, y: rect.minY + 20),
            radius: 20,
            startAngle: -CGFloat.pi / 2,
            endAngle: 0,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 20))
        path.addArc(
            withCenter: CGPoint(x: rect.maxX - 20, y: rect.maxY - 20),
            radius: 20,
            startAngle: 0,
            endAngle: CGFloat.pi / 2,
            clockwise: true
        )
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2.0 // 보더 두께
        
        self.first.chartPlace.layer.addSublayer(shapeLayer)
    }
    
    func setChartPlace() {
        self.first.chartPlace.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chartPlaceTapped)))
    }
    
    @objc func chartPlaceTapped() {
        if roundedTimes >= 0 {
            switch roundedTimes {
            case 0..<20:
                self.clearBorder()
                self.borderAnimation(color: .systemBrown) // 브론즈
                first.chartMidText.textColor = .systemBrown
            case 20..<40:
                self.clearBorder()
                self.borderAnimation(color: .lightGray) // 실버
                first.chartMidText.textColor = .lightGray

            case 40..<60:
                self.clearBorder()
                self.borderAnimation(color: UIColor(red: 200/255, green: 155/255, blue: 60/255, alpha: 1)) // 골드
                first.chartMidText.textColor = UIColor(red: 200/255, green: 155/255, blue: 60/255, alpha: 1)
            case 60..<80:
                self.clearBorder()
                self.borderAnimation(color: .systemGreen) // 플레
                first.chartMidText.textColor = .systemGreen

            case 80...:
                self.clearBorder()
                self.borderAnimation(color: .systemBlue) // 다이아
                first.chartMidText.textColor = .systemBlue

            default:
                break
            }
        } else {
            self.clearBorder()
            self.borderAnimation(color: .black) // 아이언
        }
    }
}

// MARK: FirebaseObserve

extension UserRootViewController {
    func firebaseObserveDataChange() {
        let ref = Database.database().reference().child("users/\(DataManager.shared.gymUid!)/gymInAndOutLog")
        ref.observe(.value) { snapshot in
            self.getWorkingUser {
                self.first.nowUserNumber.text = "\(self.num)"
            }
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
