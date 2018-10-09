//
//  CallView.swift
//  LiveBait
//
//  Created by maninder on 1/23/18.
//  Copyright © 2018 Maninderjit Singh. All rights reserved.
//

import UIKit


enum TypeAction : Int{
    
    case actionMap = 1
    case actionBack = 2
    case actionFB = 3
    
}


internal func loadCallingViewFromObjNib() -> CallView {
    let nib = UINib(nibName: "CallView", bundle: nil)
    let view = nib.instantiate(withOwner: nil, options: nil)[0] as! CallView
    return view
}

class CallView: UIView,QBRTCRemoteVideoViewDelegate {
    func videoView(_ videoView: QBRTCRemoteVideoView, didChangeVideoSize size: CGSize) {
        
    }
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var viewNewFeature: UIView!
    @IBOutlet weak var viewBlur: UIVisualEffectView!
    @IBOutlet weak var lblConnecting: UILabel!
    
    @IBOutlet weak var btnReportUser: UIButton!
    
    var videoCapture : QBRTCCameraCapture?  = nil
    
    var callBack : ((TypeAction) -> Void)? = nil
    
    @IBOutlet weak var lblTimer: UILabel!
    
    @IBOutlet weak var remoteView: QBRTCRemoteVideoView!
    @IBOutlet weak var btnMute: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnAddContact: UIButton!
    @IBOutlet weak var btnToggleCamera: UIButton!
    @IBOutlet weak var viewMyImage: UIImageView!
    /*
    // Only override draw() if you perform custom drawing.
     An empty implementation adversely affects performance during animation.
 */
    override func draw(_ rect: CGRect) {
     super.draw(rect)
        makeVideoSettings()
    }
    
