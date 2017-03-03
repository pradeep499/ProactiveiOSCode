//
//  AppointmentListingVC.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 06/04/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentListingVC : UIViewController
@property (copy, nonatomic)  NSString *appointmnetType;
@property (nonatomic,copy)NSMutableArray *arrEvents;
@property (nonatomic,copy)NSDate *selectedRecurrenceDate;
@property (copy, nonatomic)  NSString *fromScreenFlag;

@end
