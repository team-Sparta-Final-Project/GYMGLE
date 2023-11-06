import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth

class BoardDetailViewController: UIViewController {
    
    let ref = Database.database().reference()
        
    var tableData:[Any] = []
    var profileData:[Profile] = []
        
    var board: Board?
    var boardUid: String?
    
    let viewConfigure = BoardDetailView()
    
    var imageTapGesture = UITapGestureRecognizer()
        
    var reloadClosure = {}
    var profileDownloadClosure = {}
    
    override func loadView() {
        reloadClosure = { self.viewConfigure.tableView.reloadData() }
        profileDownloadClosure = { self.downloadProfiles(complition: self.reloadClosure) }
        
        downloadComments(complition: profileDownloadClosure)
        
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
}
//MARK: - @objc 모음 익스텐션
extension BoardDetailViewController {
    
    @objc func endEdit(_ sender: UITapGestureRecognizer){
        self.view.endEditing(true)
        downloadComments(complition: profileDownloadClosure)
    }
    
    @objc func profileImageClicked(_ sender: UITapGestureRecognizer){
        print("테스트 - \(sender)")
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
            let profile = profileData[indexPath.row]
            let cell = BoardDetailContentCell()
            cell.selectionStyle = .none
            cell.profileLine.infoDelegate = self
            
            cell.profileLine.isBoard = true
            cell.profileLine.writerLabel.text = profile.nickName
            cell.profileLine.timeLabel.text = content.date.timeAgo()
            cell.profileLine.profileImage.kf.setImage(with: profile.image)
            
            cell.contentLabel.text = content.content
            cell.likeCount.text = "좋아요 \(content.likeCount)개"
            cell.commentCount.text = "댓글 \(tableData.count - 1)개"
            
            return cell
        } else if tableData[indexPath.row] is (key: String, value: Comment) {
            let dic = tableData[indexPath.row] as! (key: String, value: Comment)
            let profile = profileData[indexPath.row]
            let comment = dic.value
            let cell = BoardDetailCommentCell()
            cell.profileLine.infoDelegate = self
            
            
            cell.profileLine.writerLabel.text = profile.nickName
            cell.profileLine.timeLabel.text = comment.date.timeAgo()
            cell.profileLine.profileImage.kf.setImage(with: profile.image)
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
}

//MARK: - 인포버튼 델리겟
extension BoardDetailViewController:BoardProfileInfoButtonDelegate {
    func infoButtonTapped(isBoard:Bool,commentUid:String) {
        
        let alert = UIAlertController(title: "확인", message: "메세지", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "아니오", style: .cancel))
        
        
        if isBoard {
            alert.message = "게시글을 삭제하시겠습니까?"
            alert.addAction(UIAlertAction(title: "네", style: .destructive, handler: {_ in
                self.deleteBoard()
            }))
            
        }else{
            alert.message = "댓글을 삭제하시겠습니까?"
            alert.addAction(UIAlertAction(title: "네", style: .destructive, handler: {_ in
                self.deleteComment(commentUid)
            }))
        }
        present(alert,animated: true)
    }
}

//MARK: - 코멘트입력버튼 델리겟
extension BoardDetailViewController:CommentButtonDelegate {
    func commentButtonTapped(text:String) {
        self.view.endEditing(true)
        let comment = Comment(uid: Auth.auth().currentUser!.uid, comment: text, date: Date(), isUpdated: false,profile: DataManager.shared.profile!)
        uploadComment(comment)
    }
}

//MARK: - 프로필이미지 델리겟


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
        downloadComments(complition: profileDownloadClosure)

    }
    
    func deleteComment(_ commentUid:String){
        ref.child("boards/\(boardUid!)/comments").child("\(commentUid)").setValue(nil)
        downloadComments(complition: profileDownloadClosure)
    }

    
    func downloadComments( complition: @escaping () -> () ){
        
        ref.child("boards/\(boardUid!)/comments").observeSingleEvent(of: .value) { [self] DataSnapshot,arg  in
            guard let value = DataSnapshot.value as? [String:Any] else {
                self.tableData = [self.board!]
                complition()
                return
            }
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
            
            complition()

        }
    }
    //MARK: - 프로필데이터
    func downloadProfiles( complition: @escaping () -> () ){
        profileData.removeAll()
        var count = tableData.count {
            didSet(oldVal){
                if count == 0 {
                    
                    for i in tempOrder {
                        self.profileData.append(tempProfiles[i]!)
                    }
                    
                    complition()
                }
            }
        }
        var tempOrder:[String] = []
        var tempProfiles:[String:Profile] = [:]

        for i in tableData {
            if i is Board {
                let temp = i as! Board
                tempOrder.append(temp.uid)
                ref.child("accounts/\(temp.uid)/profile").observeSingleEvent(of: .value) {DataSnapshot  in
                    do {
                        let JSONdata = try JSONSerialization.data(withJSONObject: DataSnapshot.value!)
                        let profile = try JSONDecoder().decode(Profile.self, from: JSONdata)
                        tempProfiles.updateValue(profile, forKey: temp.uid)
                        count -= 1
                    }catch {
                        print("테스트 - faili")
                    }
                }
            }else {
                let temp = i as! (key: String, value: Comment)
                tempOrder.append(temp.key)
                ref.child("accounts/\(temp.value.uid)/profile").observeSingleEvent(of: .value) {DataSnapshot  in
                    do {
                        let JSONdata = try JSONSerialization.data(withJSONObject: DataSnapshot.value!)
                        let profile = try JSONDecoder().decode(Profile.self, from: JSONdata)
                        tempProfiles.updateValue(profile, forKey: temp.key)
                        count -= 1
                    }catch {
                        print("테스트 - faili")
                    }
                }
            }
        }
    }
    
    func deleteBoard(){
        ref.child("boards/\(boardUid!)").setValue(nil)
        navigationController?.popViewController(animated: true)
    }
}

