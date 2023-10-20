import UIKit

class UserRegisterView: UIView {
    //MARK: - UI 컴포넌트 선언부
    lazy var label = UILabel()
    lazy var tableView = UserTableView()
    lazy var button:UIButton = UIButton.GYMGLEButtonPreset("버튼 타이틀")
    lazy var textView = UITextView()
        
    //MARK: - View 자체 라이프사이클
    override init(frame: CGRect) {
        super .init(frame: frame)
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
        addTextView()
    }
    //MARK: - 테이블뷰 configure
    func heightConfigure(cellHeight:Int, emptyCellHeight:Int){
        tableView.cellHeight = cellHeight
        tableView.emptyCellHeight = emptyCellHeight
    }
    
    func dataSourceConfigure(cells:[String],labels:[String],buttons:[String],buttonText:[String]){
        
        let maped = cells.map{ [$0] }
        let joined = Array(maped.joined(separator: [""]))
        
        tableView.cellData = joined
        tableView.labelCellData = labels
        tableView.buttonCellData = buttons
        tableView.buttonText = buttonText
    }
    //MARK: - 탑레이블
    private func topLabel(){
        
        label.text = "페이지 타이틀 레이블"
        label.font = FontGuide.customFont(size: 32, lineHeight: 40, isBold: true)
        
        self.addSubview(label)
        
        label.snp.makeConstraints{
            $0.top.equalToSuperview().inset(88)
            $0.left.equalToSuperview().inset(22)
            $0.height.equalTo(34)
        }
    }
    //MARK: - 센터 테이블 뷰
    private func centerTableView(){
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.top.equalTo(label.snp.bottom).offset(35)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalTo(button.snp.top).inset(-280)
        }
    }
    //MARK: - 텍스트 뷰
    private func addTextView(){
        
        textView.backgroundColor = .clear
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor(red: 0.894, green: 0.894, blue: 0.894, alpha: 1).cgColor
        textView.layer.cornerRadius = 10
        self.addSubview(textView)
        
        
        textView.snp.makeConstraints{
            $0.left.right.equalToSuperview().inset(24)
            $0.top.equalTo(tableView.snp.bottom).inset(10)
            $0.bottom.equalTo(button.snp.top).offset(-150)
        }
    }
    
    
    
    //MARK: - 바텀 버튼
    private func bottomButton(){
        
        self.addSubview(button)
        
        button.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(40)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
    }
}
//
