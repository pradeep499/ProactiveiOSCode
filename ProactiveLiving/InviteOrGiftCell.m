//
//  InviteOrGiftCell.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 08/06/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "InviteOrGiftCell.h"
#import "AppHelper.h"

@implementation InviteOrGiftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [AppHelper setBorderOnView:self.containerView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
