//
//  MessageListCell.swift
//  iWant
//
//  Created by Maninderjit Singh on 29/08/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class MessageListCell: UITableViewCell {
    @IBOutlet weak var viewBlue: UIView!

    var thread : ChatThread? = nil
    
    @IBOutlet var lblLastMessage: UILabel!
    @IBOutlet var lblUserName: UILabel!
    
    @IBOutlet weak var viewWhite: UIView!
    @IBOutlet weak var imgViewUser: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgViewUser.cornerRadius(value: 30)
        
        viewBlue.cornerRadius(value: 35)
        viewWhite.cornerRadius(value: 33)

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func assignChatInfo(chat : ChatThread)
    {
        self.thread = chat
        
        let lastMessageUser = self.thread?.lastMessage.senderUser
        
        setUserImage(imgView: imgViewUser, strURL: (lastMessageUser?.profileImageURL)!)
        
    self.lblLastMessage.text = self.thread?.lastMessage.message
        self.lblUserName.text = lastMessageUser?.nickName

    
        
    }
}
