//
//  HomeVC.swift
//  LiveBait
//
//  Created by maninder on 11/27/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit


class HomeVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MSAlertProtocol {
    @IBOutlet var collectionView: UICollectionView!
    var arraUsers : [User] = [User]()
    
    @IBOutlet weak var imgViewMarijunaLeaf: UIImageView!
    @IBOutlet weak var lblNotice: UILabel!
    var btnChat : UIBarButtonItem!
    var barRightButton : UIBarButtonItem!

    var refreshControl = UIRefreshControl()

    var pageNo = 0
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.view.layoutIfNeeded()
        
        self.navigationController?.navigationBar.barTintColor = APPThemeColor
        self.navigationController?.navigationBar.isTranslucent = false

        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.isNavigationBarHidden = false
        
         let barLeftButton:UIBarButtonItem = UIBarButtonItem.init(image:UIImage(named: "SideMenu"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(HomeVC.leftBtnPressed))
        self.navTitle(title:"LIVE BAIT" , color: .white , font :  FontBold(size: 17))
        
        self.navigationItem.leftBarButtonItem = barLeftButton
        
        barRightButton = UIBarButtonItem.init(image:UIImage(named: "Settings"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(HomeVC.rightBtnPressed))
        
        
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedStringKey.font :  FontRegular(size: 15),
                NSAttributedStringKey.foregroundColor : UIColor.white,
                ], for: .normal)
        

        let nib = UINib(nibName: "UserGridCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "UserGridCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.groupTableViewBackground
        
        self.setUpUI()
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
 
        btnChat   = UIBarButtonItem.init(title: "3 Chats", style: UIBarButtonItemStyle.plain, target: self, action: #selector(HomeVC.chatBtnPressed))
        self.navigationItem.rightBarButtonItems = [ barRightButton , btnChat]
        self.navigationController?.isNavigationBarHidden = false
        self.getLatestLocalUsers()
        LoginManager.sharedInstance.getMyInfo { (success, response, strError) in
            if success
            {
                if LoginManager.getMe.monthlySubscribed == "1"{
                    self.btnChat.title = "unlimited"
                }else {
                    let totalChats = LoginManager.getMe.paidCalls + LoginManager.getMe.unPaidCalls
                    if totalChats > 1
                    {
                        self.btnChat.title =  totalChats.description + " Chats"
                    }
                    else{
                        self.btnChat.title =  totalChats.description + " Chat"
                    }
                }
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if appDelegate().activeCall.status == .Connected
        {
            appDelegate().callingView?.hideBlurView()
        }
        
    }
    
    //MARK:- Button Action Methods
    //MARK:-
    
    
    
    func setUpUI()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.getLatestLocalUsers), name: NSNotification.Name(rawValue: MSNotificationName.DidGetLocation.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.newCallReceived), name: NSNotification.Name(rawValue: MSNotificationName.NewVideoCallRequest.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.showMapVC), name: NSNotification.Name(rawValue: MSNotificationName.MoveToMapVC.rawValue), object: nil)
        
        if userDefaults.bool(forKey: LocalKeys.FirstWelcomeAlert.rawValue) == false
        {
            self.perform(#selector(HomeVC.showFirstTimeScreenShotAlert), with: nil, afterDelay: 2)
            userDefaults.set( true , forKey: LocalKeys.FirstWelcomeAlert.rawValue)
        }
        
        let stringComplete = NSMutableAttributedString(string: "Pull to refresh")
        let attributComplete : [NSAttributedStringKey : Any]  = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : FontBold(size: 16), NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue) : APPThemeColor  ]
        stringComplete.addAttributes(attributComplete, range: NSMakeRange(0, stringComplete.length))
        refreshControl.attributedTitle = stringComplete
        refreshControl.tintColor = APPThemeColor
        refreshControl.addTarget(self, action: #selector(getLatestLocalUsers), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
    }
    
    @objc func leftBtnPressed()
    {
         appDelegate().viewControllerSlider?.revealToggle(animated: true)
    }
    
    @objc func chatBtnPressed()
    {
        let purchaseVC = mainStoryBoard.instantiateViewController(withIdentifier: "BuyChatVC") as! BuyChatVC
        self.navigationController?.pushViewController(purchaseVC, animated: true)
    }
    
   
    @objc func rightBtnPressed()
    {
       let filterVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
     self.navigationController?.pushViewController(filterVC, animated: true)

        
    }
    
    //MARK:- CollectionView Delegates
    //MARK:-
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arraUsers.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserGridCell", for: indexPath) as! UserGridCell
       cell.setUserInfo(user: arraUsers[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: (collectionView.frame.width/2), height: collectionView.frame.width/2 + 50)
        return size
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let profileVC =  self.storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
         profileVC.userProfile = arraUsers[indexPath.row]
         self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    
    //MARK:- API Methods
    //MARK:-
    
    @objc func getLatestLocalUsers()
    {
           if appDelegate().currentLocation != nil
            {
                MatchManager.sharedInstance.getLocalUsers(pageNo: 0) { (success, response, strError) in
                    if self.refreshControl.isRefreshing == true
                    {
                        self.refreshControl.endRefreshing()
                    }
                    if success
                    {
                        self.arraUsers.removeAll()
                        if let users = response as? [User]
                        {
                            self.arraUsers.append(contentsOf: users)
                            self.collectionView.reloadData()
                        }
                        if  self.arraUsers.count == 0
                        {
                            self.lblNotice.isHidden = false
                            self.imgViewMarijunaLeaf.isHidden = true
                        }else{
                            self.lblNotice.isHidden = true
                            self.imgViewMarijunaLeaf.isHidden = true
                        }
                    }
                    else{
                        showCustomAlert(message: strError!, controller: self)
                    }
                }
            }
    }
    
    
    //MARK:- Notification Methods
    //MARK:-
    
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
    
    
    //MARK:- MapVC Notification
    //MARK:-
    
    @objc func showMapVC(notification : Notification)
    {
        appDelegate().hideCallingView()
        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        mapVC.userReceiver = appDelegate().activeCall.secondParty
        self.navigationController?.pushViewController(mapVC, animated: true)
     }
    
    
    @objc func showFirstTimeScreenShotAlert()
    {
        if appDelegate().viewControllerSlider?.frontViewPosition == FrontViewPosition.right
        {
            appDelegate().viewControllerSlider?.revealToggle(animated: true)
        }
        showCustomAlert(message: "Take a screenshot to flag any inappropriate behavior and it will be sent to admininstration for review." , controller: self)
    }

}
