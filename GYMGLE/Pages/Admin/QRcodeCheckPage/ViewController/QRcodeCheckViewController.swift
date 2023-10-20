//
//  QRcodeCheckViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/19.
//

import UIKit
import AVFoundation
import QRCodeReader

final class QRcodeCheckViewController: UIViewController {
    
    // 실시간 캡처를 수행하기 선언
    private let captureSession = AVCaptureSession()
    
    private let dataTest = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naviBarSetting()
        qrCodeSetting()
    }
    
}
private extension QRcodeCheckViewController {
    
    //네비게이션바 세팅
    func naviBarSetting() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .none
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.tintColor = .blue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }
    func qrCodeSetting() {
        
        // 캡처 방식 (video, 전면카메라)
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { fatalError("No video device found") }
        do {
            // 제한하고 싶은 영역
            let rectOfInterest = CGRect(x: (UIScreen.main.bounds.width - 200) / 2 , y: (UIScreen.main.bounds.height - 200) / 2, width: 200, height: 200)

            //AVCaptureDeviceInput : capture device 에서 capture session 으로 media 를 제공하는 capture input.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            // 카메라 촬영하면서 생성되는 metadata를 처리하는 output
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
            captureSession.startRunning()
        }
        catch {
            print("error")
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
            plusImage.image = UIImage(systemName: "plus")
            plusImage.tintColor = ColorGuide.main
            plusImage.translatesAutoresizingMaskIntoConstraints = false
            return plusImage
        }()
        view.addSubview(plusImage)
        NSLayoutConstraint.activate([
            plusImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plusImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            plusImage.widthAnchor.constraint(equalToConstant: 30),
            plusImage.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    func showToast(message: String) {
        let toastView = ToastView()
        toastView.configure()
        toastView.text = message
        view.addSubview(toastView)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            toastView.widthAnchor.constraint(equalToConstant: view.frame.size.width / 2),
            toastView.heightAnchor.constraint(equalToConstant: view.frame.height / 18),
        ])
        UIView.animate(withDuration: 2.5, delay: 0.2) { //2.5초
            toastView.alpha = 0
        } completion: { _ in
            toastView.removeFromSuperview()
        }
    }
}

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
            print(stringValue)
           
                dataTest.updateIsInGym(id: stringValue )
                dataTest.gymInfo.gymInAndOutLog.append(InAndOut(id: stringValue, inTime: Date(), outTime: Date(), sinceInAndOutTime: 1.0))
            
            
            self.captureSession.stopRunning()
            self.showToast(message: "확인했습니다")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.captureSession.startRunning()
                print( "list: \(self.dataTest.gymInfo.gymUserList)")
                print( "list: \(self.dataTest.gymInfo.gymInAndOutLog)")
            }
        }
    }
}


