//
//  Constant.swift
//  Drinks
//
//  Created by maninder on 7/27/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import Foundation
import UIKit


let googleClientID = "1063379644598-kdnaoart1vgp7d93vajvopf6oeokipks.apps.googleusercontent.com"
let googleURL = "com.googleusercontent.apps.1063379644598-kdnaoart1vgp7d93vajvopf6oeokipks"
let appLicenseKey = "B329F8C72242D5BFD925129E4592A1BD2B8C5E5B"
let DeviceType = "I"
//https://docs.google.com/spreadsheets/d/1iOjtwLeS0tTQmSTfgE7qrFKoZjiNCYvpD6f1_4sWfB8/edit#gid=0

enum LocalKeys : String
{
    case DeviceToken,
    DeviceTokenData,
    VOIPToken,
    VOIPTokenData,
    VerificationID,
    FirstCall,
    FirstWelcomeAlert
}

enum MSNotificationName : String
{
    case DidGetLocation
    case NewVideoCallRequest
    case UserVideoInitialised
    case UserCallRejectedByOther
    case UserCallDisconnectedByOther
    case UserCallRejectedByMe
    case UserCallDisconnectedByMe
    case CallAcceptedByUser
    case UserNotResponding
    
    case MoveToMapVC
    case BackToCallView
    case MoveToFBRequest
    case UserConnected

   case NewContactShared
    case NewContactSaved

}

enum MSAlertType : String
{
    case CommonAlert
    case CancelRequest
    case NewCallRequest
    case SaveContactRequest
}

//livebait-feac2
//mode_edit



let userPlaceHolder =  UIImage(named:"UserPH")

let landLogo =  UIImage(named:"LandingLogo")
let WT1 =  UIImage(named:"WT1")
let WT2 =  UIImage(named:"WT2")
let WT3 =  UIImage(named:"WT3")
let WT4 =  UIImage(named:"WT4")
let GroupPlaceHolder =  UIImage(named:"GroupPH")
var verificationCodeReceived : String = ""



//GroupPH


let APPThemeColor = UIColor(red: 0.0/255.0, green: 172.0/255.0, blue: 237.0/255.0, alpha: 1)
let APP_BarColor = UIColor(red: 51.0/255.0, green: 151.0/255.0, blue: 241.0/255.0, alpha: 1)
let APP_BlueColor = UIColor(red: 44.0/255.0, green: 128.0/255.0, blue: 255.0/255.0, alpha: 1)
let APP_GrayColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1)
let APP_PlaceHolderColor = UIColor(red: 187.0/255.0, green: 187.0/255.0, blue: 194.0/255.0, alpha: 1)
let APP_PinkColor = UIColor(red: 249.0/255.0, green: 59.0/255.0, blue: 169.0/255.0, alpha: 1)





let InterestLocal = "InterestLocal"
let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
let alertStoryBoard = UIStoryboard(name: "Alert", bundle: nil)
let msCameraStoryBoard = UIStoryboard(name: "MSCameraGallery", bundle: nil)


//API END POINTS

struct QBDetails
{
    static let ApplicationID = 73296
    static let AuthorizationKey = "wXYEykRnTW-8vn3"
    static let AuthorizationSecret = "CSpJB5y5AJjROt5"
    static let AccountKey = "XAFZziqAqxqzNNF6sysv"
    static let QBPassword = "QWERTY123456"
    
}


 struct WebURL
  {
     //   static let URLBaseAddress = "http://159.65.129.30/livebait/api/" //DEMO
   // static let URLBaseAddress = "http://132.148.244.89/~livebait/api/" //DEMO
    static let URLBaseAddress = "http://dev2.xicom.us/livebait/api/" //DEMO

  }


