import UIKit

class UserRegisterView: UIView {
    //MARK: - UI 컴포넌트 선언부
    lazy var label = UILabel()
    lazy var tableView = UserTableView()
    lazy var button:UIButton = UIButton.GYMGLEButtonPreset("버튼 타이틀")
    lazy var textView = UITextView()
    
    let items = ["회원", "트레이너"]
    lazy var segmented = UISegmentedControl(items: items)

    //MARK: - View 자체 라이프사이클
    override init(frame: CGRect) {
        super .init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - 뷰에 요소 배치 함수 (순서 조심)
    private func configure(){
        self.backgroundColor = ColorGuide.background
        
//        topLabel()
        bottomButton()
        centerTableView()
        addTextView()
        
        segmentedConfigure()
        
        
    }
    //MARK: - 테이블뷰 configure
    func heightConfigure(cellHeight:Int, emptyCellHeight:Int){
        tableView.cellHeight = cellHeight
        tableView.emptyCellHeight = emptyCellHeight
    }
    //MARK: - 세그먼티드 컨트롤
    
    private func segmentedConfigure(){
        
        segmented.selectedSegmentIndex = 0
        
        segmented.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : ColorGuide.white], for: .selected)
        segmented.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(red: 0, green: 0, blue: 0, alpha: 0.61)], for: .normal)
        segmented.selectedSegmentTintColor = ColorGuide.main
        
        self.addSubviews(segmented)
        
        segmented.snp.makeConstraints{
            $0.top.equalToSuperview().inset(92)
            $0.right.equalToSuperview().inset(22)
        }
        
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
            $0.top.equalToSuperview().inset(132)
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
