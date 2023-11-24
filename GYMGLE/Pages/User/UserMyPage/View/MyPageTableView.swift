//
//  myPageTableView.swift
//  GYMGLE
//
//  Created by 조규연 on 10/22/23.
//

import UIKit
import Kingfisher


class MyPageTableView: UITableView {
    // MARK: - Properties
    
    lazy var cellContents = ["프로필을 설정해주세요.", "공지사항", "로그아웃", "탈퇴하기", "비밀번호 변경"]
    lazy var secondOfCellContents = ["개인정보 처리방침", "서비스 이용약관", "앱 버전 1.1.1"]
    weak var myPageDelegate: MyPageTableViewDelegate?
    
    // MARK: - Initialization
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.separatorStyle = .none
        self.isScrollEnabled = false
        self.dataSource = self
        self.delegate = self
        self.register(MyPageTableViewCell.self, forCellReuseIdentifier: "MyPageCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyPageTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectRow(at: indexPath, animated: true)
        myPageDelegate?.didSelectCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.transform = CGAffineTransform(scaleX: 0.95, y: 0.90)
            cell?.backgroundColor = ColorGuide.shadowBorder
            cell?.layer.cornerRadius = 26
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 1 || indexPath.row != 2
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.transform = .identity
            cell?.backgroundColor = ColorGuide.white
        }
    }
}

extension MyPageTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cellContents.count
        } else {
            return secondOfCellContents.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageCell", for: indexPath) as! MyPageTableViewCell
        
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            cell.label.text = cellContents[indexPath.row]
            if indexPath.row == 0 {
                let imageView = UIImageView()
                if DataManager.shared.profile != nil {
                    cell.label.text = DataManager.shared.profile?.nickName
                    imageView.kf.setImage(with: DataManager.shared.profile?.image)
                } else {
                    imageView.image = UIImage(systemName: "person.fill")?.resized(to: CGSize(width: 36, height: 36))
                }
                
                imageView.layer.cornerRadius = 17
                imageView.backgroundColor = .gray
                imageView.clipsToBounds = true
                
                
                cell.addSubview(imageView)
                
                imageView.snp.makeConstraints {
                    $0.left.equalToSuperview().offset(20)
                    $0.centerY.equalToSuperview()
                    $0.height.width.equalTo(36)
                }
                
                cell.label.snp.makeConstraints {
                    $0.left.equalTo(imageView.snp.right).offset(10)
                    $0.centerY.equalToSuperview()
                }
            } else {
                cell.label.snp.makeConstraints {
                    $0.left.equalToSuperview().offset(20)
                    $0.centerY.equalToSuperview()
                }
            }
        } else if indexPath.section == 1 {
            cell.label.text = secondOfCellContents[indexPath.row]
            
            cell.label.snp.makeConstraints {
                $0.left.equalToSuperview().offset(20)
                $0.centerY.equalToSuperview()
            }
            if indexPath.row == 2 {
                cell.arrowImageView.isHidden = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return (section == 0) ? 0 : 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.isUserInteractionEnabled = false
        header.backgroundColor = ColorGuide.background
        header.frame.size.height = 1
        return header
    }
}
