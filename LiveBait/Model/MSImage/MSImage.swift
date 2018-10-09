//
//  MSImage.swift
//  Drinks
//
//  Created by maninder on 8/3/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit



class Location
{
    
    var latitude : Double!
    var longitude : Double!
    var locationName : String!
    init()
    {
      latitude = 0.0
      longitude = 0.0
        locationName = ""
    }

    
    init(latitude: Double, longitude : Double, locationName: String)
    {
        self.latitude = latitude
        self.longitude = longitude
        self.locationName = locationName
    }
    
    init(latitude: Double, longitude : Double)
    {
        self.latitude = latitude
        self.longitude = longitude
    }
}


class MSImage: NSObject {

    
    var file : UIImage!
    var name : String!
    var filename : String!
    var mimeType : String!
    
    init(file: UIImage, variableName name: String, fileName filename: String, andMimeType mimeType: String)
    {
        self.file = file
        self.name = name
        self.filename = filename
        self.mimeType = mimeType
    }
}


class LBImage: NSObject,NSCoding {

    var serverImage = false
    var serverURL : URL!
    var file : UIImage!
    var name : String!
    var filename : String!
    var mimeType : String!
    var serverString : String!
    

    init(file: UIImage, variableName name: String, fileName filename: String, andMimeType mimeType: String)
    {
        self.file = file
        self.name = name
        self.filename = filename
        self.mimeType = mimeType
    }
    
    
    init(link : String )
    {
        serverImage = true
        self.serverString = link
        self.serverURL = URL(string : link)
    }
    
    
    
    required init?(coder aDecoder: NSCoder)
    {
        
        self.serverImage = aDecoder.decodeBool(forKey: "serverImage")
        
        let serverStr : String? = aDecoder.decodeObject(forKey: "serverString") as? String
        if serverStr != nil {
            self.serverString = serverStr;
        }
        
        let url  = aDecoder.decodeObject(forKey: "serverURL") as? URL
        if url != nil {
            self.serverURL = url;
        }
        
    }
    
    public func encode(with aCoder: NSCoder)
    {
        
        aCoder.encode(self.serverImage, forKey: "serverImage")
        aCoder.encode(self.serverString, forKey: "serverString")
        aCoder.encode(self.serverURL, forKey: "serverURL")
        
    }
}

class MSFilter: NSObject,NSCoding {
    
    
    var filterID : String = ""
    var datingType : [GenderType] = [GenderType]()
    var distance : Int = 0
    var minimumAge : Int = 0
    var maximumAge : Int = 0
    var vibration : Bool = false
    var pushNotification : Bool = false

    
    override init()
    {
        
    }
    

   init(dictFilter : [String : Any] )
    {
       if let genderTypeStr = dictFilter["dating"] as? String
       {
         self.datingType.removeAll()
        if genderTypeStr != ""
        {
            let arrGenders = genderTypeStr.components(separatedBy: ",")
            let uniqueArray = Set(arrGenders)
           
            for item in uniqueArray
            {
                let intValuGender = Int(item)
                if intValuGender != 0
                {
                    let gendertype = GenderType(rawValue : intValuGender!)!
                    self.datingType.append(gendertype)
                    
                }
                
            }
        }
      }
        pushNotification = dictFilter["push_notifications"] as! Bool
        
      vibration = dictFilter["app_sound_vibration"] as! Bool
       
        self.minimumAge = Int(dictFilter["age_from"] as! Float)
        
        
        if  self.minimumAge == 0 {
            self.minimumAge = 18
        }
        
        self.maximumAge =  Int(dictFilter["age_to"] as! Float)
        if let distance = dictFilter["distance"] as? Int
        {
            self.distance = distance
        }else
        {
            self.distance = Int(dictFilter["distance"] as! String)!
        }
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder)
    {
        

        
    }
    
    public func encode(with aCoder: NSCoder)
    {


    }
}

