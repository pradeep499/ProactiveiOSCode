//
//  SignUpCell.m
//  ProactiveLiving
//
//  Created by Hitesh on 1/13/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "SignUpCell.h"
#import "Defines.h"

@implementation SignUpCell

- (void)awakeFromNib {
    self.textFieldBackgroundImageView.layer.borderWidth = 1;
    self.textFieldBackgroundImageView.layer.borderColor = loginBorderColor.CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
