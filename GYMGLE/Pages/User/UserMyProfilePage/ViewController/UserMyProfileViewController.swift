//
//  UserMyProfileViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 10/31/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import Firebase

final class UserMyProfileViewController: UIViewController {

    // MARK: - prirperties
    let userMyProfileView = UserMyProfileView()
    var viewModel: UserMyProfileViewModel = UserMyProfileViewModel()
    
    // MARK: - life cycle
    override func loadView() {
        view = userMyProfileView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadSetting()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearSetting()
    }
}

// MARK: - private extension custom func
private extension UserMyProfileViewController {
  
    func viewDidLoadSetting() {
        tableViewSetting()
        profileIsNil()
        buttonSetting()
    }
    
    func viewWillAppearSetting() {
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
        dataSetting()
    }
    
    func tableViewSetting() {
        userMyProfileView.postTableview.dataSource = self
        userMyProfileView.postTableview.delegate = self
        userMyProfileView.postTableview.register(UserMyProfileBoardTableViewCell.self, forCellReuseIdentifier: UserMyProfileBoardTableViewCell.identifier)
    }
    
    func buttonSetting() {
        if self.viewModel.userUid == Auth.auth().currentUser?.uid { // 내 프로필 진입 시
            userMyProfileView.updateButton.addTarget(self, action: #selector(updateButtonButtoned), for: .touchUpInside)
            userMyProfileView.updateButton.titleLabel?.text = "프로필 수정"
            navigationController?.navigationBar.topItem?.title = "마이페이지"
            navigationController?.navigationBar.tintColor = .black
        } else { //다른 사람 프로필 진입 시
            userMyProfileView.updateButton.setTitle("사용자 차단", for: .normal)
            userMyProfileView.updateButton.addTarget(self, action: #selector(banButtonButtoned), for: .touchUpInside)
        }
    }
    func profileIsNil() {
        if DataManager.shared.profile?.nickName == nil {
            let userMyProfileUpdateVC = UserMyProfileUpdateViewController()
            userMyProfileUpdateVC.modalPresentationStyle = .currentContext
            present(userMyProfileUpdateVC, animated: true)
            return
        }
    }
    
    func dataSetting() {
        //자기가 들어오는 거면 싱글톤으로 보여주기
        if self.viewModel.userUid == Auth.auth().currentUser?.uid {
            self.viewModel.getBoardKeys{}
            DispatchQueue.main.async {
                guard let gymName = DataManager.shared.realGymInfo?.gymName else { return }
                guard let nickName = DataManager.shared.profile?.nickName else { return }
                guard let url = DataManager.shared.profile?.image else { return }
                self.userMyProfileView.dataSetting(gym: "\(gymName)", name: nickName, postCount: self.viewModel.post.count,imageUrl: url)
            }
            self.viewModel.getPost {
                self.userMyProfileView.postCountLabel.text = "작성한 글 \(self.viewModel.post.count)개"
                self.userMyProfileView.postTableview.reloadData()
            }
        } else { // 다른 사람이 들어오는거면 싱글톤이 아닌 uid를 사용해 서버를 통해서 보여주기
            self.viewModel.getProfile {
                self.viewModel.getBoardKeys {}
                self.viewModel.getGymName {
                    guard let url = self.viewModel.url else { return }
                    guard let gymName = self.viewModel.gymName else { return }
                    self.userMyProfileView.dataSetting(gym: gymName, name: self.viewModel.nickName, postCount: self.viewModel.post.count, imageUrl: url)
                    self.viewModel.getPost {
                        self.userMyProfileView.postCountLabel.text = "작성한 글 \(self.viewModel.post.count)개"
                        self.userMyProfileView.postTableview.reloadData()
                    }
                }
            }
        }
    }
}

// MARK: - extension @objc func

extension UserMyProfileViewController {
    
    @objc private func updateButtonButtoned() {
        let userMyProfileUpdateVC = UserMyProfileUpdateViewController()
        userMyProfileUpdateVC.modalPresentationStyle = .currentContext
        present(userMyProfileUpdateVC, animated: true)
    }
    @objc private func banButtonButtoned() {
        if self.viewModel.userUid != Auth.auth().currentUser?.uid {
            let alert = UIAlertController(title: "차단", message: "사용자를 차단하시겠습니까?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default) { _ in
                self.block()
                self.userMyProfileView.updateButton.setTitle("차단됨", for: .normal)
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel) { cancelAction in
                print("취소")
            }
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func block() {
        let userRef = Database.database().reference().child("accounts/\(Auth.auth().currentUser!.uid)/blockedUserList")
        let blockedUserUid = self.viewModel.userUid
        userRef.child("\(blockedUserUid!)").setValue(true)
    }
}

// MARK: - UITableViewDataSource
extension UserMyProfileViewController: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.post.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserMyProfileBoardTableViewCell.identifier, for: indexPath) as! UserMyProfileBoardTableViewCell
        
        cell.board = self.viewModel.post.sorted(by: {$0.date > $1.date})[indexPath.section]
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension UserMyProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let boardDetailVC = BoardDetailViewController()
        boardDetailVC.boardUid = self.viewModel.keys[indexPath.section]
        boardDetailVC.board = self.viewModel.post.sorted(by: {$0.date > $1.date})[indexPath.section]
        navigationController?.pushViewController(boardDetailVC, animated: true)
    }    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.viewModel.heightForHeaderInSection
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.isUserInteractionEnabled = false
        header.backgroundColor = UIColor.clear
        header.frame.size.height = 1
        return header
    }
 }

