//
//  AdminRegisterViewModel.swift
//  GYMGLE
//
//  Created by 조규연 on 11/10/23.
//

import Foundation
import Combine
import Firebase

class AdminRegisterViewModel: ObservableObject {
    var isIdDuplicated: Bool = false
    var isNumberDuplicated: Bool = false
    var isValid: Bool = false
    var emailValid: Bool = false
    var pwValid: Bool = false
    var allValid: Bool = false
    
    @Published var gymInfo: GymInfo?
    
    // 이메일 정규식: 알파벳과 숫자 중간에 @가 포함되며 끝 2~3자리 앞에 .이 포함
    let emailPattern = "^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\\.[a-zA-Z]{2,3}$"
    // 비밀번호 정규식: 8~16자리 알파벳, 영어, 특수문자가 포함
    let pwPattern = "^.*(?=^.{8,16}$)(?=.*\\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$"
}

// MARK: - Actions
extension AdminRegisterViewModel {
    
    func numberDuplicateCheck(registerNumber: String?, completion: @escaping (Bool) -> Void) {
        
        let ref = Database.database().reference().child("users")
//        let target = adminRegisterView.registerNumberTextField.text
        let target = registerNumber
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? [String: Any] {
                for (_, userData) in data {
                    if let userDic = userData as? [String: Any],
                       let gymInfo = userDic["gymInfo"] as? [String: Any],
                       let gymNumber = gymInfo["gymnumber"] as? String {
                        if gymNumber == target {
                            completion(true)
                            return
                        }
                    }
                }
                completion(false)
            }else {
                completion(false)
            }
            
        }
    }
    
    func emailDuplicateCheck(email: String, completion: @escaping (Bool) -> Void) {
        let ref = Database.database().reference().child("accounts")

        // 해당 이메일 주소를 사용하는 사용자가 있는지 확인
        ref.queryOrdered(byChild: "account/id").queryEqual(toValue: email).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                // 이미 사용 중인 이메일 주소가 존재
                completion(true)
            } else {
                // 사용 가능한 이메일 주소
                completion(false)
            }
        }
    }
    
    func voidCheck(textField: UITextField, completion: @escaping () -> ()) {
        if textField.text?.isEmpty == true {
            completion()
            return
        }
    }
    
    func validCheck(completion: @escaping (Bool) -> ()) {
        if isValid {
            completion(true)
        } else {
            completion(false)
        }
    }
}

// MARK: - 사업자등록번호 진위확인 API
extension AdminRegisterViewModel {
    // 사업자 등록번호
    func loadAPI(parameters: [String: [String]], completion: @escaping () -> Void) {
        let url = URL(string: "https://api.odcloud.kr/api/nts-businessman/v1/status?serviceKey=%2BOc%2FfCL8SbceIGb1K%2FNBvoWNBA1SLS153VGLIDJIFQ3yt0m3Hui01FHuxVVSWZg8gDmPL8rhc1IIlvssUA7utw%3D%3D")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = jsonData
        // URLSession을 사용하여 요청 보내기
        URLSession.shared.dataTask(with: request) {[weak self] (data, response, error) in
            guard let self else { return }
            if let error = error {
                print("오류: \(error)")
            } else if let data = data {
                guard let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    return
                }
                if let data = result["data"] as? [[String:String]],
                   let b_stt_cd = data.first?["b_stt_cd"] {
                    print("사업자유효:\(b_stt_cd)")
                    if b_stt_cd == "01" {
                        self.isValid = true
                    } else {
                        self.isValid = false
                    }
                    // if b_stt_cd = "01" 계속사업자
                    // "02" 휴업자
                    // "03" 폐업자
                }
            }
            completion()
        }
        .resume()
    }
}

// MARK: - Firebase Auth
extension AdminRegisterViewModel {
    
    // MARK: - 이메일 비밀번호 정규식 체크
    func isValid(text: String, pattern: String) -> Bool {
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: text)
    }
    
    func checkID(id: String) {
        if isValid(text: id, pattern: emailPattern) {
            emailValid = true
        } else {
            emailValid = false
        }
    }
    
    func checkPW(pw: String) {
        if isValid(text: pw, pattern: pwPattern) {
            pwValid = true
        } else {
            pwValid = false
        }
    }
    
    func checkAll() {
        if emailValid && pwValid {
            allValid = true
        } else {
            allValid = false
        }
    }
    
    // MARK: - 회원가입
    func createUser(id: String, pw: String, gymName: String, gymPhoneNumber: String, gymNumber: String) {
        let gymInfo = GymInfo(gymAccount: Account(id: id, password: pw, accountType: 0),
                              gymName: gymName,
                              gymPhoneNumber: gymPhoneNumber,
                              gymnumber: gymNumber)
        let noticeList = Notice(date: Date(), content: "GYMGLE을 사용해주셔서 감사합니다. 처음 글 작성 후 이 글을 삭제해주세요.")
        let gymInAndOutLog = InAndOut(id: "default", inTime: Date(), outTime: Date(), sinceInAndOutTime: 0)
        Auth.auth().createUser(withEmail: id, password: pw) { result, error in
            if let error = error {
                print(error)
            } else {
                do {
                    let gymInfoData = try JSONEncoder().encode(gymInfo)
                    let gymInfoJSON = try JSONSerialization.jsonObject(with: gymInfoData, options: [])
                    
                    let noticeListData = try JSONEncoder().encode(noticeList)
                    let noticeListJSON = try JSONSerialization.jsonObject(with: noticeListData, options: [])

                    let gymInAndOutLogData = try JSONEncoder().encode(gymInAndOutLog)
                    let gymInAndOutLogJSON = try JSONSerialization.jsonObject(with: gymInAndOutLogData, options: [])

                    
                    if let user = result?.user {
                        let userRef = Database.database().reference().child("users").child(user.uid)
                        userRef.child("gymInfo").setValue(gymInfoJSON)
                        userRef.child("noticeList").childByAutoId().setValue(noticeListJSON)
                        userRef.child("gymInAndOutLog").childByAutoId().setValue(gymInAndOutLogJSON)
                    }
                    
//                    let vc = AdminLoginViewController()
//                    self.navigationController?.pushViewController(vc, animated: true)
                } catch {
                    print("JSON 인코딩 에러")
                }
            }
        }
    }
    
    func updatedAdminInfo(gymName: String, gymPhoneNumber: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userID).child("gymInfo")
        ref.updateChildValues(["gymName":gymName])
        ref.updateChildValues(["gymPhoneNumber":gymPhoneNumber])
        DataManager.shared.realGymInfo?.gymName = gymName
        DataManager.shared.realGymInfo?.gymPhoneNumber = gymPhoneNumber
//        navigationController?.popViewController(animated: true)
    }
}
