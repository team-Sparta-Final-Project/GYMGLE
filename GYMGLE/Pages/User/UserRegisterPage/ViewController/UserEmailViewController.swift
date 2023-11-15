////
////  UserEmailViewController.swift
////  GYMGLE
////
////  Created by t2023-m0088 on 11/14/23.
////
//
//import UIKit
//import Then
//import SnapKit
//import FirebaseAuth
//
//class UserEmailViewController: UIViewController {
//    
//    var inBtn = UIButton().then {
//        $0.backgroundColor = ColorGuide.white
//        $0.setBackgroundColor(ColorGuide.black, for: .highlighted)
//        $0.setTitleColor(ColorGuide.main, for: .normal)
//        $0.setTitleColor(ColorGuide.main, for: .highlighted)
//        $0.setTitle("이메일 인증하기", for: .normal)
//        $0.titleLabel?.font = FontGuide.size14Bold
//        $0.layer.cornerRadius = 20
//        $0.clipsToBounds = true
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = ColorGuide.white
//        setupUI()
//    }
//    
//    @objc func inButtonClick() {
//        // AdminRootViewController를 네비게이션 스택에 푸시합니다.
//        let vc = AdminRootViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
//
//        // 이메일 인증 메서드를 호출합니다.
//        sendEmailVerification()
//    }
//
//    func sendEmailVerification() {
//        Auth.auth().currentUser?.sendEmailVerification { [weak self] (error) in
//            guard let self = self else { return }
//
//            if let error = error {
//                print("이메일 인증 메일 전송 실패: \(error.localizedDescription)")
//                // TODO: 실패에 대한 처리
//            } else {
//                print("이메일 인증 메일 전송 성공!")
//                // TODO: 성공에 대한 처리
//                self.showToastStatic(message: "이메일 인증 메일을 확인해 주세요.", view: self.view ?? UIView())
//
//                // 사용자의 이메일이 인증되었는지 확인
//                if let user = Auth.auth().currentUser {
//                    if user.isEmailVerified {
//                        // 인증이 완료되면 메인 화면으로 이동
//                        let mainVC = UserRootViewController() // UserRootViewController는 실제로 사용하는 화면으로 대체 필요
//                        self.navigationController?.pushViewController(mainVC, animated: true)
//                    } else {
//                        // 인증이 완료되지 않았을 경우 알림
//                        let alertController = UIAlertController(title: "이메일 인증", message: "이메일이 인증되지 않았습니다.", preferredStyle: .alert)
//                        alertController.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
//                        self.present(alertController, animated: true, completion: nil)
//                    }
//                }
//            }
//        }
//    }
//    
//                        func setupUI(){
//                            view.addSubview(inBtn)
//
//                            inBtn.snp.makeConstraints {
//                                $0.top.equalToSuperview().offset(300)
//                                $0.leading.equalToSuperview().offset(20)
//                                $0.trailing.equalToSuperview().offset(-20)
//                                $0.height.equalTo(56)
//                            }
//                        }
//
//}
