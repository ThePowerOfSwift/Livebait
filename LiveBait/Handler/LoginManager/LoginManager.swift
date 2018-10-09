//
//  LoginManager.swift
//  Kite Flight
//
//  Created by maninder on 5/16/17.
//  Copyright © 2017 Neetika Rana. All rights reserved.
//

import UIKit

enum EntryType : String
{
    
    case Manual = "Manual"
    case Facebook = "Facebook"
    case Google = "Google"
    
}


enum CallResult : Int
{
    case Accepted = 1
    case Rejected = 2
    case NoAnswer = 4
    
}

typealias CompletionResultHandler = (_ success: Bool, _ response: Any? , _ error : String?) -> Void


class LoginManager: NSObject {
   
    fileprivate var me: User! = User()
    
    class var getMe: User {
        return LoginManager.sharedInstance.me
    }
    
    class func setMe( user : User)
    {
         LoginManager.sharedInstance.me = user
    }
    
 
    
    override init() {
        super.init()
        let me = self.getMeArchiver()
        if (me == nil) {
            self.me = User()
        }else{
            self.me = me
        }
    }
    
    /**
     Returns the default singleton instance.
     */
    
    class var sharedInstance: LoginManager {
        struct Static {
            
            static let instance: LoginManager = LoginManager()
            
        }
        return Static.instance
    }
    
    //MARK:- Register API
    //MARK:-
    
    
    func registerFB( handler:@escaping CompletionHandle)
    {
        var deviceToken : String = "simulator"
        if userDefaults.value(forKey: "DeviceToken") as? String != nil
        {
            deviceToken = userDefaults.value(forKey: "DeviceToken") as! String
        }
        SwiftLoader.show(true)
        let   params : [String: Any] = ["email" : self.me.email , "name" : self.me.fullName , "isMobileVerified" : 0 , "deviceType" : DeviceType , "deviceToken" : deviceToken , "fb_id" : self.me.fbID, "profile_url":self.me.profile_url]
        HTTPRequest.sharedInstance().postMulipartRequest(urlLink: API.API_SignUP, paramters: params, Images: []) { (success, response, strError) in
              SwiftLoader.hide()
            if success
            {
                if let responseDict = response as? [String : Any]
                {
                    self.me = User(myLoginInfo: responseDict)
                    
                    if self.me.profileImageURL != ""
                    {
                        self.me.profileImage = LBImage(link: self.me.profileImageURL)
                        
                    }else{
                      let imgeURL =  "http://graph.facebook.com/\(self.me.fbID)/picture?type=large"
                        self.me.profileImage = LBImage(link: imgeURL)
                    }
                     self.saveUserProfile()
                    if self.me.quickBloxID == ""
                    {
                        self.createQBUser()
                    }else{
                        appDelegate().connectWithUserID()
                            self.saveSubscription()
                    }
                   
                }
                handler(true, self.me, nil)
            }else{
                handler(false, nil, strError)
            }
        }
    }
    
    
    
    
    
    func shareContactNumber( user : User , handler:@escaping CompletionHandle)
    {
        let   params : [String: Any] = ["user_id" : user.userID , "type" : "1" ]
             SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postMulipartRequest(urlLink: API.API_SharingInfo, paramters: params, Images: []) { (success, response, strError) in
            SwiftLoader.hide()
            if success
            {
                handler(true, nil, nil)

            }else{
                handler(false, nil, strError)
            }
        }
    }
    
    
    func shareLocation( address : Location , user : User , handler:@escaping CompletionHandle)
    {
        SwiftLoader.show(true)
        let   params : [String: Any] = ["user_id" : user.userID , "type" : "2"  , "address" : address.locationName , "lat" :   address.latitude , "lon" : address.longitude]
        print(params)
        HTTPRequest.sharedInstance().postMulipartRequest(urlLink: API.API_SharingInfo, paramters: params, Images: []) { (success, response, strError) in
            SwiftLoader.hide()
            if success
            {
                 handler(true, nil, nil)
             }else{
                handler(false, nil, strError)
            }
        }
    }
    
    
    
    
    
