//
//  AdminNoticeView.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/14.
//

import UIKit

final class AdminNoticeView: UIView {

    // MARK: - UI Properties
    private lazy var pageTitleLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size32Bold, textAligment: .center)
        label.text = "공지사항"
        return label
    }()
    
    lazy var noticeCreateButton: UIButton = {
        let button = UIButton()
        button.buttonImageMakeUI(backgroundColor: .white, image: "pencil", color: ColorGuide.black, cornerRadius: 10, borderWidth: 2.0, borderColor: ColorGuide.shadowBorder.cgColor)
        return button
    }()
    
    lazy var noticeTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = ColorGuide.background
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewMakeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - extension
private extension AdminNoticeView {
    func viewMakeUI() {
        let views = [pageTitleLabel, noticeCreateButton, noticeTableView]
        for view in views {
            self.addSubview(view)
        }
        
        NSLayoutConstraint.activate([
            pageTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            pageTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 88),
            
            noticeCreateButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 88),
            noticeCreateButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            noticeCreateButton.heightAnchor.constraint(equalToConstant: 40),
            noticeCreateButton.widthAnchor.constraint(equalToConstant: 40),
            
            noticeTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            noticeTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -0),
            noticeTableView.topAnchor.constraint(equalTo: pageTitleLabel.bottomAnchor, constant: 56),
            noticeTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -0),
        ])
    }
}
