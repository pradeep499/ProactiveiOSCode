//
//  AllAppointmentsVC.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 27/04/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllAppointmentsVC : UIViewController

@property (nonatomic,copy)NSArray *arrEvents;
@property (nonatomic,copy)NSDate *selectedRecurrenceDate;
@property (copy, nonatomic)  NSString *fromScreenFlag;

@end
