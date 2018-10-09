//
//  UserProfileOptionCell.swift
//  LiveBait
//
//  Created by maninder on 12/15/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class UserProfileOptionCell: UITableViewCell {
    @IBOutlet weak var lblOptionValue: UILabel!
    
    @IBOutlet weak var imgViewMarijuna: UIImageView!
    @IBOutlet weak var lblOptionName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
