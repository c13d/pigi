//
//  PracticeViewController.swift
//  Pigi
//
//  Created by Chrismanto Natanail Manik on 10/04/22.
//

import UIKit
import AVFoundation

class PracticeViewController: UIViewController {
    
    
    @IBOutlet weak var practiceButton: UIButton!{
        didSet{
            practiceButton.layer.cornerRadius = 10
            practiceButton.clipsToBounds = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    @IBAction func practiceTapped(_ sender: UIButton) {
        checkAuthorizationMedia()
    }
    lazy var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = .high
        return session
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func checkAuthorizationMedia(){
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case (.authorized): // The user has previously granted access to the camera.
            self.performSegue(withIdentifier: "toTimer", sender: self)
        case (.notDetermined): // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                if granted {
                    self.setupCaptureSessionAudio()
                    self.toSetTimer()
                    
                }else{
                    self.alertAudio(message: "Please allow microphone usage from settings")
                }
            }
        case (.denied):
            self.alertAudio(message: "Please allow microphone usage from settings")
        default:
            self.alertAudio(message: "Speech recognition restricted on this device")
            return
        }
        
    }
    
    private func toSetTimer(){
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toTimer", sender: self)
        }
    }
    
    
    private func setupCaptureSessionAudio(){
        // if we've added inputs already, don't do it again...
        guard captureSession.inputs.isEmpty else { return }
        
        // make sure we have a audio to attach to
        guard let audio = findAudio() else{
            print("No Audio found")
            return
        }
        
        do {
            // add the input
            let audioInput = try AVCaptureDeviceInput(device: audio)
            captureSession.addInput(audioInput)
            
        } catch let e {
            print("Error creating capture session: \(e)")
            return
        }
    }
    
    private func findAudio() -> AVCaptureDevice? {
        let deviceTypes: [AVCaptureDevice.DeviceType] = [
            .builtInMicrophone,
        ]
        
        let discovery = AVCaptureDevice.DiscoverySession(deviceTypes: deviceTypes,
                                                         mediaType: .audio,
                                                         position: .back)
        return discovery.devices.first
    }
    
    
    private func alertAudio(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open settings", style: .default, handler: { action in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

//func checkAuthorizationMedia(){
//    switch (AVCaptureDevice.authorizationStatus(for: .video), AVCaptureDevice.authorizationStatus(for: .audio)) {
//    case (.authorized, .authorized): // The user has previously granted access to the camera.
//        self.performSegue(withIdentifier: "toTimer", sender: self)
//    case (.notDetermined, .notDetermined): // The user has not yet been asked for camera access.
//        AVCaptureDevice.requestAccess(for: .video) { granted in
//            if granted {
//                self.setupCaptureSessionVideo()
//                AVCaptureDevice.requestAccess(for: .audio) { grantAudio in
//                    if grantAudio{
//                        self.setupCaptureSessionAudio()
//                        self.toSetTimer()
//                    }else{
//                        self.alertAudio()
//                    }
//                }
//            }else{
//                self.alertVideo()
//            }
//        }
//    case (.authorized, .notDetermined):
//        AVCaptureDevice.requestAccess(for: .audio) { grantAudio in
//            if grantAudio{
//                self.setupCaptureSessionAudio()
//                self.toSetTimer()
//            }
//            else{
//                self.alertAudio()
//            }
//        }
//        //            self.performSegue(withIdentifier: "toTimer", sender: self)
//    case (.notDetermined, .authorized):
//        AVCaptureDevice.requestAccess(for: .video) { granted in
//            if granted {
//                self.setupCaptureSessionVideo()
//                self.toSetTimer()
//
//            }else{
//                self.alertVideo()
//            }
//        }
//        //            self.performSegue(withIdentifier: "toTimer", sender: self)
//        print("autho audio")
//
//    case (.denied, _):
//        alertVideo()
//    case (_, .denied):
//      alertAudio()
//    default:
//        print("Restricted")
//        return
//    }
//
//}
//private func setupCaptureSessionVideo(){
//    // if we've added inputs already, don't do it again...
//    guard captureSession.inputs.isEmpty else { return }
//
//    // make sure we have a camera to attach to
//    guard let camera = findCamera() else {
//        print("No camera found")
//        return
//    }
//    do {
//        // add the input
//        let cameraInput = try AVCaptureDeviceInput(device: camera)
//        captureSession.addInput(cameraInput)
//
//    } catch let e {
//        print("Error creating capture session: \(e)")
//        return
//    }
//}
//private func findCamera() -> AVCaptureDevice? {
//        let deviceTypes: [AVCaptureDevice.DeviceType] = [
//            .builtInDualCamera,
//            .builtInTelephotoCamera,
//            .builtInWideAngleCamera,
//        ]
//
//        let discovery = AVCaptureDevice.DiscoverySession(deviceTypes: deviceTypes,
//                                                         mediaType: .video,
//                                                         position: .back)
//
//        return discovery.devices.first
//    }
//

//    private func alertVideo(){
//        let alert = UIAlertController(title: "Error", message: "Please allow camera usage from settings", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Open settings", style: .default, handler: { action in
//            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        present(alert, animated: true, completion: nil)
//    }

//func checkAuthorizationMedia(){
//    switch (AVCaptureDevice.authorizationStatus(for: .video), AVCaptureDevice.authorizationStatus(for: .audio)) {
//    case (.authorized, .authorized): // The user has previously granted access to the camera.
//        self.performSegue(withIdentifier: "toTimer", sender: self)
//    case (.notDetermined, .notDetermined): // The user has not yet been asked for camera access.
//        AVCaptureDevice.requestAccess(for: .video) { granted in
//            if granted {
//                self.setupCaptureSessionVideo()
//                AVCaptureDevice.requestAccess(for: .audio) { grantAudio in
//                    if grantAudio{
//                        self.setupCaptureSessionAudio()
//                        self.toSetTimer()
//                    }else{
//                        self.alertAudio()
//                    }
//                }
//            }else{
//                self.alertVideo()
//            }
//        }
//    case (.authorized, .notDetermined):
//        AVCaptureDevice.requestAccess(for: .audio) { grantAudio in
//            if grantAudio{
//                self.setupCaptureSessionAudio()
//                self.toSetTimer()
//            }
//            else{
//                self.alertAudio()
//            }
//        }
//        //            self.performSegue(withIdentifier: "toTimer", sender: self)
//    case (.notDetermined, .authorized):
//        AVCaptureDevice.requestAccess(for: .video) { granted in
//            if granted {
//                self.setupCaptureSessionVideo()
//                self.toSetTimer()
//
//            }else{
//                self.alertVideo()
//            }
//        }
//        //            self.performSegue(withIdentifier: "toTimer", sender: self)
//        print("autho audio")
//
//    case (.denied, _):
//        alertVideo()
//    case (_, .denied):
//      alertAudio()
//    default:
//        print("Restricted")
//        return
//    }
//
//}
