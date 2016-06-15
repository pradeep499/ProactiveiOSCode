//
//  CalendarCellDot.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 12/04/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarCellDot : UIView

@property (nonatomic, assign) BOOL *isMultiColor;
-(void)drawDotWithColor:(UIColor *)color;

@end
