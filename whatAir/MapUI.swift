//
//  MapUI.swift
//  whatAir
//
//  Created by 孙港 on 2017/7/30.
//  Copyright © 2017年 孙港. All rights reserved.
//

import UIKit
import CoreData

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l <= r
    default:
        return !(rhs < lhs)
    }
}

protocol MapUIDelegate{
    func sendAction(_ text:String)
}

// 高德地图key
let APIKey1 = "8a6509c1ec94d0b7c3791bed23db2f0e"

class MapUI: UIViewController, MAMapViewDelegate{
    
    let textViewHeight:CGFloat = 36

    let sendButtonWidth:CGFloat = 60
    
    var currentY:CGFloat = 10
    // 记录一大波默认参数 用于计算
    fileprivate let buttonW:CGFloat = 57
    fileprivate let textViewX:CGFloat = 1
    fileprivate let textViewY:CGFloat = 1
    fileprivate var textViewH:CGFloat = 30
    fileprivate var textViewRect:CGRect!
    fileprivate var textViewW:CGFloat = 0
    fileprivate let buttonTitle = "发 送"
    fileprivate var selfFrame:CGRect!
    fileprivate var selfDefultHight:CGFloat!
    fileprivate var isShowing:Bool = false
    
    // 控件
    //fileprivate var backgroundView:UIView! // textView背景View
    var textView:UITextView!// 输入框
    var sendButton:UIButton!// 确认按钮
    var delegate:MapUIDelegate?
    
    var mapView:MAMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 配置用户Key
        AMapServices.shared().apiKey = APIKey
        initMapView()
        
        let imageView = UIImageView(image:UIImage(named:"1234"))
        imageView.frame = CGRect(x:0, y:0, width:self.view.bounds.width, height:self.view.bounds.height)
        self.view.addSubview(imageView)
        
        let height = self.view.frame.height
        let width = self.view.frame.width
        
        //let textview = UITextView(frame:CGRect(x:width / 12, y:height - 80, width:5 * width / 6, height:60))
        //textview.font = UIFont.systemFont(ofSize: 20)
        //textview.layer.borderWidth = 1  //边框粗细
        //textview.layer.cornerRadius = 16
        //textview.layer.borderColor = UIColor.gray.cgColor //.gray.cgColor //边框颜色
        //self.view.addSubview(textview)
        
        // 记录默认属性
        isShowing = true
        selfDefultHight = self.view.frame.size.height
        textViewW = UIScreen.main.bounds.size.width - buttonW - 30
        //self.view.backgroundColor = UIColor.init(colorLiteralRed: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1)
        textViewRect = CGRect(x: textViewX, y: textViewY, width: textViewW, height: textViewH)
        selfFrame = self.view.frame
       
        
        // 创建输入框
        textView = UITextView(frame:CGRect(x: 10, y:height - textViewHeight - 10, width: width - 20 - 60 - 10,height: textViewHeight))
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.black
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.cornerRadius = 5;
        textView.layer.masksToBounds = true
        
        textView.autoresizingMask = UIViewAutoresizing.flexibleHeight
        textView.contentInset = UIEdgeInsetsMake(1, 1, 0, 0)
        textView.showsHorizontalScrollIndicator = true
        
        //textView.textContainerInset = UIEdgeInsetsMake(3, 0, 3, 0)
        //textView.textContainer.lineFragmentPadding = 0
       
        //textView.automaticallyAdjustsScrollViewInsets = NO
        
        
        self.view.addSubview(textView)
        
        // 创建背景View
        //self.backgroundView = UIView(frame: CGRect(x: 10,y: height - textViewH - 10,width: textViewW+2,height: 32))
        //backgroundView.backgroundColor = UIColor.init(colorLiteralRed: 250/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1)
        //self.view.addSubview(backgroundView)
        //backgroundView.addSubview(textView)
        
