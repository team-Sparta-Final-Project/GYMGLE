//
//  AdminNoticeDetailViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/14.
//

import UIKit

final class AdminNoticeDetailViewController: UIViewController {
    
    private let adminNoticeDetailView = AdminNoticeDetailView()
    let dataTest = DataManager.shared
    var noticeInfo: Notice? {
        didSet {
            adminNoticeDetailView.contentTextView.text = noticeInfo?.content
        }
    }
    // MARK: - life cycle
    
    override func loadView() {
        view = adminNoticeDetailView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) { // 네비게이션바 보여주기
        navigationController?.navigationBar.isHidden = false
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        adminNoticeDetailView.endEditing(true)
    }
}
// MARK: - extension (custom func)
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
    
    func showToast(message: String) {
        let toastView = ToastView()
        toastView.configure()
        toastView.text = message
        view.addSubview(toastView)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            toastView.widthAnchor.constraint(equalToConstant: view.frame.size.width / 2),
            toastView.heightAnchor.constraint(equalToConstant: view.frame.height / 17),
        ])
        UIView.animate(withDuration: 2.5, delay: 0.2) { //2.5초
            toastView.alpha = 0
        } completion: { _ in
            toastView.removeFromSuperview()
        }
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
        if adminNoticeDetailView.contentTextView.text.isEmpty || adminNoticeDetailView.contentTextView.text == "공지사항을 입력하세요." {
            showToast(message: "내용물이 비었습니다.")
        } else {
            // 여기에 등록 및 수정 코드 작성❗️
            if noticeInfo == nil {
                let date = Date()
                let content = adminNoticeDetailView.contentTextView.text
                
                var newNotice = Notice(date: date, content: content ?? "")
                print(newNotice)
                dataTest.makeNoticeList(newNotice)

                
                
            } else {
                noticeInfo?.content = adminNoticeDetailView.contentTextView.text
                noticeInfo?.date = Date()
            }
            self.navigationController?.popViewController(animated: true)
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
