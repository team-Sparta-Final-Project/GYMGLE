import UIKit

class ManageLabelCell:UITableViewCell {
    
    lazy var name = UILabel()
    lazy var phone = UILabel()
    lazy var gender = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        name.textColor = ColorGuide.textHint
        name.font = FontGuide.size14Bold
        phone.textColor = ColorGuide.textHint
        phone.font = FontGuide.size14
        gender.textColor = ColorGuide.textHint
        gender.font = FontGuide.size14


        
        self.backgroundColor = .clear
        
        
        self.contentView.clipsToBounds = true
        self.contentView.addSubview(name)
        self.contentView.addSubview(phone)
        self.contentView.addSubview(gender)
        
        name.snp.makeConstraints{
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        phone.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
        gender.snp.makeConstraints{
            $0.right.equalToSuperview()
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
//
