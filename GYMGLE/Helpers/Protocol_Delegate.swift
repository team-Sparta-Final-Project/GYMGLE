//
//  Protocol_Delegate.swift
//  GYMGLE
//
//  Created by 조규연 on 10/22/23.
//

import Foundation

protocol MyPageTableViewDelegate: AnyObject {
    func didSelectCell(at indexPath: IndexPath)
}

protocol AdminTableViewDelegate: AnyObject {
    func didSelectCell(at indexPath: IndexPath)
}

protocol CommunityTableViewDelegate: AnyObject {
    func didSelectCell(at indexPath: IndexPath)
}
