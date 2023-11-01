import UIKit
import SnapKit

class BoardDetailView: UIView {
    
    let tableView = BoardDetailTableView()
//    let contentView = BoardDetailContentView()
    let commentSection = BoardDetailCommentSection()
    
    let tempBottomSpace = UIView().then{
        $0.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        self.backgroundColor = ColorGuide.background
        
        self.addSubview(tempBottomSpace)
        tempBottomSpace.snp.makeConstraints{
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(100)
        }
        //MARK: - main
                
        self.addSubview(commentSection)
        commentSection.snp.makeConstraints{
            $0.bottom.equalTo(tempBottomSpace.snp.top)
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
