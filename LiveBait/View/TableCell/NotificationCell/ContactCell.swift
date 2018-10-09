//
//  ContactCell.swift
//  LiveBait
//
//  Created by maninder on 2/13/18.
//  Copyright © 2018 Maninderjit Singh. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
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

    
    func assignContactInfo(notificationPara : LBNotification)
    {
        self.notificaton = notificationPara
        
        let secondUser = self.notificaton?.sender
        
        
        let fullName = secondUser?.fullName
        let imageURL = secondUser?.profileImageURL
        
        self.imgViewUser.sd_setImage(with: URL(string : imageURL! ), placeholderImage: userPlaceHolder)
        
        self.lblMessage.text = self.notificaton?.notificationMessage
        
        
        
    }
    
    @IBAction func actionBtnSaveContact(_ sender: UIButton) {
        if callBackButton != nil
        {
            self.callBackButton!(notificaton!)
        }
    }
    
}
