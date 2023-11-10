//
//  tempViewModel.swift
//  GYMGLE
//
//  Created by t2023-m0078 on 2023/11/10.
//

import Foundation
import Combine

class tempViewModel: ObservableObject {
    
    //Board주입
    
    @Published var board:Board? {
        didSet{
            print("테스트 - 템프에서 찍힘 \(String(describing: self.board))")
        }
    }
    
    
}
