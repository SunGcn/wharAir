//
//  CameraUI.swift
//  whatAir
//
//  Created by 孙港 on 2017/7/30.
//  Copyright © 2017年 孙港. All rights reserved.
//

import AVFoundation
import UIKit
import CoreLocation
import CoreMotion
import CoreData
import QuartzCore

class CameraUI: UIViewController,AVCapturePhotoCaptureDelegate ,CLLocationManagerDelegate, CAAnimationDelegate{
    var imageView: UIImageView!
    
    var captureSesssion: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!

    
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    let locationLabel = UILabel()
    let locationStrLabel = UILabel()
    let locationAltitude = UILabel()
    
    var altitude:Double = 0
    var latitude:Double = 0
    var longitude:Double = 0
    var locationName:String = ""
    
    //运动管理器
    let motionManager = CMMotionManager()
    
    let labelX = UILabel()
    let labelY = UILabel()
    let labelZ = UILabel()
    
    var x:Double = 0.0
    var y:Double = 0.0
    var z:Double = 0.0
    var heading:Double = 0.0

    
    
    var messageButton:UIButton!
    
    var lastAngle = 3.1416 / 2
    var lastPoint = CGPoint(x: 100,y: 100)
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
        
        /*let captureBtn = UIButton()
        captureBtn.frame.size = CGSize(width: 48, height: 48)
        captureBtn.center.x = self.view.center.x
        captureBtn.frame.origin.y = self.view.frame.height - 100
        captureBtn.setImage(UIImage(named:"takephoto"), for: UIControlState.normal)
        captureBtn.addTarget(self, action: #selector(takePhoto), for: UIControlEvents.touchUpInside)
        self.view.addSubview(captureBtn)*/
        
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

        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1
        locationManager.requestAlwaysAuthorization()
        
        
        locationLabel.frame = CGRect(x: 0, y: 50, width: self.view.bounds.width, height: 100)
        locationLabel.textAlignment = .center
        locationLabel.textColor = UIColor.white
        self.view.addSubview(locationLabel)
        
        locationAltitude.frame = CGRect(x: 0, y: 100, width: self.view.bounds.width, height: 100)
        locationAltitude.textAlignment = .center
        locationAltitude.textColor = UIColor.white
        self.view.addSubview(locationAltitude)
        
        locationStrLabel.frame = CGRect(x: 0, y: 150, width: self.view.bounds.width, height: 50)
        locationStrLabel.textAlignment = .center
        locationStrLabel.textColor = UIColor.white
        self.view.addSubview(locationStrLabel)
        
        let findMyLocationBtn = UIButton(type: .custom)
        findMyLocationBtn.frame = CGRect(x: 50, y: self.view.bounds.height - 80, width: self.view.bounds.width - 100, height: 50)
        findMyLocationBtn.setTitle("Find My Position", for: UIControlState.normal)
        findMyLocationBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        findMyLocationBtn.addTarget(self, action: #selector(findMyLocation), for: UIControlEvents.touchUpInside)
        self.view.addSubview(findMyLocationBtn)
        
        
        labelX.frame = CGRect(x: 0, y: 200, width: self.view.bounds.width, height: 50)
        labelX.textAlignment = .center
        labelX.textColor = UIColor.white
        self.view.addSubview(labelX)
        labelY.frame = CGRect(x: 0, y: 220, width: self.view.bounds.width, height: 50)
        labelY.textAlignment = .center
        labelY.textColor = UIColor.white
        self.view.addSubview(labelY)
        labelZ.frame = CGRect(x: 0, y: 240, width: self.view.bounds.width, height: 50)
        labelZ.textAlignment = .center
        labelZ.textColor = UIColor.white
        self.view.addSubview(labelZ)
        
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Message>(entityName:"Message")
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            for info in fetchedObjects{
                //var i:Int!
                //i = 0
                if(getDistance(selfLocation: CLLocation(latitude: selfLatitude_Double, longitude: selfLongitude_Double),
                               messageLocation: CLLocation(latitude: info.latitude, longitude: info.longitude)) < MAXLENGTHSCAN){
                    //messagesArrayX[i] = getHorizonalDistance(selfLocation: CLLocation(latitude: selfLatitude_Double, longitude: selfLongitude_Double),
                    //                                         messageLocation: CLLocation(latitude: info.latitude, longitude: info.longitude))
                    //messagesArrayY[i] = getVerticalDistance(selfLocation: CLLocation(latitude: selfLatitude_Double, longitude: selfLongitude_Double),
                    //                                        messageLocation: CLLocation(latitude: info.latitude, longitude: info.longitude))
                }
            }
        }
        catch {
            fatalError("不能保存：\(error)")
        }

        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
        
