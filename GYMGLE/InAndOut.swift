//
//  InAndOut.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/16.
//

import Foundation

struct InAndOut: Codable {
    
    var id: String
    var inTime: Date
    var outTime: Date
    var sinceInAndOutTime : Double
}
