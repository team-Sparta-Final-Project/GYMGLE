//
//  UserCommnunityWriteViewController.swift
//  GYMGLE
//
//  Created by t2023-m0088 on 2023/10/19.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

class UserCommunityWriteViewController: UIViewController {
    let userCommunityWriteView = UserCommunityWriteView()
    let userCommunityView = UserCommunityView()

    let first = UserCommunityWriteView()
    
    let dataTest = DataManager.shared
    var noticeInfo: Notice? {
        didSet {
            userCommunityWriteView.writePlace.text = noticeInfo?.content
        }
    }
    
    override func loadView() {
        view = first
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        first.addButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(createButtonTapped)))
        
        first.addButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(        createBoardButtonTapped)))
    }
    
}
extension UserCommunityWriteViewController {
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            let textFieldFrameInWindow = userCommunityWriteView.countNumberLabel.convert(userCommunityWriteView.countNumberLabel.bounds, to: nil)
            let maxY = textFieldFrameInWindow.maxY
            if maxY > (userCommunityWriteView.frame.size.height - keyboardHeight) {
                let scrollOffset = maxY - (userCommunityWriteView.frame.size.height - keyboardHeight)
                userCommunityWriteView.frame.origin.y = -scrollOffset
            }
        }
    }
    @objc private func keyboardWillHide(_ notification: Notification) {
        userCommunityWriteView.frame.origin.y = 0
    }
    @objc private func createButtonTapped() {
        if userCommunityWriteView.writePlace.text.isEmpty || userCommunityWriteView.writePlace.text == "내용을 입력하세요." {
            //            showToast(message: "내용물이 비었습니다.")
        } else {
            // 여기에 등록 및 수정 코드 작성❗️
            if noticeInfo == nil {
                let date = Date()
                let content = userCommunityWriteView.writePlace.text
                
                var newNotice = Notice(date: date, content: content ?? "")
                print(newNotice)
//                dataTest.makeNoticeList(newNotice)
                
            } else {
                noticeInfo?.content = userCommunityWriteView.writePlace.text
                noticeInfo?.date = Date()
            }
            
            userCommunityView.appTableView.reloadData()
//            self.navigationController?.popViewController(animated: true)
        }
    }
}
extension UserCommunityWriteViewController{
    
}
extension UserCommunityWriteViewController: UITextViewDelegate {
    
    func createdBoard() {
        if let user = Auth.auth().currentUser {
            let uid = user.uid
        guard let boardText = userCommunityWriteView.writePlace.text else { return }
        let currentDate = Date()
        let newBoard = Board(uid: uid, content: boardText, date: currentDate, isUpdated: false, likeCount: 0)
        let ref = Database.database().reference().child("boards").childByAutoId()
        do {
            let boardData = try JSONEncoder().encode(newBoard)
            let boardJSON = try JSONSerialization.jsonObject(with: boardData, options: [])
            ref.setValue(boardJSON)
        } catch {
            print("테스트 - error")
        }
    }
    }
    
    @objc private func createBoardButtonTapped() {
                self.createdBoard()
        dismiss(animated: true, completion: nil)
        }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if userCommunityWriteView.writePlace.text == "내용을 입력하세요." {
            userCommunityWriteView.writePlace.text = nil
            userCommunityWriteView.writePlace.textColor = ColorGuide.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if userCommunityWriteView.writePlace.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            userCommunityWriteView.writePlace.text = "내용을 입력하세요."
            userCommunityWriteView.writePlace.textColor = .lightGray
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        if userCommunityWriteView.writePlace.text.count > 1000 {
            userCommunityWriteView.writePlace.deleteBackward()
        }
        userCommunityWriteView.countNumberLabel.text = "\(userCommunityWriteView.writePlace.text.count)/1000"
        
        if userCommunityWriteView.writePlace.text.count > 880 {
            let attributedString = NSMutableAttributedString(string: "\(userCommunityWriteView.writePlace.text.count)/1000")
            attributedString.addAttribute(.foregroundColor, value: ColorGuide.main, range: ("\(userCommunityWriteView.writePlace.text.count)/1000" as NSString).range(of:"\(userCommunityWriteView.writePlace.text.count)"))
            userCommunityWriteView.countNumberLabel.attributedText = attributedString
        }
    }
    func textViewDidChanges(_ textView: UITextView) {
           let text = textView.text
       }
}
