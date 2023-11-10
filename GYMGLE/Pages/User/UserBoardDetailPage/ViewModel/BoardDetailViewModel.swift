//
//  BoardDetailViewModel.swift
//  GYMGLE
//
//  Created by t2023-m0078 on 2023/11/10.
//
import Firebase
import Foundation
import Combine

class BoardDetailViewModel: ObservableObject {
    
    var bind = tempViewModel()
    
    var board:Board?
    var boardUid:String?
    
    var disposableBag = Set<AnyCancellable>()
    //MARK: - original
    @Published var tableData:[Any] = []
    
    let ref = Database.database().reference()
    
    init(){
        print("테스트 - 뷰모델 불러옴")
        
        self.bind.$board.sink{
            self.board = $0
        }.store(in: &disposableBag)
    }
    
    func downloadComments( complition: @escaping () -> () ){
        
        ref.child("boards/\(boardUid!)/comments").observeSingleEvent(of: .value) { [self] DataSnapshot,arg  in
            guard let value = DataSnapshot.value as? [String:Any] else {
                self.tableData = [self.board!]
                complition()
                return
            }
            var temp:[String:Comment] = [:]
            for i in value {
                do {
                    let JSONdata = try JSONSerialization.data(withJSONObject: i.value)
                    let comment = try JSONDecoder().decode(Comment.self, from: JSONdata)
                    temp.updateValue(comment, forKey: i.key)
                } catch let error {
                    print("테스트 - \(error)")
                }
            }
            self.tableData = [self.board!]
            self.tableData += temp.sorted(by: { $0.1.date < $1.1.date })
            
            complition()
            
        }
    }
    
    
    
    
}
