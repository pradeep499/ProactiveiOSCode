//
//  AllPACirclesVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 12/05/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "AllPACirclesVC.h"
#import "YSLContainerViewController.h"
#import "AppHelper.h"
#import "AppDelegate.h"
#import "Defines.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "Services.h"
#import "PACircleVC.h"
#import "ProactiveLiving-Swift.h"
//#import "MyPACVC.swift"

@class MyPACVC;
@interface AllPACirclesVC ()<YSLContainerViewControllerDelegate>
{
    NSMutableArray *arrServices;
    NSMutableArray *arrTypes;
    PACircleVC *PACircleVC1;
    MyPACVC *myPACVC;
  //  PACircleVC *PACircleVC2;
 //    PACircleVC *PACircleVC3;
 //    PACircleVC *PACircleVC4;
    AboutPASInstVC * aboutPASInstVC;

}
@end


@implementation AllPACirclesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpViewControllers];
}

-(void)setUpViewControllers
{
    // SetUp ViewControllers
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PACircleVC1 = [storyboard instantiateViewControllerWithIdentifier:@"PACircleVC"];
    PACircleVC1.title = @"FIND";
    PACircleVC1.menuTitle=@"";
    PACircleVC1.arrMenueImages=[NSArray arrayWithObjects:
                                @"ic_improve_activities",
                                @"ic_expert_personaltrainers",
                                @"ic_expert_more", nil];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"PAC" bundle:nil];
    
    myPACVC = [story instantiateViewControllerWithIdentifier:@"MyPACVC"];
    myPACVC.title = @"MY PAC";
    
    
    
//    PACircleVC2.arrMenueImages=[NSArray arrayWithObjects:
//                       @"ic_expert_physicians",
//                       @"ic_expert_personaltrainers",
//                       @"ic_expert_dieticians",
//                       @"ic_expert_healthwellness",
//                       @"ic_expert_healtheducation",
//                       @"ic_expert_nutritionists",
//                       @"ic_expert_professionalorganisations",
//                       @"ic_expert_psycologists",
//                       @"ic_expert_corpwellness",
//                       @"ic_expert_more", nil];
    
//    PACircleVC3 = [storyboard instantiateViewControllerWithIdentifier:@"PACircleVC"];
//    PACircleVC3.title = @"CREATE A PAC";
//    PACircleVC3.menuTitle=@"";
//    PACircleVC3.arrMenueImages=[NSArray arrayWithObjects:
//                       @"ic_expert_physicians",
//                       @"ic_expert_personaltrainers",
//                       @"ic_expert_dieticians",
//                       @"ic_expert_healthwellness",
//                       @"ic_expert_healtheducation",
//                       @"ic_expert_nutritionists",
//                       @"ic_expert_professionalorganisations",
//                       @"ic_expert_psycologists",
//                       @"ic_expert_corpwellness",
//                       @"ic_expert_more", nil];
    
//    PACircleVC4 = [storyboard instantiateViewControllerWithIdentifier:@"PACircleVC"];
//    PACircleVC4.title = @"INVITE";
//    PACircleVC4.menuTitle=@"";
//    PACircleVC4.arrMenueImages=[NSArray arrayWithObjects:
//                       @"ic_expert_physicians",
//                       @"ic_expert_personaltrainers",
//                       @"ic_expert_dieticians",
//                       @"ic_expert_healthwellness",
//                       @"ic_expert_healtheducation",
//                       @"ic_expert_nutritionists",
//                       @"ic_expert_professionalorganisations",
//                       @"ic_expert_psycologists",
//                       @"ic_expert_corpwellness",
//                       @"ic_expert_more", nil];
    
    // ContainerView
    //float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    //float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
//    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:
//                                            @[PACircleVC1,PACircleVC2,PACircleVC3,PACircleVC4]
//                                            topBarHeight:0
//                                            parentViewController:self];
    // modified by aseem 06/03/2016
  
    
    NSArray * arrForVC = @[PACircleVC1,myPACVC];
    
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers: arrForVC topBarHeight:0 parentViewController:self];
    
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
    NSLog(@"current Index : %ld",(long)index);
    NSLog(@"current controller : %@",controller);
    [controller viewWillAppear:YES];
}

#pragma mark:- Button Action
- (IBAction)btnBackClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)btnInfoAction:(id)sender {
    
     NSLog(@"ALLPACircleVC Info Button");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    aboutPASInstVC = [storyboard instantiateViewControllerWithIdentifier:@"AboutPASInstVC"];
    aboutPASInstVC.strType = @"pac";
    aboutPASInstVC.strTitle = @"PAC";
    
    [self.navigationController pushViewController:aboutPASInstVC animated:YES];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
