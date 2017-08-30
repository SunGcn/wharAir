//
//  CameraUI.swift
//  whatAir
//
//  Created by 孙港 on 2017/7/30.
//  Copyright © 2017年 孙港. All rights reserved.
//

import UIKit
import AVFoundation

class CameraUI: UIViewController,AVCapturePhotoCaptureDelegate {
    var imageView: UIImageView!
    
    var captureSesssion: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSesssion = AVCaptureSession()
        captureSesssion.sessionPreset = AVCaptureSessionPresetPhoto
        
        self.imageView = UIImageView(frame: self.view.bounds)
        self.view.addSubview(self.imageView)
        
        /*let session = UIButton()
        session.frame.size = CGSize(width: 200, height: 40)
        session.center.x = self.view.center.x
        session.frame.origin.y = self.view.frame.height - 300
        session.setBackgroundImage(UIImage(named:"bg"), for: .normal)
        session.setTitle("第一条消息", for: .normal)
        self.view.addSubview(session)
        
        let textview = UITextView(frame:CGRect(x:10, y:100, width:350, height:200))
        textview.layer.borderWidth = 1  //边框粗细
        textview.layer.borderColor = UIColor.red.cgColor //.gray.cgColor //边框颜色
        self.view.addSubview(textview)*/
        
        let captureBtn = UIButton()
        captureBtn.frame.size = CGSize(width: 48, height: 48)
        captureBtn.center.x = self.view.center.x
        captureBtn.frame.origin.y = self.view.frame.height - 100
        captureBtn.setImage(UIImage(named:"takephoto"), for: UIControlState.normal)
        captureBtn.addTarget(self, action: #selector(takePhoto), for: UIControlEvents.touchUpInside)
        self.view.addSubview(captureBtn)
        
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if (captureSesssion.canAddInput(input)) {
                captureSesssion.addInput(input)
                stillImageOutput = AVCapturePhotoOutput()
                if (captureSesssion.canAddOutput(stillImageOutput)) {
                    captureSesssion.addOutput(stillImageOutput)
                    
                    let captureVideoLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: captureSesssion)
                    captureVideoLayer.frame = self.imageView.bounds
                    captureVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                    self.imageView.layer.addSublayer(captureVideoLayer)
                    
                    captureSesssion.startRunning()
                }
            }
        }
            
        catch {
            print(error)
        }
    }
    
    //    MARK: - Button Action
    func takePhoto(_ sender: Any){
        
        //        Animation for taking photos
        DispatchQueue.main.async { [unowned self] in
            self.view.layer.opacity = 0
            UIView.animate(withDuration: 0.25) { [unowned self] in
                self.view.layer.opacity = 1
            }
        }
        
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .auto
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        stillImageOutput?.capturePhoto(with: settingsForMonitoring, delegate: self)
    }
    
    //    MARK: - AVCapturePhotoCaptureDelegate
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let photoSampleBuffer = photoSampleBuffer {
            let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            let image = UIImage(data: photoData!)
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        }
    }
}
