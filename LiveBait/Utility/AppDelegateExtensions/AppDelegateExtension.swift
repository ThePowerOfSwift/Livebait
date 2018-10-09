//
//  AppDelegateExtension.swift
//  Drinks
//
//  Created by maninder on 9/12/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import Foundation
import UserNotifications
import FirebaseAuth
import PushKit
import UIKit
import SwiftyNotifications

extension AppDelegate
{
    
    fileprivate func topViewControllerWithRootViewController(_ rootViewController:UIViewController) -> UIViewController {
        
        if (rootViewController is UITabBarController) {
            
            let tabBarController:UITabBarController = rootViewController as! UITabBarController
            return  self.topViewControllerWithRootViewController(tabBarController.selectedViewController!)
            
        }else if (rootViewController is UINavigationController) {
            let tabBarController:UINavigationController = rootViewController as! UINavigationController
            return  self.topViewControllerWithRootViewController(tabBarController.visibleViewController!)
            
        }else if ((rootViewController.presentedViewController) != nil) {
            
            let presentedViewController: UIViewController = rootViewController
            return  self.topViewControllerWithRootViewController(presentedViewController)
        }else{
            return rootViewController;
        }
    }
    
    func topViewController() -> UIViewController {
        return self.topViewControllerWithRootViewController((UIApplication.shared.keyWindow?.rootViewController)!)
    }
    
 
    
    class var appDelegate: AppDelegate {
        get {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            return delegate
        }
    }
    
    class var app: UIApplication {
        get {
            return UIApplication.shared
        }
    }
    
    func unregisterAppPushNotifications(){
     
        AppDelegate.app.registerForRemoteNotifications();
    }
    
    func registerVoIPPush() {
        let voipPushResgistry = PKPushRegistry(queue: DispatchQueue.main)
        voipPushResgistry.delegate = self
        voipPushResgistry.desiredPushTypes = [PKPushType.voIP]
    }
    
