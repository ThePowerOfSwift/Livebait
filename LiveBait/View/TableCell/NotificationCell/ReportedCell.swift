//
//  ReportedCell.swift
//  LiveBait
//
//  Created by maninder on 2/15/18.
//  Copyright © 2018 Maninderjit Singh. All rights reserved.
//

import UIKit

class ReportedCell: UITableViewCell {

    @IBOutlet weak var lblMessage: UILabel!
    
    var callBackButton : ((LBNotification) ->Void)? = nil
    
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
    
    
    func assignReportData(notificationPara : LBNotification)
    {
        self.notificaton = notificationPara
        self.imgViewUser.sd_setImage(with: URL(string : LoginManager.getMe.profileImageURL ), placeholderImage: userPlaceHolder)
        
        
        print(self.notificaton?.notificationMessage)
    self.lblMessage.text = self.notificaton?.notificationMessage
    }
    
    
    @IBAction func actionBtnSaveContact(_ sender: UIButton) {
        
       if callBackButton != nil
       {
        self.callBackButton!(notificaton!)
       }
     }
}
