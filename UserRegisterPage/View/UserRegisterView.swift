import UIKit

class UserRegisterView: UIView {
    //MARK: - UI 컴포넌트 선언부
    lazy var label = UILabel()
    lazy var tableView = UserTableView()
    lazy var button = UIButton.GYMGLEButtonPreset("등록")
    
    
    //MARK: - View 자체 라이프사이클
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.backgroundColor = .white
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - 설정 함수
    private func configure(){
        
        topLabel()
        
        bottomButton()
        
        centerTableView()
        
    }
    //MARK: - 탑레이블
    private func topLabel(){
        
        label.text = "회원 등록"
        label.font = FontGuide.size32Bold
        
        self.addSubview(label)
        
        label.snp.makeConstraints{
            $0.top.equalToSuperview().inset(140)
            $0.left.equalToSuperview().inset(40)
            $0.height.equalTo(40)
        }
    }
    //MARK: - 센터 테이블 뷰
    private func centerTableView(){
        
        
        self.addSubview(tableView)
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(label.snp.bottom).offset(30)
            $0.left.right.equalToSuperview().inset(45)
            $0.bottom.equalTo(button.snp.top).inset(-18)
        }
    }
    //MARK: - 바텀 버튼
    private func bottomButton(){
        
        
        self.addSubview(button)
        
        button.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(80)
            $0.left.right.equalToSuperview().inset(117)
            $0.height.equalTo(50)
        }
    }
}
