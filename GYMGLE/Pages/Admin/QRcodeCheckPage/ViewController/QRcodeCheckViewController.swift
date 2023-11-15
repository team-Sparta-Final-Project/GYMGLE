//
//  QRcodeCheckViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/19.
//

import UIKit
import AVFoundation
import FirebaseDatabase
import FirebaseAuth

final class QRcodeCheckViewController: UIViewController {
    
    // MARK: - properties
    // 실시간 캡처를 수행하기 선언(AVCaptureSession: 오디오 및 비디오 데이터 스트림을 캡처하고 처리하기 위한 핵심 구성 요소)
    private let captureSession = AVCaptureSession()
    private var userUidList: [String] = []
    // MARK: - lifr cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        qrCodeSetting()
        readAdminUid()
        readUserUid()
    }
}

// MARK: - extension custom func

private extension QRcodeCheckViewController {
    
    func qrCodeSetting() {
        // 캡처 방식 (video, 전면카메라)
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { fatalError("No video device found") }
        do {
            // 제한하고 싶은 영역
            let rectOfInterest = CGRect(x: (UIScreen.main.bounds.width - 200) / 2 , y: (UIScreen.main.bounds.height - 200) / 2, width: 200, height: 200)
            
            //AVCaptureDeviceInput : capture device 에서 capture session 으로 media 를 제공하는 capture input.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            // 카메라 촬영하면서 생성되는 metadata를 처리하는 output(캡처한 미디어 데이터를 처리하거나 저장)
            let output = AVCaptureMetadataOutput()
            captureSession.addOutput(output)
            
            // AVCaptureMetadataOutputObjectsDelegate 포로토콜을 채택하는 delegate 와 dispatch queue 를 설정
            // -> AVCaptureMetadataOutputObjectsDelegate❗️
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            let rectConverted = setVideoLayer(rectOfInterest: rectOfInterest)
            
            // QR 코드 제한영역 설정
            output.rectOfInterest = rectConverted
            
            setGuideCrossLineView()
           
            // input 에서 output 으로의 데이터 흐름을 시작
            DispatchQueue.main.async {
                self.captureSession.startRunning()
            }
            
        }
        catch {
        }
    }
    func setVideoLayer(rectOfInterest: CGRect) -> CGRect{
        let videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoLayer.frame = view.layer.bounds
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(videoLayer)
        return videoLayer.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
    }
    
    func setGuideCrossLineView() {
        lazy var plusImage: UIImageView = {
           let plusImage = UIImageView()
            plusImage.image = UIImage(systemName: "plus")?.resized(to: CGSize(width: 42, height: 36)).withRenderingMode(.alwaysTemplate)
           plusImage.tintColor = ColorGuide.main
           plusImage.translatesAutoresizingMaskIntoConstraints = false
           return plusImage
       }()
        lazy var backButton: UIButton = {
            let button = UIButton()
            button.buttonImageMakeUI(image: "chevron.backward", color: ColorGuide.main)
            button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            return button
        }()
        view.addSubview(plusImage)
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            plusImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plusImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    func readAdminUid(){
        let ref = Database.database().reference().child("accounts")
        let query = ref.queryOrdered(byChild: "adminUid").queryEqual(toValue: DataManager.shared.gymUid)
        query.observeSingleEvent(of: .value) { snapshot in
            guard let userSnapshot = snapshot.value as? [String:[String:Any]] else {
                return
            }
            do {
                let jsonArray = userSnapshot.values.compactMap { $0 as [String: Any] }
                let jsonData = try JSONSerialization.data(withJSONObject: jsonArray)
                let user = try JSONDecoder().decode([User].self, from: jsonData)
                DataManager.shared.userList = user
            } catch let error {
            }
        }
    }
    
//    func readUser(){ -> 전페이지에서 이름과 전화번호, 이메일, 비밀번호 db에 저장하면 이걸로 쓰면 됨 (전페이지 이메일 텍스트필드 받아오기)❌못씀 ? 관리자는 이메일 주소 모름
//        let ref = Database.database().reference().child("accounts")
//        let query = ref.queryOrdered(byChild: "account/id").queryEqual(toValue: "apple2@gmail.com")
//        query.observeSingleEvent(of: .value) { snapshot in
//            guard let userSnapshot = snapshot.value as? [String:[String:Any]] else {
//                return
//            }
//            print("테스트 - \(userSnapshot.keys)")
//        }
//    }
    
    func readUserUid() { // -> 전페이지에서 이름과 전화번호, 이메일, 비밀번호 db에 저장해서 uid로 저장이 되면 uid 다가져와서 그 중에 있으면 찍히는 걸로 하기
        self.userUidList.removeAll()
        let ref = Database.database().reference().child("accounts")
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let userSnapshot = snapshot.value as? [String:[String:Any]] else {
                return
            }
            self.userUidList.append(contentsOf: userSnapshot.keys)
        }
    }
    
