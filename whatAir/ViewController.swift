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
        
        
        //connectServer()
        //getMessagesFromServer()
                
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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



