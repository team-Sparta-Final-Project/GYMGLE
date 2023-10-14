//
//  AdminNoticeDetailView.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/14.
//

import UIKit

final class AdminNoticeDetailView: UIView {
    // MARK: - UI Properties
    private lazy var pageTitleLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size32Bold, textAligment: .center)
        label.text = "내용"
        return label
    }()
    
    private let topDivider: UIView = {
        let divider = UIView()
        divider.backgroundColor = ColorGuide.textHint.withAlphaComponent(0.4)
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.text = "텍스트를 여기에 입력하세요."
        textView.font = FontGuide.size16
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let bottomDivider: UIView = {
        let divider = UIView()
        divider.backgroundColor = ColorGuide.textHint.withAlphaComponent(0.4)
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    lazy var contentNumberLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size16, textAligment: .center)
        label.text = "\(contentTextView.text.count)/400"
        return label
    }()
    
    lazy var createButton: UIButton = {
        let button = UIButton()
        button.buttonMakeUI(backgroundColor: ColorGuide.main, cornerRadius: 10.0, borderWidth: 0.0, borderColor: UIColor
            .clear.cgColor, setTitle: "등록하기", font: FontGuide.size19Bold, setTitleColor: UIColor.white)
        return button
    }()
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        viewMakeUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - extension
private extension AdminNoticeDetailView {
    func viewMakeUI() {
        let views = [pageTitleLabel, topDivider, contentTextView, bottomDivider, contentNumberLabel, createButton]
        for view in views {
            self.addSubview(view)
        }
        NSLayoutConstraint.activate([
            pageTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            pageTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 88),
            
            topDivider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            topDivider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            topDivider.heightAnchor.constraint(equalToConstant: 2),
            topDivider.topAnchor.constraint(equalTo: self.pageTitleLabel.bottomAnchor, constant: 60),
            
            contentTextView.topAnchor.constraint(equalTo: self.topDivider.bottomAnchor, constant: 8),
            contentTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            contentTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            contentTextView.bottomAnchor.constraint(equalTo: self.bottomDivider.topAnchor, constant: 0),
            
            bottomDivider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            bottomDivider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            bottomDivider.bottomAnchor.constraint(equalTo: self.createButton.topAnchor, constant: -104),
            bottomDivider.heightAnchor.constraint(equalToConstant: 2),
            
            contentNumberLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -26),
            contentNumberLabel.topAnchor.constraint(equalTo: self.bottomDivider.bottomAnchor, constant: 10),
            
            createButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            createButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            createButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -124),
            createButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
