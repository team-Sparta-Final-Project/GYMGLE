import UIKit

class UserTableView: UITableView {
    
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
    
    let temp = ["회원 이름","","회원 전화번호","","회원 아이디","","회원 비밀번호","","등록 기간","","추가 정보"]
    
}

extension UserTableView: UITableViewDelegate {
    
}

extension UserTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temp.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if temp[indexPath.row] == "" {
            let cell = TopBordercell()
            return cell
        }else if temp[indexPath.row] == "등록 기간" || temp[indexPath.row] == "추가 정보" {
            let cell = LabelCell()
            cell.label.text = temp[indexPath.row]
            return cell

        }
        else {
            let cell = TextFieldCell()
            cell.textField.placeholder = temp[indexPath.row]
            if temp[indexPath.row] == "회원 아이디" {
                cell.setButton("중복 확인")
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if temp[indexPath.row] == "" {
            return 24
        } else {
            return 45
        }
    }
    
}
