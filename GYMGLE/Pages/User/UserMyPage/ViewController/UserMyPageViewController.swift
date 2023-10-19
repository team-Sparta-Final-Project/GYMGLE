//
//  UserMyPageViewController.swift
//  GYMGLE
//
//  Created by 조규연 on 10/18/23.
//

import UIKit

class UserMyPageViewController: UIViewController {
    
    // MARK: - Properties
    
    private let userMyPageView = UserMyPageView()
    
    // MARK: - LifeCycles
    
    override func loadView() {
        view = userMyPageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton()
    }
}

// MARK: - Actions

private extension UserMyPageViewController {
    
    func addButton() {
        userMyPageView.logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
    }
    
    @objc func logOutButtonTapped() {
        LoginManager.updateLoginStatus(isLoggedIn: false, userType: .user)
        let vc = InitialViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
