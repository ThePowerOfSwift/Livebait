//
//  FeedBackVC.swift
//  LiveBait
//
//  Created by maninder on 4/3/18.
//  Copyright © 2018 Maninderjit Singh. All rights reserved.
//

import UIKit

class FeedBackVC: UIViewController,UITextViewDelegate,MSAlertProtocol{

    @IBOutlet weak var txtViewFeedBack: UITextView!
    var placeHolder = "Please share your experience."
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)

        self.view.layoutIfNeeded()
        
        viewContainer.layer.cornerRadius = 7
        viewContainer.addAllSideShadow(maskToBounds: false)
        btnSubmit.cornerRadius(value: 22)
        
        self.navigationController?.navigationBar.barTintColor = APPThemeColor
        self.navigationController?.navigationBar.isTranslucent = false

        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.isNavigationBarHidden = false
        
   
            self.navTitle(title:"Feedback" , color: .white , font:  FontBold(size: 18))
    
        self.navigationItem.hidesBackButton = true
        
        
        let barLeftButton:UIBarButtonItem = UIBarButtonItem.init(image:UIImage(named: "SideMenu"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(FeedBackVC.leftMenuPressed))
        self.navigationItem.leftBarButtonItem = barLeftButton
        
        txtViewFeedBack.delegate = self
        txtViewFeedBack.textColor = UIColor.lightGray
        txtViewFeedBack.text = placeHolder
        
        
         NotificationCenter.default.addObserver(self, selector: #selector(FeedBackVC.newCallReceived), name: NSNotification.Name(rawValue: MSNotificationName.NewVideoCallRequest.rawValue), object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func leftMenuPressed()
    {
        appDelegate().viewControllerSlider?.revealToggle(animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if appDelegate().activeCall.status == .Connected
        {
           appDelegate().callingView?.hideBlurView()
        }
        
    }
    
    
    @IBAction func actionBtnSubmitPressed(_ sender: UIButton) {
        
        if (txtViewFeedBack.text).removeEndingSpaces() == "" || txtViewFeedBack.text == placeHolder
        {
           
            showCustomAlert(message: ErrorMessage.FeedBackText.rawValue, controller: self)
            return
        }
        
        self.view.endEditing(true)
        LoginManager.sharedInstance.saveFeedBack(feedbackString: (txtViewFeedBack.text).removeEndingSpaces()) { (success, response, strError) in
            if success
            {
                let alertVC = mainStoryBoard.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                alertVC.view.alpha = 0
                alertVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
                alertVC.strMessage = "Thank you for your feedback."
                alertVC.modalPresentationStyle = .overCurrentContext
                alertVC.delegate = self
                
                self.present(alertVC, animated: false, completion: nil)
            }else{
                showCustomAlert(message: strError!, controller: self)
            }
        }
    }
    
    
    //MARK:- TextView Delegates
    //MARK:-
    
    
    
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if ((textView.text).removeEndingSpaces()) == "" || textView.text == placeHolder
        {
            textView.textColor = UIColor.lightGray
           
            txtViewFeedBack.text = placeHolder
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if  textView.text == placeHolder
        {
           
            textView.textColor = UIColor.black
            textView.text = ""
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count < 140;
      
    }
    
    
    //MARK:- MSAlertProtocol Methods
    //MARK:-
    
    
    func popupDonePressed(type: Any) {
          appDelegate().moveToDashBoard()
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
