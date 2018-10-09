//
//  MSCoreData.swift
//  iCheckbook

//  Created by maninder on 02/03/17.
//  Copyright © 2017 maninder. All rights reserved.
//  +91 7837820722 Maninderjit Singh



import UIKit
import CoreData


let entityUser = "UserEntity"
let entityGroup = "GroupEntity"
let entityThread = "ThreadEntity"
let entityMessage = "MessageEntity"



class MSCoreData: NSObject {
    /*  Handling core data methods for saving, updating, fetching accounts,
     saving, updating, fetching simpel transaction and recurring transactions information
     and saving security information used for authentication purposes
     */
    
    class var sharedInstance: MSCoreData {
        //Shared Instance declaration *(Single time initialization)
        struct Static {
            static let instance: MSCoreData = MSCoreData()
        }
        return Static.instance
    }
    
    //MARK:- Threads
    //MARK:-
    
   




}
