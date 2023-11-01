import UIKit

class LabelCell:UITableViewCell {
    
    lazy var label = UILabel()
    lazy var CheckButton = UIButton.GYMGLEWhiteButtonPreset("텍스트")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        label.textColor = ColorGuide.textHint
        label.font = FontGuide.size14Bold
        
        self.backgroundColor = .clear
        
        self.layer.frame.size.width = 344.5
//        self.contentView.layer.addBorder([.bottom], color: ColorGuide.shadowBorder, width: 1.0)
        self.contentView.clipsToBounds = true
        self.contentView.addSubview(label)
        
        
        label.snp.makeConstraints{
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        self.contentView.addSubview(CheckButton)
        CheckButton.snp.makeConstraints{
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(74)
            $0.height.equalTo(26)
        }

        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
