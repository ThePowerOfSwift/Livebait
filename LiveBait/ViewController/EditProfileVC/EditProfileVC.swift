//
//  EditProfileVC.swift
//  LiveBait
//
//  Created by maninder on 11/30/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit
import Photos


enum ProfileType : Int
{
    case CompleteProfile = 0
    case EditProfile = 1
}

enum ImageType : Int
{
    case ProfileImage = 0
    case NormalImage = 1
}

class EditProfileVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,MSAlertProtocol {
    @IBOutlet weak var btnVerifiedStatus: UIButton!
    @IBOutlet var txtCountryCode: UITextField!
    @IBOutlet var txtUserName: UITextField!
    
    @IBOutlet weak var txtEmailAddress: UITextField!
    
    
    var agePicker = UIPickerView()
    let placeHolder = "Write something about you"
    var profileType : ProfileType = .CompleteProfile
    @IBOutlet var txtViewHeading: UITextView!
    @IBOutlet var txtFullName: UITextField!
    @IBOutlet var txtAge: UITextField!
    @IBOutlet var txtMobileNo: UITextField!
    @IBOutlet var btnMale: UIButton!
    @IBOutlet var btnFemale: UIButton!
    @IBOutlet var btnDiverse: UIButton!
    @IBOutlet var txtOccupation: UITextField!
    @IBOutlet var collectionViewPics: UICollectionView!
    @IBOutlet var btnDrinkYes: UIButton!
    @IBOutlet var btnDrinkSocially: UIButton!
    @IBOutlet var btnDrinkNEver: UIButton!
    @IBOutlet var btnSmokeYes: UIButton!
    @IBOutlet var btnSmokeSocially: UIButton!
    @IBOutlet var btnSmokeNever: UIButton!
    @IBOutlet var btn420Friendly: UIButton!
    @IBOutlet var btn420Never: UIButton!
    @IBOutlet var btnKidsYes: UIButton!
    @IBOutlet var btnKidsNo: UIButton!
    @IBOutlet var BtnVideoCallYes: UIButton!
    @IBOutlet var btnVideoNo: UIButton!
    @IBOutlet var btnAccountUpgrade: UIButton!
    @IBOutlet var btnSave: UIButton!

    var imgType : ImageType = .NormalImage
    
    var userProfile = User()
    
    let ageLimit : [Int] = [18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100]
    @IBOutlet weak var imgViewProfile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layoutIfNeeded()
        
        self.navigationController?.navigationBar.barTintColor = APPThemeColor
        self.navigationController?.navigationBar.isTranslucent = false

        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.isNavigationBarHidden = false
        
