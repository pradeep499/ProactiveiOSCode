//
//  DeleteAcVC.swift
//  ProactiveLiving
//
//  Created by Affle on 26/12/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit

class DeleteACVC: UIViewController {

    @IBOutlet weak var tableView_countryList: UITableView!
   
    @IBOutlet weak var tf_countryCode: CustomTextField!
    
    @IBOutlet weak var tf_phoneNo: CustomTextField!
    
    @IBOutlet weak var tf_pwd: CustomTextField!
    
    
    @IBOutlet weak var btn_countryCode: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func onClickBackBtn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    
    @IBAction func onClickCountryBtn(sender: AnyObject) {
    }
    
    
    @IBAction func onClickSubmitBtn(sender: AnyObject) {
    }
    
    
}


extension DeleteACVC: UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        <#code#>
    }
}
