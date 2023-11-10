//
//  Extension_UIViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 11/10/23.
//

import UIKit

extension UIViewController {
    
    func showToast(message: String, view: UIView, bottomAnchor: CGFloat, widthAnchor: CGFloat, heightAnchor: CGFloat) {
        let toastView = ToastView()
        toastView.configure()
        toastView.text = message
        view.addSubview(toastView)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomAnchor),
            toastView.widthAnchor.constraint(equalToConstant: widthAnchor),
            toastView.heightAnchor.constraint(equalToConstant: heightAnchor),
        ])
        UIView.animate(withDuration: 2.5, delay: 0.2) { //2.5초
            toastView.alpha = 0
        } completion: { _ in
            toastView.removeFromSuperview()
        }
    }
}
