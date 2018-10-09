//
//  FilterVC.swift
//  LiveBait
//
//  Created by maninder on 12/13/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

enum FilterType : Int
{
    case FirstTime = 0
    case Regular = 1
}

class FilterVC: UIViewController,MSAlertProtocol {
    
    
    var filterType : FilterType = .Regular
    
    let maximumDistance : Float = 100
    let maximumAge : Float = 100
    let minimumAge : Float = 18

   // static NSInteger const SettingsAgeMaxValue = 60;
   // static NSInteger const SettingsAgeMinValue = 18;
    @IBOutlet var btnMale: UIButton!
    @IBOutlet var btnFemale: UIButton!
    @IBOutlet var btnDiverse: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet weak var rangeSliderDistance: NMRangeSlider!
    @IBOutlet weak var rangeSliderAge: NMRangeSlider!
    
    @IBOutlet weak var lblAge: UILabel!
    
    
    @IBOutlet weak var switchSoundVibration: UISwitch!
    
    @IBOutlet weak var switchPush: UISwitch!
    
    var filterSettings : MSFilter?  = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        self.navigationController?.navigationBar.barTintColor = APPThemeColor
        self.navigationController?.navigationBar.isTranslucent = false

    self.filterSettings = MSFilter()
        
        let btnLeftBar:UIBarButtonItem = UIBarButtonItem.init(image:UIImage(named: "BackWhite"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(FilterVC.actionBtnBackPressed))
        
        
        self.navigationItem.leftBarButtonItem = btnLeftBar
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navTitle(title: "Filter", color: UIColor.white , font:  FontBold(size: 18))
        self.rangeSliderDistance.lowerHandleHidden = true
    self.rangeSliderDistance.maximumValue = 1
        self.rangeSliderDistance.minimumRange = 0
        self.rangeSliderDistance.upperValue = Float(100/maximumDistance)

        
        
        self.rangeSliderAge.minimumValue = minimumAge/100
        self.rangeSliderAge.maximumValue =  maximumAge/100
        //maximumAge/100

        self.rangeSliderAge.upperValue =  Float(maximumAge/100)
        self.rangeSliderAge.lowerValue =  Float(minimumAge/100)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.newCallReceived), name: NSNotification.Name(rawValue: MSNotificationName.NewVideoCallRequest.rawValue), object: nil)
        
        
        
        

        MatchManager.getFilterSettings { (success, response, strError) in
            if success{
                self.filterSettings = response as? MSFilter
                self.setPreviousSettings()
                
            }else{
                
                showAlert(title: "LiveBait", message: strError!, controller: self)
            }
            
        }
        self.btnApply.cornerRadius(value: 4)

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
    
    
    
    
    func setPreviousSettings()
    {
        if filterSettings != nil
        {
       if (filterSettings?.datingType)!.count > 0
        {
            for element in (filterSettings?.datingType)!
            {
                if element == .GenderMale
                {
                      btnMale.isSelected = true
                   // self.actionBtnGenderPressed(btnMale)
                }else if element == .GenderFemale
                {
                    btnFemale.isSelected = true
                }else{
                    btnDiverse.isSelected = true
                }
            }
        }
            

            let distance = Float((self.filterSettings?.distance)!)
            self.rangeSliderDistance.upperValue =  distance/maximumDistance
            self.lblDistance.text = (self.filterSettings?.distance)!.description + " miles"
            
            
            
            
            let valAgeMinimum = (filterSettings?.minimumAge)!
            let valAgeMaximum = (filterSettings?.maximumAge)!
            print(Float(valAgeMaximum)/100)
            print(Float(valAgeMinimum/100))

      
            self.rangeSliderAge.upperValue = Float(valAgeMaximum)/100
            self.rangeSliderAge.lowerValue =   Float(valAgeMinimum)/100 ///Float(valAgeMinimum)
            self.lblAge.text = valAgeMinimum.description + " - " +   valAgeMaximum.description

            self.switchSoundVibration.isOn = (filterSettings?.vibration)!
            self.switchPush.isOn = (filterSettings?.pushNotification)!
        }
    }
    
    
    @objc  func actionBtnBackPressed()
    {
        _ =  self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func actionSliderDistance(_ sender: Any) {
        
        let intValu = Int(rangeSliderDistance.upperValue*100)
        self.lblDistance.text = intValu.description + " miles"
     self.filterSettings?.distance = intValu
        
        
    }
    
    @IBAction func actionSliderAge(_ sender: Any) {
        
        let ageMin = Int(rangeSliderAge.lowerValue*100)
        let ageMax = Int(rangeSliderAge.upperValue*100)
        self.lblAge.text = ageMin.description + " - " +   ageMax.description
       filterSettings?.maximumAge = ageMax
        filterSettings?.minimumAge = ageMin
        
    }
    
    
    @IBAction func actionSwitchValueChanged(_ sender: UISwitch) {
        if sender == switchSoundVibration
        {
            filterSettings?.vibration = !(filterSettings?.vibration)!
        }else{
            filterSettings?.pushNotification = !(filterSettings?.pushNotification)!
        }
    }
    
    
    
    @IBAction func actionBtnLikePressed(_ sender: Any) {
        let userFbURL =  "https://www.facebook.com/" + LoginManager.getMe.fbID
        openInAppBrowser(controller: self , link: userFbURL)
    }
    
    
    @IBAction func actionBtnGenderPressed(_ sender: UIButton) {

        
        if sender == btnMale
        {
            if btnMale.isSelected == true
            {
                let answer =  (self.filterSettings?.datingType)!.filter({$0.rawValue == 1})
                if answer.count > 0
                {
                      let indexSelected = (self.filterSettings?.datingType)!.index(of: answer[0])
                    (self.filterSettings!.datingType).remove(at: indexSelected!)
                }
            }else{
                (self.filterSettings!.datingType).append(.GenderMale)
            }
             btnMale.isSelected = !btnMale.isSelected
            
         //   self.filterSettings?.datingType = .GenderMale
        }else if sender == btnFemale
        {
            
            if btnFemale.isSelected == true
            {
                let answer =  (self.filterSettings?.datingType)!.filter({$0.rawValue == 2})
                if answer.count > 0
                {
                    let indexSelected = (self.filterSettings?.datingType)!.index(of: answer[0])
                    
                    (self.filterSettings!.datingType).remove(at: indexSelected!)
                }
            }else{
                
                (self.filterSettings!.datingType).append(.GenderFemale)
            }
            btnFemale.isSelected = !btnFemale.isSelected
        }else{
            
            
            if btnDiverse.isSelected == true
            {
                let answer =  (self.filterSettings?.datingType)!.filter({$0.rawValue == 3})
                if answer.count > 0
                {
                    let indexSelected = (self.filterSettings?.datingType)!.index(of: answer[0])
                    
                    (self.filterSettings!.datingType).remove(at: indexSelected!)
                }
            }else{
                
                (self.filterSettings!.datingType).append(.GenderDiverse)
            }
            btnDiverse.isSelected = !btnDiverse.isSelected
          
        }
        
    }
    
    
    @IBAction func actionBtnSavePressed(_ sender: Any) {
        
        MatchManager.saveFilterSettings(setting: filterSettings!) { (success, response, strError) in
            if success
            {
                if self.filterType == .Regular
                {
                    self.navigationController?.popViewController(animated: true)
                }else{
                  appDelegate().connectWithUserID()
                 openSideMenuController(navigation: self.navigationController!)
                }
             }else{
                
                showAlert(title: "LiveBait", message: strError!, controller: self)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
