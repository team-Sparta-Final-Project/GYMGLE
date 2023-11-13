import UIKit
import MessageUI
import FirebaseDatabase
import Firebase
import Kingfisher
import FirebaseAuth
import Combine

class BoardDetailViewController: UIViewController {
    
    var viewModel:BoardDetailViewModel = BoardDetailViewModel()
    
    var disposableBag = Set<AnyCancellable>()
    
    let first = UserCommunityView()
    
    let userCommunityViewController = UserCommunityViewController()
    let second = CommunityCell()
    let ref = Database.database().reference()
    
    var tableData:[Any] = []
    var profileData:[Profile] = []
    
    var board: Board? {
        didSet{
            self.viewModel.board = board
        }
    }
    var comment: Comment?
    var boardUid: String? {
        didSet{
            self.viewModel.boardUid = boardUid
        }
    }
    
    let viewConfigure = BoardDetailView()
    
    var imageTapGesture = UITapGestureRecognizer()
    
    private func setBindings(){
        self.viewModel.$tableData.sink{
            self.tableData = $0
        }.store(in: &disposableBag)
        
        self.viewModel.$profileData.sink{
            if $0.isEmpty {
                
            }else {
                self.profileData = $0
                if self.profileData[0].nickName == "탈퇴한 회원"{
                    self.viewConfigure.commentSection.textField.placeholder = "탈퇴한 회원의 글입니다."
                    self.viewConfigure.commentSection.textField.isEnabled = false
                    self.viewConfigure.commentSection.button.isHidden = true
                }

                self.viewConfigure.tableView.reloadData()
            }
            
        }.store(in: &disposableBag)

    }
    
    override func loadView() {
        view = viewConfigure
        setBindings()
        viewModel.loadData()
        
        viewConfigure.tableView.dataSource = self
        viewConfigure.tableView.delegate = self
        viewConfigure.commentSection.commentButtonDelegate = self
        
        let endEditGesture = UITapGestureRecognizer(target: self, action: #selector(endEdit))
        viewConfigure.tableView.addGestureRecognizer(endEditGesture)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
    }
}
//MARK: - @objc 모음 익스텐션
extension BoardDetailViewController {
    
    @objc func endEdit(_ sender: UITapGestureRecognizer){
        self.view.endEditing(true)
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
            cell.profileLine.profileDelegate = self
            cell.likeDelegate = self
            
            cell.profileLine.isBoard = true
            cell.profileLine.writerLabel.text = profile.nickName
            cell.profileLine.timeLabel.text = content.date.timeAgo()
            cell.profileLine.profileImage.kf.setImage(with: profile.image, for: .normal)
            cell.profileLine.writerUid = board!.uid
            
            cell.contentLabel.text = content.content
            cell.likeCount.text = "좋아요 \(content.likeCount)개"
            cell.commentCount.text = "댓글 \(tableData.count - 1)개"
            
            let ref = Database.database().reference().child("accounts/\(Auth.auth().currentUser!.uid)/likes/\(boardUid!)")
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.exists() {
                    cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                } else {
                    cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                }
            }
            
            return cell
        } else if tableData[indexPath.row] is (key: String, value: Comment) {
            let dic = tableData[indexPath.row] as! (key: String, value: Comment)
            let profile = profileData[indexPath.row]
            let comment = dic.value
            let cell = BoardDetailCommentCell()
            cell.profileLine.profileDelegate = self
            
            
            cell.profileLine.writerLabel.text = profile.nickName
            cell.profileLine.timeLabel.text = comment.date.timeAgo()
            cell.profileLine.profileImage.kf.setImage(with: profile.image, for: .normal)
            if profile.nickName == "탈퇴한 회원" {
                cell.profileLine.profileImage.backgroundColor = .gray
            }
            cell.profileLine.commentUid = dic.key
            cell.profileLine.writerUid = comment.uid
            
            cell.contentLabel.text = comment.comment
            
            self.comment = comment
            
            return cell
        }else {
            let cell = BoardDetailCommentCell()
            cell.profileLine.profileDelegate = self
            print("테스트 - \n\n\n\(type(of:tableData[indexPath.row]))\n\n\n")
            return cell
        }
    }
    
}

//MARK: - 인포버튼 델리겟
extension BoardDetailViewController:BoardProfileInfoButtonDelegate {
    func profileImageTappedAtComment(writerUid: String) {
        let vc = UserMyProfileViewController()
        vc.viewModel.userUid = writerUid
        let naviVC = UINavigationController(rootViewController: vc)
        
        self.present(naviVC, animated: true)
    }
    
    func infoButtonTapped(isBoard:Bool,commentUid:String,writerUid:String) {
        
        let alert = UIAlertController(title: "메뉴", message: "확인", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        if isBoard {
            if board?.uid == Auth.auth().currentUser?.uid {
                alert.addAction(UIAlertAction(title: "수정", style: .default, handler: {_ in
                    self.updateBoard()
                }))
                alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: {_ in
                    self.viewModel.deleteBoard()
                    self.navigationController?.popViewController(animated: true)
                }))
                
            }else {
                alert.addAction(UIAlertAction(title: "신고하기", style: .destructive, handler: {_ in
                    self.reportContent(content: self.board!)
                }))
            }
        }else{
            if writerUid == Auth.auth().currentUser?.uid {
                alert.addAction(UIAlertAction(title: "댓글수정은없어요", style: .default, handler: {_ in
                    
                }))
                alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: {_ in
                    self.viewModel.deleteComment(commentUid)
                }))
            }else {
                alert.addAction(UIAlertAction(title: "신고하기", style: .destructive, handler: {_ in
                    self.reportContent(content: [commentUid,writerUid] )
                }))
            }
        }
        
        
        present(alert,animated: true)
    }
}

