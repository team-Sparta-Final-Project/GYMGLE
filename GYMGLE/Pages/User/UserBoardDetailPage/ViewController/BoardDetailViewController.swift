import UIKit

class BoardDetailViewController: UIViewController {
    
    var temp = ["aaa","bbb","ccc","ddd","eee"]
    
    let viewConfigure = BoardDetailView()
    
    override func loadView() {
        viewConfigure.tableView.dataSource = self
        viewConfigure.tableView.delegate = self
        view = viewConfigure
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension BoardDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
}

extension BoardDetailViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temp.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if temp[indexPath.row] == "aaa"{
            let cell = BoardDetailContentCell()
            cell.selectionStyle = .none
            return cell
        } else if temp[indexPath.row] == "ccc"{
            let cell = BoardDetailCommentCell()
            cell.contentLabel.text = "짧은 텍스트\n두줄짜리"
            return cell
        }else {
            return BoardDetailCommentCell()
        }
    }
    
    
}
