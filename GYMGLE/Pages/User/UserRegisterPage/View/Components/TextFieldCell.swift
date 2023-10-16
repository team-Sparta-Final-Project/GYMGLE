import UIKit
import Then

class TextFieldCell:UITableViewCell {
    
    lazy var textField = CustomTextField()
    lazy var placeHolderLabel = UILabel().then{
        $0.text = "기본값"
        $0.font = FontGuide.size14Bold
        $0.textColor = ColorGuide.textHint
        
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        textField.delegate = self
                
        textField.textColor = ColorGuide.textHint
        textField.font = FontGuide.size14Bold
        
        textField.backgroundColor = .clear
        
        self.layer.frame.size.width = 344.5
//        self.contentView.layer.addBorder([.bottom], color: ColorGuide.shadowBorder, width: 1.0)
        self.contentView.clipsToBounds = true
        
        makeUI()
        
        self.contentView.addSubview(placeHolderLabel)
        self.contentView.addSubview(textField)
        
//        placeHolderLabel.backgroundColor = .blue
        
        placeHolderLabel.snp.makeConstraints{
            $0.left.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(10)
        }
        
        textField.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI(){
//        self.contentView.backgroundColor = .gray
        self.contentView.clipsToBounds = true
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

extension TextFieldCell: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("테스트 - 수정시작됨")
        self.placeHolderLabel.font = UIFont.systemFont(ofSize: 10)
//        self.placeHolderLabel.backgroundColor = .red
        self.placeHolderLabel.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(30)
        }
        
        
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        print("테스트 - 수정끝")
        self.placeHolderLabel.font = UIFont.systemFont(ofSize: 10)
//        self.placeHolderLabel.backgroundColor = .blue
        self.placeHolderLabel.snp.makeConstraints{
            $0.left.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(10)
        }

    }
    
}
