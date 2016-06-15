//
//  PASShareScoreSection.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 13/06/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PASShareScoreSection : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblPAScore;
@property (weak, nonatomic) IBOutlet UILabel *lblPALevel;
@property (weak, nonatomic) IBOutlet UILabel *lblPARating;
@property (weak, nonatomic) IBOutlet UILabel *lblPASValidationDate;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentDate;
@property (weak, nonatomic) IBOutlet UIView *containerViewPAS;

@end
