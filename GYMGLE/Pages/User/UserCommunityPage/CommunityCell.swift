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
    
    
    
//    ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
//    아래가 내 헬스장 내용
    
    lazy var myallView: UIView = {
        let view = UIView()
        contentView.addSubview(view)
        view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.isHidden = true
        return view
    }()
    
//    init 안에서 allView랑 imageView 둘다 관여받고있기때문에 lazy var로 밖에 빼서 사용할 수 있음
    
    lazy var myimageView1: UIImageView = {
        let view = UIImageView()
        myallView.addSubview(view)
        view.leadingAnchor.constraint(equalTo: myallView.leadingAnchor, constant: 12).isActive = true
        view.topAnchor.constraint(equalTo: myallView.topAnchor, constant:12).isActive = true
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
        view.topAnchor.constraint(equalTo: allView.topAnchor, constant: 10).isActive = true
        view.text = "스폰지밥"
        view.font = FontGuide.size14Bold
        view.textColor = ColorGuide.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var ctextLabel : UILabel = {
        let view = UILabel()
        allView.addSubview(view)
        view.leadingAnchor.constraint(equalTo: imageView1.trailingAnchor, constant: 8).isActive = true
        view.trailingAnchor.constraint(equalTo: allView.trailingAnchor, constant: -30).isActive = true
        view.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        let tlb = view.bottomAnchor.constraint(equalTo: allView.bottomAnchor, constant: -30)
        tlb.priority = .init(rawValue: 999)
        tlb.isActive = true
        view.text = "운동조아!!\n월요일조아\n하체 조아\n하체 짱\n하체 최고"
        view.font = FontGuide.size14
        view.textColor = ColorGuide.black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
        
//
//        let textLabel = UILabel()
//        allView.addSubview(textLabel)
//        textLabel.leadingAnchor.constraint(equalTo: imageView1.trailingAnchor, constant: 8).isActive = true
//        textLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
//        let tlb = textLabel.bottomAnchor.constraint(equalTo: allView.bottomAnchor, constant: -12)
//        tlb.priority = .init(rawValue: 999)
//        tlb.isActive = true
//        textLabel.text = "운동조아!!\n월요일조아\n하체 조아\n하체 짱\n하체 최고"
//        textLabel.font = FontGuide.size14
//        textLabel.textColor = ColorGuide.black
//        textLabel.translatesAutoresizingMaskIntoConstraints = false
//        textLabel.numberOfLines = 0

        
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
        
    //    ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
    //    아래가 내 헬스장 내용
        
        let mynameLabel = UILabel()
        myallView.addSubview(mynameLabel)
        mynameLabel.leadingAnchor.constraint(equalTo: myimageView1.trailingAnchor, constant: 8).isActive = true
        mynameLabel.topAnchor.constraint(equalTo: myallView.topAnchor, constant: 10).isActive = true
        mynameLabel.text = "말티즈국밥"
        mynameLabel.font = FontGuide.size14Bold
        mynameLabel.textColor = ColorGuide.black
        mynameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let mytextLabel = UILabel()
        myallView.addSubview(mytextLabel)
        mytextLabel.leadingAnchor.constraint(equalTo: myimageView1.trailingAnchor, constant: 8).isActive = true
        mytextLabel.topAnchor.constraint(equalTo: mynameLabel.bottomAnchor, constant: 4).isActive = true
        let tlbs = mytextLabel.bottomAnchor.constraint(equalTo: myallView.bottomAnchor, constant: -12)
        tlbs.priority = .init(rawValue: 999)
        tlbs.isActive = true
        mytextLabel.text = "오늘운동완료!!\n하체 하기싫어용\n하체 하기싫어용\n하체 하기싫어용\n하체 하기싫어용"
        mytextLabel.font = FontGuide.size14
        mytextLabel.textColor = ColorGuide.black
        mytextLabel.translatesAutoresizingMaskIntoConstraints = false
        mytextLabel.numberOfLines = 0

        
        let mytimeLabel = UILabel()
        myallView.addSubview(mytimeLabel)
        mytimeLabel.trailingAnchor.constraint(equalTo: myallView.trailingAnchor, constant: -20).isActive = true
        mytimeLabel.topAnchor.constraint(equalTo: myallView.topAnchor, constant: 10).isActive = true
        mytimeLabel.text = "12시간"
        mytimeLabel.font = FontGuide.size14
        mytimeLabel.textColor = ColorGuide.textHint
        mytimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let myreplyLabel = UILabel()
        myallView.addSubview(myreplyLabel)
        myreplyLabel.trailingAnchor.constraint(equalTo: myallView.trailingAnchor, constant: -20).isActive = true
        myreplyLabel.bottomAnchor.constraint(equalTo: myallView.bottomAnchor, constant: -10).isActive = true
        myreplyLabel.text = "답글 12개"
        myreplyLabel.font = FontGuide.size14
        myreplyLabel.textColor = ColorGuide.textHint
        myreplyLabel.translatesAutoresizingMaskIntoConstraints = false
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
        
//        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.backgroundColor = .white
//        NSLayoutConstraint.activate([
//            self.topAnchor.constraint(equalTo: self.bottomAnchor , constant: 8),
//            self.heightAnchor.constraint(equalToConstant: 120),
//            self.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 0),
//            self.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: 0),
//        ])
    }

}
