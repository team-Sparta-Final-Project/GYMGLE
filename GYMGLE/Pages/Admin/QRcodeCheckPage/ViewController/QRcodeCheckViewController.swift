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
    
    // 1️⃣ 실시간 캡처를 수행하기 위해서 AVCaptureSession 개체를 인스턴스화.
    private let captureSession = AVCaptureSession()
    private let dataTest = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicSetting()
    }
    
}
extension QRcodeCheckViewController {
    
    private func basicSetting() {
        
        // AVCaptureDevice : capture sessions 에 대한 입력(audio or video)과 하드웨어별 캡처 기능에 대한 제어를 제공하는 장치.
        // 즉, 캡처할 방식을 정하는 코드.
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            
            // 시뮬레이터에서 ❌
            fatalError("No video device found")
        }
        do {
            
            // 2️⃣ 적절한 inputs 설정
            // ✅ AVCaptureDeviceInput : capture device 에서 capture session 으로 media 를 제공하는 capture input.
            // ✅ 즉, 특정 device 를 사용해서 input 를 초기화.
            // ✅ 제한하고 싶은 영역
            let rectOfInterest = CGRect(x: (UIScreen.main.bounds.width - 200) / 2 , y: (UIScreen.main.bounds.height - 200) / 2, width: 200, height: 200)

            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // ✅ session 에 주어진 input 를 추가.
            captureSession.addInput(input)
            
            // 3️⃣ 적절한 outputs 설정
            // ✅ AVCaptureMetadataOutput : capture session 에 의해서 생성된 시간제한 metadata 를 처리하기 위한 capture output.
            // ✅ 즉, 영상으로 촬영하면서 지속적으로 생성되는 metadata 를 처리하는 output 이라는 말.
            let output = AVCaptureMetadataOutput()
            
            // ✅ session 에 주어진 output 를 추가.
            captureSession.addOutput(output)
            
            // ✅ AVCaptureMetadataOutputObjectsDelegate 포로토콜을 채택하는 delegate 와 dispatch queue 를 설정한다.
            // ✅ queue : delegate 의 메서드를 실행할 큐이다. 이 큐는 metadata 가 받은 순서대로 전달되려면 반드시 serial queue(직렬큐) 여야 한다.
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // ✅ 리더기가 인식할 수 있는 코드 타입을 정한다. 이 프로젝트의 경우 qr.
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            // ✅ 카메라 영상이 나오는 layer 와 + 모양 가이드 라인을 뷰에 추가하는 함수 호출.
            // ✅ preview layer 에서의 영역 변환값을 리턴받아 사용하기 위해서 기존 코드에서 수정해주었다.
            let rectConverted = setVideoLayer(rectOfInterest: rectOfInterest)

            // ✅ rectOfInterest 를 설정(=제한영역 설정 완료)
            output.rectOfInterest = rectConverted

            // ✅ 정사각형 가이드 라인 추가
            setGuideCrossLineView()
            
            // 4️⃣ startRunning() 과 stopRunning() 로 흐름 통제
            // ✅ input 에서 output 으로의 데이터 흐름을 시작
            captureSession.startRunning()
        }
        catch {
            print("error")
        }
    }
    
    // ✅ 카메라 영상이 나오는 layer 를 뷰에 추가
    private func setVideoLayer(rectOfInterest: CGRect) -> CGRect {
        // 영상을 담을 공간.
        let videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //카메라의 크기 지정
        videoLayer.frame = view.layer.bounds
        //카메라의 비율지정
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(videoLayer)

        return videoLayer.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
    }
    
    // ✅ + 모양 가이드라인을 뷰에 추가
    private func setGuideCrossLineView() {
        let guideCrossLine = UIImageView()
        guideCrossLine.image = UIImage(systemName: "plus")
        guideCrossLine.tintColor = ColorGuide.main
        guideCrossLine.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(guideCrossLine)
        NSLayoutConstraint.activate([
            guideCrossLine.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guideCrossLine.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            guideCrossLine.widthAnchor.constraint(equalToConstant: 30),
            guideCrossLine.heightAnchor.constraint(equalToConstant: 30)
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

// ✅ metadata capture ouput 에서 생성된 metatdata 를 수신하는 메서드.
// ✅ 이 프로토콜은 위에서처럼 AVCaptureMetadataOutput object 가 채택해야만 한다. 단일 메서드가 있고 옵션이다.
// ✅ 이 메서드를 사용하면 capture metadata ouput object 가 connection 을 통해서 관련된 metadata objects 를 수신할 때 응답할 수 있다.(아래 메서드의 파라미터를 통해 다룰 수 있다.)
// ✅ 즉, 이 프로토콜을 통해서 metadata 를 수신해서 반응할 수 있다.
extension QRcodeCheckViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    // ✅ caputure output object 가 새로운 metadata objects 를 보냈을 때 알린다.
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        // ✅ metadataObjects : 새로 내보낸 AVMetadataObject 인스턴스 배열이다.
        if let metadataObject = metadataObjects.first {
            
            // ✅ AVMetadataObject 는 추상 클래스이므로 이 배열의 object 는 항상 구체적인 하위 클래스의 인스턴스여야 한다.
            // ✅ AVMetadataObject 를 직접 서브클래싱해선 안된다. 대신 AVFroundation 프레임워크에서 제공하는 정의된 하위 클래스 중 하나를 사용해야 한다.
            // ✅ AVMetadataMachineReadableCodeObject : 바코드의 기능을 정의하는 AVMetadataObject 의 구체적인 하위 클래스. 인스턴스는 이미지에서 감지된 판독 가능한 바코드의 기능과 payload 를 설명하는 immutable object 를 나타낸다.
            // ✅ (참고로 이외에도 AVMetadataFaceObject 라는 감지된 단일 얼굴의 기능을 정의하는 subclass 도 있다.)
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject, let stringValue = readableObject.stringValue else {
                return
            }
            print(stringValue)
            
            // ✅ input 에서 output 으로의 흐름 중지
            self.captureSession.stopRunning()
            
            // "확인됐습니다" 메시지를 띄우는 작업
            self.showToast(message: "확인됐습니다")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.captureSession.startRunning()
            }
        }
    }
}