struct API
  {

    
    static let API_SignUP = "users/signup"
    static let API_GetProfile = "users/profile"
    static let API_UpdateProfile = "users/update-profile"
    static let API_GetSavedSettings = "users/get-settings"
    static let API_SaveFilterSettings = "users/save-settings"
    static let API_GetUsers = "users/get-users"
    static let API_SharingInfo = "requests/send-detail"
    static let API_Logout = "users/logout"
    static let API_GetNotification = "requests/get-notifications"
    static let API_SaveCallStatus = "requests/save"
    static let API_ReportUser = "requests/report-spam"
    static let API_SaveSubscription = "users/saveSubscription"
    static let API_GeneralInfo = "contents"
    static let API_SaveFeedBack = "users/save-feedback"
    static let API_NotInterested = "users/not-intrested"
    
   //https://docs.google.com/spreadsheets/d/1iOjtwLeS0tTQmSTfgE7qrFKoZjiNCYvpD6f1_4sWfB8/edit#gid=0

}


enum SeekingFor : Int {
    case SeekingForMale = 0
    case SeekingForFemale = 1
    case SeekingForBoth = 2
    case SeekingForNone = 3
}

enum LookingFor : Int {
    case LookingForNone = 0
    case LookingForDate = 1
    case LookingForCuddyBuddy = 2
    case LookingForLove = 3
}


enum SexualBehavior : Int
{
    case SexualBehaviorStraight = 0
    case SexualBehaviorGay = 1
    case SexualBehaviorBisexual = 2
    
}


//sex - 1=>male, 2=>female, 3=>gender diverse

enum GenderType : Int {
    
    case GenderMale = 1
    case GenderFemale = 2
    case GenderDiverse = 3
    case GenderNotFound = 4
}

enum DrinkStatus : Int {
    
    case Yes = 1
    case Socially = 2
    case Never = 3
    case NotFound = 4
}

enum SmokeStatus : Int {
    
    case Yes = 1
    case Socially = 2
    case Never = 3
    case NotFound = 4
}

enum NatureStatus : Int { // 420 Status
    
    case Friendly = 1
    case Never = 2
    case NotFound = 4
}

enum KidsStatus : Int { // KIDs Status
    case Yes = 1
    case No = 0
    case NotFound = 4
}

enum AccountStatus : Int { // Subscription Type Status
    case Free = 1
    case Premium = 2
//    case NotFound = 4
    
}

enum VideoRequestStatus : Int { // Video Request enabled Status
    case Yes = 1
    case No = 0
//    case NotFound = 4
}

enum UserStatus : Int { // USer Profile Active/ Suspended Status
    case Active = 1
    case Suspended = 0
//    case NotFound = 4
}

enum CallStatus : Int
{
    case Dailing = 0 ,
    WaitingForApproval,
    CallDiscarded,
    Connected,
    Free
    
}

let userDefaults = UserDefaults.standard
let chatThreads = "ChatThreads"

enum ErrorMessage : String
{
    case GenderMissing = "Please select your gender."
    case SeekingMissing = "Please enter your seeking type."
    case EmailMissing = "Please enter your email address."
    case EmailValidation = "Please enter valid email address."
    case PasswordMissing = "Please enter password first."
    case PasswordLength = "Please enter password of 6 characters."
    case PasswordConfirmNew = "Please confirm your password."
    case PasswordConfirmMatching = "Confirm password is not matching with new password."
    case DOBMissing = "Please enter your DOB."
    case NickNameMissing = "Please enter your nick name."
    case AboutYou = "Please enter your bio."
    case TermsMissing = "Please read terms and conditions first."
    case ProfileImageMissing = "Please add your profile picture."
    case InterestMissing = "Please select your interests first."
    case ResetPassword = "Please find link on your email."
    case InterestUpdated = "Your interests have been updated successfully."
    case OTPMissing = "Please enter verification code first."
    case OTPLengthMissing = "Please enter valid verification code."

    case PhoneNoMissing = "Please enter valid mobile number."
    case CodeMissing = "Please select country code."
    case HeadingMissing = "Please write something about you first."
    case FullNameMissing = "Please enter your fullname first."
    case UserNameMissing = "Please enter your username first."
    case AgeMissing = "Please enter your age first."

    case OccupationMissing = "Please enter your occupation first."
    case VerificationCodeSent = "Verification code has been sent to your mobile number."
    case LocationDisabled = "Please enable your location first."
    case UserOnAnotherCall = "You are not able to connect to user this time."
    case UserCallRequestOff = "User is not available at that moment."
    case CodeResent = "Verification code resent successfully."
    case FeedBackText = "Please write something about your experience first."

}










