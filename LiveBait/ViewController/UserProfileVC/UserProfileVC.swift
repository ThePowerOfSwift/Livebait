//
//  UserProfileVC.swift
//  LiveBait
//
//  Created by maninder on 12/15/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

enum ProfileList : Int {
    case Photos  = 0 ,
    Name,
    AboutUser,
    Occupation,
    Drink,
    Smoke,
   Nature,
    Kids
    
}


enum BtnStatus : Int {
    case RequestCall  = 0 ,
    AcceptCall
    
}

class UserProfileVC: UIViewController,UITableViewDelegate,UITableViewDataSource,MSAlertProtocol {
    @IBOutlet weak var btnLeftOption: UIButton!
    @IBOutlet weak var btnRightOption: UIButton!
    var userProfile : User = User()
    @IBOutlet weak var tblProfile: UITableView!
    var btnStatus : BtnStatus = .RequestCall
    
    
    var delegate : MSAlertProtocol? = nil
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
            self.navigationController?.isNavigationBarHidden = true
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        if userProfile.profileImageURL != "" {
            let img = LBImage(link: userProfile.profileImageURL)
            userProfile.userImages.insert(img, at: 0)
        }
        tblProfile.registerNibsForCells(arryNib: ["OtherUserProfileCell" , "UserProfileOptionCell" , "UserProfileNameCell" , "UserAboutCell" ])
        tblProfile.delegate = self
        tblProfile.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(UserProfileVC.newCallReceived), name: NSNotification.Name(rawValue: MSNotificationName.NewVideoCallRequest.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.showMapVC), name: NSNotification.Name(rawValue: MSNotificationName.MoveToMapVC.rawValue), object: nil)
        
       // UserCallDisconnectedByOther
        if btnStatus == .AcceptCall
        {
            btnLeftOption.setTitle("ACCEPT VIDEO CHAT", for: .normal)
            self.getUserInfo()
        }else{
            btnLeftOption.setTitle("VIDEO CHAT", for: .normal)
        }
        self.tblProfile.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionBtnBackPressed(_ sender: Any) {
        _ =  self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if appDelegate().activeCall.status == .Connected
        {
            appDelegate().callingView?.hideBlurView()
        }
    }
    
    @objc  func actionBtnBackPressed()
    {
        _ =  self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    //MARK:- TableView Delegates
    //MARK:-
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileList.Kids.rawValue + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
     
        switch indexPath.row
        {
            
        case ProfileList.Photos.rawValue:
           return ScreenWidth
        case  ProfileList.Name.rawValue :
            
                return 60
        case  ProfileList.AboutUser.rawValue :
            if userProfile.aboutInfo != ""
            {
                return (FontRegular(size: 15).sizeOfString(string: userProfile.aboutInfo, constrainedToWidth: Double(ScreenWidth - 30))).height + 65
            }else{
                return 55
            }
            
        case  ProfileList.Occupation.rawValue ,  ProfileList.Drink.rawValue , ProfileList.Smoke.rawValue , ProfileList.Kids.rawValue  , ProfileList.Nature.rawValue :
            return 50
            
        default:
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row
        {
        case ProfileList.Photos.rawValue:
            
            let cell = tableView.dequeueReusableCell(withIdentifier:"OtherUserProfileCell") as! OtherUserProfileCell
           
            cell.callBackBack = { (check : Bool) in
               _ = self.navigationController?.popViewController(animated: true)
            }
                cell.images = userProfile.userImages
            
            if userProfile.userImages.count <= 1
            {
                cell.pagingControl.isHidden = true
            }else{
                cell.pagingControl.isHidden = false
            }
            
            cell.pagingControl.numberOfPages = userProfile.userImages.count
                cell.collectionViewPhotos.reloadData()

                return cell
                
            
        case  ProfileList.Name.rawValue :
            let cell = tableView.dequeueReusableCell(withIdentifier:"UserProfileNameCell") as! UserProfileNameCell
            cell.assignUser(user: userProfile)
            return cell
            
        case  ProfileList.AboutUser.rawValue :
            let cell = tableView.dequeueReusableCell(withIdentifier:"UserAboutCell") as! UserAboutCell
            cell.lblAboutInfo.text = userProfile.aboutInfo
            return cell
            
        case  ProfileList.Occupation.rawValue :
            let cell = tableView.dequeueReusableCell(withIdentifier:"UserProfileOptionCell") as! UserProfileOptionCell
            cell.lblOptionName.text = "Occupation"
            cell.lblOptionValue.text  = userProfile.occupation
            cell.imgViewMarijuna.isHidden = true;

            return cell
            
        case  ProfileList.Drink.rawValue :
            let cell = tableView.dequeueReusableCell(withIdentifier:"UserProfileOptionCell") as! UserProfileOptionCell
            cell.lblOptionName.text = "Drink"
            cell.imgViewMarijuna.isHidden = true;
            cell.lblOptionValue.text  = userProfile.occupation
            if userProfile.drinkStatus == .Yes
            {
                cell.lblOptionValue.text  = "Yes"
            }else if userProfile.drinkStatus == .Socially
            {
                cell.lblOptionValue.text  = "Socially"
            }else {
                cell.lblOptionValue.text  = "Never"
            }
            
            return cell
        case  ProfileList.Smoke.rawValue :
           
                let cell = tableView.dequeueReusableCell(withIdentifier:"UserProfileOptionCell") as! UserProfileOptionCell
                cell.lblOptionName.text = "Smoke"
                cell.imgViewMarijuna.isHidden = true;

                if userProfile.smokeStatus == .Yes
                {
                    cell.lblOptionValue.text  = "Yes"
                    
                }else if userProfile.smokeStatus == .Socially
                {
                    cell.lblOptionValue.text  = "Socially"
                }else {
                    cell.lblOptionValue.text  = "Never"
                }

                
                return cell
          
         case  ProfileList.Nature.rawValue :
                let cell = tableView.dequeueReusableCell(withIdentifier:"UserProfileOptionCell") as! UserProfileOptionCell
                cell.lblOptionName.text = "420"
                cell.imgViewMarijuna.isHidden = false;

                if userProfile.natureStatus == .Friendly
                {
                    cell.lblOptionValue.text  = "Friendly"

                }else if userProfile.natureStatus == .Never
                {
                    cell.lblOptionValue.text  = "Unfriendly"
                }

                
                return cell
            
      case  ProfileList.Kids.rawValue :
                let cell = tableView.dequeueReusableCell(withIdentifier:"UserProfileOptionCell") as! UserProfileOptionCell
                cell.lblOptionName.text = "Kids"
                cell.imgViewMarijuna.isHidden = true;

                if userProfile.kidStatus == .Yes
                {
                    cell.lblOptionValue.text  = "Yes"
                }else
                {
                    cell.lblOptionValue.text  = "No"
                }
                return cell
            
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier:"UserProfileOptionCell") as! UserProfileOptionCell
            cell.isHidden = true
            return cell
        }
        
    }
    
    
    
    @IBAction func actionBtnVideoChat(_ sender: Any) {
        
        if userProfile.videoRequest == .No
        {
            showCustomAlert(message: ErrorMessage.UserCallRequestOff.rawValue , controller: self)
            return
        }
        
       if appDelegate().activeCall.status == .Free
        {
        if userProfile.videoRequest == .Yes
        {
            let login = "facebook_" + LoginManager.getMe.fbID
            let customDataDict  : [String : Any] = ["image" : LoginManager.getMe.profileImageURL , "user_id"  : LoginManager.getMe.userID , "fb_id" : LoginManager.getMe.fbID , "lat" : getLatString() , "lon" : getLongString()]
            let strJsonCustomData = getJSONString(paraObject: customDataDict)
            let dictCaller : [String : Any] = ["custom_data" :  strJsonCustomData , "full_name" : LoginManager.getMe.fullName , "id" : LoginManager.getMe.quickBloxID , "login" : login  , "password" : QBDetails.QBPassword]
            
            
            let receiver = "facebook_" + userProfile.fbID
            
            let customDataDictRec  : [String : Any] = ["image" : userProfile.profileImageURL , "user_id"  : userProfile.userID , "fb_id" : userProfile.fbID , "lat" : userProfile.latitude , "lon" : userProfile.longitude]
            let strJsonCustomRecData = getJSONString(paraObject: customDataDictRec)
            
            let dictReceiver : [String : Any] = ["custom_data" : strJsonCustomRecData , "full_name" : userProfile.fullName , "id" : userProfile.quickBloxID ,"login" : receiver  , "password" : QBDetails.QBPassword ]
            
            let payload = [ "message" : "Call request from \(LoginManager.getMe.fullName)" , "ios_badge" : "0" , "ios_sound" : "default"  , "caller" : getJSONString(paraObject: dictCaller) , "receiver" : getJSONString(paraObject: dictReceiver) ]
           
            do {
            
                let data = try JSONSerialization.data(withJSONObject: payload, options: JSONSerialization.WritingOptions.prettyPrinted)
                let dataString = String(data: data, encoding: .utf8)!
                let event = QBMEvent()
                event.notificationType = .push
                event.usersIDs =  userProfile.quickBloxID
                event.type = .oneShot
                event.message = dataString
                QBRequest.createEvent(event, successBlock: { (response, event) in
                    
                }) { (response) in
                    
                }
                
                var userQBID = NSNumber()
                if userProfile.quickBloxID != "" {
                    userQBID = NSNumber(value: Int(userProfile.quickBloxID)!)
                }
                
                let newSession = QBRTCClient.instance().createNewSession(withOpponents: [userQBID] , with: .video)
                 let userInfo :[String:String] =  ["caller" : getJSONString(paraObject: dictCaller) ,"receiver" : getJSONString(paraObject: dictReceiver)]
                newSession.startCall(userInfo)
                appDelegate().activeCall  =  VideoCall(statuNew: .Dailing , session: newSession, secondUser: userProfile)
                let waitingVC = self.storyboard?.instantiateViewController(withIdentifier: "WaitingToConnectVC") as! WaitingToConnectVC
                waitingVC.userName = userProfile.fullName
                waitingVC.delegate = self
                waitingVC.view.alpha = 0
                waitingVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
                let navigation = UINavigationController(rootViewController: waitingVC)
                navigation.isNavigationBarHidden = true
                navigation.modalPresentationStyle = .overCurrentContext
                self.present(navigation, animated: false, completion: nil)
            } catch {
                print("JSON serialization failed: ", error)
            }
            
        }else{
            showCustomAlert(message: ErrorMessage.UserCallRequestOff.rawValue , controller: self)
        }
        }
       else if appDelegate().activeCall.status == .WaitingForApproval {
        
        appDelegate().showCallConnected()

        }else if appDelegate().activeCall.status == .Connected
       {

        showCustomAlert(message: ErrorMessage.UserOnAnotherCall.rawValue, controller: self)

        }

 
    }

    @IBAction func actionBtnNotInterested(_ sender: UIButton) {
        
        
        if appDelegate().activeCall.status == .WaitingForApproval
        {
            appDelegate().activeCall.activeSession?.hangUp(nil)
            _ =  self.navigationController?.popViewController(animated: true)
            self.delegate?.popUpWaitingApprovalAction!(type : false)
        }else if appDelegate().activeCall.status  == .Free
        {
            LoginManager.sharedInstance.setNotInterested(userID: userProfile.userID, handler: { (success, response, strError) in
                if success
                {
                    _ =  self.navigationController?.popViewController(animated: true)
                }else{
                    showCustomAlert(message: strError! , controller: self)
                }
            })
        }
        appDelegate().activeCall.status = .Free
    }
    
    
    func getUserInfo()
    {
        self.userProfile.getOtherUserProfileInfo { (success, response, strError) in
            if success
            {
                self.userProfile = response as! User
                self.tblProfile.reloadData()
            }
        }
    }
    
    
    
    
    
    //MARK:- Call Notification Methods
    //MARK:-
   
    
    @objc func newCallReceived(notification : Notification)
  {
    if let userCalling = notification.object as? User
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
    
   @objc func myDailingCallAccepted()
    {
        
    }
    
    
@objc    func showCallConnectedView()
    {
        appDelegate().showCallConnected()
    }
    
  
    
    //MARK:- MSAlertDelegate Methods
    //MARK:-
    
    
    func popUpUserBusy() {
        let strMessage = userProfile.userName + ", has declined to accept your chat request."
        showCustomAlert(message: strMessage, controller: self)
    }
    
    
    
    func popUpWaitingAction(type: Bool) {
        if type == true
        {
            DispatchQueue.main.async {
                appDelegate().showCallConnected()
                appDelegate().activeCall.status = .Connected
            }
           
        }else{
            appDelegate().activeCall.activeSession?.hangUp(nil)
            self.navigationController?.popViewController(animated: true)
            appDelegate().activeCall.status = .Free
        }
    }
    
    
    func popupDonePressed(type: Any) {
        
    }
    
    func popupYesNoPressed(type: Any) {
        if let boolType = type as? Bool
        {
            if boolType == true
            {
                appDelegate().showCallConnected()
                appDelegate().activeCall.status = .Connected

            }else{
                appDelegate().activeCall.status = .Free
            }
        }
    }

    
    @objc func showMapVC(notification : Notification)
    {
        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        mapVC.userReceiver = appDelegate().activeCall.secondParty
        self.navigationController?.pushViewController(mapVC, animated: true)
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