        getRotationValues()
        
        
        
        //添加按钮
        messageButton = UIButton(type: UIButtonType.system)
        messageButton.setTitle("hello world 这是第一条消息", for: UIControlState())
        messageButton.layer.cornerRadius = 8
        messageButton.frame = CGRect(x: 100, y: 100, width: 200, height: 36)
        //sendButton.setImage(UIImage(named:"button"), for: UIControlState.normal)
        messageButton.backgroundColor = UIColor.init(colorLiteralRed: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.75)
        messageButton.tintColor = UIColor.init(colorLiteralRed: 59/255.0, green: 151/255.0, blue: 247/255.0, alpha: 0.75)
        //messageButton.addTarget(self, action: #selector(MapUI.sendAction), for: UIControlEvents.touchUpInside)
        self.view.addSubview(messageButton)
        
        
        //rotationButton(button: messageButton,angle: Double(CGFloat.pi / 2.0))
        //rotationButton(button: messageButton,angle: Double(CGFloat.pi / 2.0))
        addButton(currentView: self.view, locationX: 200, locationY: 400)
        
        
    }
    
    func addButton(currentView:UIView, locationX:Int, locationY:Int)
    {
        var messageButton:UIButton!
        
        messageButton = UIButton(type: UIButtonType.system)
        messageButton.setTitle("hello world 这是第一条消息", for: UIControlState())
        messageButton.layer.cornerRadius = 8
        messageButton.frame = CGRect(x: locationX, y: locationY, width: 200, height: 36)
        //sendButton.setImage(UIImage(named:"button"), for: UIControlState.normal)
        messageButton.backgroundColor = UIColor.init(colorLiteralRed: 59/255.0, green: 151/255.0, blue: 247/255.0, alpha: 0.75)
        messageButton.tintColor = UIColor.init(colorLiteralRed: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.75)
        

        currentView.addSubview(messageButton)
    }
    
    
    func rotationButton(button:UIButton, angle:Double, point:CGPoint)
    {
        //控制按钮旋转
        let fullRotation = CABasicAnimation(keyPath: "transform.rotation")
        fullRotation.delegate = self
        fullRotation.fromValue = NSNumber(floatLiteral: lastAngle)
        fullRotation.toValue = NSNumber(floatLiteral: angle) // Double(CGFloat.pi / 2.0)
        
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = NSValue(cgPoint: lastPoint)
        animation.toValue = NSValue(cgPoint: point)
        
    
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.beginTime = CACurrentMediaTime() + 0.5
        groupAnimation.duration = 0.1
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = kCAFillModeBackwards
        groupAnimation.animations = [fullRotation,animation]
        
        button.layer.add(groupAnimation ,forKey: "")

    }
    
    
    func findMyLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.trueHeading
        selfDirection_Double = heading
        let directionStr = "\(heading)  "
        locationAltitude.text = directionStr
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locations : NSArray = locations as NSArray
        let currentLocation = locations.lastObject as! CLLocation
        let locationStr = "\(currentLocation.coordinate.latitude) \(currentLocation.coordinate.longitude)"
        //let altitudeStr = "\(currentLocation.altitude)  "
        
        locationLabel.text = locationStr
        
        //selfLatitude_Double = currentLocation.coordinate.latitude
        //selfLongitude_Double = currentLocation.coordinate.longitude
        
        
    }
    
    //将经纬度转换为城市名
    func reverseGeocode(location:CLLocation) {
        geocoder.reverseGeocodeLocation(location) { (placeMark, error) in
            if(error == nil) {
                let tempArray = placeMark! as NSArray
                let mark = tempArray.firstObject as! CLPlacemark
                //                now begins the reverse geocode
                let addressDictionary = mark.addressDictionary! as NSDictionary
                let country = addressDictionary.value(forKey: "Country") as! String
                let city = addressDictionary.object(forKey: "City") as! String
                let street = addressDictionary.object(forKey: "Street") as! String
                
                let finalAddress = "\(street),\(city),\(country)"
                self.locationStrLabel.text = finalAddress
                
            }
        }
    }
    
    // 开始获取手机姿态信息
    func getRotationValues() {
        //Swift
        if motionManager.isAccelerometerAvailable {
            self.motionManager.accelerometerUpdateInterval = 0.1
            let queue = OperationQueue.current
            self.motionManager.startAccelerometerUpdates(to: queue!, withHandler: {
                (accelerometerData, error) in
                guard error == nil else {
                    print(error!)
                    return
                }
                if self.motionManager.isAccelerometerAvailable{
                    if let rotationValue = accelerometerData?.acceleration {
                        self.x = rotationValue.x
                        self.y = rotationValue.y
                        self.z = rotationValue.z
                        
                        selfXRotation_Double = self.x
                        selfYRotation_Double = self.y
                        selfZRotation_Double = self.z
                        
                        //let rotationAngle = 0.5//Double(CGFloat.pi / 2.0) //+ Double(self.y * 90.0) * Double(CGFloat.pi / 180.0)
                        //self.rotationButton(button: self.messageButton, angle: rotationAngle)
            
                        //let rotationAngle1:CGFloat = CGFloat.pi / 2
                        //let aa = self.y / 2
                        //let rotationAngle2:CGFloat = CGFloat.pi /
                        //let rotationAngle = rotationAngle1 + rotationAngle2
                        //let pi:Double = 3.1416
                        
                        //let angle:Double = pi / 2.0 + pi * rotationValue.y / 2.0
                        //self.messageButton.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
                        let currentAngle = 3.1416 / 2 + asin(rotationValue.y)
                        let currentPoint = CGPoint(x: self.lastPoint.x + CGFloat(abs(abs(rotationValue.x) - 1)),y: self.lastPoint.y)
                        self.rotationButton(button: self.messageButton, angle: currentAngle )
                        self.lastAngle = currentAngle
                        //self.messageButton.transform = CGAffineTransform.init(translationX: 1, y: 1)
                        //self.messageButton.frame.origin.x = 250
                        
                        /*let buttonX = self.messageButton.frame.origin.x
                        print(self.messageButton.frame.origin.x)
                        print(self.messageButton.frame.origin.y)
                        let buttonY = self.messageButton.frame.origin.y
                        if(rotationValue.z < 0)
                        {
                           // buttonX = buttonX + CGFloat(abs(rotationValue.x - 1) * 30)
                        }
                        else
                        {
                            //buttonX = self.messageButton.frame.origin.x
                        }
                        self.messageButton.frame = CGRect(x: buttonX, y: buttonY, width: 200, height: 36)*/

                        
                        var textX = "X: "
                        textX += String(format: "%.4f", rotationValue.x)
                        self.labelX.text = textX
                        var textY = "Y: "
                        textY += String(format: "%.4f", rotationValue.y)
                        self.labelY.text = textY
                        var textZ = "Z: "
                        textZ += String(format: "%.4f", rotationValue.z)
                        self.labelZ.text = textZ
                        //print(self.heading)
                    }
                }
            })
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
