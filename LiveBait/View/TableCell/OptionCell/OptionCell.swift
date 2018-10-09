//
//  OptionCell.swift
//  LiveBait
//
//  Created by maninder on 11/27/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class OptionCell: UITableViewCell {
    @IBOutlet var lblOptionTitle: UILabel!
    
    @IBOutlet var imgViewOption: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
