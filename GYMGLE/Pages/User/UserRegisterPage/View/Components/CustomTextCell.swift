import UIKit

class CustomTextCell:UITableViewCell {
    
    lazy var textView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        textView.backgroundColor = .clear
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor(red: 0.894, green: 0.894, blue: 0.894, alpha: 1).cgColor
        textView.layer.cornerRadius = 10
        textView.font = FontGuide.size16
        textView.textColor = ColorGuide.black

        self.contentView.addSubview(textView)
        
        textView.snp.makeConstraints{
            $0.left.right.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
