//
//  UserCommunityViewController.swift
//  GYMGLE
//
//  Created by t2023-m0088 on 2023/10/18.
//

import UIKit
import Firebase

class UserCommunityViewController: UIViewController, CommunityTableViewDelegate {
    
    func didSelectCell(at indexPath: IndexPath) {
        let destinationViewController = BoardDetailViewController()
        let data = first.posts[indexPath.row]
        let key = first.keys[indexPath.row]
        destinationViewController.board = data
        destinationViewController.boardUid = key
        
        
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    let first = UserCommunityView()
    let second = CommunityCell()

    override func loadView() {
        view = first
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        first.writePlace.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(writePlaceTap)))
        first.delegate = self
        self.view = first
    }
    
    override func viewWillAppear(_ animated: Bool) { // 네비게이션바 보여주기
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        decodeData {
            self.downloadProfiles {
                self.first.appTableView.reloadData()
            }
        }
    }
    
    @objc func writePlaceTap() {
        let userCommunityWriteViewController = UserCommunityWriteViewController()
//        navigationController?.pushViewController(userCommunityWriteViewController, animated: true)
        userCommunityWriteViewController.modalPresentationStyle = .fullScreen
        self.present(userCommunityWriteViewController, animated: true)
    }
}

extension UserCommunityViewController {
    func decodeData(completion: @escaping () -> Void) {
        let databaseRef = Database.database().reference().child("boards")

        let numberOfPostsToRetrieve = 30  // 가져올 게시물 개수 (원하는 개수로 수정)
        databaseRef.queryOrdered(byChild: "date")
            .queryLimited(toLast: UInt(numberOfPostsToRetrieve))
            .observeSingleEvent(of: .value) { snapshot in
                self.first.posts.removeAll() // 데이터를 새로 받을 때 배열 비우기
                for childSnapshot in snapshot.children {
                    if let snapshot = childSnapshot as? DataSnapshot,
                        let data = snapshot.value as? [String: Any],
                        let key = snapshot.key as? String {
                        do {
                            let dataInfoJSON = try JSONSerialization.data(withJSONObject: data, options: [])
                            let dataInfo = try JSONDecoder().decode(Board.self, from: dataInfoJSON)
                            self.first.posts.insert(dataInfo, at: 0) // 가장 최근 게시물을 맨 위에 추가
                            self.first.keys.insert(key, at: 0)
                        } catch {
                            print("디코딩 에러")
                        }
                    }
                }
                completion()
                // 테이블 뷰에 업데이트된 순서대로 표시
//                self.appTableView.reloadData()
            }
    }
    
    func downloadProfiles( complition: @escaping () -> () ){
        self.first.profiles.removeAll()
        var count = self.first.posts.count {
            didSet(oldVal){
                if count == 0 {
                    for i in self.first.profiles {
                        print("테스트 - \(i.nickName) 서버에 보낸 뒤 받아온 닉네임 순서")
                    }
                    complition()
                }
            }
        }
        
        let ref = Database.database().reference()
//        var temp:[Any] = []
//        for i in self.first.posts {
//            temp.append(i.uid)
//        }
        for i in self.first.posts {
            print("테스트 - \(i.profile.nickName) 서버에 보내기 직전 닉네임 순서")
            ref.child("accounts/\(i.uid)/profile").observeSingleEvent(of: .value) {DataSnapshot    in
                do {
                    let JSONdata = try JSONSerialization.data(withJSONObject: DataSnapshot.value!)
                    let profile = try JSONDecoder().decode(Profile.self, from: JSONdata)
                    self.first.profiles.insert(profile, at: 0)
//                    temp[temp.firstIndex(of: i.uid)] = profile
                    count -= 1
                }catch {
                    print("테스트 - fail - 커뮤니티뷰 프로필 불러오기 실패")
                }
                
            }
            
        }
    }
}