 private   func makeVideoSettings()
    {
        DispatchQueue.main.async
            {
            self.btnReportUser.cornerRadius(value: 15)
           // print("No need to open second view")
                
                
                QBRTCAudioSession.instance().initialize{(configuration: QBRTCAudioSessionConfiguration) -> () in
                    var options = configuration.categoryOptions
                    if #available(iOS 10.0, *)
                    {
                        options = options.union(AVAudioSessionCategoryOptions.allowBluetoothA2DP)
                        options = options.union(AVAudioSessionCategoryOptions.allowAirPlay)
                    } else {
                        options = options.union(AVAudioSessionCategoryOptions.allowBluetooth)
                    }
                    configuration.categoryOptions = options
                    configuration.mode = AVAudioSessionModeVideoChat
                }
            
                QBRTCAudioSession.instance().currentAudioDevice = .speaker
                let videoFormat = QBRTCVideoFormat()
                videoFormat.frameRate = 60
                videoFormat.pixelFormat = QBRTCPixelFormat.format420f
                self.videoCapture = QBRTCCameraCapture(videoFormat: videoFormat, position: AVCaptureDevice.Position.front)
                self.videoCapture?.previewLayer.frame = CGRect(x: 0, y: 0, width: 90, height: 110)
                self.videoCapture?.startSession({
                    DispatchQueue.main.async {
                        appDelegate().activeCall.activeSession?.localMediaStream.videoTrack.videoCapture = self.videoCapture!
                       appDelegate().activeCall.activeSession?.localMediaStream.videoTrack.isEnabled = true
                    }
                })
       
               NotificationCenter.default.addObserver(self, selector:  #selector(CallView.receivedRemoteVideoTrack), name: NSNotification.Name(rawValue: MSNotificationName.UserVideoInitialised.rawValue) , object: nil)
                self.viewMyImage.layer.insertSublayer((self.videoCapture?.previewLayer)! , at: 0)
              self.remoteView.delegate = self
            self.viewMyImage.cornerRadius(value: 5)
                
        }
        
        NotificationCenter.default.addObserver(self, selector:  #selector(CallView.removeCallScreen), name: NSNotification.Name(rawValue: MSNotificationName.UserCallDisconnectedByOther.rawValue) , object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(CallView.connectionCompleted), name: NSNotification.Name(rawValue: MSNotificationName.UserConnected.rawValue) , object: nil)
        self.viewBlur.alpha = 1
        self.viewBlur.isHidden = false
        self.lblConnecting.isHidden = false
        
    }
 
    @IBAction func actionBtnBackPressed(_ sender: UIButton) {
        if self.callBack != nil
        {
          self.callBack!(TypeAction.actionBack)
        }
    }
    
 
    @IBAction func actionBtnEndCall(_ sender: Any) {
        
        if appDelegate().activeCall.status == .Connected
        {
            appDelegate().activeCall.activeSession?.hangUp(nil)
            self.removeCallScreen()
        }
    }
    
    @IBAction func actionBtnReportUser(_ sender: Any) {
        
      let imageScreenShot =  self.getSecondUserSS()
        let imageName = "UserReport_" + timeStamp + ".jpg"
        let newImage = LBImage(file: imageScreenShot, variableName: timeStamp  , fileName: imageName , andMimeType: "image/jpeg")
        //let secondPersonFUllName = appDelegate().activeCall.secondParty.fullName

        LoginManager.sharedInstance.reportUserWithScreenShot(userSecond: appDelegate().activeCall.secondParty, image: newImage) { (success, response, strError) in
            if success
            {
                showCustomAlert(message: "Report has been submitted to Admin.", controller: appDelegate().topViewController())
            }else{
                showCustomAlert(message:  strError! , controller: appDelegate().topViewController())
            }
        }
    }
    
    func hideBlurView()
    {
        self.viewBlur.alpha = 0
        viewBlur.isHidden = true
        lblConnecting.isHidden = true
    }
    
    @IBAction func actionBtnFbRequest(_ sender: Any) {

       if self.callBack != nil
        {
            self.viewBlur.alpha = 0
            viewBlur.isHidden = true
             self.callBack!(TypeAction.actionFB)
        }
    }
    
    @IBAction func actionBtnMuteUnmutePressed(_ sender: UIButton)
    {
        
        if sender.isSelected == false
        {
            appDelegate().activeCall.activeSession?.localMediaStream.audioTrack.isEnabled = false
        }else{
            appDelegate().activeCall.activeSession?.localMediaStream.audioTrack.isEnabled = true
        }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func actionBtnShareLocation(_ sender: Any) {
        
        
        if self.callBack != nil
        {
            self.callBack!(TypeAction.actionMap)
        }
    }
    
    @IBAction func actionBtnContactPressed(_ sender: UIButton)
    {
        print(LoginManager.getMe.phoneNumber)
        if  LoginManager.getMe.phoneNumber == ""
        {
            showCustomAlert(message: "Please verify your mobile number to share with your friends.", controller: appDelegate().topViewController())
            return
        }
        
        let secondPersonFUllName = appDelegate().activeCall.secondParty.fullName
        LoginManager.sharedInstance.shareContactNumber(user: appDelegate().activeCall.secondParty) { (success, response, strError) in
            if success
            {
                showCustomAlert(message: "Your contact has been shared with \(secondPersonFUllName).", controller: appDelegate().topViewController())
            }else{
                showCustomAlert(message:  strError! , controller: appDelegate().topViewController())
            }
        }
    }
    
    @IBAction func actionBtnCameraToggle(_ sender: UIButton) {
     
        let currentPosition = self.videoCapture?.position
        if currentPosition == AVCaptureDevice.Position.back
        {
            self.videoCapture?.position = AVCaptureDevice.Position.front
        }else{
            self.videoCapture?.position = AVCaptureDevice.Position.back
        }
    }
    
    @objc func receivedRemoteVideoTrack(notifcation : NSNotification)
    {
        if let imageTrack = notifcation.object as? QBRTCVideoTrack
        {
            self.remoteView.videoGravity = AVVideoScalingModeResize
             self.remoteView.setVideoTrack(imageTrack)
            self.remoteView.bringSubview(toFront: self.viewMyImage)
            if userDefaults.bool(forKey: LocalKeys.FirstCall.rawValue) == false
            {
                self.perform(#selector(CallView.showFirstTimeFeatureAlert), with: nil, afterDelay: 3)
                userDefaults.set( true , forKey: LocalKeys.FirstCall.rawValue)
            }
        }
    }
    
    @objc func connectionCompleted(notifcation : NSNotification)
    {
            self.viewBlur.alpha = 0
            viewBlur.isHidden = true
            lblConnecting.isHidden = true
        appDelegate().startTimer()
    }
    
    
    @objc func removeCallScreen()
    {
        DispatchQueue.main.async {
            appDelegate().activeCall.status = .Free
         self.removeFromSuperview()
            appDelegate().removeCallAndNotificationView()
            appDelegate().timerCall?.invalidate()
            appDelegate().timeToDisplay = "0:00"
            appDelegate().secondsOnCall = 0
        }
    }
    
    
    
    @IBAction func actionBtnHideFeaturePressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.viewBlur.alpha = 0
            self.viewNewFeature.alpha = 0

        }, completion: { (success) in
            self.viewBlur.isHidden = true
            self.viewNewFeature.isHidden = true
        })
    }
    
    
    @objc func showFirstTimeFeatureAlert()
    {
        UIView.animate(withDuration: 0.3, animations: {
            self.viewBlur.alpha = 0.8
            self.viewNewFeature.alpha = 1
        }, completion: { (success) in
            self.viewBlur.isHidden = false
            self.viewNewFeature.isHidden = false
        })
    }
    
    
    
    func getSecondUserSS()-> UIImage
    {
     
        UIGraphicsBeginImageContextWithOptions(self.frame.size, true, UIScreen.main.scale)
     self.remoteView.drawHierarchy(in: self.remoteView.frame, afterScreenUpdates: false)
        let imageCaptured = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageCaptured!;
        
    }
    
    func getScreenShotNew() -> UIImage
    {
        // self.lblTimer.bringSubview(toFront: self.remoteView)
       // CGContextRef context = UIGraphicsGetCurrentContext();

        let context = UIGraphicsGetCurrentContext()
       // UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        
        self.remoteView.layer.render(in: context!)
        self.viewMyImage.layer.render(in: context!)

        //[bakcgroundImage.layer renderInContext:context];
      //  [baseView.layer renderInContext:context];
      //  self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
//    YourRemoteVideoView *videoView = ....
//    QBRTCFrameConverter *frameConverter = [[QBRTCFrameConverter alloc] init];
//    CMSampleBufferRef ref = [frameConverter copyConvertedFrame: videoView.currentFrame];
//    //Get imageBuff form ref here
//    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:imageBuffer];
//    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
//    CGImageRef videoImage = [temporaryContext
//    createCGImage:ciImage
//    fromRect:CGRectMake(0, 0,
//    CVPixelBufferGetWidth(imageBuffer),
//    CVPixelBufferGetHeight(imageBuffer))];
//
//    UIImage *image = [[UIImage alloc] initWithCGImage:videoImage];
//    CGImageRelease(videoImage);
//
//    return image;
}
