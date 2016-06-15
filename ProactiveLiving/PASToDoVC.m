//
//  PASToDoVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 05/04/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "PASToDoVC.h"
#import "AppHelper.h"
#import "AppointmentDetailsVC.h"
#import "ValidationCentersVC.h"
#import "CurrentPASVC.h"
#import "ImproveVC.h"
#import "Defines.h"
#import "PASInviteMainVC.h"
#import "PASShareVC.h"

@interface PASToDoVC ()
- (IBAction)btnBackClick:(id)sender;

@end

@implementation PASToDoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackClick:(id)sender {
    //back to previous view controller
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnCurrentClick:(id)sender {
    
     if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
     CurrentPASVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CurrentPASVC"];
     [self.navigationController pushViewController:vc animated:YES];
     }
}
- (IBAction)btnUpdateClick:(id)sender {
}

- (IBAction)btnImproveClick:(id)sender {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        ImproveVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ImproveVC"];
        vc.menuTitle=@"";
        vc.arrMenueImages=[NSArray arrayWithObjects:
                           @"ic_improve_experts",
                           @"ic_improve_webinars",
                           @"ic_improve_webcasts",
                           @"ic_improve_event",
                           @"ic_improve_PAccircle",
                           @"ic_improve_PASduel",
                           @"ic_improve_education",
                           @"ic_improve_prevention",
                           @"ic_improve_volunteer",
                           @"ic_improve_eatingguide",
                           @"ic_improve_dietplans",
                           @"ic_improve_healthymeals",
                           @"ic_improve_wellnessapps",
                           @"ic_improve_device",
                           @"ic_improve_workout",
                           @"ic_improve_inspotstionalvideos",
                           @"ic_improve_inspirationalmessage",
                           @"ic_improve_gratitudejournal",
                           @"ic_improve_city",
                           @"ic_improve_communityprograme",
                           @"ic_improve_specialized",
                           @"ic_improve_kids",
                           @"ic_improve_youthprograms",
                           @"ic_improve_seniorprograms",nil];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)btnPASInviteClick:(id)sender {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        PASInviteMainVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PASInviteMainVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)btnPASGiftClick:(id)sender {
}

- (IBAction)btnPASShareClick:(id)sender {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        PASShareVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PASShareVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)btnBiomatricsClick:(id)sender {
}

- (IBAction)btnHistoryClick:(id)sender {
}

- (IBAction)btnAnalyticsClick:(id)sender {
}

- (IBAction)btnAppointmentClick:(id)sender {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        AppointmentDetailsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AppointmentDetailsVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)btnValidationCntrClick:(id)sender {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        ValidationCentersVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ValidationCentersVC"];
        vc.orgType=@"Validation Centers";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)btnQRCodeClick:(id)sender {
}

- (IBAction)btnVideoClick:(id)sender {
}

- (IBAction)btnFAQClick:(id)sender {
}

- (IBAction)btnMoreClick:(id)sender {
}
@end
