import UIKit

class CustomTextCell:UITableViewCell {
    
    lazy var textView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .red
        
        self.addSubviews(textView)
//        textView.snp.makeConstraints{
//            $0.top.bottom.left.right.equalToSuperview()
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
