//
//  FilterVC6.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 09/03/17.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit

class FilterVC6: UIViewController {

    @IBOutlet weak var switchLastActive: CustomUISwitch!
    @IBOutlet weak var switchRecent: CustomUISwitch!
    @IBOutlet weak var switchOldest: CustomUISwitch!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        AppHelper.setBorderOnView(tableView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onChangeSwitch(sender: UISwitch) {
        
        if sender.tag == 111 {
            self.switchRecent.setOn(false, animated: true)
            self.switchOldest.setOn(!sender.on, animated: true)
        }
        if sender.tag == 222 {
            self.switchLastActive.setOn(!sender.on, animated: true)
            self.switchOldest.setOn(false, animated: true)
        }
        if sender.tag == 333 {
            self.switchLastActive.setOn(!sender.on, animated: true)
            self.switchRecent.setOn(false, animated: true)
        }
        
    }
    

}