    func registerAppPushNotificaiton() {
        if #available(iOS 10.0, *)
        {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [UNAuthorizationOptions.sound , UNAuthorizationOptions.alert,UNAuthorizationOptions.badge], completionHandler: { (isSuccess, error) in
                if (error == nil){
                    DispatchQueue.main.async
                    {
                    AppDelegate.app.registerForRemoteNotifications();
                    }
                }
            })
        }else{
            AppDelegate.app.registerForRemoteNotifications()
        }
    }
    
    
    
    
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            // Pass device token to auth
            Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
            userDefaults.set(deviceToken, forKey:   LocalKeys.DeviceTokenData.rawValue )
     
        let pushToken = String(format: "%@", deviceToken as CVarArg)
        let characterSet: CharacterSet = CharacterSet.init(charactersIn: "<>")
        let strDeviceToken: String? = pushToken.trimmingCharacters(in: characterSet).replacingOccurrences(of: " ", with: "")
        userDefaults.set(strDeviceToken, forKey: LocalKeys.DeviceToken.rawValue)
        userDefaults.synchronize()
    }
    
    
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("\(error)")
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
      if  let dict  = response.notification.request.content.userInfo as? Dictionary<String,Any>
      {
    
        if UIApplication.shared.applicationState == .active
        {
          //  completionHandler(UNNotificationPresentationOptions.sound)
        }else if UIApplication.shared.applicationState == .inactive
        {
            print("inactive")
           // showAlert(title: "Testimg", message: "Coimg from direct", controller: self.topViewController())

        }else{
            print("BG")
        }
        
        
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let dict  = notification.request.content.userInfo as? Dictionary<String,Any>
        if (LoginManager.sharedInstance.getMeArchiver() != nil)
        {
            let appsDict = dict!["aps"] as! Dictionary<String,Any>
            let strMessage = appsDict["alert"] as! String
            
          if  let dataDict = appsDict["data"] as? Dictionary<String,Any>
          {
            var typePush = "1"
            if let type = dataDict["type"] as? String
            {
                typePush = type
            }else if let typeNumber = dataDict["type"] as? Int
            {
                typePush = typeNumber.description
            }
            
            if self.viewControllerSlider?.frontViewPosition == FrontViewPosition.right
            {
                self.viewControllerSlider?.revealToggle(animated: true)
                
            }
          
                if typePush == "2"
                {
                    customNotification = SwiftyNotifications.withStyle(style: .info, title: "Location Share", subtitle: strMessage, dismissDelay: 3, direction: .top)
                    customNotification.setCustomColors(backgroundColor: UIColor.white, textColor: UIColor.black)
                    self.topViewController().view.window?.addSubview(customNotification)
                    
                    customNotification.addTouchHandler {
                        let location = Location(latitude:  Double(dataDict["lat"] as! String)! , longitude: Double(dataDict["lon"] as! String)!, locationName: dataDict["address"] as! String)
                        let mapVC = mainStoryBoard.instantiateViewController(withIdentifier: "MapVC") as! MapVC
                        mapVC.userReceiver = self.activeCall.secondParty
                         mapVC.mapType = .SharedLocationOnCall
                        mapVC.locationToShare = location
                        self.topViewController().present(mapVC, animated: true, completion: nil)
                        
                    }
                     customNotification.show()
                    
                }else if typePush == "1"{
                    customNotification = SwiftyNotifications.withStyle(style: .info, title: "Contact Share", subtitle: strMessage, dismissDelay: 3, direction: .top)
                    customNotification.addTouchHandler {
                        if self.activeCall.status == .Connected
                        {
                            
                        }
                        
                       
                    }
                    customNotification.setCustomColors(backgroundColor: UIColor.white, textColor: UIColor.black)
                    self.topViewController().view.window?.addSubview(customNotification)
                    customNotification.show()
            }else{
                
                
            }
            }
        }
       
        
    }
    
    
    
    
    
    func willShowNotification(notification: UIView) {
        
    }
    
    func didShowNotification(notification: UIView) {
        
    }
    
    func willDismissNotification(notification: UIView) {
        
    }
    
    func didDismissNotification(notification: UIView) {
        
    }
    
    
    
    
    
    //MARK:- QuickBlox Session Delegates
    //MARK:-
    
    
    
    
    func sessionDidClose(_ session: QBRTCSession) {
        print("sessionDid Close called")
        if self.activeCall.status == .WaitingForApproval || self.activeCall.status == .Free || self.activeCall.status == .Connected
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: MSNotificationName.UserNotResponding.rawValue), object: session)
            self.activeCall.status = .Free
        }
    }
    
    
    func didReceiveNewSession(_ session: QBRTCSession, userInfo: [String : String]? = nil) {
        dictCaller = userInfo!
        let userReceiver = getCallerInfo(userInfo:  userInfo!)
    
        if self.activeCall.status == .Free
        {
            if self.viewControllerSlider?.frontViewPosition == FrontViewPosition.right
            {
                self.viewControllerSlider?.revealToggle(animated: true)
            }
            self.activeCall = VideoCall(statuNew: .WaitingForApproval, session: session, secondUser: userReceiver)
            print(self.activeCall.status)
            NotificationCenter.default.post(name: Notification.Name(rawValue: MSNotificationName.NewVideoCallRequest.rawValue), object: userReceiver)
        }else if  self.activeCall.status == .Dailing
        {
                if self.activeCall.activeSession!.id != session.id
                {
                        session.hangUp(userInfo)
                }
        }else{
           session.hangUp(userInfo)
        }
    }
        

    func session(_ session: QBRTCSession, userDidNotRespond userID: NSNumber) {
        if self.activeCall.status == .Dailing
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: MSNotificationName.UserNotResponding.rawValue), object: session)
            self.activeCall.status = .Free
        }
    }
    
    
    func session(session: QBRTCSession!, rejectedByUser userID: NSNumber!, userInfo: [NSObject : AnyObject]!) {
        
        if  self.activeCall.status == .Dailing
        {
               NotificationCenter.default.post(name: Notification.Name(rawValue: MSNotificationName.UserCallRejectedByOther.rawValue), object: nil)
        }
    }
    
    
    func session(_ session: QBRTCSession, acceptedByUser userID: NSNumber, userInfo: [String : String]? = nil)
    {
       
       if  self.activeCall.status == .Dailing
        {
            let userReceiver = getReceiverInfo(userInfo: userInfo!)
            self.activeCall = VideoCall(statuNew: .Connected , session: session, secondUser: userReceiver)
            NotificationCenter.default.post(name: Notification.Name(rawValue: MSNotificationName.CallAcceptedByUser.rawValue), object: nil)
        }
    }
    
    func session(session: QBRTCSession!, connectedToUser userID: NSNumber!) {
        print("Connection is established with user \(userID)")
    }
    
    
    
    func session(_ session: QBRTCSession, hungUpByUser userID: NSNumber, userInfo: [String : String]? = nil)
    {
        print("call hang up by user")
        print(self.activeCall.status)
        if  self.activeCall.status == .WaitingForApproval || self.activeCall.status == .Connected
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: MSNotificationName.UserCallDisconnectedByOther.rawValue), object: nil)
        }else if self.activeCall.status == .Dailing
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: MSNotificationName.UserCallRejectedByOther.rawValue), object: nil)
        }
    }
    
    func session(_ session: QBRTCBaseSession, receivedRemoteAudioTrack audioTrack: QBRTCAudioTrack, fromUser userID: NSNumber)
    {
        print("Audio received from another new user")
    }
    
    func session(_ session: QBRTCBaseSession, receivedRemoteVideoTrack videoTrack: QBRTCVideoTrack, fromUser userID: NSNumber) {
        print("Video received from another new user")
        NotificationCenter.default.post(name: Notification.Name(rawValue: MSNotificationName.UserVideoInitialised.rawValue), object: videoTrack)
    }
    
    
    func session(_ session: QBRTCBaseSession, didChange state: QBRTCSessionState) {
        
        
        if state == QBRTCSessionState.pending
        {
            
        }else if state == QBRTCSessionState.connecting
        {
            
        }else if state == QBRTCSessionState.connected
        {
            print("Checking New State \(state.rawValue)")
            NotificationCenter.default.post(name: Notification.Name(rawValue: MSNotificationName.UserConnected.rawValue), object: nil)
        }
            
        print(state)
    }
    
    func  session(_ session: QBRTCSession, rejectedByUser userID: NSNumber, userInfo: [String : String]? = nil)
    {
        if self.activeCall.status == .Dailing
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: MSNotificationName.UserCallRejectedByOther.rawValue), object: session)
            self.activeCall.status = .Free
        }
    }
    
  
    
    func showCallConnected()
    {
        if self.notificationView != nil
        {
            self.notificationView?.removeFromSuperview()
        }
        
        self.addCallNotifcationView()
        self.callingView = loadCallingViewFromObjNib()
        self.callingView?.frame = CGRect(x: 0, y: 0, width:ScreenWidth , height: ScreenHeight)
        self.topViewController().view.addSubview(self.callingView!)
        self.callingView?.callBack = { (test) in
            if test == TypeAction.actionMap
            {
              //  self.hideBothView()
                let mapVC = mainStoryBoard.instantiateViewController(withIdentifier: "MapVC") as! MapVC
                mapVC.userReceiver = self.activeCall.secondParty
                self.topViewController().present(mapVC, animated: true, completion: nil)
            }else  if test == TypeAction.actionFB
            {
             //   self.hideCallingView()
                let userReceiver = self.activeCall.secondParty
                if userReceiver.profile_url == "" {
                    showCustomAlert(message: "Can not open profile for privacy reasons.", controller: self.topViewController())
                }else {
                    let userFbURL =  userReceiver.profile_url
                    openInAppBrowser(controller: self.topViewController(), link: userFbURL)
                }
                
            }else if test == TypeAction.actionBack
            {
                self.hideCallingView()
            }
        }
    }
    
    func addCallNotifcationView()
    {
        self.notificationView = loadCallNotificationView()
        self.notificationView?.frame = CGRect(x: 0, y: 0, width:ScreenWidth , height: 44)
        self.topViewController().view.addSubview(self.notificationView!)
        self.notificationView?.callBackShowCallerView = { (test) in
            self.showCallingView()
        }
    }
    

    
    func hideBothView()
    {
        let screenheight = ScreenHeight
        let screenwidth = ScreenWidth
        self.callingView?.frame = CGRect(x: 0 , y: -(screenheight) , width: screenwidth, height: screenheight)
        self.notificationView?.frame = CGRect(x: 0 , y: -44 , width: screenwidth, height: 44)
    }
    
    func hideCallingView()
    {
        let screenheight = ScreenHeight
        let screenwidth = ScreenWidth

       if self.callingView != nil
       {
            UIView.animate(withDuration: 0.4, animations: {
                self.callingView?.frame = CGRect(x: 0 , y: -(screenheight) , width: screenwidth, height: screenheight)
                self.notificationView?.frame = CGRect(x: 0 , y: 0 , width: screenwidth, height: 44)

            }, completion: { (success) in
            })
        }
    }
    
    
    func removeCallAndNotificationView()
    {
        self.notificationView?.removeFromSuperview()
        self.callingView?.removeFromSuperview()
    }
    
    
    
    func showCallingView()
    {
        let screenheight = ScreenHeight
        let screenwidth = ScreenWidth
        if self.callingView != nil
        {
            UIView.animate(withDuration: 0.3, animations: {
                self.callingView?.frame = CGRect(x: 0.0, y: 0.0, width: screenwidth , height: screenheight)
                self.notificationView?.frame = CGRect(x: 0 , y: -44 , width: screenwidth, height: 44)
            }, completion: { (success) in
                
            })
        }
    }
    
    

    
  
    func startTimer()
    {
        self.timerCall =  Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (result) in
            self.incrementTime()
        })
    }
    
    
    
    func incrementTime()
    {
        secondsOnCall  = secondsOnCall + 1
            let mintues = secondsOnCall / 60
        
        let   seconds = secondsOnCall % 60
       
        if seconds < 10
        {
            timeToDisplay = mintues.description + ":0" + seconds.description

        }else{
            timeToDisplay = mintues.description + ":" + seconds.description
        }
        
        if callingView != nil && notificationView != nil
        {
        callingView?.lblTimer.text = timeToDisplay
            notificationView?.lblTimer.text = timeToDisplay
        }
    }
    
    
    
    func getCallerInfo( userInfo : [String : String]) -> User{
        let caller = userInfo["caller"]
        let jsonData = caller?.data(using: .utf8)
        let dictionary = try? JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments)
        let callerUser = User(userCaller: dictionary as! Dictionary<String, Any> )
        return callerUser
    }
    
    
    func getReceiverInfo( userInfo : [String : String]) -> User{
        let caller = userInfo["receiver"]
        let jsonData = caller?.data(using: .utf8)
        let dictionary = try? JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments)
        let callerUser = User(userCaller: dictionary as! Dictionary<String, Any>)
        return callerUser
    }
    
}

