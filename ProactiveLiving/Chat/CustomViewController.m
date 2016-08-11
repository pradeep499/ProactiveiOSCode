//
//  CustomViewController.m
//  MelderEventApp
//
//  Created by Sunil Kaushik on 9/15/15.
//  Copyright (c) 2015 Jyoti Sharma. All rights reserved.
//

#import "CustomViewController.h"


@interface CustomViewController ()
{
    BOOL isLoginFirstTap;
}
@end

@implementation CustomViewController
@synthesize objChatVC;

- (void)viewDidLoad {
    
    isLoginFirstTap=YES;
    UIViewController *vis = self.visibleViewController;
    vis.navigationController.navigationBarHidden=YES;
    //[self.visibleViewController addChildViewController:chatViewController];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    ChatHomeVC *chatViewController = [storyboard instantiateViewControllerWithIdentifier:@"ChatHomeVC"];
    self.objChatVC=chatViewController;
    [self setViewControllers:[NSArray arrayWithObjects:chatViewController, nil]];
   
    
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated
{
    // below code is done by prabodh for resolving view will appear call issues 30 nov
    [super viewWillAppear:animated];
    
    if (isLoginFirstTap==NO) {
        
        [self.objChatVC viewWillAppear:YES];

    }
    else
    {
        isLoginFirstTap=NO;
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
