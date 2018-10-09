//
//  LeftMenuVC.swift
//  LiveBait
//
//  Created by maninder on 11/27/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

enum MSSelectedTab : Int {
 
   case Dashboard ,
    Notifications ,
     About ,
     Terms ,
    Share,
    Feedback,
     Logout ,
    EditProfile
}

class LeftMenuVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var imgViewUser: UIImageView!
    
    let optionImages : [UIImage] = [#imageLiteral(resourceName: "Home") , #imageLiteral(resourceName: "Notification") ,#imageLiteral(resourceName: "About") ,#imageLiteral(resourceName: "Terms") ,#imageLiteral(resourceName: "Share"), #imageLiteral(resourceName: "FeedBack") , #imageLiteral(resourceName: "LogOut")]
    
    let optionSelectedImages : [UIImage] = [#imageLiteral(resourceName: "HomeActive") , #imageLiteral(resourceName: "NotificationActive") ,  #imageLiteral(resourceName: "AboutSelected") , #imageLiteral(resourceName: "TermSelected") ,#imageLiteral(resourceName: "ShareActive") ,#imageLiteral(resourceName: "FeedBackActive") , #imageLiteral(resourceName: "LogOut") ]
    
    let arrayTitles : [String] = ["Home"  , "Notifications"  , "About Us" , "Terms of Service", "Share" , "Feedback" , "Logout"]

    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet var tblOption: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layoutIfNeeded()
        tblOption.registerNibsForCells(arryNib: ["OptionCell"])
        tblOption.delegate = self
       tblOption.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.tblOption.reloadData()
        self.bgView.cornerRadius(value:  self.bgView.frame.size.width/2)
        self.imgViewUser.cornerRadius(value:  self.imgViewUser.frame.size.width/2)
      
        self.lblUserName.text = LoginManager.getMe.fullName
        self.imgViewUser.sd_setImage(with: URL(string : LoginManager.getMe.profileImageURL ), placeholderImage: userPlaceHolder)
    }
    @IBAction func actionBtnEditProfile(_ sender: Any) {
        
        if appDelegate().selectedTab == MSSelectedTab(rawValue: 7)!
        {
            appDelegate().viewControllerSlider?.setFrontViewPosition(.left, animated: true)
            return;
            
        }else{
            appDelegate().selectedTab = MSSelectedTab(rawValue: 7)!
            
            let  editVC = mainStoryBoard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
            editVC.userProfile = LoginManager.getMe
            editVC.profileType = .EditProfile
            let navigation = UINavigationController(rootViewController: editVC)
                appDelegate().viewControllerSlider?.setFront(navigation, animated: true)
                appDelegate().viewControllerSlider?.setFrontViewPosition(.left, animated: true)
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTitles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"OptionCell") as! OptionCell
        
        
        cell.lblOptionTitle.text = arrayTitles[indexPath.row]
        
        if appDelegate().selectedTab.rawValue  == indexPath.row{
            cell.imgViewOption.image = optionSelectedImages[indexPath.row]
            cell.lblOptionTitle.textColor = APPThemeColor
        }else{
            cell.imgViewOption.image = optionImages[indexPath.row]
            cell.lblOptionTitle.textColor = .darkGray
        }
        

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        DispatchQueue.main.async {
            
            let selected: MSSelectedTab = MSSelectedTab(rawValue: indexPath.row )!
            
            if appDelegate().selectedTab == selected {
                appDelegate().viewControllerSlider?.setFrontViewPosition(.left, animated: true)
                return;
            }

            var navigation : UINavigationController!
            if indexPath.row == 0 {
                let  mainVC = mainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                
                navigation = UINavigationController(rootViewController: mainVC)
                appDelegate().viewControllerSlider?.setFront(navigation, animated: true)
                appDelegate().selectedTab = MSSelectedTab(rawValue: indexPath.row)!
                appDelegate().viewControllerSlider?.setFrontViewPosition(.left, animated: true)
            }else if indexPath.row == 1
            {
                let  notificationVC = mainStoryBoard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
                navigation = UINavigationController(rootViewController: notificationVC)
                appDelegate().viewControllerSlider?.setFront(navigation, animated: true)
                appDelegate().selectedTab = MSSelectedTab(rawValue: indexPath.row)!
               
                appDelegate().viewControllerSlider?.setFrontViewPosition(.left, animated: true)

                
            }  else if indexPath.row == 2 {
                
                
                let  aboutUs = mainStoryBoard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
                aboutUs.viewType = .AboutUs
                navigation = UINavigationController(rootViewController: aboutUs)
                appDelegate().viewControllerSlider?.setFront(navigation, animated: true)
                appDelegate().selectedTab = MSSelectedTab(rawValue: indexPath.row)!
                
                appDelegate().viewControllerSlider?.setFrontViewPosition(.left, animated: true)
                
                
                
                    
                }else if indexPath.row == 3 {
                
                let  aboutUs = mainStoryBoard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
                aboutUs.viewType = .Terms
                
                
                navigation = UINavigationController(rootViewController: aboutUs)
                appDelegate().viewControllerSlider?.setFront(navigation, animated: true)
                appDelegate().selectedTab = MSSelectedTab(rawValue: indexPath.row)!
                appDelegate().viewControllerSlider?.setFrontViewPosition(.left, animated: true)
                
                  //
                
            }else if indexPath.row == 4 {
               
                appDelegate().viewControllerSlider?.setFrontViewPosition(.left, animated: true)
                 self.shareSheet()
            }
            else if indexPath.row == 5 {
                let  feedBackVC = mainStoryBoard.instantiateViewController(withIdentifier: "FeedBackVC") as! FeedBackVC
                navigation = UINavigationController(rootViewController: feedBackVC)
                appDelegate().viewControllerSlider?.setFront(navigation, animated: true)
                appDelegate().selectedTab = MSSelectedTab(rawValue: indexPath.row)!
                appDelegate().viewControllerSlider?.setFrontViewPosition(.left, animated: true)
             
            }
            else if indexPath.row == 6 {

                
                LoginManager.sharedInstance.logout(handler: { (success, response, strError) in
                        getOutOfApp()
                   
                })
             }
        }
    }
    
    
    func shareSheet()
    {
        
        let messageString = "Use LiveBait for Vidoe chat."
        let items : [Any] = [messageString]
    
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)

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
