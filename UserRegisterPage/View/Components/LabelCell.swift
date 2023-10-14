import UIKit

class LabelCell:UITableViewCell {
    
    lazy var label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        label.textColor = ColorGuide.textHint
        label.font = FontGuide.size14Bold
        
        
        self.contentView.layer.addBorder([.bottom], color: ColorGuide.shadowBorder, width: 1.0)
        self.contentView.clipsToBounds = true
        self.contentView.addSubview(label)
        
        
        label.snp.makeConstraints{
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum textType{
        case label, textField
    }
}
