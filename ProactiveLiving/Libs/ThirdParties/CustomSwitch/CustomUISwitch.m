//
//  CustomUISwitch.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 13/04/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "CustomUISwitch.h"

@implementation CustomUISwitch

- (void)awakeFromNib {
    [super awakeFromNib];
    self.transform = CGAffineTransformMakeScale(0.75, 0.75);
}

@end
