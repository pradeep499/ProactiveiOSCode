//
//  CalendarCellDot.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 12/04/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "CalendarCellDot.h"
#import "NSString+Color.h"
#define PI 3.14159265358979323846
static inline float radians(double degrees) { return degrees * PI / 180; }

@implementation CalendarCellDot

- (void)drawRect:(CGRect)rect {
    
    if(CGColorEqualToColor(self.backgroundColor.CGColor, [UIColor whiteColor].CGColor))
    [self drawDotWithColor:nil];
   
}

-(void)drawDotWithColor:(UIColor *)color
{
    
        CGPoint center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f, CGRectGetHeight(self.bounds) / 2.f);
        CGFloat radius = 8.f;
        
        UIBezierPath *portionPath1 = [UIBezierPath bezierPath];
        [portionPath1 moveToPoint:center];
        [portionPath1 addArcWithCenter:center radius:radius startAngle:radians(0) endAngle:radians(120) clockwise:YES];
        [portionPath1 closePath];
        [[@"#ef6c00" toColor] setFill];
        [portionPath1 fill];
        
        UIBezierPath *portionPath2 = [UIBezierPath bezierPath];
        [portionPath2 moveToPoint:center];
        [portionPath2 addArcWithCenter:center radius:radius startAngle:radians(120) endAngle:radians(240) clockwise:YES];
        [portionPath2 closePath];
        [[@"#9c27b0" toColor] setFill];
        [portionPath2 fill];
        
        UIBezierPath *portionPath3 = [UIBezierPath bezierPath];
        [portionPath3 moveToPoint:center];
        [portionPath3 addArcWithCenter:center radius:radius startAngle:radians(240) endAngle:radians(360) clockwise:YES];
        [portionPath3 closePath];
        [[@"#4caf50" toColor] setFill];
        [portionPath3 fill];
    
}
@end
