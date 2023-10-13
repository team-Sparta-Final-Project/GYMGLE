//
//  AdminRootView.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/13.
//

import UIKit

final class AdminRootView: UIView {

    // MARK: - UIProperties

    
    private lazy var pageTitleLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size32Bold, textAligment: .center)
        return label
    }()
    
    private lazy var gymNameLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size14, textAligment: .center)
        return label
    }()
    
    private lazy var gymNumberLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size14, textAligment: .center)
        return label
    }()
    
    private lazy var gymLabelStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [gymNameLabel,gymNumberLabel])
        stack.spacing = 2
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var gymSettingButton: UIButton = {
        let button = UIButton()
        //button.buttonMakeUI(backgroundColor: <#T##UIColor#>, cornerRadius: <#T##CGFloat#>, borderWidth: <#T##CGFloat#>, borderColor: <#T##CGColor#>, setTitle: <#T##String#>, font: <#T##UIFont#>, setTitleColor: <#T##UIColor#>)
        return button
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
