//
//  Extension_UIImage.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/27.
//

import UIKit

extension UIImage {
    
    // 이미지 크기를 조정하는 메서드
    func resized(to newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
    
   
}
