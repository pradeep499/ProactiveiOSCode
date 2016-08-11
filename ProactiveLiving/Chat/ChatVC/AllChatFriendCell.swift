//
//  AllChatFriendCell.swift
//  Whatsumm
//
//  Created by mawoon on 20/04/15.
//  Copyright (c) 2015 AppStudioz. All rights reserved.
//

import UIKit

class AllChatFriendCell: UITableViewCell {
    @IBOutlet weak var userName: UILabel!

    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
