//
//  ViewController.swift
//  GYMGLE
//
//  Created by t2023-m0078 on 2023/10/11.
//

import UIKit
import FirebaseDatabase
import CryptoKit

class ViewController: UIViewController {
    
    private let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //MARK: - 암호화 (CryptoKit 이용)
        let str = "hello World"
        let data = Data(str.utf8)
        let digest = SHA256.hash(data: data)
        let hash = digest.compactMap { String(format: "%02x", $0)}.joined()
        
        let key = SymmetricKey(size: .bits256)
        let message = str.data(using: .utf8)!
        let sealed = try! AES.GCM.seal(message, using: key)
        
        let decryptedData = try? AES.GCM.open(sealed, using: key)
        print(String(data: decryptedData ?? Data(), encoding: .utf8) ?? "")
        
        //MARK: - FireBase 테스트
        fireBaseTest(title: "제목", name: "공성표", string: "아무내용") // 등록 테스트 코드
        
        fireBaseReadTest("제목") // read 테스트 코드
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) { // 그냥 3초 후에 배경색 빨강으로 바꾸는 코드
            self.view.backgroundColor = .red
        }
    }
    
    private func fireBaseTest(title:String,name:String,string:String){
        let object: [String:Any] = ["이름":name as NSObject, "그냥 스트링":string]
        database.child(title).setValue(object)
        
    }
    
    private func fireBaseReadTest(_ title:String){
        database.child(title).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String:Any] else { return }
            print("테스트 - \(value)")
        })

    }
    
    
}

