//
//  Utility.swift
//  Drinks
//
//  Created by maninder on 8/3/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import SafariServices



let store = CNContactStore()


typealias ActionSheetHandler = ((_ Action: Bool, _ Index: Int) -> Void) // false for Cancel
typealias AlertHandler = ( (_ Index: Int) -> Void) // false for Cancel



@objc protocol MSSelectionCallback {
    @objc optional func moveWithSelection(selected : Any)
    @objc optional func actionPreviousVC(action: Bool )
    @objc optional func replaceRecords(obj : Any )
    @objc optional func replaceRecords()
    @objc optional func moveRecordsWithType(obj : AnyObject , type : String )
    
}


func FontBold(size: CGFloat) -> (UIFont)
{
    return UIFont(name: "ProximaNova-Bold", size: size)!
}

func FontRegular(size: CGFloat) -> (UIFont)
{
    return UIFont(name: "ProximaNova-Regular", size: size)!
}

func FontLight(size: CGFloat) -> (UIFont)
{
    return UIFont(name: "ProximaNova-Light", size: size)!
}

public func showAlertWithAnimation(object : UIViewController){
    UIView.animate(withDuration: 0.3) {
        object.view.alpha = 1
    }
}

public func hideAlertWithAnimation(object : UIViewController , callBack:@escaping (_: Bool) -> ()){
    UIView.animate(withDuration: 0.3, animations: {
       object.view.alpha = 0
    }) { (test) in
        callBack(true)
    }
}




func  showAlert(title : String , message : String , controller : UIViewController)
{
    let objAlertController = UIAlertController(title: title, message: message , preferredStyle: UIAlertControllerStyle.alert)
    let objAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler:
        {Void in
            
    })
    objAlertController.addAction(objAction)
    controller.present(objAlertController, animated: true, completion: nil)
}


func  showAlert(title : String , message : String , controller : UIViewController , handler : @escaping AlertHandler)
{
    let objAlertController = UIAlertController(title: title, message: message , preferredStyle: UIAlertControllerStyle.alert)
    let objAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler:
        {Void in
            handler(0)
    })
    objAlertController.addAction(objAction)
    controller.present(objAlertController, animated: true, completion: nil)
}

func showCustomAlert(message : String , controller : UIViewController)
{
    
    let alertVC = mainStoryBoard.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
    alertVC.view.alpha = 0
    alertVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    alertVC.strMessage = message
    alertVC.modalPresentationStyle = .overCurrentContext
    controller.present(alertVC, animated: false, completion: nil)
    
}


func JSONString (paraObject : Any) -> String{
    var strReturning = String()
    do
    {
        if let postData : NSData = try JSONSerialization.data(withJSONObject: paraObject, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData?
        {
            strReturning  = NSString(data: postData as Data, encoding: String.Encoding.utf8.rawValue)! as String
        }
    }
    catch
    {
        print(error)
    }
    return strReturning
}



func actionSheet(btnArray : [String] , cancel : Bool , destructive : Int  ,  controller : UIViewController , handler : @escaping ActionSheetHandler)
{
    let actionSheetController: UIAlertController = UIAlertController(title: nil , message: nil , preferredStyle: .actionSheet)
    for  i in 0 ..< btnArray.count {
            let actionNew : UIAlertAction = UIAlertAction(title: btnArray[i] , style: .default) { action -> Void in
                let title: String =  action.title!
                let index: Int = btnArray.index(of: title)!
                handler(true, index)
            }
            actionSheetController.addAction(actionNew)
    
    }
    
    if cancel == true{
        
        let actionNew: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            handler(false, -1)
        }
        actionSheetController.addAction(actionNew)
    }
    controller.present(actionSheetController, animated: true, completion: nil)
}



func MSAlert( message : String , firstBtn : String , SecondBtn : String  ,  controller : UIViewController , handler : @escaping ActionSheetHandler)
{
    let alertController = UIAlertController(title: "LiveBait", message: message, preferredStyle: UIAlertControllerStyle.alert)
    let actionLeft : UIAlertAction = UIAlertAction(title: firstBtn , style: .default) { action -> Void in
                        handler(true, 1)
            }
      alertController.addAction(actionLeft)
    let actionRight : UIAlertAction = UIAlertAction(title: SecondBtn , style: .default) { action -> Void in
        handler(true, 0)
    }
    alertController.addAction(actionRight)
        controller.present(alertController, animated: true, completion: nil)

}



func openInAppBrowser(controller : UIViewController , link : String)
{
    let safariVC = SFSafariViewController(url: NSURL(string: link)! as URL)
    controller.present(safariVC, animated: true, completion: nil)
}




