//
//  UserRootViewController.swift
//  GYMGLE
//
//  Created by t2023-m0088 on 2023/10/13.
//

import SnapKit
import UIKit
import SwiftUI

class UserRootViewController: UIViewController {
    
    let first = UserRootView()
    
    override func loadView() {
        view = first
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        first.inBtn.addTarget(self, action: #selector(inButtonClick), for: .touchUpInside)
                
    }
    
    @objc func inButtonClick(){
        let QrCodeViewController = QrCodeViewController()
        
        self.present(QrCodeViewController, animated: true)
    }

}


#if DEBUG

struct ViewControllerRepresentable: UIViewControllerRepresentable{
    
    //    update
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    @available(iOS 13.0, *)
    func makeUIViewController(context: Context) -> UIViewController {
        UserRootViewController()
    }
    //    makeui
    
}


struct ViewController_Previews: PreviewProvider{
    static var previews: some View{
        ViewControllerRepresentable()
            .previewDisplayName("아이폰 14")
        
    }
}


#endif
