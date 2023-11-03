import UIKit
import Firebase

class BoardDetailViewController: UIViewController {
    
    let ref = Database.database().reference()
    
    let profile = Profile(image: URL(string:"https://i.namu.wiki/i/_-uuCMpeISXkf8ByapepsmppPEKWXY9v3dTferwAVCxXKLEOMWzOA3-1rXi_Cyw_7jPARqh_-hEFgK-n5WmCRVyMzXu6TGLKjfbREZTYMTcDM7RuRuQXmDDoBJwoda-rRbhnvqxVPdcBX3nkpU_Snw.svg")!, nickName: "닉네임")
    
    var temp:[Any] = []
    
    
    
    var keyList:[String] = []
    
//    var boardUid: String = "-NiIHSztswt9jfzt-AhJ"
//    var boardUid: String = "-NiIHXxC9JORJ6D5Fl78"
    
    var board: Board?
    var boardUid: String?
    
    var comments: [Comment]?
    
    let viewConfigure = BoardDetailView()
    
    override func loadView() {
//        board = Board(uid: "마알티즈국빱", content: "안녕하세요", date: Date(), isUpdated: false, likeCount: 0,profile: profile)
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
        
        temp = [board!]
        comments!.sort(by: { $0.date < $1.date })
        temp += comments!
        downloadComments()
        print("테스트 - \(temp)",separator: "\n\n\n")
        self.viewConfigure.tableView.reloadData()
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
            cell.profileLine.writerLabel.text = content.profile.nickName
            cell.profileLine.timeLabel.text = content.date.timeAgo()
            cell.contentLabel.text = content.content
            cell.likeCount.text = "좋아요 \(content.likeCount)개"
            cell.commentCount.text = "댓글 \(temp.count - 1)개"
            
            return cell
        } else if temp[indexPath.row] is Comment {
            let comment = temp[indexPath.row] as! Comment
            let cell = BoardDetailCommentCell()
            cell.profileLine.infoDelegate = self
            cell.profileLine.writerLabel.text = comment.profile.nickName
            cell.contentLabel.text = comment.comment
            cell.profileLine.timeLabel.text = comment.date.timeAgo()
            
            cell.profileLine.profileImage.image = UIImage(systemName: "heart.fill")
            cell.profileLine.profileImage.tintColor = .systemMint
            
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
        let comment = Comment(uid: Auth.auth().currentUser!.uid, comment: text, date: Date(), isUpdated: false,profile: profile)
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
            
            ref.child("boards/\(boardUid)/comments").childByAutoId().setValue(commentJSON)
            
        } catch let error {
            print("테스트 - \(error)")
        }
    }
    
    func downloadComments(){
        
        ref.child("boards/\(boardUid)/comments").observeSingleEvent(of: .value) { DataSnapshot,arg  in
            guard let value = DataSnapshot.value as? [String:Any] else { return }
            var temp:[Comment] = []
            for i in value.values {
                do {
                    let JSONdata = try JSONSerialization.data(withJSONObject: i)
                    let comment = try JSONDecoder().decode(Comment.self, from: JSONdata)
                    temp.append(comment)
                } catch let error {
                    print("테스트 - \(error)")
                }
            }
            self.comments = temp
        }
        
    }
}
