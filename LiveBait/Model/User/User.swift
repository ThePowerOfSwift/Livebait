//
//  User.swift

//
//  Created by maninder on 5/16/17.
//  Copyright © 2017 Neetika Rana. All rights reserved.
//

import UIKit



enum ProfileStatus : String
{
    case Pending = "Pending"
    case Active = "Active"
}


let appLastLoginFormat = DateFormatter()
class User: NSObject,NSCoding
{
    
    
    
//    subscribed = 0;
//    timezone = "";
//    "unpaid_calls" = 0;
    
    
    var userID : String = ""
    var sessionID : String = ""
    var fbID : String = ""
    var email : String = ""
    var fullName : String = ""
    var userName : String = ""
    var profile_url: String = ""
    var occupation : String = ""
    var genderType : GenderType = .GenderMale
    var age : Int = 18
    var countryCode : String = ""
    var phoneNumber : String = ""
    var mobileVerified : Bool = false
    var alreadyRegistered : Bool = false
    var unPaidCalls : Int = 0
    var paidCalls : Int = 0
    var unlimitedChatsTill = ""
    var monthlySubscribed = ""
    var drinkStatus : DrinkStatus = .Yes
   
    var smokeStatus : SmokeStatus = .Yes
    var natureStatus : NatureStatus = .Friendly
    var kidStatus : KidsStatus = .No
    var accountStatus : AccountStatus = .Free
    var videoRequest : VideoRequestStatus = .Yes
    var  userStatus : UserStatus = .Active
  
    var userImages : [LBImage] = [LBImage]()
    
    var profileImageURL : String = ""

    var aboutInfo : String = ""
    var quickBloxID : String = ""

    var userDistance : Double = 0.0
    var filterSettings : MSFilter? = nil
    var qbUser : QBUUser?
    
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    
    var profileImage : LBImage?

    
    override init()
    {
        
        
        
        
    }
    
    
  

    
   
    
    
    convenience init(myLoginInfo : [String: Any]) {
        self.init()
        
        
        self.sessionID = myLoginInfo["loginToken"] as! String
        
        
        if let alreadyRegister = myLoginInfo["already_register"] as? Bool
        {
            self.alreadyRegistered  = alreadyRegister
        }
        
        self.accountStatus = AccountStatus(rawValue: myLoginInfo["account_status"] as! Int)!
         self.age  =  myLoginInfo["age"] as! Int
        self.drinkStatus = DrinkStatus(rawValue: myLoginInfo["drink"] as! Int)!
          self.email =  myLoginInfo["email"] as! String
        self.fbID = myLoginInfo["fb_id"] as! String
        self.quickBloxID = myLoginInfo["quickblox_id"] as! String
        self.aboutInfo = myLoginInfo["heading"] as! String
        self.userID =  (myLoginInfo["id"] as! NSNumber).description
        self.kidStatus = KidsStatus(rawValue: myLoginInfo["kids"] as! Int)!
        self.fullName = myLoginInfo["name"] as! String
        self.natureStatus = NatureStatus(rawValue: myLoginInfo["nature"] as! Int)!
        self.occupation = myLoginInfo["occupation"] as! String
        self.phoneNumber = myLoginInfo["phone_number"] as! String
        self.countryCode = myLoginInfo["country_code"] as! String
        self.videoRequest = VideoRequestStatus(rawValue: myLoginInfo["received_video_chat"] as! Int)!
        self.genderType = GenderType(rawValue: myLoginInfo["sex"] as! Int)!
        self.smokeStatus = SmokeStatus(rawValue: myLoginInfo["smoke"] as! Int)!
        self.userName = myLoginInfo["username"] as! String
        self.profileImageURL = myLoginInfo["profile_image"] as! String
        self.profile_url = myLoginInfo["profile_url"] as! String
        
        
        
        self.paidCalls =  (myLoginInfo["paid_calls"] as! NSNumber).intValue
        self.unPaidCalls = (myLoginInfo["unpaid_calls"] as! NSNumber).intValue
        self.monthlySubscribed = myLoginInfo["subscribed"] as! String
        if myLoginInfo["unlimited_till"] as? String != nil {
            self.unlimitedChatsTill = myLoginInfo["unlimited_till"] as! String
        }
        
        if let arrLinks =   myLoginInfo["images"] as? [String]
        {
            self.userImages.removeAll()
            
            if (self.profileImageURL != "")
            {
                let imgProfilePic = LBImage(link: self.profileImageURL)
                self.userImages.append(imgProfilePic)
            }
            
            for link in arrLinks
            {
                if link != ""
                {
                    let imageServer = LBImage(link: link)
                    self.userImages.append(imageServer)
                }
            }
        }
        
        if self.profileImageURL != ""
        {
            self.profileImage = LBImage(link: self.profileImageURL)
        }
   }
    
    
    