    func createdInAndOutLog(id: String) { //큐알코드를 찍었을 때
        let ref = Database.database().reference().child("users").child(DataManager.shared.gymUid!)
        if let currentedTimePlusOne = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) {
            let nAndOutLog = InAndOut(id: id, inTime: Date(), outTime: currentedTimePlusOne, sinceInAndOutTime: 0.0)
            do {
                let inAndOutLogData = try JSONEncoder().encode(nAndOutLog)
                let inAndOutLogJSON = try JSONSerialization.jsonObject(with: inAndOutLogData, options: [])
                ref.child("gymInAndOutLog").childByAutoId().setValue(inAndOutLogJSON)
            } catch {
                
            }
        }
    }

}
// MARK: - AVCaptureMetadataOutputObjectsDelegate

// metadata capture ouput 에서 생성된 metatdata 를 수신
// capture metadata ouput object 가 connection 을 통해서 관련된 metadata objects 를 수신할 때 응답할 수 있음 (아래 메서드를 사용)
extension QRcodeCheckViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        // 새로 내보낸 AVMetadataObject 인스턴스 배열
        if let metadataObject = metadataObjects.first {
            
            // AVMetadataObject 는 추상 클래스이므로직접 서브클래싱해선 안됨❗️
            // 대신 AVFroundation 프레임워크에서 제공하는 정의된 하위 클래스 중 하나를 사용해야 함
            // AVMetadataMachineReadableCodeObject : 바코드의 기능을 정의하는 AVMetadataObject의 하위 클래스
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject, let stringValue = readableObject.stringValue else {
                return
            }
            if (DataManager.shared.userList.first(where: {$0.account.id == stringValue}) != nil) {
                createdInAndOutLog(id: stringValue)
                
                showToast(message: "확인했습니다!", view: self.view, bottomAnchor: -80, widthAnchor: 160, heightAnchor: 50)
                self.captureSession.stopRunning()
                AudioServicesPlaySystemSound(SystemSoundID(1000))
            } else if (userUidList.first(where: {$0 == stringValue}) != nil) {
                showToast(message: "확인했습니다!", view: self.view, bottomAnchor: -80, widthAnchor: 160, heightAnchor: 50)
                self.captureSession.stopRunning()
                let userRegisterDateVC = UserRegisterDateViewController()
                userRegisterDateVC.userUid = stringValue
                userRegisterDateVC.modalPresentationStyle = .fullScreen
                self.present(userRegisterDateVC, animated: true)
            } else {
                showToast(message: "회원이 아닙니다!", view: self.view, bottomAnchor: -80, widthAnchor: 160, heightAnchor: 50)
                self.captureSession.stopRunning()
                AudioServicesPlaySystemSound(SystemSoundID(1006))
            }
            readAdminUid()
            readUserUid()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.captureSession.startRunning()
            }
        }
    }
}


