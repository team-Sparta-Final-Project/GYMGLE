import UIKit
import Firebase

class BoardDetailViewController: UIViewController {
    
    let ref = Database.database().reference()
    
    let profile = Profile(image: URL(string:"https://i.namu.wiki/i/_-uuCMpeISXkf8ByapepsmppPEKWXY9v3dTferwAVCxXKLEOMWzOA3-1rXi_Cyw_7jPARqh_-hEFgK-n5WmCRVyMzXu6TGLKjfbREZTYMTcDM7RuRuQXmDDoBJwoda-rRbhnvqxVPdcBX3nkpU_Snw.svg")!, nickName: "닉네임")
    
    var tableData:[Any] = []
    
    
    
    var keyList:[String] = []
    
//    var boardUid: String = "-NiIHSztswt9jfzt-AhJ"
//    var boardUid: String = "-NiIHXxC9JORJ6D5Fl78"
    
    var board: Board?
    var boardUid: String?
    
//    var comments: [String:Comment]?
    
    let viewConfigure = BoardDetailView()
    
    override func loadView() {
        downloadComments()
        
        viewConfigure.tableView.dataSource = self
        viewConfigure.tableView.delegate = self
        viewConfigure.commentSection.commentButtonDelegate = self
        view = viewConfigure
        
        let endEditGesture = UITapGestureRecognizer(target: self, action: #selector(endEdit))
        viewConfigure.tableView.addGestureRecognizer(endEditGesture)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewConfigure.tableView.reloadData()
    }
    
    
    
    
}
//MARK: - @objc 모음 익스텐션
extension BoardDetailViewController {
    
        
    @objc func showCommentPopUp(){
        print("테스트 - asdjhaskjdhkajsdhjkash")
    }
    
    @objc func endEdit(_ sender: UITapGestureRecognizer){
        self.view.endEditing(true)
        
        
        downloadComments()
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
        return tableData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableData[indexPath.row] is Board {
            let content = tableData[indexPath.row] as! Board
            let cell = BoardDetailContentCell()
            cell.selectionStyle = .none
            cell.profileLine.infoDelegate = self
            cell.profileLine.writerLabel.text = content.profile.nickName
            cell.profileLine.timeLabel.text = content.date.timeAgo()
            cell.profileLine.profileImage.kf.setImage(with: content.profile.image)
            
            cell.contentLabel.text = content.content
            cell.likeCount.text = "좋아요 \(content.likeCount)개"
            cell.commentCount.text = "댓글 \(tableData.count - 1)개"
            
            return cell
        } else if tableData[indexPath.row] is (key: String, value: Comment) {
            let dic = tableData[indexPath.row] as! (key: String, value: Comment)
            let comment = dic.value
            // TODO: 셀 클릭해서 (길게클릭해서 댓글메뉴 불러오는거) 삭제수정 만들어놓으면 인덱스 이용해서 뭐 할 수 있을듯 점점점 버튼 없어도 될 것 같음
            // TODO: 아니면 프로필라인(뷰)에 uid가지고 있게 해서 처리
            let cell = BoardDetailCommentCell()
            cell.profileLine.infoDelegate = self
            cell.profileLine.writerLabel.text = comment.profile.nickName
            cell.profileLine.timeLabel.text = comment.date.timeAgo()
            cell.profileLine.profileImage.kf.setImage(with: comment.profile.image)
            cell.profileLine.uidContainer = dic.key
            
            cell.contentLabel.text = comment.comment
            
            return cell
        }else {
            let cell = BoardDetailCommentCell()
            cell.profileLine.infoDelegate = self
            print("테스트 - \n\n\n\(type(of:tableData[indexPath.row]))\n\n\n")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("테스트 - \(indexPath.row) picked \n")
    }
    
    
}

//MARK: - 테이블뷰 셀 델리겟
extension BoardDetailViewController:BoardProfileInfoButtonDelegate {
    func infoButtonTapped(commentUid:String) {
        print("테스트 - \(commentUid)")
        deleteComment(commentUid)
    }
}


extension BoardDetailViewController:CommentButtonDelegate {
    func commentButtonTapped(text:String) {
        let comment = Comment(uid: Auth.auth().currentUser!.uid, comment: text, date: Date(), isUpdated: false,profile: DataManager.shared.profile!)
        uploadComment(comment)
        self.viewConfigure.tableView.reloadData()
    }
}

//MARK: - 파이어베이스

extension BoardDetailViewController {
    
    func uploadComment(_ comment:Comment){
        
        do {
            let commentData = try JSONEncoder().encode(comment)
            let commentJSON = try JSONSerialization.jsonObject(with: commentData)
            
            ref.child("boards/\(boardUid!)/comments").childByAutoId().setValue(commentJSON)
            
        } catch let error {
            print("테스트 - \(error)")
        }
    }
    
    func deleteComment(_ commentUid:String){
        
        
        ref.child("boards/\(boardUid!)/comments").child("\(commentUid)").setValue(nil)
    }

    
    func downloadComments(){
        
        ref.child("boards/\(boardUid!)/comments").observeSingleEvent(of: .value) { [self] DataSnapshot,arg  in
            guard let value = DataSnapshot.value as? [String:Any] else { return }
            var temp:[String:Comment] = [:]
            for i in value {
                do {
                    let JSONdata = try JSONSerialization.data(withJSONObject: i.value)
                    let comment = try JSONDecoder().decode(Comment.self, from: JSONdata)
                    temp.updateValue(comment, forKey: i.key)
                } catch let error {
                    print("테스트 - \(error)")
                }
            }
            self.tableData = [self.board!]
            self.tableData += temp.sorted(by: { $0.1.date < $1.1.date })
            
        }
        
    }
}
