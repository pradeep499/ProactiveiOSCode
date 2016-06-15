//
//  AppointmentVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 29/03/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "AppointmentVC.h"
#import <UIImageView+AFNetworking.h>
#import "Defines.h"
#import "AppHelper.h"
#import "AppDelegate.h"
#import "PASInstVideoVC.h"
#import "AboutPASInstVC.h"

@interface AppointmentVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblIdentity;
@property (weak, nonatomic) IBOutlet UILabel *lblDateTime;
@property (weak, nonatomic) IBOutlet UILabel *lblOrganization;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UIImageView *imgQRCode;
- (IBAction)btnPASInstClick:(id)sender;

@end

@implementation AppointmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.imgQRCode setImageWithURL:[NSURL URLWithString:[QRImageBaseUrl stringByAppendingString:[NSString stringWithFormat:@"%@",[self.dictBookingDetails valueForKey:@"_id"]]]] placeholderImage:nil];
    
    self.lblName.text=[self.dictUserDetails valueForKey:@"firstName"];
    self.lblIdentity.text=[self.dictUserDetails valueForKey:@"identity"];
    self.lblDateTime.text=[NSString stringWithFormat:@"%@ %@",[self.dictBookingDetails valueForKey:@"bookingDate"],[AppHelper timeFormattedFromSeconds:[[self.dictBookingDetails valueForKey:@"bookingTime"]intValue]]];
    self.lblOrganization.text=[self.dictOrganizationDetails valueForKey:@"name"];
    self.lblAddress.text=[self.dictOrganizationDetails valueForKey:@"address1"];

}

-(void)viewWillAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackClick:(id)sender {
    //back to previous view controller
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnInfoClick:(id)sender {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        AboutPASInstVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutPASInstVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }

}


- (IBAction)btnPASInstClick:(id)sender {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        PASInstVideoVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PASInstVideoVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }

}
@end
