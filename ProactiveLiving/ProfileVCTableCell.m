//
//  ProfileVCTableCell.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 16/02/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "ProfileVCTableCell.h"

@implementation ProfileVCTableCell

- (void)awakeFromNib {
    // Initialization code
    self.txtDetails.textContainer.lineFragmentPadding = 0;
    self.txtDetails.textContainerInset = UIEdgeInsetsZero;
    
    [self.btnShowMore setImage:[UIImage imageNamed:@"ic_profile_seemore"] forState:UIControlStateNormal];
    [self.btnShowMore setImage:[UIImage imageNamed:@"ic_profile_seeless"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
