import UIKit
import SnapKit
import Then

protocol BoardDetailContentCellDelegate {
    func likeButtonTarget()
}

class BoardDetailContentCell: UITableViewCell {
    
    let profileSize:CGFloat = 24.0
    
    let profileMini = BoardProfileMini()
    
    let contentLabel = UILabel().then{
        $0.numberOfLines = 0
        $0.font = FontGuide.size14
        $0.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

        //"오늘도 운동 완료!\n하제하기 싫은거 인정?"
    }
    
    let timeLabel = UILabel().then{
        $0.textColor = ColorGuide.textHint
        $0.text = "2시간 전"
        $0.font = FontGuide.size14
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
    
    let likeButton = UIImageView().then{
        $0.tintColor = ColorGuide.textHint
        $0.image = UIImage(systemName: "heart")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        
    func configure(){

        self.addSubview(profileMini)
        profileMini.snp.makeConstraints{
            $0.top.left.equalToSuperview().inset(20)
        }
        
        self.addSubview(timeLabel)
        timeLabel.snp.makeConstraints{
            $0.centerY.equalTo(profileMini)
            $0.top.right.equalToSuperview().inset(20)
        }
        
        self.addSubview(contentLabel)
        contentLabel.snp.makeConstraints{
            $0.top.equalTo(profileMini.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(20)
        }

        self.addSubviews(commentCount,likeCount,likeButton)
        commentCount.snp.makeConstraints{
            $0.left.equalTo(profileMini.snp.left)
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
    
    
}
