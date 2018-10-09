//
//  GoogleManager.swift
//  Kite Flight
//
//  Created by maninder on 5/31/17.
//  Copyright © 2017 Neetika Rana. All rights reserved.
//

import UIKit


typealias GoogleHandler = (_ success: Bool, _ response: Any? , _ error : String?) -> Void



class GoogleManager: NSObject,GIDSignInDelegate,GIDSignInUIDelegate{
  
    var resultHandler : GoogleHandler? = nil
    var presentingViewController : UIViewController!
    
    class var sharedInstance: GoogleManager {
        struct Static {
            static let instance: GoogleManager = GoogleManager()
        
        }
        
        return Static.instance
    }
    
    
    
    func googleSignIn(viewController : UIViewController , handlerLocal : @escaping GoogleHandler)
    {
        
        presentingViewController = viewController
        resultHandler  = handlerLocal
       GIDSignIn.sharedInstance().uiDelegate = self
       GIDSignIn.sharedInstance().delegate = self

        GIDSignIn.sharedInstance().signIn()
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil{
          
          //  if resultHandler != nil{
            print(user.userID)
            print(user.profile.givenName)
            print(user.profile.familyName)
            print(user.profile.name)
            
            let userGoogle = User()
            userGoogle.email = user.profile.email
            userGoogle.socialID = user.userID
            if let firstName = user.profile.familyName {
               userGoogle.firstName = firstName
            }
            if let lastName = user.profile.givenName {
                userGoogle.lastName = lastName
            }
            
            self.resultHandler!(true,userGoogle, nil)
        }else{
            
              self.resultHandler!(false,nil, error.localizedDescription)
        }
        
    }
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        presentingViewController.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    
   

}
