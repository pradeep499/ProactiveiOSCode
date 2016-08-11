//
//  ChatTextCell.swift
//  Whatsumm
//
//  Created by mawoon on 15/04/15.
//  Copyright (c) 2015 AppStudioz. All rights reserved.
//

import UIKit

class ChatTextCell: UITableViewCell {
    @IBOutlet weak var textViewWidthConst: NSLayoutConstraint!
    @IBOutlet weak var horizontalSpacingConst1: NSLayoutConstraint!
    @IBOutlet weak var heightNameLabel: NSLayoutConstraint!
    @IBOutlet weak var timelblsetConst: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
