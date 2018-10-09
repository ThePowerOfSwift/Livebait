//
//  GoogleDriveManager.swift
//  Google Playground
//
//  Created by David Avery on 2/27/17.
//  Copyright © 2017 David Avery. All rights reserved.
//

import Foundation
import GoogleAPIClient
import GTMOAuth2

class GoogleDriveManager: NSObject, GIDSignInDelegate {
    
    private let service = GTLServiceDrive()
    
    override init() {
        super.init()
        // Do any additional setup after loading the view, typically from a nib.
        // Initialize Google Sign-In
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "1075602346198-ruc84h1nem1vsafbb9uh8u8dc120cn8f.apps.googleusercontent.com"
        
        // Use here whatever auth scope you wish (e.g., kGTLAuthScopeDriveReadonly,
        // kGTLAuthScopeDriveMetadata, etc..)
        // You can obviously append more scopes to allow access to more services,
        // other than Google Drive.
        GIDSignIn.sharedInstance().scopes.append(kGTLAuthScopeDrive)
    }
    
    func signOut(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut();
    }
    
    func disconnect(_ sender: Any) {
        GIDSignIn.sharedInstance().disconnect()
    }
    
    func getGoogleDriveFolderHandler(folderName: String) -> GoogleDriveFolderHandler {
        let gDriverFolderHandler = GoogleDriveFolderHandler(service: service, folderName: folderName)
        
        print("Before 2nd thread :")
        print(Date())
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)) {
            print("In 2nd thread :")
            print(Date())
            //gDriverFolderHandler.createFolder()
        }
        print("After 2nd thread :")
        print(Date())
        
        return gDriverFolderHandler
    }
    
    static func checkAuthorizer(service: GTLServiceDrive) {
        
        if (nil != GIDSignIn.sharedInstance().currentUser) {
            service.authorizer = GIDSignIn.sharedInstance().currentUser.authentication.fetcherAuthorizer() as! GTMOAuth2Authentication
        } else {
            print("User isn't logged into Google.")
        }
    }
    
    // MARK: - GIDSignInDelegate Methods
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            // Perform any operations on signed in user here.
            //            let userId = user.userID                  // For client-side use only!
            //            let idToken = user.authentication.idToken // Safe to send to the server
            //            let fullName = user.profile.name
            //            let givenName = user.profile.givenName
            //            let familyName = user.profile.familyName
            //            let email = user.profile.email
            // [START_EXCLUDE]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ToggleAuthUINotification"), object: nil)
            // [END_EXCLUDE]
        } else {
            print("\(error.localizedDescription)")
            // [START_EXCLUDE silent]
            // Set GTMOAuth2Authentication authoriser for your Google Drive service
            //myAuth = user.authentication.fetcherAuthorizer()
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ToggleAuthUINotification"), object: nil)
            // [END_EXCLUDE]
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // [START_EXCLUDE]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ToggleAuthUINotification"), object: nil)
        // [END_EXCLUDE]
    }

}
