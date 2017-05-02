//
//  CustonTabBarController.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 06/04/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "CustonTabBarController.h"
#import "AppHelper.h"

@interface CustonTabBarController ()

@end

@implementation CustonTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addCenterButtonWithImage:[UIImage imageNamed:@"ic_more_tabar_home_outline"] highlightImage:[UIImage imageNamed:@"ic_more_tabar_home_outline"]];
    self.tabBar.backgroundColor = [UIColor clearColor];
    [AppHelper setBorderOnView:self.view];
    //[self setTabBarBackground];
}

- (void)setCenterImage {
    
    [self addCenterButtonWithImage:[UIImage imageNamed:@"ic_more_tabar_home_outline"] highlightImage:[UIImage imageNamed:@"ic_more_tabar_home_outline"]];
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
    if(!self.middleButton)
    {
    self.middleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.middleButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    self.middleButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [self.middleButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    //[button setBackgroundImage:highlightImage forState:UIControlStateSelected];
    self.middleButton.adjustsImageWhenHighlighted = NO;
    [self.middleButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
        
        UIView *itemView = [self.tabBar.items.firstObject valueForKey:@"view"];
        CGPoint X0Center = itemView.center;
        
        
        if (heightDifference < 0){
            self.middleButton.center = self.tabBar.center;
          /*  //for 0 position
            CGPoint X0 = self.middleButton.center;
            X0.x = self.middleButton.frame.size.width/2 + 5;
            self.middleButton.center = X0; */
        }
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
     /*   //for 0 position
        center.x = self.middleButton.frame.size.width/2 + 5;
        */
        self.middleButton.center = center;
    }
    
    [self.view addSubview:self.middleButton];
    }
    [self.view bringSubviewToFront:self.middleButton];
}
-(void)clicked:(UIButton*)sender
{
    [sender setSelected: ![sender isSelected]];
    [self setSelectedIndex:2];
}

// pass a param to describe the state change, an animated flag and a completion block matching UIView animations completion
-(void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    
    NSLog(@"tab bar y - %f", self.tabBar.frame.origin.y);
    if ([self tabBarIsVisible]) {
        NSLog(@"visible");
    } else {
        NSLog(@"not visible");
    }
    // bail if the current state matches the desired state
    if ([self tabBarIsVisible] == visible) return (completion)? completion(YES) : nil;
    
    // get a frame calculation ready
    CGFloat height = self.tabBar.frame.size.height+15;
    CGFloat offsetY = (visible)? -height : height;
    
    // zero duration means no animation
    CGFloat duration = (animated)? 0.3 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        self.tabBar.frame = CGRectOffset(self.tabBar.frame, 0, offsetY);
        self.middleButton.frame = CGRectOffset(self.middleButton.frame, 0, offsetY);
    } completion:completion];
}

// know the current state
-(BOOL)tabBarIsVisible {
    return self.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame);
}

// illustration of a call to toggle current state
- (void)hideTabBar:(BOOL)visible withAnimation:(BOOL)animate {
    [self setTabBarVisible:!visible animated:animate completion:^(BOOL finished) {
        NSLog(@"finished");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
