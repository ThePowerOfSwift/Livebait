//
//  MSExtensions.swift
//  iCheckbook
//
//  Created by maninder on 27/02/17.
//  Copyright © 2017 maninder. All rights reserved.
//

import Foundation
import UIKit


//
//var dateFormate : DateFormatter = DateFormatter()
//let APP_DateFormat = "dd-MMM-yyyy"
//let APP_DateFormatNew = "yyyy-mm-dd"
//
//let APP_DateMessageFormat = "dd/MM/yyyy hh:mm a"




var dateFormatter: DateFormatter {
    struct Static {
        static let instance : DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd-yyyy"
            return formatter
        }()
    }
    
    return Static.instance
}





@objc protocol MSProtocolCallback {
    
    @objc optional func actionMoveToPreviousVC( )
    @objc optional func actionBackDismiss( )
    @objc optional func actionMovingWithData(objData : AnyObject)
    @objc optional func actionMoveToPreviousVC(objAny : AnyObject )

    @objc optional func actionMoveToPreviousVC(action: Bool )
    @objc optional func actionMoveWithObj(obj : AnyObject , test : Bool )
    @objc optional func replaceGroup(obj : Any )
    @objc optional func updateData()


    
}

func appDelegate() ->  AppDelegate{
    return UIApplication.shared.delegate as! AppDelegate
}

extension UIButton {
    func underlineButton(text: String , font : UIFont) {
        let titleString = NSMutableAttributedString(string: text)
        titleString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, text.count))
        //  NSFontAttributeName : FontLight(size: 15)
        titleString.addAttribute(NSAttributedStringKey.font , value: font , range: NSMakeRange(0, text.count))
        
        self.setAttributedTitle(titleString, for: .normal)
    }
}


extension UIPickerView {
    func setSelectedIndex()  -> Int {
       return self.selectedRow(inComponent: 0)
    }
}



extension NSObject{
    
    //MARK: ------ Popular Objects
    
    var timeStamp: String{
        let time = String(format: "%0.0f", Date().timeIntervalSince1970 * 1000)
        return time
    }
        var ScreenHeight: CGFloat{
            return UIScreen.main.bounds.size.height //UIScreen.main.bounds.size.height
        }
        var ScreenWidth: CGFloat{
            return UIScreen.main.bounds.size.width
        }
        
}




extension Double {
    
    
    func roundTo(places: Double) -> Double {
        let divisor = pow(10.0, places)
        return (self * divisor).rounded() / divisor
    }
}



extension Date {
    
    
    public func  toShortTimeString() -> String
    {
        //Get Short Time String
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let timeString = formatter.string(from: self)
        return timeString
    }
    
    
    public static func timestamp() -> String {
        return "\(Date().timeIntervalSince1970 * 1000)" as String
    }
    
    public func getMessageDate()-> Date{
        return Date()
    }
    
}


 
extension String
{
    var length : Int
    {
        return self.count
    }
    
     public func isValidEmail() ->Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self)
    }

    
    public func removeSpacesInString() -> String
    {
       return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    

    public func getNumberFromString()-> Double
    {
        let newSTR = self.removeParticularCharacterString(character: ",")
        if let number = Int(newSTR) {
            return Double(number)
        }
        return 0.0
    }

    
    public func removeParticularCharacterString(character: String) -> String
    {
        return self.replacingOccurrences(of: character, with: "", options: NSString.CompareOptions.literal, range: nil)
    }
    
    
    public func removeMultipleCharactersString(arrayMutliple : [String]) -> String
    {
        var newString = self
        for item in arrayMutliple{
            newString =  newString.replacingOccurrences(of: item, with: "", options: NSString.CompareOptions.literal, range: nil)
        }
        return newString
    }


    public func isStringEmpty() -> Bool
    {
        let testingString = self
        if testingString.count == 0 || checkIsEmpty()
        {
            return true
        }
        return false
    }
    
    func checkIsEmpty()-> Bool{
        let trimmedString = self.trimmingCharacters(in:  CharacterSet.whitespaces)
        if trimmedString.count == 0 {
            return true
        }else{
            return false
        }
    }
    
    func removeEndingSpaces() -> String
    {
        let strTrimmed = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return strTrimmed
    }
    
    

    func sha1() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}


extension UICollectionView{
    public func registerCollectionNibs(arryNib : NSArray)
    {
        for i in 0  ..< arryNib.count
        {
            let nibName = arryNib.object(at: i) as! String
            let nibCell = UINib.init(nibName:nibName, bundle: nil);
            self.register(nibCell, forCellWithReuseIdentifier: nibName )
        }
    }
}
extension UIView
{
    public func cornerRadius(value: CGFloat){
        let view:UIView = self
        view.layer.cornerRadius = value;
        view.clipsToBounds = true
    }

    
    
