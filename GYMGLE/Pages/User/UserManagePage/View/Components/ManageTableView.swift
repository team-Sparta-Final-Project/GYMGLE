import UIKit

class ManageTableView: UITableView {
    
    //MARK: - 셀 설정
    var cellData:[String] = ["회원 이름","","회원 전화번호","","회원 아이디","","회원 비밀번호","","등록 기간","","추가 정보"]
    var labelCellData:[String] = ["등록 기간","","추가 정보"]
    var buttonCellData:[String] = ["회원 아이디"]
    var buttonText:[String] = ["중복 확인","확인"]
    var cellHeight:Int = 40
    
    //MARK: - 라이프사이클
    override init(frame: CGRect, style: UITableView.Style) {
        super .init(frame: frame, style: style)
        
        self.backgroundColor = .clear
    
        self.delegate = self
        self.dataSource = self
        self.isScrollEnabled = false
        self.allowsSelection = false

        self.separatorStyle = .none
        self.clipsToBounds = false
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    
}

extension ManageTableView: UITableViewDelegate {
    
}

extension ManageTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ManageLabelCell()
        cell.name.text = cellData[indexPath.row]
        cell.phone.text = "01011112222"
        cell.gender.text = "남"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
        
    }
    
}
//
