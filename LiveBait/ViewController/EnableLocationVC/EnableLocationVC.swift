//
//  EnableLocationVC.swift
//  LiveBait
//
//  Created by maninder on 12/19/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class EnableLocationVC: UIViewController {

    @IBOutlet weak var btnAllow: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnAllow.cornerRadius(value: 4)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionBtnEnableLocation(_ sender: Any) {
             // initializeLocationManager()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
