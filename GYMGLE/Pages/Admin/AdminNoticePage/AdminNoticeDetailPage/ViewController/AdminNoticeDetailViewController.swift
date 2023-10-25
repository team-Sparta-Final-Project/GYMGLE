//
//  AdminNoticeDetailViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/14.
// 3060349969 -> 사업자 등록 번호 (임시 사용)
import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

final class AdminNoticeDetailViewController: UIViewController {
    
    // MARK: - properties
    private let adminNoticeDetailView = AdminNoticeDetailView()
    var noticeInfo: Notice?
    var isUser: Bool?
    // MARK: - life cycle
    override func loadView() {
        view = adminNoticeDetailView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfigure()
        if adminNoticeDetailView.contentTextView.text == "500자 이내로 공지사항을 적어주세요!" {
            adminNoticeDetailView.deletedButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        adminNoticeDetailView.endEditing(true)
    }
}
// MARK: - extension custom func
private extension AdminNoticeDetailViewController {
    func viewConfigure() {

        viewSetting()
        adminNoticeDetailView.contentTextView.delegate = self
        registerForKeyboardNotifications()
        buttonTapped()
    }
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func viewSetting() {
        if let noticeInfo = self.noticeInfo {
            adminNoticeDetailView.contentTextView.text = noticeInfo.content
            adminNoticeDetailView.contentNumberLabel.text = "\(adminNoticeDetailView.contentTextView.text.count)/500"
            adminNoticeDetailView.createButton.setTitle("수정하기", for: .normal)
            adminNoticeDetailView.deletedButton.isHidden = false
        } else {
            adminNoticeDetailView.createButton.setTitle("등록하기", for: .normal)
        }
    }
    func buttonTapped() {
        adminNoticeDetailView.createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        adminNoticeDetailView.deletedButton.addTarget(self, action:  #selector(deletedButtonTapped), for: .touchUpInside)
        switch isUser {
        case false: //유저가 들어오면
            adminNoticeDetailView.createButton.isHidden = true
            adminNoticeDetailView.deletedButton.isHidden = true
            adminNoticeDetailView.contentTextView.isEditable = false
            adminNoticeDetailView.contentNumberLabel.isHidden = true
        default:
            adminNoticeDetailView.createButton.isHidden = false
            adminNoticeDetailView.deletedButton.isHidden = false
            adminNoticeDetailView.contentTextView.isEditable = true
            adminNoticeDetailView.contentNumberLabel.isHidden = false
        }
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
            toastView.widthAnchor.constraint(equalToConstant: (view.frame.size.width / 2) - 20),
            toastView.heightAnchor.constraint(equalToConstant: view.frame.height / 20),
        ])
        UIView.animate(withDuration: 2.5, delay: 0.2) { //2.5초
            toastView.alpha = 0
        } completion: { _ in
            toastView.removeFromSuperview()
        }
    }
    // 추가 및 수정 로직
    func createdAndUpatedContent(completion: @escaping () -> Void) {
        if adminNoticeDetailView.contentTextView.text.isEmpty || adminNoticeDetailView.contentTextView.text == "500자 이내로 공지사항을 적어주세요!" {
            showToast(message: "내용물이 비었습니다.")
        } else {
            if noticeInfo == nil {
                let date = Date()
                let content = adminNoticeDetailView.contentTextView.text
                let newNotice = Notice(date: date, content: content ?? "")
                do {
                    let userID = Auth.auth().currentUser?.uid
                    let ref = Database.database().reference().child("users").child(userID!).child("noticeList")
                    
                    let noticeData = try JSONEncoder().encode(newNotice)
                    let noticeJSON = try JSONSerialization.jsonObject(with: noticeData, options: [])
                    
                    ref.childByAutoId().setValue(noticeJSON)
                    completion()
                } catch {
                    completion()
                }
            } else {
                if var notice = noticeInfo {
                    let oldContent = notice.content
                    notice.content = adminNoticeDetailView.contentTextView.text
                    let userID = Auth.auth().currentUser?.uid
                    let ref = Database.database().reference().child("users").child(userID!).child("noticeList")
                    do {
                        let noticeData = try JSONEncoder().encode(notice)
                        let noticeJSON = try JSONSerialization.jsonObject(with: noticeData, options: [])
                        ref.queryOrdered(byChild: "content").queryEqual(toValue: oldContent).observeSingleEvent(of: .value) { snapshot in
                            guard let value = snapshot.value as? [String: Any] else { return }
                            var key = ""
                            for i in value.keys {
                                key = i
                            }
                            ref.child("\(key)").setValue(noticeJSON)
                            completion()
                        }
                    } catch let Error {
                        print(Error)
                        completion()
                    }
                }
            }
        }
    }
    //삭제 기능
    func deletedNotice(completion: @escaping () -> Void) {
        if let notice = noticeInfo {
            let userID = Auth.auth().currentUser?.uid
            let ref = Database.database().reference().child("users").child(userID!).child("noticeList")
            do {
                let noticeData = try JSONEncoder().encode(notice)
                _ = try JSONSerialization.jsonObject(with: noticeData, options: [])
                ref.queryOrdered(byChild: "content").queryEqual(toValue: notice.content).observeSingleEvent(of: .value) { snapshot in
                    guard let value = snapshot.value as? [String: Any] else { return }
                    var key = ""
                    for i in value.keys {
                        key = i
                    }
                    ref.child("\(key)").setValue(nil)
                    completion()
                }
            } catch let Error {
                completion()
                print(Error)
            }
        }
    }
}
// MARK: - @objc func
extension AdminNoticeDetailViewController {
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            
            var createButtonFrame = adminNoticeDetailView.createButton.frame
            createButtonFrame.origin.y = view.frame.height - keyboardHeight - createButtonFrame.height - 10
            self.adminNoticeDetailView.createButton.frame = createButtonFrame
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let realCreateButtonFrame = self.view.frame.size.height - 88 - self.adminNoticeDetailView.createButton.frame.size.height
        var createButtonFrame = adminNoticeDetailView.createButton.frame
            createButtonFrame.origin.y = realCreateButtonFrame
            self.adminNoticeDetailView.createButton.frame = createButtonFrame
        
    }
    @objc private func createButtonTapped() {
        createdAndUpatedContent {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc private func deletedButtonTapped() {
        deletedNotice {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}

// MARK: - UITextViewDelegate
extension AdminNoticeDetailViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "500자 이내로 공지사항을 적어주세요!" {
            textView.text = nil
            textView.textColor = ColorGuide.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "500자 이내로 공지사항을 적어주세요!"
            textView.textColor = .lightGray
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if adminNoticeDetailView.contentTextView.text.count > 500 {
            adminNoticeDetailView.contentTextView.deleteBackward()
        }
        adminNoticeDetailView.contentNumberLabel.text = "\(adminNoticeDetailView.contentTextView.text.count)/500"
        
        if adminNoticeDetailView.contentTextView.text.count > 480 {
            let attributedString = NSMutableAttributedString(string: "\(adminNoticeDetailView.contentTextView.text.count)/500")
            attributedString.addAttribute(.foregroundColor, value: ColorGuide.main, range: ("\(adminNoticeDetailView.contentTextView.text.count)/500" as NSString).range(of:"\(adminNoticeDetailView.contentTextView.text.count)"))
            adminNoticeDetailView.contentNumberLabel.attributedText = attributedString
        }
    }
}
