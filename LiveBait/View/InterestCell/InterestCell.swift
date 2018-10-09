//
//  InterestCell.swift
//  DTF
//
//  Created by maninder on 10/13/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class InterestCell: UITableViewCell {

    @IBOutlet var btnSelected: UIButton!
    @IBOutlet var lblInterest: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
