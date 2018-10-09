//
//  BuyChatVC.swift
//  LiveBait
//
//  Created by maninder on 12/15/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit
import StoreKit

class BuyChatVC: UIViewController,MSAlertProtocol, SKProductsRequestDelegate,SKPaymentTransactionObserver{

    @IBOutlet weak var lblTopChatCount: UILabel!
    @IBOutlet weak var lblTopPrice: UILabel!
    @IBOutlet weak var lblThirdChatCount: UILabel!
    @IBOutlet weak var lblThirdPrice: UILabel!
    @IBOutlet weak var lblSecondChatCount: UILabel!
    @IBOutlet weak var lblSecondPrice: UILabel!
    @IBOutlet weak var lblFirstChatCount: UILabel!
    @IBOutlet weak var lblFirstPrice: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblTopPopular: UILabel!
    @IBOutlet weak var viewTopPackage: UIView!
    @IBOutlet weak var lblGoUnlimited: UILabel!
    @IBOutlet weak var viewThirdPackage: UIView!
    
    @IBOutlet weak var viewSecondPackage: UIView!
    @IBOutlet weak var viewFirstPackage: UIView!
    @IBOutlet weak var viewBottomPopularPackage: UILabel!
    
    @IBOutlet var btnNOThanks: UIButton!
    @IBOutlet weak var lblTimer: UILabel!
    
    var secondsLeft : Int = 86400
    
    var timer : Timer?
    
    
    let productIdentifiers = ["com.development.LiveBait.1chat", "com.development.LiveBait.3chats", "com.development.LiveBait.20chats", "com.development.LiveBait.unlimitedChats"]
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    
    var purchasedId = ""
    var selectedPlanBtn = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        
        self.navigationController?.navigationBar.barTintColor = APPThemeColor
        
        self.navigationController?.navigationBar.isTranslucent = false
     
        
        
        let btnLeftBar:UIBarButtonItem = UIBarButtonItem.init(image:UIImage(named: "BackWhite"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(BuyChatVC.actionBtnBackPressed))
        
        self.navigationItem.leftBarButtonItem = btnLeftBar
        
        let btnRightBar:UIBarButtonItem = UIBarButtonItem.init(title: "No thanks", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BuyChatVC.actionBtnBackPressed))
        
        self.navigationItem.leftBarButtonItem = btnLeftBar
      //  self.navigationItem.rightBarButtonItem = btnRightBar

        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navTitle(title: "Out of chats !", color: UIColor.white , font:  FontBold(size: 18))
        
        self.lblTopPopular.cornerRadius(value: 3)
        self.lblTopPopular.addBorderWithColorAndLineWidth(color: .white, borderWidth: 0.8)
        
        viewTopPackage.cornerRadius(value: 7)
        viewFirstPackage.cornerRadius(value: 7)

        viewSecondPackage.cornerRadius(value: 7)
        viewThirdPackage.cornerRadius(value: 7)
        btnContinue.cornerRadius(value: 7)
        btnNOThanks.cornerRadius(value: 7)

    self.viewSecondPackage.addBorderWithColorAndLineWidth(color: .black, borderWidth: 1)
        self.viewThirdPackage.addBorderWithColorAndLineWidth(color: .black, borderWidth: 1)
        self.viewFirstPackage.addBorderWithColorAndLineWidth(color: .black, borderWidth: 1)
        self.lblGoUnlimited.setGoUnlimitedAttributedText()
        
