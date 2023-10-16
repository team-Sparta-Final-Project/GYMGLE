//
//  Extension_UIView.swift
//  GYMGLE
//
//  Created by 조규연 on 10/13/23.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
