//
//  AppDelegate.swift
//  LiveBait
//
//  Created by maninder on 11/16/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import Firebase
import FirebaseAuth
import PushKit
import SwiftyNotifications



@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate,UNUserNotificationCenterDelegate,QBRTCClientDelegate,PKPushRegistryDelegate, SwiftyNotificationsDelegate  {
    
    var window: UIWindow?
    var selectedTab : MSSelectedTab = .Dashboard
    var locationManager : CLLocationManager?
    var currentLocation : CLLocation? = nil
    var myLocationName : String = ""
    var myTimer : Timer? = nil
    var viewControllerSlider :  SWRevealViewController? = nil
    
    var activeCall : VideoCall =  VideoCall()
    
    var dictCaller : [String : String] =   [String : String]()
    var callingView : CallView? = nil
    var notificationView : NotificationView? = nil

    var contactToSave : String = ""
    var timerCall : Timer?

    var videoCapture : QBRTCCameraCapture?  = nil

    var firstTime = false
   var secondsOnCall = 0
    var timeToDisplay = "0:00"
   
    
    var customNotification: SwiftyNotifications!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().shouldShowToolbarPlaceholder = true
        IQKeyboardManager.sharedManager().previousNextDisplayMode = IQPreviousNextDisplayMode.Default
        
        self.initializeLocationManager()
        
        
        self.registerAppPushNotificaiton()
        self.registerVoIPPush()
        FirebaseApp.configure()
        QBSettings.applicationID = UInt(QBDetails.ApplicationID)
        QBSettings.accountKey = QBDetails.AccountKey
        QBSettings.authKey = QBDetails.AuthorizationKey
        QBSettings.authSecret = QBDetails.AuthorizationSecret

        QBSettings.keepAliveInterval = 60
        QBRTCClient.initializeRTC()
        QBRTCClient.instance().add(self)

        if (LoginManager.sharedInstance.getMeArchiver() != nil)
        {
            let savedDetails = LoginManager.sharedInstance.getMeArchiver()
            if savedDetails?.quickBloxID != ""
            {
                 self.connectWithUserID()
            }
        }
        UIApplication.shared.applicationIconBadgeNumber = 0

        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
         UIApplication.shared.applicationIconBadgeNumber = 0
       
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
//        if (LoginManager.sharedInstance.getMeArchiver() != nil)
//        {
//            let savedDetails = LoginManager.sharedInstance.getMeArchiver()
//            if savedDetails?.quickBloxID != ""
//            {
//                self.connectWithUserID()
//            }
//        }
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
        
//        if (LoginManager.sharedInstance.getMeArchiver() != nil)
//        {
//            let savedDetails = LoginManager.sharedInstance.getMeArchiver()
//            if savedDetails?.quickBloxID != ""
//            {
//                self.connectWithUserID()
//            }
//        }
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
                if (LoginManager.sharedInstance.getMeArchiver() != nil)
                {
                    if self.activeCall.status == .Connected || self.activeCall.status == .WaitingForApproval || self.activeCall.status == .Dailing
                    {
                        self.removeCallAndNotificationView()
                        self.activeCall.activeSession.hangUp(nil)
                        self.timerCall?.invalidate()
                    }
                }
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme!  == "fb1891076294263872" {
//        if url.scheme!  == "fb1644032585664228" {
        
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url as URL! , sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }
        return false
        
    }
    
    
    
    //MARK:- Pushkit Delegates
    //MARK:-
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        if type == PKPushType.voIP {
            let tokenData = credentials.token
            userDefaults.set(tokenData , forKey: LocalKeys.VOIPTokenData.rawValue)

            let pushToken = String(format: "%@", tokenData as CVarArg)
            let characterSet: CharacterSet = CharacterSet.init(charactersIn: "<>")
            let strDeviceToken = pushToken.trimmingCharacters(in: characterSet).replacingOccurrences(of: " ", with: "")
           // VOIPTokenData
            userDefaults.set(strDeviceToken , forKey: LocalKeys.VOIPToken.rawValue)
        }
    }
    
   
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType)
    {
        
        
    }
    
 
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType)
    {
        guard type == .voIP else { return }
    }
    
    func displayIncomingCall(uuid: UUID, handle: String, hasVideo: Bool = true, completion: ((NSError?) -> Void)? = nil) {
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "LiveBait")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
              
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    
    
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func initializeLocationManager()
    {
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager = CLLocationManager()
            locationManager!.delegate = self;
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest;
            locationManager?.requestWhenInUseAuthorization()
            locationManager?.startUpdatingLocation()
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location: CLLocation? = locations.last
        if (location == nil)
        {
            return;
        }else{
            self.currentLocation = location!
            if firstTime == false{
                firstTime = true
                NotificationCenter.default.post(name: Notification.Name(rawValue: MSNotificationName.DidGetLocation.rawValue), object: nil)
            }
            self.getLocationName()
        }
    }
    
    func getLocationName()
    {
        
        if self.currentLocation != nil{
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(currentLocation!, completionHandler: { placemarks, error in
                guard let addressDict = placemarks?[0].addressDictionary else {
                    return
                }
                if let street = addressDict["Street"] as? String {
                    self.myLocationName = street
                }
                
                if let cityName = addressDict["City"] as? String
                {
                    self.myLocationName =   self.myLocationName + ", " + cityName
                }
                
                if let stateCode = addressDict["State"] as? String
                {
                    self.myLocationName = self.myLocationName + ", " + stateCode
                }
            })
        }
    }
    

    func stopTimer()
    {
        if myTimer != nil
        {
            self.myTimer?.invalidate()
        }
    }
    
    func moveToDashBoard()
    {
        let  mainVC = mainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let navigation = UINavigationController(rootViewController: mainVC)
        self.viewControllerSlider?.setFront(navigation, animated: true)
        self.viewControllerSlider?.setFrontViewPosition(.left, animated: true)
        self.selectedTab =  MSSelectedTab(rawValue: 0)!
    }
    
    
    func connectWithUserID()
    {
        if  let myQBuser = LoginManager.getMe.quickBloxID as? String
        {
            let login = "facebook_" + LoginManager.getMe.fbID
            print(login)
            QBRequest.logIn(withUserLogin: login , password: QBDetails.QBPassword , successBlock: { (response, user) in
                QBChat.instance.connect(with: user, completion: { (error) in
                    QBRTCClient.instance().add(self)
                    QBRTCConfig.setAnswerTimeInterval(60)
                    LoginManager.sharedInstance.saveSubscription()
                })
            }, errorBlock: { (response) in
            })
        }
    }
    
    
    func calculateDistanceInMiles(UserLat : Double , UserLong : Double) -> String
    {
        let coordinateUser = CLLocation(latitude: UserLat, longitude:UserLong)
        let coordinateMy = CLLocation(latitude: (self.currentLocation?.coordinate.latitude)!, longitude: (self.currentLocation?.coordinate.longitude)!)
        let distanceInMeters = coordinateUser.distance(from: coordinateMy)
        let distanceInMiles = distanceInMeters/1609.344
        
        let finslStr =  String(format:"%.2f", distanceInMiles)
        return finslStr + " miles"
        
    }
    
    
}

