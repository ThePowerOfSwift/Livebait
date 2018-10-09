//
//  CommonOptionPopUp.swift
//  LiveBait
//
//  Created by maninder on 2/15/18.
//  Copyright © 2018 Maninderjit Singh. All rights reserved.
//

import UIKit

class CommonOptionPopUp: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var viewConatinder: UIView!
    
    var strMessage : String = ""
    var alertType : MSAlertType = .CommonAlert
    
    var delegate : MSAlertProtocol? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConatinder.cornerRadius(value: 5)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblTitle.text = strMessage
        //        btnDone.setTitle(strBtnTitle, for: .normal)
        showAlertWithAnimation(object: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
                    self.delegate!.popUpOptionAction!(type: true)
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
                    self.delegate!.popUpOptionAction!(type: false)
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
