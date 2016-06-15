//
//  PASSharePopUp.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 15/06/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "PASSharePopUp.h"
#import "Defines.h"

@implementation PASSharePopUp

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (IBAction)btnCancelClick:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (IBAction)btnBookingClick:(id)sender {
    /*
     [UIView animateWithDuration:0.3 animations:^{
     self.view.frame = CGRectMake(0, 568, 320, 284);
     } completion:^(BOOL finished) {
     [self.view removeFromSuperview];
     [self removeFromParentViewController];
     }];
     */
    
}

@end
