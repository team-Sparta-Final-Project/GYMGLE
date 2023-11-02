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
    
    
    @objc func showCommentPopUp(){
        print("테스트 - asdjhaskjdhkajsdhjkash")
    }

    
}
//MARK: - @objc 모음 익스텐션
extension BoardDetailViewController {
    
    
    
    
    
}


//MARK: - 테이블뷰 익스텐션

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
            cell.profileLine.infoDelegate = self
            return cell
        } else if temp[indexPath.row] == "ccc"{
            let cell = BoardDetailCommentCell()
            cell.contentLabel.text = "짧은 텍스트\n두줄짜리"
            cell.profileLine.writerLabel.text = "아주긴닉네임ㅇㅋㅋㅋ"
            cell.profileLine.profileImage.image = UIImage(systemName: "heart.fill")
            cell.profileLine.profileImage.tintColor = .systemMint
            return cell
        }else {
            let cell = BoardDetailCommentCell()
            return cell
        }
    }
    
    
}

//MARK: - 테이블뷰 셀 델리겟
extension BoardDetailViewController:BoardProfileInfoButtonDelegate {
    func infoButtonTapped() {
        print("테스트 - 드디어눌린다")
    }
    
    
}
