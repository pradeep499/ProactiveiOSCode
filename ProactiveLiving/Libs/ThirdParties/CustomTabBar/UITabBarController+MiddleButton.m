//
//  TableViewController+MiddleButton.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 26/05/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "UITabBarController+MiddleButton.h"
#import "AppHelper.h"

@implementation UITabBarController (MiddleButton)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self addCenterButtonWithImage:[UIImage imageNamed:@"ic_more_tabar_home_outline"] highlightImage:[UIImage imageNamed:@"ic_more_tabar_home_outline"]];
    self.tabBar.backgroundColor = [UIColor clearColor];
    [AppHelper setBorderOnView:self.view];
    //[self setTabBarBackground];
}


// reset the background image in custom tabbar.
- (void) setTabBarBackground {
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default"]];
    img.frame = CGRectOffset(img.frame, 0, 1);
    img.frame = CGRectMake(img.frame.origin.x, img.frame.origin.y-1, img.frame.size.width, img.frame.size.height);
    [self.tabBar insertSubview:img atIndex:0];
    
}

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    //[button setBackgroundImage:highlightImage forState:UIControlStateSelected];
    button.adjustsImageWhenHighlighted = NO;
    [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    
    [self.view addSubview:button];
    [self.view bringSubviewToFront:button];
}
-(void)clicked:(UIButton*)sender
{
    [sender setSelected: ![sender isSelected]];
    [self setSelectedIndex:2];
}

// pass a param to describe the state change, an animated flag and a completion block matching UIView animations completion
-(void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    
    // bail if the current state matches the desired state
    if ([self tabBarIsVisible] == visible) return (completion)? completion(YES) : nil;
    
    // get a frame calculation ready
    CGFloat height = self.tabBar.frame.size.height;
    CGFloat offsetY = (visible)? -height : height;
    
    // zero duration means no animation
    CGFloat duration = (animated)? 0.3 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        self.tabBar.frame = CGRectOffset(self.tabBar.frame, 0, offsetY);
    } completion:completion];
}

// know the current state
-(BOOL)tabBarIsVisible {
    return self.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame);
}

// illustration of a call to toggle current state
- (void)hideTabBar:(BOOL)visible withAnimation:(BOOL)animate {
    [self setTabBarVisible:!visible animated:animate completion:^(BOOL finished) {
        //NSLog(@"finished");
    }];
}

@end
