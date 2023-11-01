//
//  CommunityCell.swift
//  GYMGLE
//
//  Created by t2023-m0088 on 2023/10/18.
//

import UIKit

class CommunityCell: UITableViewCell {
    
    //    lazy의 역할 찾아볼것
    lazy var allView: UIView = {
        let view = UIView()
        contentView.addSubview(view)
        view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.isHidden = false
        return view
    }()
    
//    init 안에서 allView랑 imageView 둘다 관여받고있기때문에 lazy var로 밖에 빼서 사용할 수 있음
    
    lazy var imageView1: UIImageView = {
        let view = UIImageView()
        allView.addSubview(view)
        view.leadingAnchor.constraint(equalTo: allView.leadingAnchor, constant: 12).isActive = true
        view.topAnchor.constraint(equalTo: allView.topAnchor, constant:12).isActive = true
        view.widthAnchor.constraint(equalToConstant: 24).isActive = true
        view.heightAnchor.constraint(equalToConstant: 24).isActive = true
        view.image = UIImage(named: "GYMGLE")
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var nameLabel : UILabel = {
        let view = UILabel()
        allView.addSubview(view)
        view.leadingAnchor.constraint(equalTo: imageView1.trailingAnchor, constant: 8).isActive = true
        view.centerYAnchor.constraint(equalTo: imageView1.centerYAnchor, constant: 0).isActive = true
        view.text = "스폰지밥"
        view.font = FontGuide.size14Bold
        view.textColor = ColorGuide.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
        

        let textLabel = UILabel()
        allView.addSubview(textLabel)
        textLabel.leadingAnchor.constraint(equalTo: imageView1.trailingAnchor, constant: 8).isActive = true
        textLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        let tlb = textLabel.bottomAnchor.constraint(equalTo: allView.bottomAnchor, constant: -24)
        tlb.priority = .init(rawValue: 999)
        tlb.isActive = true
        textLabel.text = "운동조아!!\n월요일조아\n하체 조아\n하체 짱\n하체 최고"
        textLabel.font = FontGuide.size14
        textLabel.textColor = ColorGuide.black
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 4

        
        let timeLabel = UILabel()
        allView.addSubview(timeLabel)
        timeLabel.trailingAnchor.constraint(equalTo: allView.trailingAnchor, constant: -20).isActive = true
        timeLabel.topAnchor.constraint(equalTo: allView.topAnchor, constant: 10).isActive = true
        timeLabel.text = "4시간"
        timeLabel.font = FontGuide.size14
        timeLabel.textColor = ColorGuide.textHint
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let replyLabel = UILabel()
        allView.addSubview(replyLabel)
        replyLabel.trailingAnchor.constraint(equalTo: allView.trailingAnchor, constant: -20).isActive = true
        replyLabel.bottomAnchor.constraint(equalTo: allView.bottomAnchor, constant: -10).isActive = true
        replyLabel.text = "답글 7개"
        replyLabel.font = FontGuide.size14
        replyLabel.textColor = ColorGuide.textHint
        replyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let LikeLabel = UILabel()
        allView.addSubview(LikeLabel)
        LikeLabel.trailingAnchor.constraint(equalTo: replyLabel.leadingAnchor, constant: -8).isActive = true
        LikeLabel.bottomAnchor.constraint(equalTo: allView.bottomAnchor, constant: -10).isActive = true
        LikeLabel.text = "좋아요 2330개"
        LikeLabel.font = FontGuide.size14
        LikeLabel.textColor = ColorGuide.textHint
        LikeLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.backgroundColor = ColorGuide.userBackGround
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setView(){
        self.layer.cornerRadius = 20
        self.backgroundColor = .white
    }

}
