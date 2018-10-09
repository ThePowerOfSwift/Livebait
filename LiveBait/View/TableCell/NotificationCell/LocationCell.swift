//
//  LocationCell.swift
//  LiveBait
//
//  Created by maninder on 2/13/18.
//  Copyright © 2018 Maninderjit Singh. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    var callBackButton : ((LBNotification) ->Void)? = nil
    
    @IBOutlet weak var lblMessage: UILabel!
    var notificaton : LBNotification? = nil
    @IBOutlet weak var imgViewUser: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgViewUser.cornerRadius(value: 25)

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func assignLocationInfo(notificationPara : LBNotification)
    {
        self.notificaton = notificationPara
        let secondUser = self.notificaton?.sender
        let imageURL = secondUser?.profileImageURL
        self.imgViewUser.sd_setImage(with: URL(string : imageURL! ), placeholderImage: userPlaceHolder)
        
        self.lblMessage.text = (secondUser?.fullName)! + " wants to share his/her location with you."
    }
    
    @IBAction func actionBtnSaveContact(_ sender: UIButton) {
        if callBackButton != nil
        {
            self.callBackButton!(notificaton!)
        }
    }
    
}
