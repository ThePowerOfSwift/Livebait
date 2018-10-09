//
//  AddImageCell.swift
//  LiveBait
//
//  Created by maninder on 12/6/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class AddImageCell: UICollectionViewCell {
    var callbackAddImage :  ((Bool) -> Void)? = nil

    @IBOutlet var btnAddImage: UIButton!
    
    @IBOutlet weak var viewWhite: UIView!
    @IBOutlet weak var viewOuter: UIImageView!
    @IBOutlet weak var imgViewUser: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func actionBtnAddImage(_ sender: UIButton) {
        if self.callbackAddImage != nil{
            self.callbackAddImage!(true)
        }
    }
    
    

}
