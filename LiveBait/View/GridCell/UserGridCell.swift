//
//  UserGridCell.swift
//  LiveBait
//  Created by maninder on 11/27/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class UserGridCell: UICollectionViewCell {
    
    @IBOutlet weak var lblDistance: UILabel!
    
    var userInfo : User!
    @IBOutlet var imgViewGrid: UIImageView!
    
    @IBOutlet var lblAge: UILabel!
    @IBOutlet var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUserInfo(user : User)
    {
        userInfo = user
        lblAge.text = userInfo.age.description
        lblName.text = userInfo.fullName
        if userInfo.profileImageURL != ""
        {
            let firstImageURL = URL(string : userInfo.profileImageURL)
            imgViewGrid.sd_setImage(with: firstImageURL, placeholderImage: UIImage(named : "UserPH"))
            
        }else if userInfo.userImages.count > 0 {
            let firstImageURL = userInfo.userImages[0].serverURL
            imgViewGrid.sd_setImage(with: firstImageURL, placeholderImage: UIImage(named : "UserPH"))
        }else
        {
            imgViewGrid.image = UIImage(named : "UserPH")
        }
        
        self.lblDistance.text = userInfo.userDistance.description + " Miles"
        
        //        if appDelegate().currentLocation != nil
        //        {
        //
        //            if appDelegate().currentLocation != nil
        //            {
        //                self.lblDistance.text = appDelegate().calculateDistanceInMiles(UserLat: user.latitude, UserLong: user.longitude)
        //            }
        //        }
    }

}
