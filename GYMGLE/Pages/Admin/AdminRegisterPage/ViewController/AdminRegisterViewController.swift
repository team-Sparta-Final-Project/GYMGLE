//
//  AdminRegisterViewController.swift
//  GYMGLE
//
//  Created by 조규연 on 10/13/23.
//

import UIKit

class AdminRegisterViewController: UIViewController {
    
    private let adminRegisterView = AdminRegisterView()

    override func loadView() {
        view = adminRegisterView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addButtonMethod()
        configureNav()
        
    }
}

// MARK: - Configure

private extension AdminRegisterViewController {
    func configureNav() {
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - Actions

private extension AdminRegisterViewController {
    func addButtonMethod() {
        adminRegisterView.validCheckButton.addTarget(self, action: #selector(validCheckButtonTapped), for: .touchUpInside)
        adminRegisterView.duplicationCheckButton.addTarget(self, action: #selector(duplicationCheckButtonTapped), for: .touchUpInside)
        adminRegisterView.registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    @objc func validCheckButtonTapped() {
        
    }
    
    @objc func duplicationCheckButtonTapped() {
        
    }
    
    @objc func registerButtonTapped() {
        let vc = AdminRootViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
