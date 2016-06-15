//
//  ProfileVCTableCell2.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 18/02/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "ProfileVCTableCell2.h"

@implementation ProfileVCTableCell2

- (void)awakeFromNib {
    // Initialization code
}

- (void)drawRect:(CGRect)rect
{
    CGRect labelFrame = self.lblDetail.frame;
    CGRect imageFrame = self.imgSideBar.frame;
    int indentation = (int) self.treeNode.nodeLevel * 10;
    labelFrame.origin.x = 10 + indentation;
    imageFrame.origin.x = 5 + indentation;
    self.lblDetail.frame = labelFrame;
    self.imgSideBar.frame = imageFrame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
