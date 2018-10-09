//
//  WaitingToConnectVC.swift
//  LiveBait
//
//  Created by maninder on 1/30/18.
//  Copyright © 2018 Maninderjit Singh. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class WaitingToConnectVC: UIViewController {
 
    var delegate : MSAlertProtocol? = nil

    @IBOutlet weak var viewOuter: UIView!
    
    var viewLoader :  NVActivityIndicatorView!
    var userName : String = ""
 //   var callBackCancel : ((Bool) ->(Void))? = nil

    @IBOutlet weak var lblUserName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        
            let frame = CGRect(x: (ScreenWidth/2) - 70 , y: lblUserName.frame.origin.y + lblUserName.frame.size.height + 35
                , width: 70, height: 70)
         let type = NVActivityIndicatorType.ballSpinFadeLoader
   viewLoader =  NVActivityIndicatorView(frame: frame, type: type , color: APPThemeColor , padding: 0)
        
        
        self.viewOuter.addSubview(viewLoader)
        
            NotificationCenter.default.addObserver(self, selector: #selector(WaitingToConnectVC.dismissWaitingVCWithUserBusy), name: NSNotification.Name(rawValue: MSNotificationName.UserCallRejectedByOther.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WaitingToConnectVC.showCallConnectedView), name: NSNotification.Name(rawValue: MSNotificationName.CallAcceptedByUser.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WaitingToConnectVC.dismissWaitingVC), name: NSNotification.Name(rawValue: MSNotificationName.UserNotResponding.rawValue), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         viewLoader.startAnimating()
        lblUserName.text = "Please wait while \(userName) decides!!"
          showAlertWithAnimation(object: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionBtnCancelPressed(_ sender: UIButton)
    {
         viewLoader.stopAnimating()
        
        hideAlertWithAnimation(object: self) { (call) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.dismiss(animated: false, completion: nil)
              if self.delegate != nil
                {
                    self.delegate!.popUpWaitingAction!(type: false)
                }
            })
        }
    }
    @objc func showCallConnectedView()
    {
        hideAlertWithAnimation(object: self) { (call) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.dismiss(animated: false, completion: nil)
                if self.delegate != nil
                {
                    self.delegate!.popUpWaitingAction!(type: true)
                }
            })
        }
    }
    
    
    
@objc    func  dismissWaitingVC()
{
    viewLoader.stopAnimating()
    
    hideAlertWithAnimation(object: self) { (call) in
        DispatchQueue.main.async(execute: { () -> Void in
            self.dismiss(animated: false, completion: nil)
            if self.delegate != nil
            {
                self.delegate!.popUpWaitingAction!(type: false)
            }
        })
    }
    
    }
    
    @objc    func  dismissWaitingVCWithUserBusy()
    {
        viewLoader.stopAnimating()
        
        hideAlertWithAnimation(object: self) { (call) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.dismiss(animated: false, completion: nil)
                if self.delegate != nil
                {
                    self.delegate!.popUpUserBusy!()
                }
            })
        }
        
    }
    
}
