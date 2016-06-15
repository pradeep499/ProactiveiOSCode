//
//  NSDate+Utils.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 07/06/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)

-(BOOL) isLaterThanOrEqualTo:(NSDate*)date {
    return !([self compare:date] == NSOrderedAscending);
}

-(BOOL) isEarlierThan:(NSDate*)date {
    return ([self compare:date] == NSOrderedAscending);
}

-(BOOL) isEarlierThanOrEqualTo:(NSDate*)date {
    return !([self compare:date] == NSOrderedDescending);
}
-(BOOL) isLaterThan:(NSDate*)date {
    return ([self compare:date] == NSOrderedDescending);
}

- (NSDate *) dateByAddingDays:(int)days {
   
    NSDate *retVal;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:days];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    retVal = [gregorian dateByAddingComponents:components toDate:self options:0];
    return retVal;
}

@end
