//
//  OtherUserProfileCell.swift
//  DTF
//
//  Created by maninder on 12/6/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class OtherUserProfileCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var images : [LBImage] = [LBImage]()
    
    
    @IBOutlet var imgViewPH: UIImageView!
    
    var callBackBack : ((Bool) ->(Void))? = nil
    @IBOutlet var collectionViewPhotos: UICollectionView!
    @IBOutlet var pagingControl: UIPageControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionViewPhotos.registerCollectionNibs(arryNib: ["OtherUserPhotoCell"])
        collectionViewPhotos.delegate = self
        collectionViewPhotos.dataSource = self
        self.pagingControl.currentPage = 0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- CollectionView Delegates
    //MARK:-
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OtherUserPhotoCell", for: indexPath) as! OtherUserPhotoCell
        let imageObj = images[indexPath.row]
        cell.imageViewSecondUser.sd_setImage(with: imageObj.serverURL!, placeholderImage: userPlaceHolder)
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if images.count < 1
        {
            imgViewPH.isHidden = false
        }else{
            imgViewPH.isHidden = true

        }
        
            return images.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenWidth, height: ScreenWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        self.pagingControl.currentPage = currentPage
        // Do whatever with currentPage.
    }
    
    
    
    @IBAction func actionBtnBackPressed(_ sender: UIButton) {
        
        if callBackBack != nil{
            self.callBackBack!(true)
        }
        
        
    }
    
    
    
}
