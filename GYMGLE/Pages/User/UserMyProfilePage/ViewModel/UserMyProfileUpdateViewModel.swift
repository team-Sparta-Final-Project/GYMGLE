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
    
    func saveProfile(newProfile: Profile, completion: @escaping () -> Void) {
        let ref = Database.database().reference().child("accounts/\(Auth.auth().currentUser!.uid)/profile")
        do {
            let profileData = try JSONEncoder().encode(newProfile)
            let profileJSON = try JSONSerialization.jsonObject(with: profileData, options: [])
            ref.setValue(profileJSON)
            completion()
        } catch {
            print("테스트 - error")
            completion()
        }
    }
}
