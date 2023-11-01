import UIKit
import SnapKit

class BoardDetailCommentSection:UIView {
    
    let profileSize:CGFloat = 24.0
    
    let profileImage = UIImageView().then{
        $0.sizeToFit()
        $0.backgroundColor = .systemPink
        $0.image = UIImage(systemName: "star.fill")
    }
    
    let textField = UITextField().then{
        $0.placeholder = "댓글을 남겨보세요."
    }
    
    let button = UIButton.GYMGLEWhiteButtonPreset("등록")
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0.896, green: 0.896, blue: 0.896, alpha: 1)
        
        self.addSubview(profileImage)
        profileImage.snp.makeConstraints{
            $0.top.bottom.left.equalToSuperview().inset(20)
            $0.width.height.equalTo(profileSize)
        }
        profileImage.layer.cornerRadius = profileSize/2.0
        
        self.addSubview(button)
        button.snp.makeConstraints{
            $0.width.equalTo(54)
            $0.centerY.equalTo(profileImage)
            $0.right.equalToSuperview().inset(20)
        }
        
        self.addSubview(textField)
        textField.snp.makeConstraints{
            $0.centerY.equalTo(profileImage)
            $0.left.equalTo(profileImage.snp.right).offset(8)
            $0.right.equalTo(button.snp.left)
        }

        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
