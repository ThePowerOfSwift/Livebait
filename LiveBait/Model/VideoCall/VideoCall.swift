//
//  VideoCall.swift
//  LiveBait
//
//  Created by maninder on 1/31/18.
//  Copyright © 2018 Maninderjit Singh. All rights reserved.
//

import UIKit



class VideoCall: NSObject {
    
    var activeSession : QBRTCSession!
    var status : CallStatus = .Free
    var secondParty : User = User()
    
    
    override init() {
        
        
    }
    
    convenience init(statuNew : CallStatus , session : QBRTCSession , secondUser : User )
   {
        self.init()
        self.activeSession = session
       self.status = statuNew
    self.secondParty = secondUser
}
    
    
    
    
    
}
