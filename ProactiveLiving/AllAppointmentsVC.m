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
#import "ProactiveLiving-Swift.h"
@interface AllAppointmentsVC ()<YSLContainerViewControllerDelegate>
{
    NSMutableArray *arrServices;
    NSMutableArray *arrTypes;
    AppointmentListingVC *appointVC1;
    AppointmentListingVC *appointVC2;
    AppointmentListingVC *appointVC3;
    AppointmentListingVC *appointVC4;
    AppointmentListingVC *appointVC8;


}
@property (weak, nonatomic) IBOutlet UIButton *btnCalendar;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@end

@implementation AllAppointmentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if([self.fromScreenFlag isEqualToString:@"pac"] || [self.fromScreenFlag isEqualToString:@"private"])
        self.btnBack.hidden = NO;
    else
        self.btnBack.hidden = YES;
    
    [self setUpViewControllers];
}

-(void)setUpViewControllers
{
    // SetUp ViewControllers
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    appointVC1 = [storyboard instantiateViewControllerWithIdentifier:@"AppointmentListingVC"];
    appointVC1.title = @"ALL";
    appointVC1.appointmnetType=@"";
    appointVC1.updateData = self.recordNotFound;
    appointVC1.arrEvents=self.arrEvents;
    appointVC1.selectedRecurrenceDate = self.selectedRecurrenceDate;
    appointVC1.fromScreenFlag = self.fromScreenFlag;
    appointVC1.pacID = self.pacID;
    
    appointVC2 = [storyboard instantiateViewControllerWithIdentifier:@"AppointmentListingVC"];
    appointVC2.title = @"APPOINTMENTS";
    appointVC2.appointmnetType=@"appointment";
    appointVC2.updateData = self.recordNotFound;

    appointVC2.fromScreenFlag = self.fromScreenFlag;
    appointVC2.pacID = self.pacID;


    appointVC3 = [storyboard instantiateViewControllerWithIdentifier:@"AppointmentListingVC"];
    appointVC3.title = @"MEET UPS";
    appointVC3.appointmnetType=@"meetup";
    appointVC3.updateData = self.recordNotFound;
    appointVC3.pacID = self.pacID;

    appointVC3.fromScreenFlag = self.fromScreenFlag;

    appointVC4 = [storyboard instantiateViewControllerWithIdentifier:@"AppointmentListingVC"];
    appointVC4.title = @"WEB INVITES";
    appointVC4.appointmnetType=@"webinvite";
    appointVC4.updateData = self.recordNotFound;
    appointVC4.pacID = self.pacID;

    appointVC4.fromScreenFlag = self.fromScreenFlag;

    appointVC8 = [storyboard instantiateViewControllerWithIdentifier:@"AppointmentListingVC"];
    appointVC8.title = @"OTHERS";
    appointVC8.appointmnetType=@"other";
    appointVC8 .updateData = self.recordNotFound;
    appointVC8.pacID = self.pacID;

    appointVC8.fromScreenFlag = self.fromScreenFlag;

    
    // ContainerView
    //float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    //float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    NSArray *arrVCs;
    if([self.fromScreenFlag isEqualToString:@"pac"])
        arrVCs = @[appointVC1,appointVC3,appointVC4];
    else
        arrVCs = @[appointVC1,appointVC2,appointVC3,appointVC4,appointVC8];
    
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:arrVCs
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
    
    // To take button on front most
    [self.view addSubview:self.btnCalendar];
    [self.view bringSubviewToFront:self.btnCalendar];

}


#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    NSLog(@"current Index : %ld",(long)index);
    NSLog(@"current controller : %@",controller);
  //  [controller viewWillAppear:YES];
}

- (IBAction)btnBackClick:(id)sender {
    
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    if([self.fromScreenFlag isEqualToString:@"pac"]) {
        
        UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 3];
        [self.navigationController popToViewController:vc animated:YES];
    }
    else {
        UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
        [self.navigationController popToViewController:vc animated:YES];
    }

}
- (IBAction)btnFlipClick:(id)sender {
            [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)btnCreateEventClick:(id)sender {
    
    UIAlertController * alertActionSheet=   [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * appointment = [UIAlertAction
                         actionWithTitle:@"Appointment"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             [alertActionSheet dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction * meetup = [UIAlertAction
                                   actionWithTitle:@"Meet Up"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       //Do some thing here
                                       if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                                           UIStoryboard *chatStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                           CreateMeetUpVC *vc = [chatStoryBoard instantiateViewControllerWithIdentifier:@"CreateMeetUpVC"];
                                           vc.pushedFrom=@"MEETUPS";
                                           if([self.fromScreenFlag isEqualToString:@"pac"]) {
                                               vc.fromScreenFlag = @"PAC";
                                               vc.arrPACMembers = self.arrPACMembers;
                                           }
                                           
                                           [self.navigationController pushViewController:vc animated:YES];
                                       }
                                       [alertActionSheet dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
    UIAlertAction * webinvite = [UIAlertAction
                                   actionWithTitle:@"Web Invite"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       //Do some thing here
                                       if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                                           UIStoryboard *chatStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                           CreateMeetUpVC *vc = [chatStoryBoard instantiateViewControllerWithIdentifier:@"CreateMeetUpVC"];
                                           vc.pushedFrom=@"WEBINVITES";
                                           if([self.fromScreenFlag isEqualToString:@"pac"]) {
                                               vc.fromScreenFlag = @"PAC";
                                               vc.arrPACMembers = self.arrPACMembers;
                                           }
                                           [self.navigationController pushViewController:vc animated:YES];
                                       }

                                       [alertActionSheet dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
    UIAlertAction * other = [UIAlertAction
                                   actionWithTitle:@"Other"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       //Do some thing here
                                       
                                       [alertActionSheet dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
    UIAlertAction * cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 [alertActionSheet dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    
    if([self.fromScreenFlag isEqualToString:@"pac"])
    {
        
        if(self.allowToCreateWebinvite == TRUE || self.allowToCreateMeetup == TRUE) {
            
            if(self.allowToCreateMeetup == TRUE)
                [alertActionSheet addAction:meetup];
            if(self.allowToCreateWebinvite == TRUE)
                [alertActionSheet addAction:webinvite];

            [alertActionSheet addAction:cancel];
            [self presentViewController:alertActionSheet animated:YES completion:nil];
        }
    }
    else
    {
        [alertActionSheet addAction:appointment];
        [alertActionSheet addAction:meetup];
        [alertActionSheet addAction:webinvite];
        [alertActionSheet addAction:other];
        [alertActionSheet addAction:cancel];
        [self presentViewController:alertActionSheet animated:YES completion:nil];
    }

   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
