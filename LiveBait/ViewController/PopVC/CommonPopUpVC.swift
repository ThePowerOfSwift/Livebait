//
//  CommonPopUpVC.swift
//  LiveBait
//
//  Created by maninder on 1/31/18.
//  Copyright © 2018 Maninderjit Singh. All rights reserved.
//



@objc protocol MSAlertProtocol {
    @objc optional func popupDonePressed(type : Any)
    
    @objc optional func popupYesNoPressed(type : Any)
    @objc optional func popUpWaitingAction(type : Bool)
    @objc optional func popUpWaitingApprovalAction(type : Bool)
    @objc optional func popUpOptionAction(type : Bool)
    @objc optional func popUpUserBusy()
    @objc optional func popupYesNoContactPressed(action : Bool)


  //  @objc optional func actionPreviousVC(action: Bool )
   // @objc optional func replaceRecords(obj : Any )
    
}

import UIKit

class CommonPopUpVC: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
  
    @IBOutlet weak var viewContainer: UIView!
    
    var strMessage : String = ""
    var alertType : MSAlertType = .CommonAlert
    
    var delegate : MSAlertProtocol? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblTitle.text = strMessage
        
//        btnDone.setTitle(strBtnTitle, for: .normal)
        showAlertWithAnimation(object: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
         viewContainer.cornerRadius(value: 5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionBtnOkPressed(_ sender: UIButton) {
        
        hideAlertWithAnimation(object: self) { (call) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.dismiss(animated: false, completion: nil)
                if self.delegate != nil
                {
                    self.delegate!.popupDonePressed!(type: self.alertType)
                }
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