//MARK: - 코멘트입력버튼 델리겟
extension BoardDetailViewController:CommentButtonDelegate {
    func commentButtonTapped(text:String) {
        self.view.endEditing(true)
        guard let profile = DataManager.shared.profile else {
            self.showToast(message: "프로필 설정 후 이용할 수 있습니다.")
            return
        }
        let comment = Comment(uid: Auth.auth().currentUser!.uid, comment: text, date: Date(), isUpdated: false,profile: profile)
        uploadComment(comment)
    }
}

//MARK: - 토스트
extension BoardDetailViewController {
    func showToast(message: String) {
        let toastView = ToastView()
        toastView.configure()
        toastView.text = message
        view.addSubview(toastView)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -124),
            toastView.widthAnchor.constraint(equalToConstant: view.frame.size.width / 2),
            toastView.heightAnchor.constraint(equalToConstant: view.frame.height / 17),
        ])
        UIView.animate(withDuration: 2.5, delay: 0.2) { //2.5초
            toastView.alpha = 0
        } completion: { _ in
            toastView.removeFromSuperview()
        }
    }
}

//MARK: - 파이어베이스

extension BoardDetailViewController : MFMailComposeViewControllerDelegate {
    
    func reportContent(content:Any){
        var body = ""
        if content is Board {
            let boardTemp = content as! Board
            body = "유효한 신고접수를 위해서 UID와 Content를 삭제하거나 수정하지 마십시오.\n\nUID: \(boardTemp.uid)\nContent: \(boardTemp.content)"
        } else {
            let commentTemp = content as! [String]
            body = "유효한 신고접수를 위해서 UID와 Content를 삭제하거나 수정하지 마십시오.\n\nCommentUID: \(commentTemp[0])\nUID: \(commentTemp[1])"
        }
        if MFMailComposeViewController.canSendMail() {
            let vc = MFMailComposeViewController()
            vc.mailComposeDelegate = self
            vc.setToRecipients(["gymgle7@gmail.com"])
            vc.setSubject("신고")
            vc.setMessageBody(body, isHTML: false)
            
            present(vc, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "이메일 전송 오류",
                                          message: "이메일을 보낼 수 없습니다. 메일앱에 계정을 등록해주세요.",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                guard let emailURL = URL(string: "mailto:gymgle7@gmail.com") else { return }
                
                if UIApplication.shared.canOpenURL(emailURL) {
                    UIApplication.shared.open(emailURL)
                }
                
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func uploadComment(_ comment: Comment) {
        do {
            let commentData = try JSONEncoder().encode(comment)
            let commentJSON = try JSONSerialization.jsonObject(with: commentData)
            
            // Firebase에 새 댓글 추가
            let commentsRef = ref.child("boards/\(boardUid!)/comments")
            let newCommentRef = commentsRef.childByAutoId()
            newCommentRef.setValue(commentJSON)
            
            // Firebase에서 현재 commentCount를 가져옴
            userCommunityViewController.getCommentCountForBoard(boardUid: boardUid!) { [self] commentCount in
                // commentCount를 1 증가시키고 Firebase에 업데이트
                let updatedCommentCount = commentCount + 1
                let boardRef = ref.child("boards/\(boardUid!)")
                boardRef.updateChildValues(["commentCount": updatedCommentCount])
            }
        } catch let error {
            print("오류 발생: \(error)")
        }
        viewModel.loadData()
    }
    
    
    func updateComment(_ commentUid:String){
        ref.child("boards/\(boardUid!)/comments").child("\(commentUid)").setValue(nil)
        viewModel.loadData()
    }
    
    
    func updateBoard(){
        let userCommunityWriteViewController = UserCommunityWriteViewController()
        userCommunityWriteViewController.isUpdate = true
        userCommunityWriteViewController.fromBoardClosure = {self.viewModel.loadData()}
        userCommunityWriteViewController.boardContent = board?.content
        userCommunityWriteViewController.boardUid = boardUid
        //        userCommunityWriteViewController.modalPresentationStyle = .fullScreen
        self.present(userCommunityWriteViewController, animated: true)
    }
}

extension BoardDetailViewController: BoardProfilelikeButtonDelegate {
    
    func likeButtonTapped(button: UIButton, count: UILabel) {
        let ref = Database.database().reference().child("accounts/\(Auth.auth().currentUser!.uid)/likes/\(boardUid!)")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                self.removeLikes()
                button.setImage(UIImage(systemName: "heart"), for: .normal)
                
                let database = self.ref.child("boards/\(self.boardUid!)/likeCount")
                database.observeSingleEvent(of: .value) { snapshot in
                    if let likeCount = snapshot.value as? Int {
                        let newLikeCount = max(likeCount - 1, 0)
                        database.setValue(newLikeCount)
                        count.text = "좋아요 \(newLikeCount)개"
                    }
                }
            } else {
                self.addLikes()
                button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                
                let database = self.ref.child("boards/\(self.boardUid!)/likeCount")
                database.observeSingleEvent(of: .value) { snapshot in
                    if let likeCount = snapshot.value as? Int {
                        let newLikeCount = likeCount + 1
                        database.setValue(newLikeCount)
                        count.text = "좋아요 \(newLikeCount)개"
                    }
                }
            }
        }
    }
    
    func addLikes() {
        let ref = Database.database().reference().child("accounts/\(Auth.auth().currentUser!.uid)/likes")
        ref.updateChildValues([boardUid!: true])
    }
    
    func removeLikes() {
        let ref = Database.database().reference().child("accounts/\(Auth.auth().currentUser!.uid)/likes/\(boardUid!)")
        ref.removeValue()
    }
}
