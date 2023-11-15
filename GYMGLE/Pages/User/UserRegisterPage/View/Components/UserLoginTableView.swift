import UIKit


class UserLoginTableView: UITableView {
    // TODO: 데이터를 컨트롤러에서 애초에 전달받을 이유가 없고 여기서 그려주면 됨 그리고 셀자체를 여러개 파일로만들어서 관리하기 쉽게 하자
    // 버튼 셀, 라벨 셀, 텍스트 셀 이 세개로 애초에 만드는 것
    //MARK: - 셀 설정
        
    //MARK: - 라이프사이클
    override init(frame: CGRect, style: UITableView.Style) {
        super .init(frame: frame, style: style)
        
        self.backgroundColor = .clear
    
        self.isScrollEnabled = true
        self.allowsSelection = false

        self.separatorStyle = .none
        self.clipsToBounds = false
        
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        fatalError("init(coder:) has not been implemented")
        
    }
    
}