    public  func addAllSideShadow( maskToBounds:Bool=false ){
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = maskToBounds
    }
    
    public func addBorderWithColorAndLineWidth(color: UIColor , borderWidth : Float){
        let view:UIView = self
        view.layer.borderColor = color.cgColor
        view.layer.borderWidth = CGFloat(borderWidth)
    }

}



extension UIViewController
{
    public func navTitle(title:NSString,color:UIColor,font:UIFont){
        let label: UILabel = UILabel()
        label.backgroundColor = UIColor.clear
        label.text = title as String
        label.font = font
        label.textAlignment = NSTextAlignment.center
        label.isUserInteractionEnabled = true;
        label.textColor = color
        self.navigationItem.titleView = label
        label.sizeToFit()
    }
    
    
    public func navLogo(){
        let imageViewLogo = UIImageView(frame: CGRect(x: 0, y: 0, width: 37, height: 37  ))
        imageViewLogo.image = UIImage(named : "NavLogo")
        imageViewLogo.isUserInteractionEnabled = true;

        self.navigationItem.titleView = imageViewLogo
    }

    
    
    
    public func presentControllerWithNavController(objNextVC: UIViewController)
    {
        let navigation = UINavigationController(rootViewController: objNextVC)
        navigation.isNavigationBarHidden = true
        self.navigationController?.present(navigation, animated: true, completion: nil)
    }
    
}

extension UITextField{
    
    public func acceptOnly15CharactersOnly(strNew: String)-> Bool
    {
        let txtFPara : UITextField = self
        if strNew == ""
        {
            return true
        }else if txtFPara.text?.count == 15 {
            return false
        }
        return true
    }
    
    
    public func setDollarSign(){
        
        let view :UITextField = self
        let leftView : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: view.frame.size.height))
        leftView.backgroundColor = UIColor.clear
        leftView.text = "$";
        leftView.font = FontLight(size: 15)
        leftView.textAlignment = NSTextAlignment.center;
        view.leftView = leftView
        view.leftViewMode = .always
        view.contentVerticalAlignment = .center
    }
    
    
    
     func attributedPlaceHolder(placeHolder : String , color : UIColor , font : UIFont)
    {
    let strAttributed = NSMutableAttributedString(string: placeHolder)
        strAttributed.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: NSRange(location:0,length:placeHolder.count))
        strAttributed.addAttribute(NSAttributedStringKey.font, value: font, range: NSRange(location:0,length:placeHolder.count))
    self.attributedPlaceholder = strAttributed
    
    }
}


extension UITableView{
    
        /// Check if cell at the specific section and row is visible
        /// - Parameters:
        /// - section: an Int reprenseting a UITableView section
        /// - row: and Int representing a UITableView row
        /// - Returns: True if cell at section and row is visible, False otherwise
      public  func isCellVisible(section:Int, row: Int) -> Bool {
            guard let indexes = self.indexPathsForVisibleRows else {
                return false
            }
            return indexes.contains {$0.section == section && $0.row == row }
        }
    
    
    
    public func registerNibsForCells(arryNib : NSArray)
    {
        for i in 0  ..< arryNib.count
        {
            let nibName = arryNib.object(at: i) as! String
            let nibCell = UINib.init(nibName:nibName, bundle: nil);
            self.register(nibCell, forCellReuseIdentifier:nibName)
        }
    }
    

}

extension UILabel
{
    //
    func setGoUnlimitedAttributedText()
    {
        let strTerms = "Dont want to wait? Go Unlimited !"
    
        let range = NSMakeRange(18, 14)
        let titleString = NSMutableAttributedString(string: strTerms)
        titleString.addAttribute(NSAttributedStringKey.foregroundColor , value: UIColor.white , range: NSMakeRange(0, strTerms.count ))
        titleString.addAttribute(NSAttributedStringKey.font , value: FontRegular(size: 17) , range: NSMakeRange(0, strTerms.count))
        titleString.addAttribute(NSAttributedStringKey.font , value: FontBold(size: 19) , range: range)
        //titleString.addAttribute(NSAttributedStringKey.foregroundColor  , value: UIColor.white , range: range)
        self.attributedText = titleString
    }
    
    
    
}


extension UIFont {
    func sizeOfString (string: String, constrainedToWidth width: Double) -> CGSize {
        return NSString(string: string).boundingRect(with: CGSize(width: width, height: Double.greatestFiniteMagnitude),
                                                     options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                     attributes: [NSAttributedStringKey.font : self],
                                                             context: nil).size
    }
}

extension NSString{

    var md5: String! {
        let str = self.cString(using: String.Encoding.utf8.rawValue)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8.rawValue))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate(capacity: digestLen)
        return String(format: hash as String)
    }

    
}


public extension UIView {
    func captureScreenShot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        
    }
}


