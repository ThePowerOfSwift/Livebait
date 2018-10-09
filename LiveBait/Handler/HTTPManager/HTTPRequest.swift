//
//  HTTPRequest.swift
//  Kite Flight
//
//  Created by maninder on 5/17/17.
//  Copyright © 2017 Neetika Rana. All rights reserved.
//

import UIKit

//extension String {
//    
//    var sha1: String {
//        guard let data = data(using: .utf8, allowLossyConversion: false) else {
//            // Here you can just return empty string or execute fatalError with some description that this specific string can not be converted to data
//            return ""
//        }
//        return data.digestSHA1.hexString
//    }
//    
//}
//
//fileprivate extension Data {
//    
//    var digestSHA1: Data {
//        var bytes: [UInt8] = Array(repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
//        
//        withUnsafeBytes {
//            _ = CC_SHA1($0, CC_LONG(count), &bytes)
//        }
//        
//        return Data(bytes: bytes)
//    }
//    
//    var hexString: String {
//        return map { String(format: "%02x", UInt8($0)) }.joined()
//    }
//    
//}

typealias CompletionHandle = (_ success: Bool, _ response: Any? , _ error : String?) -> Void


class HTTPRequest: NSObject {

    
    class func sharedInstance() -> HTTPRequest {
        struct Static {
            static let manager = HTTPRequest()
        }
        return Static.manager
    }

    
    
 

    
    func setHeader( apiURL : String ,  manager: AFHTTPSessionManager)
    {
        manager.requestSerializer.setValue( timeStamp , forHTTPHeaderField: "timestamp")
        
      //  1512374761832
        manager.requestSerializer.setValue( "1512374761832" , forHTTPHeaderField: "timestamp")
        manager.requestSerializer.setValue( "0fb0f16c3ae4bdf804e4a0d1f6e28567c483ac45"  , forHTTPHeaderField: "token")
        
        if (LoginManager.sharedInstance.getMeArchiver() != nil)
        {
            manager.requestSerializer.setValue(LoginManager.getMe.sessionID, forHTTPHeaderField: "loginToken")
        }
        
        if userDefaults.value(forKey: "DeviceToken") as? String != nil
        {
            manager.requestSerializer.setValue(userDefaults.value(forKey: "DeviceToken") as? String , forHTTPHeaderField: "DeviceID")
        }else
        {
            manager.requestSerializer.setValue( "SIMULATOR" , forHTTPHeaderField: "DeviceID")
        }

        
        print(manager.requestSerializer.httpRequestHeaders)
    }
    
 
    //MARK:- Creation of Requests
    //MARK:-
    
