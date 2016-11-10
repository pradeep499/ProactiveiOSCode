//
//  AppointmentListingVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 06/04/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "AppointmentListingVC.h"
#import "AppointmentListTableCell.h"
#import "AppointmentDetailsVC.h"
#import "AppHelper.h"
#import "AppDelegate.h"
#import "Defines.h"
#import "CKCalendarEvent.h"
#import "ProactiveLiving-Swift.h"
@interface AppointmentListingVC ()

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AppointmentListingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getAppointmentListingData];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

-(void)getAppointmentListingData
{
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection]) {
        
        //show indicator on screen
        [AppDelegate showProgressHUDWithStatus:@"Please wait.."];
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
        [parameters setValue:AppKey forKey:@"AppKey"];
        [parameters setValue:[AppHelper userDefaultsForKey:uId] forKey:@"UserID"];
        [parameters setObject:self.appointmnetType forKey:@"type"];
        
        //call global web service class
        [Services serviceCallWithPath:ServiceGetAppointmentList withParam:parameters success:^(NSDictionary *responseDict)
         {
             [AppDelegate dismissProgressHUD];//dissmiss indicator
             
             if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
             {
                 if ([[responseDict objectForKey:@"error"] intValue] == 0) {
                     
                     self.dataArray=[[responseDict objectForKey:@"result"] mutableCopy];
                     
                     if([self.arrEvents count]>0)
                         [self filterArrayUsingEvents:self.arrEvents];
                     
                     [self.tableView reloadData];
                 }
                 else
                 {
                     //[AppHelper showAlertWithTitle:[responseDict objectForKey:@"errorMsg"] message:@"" tag:0 delegate:nil cancelButton:ok otherButton:nil];
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

#pragma mark - uitableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //number of rows in tableview
    return [self.dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"AppointmentListCell";
    AppointmentListTableCell*cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.lblTitle.text=[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.lblDD.text=[[[self componentsFromDate:[self.dataArray objectAtIndex:indexPath.row][@"bookingDate"]] componentsSeparatedByString:@" "]objectAtIndex:1];
    cell.lblEEE.text=[[[self componentsFromDate:[self.dataArray objectAtIndex:indexPath.row][@"bookingDate"]] componentsSeparatedByString:@" "]objectAtIndex:0];
    cell.sideBarView.backgroundColor=[AppHelper colorFromHexString:[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"bookingColor"] alpha:1.0];
    cell.lblDateTime.text=[NSString stringWithFormat:@"%@ at %@",[self.dataArray objectAtIndex:indexPath.row][@"bookingDate"],[self timeFormatted:[[self.dataArray objectAtIndex:indexPath.row][@"bookingTime"] intValue]]];
    //cell.lblName.text=[NSString stringWithFormat:@"Event Type: %@",[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"type"]];
    if ([[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"appointment"]) {
        cell.lblDesc.text=[[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"organizationId"] valueForKey:@"address1"];
    }
    else
    {
        cell.lblDesc.text=@"";
    }
    
    [AppHelper setBorderOnView:cell.imgCellBG];
    
    cell.btnEdit.tag=indexPath.row;
    [cell.btnEdit addTarget:self action:@selector(btnEditBookingClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

// filter on array to move events to top
-(void)filterArrayUsingEvents:(NSArray *)arrEvents
{
    for(CKCalendarEvent *event in arrEvents) {
        NSString *eventID=[event.info valueForKey:@"_id"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@)", @"_id",eventID];
        NSMutableArray *filteredarray = [[self.dataArray filteredArrayUsingPredicate:predicate] mutableCopy];
        NSLog(@"array %@",eventID);
        
        NSInteger index = [self.dataArray indexOfObject:filteredarray[0]];
        id obj = self.dataArray[index];
        [self.dataArray removeObjectAtIndex:index];
        [self.dataArray insertObject:obj atIndex:0];
    }
}

//moving an object to another location
- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to
{
    if (to != from) {
        id obj = [self.dataArray objectAtIndex:from];
        [self.dataArray removeObjectAtIndex:from];
        if (to >= [self.dataArray count]) {
            [self.dataArray addObject:obj];
        } else {
            [self.dataArray insertObject:obj atIndex:to];
        }
    }
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

-(NSString *)componentsFromDate:(NSString *)date{
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"yyyy-MM-dd"];//@"EE, d LLLL yyyy HH:mm:ss Z"
    [dayFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSDate *myDate=[dayFormatter dateFromString:date];
    [dayFormatter setDateFormat:@"yyyy MMM EEEE"];
    //NSString*strDate1=[dayFormatter stringFromDate:myDate];
    [dayFormatter setDateFormat:@"EE d LLLL yyyy"];
    NSString *strDate2=[dayFormatter stringFromDate:myDate];

    return strDate2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        if([[self.dataArray objectAtIndex:indexPath.row][@"type"] isEqualToString:@"meetup"])
        {
            MeetUpDetailsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MeetUpDetailsVC"];
            vc.screenName = @"MEET UPS";
            vc.meetUpID=[self.dataArray objectAtIndex:indexPath.row][@"meetupInviteId"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if([[self.dataArray objectAtIndex:indexPath.row][@"type"] isEqualToString:@"webinvite"])
        {
            
            MeetUpDetailsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MeetUpDetailsVC"];
            vc.screenName = @"WEB INVITES";
            vc.meetUpID=[self.dataArray objectAtIndex:indexPath.row][@"meetupInviteId"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            AppointmentDetailsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AppointmentDetailsVC"];
            vc.dataDict=[self.dataArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(void)btnEditBookingClick:(UIButton *)sender
{
    
}

- (IBAction)btnBackClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
