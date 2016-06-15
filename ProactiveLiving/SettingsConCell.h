//
//  SettingsConCell.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 31/05/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomUISwitch.h"

@interface SettingsConCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblContactTypes;
@property (weak, nonatomic) IBOutlet CustomUISwitch *switchShareContact;

@end
