//
//  AddPhoneNoVC.swift
//  LiveBait
//
//  Created by maninder on 11/29/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AddPhoneNoVC: UIViewController,UITextFieldDelegate,CountryPickerDelegate{

    var codeSelected = String()
    var strMobileNumber = String()

    let pickerCountry : CountryPicker =  CountryPicker()
    @IBOutlet var btnVerify: UIButton!
    @IBOutlet var txtMobileNumber: UITextField!
    @IBOutlet var txtCode: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navTitle(title:"" , color: .white , font:  FontBold(size: 17))
        
        
        let barLeftButton:UIBarButtonItem = UIBarButtonItem.init(image:UIImage(named: "BackWhite"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddPhoneNoVC.leftBackPressed))
        self.navigationItem.leftBarButtonItem = barLeftButton
        
        
        let locale = Locale.current

       
        let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?

        pickerCountry.countryPickerDelegate = self
        pickerCountry.showPhoneNumbers = true
        print(code)
        pickerCountry.setCountry(code!)
         self.txtCode.inputView = pickerCountry
        
    
        
        
        if codeSelected != ""
        {
            
            if codeSelected.hasPrefix("+")
            {
                pickerCountry.setCountryByPhoneCode(codeSelected)

            }else{
             codeSelected = "+" +  codeSelected
                pickerCountry.setCountryByPhoneCode(codeSelected)

                
            }
        }
        txtMobileNumber.text = strMobileNumber
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc  func leftBackPressed()
    {
     _ =  self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func actionBtnVerify(_ sender: UIButton) {
        
    
        if  txtCode.text?.count == 0
        {
            
            showCustomAlert(message: ErrorMessage.CodeMissing.rawValue, controller: self)


        }else if txtMobileNumber.text?.count == 0 {
            showCustomAlert(message: ErrorMessage.PhoneNoMissing.rawValue, controller: self)
        }else
        {
            
            let strPhoneNumber = txtCode.text! + txtMobileNumber.text!
            
            SwiftLoader.show(true)
            PhoneAuthProvider.provider().verifyPhoneNumber(strPhoneNumber, uiDelegate: nil) { (verificationID, error) in
                SwiftLoader.hide()
                if let error = error {
                    showCustomAlert(message: error.localizedDescription , controller: self)

                    return
                }
                
                if let verificationId = verificationID as? String
                {
                    verificationCodeReceived = verificationId
                  //  userDefaults.set(verificationId, forKey: LocalKeys.VerificationID.rawValue)
                    DispatchQueue.main.async {
                    
                    let otpVC = self.storyboard?.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
                    otpVC.code = self.txtCode.text!
                    otpVC.mobileNo = self.txtMobileNumber.text!
                    self.navigationController?.pushViewController(otpVC, animated: true)
                   
                    }
                    
                }
                // Sign in using the verificationID and the code sent to the user
                // ...
            }
            
            
        }
        
        
        
        
        
    }
    
    // a picker item was selected
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        //pick up anythink
        self.txtCode.text = phoneCode
        
    }
    
   

}


