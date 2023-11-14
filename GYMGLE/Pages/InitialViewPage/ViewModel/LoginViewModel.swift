//
//  InitialViewModel.swift
//  GYMGLE
//
//  Created by 조규연 on 11/9/23.
//

import Foundation
import Firebase

protocol LoginViewModelDelegate: AnyObject {
    func adminLogin()
    func userLogin()
    func trainerLogin()
    func loginFailure()
    func tempLogin()
}

class LoginViewModel {
    
    weak var delegate: LoginViewModelDelegate?
    
    // MARK: - 로그인
    func signIn(id: String, password: String) {
        Auth.auth().signIn(withEmail: id, password: password) { [weak self] result, error in
            guard let self else { return }
            if let error = error {
                print(error)
                self.delegate?.loginFailure()
            } else if let user = result?.user {
                self.handleLoginSuccess(user)
            }
        }
    }
    
    func AdminSignIn(id: String, password: String) {
        Auth.auth().signIn(withEmail: id, password: password) { [weak self] result, error in
            guard let self else { return }
            if let error = error {
                print(error)
                self.delegate?.loginFailure()
            } else if let user = result?.user {
                self.handleAdminLoginSuccess(user)
                DataManager.shared.id = id
                DataManager.shared.pw = password
            }
        }

    }
    
