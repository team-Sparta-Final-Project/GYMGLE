//
//  AdminNoticeDetailViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/14.
//

import UIKit
import Combine

final class AdminNoticeDetailViewController: UIViewController {
    
    // MARK: - properties
    private let adminNoticeDetailView = AdminNoticeDetailView()
    var viewModel: AdminNoticeDetailViewModel = AdminNoticeDetailViewModel()
    var disposableBag = Set<AnyCancellable>()
    
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        adminNoticeDetailView.endEditing(true)
    }
}
// MARK: - extension custom func
private extension AdminNoticeDetailViewController {
    func viewConfigure() {
        viewSetting()
        adminNoticeDetailView.contentTextView.delegate = self
        buttonTapped()
    }

    func viewSetting() {
        viewModel.$noticeInfo.sink { [self] in
            if let noticeInfo = $0 {
                adminNoticeDetailView.contentTextView.text = noticeInfo.content
                adminNoticeDetailView.contentNumberLabel.text = "\(adminNoticeDetailView.contentTextView.text.count)/500"
                adminNoticeDetailView.createButton.setTitle("수정하기", for: .normal)
                adminNoticeDetailView.deletedButton.isHidden = false
            } else {
                adminNoticeDetailView.createButton.setTitle("등록하기", for: .normal)
                adminNoticeDetailView.contentNumberLabel.text = "0/500"
            }
        }.store(in: &disposableBag)
    }
    func buttonTapped() {
        adminNoticeDetailView.createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        adminNoticeDetailView.deletedButton.addTarget(self, action:  #selector(deletedButtonTapped), for: .touchUpInside)
        viewModel.$isUser.sink { [weak self] isUser in
            guard let self = self else { return }
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
        }.store(in: &disposableBag)
       
    }
}
// MARK: - @objc func
extension AdminNoticeDetailViewController {

    @objc private func createButtonTapped() {
        if adminNoticeDetailView.contentTextView.text.isEmpty || adminNoticeDetailView.contentTextView.text == "500자 이내로 공지사항을 적어주세요!" {
            showToast(message: "내용물이 비었습니다.", view: self.view,  bottomAnchor: -80, widthAnchor: 220, heightAnchor: 30)
        } else {
            viewModel.$noticeInfo.sink { [self] in
                if $0 == nil {
                    let date = Date()
                    let content = adminNoticeDetailView.contentTextView.text
                    let newNotice = Notice(date: date, content: content ?? "")
                    viewModel.createdNoticeData(notice: newNotice) {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    if var notice = $0 {
                        let oldContent = notice.content
                        notice.content = adminNoticeDetailView.contentTextView.text
                        viewModel.updatedNoticeData(oldContent: oldContent, newNotice: notice) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }.store(in: &disposableBag)
        }
    }
    
    @objc private func deletedButtonTapped() {
        let alert = UIAlertController(title: "공지사항 삭제",
                                      message: "삭제하시겠습니까?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.viewModel.$noticeInfo.sink { [weak self] in
                guard let self = self else {return}
                if let notice = $0 {
                    viewModel.deletedNotice(notice: notice, completion: {
                        self.navigationController?.popViewController(animated: true)
                        DataManager.shared.noticeList.removeAll(where: {$0.date == notice.date})
                    })
                }
            }.store(in: &self.disposableBag)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true, completion: nil)
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

