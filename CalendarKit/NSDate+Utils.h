//
//  NSDate+Utils.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 07/06/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utils)
-(BOOL) isLaterThanOrEqualTo:(NSDate*)date;
-(BOOL) isEarlierThanOrEqualTo:(NSDate*)date;
-(BOOL) isLaterThan:(NSDate*)date;
-(BOOL) isEarlierThan:(NSDate*)date;
- (NSDate*) dateByAddingDays:(int)days;
@end
