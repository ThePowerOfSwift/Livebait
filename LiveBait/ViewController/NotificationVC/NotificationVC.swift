//
//  NotificationVC.swift
//  LiveBait
//
//  Created by maninder on 2/9/18.
//  Copyright © 2018 Maninderjit Singh. All rights reserved.
//

import UIKit
import SKPhotoBrowser


class NotificationVC: UIViewController,UITableViewDelegate,UITableViewDataSource,MSAlertProtocol
{

    @IBOutlet weak var tblNotifications: UITableView!
    var arrPhotos : [SKPhoto] = [SKPhoto]()

    var userToSave : User? = nil
    
    var arrayNotification : [LBNotification] = [LBNotification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        
        
        self.navigationController?.navigationBar.barTintColor = APPThemeColor
        self.navigationController?.navigationBar.isTranslucent = false

        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.isNavigationBarHidden = false
          self.navTitle(title:"Notifications" , color: .white , font:  FontBold(size: 18))
            self.navigationItem.hidesBackButton = true
        
            
            let barLeftButton:UIBarButtonItem = UIBarButtonItem.init(image:UIImage(named: "SideMenu"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(NotificationVC.leftMenuPressed))
            self.navigationItem.leftBarButtonItem = barLeftButton
        
        
        tblNotifications.registerNibsForCells(arryNib: ["ContactCell" , "LocationCell" , "ReportedCell"  ])
        tblNotifications.delegate = self
        tblNotifications.dataSource = self
        self.getNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0

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

    
    
    //MARK:- TableView Delegates
    //MARK:-
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayNotification.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
    let notificationElement = arrayNotification[indexPath.row]
        
        
        if notificationElement.notificationType == .LocationShared
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier:"LocationCell") as! LocationCell

            
            cell.assignLocationInfo(notificationPara: notificationElement)
            cell.callBackButton = { (notif : LBNotification) in
                
                let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapVC
                mapVC.userReceiver = notif.sender
                mapVC.mapType = .SharedLocation
                mapVC.locationToShare = notif.locationDetails
                self.navigationController?.pushViewController(mapVC, animated: true)
                
                
            }
            return cell
            
        }else if notificationElement.notificationType == .ContactShared
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:"ContactCell") as! ContactCell
            
            cell.assignContactInfo(notificationPara: notificationElement)
            cell.callBackButton = { (notif : LBNotification) in
                
                
                self.userToSave = notif.sender
                let alertVC = mainStoryBoard.instantiateViewController(withIdentifier: "CommonOptionPopUp") as! CommonOptionPopUp
                alertVC.view.alpha = 0
                alertVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
                alertVC.strMessage = "Do you want to save this user contact?"
                alertVC.delegate = self
                alertVC.modalPresentationStyle = .overCurrentContext
                self.present(alertVC, animated: false, completion: nil)
                
                
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier:"ReportedCell") as! ReportedCell
            cell.assignReportData(notificationPara: notificationElement)
            cell.callBackButton = { (notif : LBNotification) in
                
                self.arrPhotos.removeAll()
                
              //  let imageURL =  URL(string : notif.reportDetails)
                let imageNew = SKPhoto.photoWithImageURL(notif.reportDetails)
                self.arrPhotos.append(imageNew)
                let browser = SKPhotoBrowser(photos: self.arrPhotos)
                browser.initializePageIndex(indexPath.row)
                self.present(browser, animated: true, completion: nil)
                //let
                
                
                
            }
            return cell
            
        }
    }
    
    
    
    func getNotifications()
    {
        
        LoginManager.sharedInstance.getNotifications { (success, response, strError) in
            if success
            {
                if let arrayNotis = response as? [LBNotification]
                {
                    self.arrayNotification.append(contentsOf: arrayNotis)
                    self.tblNotifications.reloadData()
                }
                
            }else{
                
                showCustomAlert(message:  strError!, controller: self)
            }
        }
        
        
        
    }
    
    
    func popUpOptionAction(type: Bool) {
        if type == true
        {
            createAndSaveContact(userData: self.userToSave!)
           
        }
        
        
    }
 //   func
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
