//
//  PASShareCell.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 10/06/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomCheckBox.h"

@interface PASShareCell : UITableViewCell <UICustomCheckBoxDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *sideColorView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UICustomCheckBox *checkBoxScore;
@property (weak, nonatomic) IBOutlet UICustomCheckBox *checkBoxLevel;
@property (weak, nonatomic) IBOutlet UICustomCheckBox *checkBoxRating;
@end
