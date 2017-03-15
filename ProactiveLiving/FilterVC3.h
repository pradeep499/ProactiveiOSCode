//
//  FilterVC3.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 04/02/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomUISwitch.h"

@interface FilterVC3 : UIViewController

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet CustomUISwitch *switch1;
@property (weak, nonatomic) IBOutlet CustomUISwitch *switch2;
@property (weak, nonatomic) IBOutlet CustomUISwitch *switch3;

@property (nonatomic,retain) NSMutableArray *selectedRowsArray;
@property (nonatomic,copy)NSString *latlong;
@end
