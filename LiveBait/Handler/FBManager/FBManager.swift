//
//  FBManager.swift
//  Who's In
//
//  Created by Maninderjit Singh on 04/07/16.
//  Copyright © 2016 XICOM. All rights reserved.
//

import UIKit

class FBManager: NSObject  {

    
    var shareCallBack:((Bool)->Void)? = nil
    var inviteCallBack:((Bool)->Void)? = nil


   // @property (nonatomic, copy) FBShareCallBack shareCallBack;
    var loginManager:FBSDKLoginManager!
    var permissions = [String]()
    var userID:String? = ""
    
    override init() {
        
       // super.init()
        self.permissions = ["public_profile","email","user_friends","user_link"]
        self.loginManager = FBSDKLoginManager()
        
    }
    
    

    class var sharedInstance: FBManager {
        struct Static {
            static let instance: FBManager = FBManager()
        }
        return Static.instance
    }
    
    
    
     
    
    // MARK: - logout FB
    
    func logout(){
        
        self.loginManager.logOut()
        FBSDKProfile.setCurrent(nil)
     FBSDKGraphRequest(graphPath: "me/permissions", parameters: nil, httpMethod: "DELETE").start { (connection , result, error) -> Void in
        
        }
        
        
        let storage:HTTPCookieStorage =  HTTPCookieStorage.shared
        for cookie in storage.cookies! {
            storage.deleteCookie(cookie)
        }
        userDefaults.synchronize()
    }
    
    
    private func profile(callBack:@escaping (Bool,AnyObject?,String?)->()) {
    
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields" : "first_name,last_name,picture.type(normal),email,birthday,gender, link"])
        graphRequest.start(completionHandler: { ( connection , result, error) -> Void in
            if (error != nil) {
                 self.logout()
                callBack(false,nil, error?.localizedDescription)
                return
            }
            
            if  let dictResult = result as? Dictionary<String , Any> {
                
                print(dictResult)
            }
            
            callBack(true,result as AnyObject?,nil)
            
        })
        
    }
    
    
    func getFriendList(callBack:@escaping (Bool,AnyObject?,String?)->()) {
        
        let params : [String : Any] = ["fields": "id, first_name, last_name, name, email, picture"]
        
        
        let graphRequest = FBSDKGraphRequest(graphPath: "/me/taggable_friends", parameters: params)
        
        // let graphRequest = FBSDKGraphRequest(graphPath: "/me/friends", parameters: params)
        let connection = FBSDKGraphRequestConnection()
        connection.add(graphRequest, completionHandler: { (connection, result, error) in
            if error == nil {
                if let userData = result as? [String:Any] {
                    print(userData)
                    
                    callBack(true,userData as AnyObject?, nil)
                    
                }
            } else {
                
                print("Error Getting Friends \(error)");
            }
            
        })
        
        connection.start()
        
    }
  
    
    
    
    
    func getNumberOfLikes()
    {
        let params : [String : Any] = ["fields": "total_count"]
        let objectID : String = "/" +  "345346236" + "/likes"
    let Fbrequest = FBSDKGraphRequest(graphPath: objectID , parameters: params, httpMethod: "GET")
        
        Fbrequest?.start(completionHandler: { (connection, result, error) in
            
            
        })
        
     /*
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
            initWithGraphPath:@"/{object-id}/likes"
            parameters:params
            HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
            id result,
            NSError *error) {
            // Handle the result
            }];
 
 */
    }
    
    
    
    
    
    
    func currentTokenString() -> String {
        return FBSDKAccessToken.current().tokenString;
    }
    
    func currentUserProfile( viewController : UIViewController , callBack:@escaping (Bool,AnyObject?,String?)->()) {

            self.login(viewController: viewController, callBack:  { (isSuccess:Bool, result:AnyObject?, error:String?) -> () in
                if isSuccess {
                    
                    self.profile(callBack: callBack)
                }else{
                      callBack(false,nil,error)
                }
            })
    }
    
    
    func login(viewController: UIViewController, callBack:@escaping (Bool,AnyObject?,String?)->()) {
        self.loginManager.logOut()

        self.loginManager.logIn(withReadPermissions: self.permissions, from: viewController) { (result, error) in
            
            if error != nil {
                
                callBack(false,nil,error?.localizedDescription)
                return
            }
            
            if (result?.isCancelled)!{
                callBack(false,nil,"User cancelled the action.")
                return
            }
            
            callBack(true,result,nil)
        }

    }


}
