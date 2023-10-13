import UIKit
import Then
import SnapKit

class InitialView: UIView {
    
    private lazy var imageView = UIImageView().then {
        $0.image = UIImage(named: "GYMGLE")
    }
    
    private lazy var loginLabel = UILabel().then {
        $0.textColor = ColorGuide.main
        $0.font = FontGuide.size19Bold
        $0.text = "로그인"
    }
    
    private lazy var idTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "아이디"
        $0.textAlignment = .center
        $0.font = FontGuide.size14
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.25
        $0.layer.shadowRadius = 2.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    private lazy var passwordTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "비밀번호"
        $0.textAlignment = .center
        $0.font = FontGuide.size14
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.25
        $0.layer.shadowRadius = 2.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    private lazy var loginButton = UIButton().then {
        $0.buttonMakeUI(backgroundColor: .white, cornerRadius: 10, borderWidth: 0.5, borderColor: ColorGuide.shadowBorder.cgColor, setTitle: "로그인", font: FontGuide.size14Bold, setTitleColor: ColorGuide.main)
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.25
        $0.layer.shadowRadius = 2.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    private lazy var adminButton = UIButton().then {
        $0.buttonMakeUI(backgroundColor: .clear, cornerRadius: 20, borderWidth: 1, borderColor: ColorGuide.shadowBorder.cgColor, setTitle: "관리자모드", font: FontGuide.size14Bold, setTitleColor: ColorGuide.main)
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.25
        $0.layer.shadowRadius = 2.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.backgroundColor = .white
        addSubview(imageView)
        addSubview(loginLabel)
        addSubview(idTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        addSubview(adminButton)
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(260)
            $0.left.right.equalToSuperview().inset(124)
            $0.height.equalTo(30)
        }
        
        loginLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(62)
            $0.left.equalToSuperview().offset(50)
        }
        
        idTextField.snp.makeConstraints {
            $0.top.equalTo(loginLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(45)
            $0.height.equalTo(46)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(45)
            $0.height.equalTo(46)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(45)
            $0.height.equalTo(55)
        }
        
        adminButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-60)
            $0.right.equalToSuperview().offset(-45)
            $0.width.equalTo(90)
            $0.height.equalTo(44)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
