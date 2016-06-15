//
//  AllAppointmentsVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 27/04/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "AllAppointmentsVC.h"
#import "YSLContainerViewController.h"
#import "AppHelper.h"
#import "AppDelegate.h"
#import "Defines.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "Services.h"
#import "AppointmentListingVC.h"

@interface AllAppointmentsVC ()<YSLContainerViewControllerDelegate>
{
    NSMutableArray *arrServices;
    NSMutableArray *arrTypes;
    AppointmentListingVC *appointVC1;
    AppointmentListingVC *appointVC2;
    AppointmentListingVC *appointVC3;
    AppointmentListingVC *appointVC4;
    AppointmentListingVC *appointVC5;
    AppointmentListingVC *appointVC6;
    AppointmentListingVC *appointVC7;
    AppointmentListingVC *appointVC8;


}

@end

@implementation AllAppointmentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpViewControllers];
}

-(void)setUpViewControllers
{
    // SetUp ViewControllers
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    appointVC1 = [storyboard instantiateViewControllerWithIdentifier:@"AppointmentListingVC"];
    appointVC1.title = @"ALL";
    appointVC1.appointmnetType=@"";
    appointVC1.arrEvents=self.arrEvents;
    
    
    appointVC2 = [storyboard instantiateViewControllerWithIdentifier:@"AppointmentListingVC"];
    appointVC2.title = @"APPOINTMENTS";
    appointVC2.appointmnetType=@"appointment";
    
    appointVC3 = [storyboard instantiateViewControllerWithIdentifier:@"AppointmentListingVC"];
    appointVC3.title = @"WEBINARS";
    appointVC3.appointmnetType=@"webinar";
    
    appointVC4 = [storyboard instantiateViewControllerWithIdentifier:@"AppointmentListingVC"];
    appointVC4.title = @"CONFERENCES";
    appointVC4.appointmnetType=@"conference";
    
    appointVC5 = [storyboard instantiateViewControllerWithIdentifier:@"AppointmentListingVC"];
    appointVC5.title = @"ACTIVITIES";
    appointVC5.appointmnetType=@"activity";
    
    appointVC6 = [storyboard instantiateViewControllerWithIdentifier:@"AppointmentListingVC"];
    appointVC6.title = @"PAC MEETINGS";
    appointVC6.appointmnetType=@"pac";
    
    appointVC7 = [storyboard instantiateViewControllerWithIdentifier:@"AppointmentListingVC"];
    appointVC7.title = @"EVENTS";
    appointVC7.appointmnetType=@"event";
    
    appointVC8 = [storyboard instantiateViewControllerWithIdentifier:@"AppointmentListingVC"];
    appointVC8.title = @"OTHERS";
    appointVC8.appointmnetType=@"other";

    
    // ContainerView
    //float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    //float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:@[appointVC1,appointVC2,appointVC3,appointVC4,appointVC5,appointVC6,appointVC7,appointVC8]
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
    NSLog(@"current Index : %ld",(long)index);
    NSLog(@"current controller : %@",controller);
    [controller viewWillAppear:YES];
}

- (IBAction)btnBackClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
