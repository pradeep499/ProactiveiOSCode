//
//  AppointmentListTableCell.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 06/04/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentListTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblFor;
@property (weak, nonatomic) IBOutlet UILabel *lblBy;
@property (weak, nonatomic) IBOutlet UILabel *lblDateTime;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblDD;
@property (weak, nonatomic) IBOutlet UILabel *lblEEE;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIView *sideBarView;
@property (weak, nonatomic) IBOutlet UIImageView *imgCellBG;

@end
