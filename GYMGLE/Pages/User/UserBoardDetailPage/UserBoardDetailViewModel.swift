import Firebase
import Foundation
import Combine

class BoardDetailViewModel: ObservableObject {
    
    var board:Board?
    var boardUid:String?
    
    @Published var tableData:[Any] = []
    @Published var profileData:[Profile] = []
    let ref = Database.database().reference()
    
    init(){
        print("테스트 - 뷰모델 불러옴")
    }
    func loadData(){
        downloadComments {
            self.downloadProfiles()
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
            
            getCommentCountForBoard(boardUid: boardUid!) { [self] commentCount in
                // commentCount를 1 증가시키고 Firebase에 업데이트
                let updatedCommentCount = commentCount + 1
                let boardRef = ref.child("boards/\(boardUid!)")
                boardRef.updateChildValues(["commentCount": updatedCommentCount])
            }
        } catch let error {
            print("오류 발생: \(error)")
        }
        loadData()
    }
    
    func deleteComment(_ commentUid:String){
        ref.child("boards/\(boardUid!)/comments").child("\(commentUid)").setValue(nil)
        
        // Firebase에서 현재 commentCount를 가져옴
        getCommentCountForBoard(boardUid: boardUid!) { [self] commentCount in
            // commentCount를 1 감소시키고 Firebase에 업데이트
            let updatedCommentCount = commentCount - 1
            let boardRef = ref.child("boards/\(boardUid!)")
            boardRef.updateChildValues(["commentCount": updatedCommentCount])
        }
        loadData()
    }
    
    func getCommentCountForBoard(boardUid: String, completion: @escaping (Int) -> Void) {
        let databaseRef = Database.database().reference()
        let boardRef = databaseRef.child("boards").child(boardUid)
        
        boardRef.observeSingleEvent(of: .value) { snapshot in
            if let boardData = snapshot.value as? [String: Any] {
                if let commentCount = boardData["commentCount"] as? Int {
                    completion(commentCount)
                } else {
                    completion(0)
                }
            } else {
                completion(0)
            }
        }
    }
    
    func deleteBoard(){
        ref.child("boards/\(boardUid!)").setValue(nil)
    }


    
    
    
    
    
    //MARK: - loads
    
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
    
    func downloadProfiles(){
        profileData.removeAll()
        var count = tableData.count {
            didSet(oldVal){
                if count == 0 {
                    profileData = tempOrder.map{tempProfiles[$0]!}
                }
            }
        }
        var tempOrder:[String] = []
        var tempProfiles:[String:Profile] = [:]
        
        let emptyProfile = Profile(image: URL(fileURLWithPath: "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Ft1.daumcdn.net%2Fcfile%2Ftistory%2F2513B53E55DB206927"), nickName: "탈퇴한 회원")
        for i in tableData {
            var profile = emptyProfile
            if i is Board {
                let temp = i as! Board
                tempOrder.append(temp.uid)
                ref.child("accounts/\(temp.uid)/profile").observeSingleEvent(of: .value) {DataSnapshot    in
                    do {
                        if !(DataSnapshot.value! is NSNull) {
                            let JSONdata = try JSONSerialization.data(withJSONObject: DataSnapshot.value!)
                            profile = try JSONDecoder().decode(Profile.self, from: JSONdata)
                        }
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
                        if !(DataSnapshot.value! is NSNull) {
                            let JSONdata = try JSONSerialization.data(withJSONObject: DataSnapshot.value!)
                            profile = try JSONDecoder().decode(Profile.self, from: JSONdata)
                        }
                        tempProfiles.updateValue(profile, forKey: temp.key)
                        count -= 1
                    }catch {
                        print("테스트 - faili")
                    }
                }
            }
        }
    }
    
    
}
