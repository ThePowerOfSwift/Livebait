//
//  NewCallRequestVC.swift
//  LiveBait
//
//  Created by maninder on 1/29/18.
//  Copyright © 2018 Maninderjit Singh. All rights reserved.
//

import UIKit
import AVFoundation

// create a sound ID, in this case its the tweet sound.


class NewCallRequestVC: UIViewController,MSAlertProtocol,UITextViewDelegate
{
    var userOnCall : User = User()
    
    @IBOutlet weak var lblClickhere: UILabel!
    @IBOutlet weak var txtViewUser: UITextView!
    @IBOutlet weak var lblDIstance: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    var delegate : MSAlertProtocol? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stringComplete = NSMutableAttributedString(string: "Click here to view profile and decide.")

        let attributComplete : [NSAttributedStringKey : Any]  = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : FontRegular(size: 14) ]
        
        stringComplete.addAttributes(attributComplete, range: NSMakeRange(0, stringComplete.length))
        txtViewUser.delegate = self
          NotificationCenter.default.addObserver(self, selector: #selector(NewCallRequestVC.disconnectedBYUser), name: NSNotification.Name(rawValue: MSNotificationName.UserNotResponding.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewCallRequestVC.disconnectedBYUser), name: NSNotification.Name(rawValue: MSNotificationName.UserCallDisconnectedByOther.rawValue), object: nil)

        
        let attributClickHere : [NSAttributedStringKey : Any]  = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue) : APPThemeColor ,
                                                                  NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : FontRegular(size: 14) , NSAttributedStringKey(rawValue: NSAttributedStringKey.underlineStyle.rawValue)  : NSUnderlineStyle.styleSingle.rawValue ]
        
        stringComplete.addAttributes(attributClickHere, range: NSMakeRange(0, 10))
        
        txtViewUser.attributedText = stringComplete
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(NewCallRequestVC.myMethodToHandleTap(_:)))
        tap.numberOfTapsRequired = 1
        txtViewUser.addGestureRecognizer(tap)
        
  
        
        
        if appDelegate().currentLocation != nil
        {
            self.lblDIstance.text = appDelegate().calculateDistanceInMiles(UserLat: userOnCall.latitude, UserLong: userOnCall.longitude)
        }
         lblUserName.text = userOnCall.fullName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // viewLoader.startAnimating()
       // lblUserName.text = "Please wait for \(userName) decides!!"
        showAlertWithAnimation(object: self)
        
       
        
    }

    
    @IBAction func actionBtnYesPressed(_ sender: UIButton) {
      //  let currentNC = self.storyboard.
        
        hideAlertWithAnimation(object: self) { (call) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.dismiss(animated: false, completion: nil)
               
                if self.delegate != nil
                {
                     self.delegate!.popupYesNoPressed!(type: true)
                }
            })
        }
    }
    
    @IBAction func actionBtnNoPressed(_ sender: UIButton) {
        hideAlertWithAnimation(object: self) { (call) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.dismiss(animated: false, completion: nil)
             if self.delegate != nil
                {
                    self.delegate!.popupYesNoPressed!(type: false)
                }
            })
        }
    }
    
    
    
    func hideViewOnCallAcceptOrReject()
    {
        hideAlertWithAnimation(object: self) { (call) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.dismiss(animated: false, completion: nil)
            })
        }
    }
    
    
    @objc func myMethodToHandleTap(_ sender: UITapGestureRecognizer) {
        
        let myTextView = sender.view as! UITextView
        let layoutManager = myTextView.layoutManager
        
        // location of tap in myTextView coordinates and taking the inset into account
        var location = sender.location(in: myTextView)
        location.x -= myTextView.textContainerInset.left;
        location.y -= myTextView.textContainerInset.top;
        
        // character index at tap location
        let characterIndex = layoutManager.characterIndex(for: location, in: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        // if index is valid then do something.
        if characterIndex < myTextView.textStorage.length {
            
            // print the character index
            
            if characterIndex < 10
            {
                let profileVC =  self.storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
                profileVC.userProfile = self.userOnCall
                profileVC.delegate = self
                profileVC.btnStatus = .AcceptCall
                self.navigationController?.pushViewController(profileVC, animated: true)
                
                
            }

        }
    }
    
    
    
    //MARK:- Custom Delegate Methods
    //MARK:-
    
    
    func popUpWaitingApprovalAction(type: Bool) {
        self.dismiss(animated: false, completion: nil)
        self.delegate!.popupYesNoPressed!(type: type)
    }
    
 
    
    @objc func disconnectedBYUser()
    {
        self.dismiss(animated: false) {
         appDelegate().activeCall.status = .Free
        }
        
    }
    
    
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        
       
        return false
    }
    
  

}
