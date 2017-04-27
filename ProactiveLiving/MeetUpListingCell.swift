//
//  MeetUpListingCell.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 07/09/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit

class MeetUpListingCell: UITableViewCell {

    @IBOutlet weak var bkImageView: UIImageView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnDecline: UIButton!
    @IBOutlet weak var imgAccept: UIImageView!
    @IBOutlet weak var imgDecline: UIImageView!
    
    @IBOutlet weak var layOut_addressHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //button color
        btnAccept.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btnDecline.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        btnAccept.setTitleColor(UIColor(red: 1/255.0, green: 174/255.0, blue: 240/255.0, alpha: 1.0), forState: UIControlState.Selected)
        btnDecline.setTitleColor(UIColor(red: 1/255.0, green: 174/255.0, blue: 240/255.0, alpha: 1.0), forState: UIControlState.Selected)

    
        
        imgAccept.hidden=true
        imgDecline.hidden=true
        btnAccept.layer.borderWidth=1.0;
        btnDecline.layer.borderWidth=1.0;
        btnAccept.layer.borderColor=UIColor.clearColor().CGColor
        btnDecline.layer.borderColor=UIColor.clearColor().CGColor


    }
    @IBAction func btnSureClick(sender: UIButton) {
        
        
        
    }
    
    @IBAction func btnSorryClick(sender: UIButton) {

           
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
