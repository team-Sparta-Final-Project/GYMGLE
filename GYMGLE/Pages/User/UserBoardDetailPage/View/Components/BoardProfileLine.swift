import UIKit
import SnapKit

protocol BoardProfileInfoButtonDelegate {
    func infoButtonTapped(isBoard:Bool, commentUid:String, writerUid:String)
}

class BoardProfileLine:UIView {
    
    var infoDelegate:BoardProfileInfoButtonDelegate?
        
    var commentUid = ""
    var writerUid = ""
    var isBoard = false
        
    let profileSize:CGFloat = 24.0
    
    lazy var profileImage = UIButton().then{
        $0.clipsToBounds = true
        $0.sizeToFit()
        $0.setImage(UIImage(systemName: "star.fill"), for: .normal)
    }
    
    let writerLabel = UILabel().then{
        $0.font = FontGuide.size14
        $0.text = "말티즈국밥"
    }
    
    let timeLabel = UILabel().then{
        $0.textColor = ColorGuide.textHint
        $0.text = "2시간"
        $0.font = FontGuide.size14
    }
    
    let infoButton = UIButton().then{
        $0.tintColor = ColorGuide.textHint
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
    }


    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        
        
        self.addSubview(profileImage)
        profileImage.snp.makeConstraints{
            $0.top.left.bottom.equalToSuperview()
            $0.width.height.equalTo(profileSize)
        }
        profileImage.layer.cornerRadius = profileSize/2.0
        
        self.addSubview(writerLabel)
        writerLabel.snp.makeConstraints{
            $0.left.equalTo(profileImage.snp.right).offset(8)
            $0.centerY.equalTo(profileImage)
        }
        
        self.addSubview(timeLabel)
        timeLabel.snp.makeConstraints{
            $0.centerY.equalTo(profileImage)
            $0.left.equalTo(writerLabel.snp.right).offset(4)
        }

        self.addSubview(infoButton)
        infoButton.snp.makeConstraints{
            $0.centerY.equalTo(profileImage)
            $0.right.equalToSuperview()
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func infoButtonTapped(){
        self.infoDelegate?.infoButtonTapped(isBoard: isBoard, commentUid: commentUid, writerUid: writerUid)
    }
        
}
