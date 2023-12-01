//
//  UserMyProfileUpdateViewModel.swift
//  GYMGLE
//
//  Created by 박성원 on 11/12/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


final class UserMyProfileUpdateViewModel {
   
    let dataManager: DataManager
    
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
    }
    
    // 이미지를 스토리지에 올리기
    func uploadImage(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let imageName = Auth.auth().currentUser!.uid
        
        let firebaseReference = Storage.storage().reference().child("profiles").child("\(imageName)")
        let uploadTask = firebaseReference.putData(imageData, metadata: metaData) { metaData, error in
            firebaseReference.downloadURL { url, _ in
                completion(url)
            }
        }
//        uploadTask.observe(.progress) { snapshot in
//            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
//            print("업로드 진행률: \(percentComplete)%")
//        }
    }
    
    func saveProfile(newProfile: Profile) {
        let ref = Database.database().reference().child("accounts/\(Auth.auth().currentUser!.uid)/profile")
        do {
            let profileData = try JSONEncoder().encode(newProfile)
            let profileJSON = try JSONSerialization.jsonObject(with: profileData, options: [])
            ref.setValue(profileJSON)
        } catch {
            print("테스트 - error")
        }
    }
    
    func viewDisappearEvent(image: UIImage, nickName: String, completion: @escaping () -> Void) {
        self.uploadImage(image: image) { url in
            guard let url = url else { return }
            let myProfile = Profile(image: url, nickName: nickName)
            DataManager.shared.profile = myProfile
            self.saveProfile(newProfile: myProfile)
            completion()
        }
    }
    
    func nickNameDuplicateCheck(target: String, completion: @escaping (Bool) -> Void) {
        let ref = Database.database().reference().child("accounts")
        ref.queryOrdered(byChild: "profile/nickName").queryEqual(toValue: target).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                completion(true)
                return
            }
            completion(false)
        }
    }
}
