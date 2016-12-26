//
//  SettingsOrgCell.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 31/05/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomUISwitch.h"

@interface SettingsOrgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblOrganization;
@property (weak, nonatomic) IBOutlet UILabel *lblUID;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet CustomUISwitch *orgSwitch;
@property (weak, nonatomic) IBOutlet UILabel *lblOrgHeader;

@end