    func getGeneralInfo(type : Int ,  handler:@escaping CompletionHandle)
    {
              let   params : [String: Any] = ["type" : type ]
         SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postMulipartRequest(urlLink: API.API_GeneralInfo, paramters: params, Images: []) { (success, response, strError) in
            SwiftLoader.hide()
            if success
            {
                
                if let dictFull = response as? [String : Any]
                {
                    
                    let response = dictFull["content"] as! String
                    handler(true, response, nil)
                   }
               
            }else{
                handler(false, nil, strError)
            }
        }
    }
    
    
    func getReceiverID(status : CallStatus , duration : Int )
    {
            let sessionID = appDelegate().activeCall.activeSession.id
              let   params : [String: Any] = ["quickblox_id" : sessionID , "status" : status.rawValue  , "duration" : duration ]
            HTTPRequest.sharedInstance().postMulipartRequest(urlLink: API.API_SaveCallStatus , paramters: params, Images: []) { (success, response, strError) in
                if success
                {
                    if let responseDict = response as? [String : Any]
                    {
                        //  handler(true, self.me, nil)
                    }
                }
            }
    }
    
    func getMyInfo(handler:@escaping CompletionHandle)
    {
        HTTPRequest.sharedInstance().postMulipartRequest(urlLink: API.API_GetProfile , paramters: nil, Images: []) { (success, response, strError) in
            if success
            {
                if let responseDict = response as? [String : Any]
                {
                    self.me.updateCalls(myLoginInfo: responseDict)
                    self.saveUserProfile()
                    handler(true, self.me, nil)
                }
            }
         }
   }

    func getNotifications(  handler:@escaping CompletionHandle)
    {
        SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postMulipartRequest(urlLink: API.API_GetNotification, paramters: nil, Images: []) { (success, response, strError) in
            SwiftLoader.hide()
            if success
            {
                var arrNotifications : [LBNotification] = [LBNotification]()
                if let responseArray = response as? [ Any]
                {
                    for item in responseArray
                    {
                        let notification = LBNotification(notificationInfo: item as! [String : Any])
                        arrNotifications.append(notification)
                    }
                    handler(true, arrNotifications, nil)
                }
            }else{
                handler(false, nil, strError)
            }
        }
    }
    
    
    func setNotInterested ( userID : String , handler:@escaping CompletionHandle )
    {
        SwiftLoader.show(true)
        let   params : [String: Any] = ["user_id" : userID ]
        HTTPRequest.sharedInstance().postMulipartRequest(urlLink: API.API_NotInterested, paramters: params , Images: []) { (success, response, strError) in
            SwiftLoader.hide()
            if success
            {
               handler(true, nil, nil)
            }else{
                handler(false, nil, strError)
            }
        }
        
        
    }
    
    func reportUserWithScreenShot(userSecond : User , image : LBImage , handler:@escaping CompletionHandle )
    {
        SwiftLoader.show(true)
          let   params : [String: Any] = ["user_id" : userSecond.userID]
        
        HTTPRequest.sharedInstance().postMulipartRequestOneImage(urlLink: API.API_ReportUser, paramters: params, Images: [image]) { (success, response, strError) in
              SwiftLoader.hide()
            if success
            {
                handler(true, nil, nil)
            }else{
                handler(false, nil, strError)
            }
            
        }
    }
    
    
    
    
    func saveTransactionDetails( handler:@escaping CompletionHandle )
    {
        let   params : [String: Any] = [String: Any]()

        HTTPRequest.sharedInstance().postMulipartRequestOneImage(urlLink: API.API_SaveSubscription, paramters: params, Images: []) { (success, response, strError) in
            SwiftLoader.hide()
        }
        
    }
    
    
    func createQBUser()
    {
        let qbUser = QBUUser()
        qbUser.login = "facebook_" + self.me.fbID
           // qbUser.email = "tester@mailinator.com"
        qbUser.fullName = self.me.fullName
        qbUser.password = QBDetails.QBPassword
        QBRequest.signUp( qbUser , successBlock: { (response, userCreated) in
            self.me.quickBloxID = userCreated.id.description
            self.saveQuikbloxID(quickbloxID:  self.me.quickBloxID)
            self.saveSubscription()
            self.saveUserProfile()
            self.saveProfile(user: self.me, handler: { (success, response, strError) in
                
            })
            appDelegate().connectWithUserID()
        }) { (responseResult) in
            
        }
    }
    
    
    func saveSubscription()
    {
        let subscription = QBMSubscription()
        subscription.devicePlatform = "ios"
        subscription.deviceToken = userDefaults.value(forKey: LocalKeys.DeviceTokenData.rawValue) as? Data
        subscription.notificationChannel = .APNS
        subscription.deviceUDID = deviceUniqueIdentifier()
        QBRequest.createSubscription(subscription, successBlock: { (response, subscriptionError) in
            print(subscriptionError)

        }) { (response) in
            
        }
    }
    
