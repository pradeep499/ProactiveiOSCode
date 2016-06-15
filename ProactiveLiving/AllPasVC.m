//
//  AllPasVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 06/06/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "AllPasVC.h"
#import "YSLContainerViewController.h"
#import "PASInviteOrGiftVC.h"
@interface AllPasVC ()<YSLContainerViewControllerDelegate>
{
    NSMutableArray *arrServices;
    NSMutableArray *arrTypes;
    PASInviteOrGiftVC *invitePASVC;
    PASInviteOrGiftVC *giftPASVC;
}
@end

@implementation AllPasVC

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
    
    invitePASVC = [storyboard instantiateViewControllerWithIdentifier:@"PASInviteOrGiftVC"];
    invitePASVC.title = @"INVITE";
    invitePASVC.vcType=@"Invite";
    
    giftPASVC = [storyboard instantiateViewControllerWithIdentifier:@"PASInviteOrGiftVC"];
    giftPASVC.title = @"GIFT";
    giftPASVC.vcType=@"Gift";
    
    // ContainerView
    //float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    //float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]
                                               initWithControllers:@[invitePASVC,giftPASVC]
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

- (IBAction)btnBackClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)btnInfoClick:(id)sender {
}
- (IBAction)btnHistoryClick:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
