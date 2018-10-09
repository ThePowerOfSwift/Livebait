//
//  ImageCollectionCell.swift
//  Drinks
//
//  Created by maninder on 8/10/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit
import Photos

class ImageCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imgHighlighted: UIImageView!
    var asset : PHAsset!
    @IBOutlet weak var imgViewPhoto: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    
    func setAssetImage(selectedImage : PHAsset?){
        if selectedImage !=  nil
        {
            if selectedImage == self.asset
            {
                self.imgHighlighted.isHidden = false
                
            }else{
                self.imgHighlighted.isHidden = true
                
            }
        } else {
            self.imgHighlighted.isHidden = true
        }
        
        AssetManager.resolveAsset(asset, size: CGSize(width: 160, height: 240)) { image in
            if let image = image {
                self.imgViewPhoto.image = image
                
            }
        }
    }
}
