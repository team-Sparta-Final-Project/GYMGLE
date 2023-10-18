
import UIKit

class PopUpView: UIView {
    lazy var backView = UIView().then{
        $0.backgroundColor = .black.withAlphaComponent(CGFloat(0.1))
    }
    lazy var contentView = UIView().then{
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 30
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.backgroundColor = .clear
        
        self.addSubview(backView)
        backView.snp.makeConstraints{
            $0.top.bottom.left.right.equalToSuperview()
        }

        self.addSubview(contentView)
        contentView.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(255)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        
        configure()
        
        
    }
    
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    private func configure(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
        self.backView.addGestureRecognizer(tap)
    }
    
    @objc func dismissPopUp(){
        self.removeFromSuperview()
        
    }

}