        if   profileType == .CompleteProfile
        {
            
            self.navTitle(title:"Complete Profile" , color: .white , font:  FontBold(size: 18))
            btnSave.setTitle("DONE",for: .normal)
            self.navigationItem.hidesBackButton = true
        }else{
            
            self.navTitle(title:"Edit Profile" , color: .white , font:  FontBold(size: 18))
            
            btnSave.setTitle("SAVE CHANGES",for: .normal)

            let barLeftButton:UIBarButtonItem = UIBarButtonItem.init(image:UIImage(named: "SideMenu"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(EditProfileVC.leftMenuPressed))
            self.navigationItem.leftBarButtonItem = barLeftButton
        }
        collectionViewPics.registerCollectionNibs(arryNib: ["StoryCell" , "AddImageCell" ])
        collectionViewPics.delegate = self
        collectionViewPics.dataSource = self

        
        
        btnAccountUpgrade.cornerRadius(value: 3)
        btnAccountUpgrade.cornerRadius(value: 3)
        btnDrinkYes.cornerRadius(value: 3)
        btnDrinkNEver.cornerRadius(value: 3)
        btnDrinkSocially.cornerRadius(value: 3)
        btnSmokeYes.cornerRadius(value: 3)
        btnSmokeSocially.cornerRadius(value: 3)
        btnSmokeNever.cornerRadius(value: 3)
        
        btn420Friendly.cornerRadius(value: 3)
        btn420Never.cornerRadius(value: 3)
        btnKidsYes.cornerRadius(value: 3)
        btnKidsNo.cornerRadius(value: 3)
        BtnVideoCallYes.cornerRadius(value: 3)
        btnVideoNo.cornerRadius(value: 3)
        btnSave.cornerRadius(value: 4)

        
        
        txtViewHeading.delegate = self
        agePicker.delegate = self
        agePicker.dataSource = self
        
        
        if userProfile.aboutInfo == ""
        {
            self.txtViewHeading.text = placeHolder
            self.txtViewHeading.textColor = .lightGray
        }else{
            self.txtViewHeading.text = userProfile.aboutInfo
            self.txtViewHeading.textColor = .black
        }
        
        if userProfile.genderType == .GenderMale
        {
            self.actionBtnGenderPressed(self.btnMale)
        }else if userProfile.genderType == .GenderFemale
        {
            self.actionBtnGenderPressed(self.btnFemale)
        }else{
            self.actionBtnGenderPressed(self.btnDiverse)
        }
        
        
        if userProfile.drinkStatus == .Yes
        {
            self.actionBtnDrinksPressed(self.btnDrinkYes)
        }else if userProfile.drinkStatus == .Never
        {
            self.actionBtnDrinksPressed(self.btnDrinkNEver)
        }else{
            self.actionBtnDrinksPressed(self.btnDrinkSocially)
        }
        
        if userProfile.smokeStatus == .Yes
        {
            self.actionBtnSmokePressed(self.btnSmokeYes)
        }else if userProfile.smokeStatus == .Never
        {
            self.actionBtnSmokePressed(self.btnSmokeNever)
        }else{
            self.actionBtnSmokePressed(self.btnSmokeSocially)
        }
        
        if userProfile.kidStatus == .Yes
        {
            self.actionBtnKidsPressed(self.btnKidsYes)
        }else
        {
            self.actionBtnKidsPressed(self.btnKidsNo)
        }
        
        if userProfile.natureStatus == .Friendly
        {
            self.actionBtn420Pressed(self.btn420Friendly)
        }else
        {
            self.actionBtn420Pressed(self.btn420Never)
        }
        
        if userProfile.videoRequest == .Yes
        {
            self.actionBtnVideoChatPressed(self.BtnVideoCallYes)
        }else
        {
            self.actionBtnVideoChatPressed(self.btnVideoNo)
        }
        
        
            self.txtFullName.text = self.userProfile.fullName
        
        if userProfile.age != 0
        {
            print(userProfile.age)
            self.txtAge.text = userProfile.age.description
            let index = ageLimit.index(of: userProfile.age)
            self.agePicker.selectRow(index!, inComponent: 0, animated: false)
            
        }
        
            self.txtMobileNo.text = userProfile.phoneNumber
            self.txtOccupation.text = userProfile.occupation
            self.txtUserName.text = userProfile.userName
            self.txtEmailAddress.text = userProfile.email
        imgViewProfile.cornerRadius(value: 31)
        
        userProfile.profileImage = LBImage(link: userProfile.profileImageURL)
        
        let profilePic = URL(string : userProfile.profileImageURL)
        imgViewProfile.sd_setImage(with: profilePic, placeholderImage: userPlaceHolder )
        
        txtAge.inputView = agePicker
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileVC.newCallReceived), name: NSNotification.Name(rawValue: MSNotificationName.NewVideoCallRequest.rawValue), object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.txtMobileNo.text = LoginManager.getMe.phoneNumber
        self.txtCountryCode.text = LoginManager.getMe.countryCode
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if appDelegate().activeCall.status == .Connected
        {
            appDelegate().callingView?.hideBlurView()
        }
        
    }
    
    
    //MARK:- Button Actions
    //MARK:-
    
  @objc  func leftMenuPressed()
    {
        appDelegate().viewControllerSlider?.revealToggle(animated: true)
    }
    
    
    
    @IBAction func actionBtnGenderPressed(_ sender: UIButton) {
        
        btnMale.isSelected = false
        btnDiverse.isSelected = false
        btnFemale.isSelected = false


        if sender == btnMale
        {
            btnMale.isSelected = true
            userProfile.genderType = .GenderMale
            
        }else if sender == btnFemale
        {
            btnFemale.isSelected = true
            userProfile.genderType = .GenderFemale

        }else{
            btnDiverse.isSelected = true
            userProfile.genderType = .GenderDiverse
        }
        
    }
    
    
    
    @IBAction func actionBtnDrinksPressed(_ sender: UIButton) {
        
        btnDrinkYes.setTitleColor(.black, for: .normal)
        btnDrinkSocially.setTitleColor(.black, for: .normal)
        btnDrinkNEver.setTitleColor(.black, for: .normal)
        
        
        btnDrinkYes.backgroundColor = .lightGray
        btnDrinkSocially.backgroundColor = .lightGray
        btnDrinkNEver.backgroundColor = .lightGray
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = APPThemeColor
        
        if sender == btnDrinkYes
        {
            userProfile.drinkStatus = .Yes
        }else if sender == btnDrinkSocially
        {
            userProfile.drinkStatus = .Socially
        }else{
            userProfile.drinkStatus = .Never
        }
    }
    
    
    
    @IBAction func actionBtnSmokePressed(_ sender: UIButton) {
        
        btnSmokeYes.setTitleColor(.black, for: .normal)
        btnSmokeSocially.setTitleColor(.black, for: .normal)
        btnSmokeNever.setTitleColor(.black, for: .normal)
        
        btnSmokeYes.backgroundColor = .lightGray
        btnSmokeSocially.backgroundColor = .lightGray
        btnSmokeNever.backgroundColor = .lightGray
        
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = APPThemeColor
        
        if sender == btnSmokeYes
        {
            
            userProfile.smokeStatus = .Yes
        }else if sender == btnSmokeSocially
        {
            userProfile.smokeStatus = .Socially
        }else{
            userProfile.smokeStatus = .Never
        }
        
    }
    
    
    @IBAction func actionBtn420Pressed(_ sender: UIButton) {
        
        
        btn420Friendly.setTitleColor(.black, for: .normal)
        btn420Never.setTitleColor(.black, for: .normal)
        
        btn420Friendly.backgroundColor = .lightGray
        btn420Never.backgroundColor = .lightGray
        
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = APPThemeColor
        
        if sender == btn420Friendly
        {
            userProfile.natureStatus = .Friendly
        }else
        {
            userProfile.natureStatus = .Never
        }
        
    }
    
    
    @IBAction func actionBtnKidsPressed(_ sender: UIButton) {
        
        
        btnKidsNo.setTitleColor(.black, for: .normal)
        btnKidsYes.setTitleColor(.black, for: .normal)
        btnKidsYes.backgroundColor = .lightGray
        btnKidsNo.backgroundColor = .lightGray
        
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = APPThemeColor
        
        if sender == btnKidsYes
        {
            
            userProfile.kidStatus = .Yes
        }else
        {
            userProfile.kidStatus = .No
        }
    }
    
    @IBAction func actionBtnVideoChatPressed(_ sender: UIButton) {
        
        
        BtnVideoCallYes.setTitleColor(.black, for: .normal)
        btnVideoNo.setTitleColor(.black, for: .normal)
        
        BtnVideoCallYes.backgroundColor = .lightGray
        btnVideoNo.backgroundColor = .lightGray
        
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = APPThemeColor
        
        if sender == BtnVideoCallYes
        {
            userProfile.videoRequest = .Yes
        }else
        {
            userProfile.videoRequest = .No
        }
        
    }
    
    @IBAction func actionBtnUpgradePressed(_ sender: UIButton) {
        
        let purchaseVC = mainStoryBoard.instantiateViewController(withIdentifier: "BuyChatVC") as! BuyChatVC
        self.navigationController?.pushViewController(purchaseVC, animated: true)
        
    }
    
    @IBAction func actionBtnVerifyMobileNo(_ sender: Any) {
        
        
        
        
    }
    
    @IBAction func actionBtnEnterMobileNo(_ sender: UIButton) {
        
        let mobileVC = mainStoryBoard.instantiateViewController(withIdentifier: "AddPhoneNoVC") as! AddPhoneNoVC
        mobileVC.strMobileNumber = txtMobileNo.text!
        mobileVC.codeSelected = txtCountryCode.text!
        self.navigationController?.pushViewController(mobileVC, animated: true)
        
    }
    
    
    @IBAction func actionBtnDonePressed(_ sender: UIButton) {
        
    
        if txtViewHeading.text!.removeEndingSpaces() == "" || txtViewHeading.text! == placeHolder
        {
            
            showCustomAlert(message: ErrorMessage.HeadingMissing.rawValue , controller: self)

            return
        }
        else if (txtFullName.text!.removeEndingSpaces()).count == 0
        {
            showCustomAlert(message: ErrorMessage.FullNameMissing.rawValue , controller: self)

            return
        }
        else if (txtUserName.text!.removeEndingSpaces()).count == 0
        {
            showCustomAlert(message: ErrorMessage.UserNameMissing.rawValue , controller: self)
            return
        }else if (txtEmailAddress.text!.removeEndingSpaces()).count == 0
        {
            showCustomAlert(message: ErrorMessage.EmailMissing.rawValue , controller: self)
            return
        }else if  txtEmailAddress.text!.isValidEmail() == false
        {
            showCustomAlert(message: ErrorMessage.EmailValidation.rawValue , controller: self)
            return
            
        }else if   (txtAge.text!.removeEndingSpaces()).count == 0
        {
            showCustomAlert(message: ErrorMessage.AgeMissing.rawValue , controller: self)
            return
        }
        else if   (txtOccupation.text!.removeEndingSpaces()).count == 0
        {
            showCustomAlert(message: ErrorMessage.OccupationMissing.rawValue , controller: self)
            return
        }
        
        
        userProfile.aboutInfo = txtViewHeading.text!.removeEndingSpaces()
        userProfile.fullName = txtFullName.text!.removeEndingSpaces()
        userProfile.userName = txtUserName.text!.removeEndingSpaces()
        userProfile.email = txtEmailAddress.text!.removeEndingSpaces()
        userProfile.countryCode = txtCountryCode.text!
        userProfile.phoneNumber = txtMobileNo.text!
        userProfile.occupation = txtOccupation.text!.removeEndingSpaces()
        userProfile.age = Int(txtAge.text!)!
        
        if userProfile.phoneNumber != ""
        {
            userProfile.mobileVerified = true
        }else{
            userProfile.mobileVerified = false
        }
        
        LoginManager.sharedInstance.saveProfile(user: userProfile) { (success, response, strError) in
            if success
            {
                if   self.profileType == .CompleteProfile
                {
                    let filterVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
                    filterVC.filterType = .FirstTime
                    self.navigationController?.pushViewController(filterVC, animated: true)
                    
               // openSideMenuController(navigation: self.navigationController!)
                }else{
                    
                   appDelegate().moveToDashBoard()
                }
            }else
            {
                showCustomAlert(message:  strError! , controller: self)

            }
        }
        
    }
    
    
    
    //MARK:- UICollectionView Delegates
    //MARK:-
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddImageCell", for: indexPath) as! AddImageCell
            
        let widthFotCell = CGFloat(66)
            cell.viewWhite.cornerRadius(value: (widthFotCell - 4 )/2)
            cell.callbackAddImage = { (test : Bool) in
                   self.imgType = .NormalImage
                self.openImageSelection()
            }
            return cell
        }else{
            
     
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryCell", for: indexPath) as! StoryCell
        
        let widthFotCell = CGFloat(66)
            cell.viewWhite.cornerRadius(value: (widthFotCell - 4 )/2)
            cell.assignMyImage(image: userProfile.userImages[indexPath.row - 1])
        return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return userProfile.userImages.count + 1
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: 70, height: 70)
//        return CGSize(width: (self.collectionViewPics.frame.size.width)/4, height: (self.collectionViewPics.frame.size.width)/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        
        if indexPath.row > 0
        {
            
               self.getImagesArray(selectedIndex: indexPath.row)

            
        }
        
        
