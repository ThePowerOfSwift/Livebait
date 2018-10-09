//
//  NotificationView.swift
//  LiveBait
//
//  Created by maninder on 2/20/18.
//  Copyright © 2018 Maninderjit Singh. All rights reserved.
//

import UIKit

internal func loadCallNotificationView() -> NotificationView {
    let nib = UINib(nibName: "NotificationView", bundle: nil)
    let view = nib.instantiate(withOwner: nil, options: nil)[0] as! NotificationView
    return view
}
class NotificationView: UIView {

    @IBOutlet weak var lblTimer: UILabel!
    var callBackShowCallerView : ((Bool) -> Void)? = nil

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    
    @IBAction func actionBtnShowCallerView(_ sender: UIButton) {
        if callBackShowCallerView != nil
        {
            self.callBackShowCallerView!(true)
        }
    }
    
}