    private func handleLoginSuccess(_ user: FirebaseAuth.User) {
        let userRef = Database.database().reference().child("accounts").child(user.uid)
        let userRef2 = Database.database().reference().child("users").child(user.uid)
        userRef.observeSingleEvent(of: .value) { (snapshot, _)  in
            if let userData = snapshot.value as? [String: Any],
               let adminUid = userData["adminUid"] as? String,
               let account = userData["account"] as? [String: Any],
               let accountType = account["accountType"] as? Int {
                // 트레이너 일때
                if accountType == 1 {
                    do {
                        let userInfoData = try JSONSerialization.data(withJSONObject: userData, options: [])
                        let userInfo = try JSONDecoder().decode(User.self, from: userInfoData)
                        DataManager.shared.userInfo = userInfo
                    } catch {
                        print("Decoding error: \(error.localizedDescription)")
                    }
                    DataManager.shared.gymUid = adminUid
                    self.getGymInfo() {
                        self.delegate?.trainerLogin()
                    }
                    // 회원 일때
                } else if accountType == 2 {
                    do {
                        let userInfoData = try JSONSerialization.data(withJSONObject: userData, options: [])
                        let userInfo = try JSONDecoder().decode(User.self, from: userInfoData)
                        DataManager.shared.userInfo = userInfo
                    } catch {
                        print("Decoding error: \(error.localizedDescription)")
                    }
                    DataManager.shared.gymUid = adminUid
                    self.getGymInfo() {
                        self.delegate?.userLogin()
                    }
                }
            }
        }
        
        userRef2.observeSingleEvent(of: .value) { (snapshot) in
            if let userData = snapshot.value as? [String: Any],
               let gymInfo = userData["gymInfo"] as? [String: Any],
               let gymAccount = gymInfo["gymAccount"] as? [String: Any],
               let accountType = gymAccount["accountType"] as? Int {
                if accountType == 0 {
                    self.signOut()
                    self.delegate?.loginFailure()
                }
            }
        }
        
        userRef.child("profile").observeSingleEvent(of: .value) { (snapshot) in
            if let profileData = snapshot.value as? [String: Any] {
                do {
                    let profileInfoData = try JSONSerialization.data(withJSONObject: profileData, options: [])
                    let profileInfo = try JSONDecoder().decode(Profile.self, from: profileInfoData)
                    DataManager.shared.profile = profileInfo
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func handleAdminLoginSuccess(_ user: FirebaseAuth.User) {
        let userRef = Database.database().reference().child("users").child(user.uid)
        let userRef2 = Database.database().reference().child("accounts").child(user.uid)
        
        userRef.observeSingleEvent(of: .value) { (snapshot)  in
            if let userData = snapshot.value as? [String: Any],
               let gymInfoJSON = userData["gymInfo"] as? [String: Any],
               let gymAccount = gymInfoJSON["gymAccount"] as? [String: Any],
               let accountType = gymAccount["accountType"] as? Int {
                if accountType == 0 {
                    do {
                        let gymInfoData = try JSONSerialization.data(withJSONObject: gymInfoJSON, options: [])
                        let gymInfo = try JSONDecoder().decode(GymInfo.self, from: gymInfoData)
                        DataManager.shared.realGymInfo = gymInfo
                    } catch {
                        print("Decoding error: \(error.localizedDescription)")
                    }
                    self.delegate?.adminLogin()
                    DataManager.shared.gymUid = user.uid
                }
            }
        }
        
        userRef2.observeSingleEvent(of: .value) { (snapshot)  in
            if let userData = snapshot.value as? [String: Any],
               let account = userData["account"] as? [String: Any],
               let adminUid = userData["adminUid"] as? String,
               let accountType = account["accountType"] as? Int {
                // 트레이너 일때
                if accountType == 1 {
                    Database.database().reference().child("users").child(adminUid).observeSingleEvent(of: .value) { (snapshot)  in
                        if let userData = snapshot.value as? [String: Any],
                           let gymInfoJSON = userData["gymInfo"] as? [String: Any] {
                            do {
                                let gymInfoData = try JSONSerialization.data(withJSONObject: gymInfoJSON, options: [])
                                let gymInfo = try JSONDecoder().decode(GymInfo.self, from: gymInfoData)
                                DataManager.shared.realGymInfo = gymInfo
                            } catch {
                                print("Decoding error: \(error.localizedDescription)")
                            }
                            self.delegate?.trainerLogin()
                            DataManager.shared.gymUid = adminUid
                        }
                    }
                    // 회원 일때
                } else if accountType == 2 {
                    self.delegate?.loginFailure()
                    self.signOut()
                }
            }
        }
    }
    
    // MARK: - 로그아웃
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    // MARK: - 자동 로그인
    func checkLogin() {
        if let currentUser = Auth.auth().currentUser {
            let userRef = Database.database().reference().child("users").child(currentUser.uid)
            let userRef2 = Database.database().reference().child("accounts").child(currentUser.uid)
            
            userRef.observeSingleEvent(of: .value) { (snapshot, _) in
                if let userData = snapshot.value as? [String: Any],
                   let gymInfoJSON = userData["gymInfo"] as? [String: Any],
                   let gymAcoount = gymInfoJSON["gymAccount"] as? [String: Any],
                   let id = gymAcoount["id"] as? String,
                   let pw = gymAcoount["password"] as? String {
                    do {
                        let gymInfoData = try JSONSerialization.data(withJSONObject: gymInfoJSON, options: [])
                        let gymInfo = try JSONDecoder().decode(GymInfo.self, from: gymInfoData)
                        DataManager.shared.realGymInfo = gymInfo
                    } catch {
                        print("Decoding error: \(error.localizedDescription)")
                    }
                    DataManager.shared.gymUid = currentUser.uid
                    DataManager.shared.id = id
                    DataManager.shared.pw = pw
                    self.delegate?.adminLogin()
                }
            }
            
            userRef2.observeSingleEvent(of: .value) { snapshot  in
                if let userData = snapshot.value as? [String: Any],
                   let adminUid = userData["adminUid"] as? String,
                   let account = userData["account"] as? [String: Any],
                   let accountType = account["accountType"] as? Int {
                    // 트레이너 일때
                    if accountType == 1 {
                        Database.database().reference().child("users").child(adminUid).observeSingleEvent(of: .value) { (snapshot) in
                            if let userData = snapshot.value as? [String: Any],
                               let gymInfoJSON = userData["gymInfo"] as? [String: Any],
                               let gymAcoount = gymInfoJSON["gymAccount"] as? [String: Any],
                               let id = gymAcoount["id"] as? String,
                               let pw = gymAcoount["password"] as? String {
                                do {
                                    let gymInfoData = try JSONSerialization.data(withJSONObject: gymInfoJSON, options: [])
                                    let gymInfo = try JSONDecoder().decode(GymInfo.self, from: gymInfoData)
                                    DataManager.shared.realGymInfo = gymInfo
                                } catch {
                                    print("Decoding error: \(error.localizedDescription)")
                                }
                                DataManager.shared.gymUid = adminUid
                                DataManager.shared.id = id
                                DataManager.shared.pw = pw
                                self.delegate?.trainerLogin()
                            }
                        }
                        // 회원 일때
                    } else if accountType == 2 {
                        do {
                            let userInfoData = try JSONSerialization.data(withJSONObject: userData, options: [])
                            let userInfo = try JSONDecoder().decode(User.self, from: userInfoData)
                            DataManager.shared.userInfo = userInfo
                        } catch {
                            print("Decoding error: \(error.localizedDescription)")
                        }
                        DataManager.shared.gymUid = adminUid
                        self.getGymInfo() {
                            self.delegate?.userLogin()
                        }
                    } else if adminUid == "" {
                        self.delegate?.tempLogin()
                    }
                }
            }
            userRef2.child("profile").observeSingleEvent(of: .value) { (snapshot) in
                if let profileData = snapshot.value as? [String: Any] {
                    do {
                        let profileInfoData = try JSONSerialization.data(withJSONObject: profileData, options: [])
                        let profileInfo = try JSONDecoder().decode(Profile.self, from: profileInfoData)
                        DataManager.shared.profile = profileInfo
                    } catch {
                        print("Decoding error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    // MARK: - 헬스장 정보 가져오기
    func getGymInfo(completion: @escaping () -> Void) {
        let userRef = Database.database().reference().child("users").child(DataManager.shared.gymUid!)
        
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            if let userData = snapshot.value as? [String: Any],
               let gymInfoJSON = userData["gymInfo"] as? [String: Any] {
                do {
                    let gymInfoData = try JSONSerialization.data(withJSONObject: gymInfoJSON, options: [])
                    let gymInfo = try JSONDecoder().decode(GymInfo.self, from: gymInfoData)
                    DataManager.shared.realGymInfo = gymInfo
                    completion()
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - 회원탈퇴
    func deleteAccount(completion: @escaping () -> ()) {
        // 계정 삭제
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if let error = error {
                    print("delete Error : ", error)
                } else {
                    self.signOut()
                    // 데이터베이스에서 삭제
                    let userRef = Database.database().reference().child("accounts").child(user.uid)
                    userRef.removeValue()
                    completion()
                }
            }
        } else {
            print("로그인 정보가 존재하지 않습니다.")
        }
    }
    
    // MARK: - 비밀번호 재설정
    func resetPassword(email: String, completion: @escaping (Bool) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
