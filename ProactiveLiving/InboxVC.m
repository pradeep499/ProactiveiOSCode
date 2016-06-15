//
//  InboxVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 17/05/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "InboxVC.h"
#import "AppHelper.h"
#import "Defines.h"
#import "AllContactsVC.h"
#import "YSLContainerViewController.h"
#import "MessagesVC.h"

@interface InboxVC () <YSLContainerViewControllerDelegate>
{
    NSMutableArray *arrServices;
    NSMutableArray *arrTypes;
    MessagesVC *mesagesVC1;
    MessagesVC *mesagesVC2;
    MessagesVC *mesagesVC3;
    MessagesVC *mesagesVC4;

}

- (IBAction)btnContactsClick:(id)sender;
- (IBAction)btnCreateNewClick:(id)sender;

@end

@implementation InboxVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpViewControllers];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - preferredStatusBarStyle
-(UIStatusBarStyle)preferredStatusBarStyle {
    // to set the light color of status bar
    return UIStatusBarStyleLightContent;
}

-(void)setUpViewControllers
{
    // SetUp ViewControllers
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    mesagesVC1 = [storyboard instantiateViewControllerWithIdentifier:@"MessagesVC"];
    mesagesVC1.title = @"MESSAGES";
    
    mesagesVC2 = [storyboard instantiateViewControllerWithIdentifier:@"MessagesVC"];
    mesagesVC2.title = @"MEETUPS";
    
    mesagesVC3 = [storyboard instantiateViewControllerWithIdentifier:@"MessagesVC"];
    mesagesVC3.title = @"INVITATION";
    
    mesagesVC4 = [storyboard instantiateViewControllerWithIdentifier:@"MessagesVC"];
    mesagesVC4.title = @"REQUESTS";
    
    
    // ContainerView
    //float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    //float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]
                                               initWithControllers:@[mesagesVC1]
                                               topBarHeight:0
                                               parentViewController:self];
    
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:@"Roboto-Regular" size:11];
    containerVC.menuItemSelectedFont = [UIFont fontWithName:@"Roboto-Bold" size:11.5];
    containerVC.menuBackGroudColor=[UIColor colorWithRed:1.0/255 green:174.0/255 blue:240.0/255 alpha:1.0];
    containerVC.menuItemTitleColor=[UIColor whiteColor];
    containerVC.menuItemSelectedTitleColor=[UIColor whiteColor];
    containerVC.view.frame=CGRectMake(0, 64, containerVC.view.frame.size.width, containerVC.view.frame.size.height-64);
    
    [self.view addSubview:containerVC.view];
}

#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    [self.view endEditing:YES];
    NSLog(@"current Index : %ld",(long)index);
    NSLog(@"current controller : %@",controller);
    [controller viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnContactsClick:(id)sender {
    
    
}

- (IBAction)btnCreateNewClick:(id)sender {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        AllContactsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AllContactsVC"];
        //vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
