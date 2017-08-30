//
//  ViewController.swift
//  whatAir
//
//  Created by 孙港 on 2017/7/30.
//  Copyright © 2017年 孙港. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion
import CoreData

class ViewController: UIViewController,CLLocationManagerDelegate{
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Thread.sleep(forTimeInterval: 0.5)
        
        //新建滚动视图
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(scrollView)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentOffset = CGPoint(x: self.view.frame.width, y: 0)
        
        let amap = MapUI()
        let cameraUI = CameraUI()
        //let amap = AMap()
        
        //添加Map界面
        self.addChildViewController(amap)
        scrollView.addSubview(amap.view)
        amap.view.frame.origin.x = self.view.frame.width
        
        //添加Camera界面
        self.addChildViewController(cameraUI)
        scrollView.addSubview(cameraUI.view)
        cameraUI.view.frame.origin.x = 0
        
        scrollView.contentSize = CGSize(width: 2 * self.view.frame.width, height: self.view.frame.height)
        
        
        
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

        
       
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        
        getRotationValues()
        
        
        //storePerson(name: "ss",age: 11)
        //storePerson(name: "fff",age: 12)
        //storePerson(name: "ssss",age: 12)
        
        //getPerson()
        
        
        //获取管理的数据上下文 对象
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        //创建User对象
        let user = NSEntityDescription.insertNewObject(forEntityName: "Message",
                                                       into: context) as! Message
        
        //对象赋值
        user.name = "sdf"
        user.content = "hangge"
        user.latitude = 12
        user.longitude = 12

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locations : NSArray = locations as NSArray
        let currentLocation = locations.lastObject as! CLLocation
        let locationStr = "\(currentLocation.coordinate.latitude) \(currentLocation.coordinate.longitude)"
        let altitudeStr = "\(currentLocation.altitude)  "
        locationLabel.text = locationStr
        locationAltitude.text = altitudeStr
        //reverseGeocode(location:currentLocation)
        //locationManager.stopUpdatingLocation()
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
                        
                        var textX = "X: "
                        textX += String(format: "%.4f", rotationValue.x)
                        self.labelX.text = textX
                        var textY = "Y: "
                        textY += String(format: "%.4f", rotationValue.y)
                        self.labelY.text = textY
                        var textZ = "Z: "
                        textZ += String(format: "%.4f", rotationValue.x)
                        self.labelZ.text = textZ
                        //print(self.heading)
                    }
                }
            })
        }
    }
    
    /*func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // 获取某一entity的所有数据
    func getPerson(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            print("numbers of \(searchResults.count)")
            
            for p in (searchResults as! [NSManagedObject]){
                print("name:  \(p.value(forKey: "name")!) age: \(p.value(forKey: "age")!)")
            }
        } catch  {
            print(error)
        }
    }
    
    func storePerson(name:String, age:Int){
        let context = getContext()
        // 定义一个entity，这个entity一定要在xcdatamodeld中做好定义
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: context)
        
        let person = NSManagedObject(entity: entity!, insertInto: context)
        
        person.setValue(name, forKey: "name")
        person.setValue(age, forKey: "age")
        
        do {
            try context.save()
            print("saved")
        }catch{
            print(error)
        }
        
    }*/
    
}



