//
//  ConsANDFunc.swift
//  whatAir
//
//  Created by 孙港 on 2017/8/26.
//  Copyright © 2017年 孙港. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreData

//Constant
public let SCREENWIDTH = UIScreen.self().bounds.width //屏幕宽度
public let SCREENHEIGHT = UIScreen.self().bounds.height // 屏幕高度
public let USERNAME:String = "孙港"

//Variable
public var selfLatitude_Double:Double = 0 //当前维度 角度
public var selfLongitude_Double:Double = 0 //当前经度 角度
public var selfXRotation_Double:Double = 0 //0-1
public var selfYRotation_Double:Double = 0 //0-1
public var selfZRotation_Double:Double = 0 //0-1
public var selfDirection_Double:Double = 0 //0-360 角度

//Function
public func getHorizonalDistance(selfLocation:CLLocation, messageLocation:CLLocation)->Double{
    let tempLocation = CLLocation(latitude: selfLocation.coordinate.latitude, longitude: messageLocation.coordinate.longitude)
    let distance:CLLocationDistance = selfLocation.distance(from: tempLocation)
    
    if messageLocation.coordinate.longitude > selfLocation.coordinate.longitude{
        return distance
    }
    else{
        return -distance
    }
}
public func getVerticalDistance(selfLocation:CLLocation, messageLocation:CLLocation)->Double{
    let tempLocation = CLLocation(latitude: messageLocation.coordinate.latitude, longitude: selfLocation.coordinate.longitude)
    let distance:CLLocationDistance = selfLocation.distance(from: tempLocation)
    if messageLocation.coordinate.latitude > selfLocation.coordinate.latitude{
        return distance
    }
    else{
        return -distance
    }
}

/*
 *function: stroeMessage
 *author: sungang
 *date: 2017/08/31
 */
public func storeMessage(messageContent:String){
    let app = UIApplication.shared.delegate as! AppDelegate
    let context = app.persistentContainer.viewContext
    
    //创建User对象
    let user = NSEntityDescription.insertNewObject(forEntityName: "Message",
                                                   into: context) as! Message
    
    //对象赋值
    user.name = USERNAME
    user.content = messageContent
    user.latitude = selfLatitude_Double
    user.longitude = selfLongitude_Double
    
    //保存
    do {
        try context.save()
        print("保存成功！")
    } catch {
        fatalError("不能保存：\(error)")
    }

}

/*
 *function: searchMessage
 *author: sungang
 *date: 2017/08/31
 */
public func searchMessage(){
    let app = UIApplication.shared.delegate as! AppDelegate
    let context = app.persistentContainer.viewContext
    
    //声明数据的请求
    let fetchRequest = NSFetchRequest<Message>(entityName:"Message")
    //fetchRequest.fetchLimit = 10 //限定查询结果的数量
    //fetchRequest.fetchOffset = 0 //查询的偏移量
    
    //设置查询条件
    //let predicate = NSPredicate(format: "id= '1' ", "")
    //fetchRequest.predicate = predicate
    
    //查询操作
    do {
        let fetchedObjects = try context.fetch(fetchRequest)
        
        //遍历查询的结果
        for info in fetchedObjects{
            print("name=\(String(describing: info.name))")
            print("content=\(String(describing: info.content))")
            print("latitude=\(info.latitude)")
            print("longitude=\(info.longitude)")
        }
    }
    catch {
        fatalError("不能保存：\(error)")
    }
}
/*public func getViewContext () -> NSManagedObjectContext {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.persistentContainer.viewContext
}
public func storeMessage(messageContent:String){
    let viewContext = getViewContext()
    let entity = NSEntityDescription.entity(forEntityName: "Message", in: viewContext)
    
    let message = NSManagedObject(entity: entity!, insertInto: viewContext)
    
    message.setValue(name, forKey: USERNAME)
    message.setValue(content, forKey: messageContent)
    message.setValue(latitude, forKey: selfLatitude_Double)
    message.setValue(longitude, forKey: selfLongitude_Double)
    
    do {
        try viewContext.save()
        print("saved")
    }catch{
        print(error)
    }
}*/
