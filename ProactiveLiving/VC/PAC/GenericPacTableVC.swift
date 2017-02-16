//
//  GenericPacTableVC.swift
//  ProactiveLiving
//
//  Created by Affle on 16/02/2017.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit
enum PacGenericType{
    
    case Find
}

class GenericPacTableVC: UIViewController {
    var genericType:PacGenericType!

    @IBOutlet weak var tv_generic: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.tv_generic.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension GenericPacTableVC: UITableViewDataSource{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat    {
        
        if genericType == .Find{
            
           // return  self.setAboutMeCellHeight(tableView, indexPath: indexPath)
        }
        return 200
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.genericType == .Find {
            self.setUpFindCell(tableView, indexPath: indexPath)
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FindCell", forIndexPath: indexPath)
        return cell
    }
    
    func setUpFindCell(tv: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =  tv.dequeueReusableCellWithIdentifier("FindCell", forIndexPath: indexPath)
        
        
        
        let iv_item = cell.viewWithTag(1) as! UIImageView
        let iv_itemDec = cell.viewWithTag(2) as! UIImageView
        let lbl_title = cell.viewWithTag(3) as! UILabel
        let lbl_by = cell.viewWithTag(4) as! UILabel
        let lbl_members = cell.viewWithTag(5) as! UILabel
        let lbl_activateTime = cell.viewWithTag(6) as! UILabel
        let lbl_privacy = cell.viewWithTag(7) as! UILabel
        let lbl_desc = cell.viewWithTag(8) as! UILabel
        let lbl_createdAt = cell.viewWithTag(9) as! UILabel
        let lbl_distance = cell.viewWithTag(10) as! UILabel
        
        
        
        iv_item.sd_setImageWithURL(NSURL.init(string: ""), placeholderImage: UIImage.init(named: ""))
        
        
        return cell
    }
    
    
}

extension GenericPacTableVC:  UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}
