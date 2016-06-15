//
//  AppointmentDetailsVC.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 06/04/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentDetailsVC : UIViewController

@property (nonatomic,copy) NSDictionary *dataDict;
@property (weak, nonatomic) IBOutlet UILabel *screenTitle;

@end