//        if indexPath.row == 0 {
//            self.openImageSelection()
//        }
        
//        let chat = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
//        chat.secondUser = appDelegate().matchedUser[indexPath.row]
//        self.navigationController?.pushViewController(chat, animated: true)
        
        
    }
    
    
    func getImagesArray(selectedIndex : Int)
    {
        
        if  userProfile.userImages.count > 0
        {
        
            let latestIndex = selectedIndex - 1
        
            var photos : [INSPhotoViewable] = [INSPhotoViewable]()
        for item in  userProfile.userImages
        {
            if item.serverImage == true
            {
             let imageServer = INSPhoto(imageURL: item.serverURL , thumbnailImage: userPlaceHolder )
                imageServer.isDeletable = true
                photos.append(imageServer)
                
                
            }else{
               let imageLcoal = INSPhoto(image:   item.file , thumbnailImage: userPlaceHolder)
                imageLcoal.isDeletable = true
                photos.append(imageLcoal)
            }
        }
            
            let currentPhoto = photos[latestIndex]
            let galleryPreview = INSPhotosViewController(photos: photos, initialPhoto: currentPhoto, referenceView: nil)
            
            galleryPreview.referenceViewForPhotoWhenDismissingHandler = {  photo in

               return nil
            }
            
            galleryPreview.profilePhotoHandler = { photo in
                
                if let index = photos.index(where: {$0 === photo}) {
                    
                    let imageSetting = self.userProfile.userImages[index]
                    self.userProfile.profileImage = imageSetting
                    if imageSetting.serverImage == true{
                        self.imgViewProfile.sd_setImage(with: imageSetting.serverURL , placeholderImage: userPlaceHolder )

                    }else{
                        self.imgViewProfile.image = imageSetting.file
                    }
                    
                }
            }
            galleryPreview.deletePhotoHandler = { photo in
                                if let index = photos.index(where: {$0 === photo}) {
                                    print(index + 1)
                                    self.userProfile.userImages.remove(at: index )
                                    self.collectionViewPics.reloadData()
                                }
                
            }
            
            
            present(galleryPreview, animated: true, completion: nil)
        }
        
    }
    
    
    
    //MARK:- TextView Delegates
    //MARK:-
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.removeEndingSpaces() == "" ||  textView.text == placeHolder
        {
            textView.text = ""
            textView.textColor = .black
        }else{
            textView.textColor = .black
        }
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.removeEndingSpaces() == ""
        {
            textView.text = placeHolder
            textView.textColor = .lightGray
        }else{
            textView.textColor = .black
        }
    }
    
    
    
    
    
    //MARK:- Select Photo
    //MARK:-
    @IBAction func actionBtnChangeProfileImage(_ sender: UIButton) {
        imgType = .ProfileImage
        actionSheet(btnArray: ["Camera" , "Gallery"], cancel: true, destructive: 0, controller: self) { (success, index) in
            
            if success{
                if index == 0 {
                    self.openCameraWithPermissions()
                }else{
                    self.openGalleryWithPermissions()
                }
            }
        }
    }
    
    func openImageSelection()
    {
        
        if self.userProfile.userImages.count < 5
        {
        actionSheet(btnArray: ["Camera" , "Gallery"], cancel: true, destructive: 0, controller: self) { (success, index) in
            
            if success{
                if index == 0 {
                    self.openCameraWithPermissions()
                }else{
                    self.openGalleryWithPermissions()
                }
            }
        }
        }else{
            showCustomAlert(message: "Maximum 5 photos are allowed." , controller: self)
        }
    }
    
    func openCameraWithPermissions()
    {
        let status : AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if status == AVAuthorizationStatus.authorized
        {
            self.openCamera()
        }else if  status == AVAuthorizationStatus.denied
        {
            showCustomAlert(message: "Camera permissions are disabled." , controller: self)

            //  showAlert(AppName, message: "Camera permissions are disabled.", controller: self)
        }else if  status == AVAuthorizationStatus.restricted
        {
            
            showCustomAlert(message: "Camera permissions are disabled" , controller: self)

        }else if  status == AVAuthorizationStatus.notDetermined{
            AVCaptureDevice.requestAccess(for: AVMediaType.video , completionHandler: { (Bool) in
                if Bool {
                    DispatchQueue.main.async {
                        self.openCamera()
                    }
                }
            })
        }
        
    }
    
    
    func openCamera()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: {
        })
    }
    
    
    func openGalleryWithPermissions()
    {
        PHPhotoLibrary.requestAuthorization { (status) -> Void in
            switch status{
            case .authorized:
                DispatchQueue.main.async {
                    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
                        let imagePicker = UIImagePickerController()
                        imagePicker.sourceType = .savedPhotosAlbum
                        imagePicker.allowsEditing = true
                        imagePicker.delegate = self
                        self.present(imagePicker, animated: true, completion: {
                        })
                    }
                }
                break
            case .denied:
                print("Denied")
                break
            default:
                print("Default")
                break
            }
        }
    }
    
    //MARK:- ImagePicker Delegate
    //MARK:-
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            let imageName = "LiveBait_" + timeStamp + ".jpg"
            let newImage = LBImage(file: pickedImage, variableName: timeStamp  , fileName: imageName , andMimeType: "image/jpeg")
            
            if self.imgType == .NormalImage
            {
                self.userProfile.userImages.append(newImage)
                self.collectionViewPics.reloadData()
            }else{
                userProfile.profileImage = newImage
                self.imgViewProfile.image = pickedImage
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Picker Delegate
    //MARK:-
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        return ageLimit.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return ageLimit[row].description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtAge.text =  ageLimit[row].description
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


}


