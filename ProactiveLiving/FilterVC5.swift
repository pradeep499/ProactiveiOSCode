//
//  FilterVC5.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 09/03/17.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit


class FilterVC5: UIViewController {

    var arrData = [String]()
    var arrSelectedRow = [String]()
    
    @IBOutlet weak var switchPublic: CustomUISwitch!
    @IBOutlet weak var switchPrivate: CustomUISwitch!
    @IBOutlet weak var switchAny: CustomUISwitch!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        arrData = ["Experts", "Colleagues", "Health Club Members", "Friends", "All"];
        AppHelper.setBorderOnView(tableView)
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onChangeSwitch(sender: AnyObject) {
        
        if sender.tag == 111 {
            self.switchPrivate.setOn(false, animated: true)
            self.switchAny.setOn(!sender.on, animated: true)
        }
        if sender.tag == 222 {
            self.switchPublic.setOn(!sender.on, animated: true)
            self.switchAny.setOn(false, animated: true)
        }
        if sender.tag == 333 {
            self.switchPublic.setOn(!sender.on, animated: true)
            self.switchPrivate.setOn(false, animated: true)
        }

    }
}

// MARK:- Extension

extension FilterVC5 : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Created by"
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return popOverCellData.count
        return arrData.count
        
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCellWithIdentifier("FilterFiveCell", forIndexPath: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let lblTitle = cell.viewWithTag(111) as! UILabel
        let imgRadio = cell.viewWithTag(222) as! UIImageView
        
        if(arrSelectedRow.contains(arrData[indexPath.row])) {
            imgRadio.image = UIImage(named: "radio_selected")
        }
        else {
            imgRadio.image = UIImage(named: "radio")
        }
        lblTitle.text = arrData[indexPath.row]
        return cell
        
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        /* if(arrSelectedRow.contains(arrData[indexPath.row])) { // For checkbox
            
            arrSelectedRow.removeAtIndex(arrSelectedRow.indexOf(arrData[indexPath.row])!)
        }
        else {
            arrSelectedRow.append(arrData[indexPath.row])
        }
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None) */
        
        arrSelectedRow.removeAll() // For radiobox
        arrSelectedRow.append(arrData[indexPath.row])
        tableView.reloadData()
    }
    
}
