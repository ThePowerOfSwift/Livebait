//
//  ProfileCell.swift
//  DTF
//
//  Created by maninder on 10/13/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    
    @IBOutlet var imgViewOption: UIImageView!
    
    @IBOutlet var lblOptionValue: UILabel!
    
    @IBOutlet var lblOptionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
