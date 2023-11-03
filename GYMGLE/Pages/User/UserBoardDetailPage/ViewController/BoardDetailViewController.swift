import UIKit

class BoardDetailViewController: UIViewController {
    
    let profile = Profile(image: URL(string:"https://i.namu.wiki/i/_-uuCMpeISXkf8ByapepsmppPEKWXY9v3dTferwAVCxXKLEOMWzOA3-1rXi_Cyw_7jPARqh_-hEFgK-n5WmCRVyMzXu6TGLKjfbREZTYMTcDM7RuRuQXmDDoBJwoda-rRbhnvqxVPdcBX3nkpU_Snw.svg")!, nickName: "닉네임")
    
    var temp:[Any] = []
    
    let viewConfigure = BoardDetailView()
    
    override func loadView() {
        viewConfigure.tableView.dataSource = self
        viewConfigure.tableView.delegate = self
        viewConfigure.commentSection.commentButtonDelegate = self
        view = viewConfigure
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeDummy()
    }
    
    

    
}
//MARK: - @objc 모음 익스텐션
extension BoardDetailViewController {
    
    
    func makeDummy(){
        temp.append(Board(uid: "마알티즈국빱", content: "안녕하세요", date: Date(), isUpdated: false, likeCount: 0,profile: profile))
        temp.append(Comment(uid: "국빱애호가", comment: "반갑습니다", date: Date(), isUpdated: false, profile: profile))
    }
    
    @objc func showCommentPopUp(){
        print("테스트 - asdjhaskjdhkajsdhjkash")
    }
    
    
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
        if temp[indexPath.row] is Board {
            let content = temp[indexPath.row] as! Board
            let cell = BoardDetailContentCell()
            cell.selectionStyle = .none
            cell.profileLine.infoDelegate = self
            cell.contentLabel.text = content.content
            cell.profileLine.writerLabel.text = content.uid
            return cell
        } else if temp[indexPath.row] is Comment {
            let comment = temp[indexPath.row] as! Comment
            let cell = BoardDetailCommentCell()
            cell.profileLine.writerLabel.text = comment.uid
            cell.contentLabel.text = comment.comment
            cell.profileLine.profileImage.image = UIImage(systemName: "heart.fill")
            cell.profileLine.profileImage.tintColor = .systemMint
            cell.profileLine.infoDelegate = self
            return cell
        }else {
            let cell = BoardDetailCommentCell()
            cell.profileLine.infoDelegate = self
            return cell
        }
    }
    
    
}

//MARK: - 테이블뷰 셀 델리겟
extension BoardDetailViewController:BoardProfileInfoButtonDelegate {
    func infoButtonTapped(nickName:String) {
        print("테스트 - \(nickName)")
    }
}


extension BoardDetailViewController:CommentButtonDelegate {
    func commentButtonTapped(text:String) {
        temp.append(Comment(uid: "국빱애호가", comment: text, date: Date(), isUpdated: false,profile: profile))
        self.viewConfigure.tableView.reloadData()
    }
}
