//
//  MSCameraGallery.swift
//  Drinks
//
//  Created by maninder on 8/10/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit
import Photos

public var requestPermissionTitle = "Permission denied"
 var requestPermissionMessage = "Please, allow the application to access to your photo library."
var requestCameraPermissionMessage = "Please, allow the application to access to your camera."


@objc protocol MSGetImage {
    @objc optional func moveWithSelectedImage(selected : Any)
    
}


enum Flash : String {
    case OFF = "Off"
    case ON = "On"
    case AUTO = "Auto"
    
    
}

class MSCameraGallery: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CameraManDelegate
{

    
    var capturedImage : UIImage? = nil
    var selectingImage : UIImage? = nil

    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    var assets : [PHAsset] = [PHAsset]()
    var selectedImage : PHAsset? = nil
    @IBOutlet weak var collectionViewImages: UICollectionView!
    var viewGallery : GalleryImageView!
    var windowWidth : CGFloat = 0.0
    var windowHeight : CGFloat = 0.0
    @IBOutlet weak var btnFlash: UIButton!
    @IBOutlet weak var btnChangeCamera: UIButton!
    @IBOutlet weak var btnCapture: UIButton!
    @IBOutlet weak var viewContainer: UIView!
     let cameraMan = CameraMan()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var delegate : MSGetImage? = nil
    
    var  frontCamera = false
    var flash : Flash = .OFF
    
    var pinch : UIPinchGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        windowWidth = self.view.frame.width
        windowHeight = self.view.frame.height
        
        
        
        cameraMan.delegate = self
        cameraMan.setup(self.frontCamera)
        
