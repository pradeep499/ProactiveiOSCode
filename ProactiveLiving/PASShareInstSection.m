//
//  PASShareInstSection.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 13/06/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "PASShareInstSection.h"

@implementation PASShareInstSection

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIView *ViewInst = (UIView *)[self viewWithTag:999];
    ViewInst.layer.borderWidth=3.0f;
    ViewInst.layer.borderColor=[UIColor colorWithRed:1.0/255.0f green:174.0/255.0f blue:240.0/255.0f alpha:1.0].CGColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
