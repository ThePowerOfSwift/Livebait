//
//  UserProfileNameCell.swift
//  LiveBait
//
//  Created by maninder on 12/15/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class UserProfileNameCell: UITableViewCell {

    @IBOutlet weak var lblMemberType: UILabel!
    
    @IBOutlet weak var lblAgeGender: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func assignUser(user : User)
    {
        lblMemberType.text = "Free"
        lblName.text  = user.fullName
      var strGender = ""
        if user.genderType == .GenderMale
        {
            strGender = "Male"
        }else if user.genderType == .GenderFemale
        {
            strGender = "Female"
        }else{
            strGender = "Diverse"
        }
        strGender =  strGender + " " + user.age.description
    }
    
}
