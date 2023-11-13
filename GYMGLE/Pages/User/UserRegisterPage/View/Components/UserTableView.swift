import UIKit

protocol UserTableViewDelegate {
    func cellTypeConfigure(cell:[String],labelOrder:[String],buttonText:[String])
    func heightConfigure(height:Int,empty:Int)
    func dateButtonTarget(cell:LabelCell,text:String)
    func textFieldTarget(cell:TextFieldCell)
    func textViewTarget(cell:CustomTextCell)
    func emailButtonTarget(cell:TextFieldCell)
}

class UserTableView: UITableView {
    // TODO: 데이터를 컨트롤러에서 애초에 전달받을 이유가 없고 여기서 그려주면 됨 그리고 셀자체를 여러개 파일로만들어서 관리하기 쉽게 하자
    // 버튼 셀, 라벨 셀, 텍스트 셀 이 세개로 애초에 만드는 것
    //MARK: - 셀 설정
    var cellData:[String] = []
    var labelCellData:[String] = []
    var buttonText:[String] = []
    var emptyCellHeight:Int = 12
    var cellHeight:Int = 40
    
    var myDelegate: UserTableViewDelegate?
    
    //MARK: - 라이프사이클
    override init(frame: CGRect, style: UITableView.Style) {
        super .init(frame: frame, style: style)
        
        self.backgroundColor = .clear
    
        self.delegate = self
        self.dataSource = self
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
            if indexPath.row == (cellData.count - 1) {
            }else{
                cell.contentView.layer.addBorder([.bottom], color: ColorGuide.shadowBorder, width: 1.0)
            }
            cell.label.text = cellData[indexPath.row]
            if buttonText.count != 0 {
                cell.CheckButton.setTitle(buttonText.first, for: .normal)
                myDelegate?.dateButtonTarget(cell: cell, text: cellData[indexPath.row])
                buttonText.remove(at: 0)
            }else {
                cell.CheckButton.isHidden = true
            }
            
            
            
            return cell

        }
        else if cellData[indexPath.row] == "textView" {
            let cell = CustomTextCell()
            myDelegate?.textViewTarget(cell: cell)
            return cell
        }else if cellData[indexPath.row] == "회원 이메일" {
            let cell = TextFieldCell()
            cell.contentView.layer.addBorder([.bottom], color: ColorGuide.shadowBorder, width: 1.0)
            cell.placeHolderLabel.text = cellData[indexPath.row]
            cell.setButton("인증")
            myDelegate?.emailButtonTarget(cell: cell)
            return cell
        }
        else {
            let cell = TextFieldCell()
            cell.contentView.layer.addBorder([.bottom], color: ColorGuide.shadowBorder, width: 1.0)
            cell.placeHolderLabel.text = cellData[indexPath.row]
            
            myDelegate?.textFieldTarget(cell: cell)
            return cell

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellData[indexPath.row] == "" {
            return CGFloat(emptyCellHeight)
        } else if cellData[indexPath.row] == "textView" {
            return CGFloat(100.0)
        } else {
            return CGFloat(cellHeight)
        }
    }
    
}
//