public func resizeImage(image: UIImage, size: CGSize) -> UIImage?
{
    var returnImage: UIImage?
    var scaleFactor: CGFloat = 1.0
    var scaledWidth = size.width
    var scaledHeight = size.height
    var thumbnailPoint = CGPoint(x: 0, y: 0)
    
    if !image.size.equalTo(size) {
        let widthFactor = size.width / image.size.width
        let heightFactor = size.height / image.size.height
        
        if widthFactor > heightFactor {
            scaleFactor = widthFactor
        } else {
            scaleFactor = heightFactor
        }
        
        scaledWidth = image.size.width * scaleFactor
        scaledHeight = image.size.height * scaleFactor
        
        if widthFactor > heightFactor {
            thumbnailPoint.y = (size.height - scaledHeight) * 0.5
        } else if widthFactor < heightFactor {
            thumbnailPoint.x = (size.width - scaledWidth) * 0.5
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(size, true, 0)
    
    var thumbnailRect = CGRect.zero
    thumbnailRect.origin = thumbnailPoint
    thumbnailRect.size.width = scaledWidth
    thumbnailRect.size.height = scaledHeight
    
    image.draw(in: thumbnailRect)
    returnImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return returnImage
}






func getOutOfApp(){
    
    
    
    LoginManager.sharedInstance.removeSubscription()
    SwiftLoader.hide()
    LoginManager.sharedInstance.removeUserProfile()
    
    FBManager.sharedInstance.logout()
    let landing = mainStoryBoard.instantiateViewController(withIdentifier: "WalkThroughVC") as! WalkThroughVC
    let naviagtionController = UINavigationController(rootViewController: landing)
    naviagtionController.isNavigationBarHidden = true
    appDelegate().window?.rootViewController = naviagtionController
    appDelegate().selectedTab = MSSelectedTab(rawValue: 0)!
}





func openSideMenuController(navigation : UINavigationController) {
    
    let leftVC = mainStoryBoard.instantiateViewController(withIdentifier: "LeftMenuVC") as! LeftMenuVC

    let  mainVC = mainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
    let navController: UINavigationController = UINavigationController(rootViewController: mainVC);
    navController.isNavigationBarHidden = true

    let slideController:SWRevealViewController = SWRevealViewController.init(rearViewController: leftVC, frontViewController: navController)
    slideController.frontViewPosition = FrontViewPosition.left
    appDelegate().viewControllerSlider = slideController
    appDelegate().window?.rootViewController = slideController
    
}


func deviceUniqueIdentifier() -> String {
    
    let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
    var strApplicationUUID = SSKeychain.password(forService: appName, account: "incoding")
    if (strApplicationUUID == nil)
    {
        strApplicationUUID = UIDevice.current.identifierForVendor?.uuidString;
        SSKeychain.setPassword(strApplicationUUID, forService: appName, account: "incoding")
    }
    
    return strApplicationUUID!;
    
}



func setUserImage(imgView : UIImageView , strURL : String)
{
    let urlImage = URL(string: strURL)
    imgView.sd_setImage(with: urlImage, placeholderImage: userPlaceHolder)
}

func getLatString()-> String
{
    return  String(format:"%.5f", (appDelegate().currentLocation?.coordinate.latitude)!)
}


func getLongString() -> String
{
    return  String(format:"%.5f", (appDelegate().currentLocation?.coordinate.longitude)!)
}


func getJSONString (paraObject : [String : Any]) -> String{
    var strReturning = String()
    do
    {
        if let postData : NSData = try JSONSerialization.data(withJSONObject: paraObject, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData?
        {
            strReturning  = NSString(data: postData as Data, encoding: String.Encoding.utf8.rawValue)! as String
        }
    }
    catch
    {
        print(error)
    }
    
    return strReturning
}

public func createAndSaveContact(userData : Any)
{
    switch CNContactStore.authorizationStatus(for: .contacts){
    case .authorized:
        createContact(userData: userData)
    case .notDetermined:
        store.requestAccess(for: .contacts){succeeded, err in
            guard err == nil && succeeded else{
                return
            }
            createContact(userData: userData)
        }
    default:
        print("Not handled")
    }
}


func createContact(userData : Any)
{
    let contactUser = userData as! User
    let contactNew = CNMutableContact()
    let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue: contactUser.phoneNumber))
    contactNew.givenName = contactUser.fullName
    contactNew.phoneNumbers = [homePhone]
    let request = CNSaveRequest()
    request.add(contactNew, toContainerWithIdentifier: nil)
    do{
        
        try store.execute(request)
        NotificationCenter.default.post(name: Notification.Name(rawValue: MSNotificationName.NewContactSaved.rawValue), object: nil)
        print("Stored the contact")
        
    } catch let err{
        
        print(err)
    }
    
    
}


