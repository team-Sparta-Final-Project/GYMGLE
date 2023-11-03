//
//  UserMyProfileUpdateViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 10/31/23.
//

import UIKit
import PhotosUI
import FirebaseStorage
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import Kingfisher

protocol SendUpdatedDataProtocol: AnyObject {
    func updatedProfileData(viewController: UserMyProfileUpdateViewController, updatedData: Profile)
}

final class UserMyProfileUpdateViewController: UIViewController {


    // MARK: - pripertise
    let userMyprofileUpdateView = UserMyProfileUpdateView()
    weak var delegate: SendUpdatedDataProtocol?
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewDisappearEvent()
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
        if DataManager.shared.profile?.nickName == nil {
            userMyprofileUpdateView.pageLabel.text = "프로필 추가"
        } else {
            userMyprofileUpdateView.pageLabel.text = "프로필 수정"
            userMyprofileUpdateView.nickNameTextField.text = DataManager.shared.profile?.nickName
            downloadImage(imageView: userMyprofileUpdateView.profileImageView)
        }
    }
    
    func allButtonSetting() {
        userMyprofileUpdateView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        userMyprofileUpdateView.imageButton.addTarget(self, action:  #selector(imageButtonTapped), for: .touchUpInside)
        userMyprofileUpdateView.successedButton.addTarget(self, action:  #selector(successedButtonTapped), for: .touchUpInside)
    }
    // 스토리지에 올리기
    func uploadImage(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let imageName = Auth.auth().currentUser!.uid + String(Date().timeIntervalSince1970)
        
        let firebaseReference = Storage.storage().reference().child("profiles").child("\(imageName)")
        firebaseReference.putData(imageData, metadata: metaData) { metaData, error in
            firebaseReference.downloadURL { url, _ in
                completion(url)
            }
        }
    }
    // 프로필 서버에 올리기
    func createdProfile(url: URL, completion: @escaping () -> Void) {
        guard let nickName = userMyprofileUpdateView.nickNameTextField.text else { return }
        let newProfile = Profile(image: url, nickName: nickName)
        let ref = Database.database().reference().child("accounts/\(Auth.auth().currentUser!.uid)/profile")
        do {
            let profileData = try JSONEncoder().encode(newProfile)
            let profileJSON = try JSONSerialization.jsonObject(with: profileData, options: [])
            ref.setValue(profileJSON)
            completion()
        } catch {
            print("테스트 - error")
            completion()
        }
    }
    //이미지 가져오기 (싱글톤에서)
    func downloadImage(imageView: UIImageView) {
        guard let url = DataManager.shared.profile?.image else  {return}
        imageView.kf.setImage(with: url)
    }

    //닉네임 중복 검사 (서버에서 검사하기)
    func nickNameDuplicateCheck(completion: @escaping (Bool) -> Void) {
        let ref = Database.database().reference().child("accounts")
        let target = userMyprofileUpdateView.nickNameTextField.text
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? [String: Any] {
                for (_, accountData) in data {
                    if let account = accountData as? [String: Any],
                       let accountInfo = account["profile"] as? [String: Any],
                       let nickName = accountInfo["nickName"] as? String {
                        if nickName == target {
                            completion(true)
                            return
                        }
                    }
                }
                completion(false)
            }
        }
    }
    func viewDisappearEvent() {
        nickNameDuplicateCheck(completion: { isDuplicated in
            if !isDuplicated || DataManager.shared.profile?.nickName == self.userMyprofileUpdateView.nickNameTextField.text {
                self.uploadImage(image: self.userMyprofileUpdateView.profileImageView.image!) { url in
                    if let url = url, let nickName = self.userMyprofileUpdateView.nickNameTextField.text {
                        let myProfile = Profile(image: url, nickName: nickName)
                        DataManager.shared.profile = myProfile
                        self.delegate?.updatedProfileData(viewController: self, updatedData: myProfile)
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

// MARK: - extension @objc func

extension UserMyProfileUpdateViewController {
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    @objc private func imageButtonTapped() {
        setupImagePicker()
    }
    @objc private func successedButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension UserMyProfileUpdateViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 20
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}

// MARK: - PHPickerViewController

extension UserMyProfileUpdateViewController {
    
    private func setupImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
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
                        self.userMyprofileUpdateView.profileImageView.image = image.resized(to: CGSize(width: 100, height: 100))
                    }
                }
            }
        } else {
            print("이미지 못 불러왔음!!!!")
        }
    }
}
