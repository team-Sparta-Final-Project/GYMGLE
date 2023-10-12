import UIKit
import Then
import SnapKit

class ViewView: UIView {
    
    private lazy var button = UIButton().then {
        $0.buttonMakeUI(backgroundColor: ColorGuide.main, cornerRadius: 10.0, borderWidth: 0.0, borderColor: UIColor
            .clear.cgColor, setTitle: "buuton", font: FontGuide.size16Bold, setTitleColor: UIColor.white)
    }
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.backgroundColor = .white
        addSubview(button)
        
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(117)
            $0.height.equalTo(50)
        }
        
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        super .init(coder: coder)
    }
    
    
}
