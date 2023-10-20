import UIKit

class ManageTableView: UITableView {
    
    //MARK: - 셀 설정
    var cellData:[User] = []
    var cellHeight:Int = 40
    
    //MARK: - 라이프사이클
    override init(frame: CGRect, style: UITableView.Style) {
        super .init(frame: frame, style: style)
        
        self.backgroundColor = .clear
    
        self.dataSource = self
        self.allowsSelection = true

        self.separatorStyle = .none
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    
}


extension ManageTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ManageLabelCell()
        cell.name.text = cellData[indexPath.row].name
        cell.phone.text = cellData[indexPath.row].number
        cell.gender.text = "남"
        
        if cellData.count == (indexPath.row + 1) {
            cell.contentView.layer.addBorder([.bottom], color: ColorGuide.shadowBorder, width: 1.0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("테스트 - \(indexPath)")
    }
    
    
    
}
//