    func getRequest( urlLink: String, paramters : Dictionary<String ,Any>?, handler:@escaping CompletionHandle)
    {
        let strFinalURL: String = WebURL.URLBaseAddress + urlLink
        let manager = AFHTTPSessionManager()
        self.setHeader(apiURL: urlLink, manager: manager)
        manager.get(strFinalURL, parameters: paramters, success: { (taskSuccess, responseSuccess) in
            guard  let dictResponse = responseSuccess as? Dictionary<String, Any>
                else{
                    handler(false, nil, "NO JSON FORMAT")
                    return
            }
            print("API Response ************************** \(urlLink) + \(dictResponse)")
            
            
            if let statusCode = dictResponse["status"] as? Bool
            {
                if statusCode == true
                {
                    handler(true, dictResponse["data"] as! [String : Any]  , nil)
                }else
                {
                    handler(false, nil, dictResponse["message"] as? String)
                }
            }
            
        }) { (task, error) in
            
         //   let responseData:NSData = (error as NSError).userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData
         //   let str :String = String(data: responseData as Data, encoding: String.Encoding.utf8)!
          //  print("content received : \(str)")
               handler(false, nil, error.localizedDescription)
            
        }
    }
    
    
    
    
func postRequest( urlLink: String, paramters : Dictionary<String ,Any>?, handler:@escaping CompletionHandle)
    {
       let strFinalURL : String = WebURL.URLBaseAddress + urlLink
        let manager = AFHTTPSessionManager()
        self.setHeader(apiURL: urlLink, manager: manager)
          manager.post(strFinalURL, parameters: paramters, success: { (taskSuccess, responseSuccess) in
            
            guard  let dictResponse = responseSuccess as? Dictionary<String, Any>
            else{
                return
            }
            print("API Response ************************** \(urlLink) + \(dictResponse)")
          if let statusCode = dictResponse["status"] as? Bool
          {
                if statusCode == true
                 {
                    handler(true, dictResponse["data"] as! [String : Any]  , nil)
                    
                }else
                {
                    handler(false, nil, dictResponse["message"] as? String)
                }
            }
            
        }) { (task, error) in
            
//            let responseData:NSData = (error as NSError).userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData
//            let str :String = String(data: responseData as Data, encoding: String.Encoding.utf8)!
//            print("content received : \(str)")
            print(error.localizedDescription)
            handler(false, nil, error.localizedDescription)
        }
        
    }
    
    
    func postMulipartRequestProfileImage( urlLink: String, paramters: Dictionary<String ,Any>?,  Images : [LBImage] ,profileImage : LBImage? , handler:@escaping CompletionHandle){
        
        let strFinalURL: String = WebURL.URLBaseAddress + urlLink
        let manager = AFHTTPSessionManager()
        self.setHeader(apiURL: urlLink, manager: manager)
        
        
        var newDict = paramters
        
        if profileImage?.serverImage == true
        {
            newDict!["profile_image"] =  profileImage?.serverString
        }
        
        manager.post(strFinalURL, parameters: newDict, constructingBodyWith: { (formData) in
            
            
            if profileImage?.serverImage == false
            {
                formData.appendPart(withFileData: UIImageJPEGRepresentation((profileImage?.file)! , 0.7)!, name: "profile_image" , fileName: (profileImage?.filename)!, mimeType: (profileImage?.mimeType)!)
            }
            
            if Images.count > 0 {
                var index = 0
                for item in Images
                {
                    let nameNew = "images[\(index)]"
                    formData.appendPart(withFileData: UIImageJPEGRepresentation((item.file)! , 0.7)!, name: nameNew , fileName: item.filename, mimeType: item.mimeType)
                    index = index + 1
                }
            }
        }, success: { (task, responseValue) in
            
            guard  let dictResponse = responseValue as? Dictionary<String, Any>
                else{
                    handler(false, nil, "NO JSON FORMAT")
                    return
            }
            
            print("API Response ************************** \(urlLink) + \(dictResponse)")
            if let statusCode = dictResponse["status"] as? NSNumber
            {
                if statusCode == 1
                {
                    if let  dict = dictResponse["data"] as? [String : Any]
                    {
                        handler(true,  dict  , nil)
                    }else
                    {
                        handler(true, dictResponse["data"] as? [Any]  , nil)
                    }
                    
                }else if statusCode == 0
                {
                    handler(false, nil, dictResponse["message"] as? String)
                }else {
                    getOutOfApp()
                }
            }
            
        }, failure: { (task, error) in
            
            //            let responseData:NSData = (error as NSError).userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData
            //            let str :String = String(data: responseData as Data, encoding: String.Encoding.utf8)!
            //            print("content received : \(str)")
            handler(false, nil, error.localizedDescription)
        })
    }
    
    
    func postMulipartRequest( urlLink: String, paramters: Dictionary<String ,Any>?,  Images : [LBImage] , handler:@escaping CompletionHandle){
        
        let strFinalURL: String = WebURL.URLBaseAddress + urlLink
        print(strFinalURL)
        let manager = AFHTTPSessionManager()
        self.setHeader(apiURL: urlLink, manager: manager)
        manager.post(strFinalURL, parameters: paramters, constructingBodyWith: { (formData) in
           
            if Images.count > 0 {
              // let image = Images[0]
                
                var index = 0
                for item in Images
                {
                    let nameNew = "images[\(index)]"
                    formData.appendPart(withFileData: UIImageJPEGRepresentation((item.file)! , 0.7)!, name: nameNew , fileName: item.filename, mimeType: item.mimeType)
                    index = index + 1
                }
            }
        }, success: { (task, responseValue) in
            
            guard  let dictResponse = responseValue as? Dictionary<String, Any>
            else{
                handler(false, nil, "NO JSON FORMAT")
                    return
            }
            
            print("API Response ************************** \(urlLink) + \(dictResponse)")
            if let statusCode = dictResponse["status"] as? NSNumber
            {
                if statusCode == 1
                {
                    if let  dict = dictResponse["data"] as? [String : Any]
                    {
                        handler(true,  dict  , nil)
                    }else
                    {
                        handler(true, dictResponse["data"] as? [Any]  , nil)
                    }
                    
                }else if statusCode == 0
                {
                    handler(false, nil, dictResponse["message"] as? String)
                }else {
                    getOutOfApp()
                }
            }

        }, failure: { (task, error) in
            
            let responseData:NSData = (error as NSError).userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData
            let str :String = String(data: responseData as Data, encoding: String.Encoding.utf8)!
            print("content received : \(str)")
        
            handler(false, nil, error.localizedDescription)
        })
    }
    func postMulipartRequestOneImage( urlLink: String, paramters: Dictionary<String ,Any>?,  Images : [LBImage] , handler:@escaping CompletionHandle){
        
        let strFinalURL: String = WebURL.URLBaseAddress + urlLink
        let manager = AFHTTPSessionManager()
        self.setHeader(apiURL: urlLink, manager: manager)
        
       
        manager.post(strFinalURL, parameters: paramters, constructingBodyWith: { (formData) in
            
            if Images.count > 0 {
                // let image = Images[0]
                
                var index = 0
                for item in Images
                {
                    let nameNew = "screenshot"
                    formData.appendPart(withFileData: UIImageJPEGRepresentation((item.file)! , 0.7)!, name: nameNew , fileName: item.filename, mimeType: item.mimeType)
                    index = index + 1
                }
            }
        }, success: { (task, responseValue) in
            
            guard  let dictResponse = responseValue as? Dictionary<String, Any>
                else{
                    handler(false, nil, "NO JSON FORMAT")
                    return
            }
            
            print("API Response ************************** \(urlLink) + \(dictResponse)")
            if let statusCode = dictResponse["status"] as? NSNumber
            {
                if statusCode == 1
                {
                    if let  dict = dictResponse["data"] as? [String : Any]
                    {
                        handler(true,  dict  , nil)
                    }else
                    {
                        handler(true, dictResponse["data"] as? [Any]  , nil)
                    }
                    
                }else if statusCode == 0
                {
                    handler(false, nil, dictResponse["message"] as? String)
                }else {
                    getOutOfApp()
                }
            }
            
        }, failure: { (task, error) in
            
            //            let responseData:NSData = (error as NSError).userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData
            //            let str :String = String(data: responseData as Data, encoding: String.Encoding.utf8)!
            //            print("content received : \(str)")
            handler(false, nil, error.localizedDescription)
        })
    }
    
    func checkSessionExpired(dictResponse : Dictionary<String, Any>)
    {
        if let statusCode = dictResponse["status_code"] as? NSNumber
        {
            if statusCode == 203
            {
                getOutOfApp()
                return
            }
        }
    }
 }



