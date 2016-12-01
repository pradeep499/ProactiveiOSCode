//
//  AppointmentDetailsVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 06/04/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "AppointmentDetailsVC.h"
#import "ASStarRatingView.h"
#import "AppHelper.h"
#import "AppDelegate.h"
#import "Defines.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "LocationManagerSingleton.h"
#import "ProactiveLiving-Bridging-Header.h"

@interface AppointmentDetailsVC ()

@property (strong, nonatomic) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *lblDateTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblServices;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UITextView *txtTimings;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@property (weak, nonatomic) IBOutlet ASStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
- (IBAction)btnCallClick:(id)sender;
- (IBAction)btnEditAppointmentClick:(id)sender;
- (IBAction)btnViewInCalenderClick:(id)sender;
- (IBAction)btnPASInstClick:(id)sender;
- (IBAction)btnBackClick:(id)sender;

@end

@implementation AppointmentDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [AppHelper setBorderOnView:self.containerView];
    
    //Update appointment details from back controller or API
    if(self.dataDict !=nil)
    {
        self.screenTitle.text=[NSString stringWithFormat:@"%@",[self.dataDict valueForKey:@"name"]];
        [self updateUserInterface];
    }
    else
        [self getAppointmentData];
    
    NSLog(@"location::::::>  %@",[LocationManagerSingleton sharedSingleton].locationManager.location);
    
}

-(void)updateUserInterface
{
    NSString* date = [HelpingClass convertDateFormat:@"yyyy/MM/dd" desireFormat:@"MM/dd/yyyyy" dateStr:[self.dataDict valueForKey:@"bookingDate"]];
    
    self.lblDateTime.text=[NSString stringWithFormat:@"Your Appointment is confirmed for %@ at %@ ETS",date,[self timeFormatted:[[self.dataDict valueForKey:@"bookingTime"] intValue]]];
    
    self.lblName.text=[[self.dataDict valueForKey:@"organizationId"] valueForKey:@"name"];
    self.lblServices.text=[[self.dataDict valueForKey:@"Validation_Center"] valueForKey:@"name"];
    self.lblAddress.text=[[self.dataDict valueForKey:@"organizationId"] valueForKey:@"address1"];
    self.lblDistance.text=[NSString stringWithFormat:@"%.02f miles",(([[self.dataDict valueForKey:@"dist"] floatValue])/1609.344)];

    [self.btnCall setTitle:[[self.dataDict valueForKey:@"organizationId"] valueForKey:@"phone"] forState:UIControlStateNormal];
    self.ratingView.canEdit=NO;
    self.ratingView.rating=[[[self.dataDict valueForKey:@"organizationId"] valueForKey:@"rating"] intValue];
    
    //Timings
    NSMutableArray *timingsArr=[self flatDateAndTimeAsPerNeedWithArray:[[self.dataDict valueForKey:@"organizationId"] objectForKey:@"availability"]];
    NSArray *groups = [timingsArr valueForKeyPath:@"@distinctUnionOfObjects.timings"];
    NSMutableArray *resultArray = [NSMutableArray new];
    
    for (NSString *groupTime in groups)
    {
        NSMutableString *entry = [NSMutableString new];
        NSString *name=@"";
        NSArray *groupNames = [timingsArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"timings = %@", groupTime]];
        if(groupNames.count>0)
        {
            if(groupNames.count==1)
            {
                name = [NSString stringWithFormat:@"%@",[[groupNames firstObject] valueForKey:@"day"]];
            }
            else
                name = [NSString stringWithFormat:@"%@ - %@ ",[[groupNames firstObject] valueForKey:@"day"],[[groupNames lastObject] valueForKey:@"day"]];
        }
        
        [entry appendString:name];
        [entry appendString:[NSString stringWithFormat:@" %@",groupTime]];
        
        [resultArray addObject:entry];
    }
    self.txtTimings.text=[resultArray componentsJoinedByString:@"\n"];
}

