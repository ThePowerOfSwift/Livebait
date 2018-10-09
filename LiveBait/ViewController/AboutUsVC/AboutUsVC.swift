//
//  AboutUsVC.swift
//  LiveBait
//
//  Created by maninder on 3/6/18.
//  Copyright © 2018 Maninderjit Singh. All rights reserved.
//

import UIKit


enum PageType : Int
{
    case AboutUs = 1
    case PrivacyPolicy = 2
    case Terms = 3
    
}

class AboutUsVC: UIViewController,MSAlertProtocol{

    @IBOutlet weak var viewContainer: UIView!
    var viewType : PageType = .AboutUs
    @IBOutlet weak var txtViewInformation: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)

        self.view.layoutIfNeeded()
        
        viewContainer.layer.cornerRadius = 7
        viewContainer.addAllSideShadow(maskToBounds: false)
        self.navigationController?.navigationBar.barTintColor = APPThemeColor
        self.navigationController?.navigationBar.isTranslucent = false

        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.isNavigationBarHidden = false
        
           NotificationCenter.default.addObserver(self, selector: #selector(AboutUsVC.newCallReceived), name: NSNotification.Name(rawValue: MSNotificationName.NewVideoCallRequest.rawValue), object: nil)
        if viewType == .AboutUs
        {
            self.navTitle(title:"About us" , color: .white , font:  FontBold(size: 18))
            
            self.txtViewInformation.text =
   "LiveBait is the world's first completely live interaction dating platform. Never wait for a response again! Video chat with people near you, in real time. No DM's, No Matching, No Catfish, and no Scams to geet you to Pay before utilizing the full features of the App!"
            
        }else {
            
            
             self.getGeneralInfo()
            self.navTitle(title:"Terms of Service" , color: .white , font:  FontBold(size: 18))
        }
        
        self.navigationItem.hidesBackButton = true
        
        
        let barLeftButton:UIBarButtonItem = UIBarButtonItem.init(image:UIImage(named: "SideMenu"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(AboutUsVC.leftMenuPressed))
        self.navigationItem.leftBarButtonItem = barLeftButton
        
        
       
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        
        if appDelegate().activeCall.status == .Connected
        {
            appDelegate().callingView?.hideBlurView()
        }
        
    }
    
    
    
    @objc func leftMenuPressed()
    {
        appDelegate().viewControllerSlider?.revealToggle(animated: true)
        
    }
    
    
    func getGeneralInfo()
    {
        LoginManager.sharedInstance.getGeneralInfo(type: viewType.rawValue) { (success, response, strError) in
            if success
            {
                self.txtViewInformation.text =  response as! String
                
            }else{
                
                showCustomAlert(message: strError!, controller: self)
            }
        }
    }
  
    
    
    @objc func newCallReceived(notification : Notification)
    {
        if let userCalling = notification.object as? User
        {
            DispatchQueue.main.async
                {
                    let newCallPopUp = mainStoryBoard.instantiateViewController(withIdentifier: "NewCallRequestVC") as! NewCallRequestVC
                    newCallPopUp.userOnCall = userCalling
                    newCallPopUp.delegate = self
                    newCallPopUp.view.alpha = 0
                    
                    newCallPopUp.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
                    let navigation = UINavigationController(rootViewController: newCallPopUp)
                    navigation.isNavigationBarHidden = true
                    navigation.modalPresentationStyle = .overCurrentContext
                    self.present(navigation, animated: false, completion: nil)
            }
        }
    }
    
    
    func popupYesNoPressed(type: Any) {
        
        if let boolType = type as? Bool
        {
            if boolType == true
            {
                appDelegate().activeCall.activeSession?.acceptCall( appDelegate().dictCaller)
                appDelegate().showCallConnected()
                appDelegate().activeCall.status = .Connected
            }else{
                appDelegate().activeCall.status = .Free
                appDelegate().activeCall.activeSession?.hangUp(nil)
            }
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
