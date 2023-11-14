//
//  UserMyProfileUpdateViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 10/31/23.
//

import UIKit
import PhotosUI
import Kingfisher

final class UserMyProfileUpdateViewController: UIViewController {

    // MARK: - pripertise
    let userMyprofileUpdateView = UserMyProfileUpdateView()
    var viewModel: UserMyProfileUpdateViewModel = UserMyProfileUpdateViewModel()
    // MARK: - life cycle
    override func loadView() {
        view = userMyprofileUpdateView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        allSetting()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - private extension custom func

private extension UserMyProfileUpdateViewController {
    
    func allSetting() {
        userMyprofileUpdateView.nickNameTextField.delegate = self
        allButtonSetting()
        // 프로필이 없을 경우 와 있을 경우 싱글톤에서 받아옴
        if DataManager.shared.profile?.nickName == nil {
            userMyprofileUpdateView.pageLabel.text = "프로필 추가"
        } else {
            userMyprofileUpdateView.pageLabel.text = "프로필 수정"
            guard let nickName = DataManager.shared.profile?.nickName else { return }
            guard let url = DataManager.shared.profile?.image else { return }
            userMyprofileUpdateView.dataSetting(nickName: nickName, imageUrl: url)
        }
    }
    
    func allButtonSetting() {
        userMyprofileUpdateView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        userMyprofileUpdateView.imageButton.addTarget(self, action:  #selector(imageButtonTapped), for: .touchUpInside)
        userMyprofileUpdateView.successedButton.addTarget(self, action:  #selector(successedButtonTapped), for: .touchUpInside)
    }
}

// MARK: - extension @objc func

extension UserMyProfileUpdateViewController {
    
    @objc private func backButtonTapped() {
        presentingViewController?.dismiss(animated: true)
    }
    @objc private func imageButtonTapped() {
        setupImagePicker()
    }
    @objc private func successedButtonTapped() {
        guard let nickName = userMyprofileUpdateView.nickNameTextField.text else {return}
        viewModel.nickNameDuplicateCheck(target: nickName , completion: { isDuplicated in
            if !isDuplicated || DataManager.shared.profile?.nickName == self.userMyprofileUpdateView.nickNameTextField.text  {
                if self.userMyprofileUpdateView.nickNameTextField.text?.isEmpty == true {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "닉네임 칸이 비었습니다.",
                                                      message: "다시 입력해주세요.",
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    self.userMyprofileUpdateView.activityIndicator.startAnimating()
                    guard let image = self.userMyprofileUpdateView.profileImageView.image, let nickName =  self.userMyprofileUpdateView.nickNameTextField.text else { return }
                    
                    self.viewModel.viewDisappearEvent(image: image, nickName: nickName) {
                        self.userMyprofileUpdateView.activityIndicator.stopAnimating()
                        self.dismiss(animated: true)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "닉네임 중복",
                                                  message: "닉네임 중복입니다. 다시 입력해주세요.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
}

// MARK: - UITextFieldDelegate
extension UserMyProfileUpdateViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 20
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        let allowedCharacter = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎㅏㅑㅓㅕㅗㅛㅜㅠㅡㅣㅔㅐㅖㅒ")
        let replacementString = CharacterSet(charactersIn: string)
    
        if string == " " {
            showToast(message: "띄어쓰기는 할 수 없습니다.", view: self.view, bottomAnchor: -300, widthAnchor: 200, heightAnchor: 40)
            return false
        }
        if !allowedCharacter.isSuperset(of: replacementString) {
            showToast(message: "입력할 수 없는 문자입니다.", view: self.view, bottomAnchor: -300, widthAnchor: 200, heightAnchor: 40)
            return false
        }
        return newString.length <= maxLength
    }
}

// MARK: - PHPickerViewController

extension UserMyProfileUpdateViewController {
    
    private func setupImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
}
extension UserMyProfileUpdateViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider: NSItemProvider? = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self.userMyprofileUpdateView.profileImageViewSetting(image: image.resized(to: CGSize(width: 100, height: 100)))
                    }
                }
            }
        } else {
            print("이미지 못 불러왔음!!!!")
        }
    }
}