-(void)getAppointmentData
{
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection]) {
        
        //show indicator on screen
        [SVProgressHUD showWithStatus:@"Please wait" maskType:SVProgressHUDMaskTypeBlack];
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
        [parameters setValue:AppKey forKey:@"AppKey"];
        [parameters setValue:[AppHelper userDefaultsForKey:uId] forKey:@"UserID"];
        
        //call global web service class
        [Services serviceCallWithPath:ServiceGetAppointment withParam:parameters success:^(NSDictionary *responseDict)
         {
             [SVProgressHUD dismiss];//dissmiss indicator
             
             if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
             {
                 if ([[responseDict objectForKey:@"error"] intValue] == 0) {
                     
                     self.dataDict=[responseDict objectForKey:@"result"];
                     
                     [self updateUserInterface];
                 }
                 else
                 {
                     [AppHelper showAlertWithTitle:[responseDict objectForKey:@"errorMsg"] message:@"" tag:111 delegate:self cancelButton:ok otherButton:nil];
                 }
                 
             }
             else
                 [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
             
         } failure:^(NSError *error)
         {
             //[SVProgressHUD dismiss];
             [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
         }];
        
    }
    else
        //show internet not available
        [AppHelper showAlertWithTitle:netError message:netErrorMessage tag:0 delegate:nil cancelButton:ok otherButton:nil];
}

#pragma mark- Date n Time conversion from sec to hr:mm:ss
-(NSMutableArray *)flatDateAndTimeAsPerNeedWithArray:(NSArray *)dataArr
{
    NSMutableArray *resultArray = [NSMutableArray new];
    
    for (int i=0; i<[dataArr count]; i++) {
        
        NSMutableDictionary *timingsDict = [NSMutableDictionary new];
        
        NSMutableDictionary *dataDict=[dataArr objectAtIndex:i];
        //NSCalendar* calender = [NSCalendar currentCalendar];
        //NSDateComponents* component = [calender components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
        int weekDay = [[dataDict valueForKey:@"dayNum"]intValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSString *weekdayString = [[formatter weekdaySymbols] objectAtIndex:weekDay - 1];
        NSLog(@"Day: %@", weekdayString);
        
        NSArray *arrTimings=[dataDict valueForKey:@"timings"];
        NSMutableArray *timingStrArr=[[NSMutableArray alloc]init];
        for (int i=0; i<arrTimings.count; i++) {
            [timingStrArr addObject:[NSString stringWithFormat:@"%@ to %@",[self timeFormatted:[[[arrTimings objectAtIndex:i] valueForKey:@"starttime"] intValue]],[self timeFormatted:[[[arrTimings objectAtIndex:i] valueForKey:@"endtime"] intValue]]]];
        }
        NSLog(@"Timings: %@",[timingStrArr componentsJoinedByString:@", "]);
        
        //    for (int i=0; i<timingStrArr.count; i++) {
        //        if ([[timingStrArr objectAtIndex:i] isEqualToString:[timingStrArr objectAtIndex:i+1]]) {
        //
        //        }
        //        else
        //        {
        //            NSLog(@"Timings: %@",[timingStrArr componentsJoinedByString:@", "]);
        //
        //        }
        //    }
        
        [timingsDict setObject:[weekdayString substringToIndex:3] forKey:@"day"];
        [timingsDict setObject:[timingStrArr componentsJoinedByString:@", "] forKey:@"timings"];
        [resultArray addObject:timingsDict];
    }
    
    return resultArray;
    
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm:ss"];
    NSDate *date1 = [dateFormat dateFromString:[NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    return [formatter stringFromDate:date1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCallClick:(id)sender {
    
    NSString *phone = [sender titleForState:UIControlStateNormal];
    // Remove all chars except of digits
    static NSString *const kDigitsString = @"0123456789";
    phone = [[phone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:kDigitsString] invertedSet]] componentsJoinedByString:@""];
    // Initiate call
    //Type cast it to CustomCell
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (IBAction)btnEditAppointmentClick:(id)sender {
}

- (IBAction)btnViewInCalenderClick:(id)sender {
}

- (IBAction)btnPASInstClick:(id)sender {
}

- (IBAction)btnBackClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==111)
    {
        if(buttonIndex==0)
        [self.navigationController popViewControllerAnimated:YES];

    }
}
@end
