//
//  UserMyProfileViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 10/31/23.
//

import UIKit


final class UserMyProfileViewController: UIViewController {
    
    // MARK: - prirperties
    let userMyProfileView = UserMyProfileView()
    
    // MARK: - life cycle

    override func loadView() {
        view = userMyProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

// MARK: - private extension custom func

private extension UserMyProfileViewController {
  
    
    func buttonTapped() {
        userMyProfileView.updateButton.addTarget(self, action: #selector(updateButtonButtoned), for: .touchUpInside)
    }
}

// MARK: - extension @objc func

extension UserMyProfileViewController {
    
    @objc private func updateButtonButtoned() {
        print("테스트 - click")
//        let userMyProfileUpdateVC = UserMyProfileUpdateViewController()
//        userMyProfileUpdateVC.modalPresentationStyle = .fullScreen
//        userMyProfileUpdateVC.present(userMyProfileUpdateVC, animated: true)
    }
    
}

