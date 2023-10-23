import UIKit

class ManageTableView: UITableView {
    
    //MARK: - 셀 설정
    var cellData:[User] = []
    var cellHeight:Int = 40
    
    //MARK: - 라이프사이클
    override init(frame: CGRect, style: UITableView.Style) {
        super .init(frame: frame, style: style)
        
        self.backgroundColor = .clear
    
        self.allowsSelection = true
        
        self.separatorStyle = .none
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    
}