    func updateCalls( myLoginInfo : [String: Any])
    {
      //  paid_calls
        self.unPaidCalls = (myLoginInfo["unpaid_calls"] as! NSNumber).intValue
        self.accountStatus = AccountStatus(rawValue: myLoginInfo["account_status"] as! Int)!
        self.paidCalls =  (myLoginInfo["paid_calls"] as! NSNumber).intValue
        self.monthlySubscribed = myLoginInfo["subscribed"] as! String
        if myLoginInfo["unlimited_till"] as? String != nil {
            self.unlimitedChatsTill = myLoginInfo["unlimited_till"] as! String
        }
    }
    
    
    convenience init(userCaller : Dictionary<String, Any>) {
        self.init()
        print(userCaller)
        if let numberID = userCaller["id"] as? NSNumber
        {
            self.quickBloxID = numberID.description
        }else{
            self.quickBloxID = userCaller["id"] as! String
        }
        self.fullName = userCaller["full_name"] as! String
        if let strCustomDict = userCaller["custom_data"] as? String
        {
            let jsonData = strCustomDict.data(using: .utf8)
            let dictionary  = try? JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments)
            
            let userInfo = dictionary as! Dictionary<String, Any>
            self.fbID = userInfo["fb_id"] as! String
            self.profileImageURL = userInfo["image"] as! String
            
            
            if let latSTring = userInfo["lat"] as? String
            {
                self.latitude = Double(latSTring)!
                
            }else if let latdouble = userInfo["lat"] as? Double
            {
                self.latitude = latdouble
            }
            
            
            if let lonString = userInfo["lon"] as? String
            {
                self.longitude = Double(lonString)!
                
            }else if let longdouble = userInfo["lon"] as? Double
            {
                self.longitude = longdouble
            }
            
            
            if let userid = userInfo["user_id"] as? NSNumber
            {
                self.userID  = userid.description
            }else
            {
                self.userID   =  userInfo["user_id"] as! String
            }
            getUserProfileInfo(self.userID, handler: { (success, response, strError) in
                if success
                {
                    let userObj = response as! User
                    self.profile_url = userObj.profile_url
                }
            })
            
        }
    }
    
    
    
    
    convenience init(userInfo : Any) {
        self.init()
        
        guard let dictLocal = userInfo as? Dictionary<String, Any> else {
            return
        }
    
        self.age  =   getIntValue(strParam: "age", dictParam: dictLocal)
        self.drinkStatus = DrinkStatus(rawValue: getIntValue(strParam: "drink", dictParam: dictLocal))!
        self.email =  dictLocal["email"] as! String
        self.fbID = dictLocal["fb_id"] as! String
        self.profile_url = dictLocal["profile_url"] as! String

        self.aboutInfo = dictLocal["heading"] as! String
        
        if let userid = dictLocal["id"] as? String
        {
            self.userID = userid

        }else {
            self.userID = (dictLocal["id"] as! NSNumber).description
            
        }
        
        
        self.kidStatus = KidsStatus(rawValue: getIntValue(strParam: "kids", dictParam: dictLocal))!
        self.fullName = dictLocal["name"] as! String
        self.natureStatus = NatureStatus(rawValue: getIntValue(strParam: "nature", dictParam: dictLocal))!
        self.occupation = dictLocal["occupation"] as! String
        self.phoneNumber = dictLocal["phone_number"] as! String
        self.countryCode = dictLocal["country_code"] as! String
        self.videoRequest = VideoRequestStatus(rawValue: getIntValue(strParam: "received_video_chat", dictParam: dictLocal) )!
        self.genderType = GenderType(rawValue:  getIntValue(strParam: "sex", dictParam: dictLocal))!
        self.smokeStatus = SmokeStatus(rawValue: getIntValue(strParam: "smoke", dictParam: dictLocal))!
       self.userName = dictLocal["username"] as! String
        self.quickBloxID = dictLocal["quickblox_id"] as! String
        self.profileImageURL = dictLocal["profile_image"] as! String
        if let arrLinks =   dictLocal["images"] as? [String]
        {
            self.userImages.removeAll()
            for link in arrLinks
            {
                if link != ""
                {
                    let imageServer = LBImage(link: link)
                    self.userImages.append(imageServer)
                }
              
            }
        }
        
        if  let distnace = dictLocal["distance"] as? String
        {
            self.userDistance = Double(distnace)!
        } else if let distanceFloat =  dictLocal["distance"] as? Double
        {
            self.userDistance = distanceFloat
        }
        
        
        

        if let latUser =   dictLocal["lat"] as? Double
        {
            self.latitude = latUser
        }else if let latString = dictLocal["lat"] as? Double
        {
            self.latitude = Double(latString)
        }
        
        
        if let longUser =   dictLocal["lon"] as? Double
        {
            self.latitude = longUser
        }else if let longString = dictLocal["lon"] as? Double
        {
            self.latitude = Double(longString)
        }
    }
    
    
    
    
    func getIntValue(strParam : String , dictParam : [String : Any]) -> Int
    {
        if let  strValue = dictParam[strParam] as? String
        {
            return Int(strValue)!
        }else if let numberValue = dictParam[strParam] as? NSNumber
        {
            return numberValue.intValue
        }
        return 0
        
        
    }
    
     required init?(coder aDecoder: NSCoder)
    {
        let strID : String? = aDecoder.decodeObject(forKey: "userID") as? String
        if strID != nil {
            self.userID = strID!;
        }
        
         if  let QB_ID = aDecoder.decodeObject(forKey: "quickBloxID") as? String
         {
            self.quickBloxID = QB_ID;
          }
        
        let sessID : String? = aDecoder.decodeObject(forKey: "sessionID") as? String
        if sessID != nil {
            self.sessionID = sessID!;
        }
        
        let email : String? = aDecoder.decodeObject(forKey: "email") as? String
        if email != nil {
            self.email = email!;
        }

        let profile_url : String? = aDecoder.decodeObject(forKey: "profile_url") as? String
        if profile_url != nil {
            self.profile_url = profile_url!;
        }
        
        let imageURL : String? = aDecoder.decodeObject(forKey: "profileImageURL") as? String
        if imageURL != nil {
            self.profileImageURL = imageURL!;
        }

        let name : String? = aDecoder.decodeObject(forKey: "fullName") as? String
        if name != nil {
            self.fullName = name!;
        }
        
        let userName : String? = aDecoder.decodeObject(forKey: "userName") as? String
        if userName != nil {
            self.userName = userName!;
        }
        
        let aboutUser : String? = aDecoder.decodeObject(forKey: "aboutInfo") as? String
        if aboutUser != nil {
            self.aboutInfo = aboutUser!;
        }
        
        let phoneNumber : String? = aDecoder.decodeObject(forKey: "phoneNumber") as? String
        if phoneNumber != nil {
            self.phoneNumber = phoneNumber!;
        }
        
        
        self.fbID = aDecoder.decodeObject(forKey: "fbID") as! String
      
       
        let countryCode : String? = aDecoder.decodeObject(forKey: "countryCode") as? String
        if countryCode != nil {
            self.countryCode = countryCode!;
        }
        
        self.occupation = aDecoder.decodeObject(forKey: "occupation") as! String
       
      
        
        self.mobileVerified = aDecoder.decodeBool(forKey: "mobileVerified")
        self.alreadyRegistered = aDecoder.decodeBool(forKey: "alreadyRegistered")

        
        self.drinkStatus = DrinkStatus(rawValue: aDecoder.decodeInteger(forKey: "drinkStatus"))!
        self.smokeStatus = SmokeStatus(rawValue: aDecoder.decodeInteger(forKey: "smokeStatus"))!
        self.kidStatus = KidsStatus(rawValue: aDecoder.decodeInteger(forKey: "kidStatus"))!
        self.natureStatus = NatureStatus(rawValue: aDecoder.decodeInteger(forKey: "natureStatus"))!
        self.videoRequest = VideoRequestStatus(rawValue: aDecoder.decodeInteger(forKey: "videoRequest"))!
        
        self.unPaidCalls = aDecoder.decodeInteger(forKey: "unPaidCalls")
        self.paidCalls = aDecoder.decodeInteger(forKey: "paidCalls")

        if let arrLinks =   aDecoder.decodeObject(forKey: "userImages")  as? [LBImage]
        {
            self.userImages = arrLinks
        }
        
        if let profileImg =   aDecoder.decodeObject(forKey: "profileImage")  as? LBImage
        {
            self.profileImage = profileImg
        }
        
   }
    
    public func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.userID, forKey: "userID")
        aCoder.encode(self.sessionID, forKey: "sessionID")
        aCoder.encode(self.profileImageURL, forKey: "profileImageURL")
        aCoder.encode(self.fullName, forKey: "fullName")
        aCoder.encode(self.quickBloxID, forKey: "quickBloxID")
        aCoder.encode(self.aboutInfo, forKey: "aboutInfo")
        aCoder.encode(self.userName, forKey: "userName")

        aCoder.encode(self.fbID, forKey: "fbID")
        aCoder.encode(self.profile_url, forKey: "profile_url")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.mobileVerified, forKey: "mobileVerified")
        aCoder.encode(self.alreadyRegistered, forKey: "alreadyRegistered")
        aCoder.encode(self.occupation, forKey: "occupation")
        aCoder.encode(self.age, forKey: "age")
        aCoder.encode(self.countryCode, forKey: "countryCode")
        aCoder.encode(self.phoneNumber, forKey: "phoneNumber")
        aCoder.encode(self.drinkStatus.rawValue, forKey: "drinkStatus")
        aCoder.encode(self.smokeStatus.rawValue, forKey: "smokeStatus")
        aCoder.encode(self.kidStatus.rawValue, forKey: "kidStatus")
        aCoder.encode(self.natureStatus.rawValue, forKey: "natureStatus")
        aCoder.encode(self.videoRequest.rawValue, forKey: "videoRequest")
        aCoder.encode(self.accountStatus.rawValue, forKey: "accountStatus")
        aCoder.encode(self.userImages, forKey: "userImages")
        aCoder.encode(self.unPaidCalls, forKey: "unPaidCalls")
        aCoder.encode(self.profileImage, forKey: "profileImage")
        aCoder.encode(self.paidCalls, forKey: "paidCalls")

    }

    
    
    func getOtherUserProfileInfo(handler:@escaping CompletionHandle)
    {
        SwiftLoader.show(true)
        let   params : [String: Any] = ["user_id" : self.userID]
        HTTPRequest.sharedInstance().postMulipartRequest(urlLink: API.API_GetProfile, paramters: params, Images: []) { (success, response, strError) in
            SwiftLoader.hide()
            if success
            {
                if let responseDict = response as? [String : Any]
                {
                    let userInf = User(userInfo : responseDict)
                     handler(true, userInf, nil)
                }
               
            }else{
                handler(false, nil, strError)
            }
        }
        
        
    }
    
    
    func getUserProfileInfo(_ userId: String, handler:@escaping CompletionHandle)
    {
        SwiftLoader.show(true)
        let   params : [String: Any] = ["user_id" : userId]
        HTTPRequest.sharedInstance().postMulipartRequest(urlLink: API.API_GetProfile, paramters: params, Images: []) { (success, response, strError) in
            SwiftLoader.hide()
            if success
            {
                if let responseDict = response as? [String : Any]
                {
                    let userInf = User(userInfo : responseDict)
                    handler(true, userInf, nil)
                }
                
            }else{
                handler(false, nil, strError)
            }
        }
        
        
    }

}
