//
//  TabBarView.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 25/02/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "TabBarView.h"
#import "AppHelper.h"
#import "Defines.h"

@implementation TabBarView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        //inialize ivars
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
   
    UIButton *button1 =  (UIButton*)[self viewWithTag:1];
    UIButton *button2 =  (UIButton*)[self viewWithTag:2];
    UIButton *button3 =  (UIButton*)[self viewWithTag:3];
    UIButton *button4 =  (UIButton*)[self viewWithTag:4];
    UIButton *button5 =  (UIButton*)[self viewWithTag:5];
    
    [button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button1 setTitleColor:[AppHelper colorFromHexString:@"#01aef0" alpha:1.0] forState:UIControlStateSelected];
    [button1 addTarget:self action:@selector(calenderClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [button2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button2 setTitleColor:[AppHelper colorFromHexString:@"#01aef0" alpha:1.0] forState:UIControlStateSelected];
    [button2 addTarget:self action:@selector(inboxClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [button3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button3 setTitleColor:[AppHelper colorFromHexString:@"#01aef0" alpha:1.0] forState:UIControlStateSelected];
    [button3 addTarget:self action:@selector(homeClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [button4 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button4 setTitleColor:[AppHelper colorFromHexString:@"#01aef0" alpha:1.0] forState:UIControlStateSelected];
    [button4 addTarget:self action:@selector(pasClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [button5 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button5 setTitleColor:[AppHelper colorFromHexString:@"#01aef0" alpha:1.0] forState:UIControlStateSelected];
    [button5 addTarget:self action:@selector(menuClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [button1 setImage:[UIImage imageNamed:@"ic_more_tabar_calendar"] forState:UIControlStateNormal];
    [button1 setImage:[UIImage imageNamed:@"ic_more_tabar_calendar_active"] forState:UIControlStateSelected];
    
    [button2 setImage:[UIImage imageNamed:@"ic_more_tabar_inbox"] forState:UIControlStateNormal];
    [button2 setImage:[UIImage imageNamed:@"ic_more_tabar_inbox_active"] forState:UIControlStateSelected];
    
    [button3 setImage:[UIImage imageNamed:@"ic_more_tabar_home"] forState:UIControlStateNormal];
    [button3 setImage:[UIImage imageNamed:@"ic_more_tabar_home_active"] forState:UIControlStateSelected];
    
    [button4 setImage:[UIImage imageNamed:@"ic_more_tabar_pas"] forState:UIControlStateNormal];
    [button4 setImage:[UIImage imageNamed:@"ic_more_tabar_pas_active"] forState:UIControlStateSelected];
    
    [button5 setImage:[UIImage imageNamed:@"ic_more_tabar_menu"] forState:UIControlStateNormal];
    [button5 setImage:[UIImage imageNamed:@"ic_more_tabar_menu_active"] forState:UIControlStateSelected];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
}

- (void)centerTitleAndImageOnButton:(UIButton *)button withSpacing:(CGFloat)spacing {
    CGFloat insetAmount = spacing / 2.0;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -insetAmount, 0, insetAmount);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, -insetAmount);
    button.contentEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, insetAmount);
}

#pragma Mark Notifying Delegates
- (void)didSelectItemAtIndex:(NSUInteger)itemIndex;
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabView:didSelectTabAtIndex:)])
    {
        [self.delegate tabView:self didSelectTabAtIndex:itemIndex];
    }
}

-(void)homeClicked:(UIButton *)sender
{
    [self deselectOtherExcept:sender];
    NSLog(@"Home clicked");
}
-(void)pasClicked:(UIButton *)sender
{
    [self deselectOtherExcept:sender];
}
-(void)calenderClicked:(UIButton *)sender
{
    [self deselectOtherExcept:sender];
    [AppHelper showAlertWithTitle:@"Coming Soon.." message:@"" tag:0 delegate:nil cancelButton:@"Ok" otherButton:nil];

}
-(void)inboxClicked:(UIButton *)sender
{
    [self deselectOtherExcept:sender];
    [AppHelper showAlertWithTitle:@"Coming Soon.." message:@"" tag:0 delegate:nil cancelButton:@"Ok" otherButton:nil];

}
-(void)menuClicked:(UIButton *)sender
{
    [self deselectOtherExcept:sender];
    [AppHelper showAlertWithTitle:@"Coming Soon.." message:@"" tag:0 delegate:nil cancelButton:@"Ok" otherButton:nil];

}

-(void)deselectOtherExcept:(UIButton*)currentButton
{
    // Unselect all the buttons in the parent view
    for (UIView *button in currentButton.superview.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [(UIButton *)button setSelected:NO];
        }
    }
    // Set the current button as the only selected one
    
    //if(currentButton)
    //[currentButton setSelected:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
