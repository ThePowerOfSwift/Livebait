//
//  OTPVC.swift
//  LiveBait
//
//  Created by maninder on 12/12/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class OTPVC: UIViewController {

    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var btnResend: UIButton!
    var code = String()
    var mobileNo = String()
    
    @IBOutlet var txtVerificationCode: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        
        
        self.navigationController?.navigationBar.barTintColor = APPThemeColor
        self.navigationController?.navigationBar.isTranslucent = false

        let btnLeftBar:UIBarButtonItem = UIBarButtonItem.init(image:UIImage(named: "BackWhite"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(OTPVC.actionBtnBackPressed))
        
       
        self.navigationItem.leftBarButtonItem = btnLeftBar
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navTitle(title: "Verification", color: UIColor.white , font:  FontBold(size: 18))
        btnSubmit.cornerRadius(value: 4)
        self.btnResend.underlineButton(text: "Resend verification code", font: FontRegular(size: 15))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     @objc func  actionBtnBackPressed()
     {
     self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionBtnSubmit(_ sender: UIButton) {
        
        if txtVerificationCode.text!.checkIsEmpty()
        {
            showCustomAlert(message: ErrorMessage.OTPMissing.rawValue, controller: self)
            return
        }
        
     else   if txtVerificationCode.text!.count != 6 {
            showCustomAlert(message:  ErrorMessage.OTPLengthMissing.rawValue , controller: self)

            return
            
        }
        
        let crdential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationCodeReceived,
                 verificationCode: txtVerificationCode.text!)
        
        SwiftLoader.show(true)
        Auth.auth().signIn(with: crdential) { (user, error) in
               SwiftLoader.hide()
            if let error = error {
                
                print(error.localizedDescription)
                // self.showMessagePrompt(error.localizedDescription)
                return
            }
            
          
                
         
                LoginManager.getMe.countryCode = self.code
                LoginManager.getMe.mobileVerified = true
                LoginManager.getMe.phoneNumber = self.mobileNo
            
           DispatchQueue.main.async {
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
            }
 
       }
            
            
    }
        
        
       

        
    
    
    
    @IBAction func actionResendVerificationCode(_ sender: UIButton) {
        
        let strPhoneNumber = code + mobileNo
         SwiftLoader.show(true)
        PhoneAuthProvider.provider().verifyPhoneNumber(strPhoneNumber, uiDelegate: nil) { (verificationID, error) in
            SwiftLoader.hide()
            if let error = error {
                
                print(error.localizedDescription)
                // self.showMessagePrompt(error.localizedDescription)
                return
            }
            
            if let verificationId = verificationID as? String
            {
                
                verificationCodeReceived = verificationId
                //  userDefaults.set(verificationId, forKey: LocalKeys.VerificationID.rawValue)
                 DispatchQueue.main.async {
                    showCustomAlert(message: ErrorMessage.CodeResent.rawValue, controller: self)

                }
                
            }
            // Sign in using the verificationID and the code sent to the user
            // ...
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
