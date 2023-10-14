import UIKit

class TextFieldCell:UITableViewCell {
    
    lazy var textField = CustomTextField()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
                
        textField.textColor = ColorGuide.textHint
        textField.font = FontGuide.size14Bold
        
        self.contentView.layer.addBorder([.bottom], color: ColorGuide.shadowBorder, width: 1.0)
        self.contentView.clipsToBounds = true
        
        
//        var test = self.contentView.layer.frame.width
//        var test2 = self.frame.width
//        print("테스트 - \(test)","테스트 - \(test2)",separator: "\n")
        
        self.contentView.addSubview(textField)
        
        textField.snp.makeConstraints{
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButton(_ title:String){
        lazy var CheckButton = UIButton.GYMGLEWhiteButtonPreset(title)
        
        self.contentView.addSubview(CheckButton)
        CheckButton.snp.makeConstraints{
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(74)
            $0.height.equalTo(26)
        }
    }
}

