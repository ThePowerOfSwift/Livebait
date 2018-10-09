//
//  GalleryImageView.swift
//  Drinks
//
//  Created by maninder on 8/10/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class GalleryImageView: UIView {

    @IBOutlet weak var collectionViewImages: UICollectionView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    class func instanceFromNib(width : CGFloat , height : CGFloat) -> GalleryImageView {
        

        let viewFromNib: GalleryImageView = Bundle.main.loadNibNamed("GalleryImageView",
                                                            owner: nil,
                                                            options: nil)?.first as! GalleryImageView
        viewFromNib.frame.size = CGSize(width: width, height: height)
         return  viewFromNib
        
       }

    
    override func draw(_ rect: CGRect) {
        
    }

    
}
