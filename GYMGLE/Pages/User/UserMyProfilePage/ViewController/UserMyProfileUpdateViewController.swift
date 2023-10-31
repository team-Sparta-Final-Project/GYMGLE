//
//  UserMyProfileUpdateViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 10/31/23.
//

import UIKit

final class UserMyProfileUpdateViewController: UIViewController {

    // MARK: - pripertise
    let userMyprofileUpdateView = UserMyProfileUpdateView()
    
    // MARK: - life cycle

    override func loadView() {
        view = userMyprofileUpdateView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}


// MARK: - private extension custom func

private extension UserMyProfileUpdateViewController {
    
}

// MARK: - private extension @objc func

private extension UserMyProfileUpdateViewController {
    
}

