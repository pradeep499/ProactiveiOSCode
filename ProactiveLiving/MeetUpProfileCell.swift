//
//  MeetUpProfileCell.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 15/09/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit

class MeetUpProfileCell: UITableViewCell {

    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCreatedBy: UILabel!
    @IBOutlet weak var lblForwardBy: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var img_recurance: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let placeholder = UIImage(named: "no_photo")
        self.imageView?.image = placeholder
        self.imgProfile.layer.borderWidth = 1.0
        self.imgProfile.contentMode = .ScaleAspectFill
        self.imgProfile.backgroundColor = UIColor.whiteColor()
        self.imgProfile.layer.masksToBounds = false
        self.imgProfile.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.imgProfile.layer.cornerRadius = 23
        self.imgProfile.clipsToBounds = true
    }
    
}
