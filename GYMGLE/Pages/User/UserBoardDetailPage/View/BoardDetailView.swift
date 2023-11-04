import UIKit
import SnapKit

class BoardDetailView: UIView {
    
    let tableView = BoardDetailTableView()
    let commentSection = BoardDetailCommentSection()
        
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        self.backgroundColor = ColorGuide.background
        
        
        //MARK: - main
    
        self.addSubview(commentSection)
        commentSection.snp.makeConstraints{
            $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top)
            $0.left.right.equalToSuperview()
        }
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.top.equalToSuperview().inset(52)
            $0.bottom.equalTo(commentSection.snp.top)
            $0.left.right.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