        // 创建按钮
        sendButton = UIButton(type: UIButtonType.system)
        sendButton.setTitle(buttonTitle, for: UIControlState())
        sendButton.layer.cornerRadius = 8
        sendButton.frame = CGRect(x: width - 60 - 10, y: height - textViewHeight - 10, width: 60, height: 36)
        //sendButton.setImage(UIImage(named:"button"), for: UIControlState.normal)
        sendButton.backgroundColor = UIColor.init(colorLiteralRed: 59/255.0, green: 151/255.0, blue: 247/255.0, alpha: 1)
        sendButton.tintColor = UIColor.white
        sendButton.addTarget(self, action: #selector(MapUI.sendAction), for: UIControlEvents.touchUpInside)
        self.view.addSubview(sendButton)
        
        // 切圆角
        
        //backgroundView.layer.masksToBounds = true
        //backgroundView.layer.cornerRadius = 5;
        
        // 注册通知
        registNotification()


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
        
        
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        //声明数据的请求
        let fetchRequest = NSFetchRequest<Message>(entityName:"Message")
        //查询操作
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            
            //遍历查询的结果
            for info in fetchedObjects{
                let pointAnnotation = MAPointAnnotation()
                pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: info.latitude, longitude: info.longitude)
                pointAnnotation.title = info.name
                pointAnnotation.subtitle = info.content
                mapView!.addAnnotation(pointAnnotation)
            }
        }
        catch {
            fatalError("不能保存：\(error)")
        }
        
        
   
        /*let pointAnnotation = MAPointAnnotation()
        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: 30.536353, longitude: 114.359372)
        pointAnnotation.title = "sdfs"
        pointAnnotation.subtitle = "sssssssssss"
        mapView!.addAnnotation(pointAnnotation)*/

        

        self.view.addSubview(mapView!)
    }
    
    @objc(mapView:viewForAnnotation:) func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
            
            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView!.image = UIImage(named: "point")
            
            annotationView!.autoresizesSubviews = true
            annotationView!.canShowCallout = true
            //annotationView!.self.image = UIImage(named: "self")
            //annotationView!.translatesAutoresizingMaskIntoConstraints = true
            
            //设置中心点偏移，使得标注底部中间点成为经纬度对应点
            annotationView!.centerOffset = CGPoint(x:0, y:-18);
            
            return annotationView!
        }
        
        return nil
    }
    
    // 将要出现
    func keyboardWillShow(_ notification:Notification){
        isShowing = true
        // 通知传参
        let userInfo  = notification.userInfo
        // 取出键盘bounds
        let  keyBoardBounds = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        // 时间
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        // 动画模式
        let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
        // 偏移量
        let deltaY = keyBoardBounds.size.height
        // 动画
        let animations:(() -> Void) = {
            self.view.transform = CGAffineTransform(translationX: 0,y: -deltaY)
            self.textView.text = ""
            self.textView.textColor = UIColor.black
        }
        // 判断是否需要动画
        if duration > 0 {
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            
            animations()
        }
        currentY = textView.frame.origin.y
    }
    
    // 将要收起
    func keyboardWillHid(_ notification:Notification){
        isShowing = false
        let userInfo  = notification.userInfo
        
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animations:(() -> Void) = {
            self.view.transform = CGAffineTransform.identity
            
            self.textView.frame = CGRect(x: 10, y:self.view.frame.height - self.textViewHeight - 10, width: self.view.frame.width - 20 - 60 - 10,height: self.textViewHeight)
            //self.backgroundView.frame = CGRect(x: 10,y: self.view.frame.height - 40,width: self.textViewW+2,height: 32)
            
            self.textView.textColor = UIColor.lightGray
            
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
        currentY = textView.frame.origin.y
    }
    
    // 将要改变
    func keyboardWillChange(_ notification:Notification){
        let contentSize = self.textView.contentSize
        //print(contentSize.height)
        if contentSize.height > 140{
            //print(contentSize.height)
            return;
        }
        var selfframe = self.view.frame
        // selfHight的计算我也不太清楚 等大神解答..
        var selfHeight = (self.textView.superview?.frame.origin.y)! * 2 + contentSize.height
        if selfHeight <= selfDefultHight {
            selfHeight = selfDefultHight
        }
        let selfOriginY = selfframe.origin.y - (selfHeight - selfframe.size.height)
        selfframe.origin.y  = selfOriginY;
        selfframe.size.height = selfHeight;
        self.view.frame = selfframe;
        
        
        //self.textView.contentInset = UIEdgeInsetsMake(-1, 1, 0, 0)
        
        self.textView.frame = CGRect(x: 10, y:currentY - contentSize.height + 36, width: self.view.frame.width - 20 - 60 - 10,height: contentSize.height )

        
        self.textView.scrollRangeToVisible(NSRange(location: -1,length: 0))
        
        //print(self.textView.textContainer.lineFragmentPadding)
        //print(self.textView.textContainerInset.top)
        //print(self.textView.textContainerInset.bottom)
        //        //self.backgroundView.frame = CGRect(x: 10, y: self.view.frame.height - 40, width: textViewW+2, height: selfHeight-18);
    }
    
    // click button to storage a message
    func sendAction(){
        //self.keyboardWillHid(<#T##notification: Notification##Notification#>)
        storeMessage(messageContent: self.textView.text)
        if (isShowing){
            if self.textView.text.characters.count == 0 {
                print("评论为空")
            }else{
                self.textView.resignFirstResponder()
                delegate?.sendAction(self.textView.text)
                print(self.textView.text)
                self.textView.text = "我有话说"
            }
        }else{
            self.textView.becomeFirstResponder()
        }
    
    }
    
    
    // 注册通知
    func registNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(MapUI.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapUI.keyboardWillHid(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapUI.keyboardWillChange(_:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }

}
