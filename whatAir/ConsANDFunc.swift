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
public var selfLatitude_Double:Double! //当前维度
public var selfLongitude_Double:Double! //当前经度

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
