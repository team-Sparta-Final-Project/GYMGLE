//
//  UserCommunityViewController.swift
//  GYMGLE
//
//  Created by t2023-m0088 on 2023/10/18.
//

import UIKit

class UserCommunityViewController: UIViewController, CommunityTableViewDelegate {
    
    func didSelectCell(at indexPath: IndexPath) {
            let destinationViewController = BoardDetailViewController()
            present(destinationViewController, animated: true)
            print(navigationController == nil)
    }
    
    let first = UserCommunityView()
    
    override func loadView() {
        view = first
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        first.writePlace.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(writePlaceTap)))
        first.delegate = self
        self.view = first
    }
    
    override func viewWillAppear(_ animated: Bool) { // 네비게이션바 보여주기
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        first.appTableView.reloadData()
    }
    
    @objc func writePlaceTap() {
        let userCommunityWriteViewController = UserCommunityWriteViewController()

        self.present(userCommunityWriteViewController, animated: true)
    }
}
