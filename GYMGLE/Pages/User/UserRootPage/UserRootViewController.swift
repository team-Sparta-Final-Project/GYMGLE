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
    
    override func loadView() {
        view = first
        timeUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        first.inBtn.addTarget(self, action: #selector(inButtonClick), for: .touchUpInside)
                
    }
    
    @objc func inButtonClick(){
        let QrCodeViewController = QrCodeViewController()
        
        self.present(QrCodeViewController, animated: true)
    }
    

    func timeUser(){
        // 시작 및 끝 구독 날짜를 생성
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let startDateString = "2023-10-14 10:00:00" // 시작 날짜 및 시간 문자열
        let endDateString = "2023-10-14 11:30:00"   // 끝 날짜 및 시간 문자열

        if let startSubscriptionDate = dateFormatter.date(from: startDateString),
           let endSubscriptionDate = dateFormatter.date(from: endDateString) {
            let userAccount = Account(id: "kiho0528", password: "0528kiho", accountType: 2)
            let user = User(account: userAccount, name: "김기호", number: "01066146889", startSubscriptionDate: startSubscriptionDate, endSubscriptionDate: endSubscriptionDate, userInfo: "운동 똑바로 시킬것", isInGym: true)

                first.user = user
            
                let newNotice = Notice(date: Date(), content: "안녕하세요 좋은아침입니다.\n 저희 헬스장은 오늘부터 90일간 휴무입니다. \n다른곳으로 옮기시면 위약금 3천만원입니다.\n저는 오늘부터 밸리댄스를 3개월간 마스터\n 할 예정입니다.\n 수고하세요")
            
            first.noticeWrite = newNotice
            let timeDifference = endSubscriptionDate.timeIntervalSince(startSubscriptionDate)
            let inOut = InAndOut(id: "kiho0528", inTime: startSubscriptionDate, outTime: endSubscriptionDate, sinceInAndOutTime: timeDifference)
            first.sinceTime = inOut
            // 두 Date 객체 간의 시간 차이(초 단위)
        } else {
            print("날짜를 불러올 수 없습니다.")
        }
        
    }
}


#if DEBUG

struct ViewControllerRepresentable: UIViewControllerRepresentable{
    
    //    update
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    @available(iOS 13.0, *)
    func makeUIViewController(context: Context) -> UIViewController {
        UserRootViewController()
    }
    //    makeui
    
}


struct ViewController_Previews: PreviewProvider{
    static var previews: some View{
        ViewControllerRepresentable()
            .previewDisplayName("아이폰 14")
        
    }
}


#endif
