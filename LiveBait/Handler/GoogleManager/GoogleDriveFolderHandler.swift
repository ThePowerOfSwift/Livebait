//
//  GoogleDriveWorker.swift
//  Google Playground
//
//  Created by David Avery on 2/27/17.
//  Copyright © 2017 David Avery. All rights reserved.
//

import Foundation
import GoogleAPIClient

enum GoogleDriveError: Error {
    case folderNotFound(advice: String)
}

class GoogleDriveFolderHandler: NSObject {
    
    private var service: GTLServiceDrive
    var folderName: String
    var folderId: String
    var error: NSError?  // Useful for debugging, but cannot catch or immediately inspect as this is set on callback handlers.  The program
    // cannot quarantee execution timing.
    
    override init() {
        self.service = GTLServiceDrive()
        self.folderName = ""
        self.folderId = ""
        super.init()
    }
    
    init(service: GTLServiceDrive, folderName: String) {
        self.service = service
        self.folderName = folderName
        self.folderId = ""
        super.init()
    }
    
    func createFolder() {
        
        GoogleDriveManager.checkAuthorizer(service: service)
        
        if let authorizer = service.authorizer, let canAuth = authorizer.canAuthorize, canAuth {
            // service is authorised and can be used for queries
            let search = "name = '\(folderName)' and trashed = false"
            let query = GTLQueryDrive.queryForFilesList()
            query?.fields = "nextPageToken, files(id, name)"
            query?.q = search
            service.executeQuery(
                query!,
                delegate: self,
                didFinish: #selector(GoogleDriveFolderHandler.createFolderCallBack(ticket:finishedWithObject:error:))
            )
        } else {
            // service is not authorised
            print("Service is not authorized.")
        }
        
    }
    
    
    @objc private func createFolderCallBack(ticket : GTLServiceTicket,
                                            finishedWithObject response : GTLDriveFileList,
                                            error : NSError?) {
        
        if let error = error {
            self.error = error
            print("Error received on Google Drive API Call Back.  Error: \(error)")
            return
        }
        
        var folderExists = false
        if let files = response.files, !files.isEmpty {
            for file in files as! [GTLDriveFile] {
                if (folderName == file.name) {
                    folderExists = true
                    self.folderId = file.identifier
                    print("File ID: \(file.identifier)")
                }
            }
        }
        
        if (!folderExists) {
            // Create a Folder
            let metadata = GTLDriveFile()
            metadata.name = folderName
            metadata.mimeType = "application/vnd.google-apps.folder"
            let query2 = GTLQueryDrive.queryForFilesCreate(withObject: metadata, uploadParameters: nil)
            query2?.fields = "id"
            
            // I cannot return the file.indentifier from the closure {(. . .)} to the calling class so storing in member variable folderId.            
            service.executeQuery(query2!, completionHandler: {(ticket, file, error) -> Void in
                let tempFile = file as! GTLDriveFile
                let fileId = tempFile.identifier
                print("File ID \(fileId)")
                
                self.folderId = fileId!
                print("complete")
            })
        } else {
            print("Folder already exists in Google Drive.")
        }
        
    }
    
    func addFile(parent : String) {
        
        GoogleDriveManager.checkAuthorizer(service: service)
        
        if let authorizer = service.authorizer, let canAuth = authorizer.canAuthorize, canAuth {
            // service is authorized and can be used for queries
            
            // Create a file in our newly created folder
            let title = "Upload.txt"
            let content = "hello world \n maninderjit Singh"
            let mimeType = "text/plain"
            let fileData = GTLDriveFile()
            fileData.name = title
            
            if !parent.isEmpty {
                print("Parent ID: \(self.folderId)")
                fileData.parents = [self.folderId]
            }
            let data = content.data(using: String.Encoding.utf8, allowLossyConversion: true)
            let uP = GTLUploadParameters(data: data!, mimeType: mimeType)
            let query3 = GTLQueryDrive.queryForFilesCreate(withObject: fileData, uploadParameters: uP)
            
            let serviceTicket = service.executeQuery(query3!, completionHandler: {(ticket, file, error) -> Void in
                print("complete")
            })
            
            serviceTicket?.uploadProgressBlock = {(ticket, written, total) in
                print("making progress")
            }
            
        } else {
            // service is not authorized
            print("Service is not authorized.")
        }
        
    }
    
    func addImage(parent : String, title : String, image : UIImage) throws {
        
        GoogleDriveManager.checkAuthorizer(service: service)
        
        if let authorizer = service.authorizer, let canAuth = authorizer.canAuthorize, canAuth {
            // service is authorized and can be used for queries
            
            // Make sure we have a folderID if the folderName has been set.  We are using services that are not guaranteed to work 100% of the time.
            if("" == folderId && "" != folderName) {
                throw GoogleDriveError.folderNotFound(advice: "Please try again.")
            }
            
            let data = UIImagePNGRepresentation(image) as Data?
            
            let mimeType = "image/jpeg"
            let fileData = GTLDriveFile()
            fileData.name = title
            
            if !parent.isEmpty {
                print("Parent ID: \(parent)")
                fileData.parents = [parent]
            }
            
            let uP = GTLUploadParameters(data: data!, mimeType: mimeType)
            let query3 = GTLQueryDrive.queryForFilesCreate(withObject: fileData, uploadParameters: uP)
            query3?.fields = "id"
            
            let serviceTicket = service.executeQuery(query3!, completionHandler: {(ticket, file, error) -> Void in
                print("complete")
                let tempFile = file as! GTLDriveFile
                let fileId = tempFile.identifier
                print("File ID \(fileId)")
            })
            
            serviceTicket?.uploadProgressBlock = {(ticket, written, total) in
                print("making progress")
            }

        } else {
            // service is not authorized
            print("Service is not authorized.")
        }
        
    }
    
//    func fetchFiles(_ sender: Any) {
//        
//        checkAuthorizer()
//        
//        if let authorizer = service.authorizer, let canAuth = authorizer.canAuthorize, canAuth {
//            // service is authorised and can be used for queries
//            print("Getting files...")
//            let query = GTLQueryDrive.queryForFilesList()
//            query?.pageSize = 10
//            query?.fields = "nextPageToken, files(id, name)"
//            service.executeQuery(
//                query!,
//                delegate: self,
//                didFinish: #selector(GoogleDriveHandler.displayResultWithTicket(ticket:finishedWithObject:error:))
//            )
//            
//        } else {
//            // service is not authorised
//            print("Service is not authorized.")
//        }
//        
//        
//    }
//    
//    // Parse results and display
//    func displayResultWithTicket(ticket : GTLServiceTicket,
//                                 finishedWithObject response : GTLDriveFileList,
//                                 error : NSError?) throws {
//        
//        if let error = error {
//            throw error
//        }
//        
//        var filesString = ""
//        
//        if let files = response.files, !files.isEmpty {
//            filesString += "Files:\n"
//            for file in files as! [GTLDriveFile] {
//                filesString += "\(file.name) (\(file.identifier))\n"
//            }
//        } else {
//            filesString = "No files found."
//        }
//        
//        print(filesString)
//    }

}
