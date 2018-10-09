//
//  PremiumPlan.swift
//  Drinks
//
//  Created by maninder on 9/28/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class PremiumPlan: NSObject
{
    
    var engName : String!
    var japName : String!
    var amount : Double!
    var planID : String!
    var planDescription : String!

    var discount : Double!
    
    override init()
    {
        
        
        
    }
    
    
    
    convenience  init(dict : Any)
    {
        self.init()
        
        guard let dictPlan = dict as? Dictionary<String, Any> else {
            return
        }
     
        engName = dictPlan["eng_name"] as! String
        japName = dictPlan["jap_name"] as! String
        planID = dictPlan["id"] as! String
        amount = dictPlan["amount"] as! Double
        planDescription = dictPlan["description"] as! String
        discount = dictPlan["discount"] as! Double


        
       // amount = Decimal(string: decimal)
        
    }
    
   
}
