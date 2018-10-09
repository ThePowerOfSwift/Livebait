//
//  LBNotification.swift
//  LiveBait
//
//  Created by maninder on 2/13/18.
//  Copyright © 2018 Maninderjit Singh. All rights reserved.
//


enum NotificationType : Int
{
    case ContactShared = 1
    case LocationShared = 2
    case ReportRegistered = 3
    
}


import UIKit

class LBNotification: NSObject {
    
    var sender : User!
    var notificationType : NotificationType = .LocationShared
    var  locationDetails : Location!
    var  phoneDetails : String!
    var  reportDetails : String = ""

    var notificationMessage : String = ""
    
    override init() {
        
    }
    convenience init(notificationInfo : [String : Any]) {
        self.init()

        
        // print(notificationInfo["type"] )
        
        if let type = notificationInfo["type"]  as? NSNumber
        {
            self.notificationType = NotificationType(rawValue: type.intValue)!
        }else{
            
            let typeString  =    notificationInfo["type"]  as! String
            self.notificationType = NotificationType(rawValue: Int(typeString)!)!
        }
        
        let requestDict =    notificationInfo["request_data"]  as! [String : Any]
       
        self.notificationMessage = requestDict["message"]  as! String
        if self.notificationType == .LocationShared
        {
            let lat = Double( requestDict["lat"]  as! String)
            let long =   Double( requestDict["lon"]  as! String)
            //Double(String(describing: requestDict["lon"] ))
            let locationName = requestDict["address"] as! String
            self.locationDetails = Location(latitude: lat!, longitude: long!, locationName: locationName)
        }else if  self.notificationType == .ContactShared{
           phoneDetails = requestDict["phone_number"] as! String
        }else{
            
            self.reportDetails = requestDict["screenshot"] as! String
        }
        
        self.sender = User(userInfo: notificationInfo["sender"] as! Dictionary<String ,Any>)
    }
}
