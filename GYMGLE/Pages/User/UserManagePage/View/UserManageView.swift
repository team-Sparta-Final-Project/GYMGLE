import UIKit

class UserManageView: UIView {
    //test
    //MARK: - UI 컴포넌트 선언부
    lazy var label = UILabel()
    lazy var tableView = ManageTableView()
    lazy var CustomSearchBar = UISearchBar()
    
    
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
        CenterSearchBar()
        centerTableView()
        
        
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
    //MARK: - 서치 바 커스텀
    
    private func CenterSearchBar(){
        CustomSearchBar.searchBarStyle = .minimal
        CustomSearchBar.placeholder = "검색"
        
        if let textfield = CustomSearchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor(red: 0.887, green: 0.887, blue: 0.887, alpha: 1)
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "gr-d") ?? .white, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)])
            textfield.textColor = .white
            textfield.font = UIFont.systemFont(ofSize: 12)
            
            if let leftView = textfield.leftView as? UIImageView {
                leftView.tintColor = .white
            }
            
            textfield.snp.makeConstraints{
                $0.top.bottom.left.right.equalToSuperview()
            }
        }
            
        self.addSubviews(CustomSearchBar)
        CustomSearchBar.snp.makeConstraints{
            $0.top.equalTo(label.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(30)
        }
    }
    
    //MARK: - 센터 테이블 뷰
    private func centerTableView(){
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.top.equalTo(CustomSearchBar.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(-18)
        }
    }
}
//
