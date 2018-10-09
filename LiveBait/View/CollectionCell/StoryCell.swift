//
//  StoryCell.swift
//  iWant
//
//  Created by Maninderjit Singh on 26/08/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class StoryCell: UICollectionViewCell {
    
    
    var myImage : LBImage!
    @IBOutlet weak var viewWhite: UIView!
    @IBOutlet weak var viewOuter: UIImageView!
    @IBOutlet weak var imgViewUser: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func assignMyImage(image : LBImage)
    {
       self.myImage = image
        
        if myImage.serverImage == true
        {
            imgViewUser.sd_setImage(with: myImage.serverURL, placeholderImage: userPlaceHolder)
        }else{
         imgViewUser.image = self.myImage.file
      }
    }
}
