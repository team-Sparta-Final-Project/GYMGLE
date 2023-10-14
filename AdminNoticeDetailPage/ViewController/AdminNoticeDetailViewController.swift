//
//  AdminNoticeDetailViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/14.
//

import UIKit

final class AdminNoticeDetailViewController: UIViewController {

    
    private let adminNoticeDetailView = AdminNoticeDetailView()
    
    // MARK: - life cycle

    override func loadView() {
        view = adminNoticeDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetting()

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        adminNoticeDetailView.endEditing(true)
    }
}
// MARK: - extension

private extension AdminNoticeDetailViewController {
    func viewSetting() {
        adminNoticeDetailView.contentTextView.delegate = self
    }
}

extension AdminNoticeDetailViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "텍스트를 여기에 입력하세요." {
            textView.text = nil
            textView.textColor = ColorGuide.black
        }
    }
    // 입력이 끝났을때
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "텍스트를 여기에 입력하세요."
            textView.textColor = .lightGray
        }
    }
}