    func removeSubscription()
    {
        if self.me.quickBloxID != "" {
            QBRequest.deleteSubscription(withID: UInt(self.me.quickBloxID)!, successBlock: { (response) in
                
            }) { (response) in
                
            }
        }
        
    }
    
    
    func saveQuikbloxID(quickbloxID : String)
    {
        let   params : [String: Any] = [ "quickblox_id" : self.me.quickBloxID ]
        HTTPRequest.sharedInstance().postMulipartRequest(urlLink: API.API_UpdateProfile, paramters: params, Images: [LBImage]()) { (success, response, strError) in
            if success
            {

            }
        }
    }
    
    func saveProfile( user: User , handler:@escaping CompletionHandle)
    {
        SwiftLoader.show(true)
        let newImages = user.userImages.filter { $0.serverImage == false }
        let previousImages = user.userImages.filter { $0.serverImage == true }
        let arrayLast : [String] = previousImages.map{ $0.serverString }
        let joinedStr = arrayLast.joined(separator: ",")
        var verified = 0
    
        if user.mobileVerified == true
        {
            verified = 1
        }

        let   params : [String: Any] = ["email" : user.email , "name" : user.fullName , "username"  :  self.me.userName , "isMobileVerified" : verified , "sex" : user.genderType.rawValue , "occupation" : user.occupation , "drink" : user.drinkStatus.rawValue , "smoke" :  user.smokeStatus.rawValue , "nature" : user.natureStatus.rawValue  , "kids" : user.kidStatus.rawValue , "received_video_chat" : user.videoRequest.rawValue , "heading" : user.aboutInfo , "previous_images" : joinedStr  , "account_status" : user.accountStatus.rawValue , "quickblox_id" : self.me.quickBloxID , "country_code" : user.countryCode , "phone_number" : user.phoneNumber , "age" : user.age]
        
        print(params)
        
     
        HTTPRequest.sharedInstance().postMulipartRequestProfileImage(urlLink: API.API_UpdateProfile, paramters: params, Images: newImages , profileImage: user.profileImage) { (success, response, strError) in
            
          SwiftLoader.hide()
            if success
            {
               if let responseDict = response as? [String : Any]
                {
                    self.me = User(myLoginInfo: responseDict)
                    self.me.alreadyRegistered = true
                    appDelegate().connectWithUserID()
                    self.saveUserProfile()
                }
                handler(true, self.me, nil)
            }else{
                handler(false, nil, strError)
            }
        }
    }
    
    
    
    func saveFeedBack(feedbackString : String ,  handler:@escaping CompletionHandle)
    {
        let   params : [String: Any] = ["message" : feedbackString ]
        SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postMulipartRequest(urlLink: API.API_SaveFeedBack, paramters: params, Images: []) { (success, response, strError) in
            SwiftLoader.hide()
            if success
            {
               
                
//                if let dictFull = response as? [String : Any]
//                {
////                    let response = dictFull["content"] as! String
                    handler(true, response, nil)
               // }
                
            }else{
                handler(false, nil, strError)
            }
        }
    }
    
   
    func logout(handler:@escaping CompletionHandle)
    {
        SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postMulipartRequest(urlLink: API.API_Logout, paramters: nil, Images: [LBImage]()) { (success, response, strError) in
            SwiftLoader.hide()
            if success
            {
                handler(true, response, nil)
            }else{
                handler(false, nil, strError)
            }
        }
    }
    
  
    
    //MARK:- User default functions
    //MARK:-
    
    func saveUserProfile()
    {
        let data = NSKeyedArchiver.archivedData(withRootObject: self.me)
        UserDefaults.standard.set(data, forKey: "User")
        UserDefaults.standard.synchronize()
    }
    
    func removeUserProfile(){
        UserDefaults.standard.set(nil, forKey: "User")
        UserDefaults.standard.synchronize()
        self.me = User()
    }
    
    func getMeArchiver() -> User? {
     if let data = UserDefaults.standard.object(forKey: "User") as? Data {
            let me = NSKeyedUnarchiver.unarchiveObject(with: data)
            return me as? User
        }else{
            return nil
        }
    }
}
