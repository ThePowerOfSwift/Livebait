//
//  UserFeedCollectionCell.swift
//  iWant
//
//  Created by Maninderjit Singh on 20/09/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class UserFeedCollectionCell: UICollectionViewCell,UITableViewDelegate,UITableViewDataSource {

    var callbackChat : ((Int)->Void)? = nil

    var feedArray : [UIImage] = [UIImage]()
    @IBOutlet weak var tblUserFeed: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tblUserFeed.registerNibsForCells(arryNib: ["PhotoCell"])
        tblUserFeed.delegate = self
        tblUserFeed.dataSource = self

        // Initialization code
    }
    
    
    //MARK:- TableView Delegates
    //MARK:-
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return feedArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath as IndexPath) as! PhotoCell
        
//        cell.imgViewThumbNail.image = feedArray[indexPath.row]
//        cell.feedIndex = indexPath.row
//
//        cell.callbackHome = { (index : Int) in
//
//            if  self.callbackChat != nil{
//                self.callbackChat!(index)
//            }
//
//
//        }
        return cell
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return ScreenWidth + 10
        
    }

    
    
    func updateTable()
    {
        
      self.tblUserFeed.reloadData()
    }

}
