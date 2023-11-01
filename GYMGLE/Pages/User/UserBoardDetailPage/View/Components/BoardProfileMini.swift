import UIKit
import SnapKit

class BoardProfileMini:UIView {
    
    let profileSize:CGFloat = 24.0
    
    let profileImage = UIImageView().then{
        $0.sizeToFit()
        $0.backgroundColor = .systemPink
        $0.image = UIImage(systemName: "star.fill")
    }
    
    let writerLabel = UILabel().then{
        $0.font = FontGuide.size14
        $0.text = "말티즈국밥"
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        self.addSubview(profileImage)
        profileImage.snp.makeConstraints{
            $0.top.left.bottom.equalToSuperview()
            $0.width.height.equalTo(profileSize)
        }
        profileImage.layer.cornerRadius = profileSize/2.0
        
        self.addSubview(writerLabel)
        writerLabel.snp.makeConstraints{
            $0.left.equalTo(profileImage.snp.right).offset(8)
            $0.right.equalToSuperview()
            $0.centerY.equalTo(profileImage.snp.centerY)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