        self.checkStatus()
        let nib = UINib(nibName: "ImageCollectionCell", bundle: nil)
        collectionViewImages.register(nib, forCellWithReuseIdentifier: "ImageCollectionCell")
        collectionViewImages.delegate = self
        collectionViewImages.dataSource = self
        collectionViewImages.backgroundColor = UIColor.groupTableViewBackground
        
        
        pinch = UIPinchGestureRecognizer(target: self, action: #selector(MSCameraGallery.pinch(_:)))
    
        self.viewContainer.addGestureRecognizer(pinch)
      //  viewGallery = GalleryImageView.instanceFromNib(width: windowWidth-16, height: viewGalleryContainer.frame.size.height)
        
      //  print(viewGallery.frame)
       // viewGalleryContainer.addSubview(viewGallery)

        // Do any additional setup after loading the view.
    }
    
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _ = try? AVAudioSession.sharedInstance().setActive(true)
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        previewLayer?.connection.videoOrientation = .portrait
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
     //   UIApplication.shared.setStatusBarHidden(false, with: .fade)
    }
    
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    @IBAction func actionBtnDonePressed(_ sender: UIButton) {
        if capturedImage == nil && selectedImage == nil{
            return
        }else if capturedImage == nil && selectedImage != nil
        {
            AssetManager.resolveAssetMS(selectedImage!, size: CGSize(width: 500, height: 500)) { image in
                if let image = image {
                    self.delegate?.moveWithSelectedImage!(selected: image)
                }
            }
            

        
        }else if capturedImage != nil && selectedImage == nil
        {
            
            self.delegate?.moveWithSelectedImage!(selected: capturedImage!)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func actionBtnCancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func actionBtnCapture(_ sender: Any) {
        cameraMan.takePhoto(previewLayer!) { (image) in
         if image != nil
            {
                self.btnCapture.isSelected = true
                self.capturedImage = image
            }else{
                self.btnCapture.isSelected = false
            self.capturedImage = nil
            }
        }
        
        
    }
    
    
    @IBAction func actionBtnToggle(_ sender: Any) {
        
         if self.capturedImage == nil
         {
            
            cameraMan.switchCamera(handler: { (camera) in
               self.frontCamera = !self.frontCamera
                
                if self.frontCamera == false{
                    
                    self.btnFlash.isEnabled = true
                }else{
                    
                    self.btnFlash.isEnabled = false
                   

                }
                self.btnFlash.setImage(UIImage(named: "FlashOff"), for: .normal)

                self.cameraMan.flash(.off)
                 self.flash = .OFF
                
            })
            
            
            
        
        }
        
    }
    
    @IBAction func actionBtnFlash(_ sender: Any) {
        
        
        if frontCamera == false{
            
            if flash == .OFF{
                 self.cameraMan.flash(.on)
                self.flash = .ON
                self.btnFlash.setImage(UIImage(named: "FlashOn"), for: .normal)

                
            }else if  flash == .ON {
                self.flash = .AUTO
                 self.cameraMan.flash(.auto)
                self.btnFlash.setImage(UIImage(named: "FlashAuto"), for: .normal)


            }else{
                
                self.flash = .OFF
                self.cameraMan.flash(.off)
                self.btnFlash.setImage(UIImage(named: "FlashOff"), for: .normal)

            }
        }else{
              self.btnFlash.isEnabled = false
        }
        
    }

    
    func fetchPhotos(_ completion: (() -> Void)? = nil) {
        AssetManager.fetch { assets in
            self.assets.removeAll()
            self.assets.append(contentsOf: assets)
            self.collectionViewImages.reloadData()
            
            completion?()
        }
    }
    
    
    func checkStatus() {
        let currentStatus = PHPhotoLibrary.authorizationStatus()
//        guard currentStatus != .authorized else { return }
        
        if currentStatus == .notDetermined {
        
        PHPhotoLibrary.requestAuthorization { (authorizationStatus) -> Void in
            DispatchQueue.main.async {
                if authorizationStatus == .denied {
                    self.presentAskPermissionAlert()
                } else if authorizationStatus == .authorized {
                    self.fetchPhotos()
                }
            }
        }
            
            
            
        }else if  currentStatus == .authorized{
            self.fetchPhotos()
        }
    }
    
    func presentAskPermissionAlert() {
        let alertController = UIAlertController(title: requestPermissionTitle, message: requestPermissionMessage, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(settingsURL)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(alertAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func hideViews() {
    }
    
    //MARK:- Camera Methods
    //MARK:-
    
    

    
    
    
    //MARK:- CollectionView Delegate Methods
    //MARK:-
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
//        cell.backgroundColor = .black
        cell.asset = assets[indexPath.row]
        cell.setAssetImage(selectedImage: selectedImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: self.collectionViewImages.bounds.width, height: 0)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let size = CGSize(width: ((collectionViewImages.frame.width - 16)/3), height: ((collectionViewImages.frame.width - 16)/3))
        return size
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if capturedImage != nil{
            selectedImage = nil
            
        }else{
        
        if selectedImage == nil{
         selectedImage = assets[indexPath.row]
        }else{
            
            if selectedImage == assets[indexPath.row]
            {
                selectedImage = nil
            }else{
                selectedImage = assets[indexPath.row]
            }
            
        }
        }
        self.collectionViewImages.reloadItems(at: collectionViewImages.indexPathsForVisibleItems )
        
    }
    
    
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func getSelectedImage(indexpath: IndexPath)
    {
        
        
        let cell = collectionViewImages.cellForItem(at: indexpath) as! ImageCollectionCell
        self.selectingImage = cell.imgViewPhoto.image
        
        
        
    }
    
    
    //MARK:- Set GalleryView
    //MARK:-
    
    
    // CameraManDelegate
    func cameraManNotAvailable(_ cameraMan: CameraMan) {
               self.presentAskCameraPermissionAlert()
    
    }
    
    func cameraMan(_ cameraMan: CameraMan, didChangeInput input: AVCaptureDeviceInput) {
        
     //   delegate?.setFlashButtonHidden(!input.device.hasFlash)
    }
    
    func cameraManDidStart(_ cameraMan: CameraMan) {
        setupPreviewLayer()
    }

    
        func setupPreviewLayer() {
            guard let layer = AVCaptureVideoPreviewLayer(session: cameraMan.session) else { return }
    
            layer.backgroundColor = UIColor.clear.cgColor
            layer.autoreverses = true
            layer.videoGravity = AVLayerVideoGravityResizeAspectFill
    
            self.viewContainer.layer.insertSublayer(layer, at: 0)
            layer.frame = CGRect(x: 0, y: 0, width: self.viewContainer.frame.width, height: self.viewContainer.frame.height)
                previewLayer = layer
            
        }
    
    
    
    func presentAskCameraPermissionAlert() {
        let alertController = UIAlertController(title: requestPermissionTitle, message: requestPermissionMessage, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(settingsURL)
                }
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(alertAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }


    let minimumZoom: CGFloat = 1.0
    let maximumZoom: CGFloat = 3.0
    var lastZoomFactor: CGFloat = 1.0
    
    func pinch(_ pinch: UIPinchGestureRecognizer) {
        guard let device = cameraMan.currentInput?.device else { return }
        
        // Return zoom value between the minimum and maximum zoom values
        func minMaxZoom(_ factor: CGFloat) -> CGFloat {
            return min(min(max(factor, minimumZoom), maximumZoom), device.activeFormat.videoMaxZoomFactor)
        }
        
        func update(scale factor: CGFloat) {
            do {
                try device.lockForConfiguration()
                defer { device.unlockForConfiguration() }
                device.videoZoomFactor = factor
            } catch {
                print("\(error.localizedDescription)")
            }
        }
        
        let newScaleFactor = minMaxZoom(pinch.scale * lastZoomFactor)
        
        switch pinch.state {
        case .began: fallthrough
        case .changed: update(scale: newScaleFactor)
        case .ended:
            lastZoomFactor = minMaxZoom(newScaleFactor)
            update(scale: lastZoomFactor)
        default: break
        }
    }
    
    
    func loadViewFromNib() -> GalleryImageView {
        let nib = UINib(nibName: "GalleryImageView", bundle: nil)
        
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? GalleryImageView
        return view!
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
