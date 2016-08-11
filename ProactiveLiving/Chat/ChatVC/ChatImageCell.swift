//
//  ChatImageCell.swift
//  Whatsumm
//
//  Created by mawoon on 15/04/15.
//  Copyright (c) 2015 AppStudioz. All rights reserved.
//

import UIKit

class ChatImageCell: UITableViewCell {

    @IBOutlet weak var bubbleConstLead: NSLayoutConstraint!
    @IBOutlet weak var bubbleConstTralng: NSLayoutConstraint!
    @IBOutlet weak var imageLeadingConst: NSLayoutConstraint!
    @IBOutlet weak var imageTrailingConst: NSLayoutConstraint!
    @IBOutlet weak var nameLabelConst: NSLayoutConstraint!
    @IBOutlet weak var timerightAlignment: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
