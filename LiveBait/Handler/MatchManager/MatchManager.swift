//
//  MatchManager.swift
//  DTF
//
//  Created by maninder on 11/8/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class MatchManager: NSObject {
    
    class var sharedInstance: MatchManager {
        struct Static {
            static let instance: MatchManager = MatchManager()
        }
        
        return Static.instance
    }

    
    
 class   func getFilterSettings(handler:@escaping CompletionHandle)
    {
        SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postMulipartRequest(urlLink: API.API_GetSavedSettings, paramters: nil , Images: [LBImage]()) { (success, response, strError) in
            SwiftLoader.hide()
            if success{
                
              
                let responseDict = response as! [String : Any]
                let settings = MSFilter(dictFilter: responseDict)
                handler(true, settings, nil)
                
            }else
            {
                handler(false, nil, strError)
            }
        }
    }
    
    class  func saveFilterSettings(setting : MSFilter , handler:@escaping CompletionHandle)
    {
        SwiftLoader.show(true)
        var selectedDating  : String = ""
      if  setting.datingType.count > 0
        {
            for item in setting.datingType
            {
                if selectedDating == ""
                {
                    selectedDating =  item.rawValue.description
                }else{
                    selectedDating = selectedDating + "," + item.rawValue.description
                }
            }
        }
        let params : [String : Any] = ["dating": selectedDating , "distance" : setting.distance , "age_from" : setting.minimumAge , "age_to" :setting.maximumAge , "app_sound_vibration" : NSNumber(value: setting.vibration) , "push_notifications" :   NSNumber(value: setting.pushNotification) ]
        HTTPRequest.sharedInstance().postMulipartRequest(urlLink: API.API_SaveFilterSettings, paramters: params , Images: [LBImage]()) { (success, response, strError) in
            SwiftLoader.hide()
            if success{
                handler(true, response, nil)
            }else
            {
                handler(false, nil, strError)
            }
        }
    }
    
    func getLocalUsers(pageNo : Int , handler:@escaping CompletionHandle)
    {
     let dictParams : [String : Any] = ["page" : 1 , "lat" : getLatString() , "lon" : getLongString()  ]
        SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postMulipartRequest(urlLink: API.API_GetUsers, paramters: dictParams, Images: [LBImage]()) { (success, response, strError) in
            SwiftLoader.hide()
                        if success{
                            var arrNewUsers = [User]()
                            let responseDict = response as! [String : Any]
            
                            if let arrayNew = responseDict["record"] as? [Any]
                            {
                                for item in arrayNew
                                {
                                    let newUser = User(userInfo: item)
                                    arrNewUsers.append(newUser)
                                }
                            }
                            handler(true, arrNewUsers, nil)
                        }else
                        {
                            handler(false, nil, strError)
                        }
               }
        }
}
