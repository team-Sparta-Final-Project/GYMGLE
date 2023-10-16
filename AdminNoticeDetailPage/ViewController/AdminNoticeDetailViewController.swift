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
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        adminNoticeDetailView.endEditing(true)
    }
}
// MARK: - extension
private extension AdminNoticeDetailViewController {
    func viewSetting() {
        adminNoticeDetailView.contentTextView.delegate = self
        registerForKeyboardNotifications()
        allButtonTapped()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func allButtonTapped() {
        adminNoticeDetailView.createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    func textViewIsEmptyAlert() {
        let alert = UIAlertController(title: "공지사항이 없습니다!", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
}
// MARK: - @objc func
extension AdminNoticeDetailViewController {
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            let textFieldFrameInWindow = adminNoticeDetailView.contentNumberLabel.convert(adminNoticeDetailView.contentNumberLabel.bounds, to: nil)
            let maxY = textFieldFrameInWindow.maxY
            if maxY > (adminNoticeDetailView.frame.size.height - keyboardHeight) {
                let scrollOffset = maxY - (adminNoticeDetailView.frame.size.height - keyboardHeight)
                adminNoticeDetailView.frame.origin.y = -scrollOffset
            }
        }
    }
    @objc private func keyboardWillHide(_ notification: Notification) {
        adminNoticeDetailView.frame.origin.y = 0
    }
    @objc private func createButtonTapped() {
        if adminNoticeDetailView.contentTextView.text.isEmpty {
            textViewIsEmptyAlert()
        } else {
            // 여기에 등록 및 수정 코드 작성❗️
        }
    }
}

// MARK: - UITextViewDelegate
extension AdminNoticeDetailViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "공지사항을 입력하세요." {
            textView.text = nil
            textView.textColor = ColorGuide.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "공지사항을 입력하세요."
            textView.textColor = .lightGray
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if adminNoticeDetailView.contentTextView.text.count > 400 {
            adminNoticeDetailView.contentTextView.deleteBackward()
        }
        adminNoticeDetailView.contentNumberLabel.text = "\(adminNoticeDetailView.contentTextView.text.count)/400"
        
        if adminNoticeDetailView.contentTextView.text.count > 380 {
            let attributedString = NSMutableAttributedString(string: "\(adminNoticeDetailView.contentTextView.text.count)/400")
            attributedString.addAttribute(.foregroundColor, value: ColorGuide.main, range: ("\(adminNoticeDetailView.contentTextView.text.count)/400" as NSString).range(of:"\(adminNoticeDetailView.contentTextView.text.count)"))
            adminNoticeDetailView.contentNumberLabel.attributedText = attributedString
        }
    }
}
