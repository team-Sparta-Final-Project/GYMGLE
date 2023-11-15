//
//  ReportViewController.swift
//  GYMGLE
//
//  Created by 조규연 on 10/31/23.
//

import UIKit
import MessageUI

class ReportViewController: UIViewController {
    // 넘겨받은 게시물 데이터
    var board: Board?
    
    private let reportView = ReportView()
    
    override func loadView() {
        view = reportView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
        
        // Do any additional setup after loading the view.
    }
}

extension ReportViewController {
    func setButton() {
        reportView.reportButton.addTarget(self, action: #selector(reportButtonTapped), for: .touchUpInside)
    }
    
    @objc func reportButtonTapped() {
        let alert = UIAlertController(title: "신고하기",
                                      message: "정말로 신고하시겠습니까?",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.report()
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
    
    func report() {
        if MFMailComposeViewController.canSendMail() {
            let vc = MFMailComposeViewController()
            vc.mailComposeDelegate = self
            vc.setToRecipients(["gymgle7@gmail.com"])
            vc.setSubject("신고")
            let body = "유효한 신고접수를 위해서 UID와 Content를 삭제하거나 수정하지 마십시오.\n\nUID: \(board!.uid)\nContent: \(board!.content)"
            vc.setMessageBody(body, isHTML: false)
            
            present(vc, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "이메일 전송 오류",
                                          message: "이메일을 보낼 수 없습니다. 메일앱에 계정을 등록해주세요.",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                guard let emailURL = URL(string: "mailto:gymgle7@gmail.com") else { return }
                
                if UIApplication.shared.canOpenURL(emailURL) {
                    UIApplication.shared.open(emailURL)
                }
                
            }))
            present(alert, animated: true, completion: nil)
        }
    }
}

extension ReportViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
