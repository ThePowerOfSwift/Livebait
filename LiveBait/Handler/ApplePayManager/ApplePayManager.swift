//
//  ApplePayManager.swift
//  Drinks
//
//  Created by maninder on 9/28/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit
import PassKit





class ApplePayManager: NSObject,PKPaymentAuthorizationViewControllerDelegate
{
    
    var request : PKPaymentRequest!
    
   // var controller : UIViewController? = nil
    
    
    override init()
    {
        self.request = PKPaymentRequest()
        request.merchantIdentifier = ApplePayDrinksMerchantID
        request.supportedNetworks = [PKPaymentNetwork.amex, PKPaymentNetwork.visa ,  PKPaymentNetwork.discover,  PKPaymentNetwork.JCB , PKPaymentNetwork.masterCard]
        request.merchantCapabilities = .capability3DS

    }
    
    
    
    class var sharedInstance: ApplePayManager {
        struct Static {
            static let instance: ApplePayManager = ApplePayManager()
        }
        return Static.instance
    }
    
    
    
    
    func paymentAuthorizationVC(controller : UIViewController)
    {
        
        let objApplePay = PKPaymentAuthorizationViewController(paymentRequest: request)
        objApplePay.delegate = self
        controller.present(objApplePay, animated: true, completion: nil)
    }
    
    //MARK:- Payment Authorization Delegates
    //MARK:-
    
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        
        print(payment)
        
    }
    
    
    
    
//    @available(iOS 8.0, *)
//    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Swift.Void)
//    
//    
//    // Sent to the delegate when payment authorization is finished.  This may occur when
//    // the user cancels the request, or after the PKPaymentAuthorizationStatus parameter of the
//    // paymentAuthorizationViewController:didAuthorizePayment:completion: has been shown to the user.
//    //
//    // The delegate is responsible for dismissing the view controller in this method.
//    @available(iOS 8.0, *)
//    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController)
//    

    
    
//    let objApplePay = PKPaymentAuthorizationViewController(paymentRequest: request)
//    objApplePay.delegate = self
//    self.presentViewController(objApplePay, animated: true, completion: nil)

    

    
}
