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

@property (assign, atomic)int positionOfSelectedDate;



@end

@implementation AppointmentListingVC{
    //NSMutableArray *recuringArr;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.positionOfSelectedDate = -1;
   // recuringArr = [[NSMutableArray alloc]init];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getAppointmentListingData];

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
        [parameters setObject:self.fromScreenFlag forKey:@"calendarType"];
        
        if([self.fromScreenFlag isEqualToString:@"pac"]) {
            [parameters setValue:@"pac" forKey:@"calendarType"];
            [parameters setValue:self.pacID forKey:@"pacId"];
        }
        else {
            [parameters setValue:@"private" forKey:@"calendarType"];
        }


        //call global web service class
        [Services serviceCallWithPath:ServiceGetAppointmentList withParam:parameters success:^(NSDictionary *responseDict)
         {
             [AppDelegate dismissProgressHUD];//dissmiss indicator
             
             if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
             {
                 if ([[responseDict objectForKey:@"error"] intValue] == 0) {
                     
                     self.dataArray = [[responseDict objectForKey:@"result"] mutableCopy];
                     
                     NSMutableArray *arr = [[responseDict objectForKey:@"result"] mutableCopy];
                     
                    if([self.dataArray count]>0){
                   
                    //     [self filterArrayUsingEvents:self.arrEvents];
                        
                        [self getSelectedDatePositionInTableArr:arr];
                       // [self performSelector:@selector(moveCellToTop) withObject:nil afterDelay:0.5];
                   
                     
                        for (int i = 0; i < arr.count; i++)
                        {
                            if ([[_dataArray[i] valueForKeyPath:@"meetupInviteId.isrecur"] integerValue] == 1 ){
                                NSDictionary *recurrenceDict = [arr[i] valueForKeyPath:@"meetupInviteId.recurrence"];
                                //  NSString *startDate = [recurrenceDict valueForKey:@""];
                                NSString *endDate = [recurrenceDict valueForKey:@"endDate"];
                                NSString *recurrenceType = [recurrenceDict valueForKey:@"pattern"];
                                int interval = [[recurrenceDict valueForKey:@"recurevery"]intValue];
                                
                                
                                NSDictionary *dict = [arr[i] valueForKeyPath:@"meetupInviteId"];
                                
                                NSString *startDate = [dict valueForKey:@"eventDate"];
                                //get the recurrence date n append array
                                NSDateFormatter *df = [[NSDateFormatter alloc]init];
                                [df setDateFormat:@"yyyy/MM/dd"];
                                
                                NSDateFormatter *df1 = [[NSDateFormatter alloc]init];
                                [df1 setDateFormat:@"dd/MM/yyyy"];
                                
                                int rType = 0;
                                if([recurrenceType isEqualToString:@"Weekly"])
                                rType = 1;
                                else if([recurrenceType isEqualToString:@"Monthly"])
                                rType = 2;
                                else if([recurrenceType isEqualToString:@"Yearly"])
                                rType = 3;
                                
                                
                                NSArray *recurrenceArr = [self setupRecurringEventFromStartingDate:[df1 dateFromString:startDate ] toEndDate:[df dateFromString:endDate] withType:rType interval:interval];
                                
                                NSLog(@"recurrenceArr %@" , recurrenceArr);
                                
                                for (int j = 0; j < recurrenceArr.count; j++) {
                                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                                    NSDictionary *oldDict = arr[i];
                                    [newDict addEntriesFromDictionary:oldDict];
                                    
                                    [newDict setObject:recurrenceArr[j] forKey:@"bookingDate"];
                                    NSLog(@"new dict values =%@: " , newDict);
                                    [self.dataArray addObject:newDict];
                                    
                                }
                                
                                
                            }
                            //[self.tableView reloadData];
                            
                        }
                    }
                     NSSortDescriptor *bookingDescriptor = [[NSSortDescriptor alloc] initWithKey:@"bookingDate" ascending:YES];
                     NSSortDescriptor *timeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"bookingTime" ascending:YES];
                     NSArray *arr1 = [self.dataArray sortedArrayUsingDescriptors:@[bookingDescriptor,timeDescriptor]];
                     self.dataArray = [[NSMutableArray alloc]init];
                    self.dataArray = [NSMutableArray arrayWithArray:arr1];
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
   /*
    //showing selected date
    if (indexPath.row == 0 && [self.title isEqualToString:@"ALL"]) {
        cell.lblDD.text= [[[self getDateStringFromDate:self.selectedRecurrenceDate] componentsSeparatedByString:@" "]objectAtIndex:1];
        cell.lblEEE.text=[[[self getDateStringFromDate:self.selectedRecurrenceDate] componentsSeparatedByString:@" "]objectAtIndex:0];
        
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy/MM/dd"];
        
        cell.lblDateTime.text=[NSString stringWithFormat:@"%@ at %@",[df stringFromDate:_selectedRecurrenceDate],[self timeFormatted:[[self.dataArray objectAtIndex:indexPath.row][@"bookingTime"] intValue]]];
        
    }else{
        cell.lblDD.text=[[[self componentsFromDate:[self.dataArray objectAtIndex:indexPath.row][@"bookingDate"]] componentsSeparatedByString:@" "]objectAtIndex:1];
        cell.lblEEE.text=[[[self componentsFromDate:[self.dataArray objectAtIndex:indexPath.row][@"bookingDate"]] componentsSeparatedByString:@" "]objectAtIndex:0];
    
        cell.lblDateTime.text=[NSString stringWithFormat:@"%@ at %@",[self.dataArray objectAtIndex:indexPath.row][@"bookingDate"],[self timeFormatted:[[self.dataArray objectAtIndex:indexPath.row][@"bookingTime"] intValue]]];
    
    }
    */
    
    // to display Calendar Selected date on cell
//    if ((self.positionOfSelectedDate > -1) && (indexPath.row == self.positionOfSelectedDate) && [self.title isEqualToString:@"ALL"]) {
//        cell.lblDD.text= [[[self getDateStringFromDate:self.selectedRecurrenceDate] componentsSeparatedByString:@" "]objectAtIndex:1];
//        cell.lblEEE.text=[[[self getDateStringFromDate:self.selectedRecurrenceDate] componentsSeparatedByString:@" "]objectAtIndex:0];
//        
//        NSDateFormatter *df = [[NSDateFormatter alloc]init];
//        [df setDateFormat:@"MM/dd/yyyy"];
//        
//        cell.lblDateTime.text=[NSString stringWithFormat:@"%@ at %@",[df stringFromDate:_selectedRecurrenceDate],[self timeFormatted:[[self.dataArray objectAtIndex:indexPath.row][@"bookingTime"] intValue]]];
//        
//    }else{
        cell.lblDD.text=[[[self componentsFromDate:[self.dataArray objectAtIndex:indexPath.row][@"bookingDate"]] componentsSeparatedByString:@" "]objectAtIndex:1];
        cell.lblEEE.text=[[[self componentsFromDate:[self.dataArray objectAtIndex:indexPath.row][@"bookingDate"]] componentsSeparatedByString:@" "]objectAtIndex:0];
        
        NSString *date = [self.dataArray objectAtIndex:indexPath.row][@"bookingDate"];
     //   [HelpingClass convertDateFormat
         
        
        cell.lblDateTime.text=[NSString stringWithFormat:@"%@ at %@",[HelpingClass convertDateFormat:@"yyyy/MM/dd" desireFormat:@"MM/dd/yyyy" dateStr:date],[self timeFormatted:[[self.dataArray objectAtIndex:indexPath.row][@"bookingTime"] intValue]]];
        
   // }
    
    
    cell.sideBarView.backgroundColor=[AppHelper colorFromHexString:[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"bookingColor"] alpha:1.0];
    
    
    //cell.lblName.text=[NSString stringWithFormat:@"Event Type: %@",[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"type"]];
    
    if ([[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"appointment"]) {
        
        cell.lblFor.text = @"";
        cell.lblBy.text = @"";
        cell.lblDesc.text=[[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"organizationId"] valueForKey:@"address1"];
    }
    else
    {
        cell.lblFor.text = [[self.dataArray objectAtIndex:indexPath.row] valueForKeyPath:@"meetupInviteId.for"];
        cell.lblBy.text = [NSString stringWithFormat:@"by %@",[[self.dataArray objectAtIndex:indexPath.row] valueForKeyPath:@"meetupInviteId.admin"]];
        cell.lblDesc.text= [[self.dataArray objectAtIndex:indexPath.row] valueForKeyPath:@"meetupInviteId.address" ];
    }
    
    [AppHelper setBorderOnView:cell.imgCellBG];
    
    cell.btnEdit.tag=indexPath.row;
    [cell.btnEdit addTarget:self action:@selector(btnEditBookingClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        
        if([[self.dataArray objectAtIndex:indexPath.row][@"type"] isEqualToString:@"meetup"])
        {
            [self fetchDataForType:[self.dataArray objectAtIndex:indexPath.row][@"type"] andWithID:[self.dataArray objectAtIndex:indexPath.row][@"meetupInviteId"][@"_id"]];
        }
        else if([[self.dataArray objectAtIndex:indexPath.row][@"type"] isEqualToString:@"webinvite"])
        {
            [self fetchDataForType:[self.dataArray objectAtIndex:indexPath.row][@"type"] andWithID:[self.dataArray objectAtIndex:indexPath.row][@"meetupInviteId"][@"_id"]];
        }
        else
        {
            AppointmentDetailsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AppointmentDetailsVC"];
            vc.dataDict=[self.dataArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(void) fetchDataForType :(NSString *) groupType andWithID :(NSString *) groupID {
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection]) {
        NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]init];
        [paramDict setValue:AppKey forKey:@"AppKey"];
        [paramDict setValue:[AppHelper userDefaultsForKey:uId] forKey:@"userId"];
        [paramDict setValue:groupType forKey:@"type"];
        [paramDict setValue:groupID forKey:@"typeId"];
        
        [AppDelegate showProgressHUDWithStatus:@"Please wait.."];
        [Services postRequest:ServiceGetDetailMeetupInvite parameters:paramDict completionHandler:^(NSString *error, NSDictionary *responseDict) {
            
            [AppDelegate dismissProgressHUD];//dissmiss indicator
            
            if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
            {
                if ([[responseDict objectForKey:@"error"] intValue] == 0) {

                    MeetUpDetailsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MeetUpDetailsVC"];
                    vc.dataDict = [responseDict objectForKey:@"result"];
                    if([[responseDict[@"result"] objectForKey:@"type"] isEqualToString:@"meetup"])
                        vc.screenName = @"MEET UPS";
                    else
                        vc.screenName = @"WEB INVITES";
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                else
                {
                    [AppHelper showAlertWithTitle:[responseDict objectForKey:@"errorMsg"] message:@"" tag:0 delegate:nil cancelButton:ok otherButton:nil];
                }
                
            }
            else
                [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
            
            
        }];
        
        
    }
    else
        //show internet not available
        [AppHelper showAlertWithTitle:netError message:netErrorMessage tag:0 delegate:nil cancelButton:ok otherButton:nil];
}

-(NSMutableArray *)setupRecurringEventFromStartingDate:(NSDate*)sDate toEndDate:(NSDate*)eDate withType:(NSInteger)type interval:(NSInteger)interval{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd-mm-yyyy"];
    
    NSMutableArray *recuringArr = [[NSMutableArray alloc]init];
    NSDate *nextRecurringDate = sDate;
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    do {
        
        NSDateComponents *dateComponent = [[NSDateComponents alloc] init];
        // dateComponent.
        
        switch (type) {
            case 0:
                dateComponent.day = interval;
                break;
            case 1:
                dateComponent.weekOfMonth = interval;
                break;
            case 2:
                dateComponent.month = interval;
                break;
            case 3:
                dateComponent.year = interval;
                break;
                
                
            default:
                break;
        }
        
        nextRecurringDate = [cal dateByAddingComponents:dateComponent toDate:nextRecurringDate options:0];
        
        if ([nextRecurringDate compare:eDate] == NSOrderedDescending) {
            //NSLog(@"nextRecurringDate is later than eDate");
            return recuringArr;
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyyy/MM/dd";
        
        NSString *dateValStr = [dateFormatter stringFromDate:nextRecurringDate];
        
        
        [recuringArr addObject: dateValStr];
        
    }while (1);
    
    return recuringArr;
    
}

#pragma mark-
// filter on array to move events to top
-(void)filterArrayUsingEvents:(NSArray *)arrEvents
{
    for(CKCalendarEvent *event in arrEvents) {
        NSString *eventID=[event.info valueForKey:@"_id"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@)", @"_id",eventID];
        NSMutableArray *filteredarray = [[self.dataArray filteredArrayUsingPredicate:predicate] mutableCopy];
        //NSLog(@"array %@",eventID);
        
        NSInteger index = [self.dataArray indexOfObject:filteredarray[0]];
        id obj = self.dataArray[index];
        [self.dataArray removeObjectAtIndex:index];
        [self.dataArray insertObject:obj atIndex:0];
    }
}


-(void)getSelectedDatePositionInTableArr:(NSMutableArray *)arrEvents
{
    for(CKCalendarEvent *event in arrEvents) {
        NSString *eventID=[event valueForKey:@"_id"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@)", @"_id",eventID];
        NSMutableArray *filteredarray = [[self.dataArray filteredArrayUsingPredicate:predicate] mutableCopy];
        //NSLog(@"array %@",eventID);
        
        NSInteger index = [self.dataArray indexOfObject:filteredarray[0]];
        
         self.positionOfSelectedDate = (int) index;
       
        
    }
    
    
    
}

-(void)moveCellToTop{
   
    NSIndexPath *indexPath  = [NSIndexPath indexPathForRow: (NSInteger) self.positionOfSelectedDate inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
    
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

-(NSString *)getDateStringFromDate:(NSDate *)date{
    
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"yyyy MMM EEEE"];
    //NSString*strDate1=[dayFormatter stringFromDate:myDate];
    [dayFormatter setDateFormat:@"EE d LLLL yyyy"];
    NSString *strDate2=[dayFormatter stringFromDate:date];
    
    return strDate2;
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
