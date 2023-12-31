//
//  UserCommunityView.swift
//  GYMGLE
//
//  Created by t2023-m0088 on 2023/10/18.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase


class UserCommunityView: UIView,UITableViewDelegate {
    var posts: [Board] = [] // 게시물 데이터를 저장할 배열
    var keys: [String] = []
    //MARK: - 프로필 저장 배열
    
    var profiles:[Profile] = []
    var profilesWithKey:[String:Profile] = [:]
    var filteredProfiles:[Profile] = []
    var filteredKeys:[String] = []
    var nowSearching:Bool = false
    
    //MARK: - 프로필 저장 배열
    var filteredPost: [Board] = []
    let first = CommunityCell()
    
    weak var delegate: CommunityTableViewDelegate?
    
    func userDidSelectRow(at indexPath: IndexPath) {
        delegate?.didSelectCell(at: indexPath)
    }
    
    private let dummyDataManager = DataManager.shared
    var gymInfo: GymInfo?
    var userName: User?
    
    private(set) lazy var GymgleName = UILabel().then {
        $0.textColor = ColorGuide.main
        $0.font = FontGuide.size26Bold
        $0.text = "GYMGLE"
    }
    private lazy var healthName = UILabel().then {
        $0.textColor = ColorGuide.main
        $0.font = FontGuide.size26Bold
        $0.text = "만나 짐"
        $0.isHidden = true
    }
    private(set) lazy var writePlace = UIButton().then {
        $0.backgroundColor = ColorGuide.main
        $0.setImage(UIImage(systemName: "pencil"), for: .normal)
        $0.layer.cornerRadius = 30
        $0.tintColor = ColorGuide.white
        $0.layer.shadowColor = ColorGuide.black.cgColor
        $0.layer.shadowOpacity = 0.25
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    //    private lazy var mirrorPlace = UIButton().then {
    //        $0.backgroundColor = ColorGuide.white
    //        $0.setImage(UIImage(systemName: "circle.grid.2x1.left.filled"), for: .normal)
    //        $0.tintColor = ColorGuide.black
    //        $0.layer.cornerRadius = 16
    ////        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mirrorPlaceTap)))
    //    }
    private lazy var appNoticePlace = UISearchBar().then {
        $0.layer.cornerRadius = 20
        $0.searchTextField.placeholder = "검색"
        $0.searchTextField.textColor = ColorGuide.textHint
        $0.searchTextField.clearButtonMode = .whileEditing
        $0.searchTextField.layer.borderWidth = 0
        $0.searchTextField.layer.cornerRadius = 10
        $0.searchTextField.layer.borderColor = ColorGuide.textHint.cgColor
        $0.searchBarStyle = .minimal
        $0.delegate = self
        
    }
    private(set) lazy var appTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    let refreshController: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = ColorGuide.main
        refresh.translatesAutoresizingMaskIntoConstraints = false
        return refresh
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupUI()
        appTableView.dataSource = self
        appTableView.delegate = self
        appTableView.register(CommunityCell.self, forCellReuseIdentifier: "Cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func fetchProfileData(forUserID userID: String, completion: @escaping (Profile?) -> Void) {
        let profileRef = Database.database().reference().child("profiles").child(userID)
        
        profileRef.observeSingleEvent(of: .value) { snapshot in
            if let profileData = snapshot.value as? [String: Any],
               let imageString = profileData["image"] as? String,
               let imageURL = URL(string: imageString),
               let nickName = profileData["nickName"] as? String {
                let profile = Profile(image: imageURL, nickName: nickName)
                completion(profile)
            } else {
                completion(nil)
            }
        }
    }
    
    func decodeData(completion: @escaping () -> Void) {
        let databaseRef = Database.database().reference().child("boards")

        let numberOfPostsToRetrieve = 30  // 가져올 게시물 개수 (원하는 개수로 수정)
        databaseRef.queryOrdered(byChild: "date")
            .queryLimited(toLast: UInt(numberOfPostsToRetrieve))
            .observeSingleEvent(of: .value) { snapshot in
                self.posts.removeAll() // 데이터를 새로 받을 때 배열 비우기
                self.keys.removeAll()
                for childSnapshot in snapshot.children {
                    if let snapshot = childSnapshot as? DataSnapshot,
                        let data = snapshot.value as? [String: Any],
                        let key = snapshot.key as? String {
                        do {
                            let dataInfoJSON = try JSONSerialization.data(withJSONObject: data, options: [])
                            let dataInfo = try JSONDecoder().decode(Board.self, from: dataInfoJSON)
                            self.posts.insert(dataInfo, at: 0) // 가장 최근 게시물을 맨 위에 추가
                          self.keys.insert(key, at: 0)
                            // 키값은 역순으로 저장되어서 바꿨습니다.
                        } catch {
//                            print("디코딩 에러")
                        }
                    }
                }
                completion()
                // 테이블 뷰에 업데이트된 순서대로 표시
//                self.appTableView.reloadData()
            }
    }
    
    func downloadProfiles( complition: @escaping () -> () ){
        self.profiles.removeAll()
        var count = self.posts.count {
            didSet(oldVal){
                if count == 0 {
                    for i in temp {
                        self.profiles.append(profilesWithKey[i]!)
                    }
                    complition()
                }
            }
        }

        let ref = Database.database().reference()
        var temp:[String] = []
        profilesWithKey = [:]
        for i in self.posts {
            temp.append(i.uid)
            ref.child("accounts/\(i.uid)/profile").observeSingleEvent(of: .value) {DataSnapshot    in
                do {
                    let JSONdata = try JSONSerialization.data(withJSONObject: DataSnapshot.value!)
                    let profile = try JSONDecoder().decode(Profile.self, from: JSONdata)
                    self.profilesWithKey.updateValue(profile, forKey: i.uid)
                    count -= 1
                }catch {
                    print("테스트 - fail - 커뮤니티뷰 프로필 불러오기 실패")
                }
                
            }
            
        }

    }

    func setupUI(){
        self.backgroundColor = ColorGuide.userBackGround
        addSubview(GymgleName)
        addSubview(healthName)
        //        addSubview(mirrorPlace)
        addSubview(appNoticePlace)
        addSubview(appTableView)
        addSubview(writePlace)
        
        //        writePlace.addSubview(yourTableView)
        //        appTableView.addSubview(yourTableView)
        
        GymgleName.snp.makeConstraints {
            $0.top.equalToSuperview().offset(90)
            $0.leading.equalToSuperview().offset(20)
        }
        healthName.snp.makeConstraints {
            $0.top.equalToSuperview().offset(90)
            $0.leading.equalToSuperview().offset(20)
        }
        writePlace.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-122)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.equalTo(60)
            $0.height.equalTo(60)
        }
        //        mirrorPlace.snp.makeConstraints {
        //            $0.centerY.equalTo(GymgleName.snp.centerY)
        //            $0.trailing.equalTo(writePlace.snp.leading).offset(-6)
        //            $0.width.equalTo(32)
        //            $0.height.equalTo(32)
        //        }
        appNoticePlace.snp.makeConstraints {
            $0.top.equalTo(GymgleName.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(50)
        }
        appTableView.snp.makeConstraints {
            $0.top.equalTo(appNoticePlace.snp.bottom).offset(0)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-90)
        }
        
    }
    
}
extension UserCommunityView:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appNoticePlace.text?.isEmpty == true ? posts.count : filteredPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CommunityCell
        cell.selectionStyle = .none
        if appNoticePlace.text?.isEmpty == true {
            if indexPath.row < posts.count {
                let data = posts[indexPath.row]
                if indexPath.row < profiles.count {
                    let profile = profiles[indexPath.row] // 프로필 불러오기 수정된 부분
                    cell.configure(with: data)
                    cell.profileConfigure(with: profile)
                } else {
                    let profile = Profile(image: URL(fileURLWithPath: ""), nickName: "")
                    cell.configure(with: data)
                    cell.profileConfigure(with: profile) // 프로필 불러오기 수정된 부분
                }
            }
        } else {
            if indexPath.row < filteredPost.count {
                let data = filteredPost[indexPath.row]
                let profile = filteredProfiles[indexPath.row] // 필터 안한 프로필이라 버그가 예상됩니다. 임시로 해놨습니다.
                cell.configure(with: data)
                cell.profileConfigure(with: profile) // 필터 안한 프로필이라 버그가 예상됩니다. 임시로 해놨습니다.
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension // 셀의 높이 (예: 100)에 간격 (예: 12)을 더해 설정
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userDidSelectRow(at: indexPath)
    }
    
}

extension UserCommunityView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            nowSearching = false
        }else{
            nowSearching = true
        }
        
        let searchQuery = searchText.lowercased()
        
        filteredPost = posts.filter { post in
            return post.content.lowercased().contains(searchQuery) || profilesWithKey[post.uid]!.nickName.lowercased().contains(searchQuery)
        }
        
        var temp:[Profile] = []
        var tempKey:[String] = []
        for i in filteredPost {
            temp.append(profilesWithKey[i.uid]!)
            tempKey.append(i.uid)
        }
        filteredProfiles = temp
        filteredKeys = tempKey
        
        appTableView.reloadData()
       
    }
}
