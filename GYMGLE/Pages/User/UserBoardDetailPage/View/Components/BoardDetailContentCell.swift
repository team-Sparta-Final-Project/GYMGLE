import UIKit
import SnapKit
import Then
import Firebase

protocol BoardProfilelikeButtonDelegate {
    func likeButtonTapped(button: UIButton)
}

class BoardDetailContentCell: UITableViewCell {
    
    var likeDelegate:BoardProfilelikeButtonDelegate?
    
    let profileSize:CGFloat = 24.0
    
    var liked:Bool = false
    
    let profileLine = BoardProfileLine()
    
    let contentLabel = UILabel().then{
        $0.numberOfLines = 0
        $0.font = FontGuide.size14
        $0.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        
        //"오늘도 운동 완료!\n하제하기 싫은거 인정?"
    }
    
    let commentCount = UILabel().then{
        $0.textColor = ColorGuide.textHint
        $0.text = "답글 12개"
        $0.font = FontGuide.size14
    }
    
    let likeCount = UILabel().then{
        $0.textColor = ColorGuide.textHint
        $0.text = "좋아요 20개"
        $0.font = FontGuide.size14
    }
    
    let likeButton = UIButton().then{
        $0.tintColor = ColorGuide.textHint
        $0.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(){
        
        self.contentView.addSubview(profileLine)
        profileLine.snp.makeConstraints{
            $0.top.left.right.equalToSuperview().inset(20)
        }
        
        
        self.contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints{
            $0.top.equalTo(profileLine.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        self.contentView.addSubviews(commentCount,likeCount,likeButton)
        commentCount.snp.makeConstraints{
            $0.left.equalTo(profileLine.snp.left)
            $0.top.equalTo(contentLabel.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().inset(10)
        }
        likeCount.snp.makeConstraints{
            $0.left.equalTo(commentCount.snp.right).offset(8)
            $0.centerY.equalTo(commentCount.snp.centerY)
        }
        likeButton.snp.makeConstraints{
            $0.centerY.equalTo(commentCount.snp.centerY)
            $0.right.equalToSuperview().inset(20)
        }
        
    }
    
    @objc func likeButtonTapped(){
        self.likeDelegate?.likeButtonTapped(button: likeButton)
    }
}