         NotificationCenter.default.addObserver(self, selector: #selector(BuyChatVC.newCallReceived), name: NSNotification.Name(rawValue: MSNotificationName.NewVideoCallRequest.rawValue), object: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let date = Date() // current date or replace with a specific date
        let calendar = Calendar.current
        let dateAtEnd = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date)
        let interval = dateAtEnd?.timeIntervalSince(date)
        timer = nil
        self.secondsLeft = Int(interval!)
        self.updateTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (success) in
            self.updateTimer()
        })
        
        fetchAvailableProducts()
   }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if appDelegate().activeCall.status == .Connected
        {
            appDelegate().callingView?.hideBlurView()
        }
        
    }
    
    
    @IBAction func actionBtnNoThanks(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func actionContinuePurchase(_ sender: Any) {
        if selectedPlanBtn == 0 {
            showCustomAlert(message: "Please select any opiton", controller: self)
        }else {
            if iapProducts.count >= selectedPlanBtn{
                purchaseMyProduct(iapProducts[selectedPlanBtn-1])
            }
        }
    }
    
    @IBAction func actionBtnPlanPressed(_ sender: UIButton) {

        self.viewTopPackage.addBorderWithColorAndLineWidth(color: .white, borderWidth: 1)
        self.viewFirstPackage.addBorderWithColorAndLineWidth(color: .black, borderWidth: 1)
        self.viewSecondPackage.addBorderWithColorAndLineWidth(color: .black, borderWidth: 1)
        self.viewThirdPackage.addBorderWithColorAndLineWidth(color: .black, borderWidth: 1)

        self.selectedPlanBtn = sender.tag

        if sender.tag == 1
        {
            self.viewFirstPackage.addBorderWithColorAndLineWidth(color: APP_PinkColor, borderWidth: 4)
        }else if sender.tag == 2
        {
              self.viewSecondPackage.addBorderWithColorAndLineWidth(color: APP_PinkColor, borderWidth: 4)
           // viewSecondPackage.backgroundColor = .lightGray

        }else if sender.tag == 3 {
            
         self.viewThirdPackage.addBorderWithColorAndLineWidth(color: APP_PinkColor, borderWidth: 4)
            
        }else if sender.tag == 4
        {
             self.viewTopPackage.addBorderWithColorAndLineWidth(color: APP_PinkColor, borderWidth: 4)
        }
    }
    
    
    func updateTimer()
    {
        if secondsLeft == 0
        {
            secondsLeft = 86400
        }
        secondsLeft = secondsLeft - 1
        let hours = secondsLeft / 3600
        let minutes = secondsLeft / 60 % 60
        let seconds = secondsLeft % 60
        var strToDisplay = ""
        
        if hours < 10
        {
            strToDisplay = "0" + hours.description + " : "
        }else{
             strToDisplay =  hours.description + " : "
        }
        if minutes < 10
        {
            strToDisplay =  strToDisplay +  "0" + minutes.description + " : "
        }else{
            strToDisplay =  strToDisplay + minutes.description + " : "
        }
        if seconds < 10
        {
            strToDisplay =  strToDisplay +  "0" + seconds.description
        }else{
            strToDisplay =  strToDisplay + seconds.description
        }
        lblTimer.text =   strToDisplay
    }
 
    @objc func actionBtnBackPressed()
    {
     _ = self.navigationController?.popViewController(animated: true)
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
   

     //Payments

    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts()  {
        let productIdentifiers = NSSet(array: self.productIdentifiers)
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }

    // MARK: - REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        if (response.products.count > 0) {
            iapProducts = response.products
            for product in iapProducts {
                // Get its price from iTunes Connect
                let numberFormatter = NumberFormatter()
                numberFormatter.formatterBehavior = .behavior10_4
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = product.priceLocale
                let productPrice = numberFormatter.string(from: product.price)

                
                if product.productIdentifier == productIdentifiers[0] {
                    lblFirstChatCount.text = product.localizedDescription
                    lblFirstPrice.text = productPrice
                }else if product.productIdentifier == productIdentifiers[1] {
                    lblSecondChatCount.text = product.localizedDescription
                    lblSecondPrice.text = productPrice
                }else if product.productIdentifier == productIdentifiers[2] {
                    lblThirdChatCount.text = product.localizedDescription
                    lblThirdPrice.text = productPrice
                }else if product.productIdentifier == productIdentifiers[3] {
                    lblTopChatCount.text = product.localizedDescription + " / mo"
                    lblTopPrice.text = productPrice
                }
            }

        }
    }

    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }

    func purchaseMyProduct(_ product: SKProduct) {
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            purchasedId = product.productIdentifier
        } else {
            showCustomAlert(message: "Purchases are disabled in your device!" , controller: self)
        }
    }

    // MARK:- IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {

                case .purchased:
                    self.updateChats(trans.transactionIdentifier!)
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break

                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                
                default: break
                }
            }
        }
    }
    
    func updateChats(_ txnId: String) {

        let params : [String: Any] = [
            "txn_id" : txnId ,
            "status": "1",
            "deviceType":"I",
            "plan_id":selectedPlanBtn,
            "payment_data":""
        ]
        SwiftLoader.show(true)
        HTTPRequest.sharedInstance().postMulipartRequest(urlLink: API.API_SaveSubscription, paramters: params, Images: []) { (success, response, strError) in
            SwiftLoader.hide()
            if success
            {
                
                
            }else{
                
            }
        }
    }
}
