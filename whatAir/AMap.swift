//
//  AMap.swift
//  whatAir
//
//  Created by 孙港 on 2017/8/20.
//  Copyright © 2017年 孙港. All rights reserved.
//

import UIKit

let APIKey = "8a6509c1ec94d0b7c3791bed23db2f0e"

class AMap: UIViewController, MAMapViewDelegate{

    var mapView:MAMapView?
    override func viewDidLoad() {
        super.viewDidLoad()

        // 配置用户Key
        AMapServices.shared().apiKey = APIKey
        initMapView()

        let imageView = UIImageView(image:UIImage(named:"1234"))
        imageView.frame = CGRect(x:0, y:0, width:self.view.bounds.width, height:self.view.bounds.height)
        self.view.addSubview(imageView)
        
        // Do any additional setup after loading the view.
    }

    func initMapView(){
        
        mapView = MAMapView(frame: self.view.bounds)
        mapView?.delegate = self
        
        let compassX = mapView?.compassOrigin.x
        
        let scaleX = mapView?.scaleOrigin.x

        //设置指南针和比例尺的位置
        mapView?.compassOrigin = CGPoint(x:compassX!,y:40)
        
        mapView?.scaleOrigin = CGPoint(x: scaleX!,y: 21)
        
        mapView?.showsCompass = true
        mapView?.showsScale = false
        
        mapView?.zoomLevel = 18
        
        // 开启定位
        mapView!.showsUserLocation = true
        
        // 设置跟随定位模式，将定位点设置成地图中心点
        mapView!.userTrackingMode = MAUserTrackingMode.follow
      
        self.view.addSubview(mapView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
