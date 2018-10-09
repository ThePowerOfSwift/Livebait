//
//  WalkThroughVC.swift
//  LiveBait
//
//  Created by maninder on 11/16/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class WalkThroughVC: UIViewController,UIScrollViewDelegate {

    var widthForScrlView : CGFloat = 0
    @IBOutlet var scrlView: UIScrollView!
    
    @IBOutlet var pagingControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        widthForScrlView = scrlView.frame.size.width
        
       
        scrlView.delegate = self
        pagingControl.currentPage = 0
       // print(widthForScrlView)
       // scrlView.contentSize = CGSize(width: widthForScrlView * 2, height: scrlView.frame.size.height)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
        if (LoginManager.sharedInstance.getMeArchiver() != nil)
        {
            
            if LoginManager.getMe.alreadyRegistered == false
            {
                let landingVC =  self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
                landingVC.userProfile = LoginManager.getMe
                self.navigationController?.pushViewController(landingVC, animated: true)
            }else
            {
                openSideMenuController(navigation: self.navigationController!)
            }
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func actionBtnFacebookPressed(_ sender: Any)
    {
        let alert = UIAlertController(title: NSLocalizedString("Facebook Authentication", comment: ""), message: NSLocalizedString("We will access your public profile including your facebook's profile link, so that other users can visit your profile. Do you want to continue?", comment: ""), preferredStyle: .alert)
        let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) { (_) in
            FBManager.sharedInstance.currentUserProfile(viewController: self) { (isSuccess, response, error) in
                if isSuccess == false{
                    
                    return
                }else{
                    if let dictFB = response as? Dictionary <String , Any> {
                        var fullName = dictFB["first_name"] as! String
                        
                        if let lastName = dictFB["last_name"] as? String
                        {
                            fullName = fullName + " " + lastName
                        }
                        LoginManager.getMe.fullName = fullName
                        LoginManager.getMe.fbID = dictFB["id"] as! String
                        LoginManager.getMe.profileImageURL = "http://graph.facebook.com/\(LoginManager.getMe.fbID)/picture?type=large"
                        //                    if  (dictFB["gender"] as! String) == "male"
                        //                    {
                        //                       LoginManager.getMe.genderType = .GenderMale
                        //                    }else{
                        //                     LoginManager.getMe.genderType = .GenderFemale
                        //
                        //                     }
                        if let email =  dictFB["email"] as? String
                        {
                            LoginManager.getMe.email = email
                        }
                        if let link = dictFB["link"] as? String {
                            LoginManager.getMe.profile_url = link
                        }
                        self.registerWithFacebook()
                    }
                }
            }

        }
        
        let noAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .default, handler: nil)
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func registerWithFacebook()
    {
        LoginManager.sharedInstance.registerFB { (success, response, strError) in
            if success
            {
                if LoginManager.getMe.alreadyRegistered == false
                {
                    let landingVC =  self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
                    landingVC.userProfile = LoginManager.getMe
                    self.navigationController?.pushViewController(landingVC, animated: true)
                }else
                {
                    appDelegate().connectWithUserID()
                    openSideMenuController(navigation: self.navigationController!)
                }
            
            }else{
                showCustomAlert(message: strError! , controller: self)

            }
        }
    }
   
    
    
    //MARK:- ScrollView Delegates
    //MARK:-
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = scrollView.currentPage
    
        pagingControl.currentPage = currentPage
        // Do something with your page update
        print("scrollViewDidEndDragging: \(currentPage)")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            
            let currentPage = scrollView.currentPage
            print(currentPage)
            pagingControl.currentPage = currentPage
            // Do something with your page update
            print("scrollViewDidEndDragging: \(currentPage)")
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
     
  

}
extension UIScrollView {
    var currentPage: Int {
        return Int((self.contentOffset.x + (0.5*self.frame.size.width))/self.frame.width)
    }
}
