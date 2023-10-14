import UIKit

class UserTableView: UITableView {
    
    //MARK: - 셀 설정
    var cellData:[String] = ["회원 이름","","회원 전화번호","","회원 아이디","","회원 비밀번호","","등록 기간","","추가 정보"]
    var labelCellData:[String] = ["등록 기간","","추가 정보"]
    var buttonCellData:[String] = ["회원 아이디"]
    var buttonText:[String] = ["중복 확인","확인"]
    var emptyCellHeight:Int?
    var cellHeight:Int?
    
    //MARK: - 라이프사이클
    override init(frame: CGRect, style: UITableView.Style) {
        super .init(frame: frame, style: style)
    
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

extension UserTableView: UITableViewDelegate {
    
}

extension UserTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if cellData[indexPath.row] == "" {
            let cell = EmptyCell()
            return cell
        }else if labelCellData.contains(cellData[indexPath.row]){
            let cell = LabelCell()
            cell.label.text = cellData[indexPath.row]
            return cell

        }
        else {
            let cell = TextFieldCell()
            cell.textField.placeholder = cellData[indexPath.row]
            if buttonCellData.contains(cellData[indexPath.row]) {
                
                cell.setButton(buttonText.first ?? "미설정")
                buttonText.remove(at: 0)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellData[indexPath.row] == "" {
            return CGFloat(emptyCellHeight ?? 12)
        } else {
            return CGFloat(cellHeight ?? 40)
        }
    }
    
}
