///
//  UICustomCheckBox.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 10/06/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "UICustomCheckBox.h"

@interface UICustomCheckBox (){

}
@end

@implementation UICustomCheckBox
@synthesize checked = _checked;
@synthesize disabled = _disabled;

-(void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    self.checked=NO;
}
-(void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_filterservice_%@check", (self.checked) ? @"" : @"un"]];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    if(self.disabled) {
        self.userInteractionEnabled = FALSE;
        self.alpha = 0.7f;
    } else {
        self.userInteractionEnabled = TRUE;
        self.alpha = 1.0f;
    }

}

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self setThisChecked:!self.checked];

    return TRUE;
}
-(void)setChecked:(BOOL)boolValue
{
    _checked = boolValue;
    [self setNeedsDisplay];

}
-(void)setThisChecked:(BOOL)boolValue {
    _checked = boolValue;
    [self.delegate checkBoxTapped:self status:boolValue];
    [self setNeedsDisplay];

}

-(void)setDisabled:(BOOL)boolValue {
    _disabled = boolValue;
    [self setNeedsDisplay];
}

@end
