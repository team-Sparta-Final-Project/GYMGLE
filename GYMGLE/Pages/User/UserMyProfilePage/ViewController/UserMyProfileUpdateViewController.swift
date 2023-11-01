//
//  UserMyProfileUpdateViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 10/31/23.
//

import UIKit
import PhotosUI

final class UserMyProfileUpdateViewController: UIViewController {

    // MARK: - pripertise
    let userMyprofileUpdateView = UserMyProfileUpdateView()
    
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
        
    }
}


// MARK: - private extension custom func

private extension UserMyProfileUpdateViewController {
    
    func allSetting() {
        userMyprofileUpdateView.nickNameTextField.delegate = self
        allButtonSetting()
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
                        //작성❗️
                    }
                }
            }
        } else {
            print("이미지 못 불러왔음!!!!")
        }
    }
}
