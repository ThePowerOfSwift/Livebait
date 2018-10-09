//
//  CardView.swift
//  DTF
//
//  Created by maninder on 10/31/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var cardUser : User!
    @IBOutlet var imgViewUser: UIImageView!

    @IBOutlet var imgViewOnline: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
  */
    override func draw(_ rect: CGRect) {
        // Drawing code
        //self.cornerRadius(value: 10)
    }
    
    func setUpCardInfo(user : User)
    {
        self.cardUser = user
        imgViewUser.sd_setImage(with: URL(string : self.cardUser.profileImageURL), placeholderImage: userPlaceHolder)
        lblUserName.text = self.cardUser.nickName
    }
    
    

}
