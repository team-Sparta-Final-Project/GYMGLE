//
//  AdminRootViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/13.
//

import UIKit

final class AdminRootViewController: UIViewController {

    private let adminRootView = AdminRootView()
    
    // MARK: - life cycle

    override func loadView() {
        view = adminRootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

// MARK: - extension
private extension AdminRootViewController {
    
    func buttonTappedSetting() {
        //adminRootView.gymSettingButton.addTarget(self, action: <#T##Selector#>, for: .touchUpInside)
    }
}
