//
//  PASShareCell.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 10/06/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "PASShareCell.h"
#import "AppHelper.h"
typedef NS_ENUM(NSInteger, EnumTappedCheckBox) {
    scoreCheckBox,
    LevelCheckBox,
    RatingCheckBox
};

@implementation PASShareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [AppHelper setBorderOnView:self.containerView];
    self.checkBoxScore.tag=scoreCheckBox;
    self.checkBoxLevel.tag=LevelCheckBox;
    self.checkBoxRating.tag=RatingCheckBox;
    self.checkBoxScore.delegate = self;
    self.checkBoxLevel.delegate = self;
    self.checkBoxRating.delegate = self;

}
- (void)checkBoxTapped:(UIControl *)checkbox status:(BOOL)status
{
    if (checkbox.tag == self.checkBoxScore.tag) {
        [self.checkBoxScore setChecked:status];
        [self.checkBoxLevel setChecked:status];
        [self.checkBoxRating setChecked:status];
    }
    
    if (checkbox.tag == self.checkBoxLevel.tag) {
        [self.checkBoxScore setChecked:NO];
        [self.checkBoxLevel setChecked:status];
        [self.checkBoxRating setChecked:status];
    }
    if (checkbox.tag == self.checkBoxRating.tag) {
        [self.checkBoxScore setChecked:NO];
        [self.checkBoxLevel setChecked:NO];
        [self.checkBoxRating setChecked:status];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
