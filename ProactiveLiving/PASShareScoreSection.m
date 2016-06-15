//
//  PASShareScoreSection.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 13/06/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "PASShareScoreSection.h"
#import "AppHelper.h"

@implementation PASShareScoreSection

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [AppHelper setBorderOnView:self.containerViewPAS];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
