//
//  ValidationCMoreVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 16/02/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "ValidationCMoreVC.h"
#import "MoreVCTableCell.h"
#import "AppHelper.h"
#import "Defines.h"
#import "AppDelegate.h"
#import "Services.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <EventKitUI/EventKitUI.h>
#import "BookingPopUp.h"
#import "AppointmentVC.h"
#import "ValidationCProfileVC.h"

@interface ValidationCMoreVC ()
{
    UIDatePicker *datePicker;
    UIToolbar *doneBarDatePicker;
    NSDateFormatter *_dateFormatter;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *screenTitle;
@property (nonatomic, copy) NSString *strBookingDate;
@property (strong,nonatomic) BookingPopUp *modal;


@end

@implementation ValidationCMoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.screenTitle.text=[self.dataDict valueForKey:@"name"];
    if (!datePicker) {
        datePicker = [[UIDatePicker alloc]init];
        [datePicker setMinimumDate:[NSDate date]];
        [datePicker setDate:[NSDate date]];
    }
    
    if (!_dateFormatter) {
        _dateFormatter = [NSDateFormatter new];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //[_dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    }
    
    if (!doneBarDatePicker) {
        doneBarDatePicker =[[UIToolbar alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width,44)];
        [doneBarDatePicker setBarStyle:UIBarStyleDefault];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                         
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                         target:self
                                         action:@selector(cancelButtonPressed:)];
        
        UIBarButtonItem *flexibleSpace =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                     target:self
                                                                                     action:nil];
        
        UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                   target:self
                                                                                   action:@selector(doneButtonPressed:)];
        [doneBarDatePicker setItems:@[cancelButton,flexibleSpace, doneButton]];
    }

    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [AppHelper setBorderOnView:self.tableView];

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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.strBookingDate=[_dateFormatter stringFromDate:[datePicker date]];
    /*CALayer *sublayer = [CALayer layer];
     sublayer.backgroundColor = [UIColor lightGrayColor].CGColor;
     sublayer.shadowOffset = CGSizeMake(0.5, 0.5);
     sublayer.shadowRadius = 1.0;
     sublayer.shadowColor = [UIColor blackColor].CGColor;
     sublayer.shadowOpacity = 0.5;
     sublayer.cornerRadius = 1.0;
     sublayer.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height);
     [self.view.layer addSublayer:sublayer];
     [self.view.layer addSublayer:self.tableView.layer];*/
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    CGPoint pnt = [self.tableView convertPoint:textField.bounds.origin fromView:textField];
    NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:pnt];
    
    MoreVCTableCell *cell=(MoreVCTableCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.popupView setHidden:YES];
    //[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"popupShown"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
 
    if(textField.tag==100)
    [self addInputViewToTextField:textField];
    if(textField.tag==200)
    [self addInputViewToTextField:textField];
    
    return YES;
}

- (void)addInputViewToTextField:(UITextField *)textField{
    
    
    if(textField.tag==100)
        [datePicker setDatePickerMode:UIDatePickerModeDate];
    if(textField.tag==200)
        [datePicker setDatePickerMode:UIDatePickerModeTime];

    textField.inputView = datePicker;
    textField.inputAccessoryView=doneBarDatePicker;
}


// Date-Time picker Done button pressed
- (void)doneButtonPressed:(UIBarButtonItem *)sender{
    
    NSIndexPath *myIP = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    MoreVCTableCell *cell = (MoreVCTableCell*)[self.tableView cellForRowAtIndexPath:myIP];
    
    cell.txtCalender.text = [NSDateFormatter localizedStringFromDate:[datePicker date] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
    cell.txtTime.text = [NSDateFormatter localizedStringFromDate:[datePicker date] dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
    
    NSLog(@"Date%@ and Time %@",cell.txtCalender.text,cell.txtTime.text);
    
     //NSString *date = [NSString stringWithFormat:@"%@",cell.txtCalender.text];
     //NSString *time = [NSString stringWithFormat:@"%@",cell.txtTime.text];
    
     NSLog(@"Date+Time %@ ",[_dateFormatter stringFromDate:[datePicker date]]);
    //[AppHelper saveToUserDefaults:[_dateFormatter stringFromDate:[datePicker date]] withKey:BookinTime];
    self.strBookingDate=[_dateFormatter stringFromDate:[datePicker date]];
    [cell.txtCalender resignFirstResponder];
    [cell.txtTime resignFirstResponder];

    
}

// Date-Time picker Cancel button pressed
- (void)cancelButtonPressed:(UIBarButtonItem *)sender{
    
    NSIndexPath *myIP = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    MoreVCTableCell *cell = (MoreVCTableCell*)[self.tableView cellForRowAtIndexPath:myIP];

    [cell.txtCalender resignFirstResponder];
    [cell.txtTime resignFirstResponder];
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //To disable text editing
    return NO;
}

#pragma mark- TableView delegates and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 735;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *kCustomCellID = @"MoreVCTableCell";
    MoreVCTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
    if (cell == nil)
        cell = [[MoreVCTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID];
    
    if (![@"YES" isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"popupShown"]])
        [cell.popupView setHidden:NO];
    
    cell.lblTitle.text=[self.dataDict valueForKey:@"name"];
    //cell.lblServices.text=[[[self.dataDict valueForKey:@"Validation_Center"]valueForKey:@"name"]componentsJoinedByString:@", "];
    cell.lblServices.text=[[self.dataDict valueForKey:@"Validation_Center"]valueForKey:@"name"];
    cell.txtAddress.text=[NSString stringWithFormat:@"%@",[self.dataDict valueForKey:@"address1"]];
    cell.lblDistance.text=[NSString stringWithFormat:@"~%d miles away",self.milesAway];
    cell.ratingView.canEdit=NO;
    cell.ratingView.rating=[[self.dataDict valueForKey:@"rating"]floatValue];
    
    NSMutableArray *timingsArr=[self flatDateAndTimeAsPerNeedWithArray:[self.dataDict valueForKey:@"availability"]];
    
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
    
    cell.txtTimings.text=[resultArray componentsJoinedByString:@"\n"];

    // For Date and Time fields
    cell.txtCalender.delegate=self;
    cell.txtTime.delegate=self;
    cell.txtCalender.tag=100;
    cell.txtTime.tag=200;
    
    cell.txtCalender.text = [NSDateFormatter localizedStringFromDate:[datePicker date] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
    
    cell.txtTime.text = [NSDateFormatter localizedStringFromDate:[datePicker date] dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
    
    cell.btnCall.tag=indexPath.row;
    [cell.btnCall setTitle:[self.dataDict valueForKey:@"phone"] forState:UIControlStateNormal];
    [cell.btnCall addTarget:self action:@selector(btnCallClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnBook.tag=indexPath.row;
    [cell.btnBook addTarget:self action:@selector(btnBookClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnProfile.tag=indexPath.row;
    [cell.btnProfile addTarget:self action:@selector(btnProfileClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
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

- (void)btnCallClicked:(UIButton *)sender {
    
    NSIndexPath *myIP = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    //Type cast it to CustomCell
    MoreVCTableCell *cell = (MoreVCTableCell*)[self.tableView cellForRowAtIndexPath:myIP];
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:cell.btnCall.titleLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (void)btnBookClicked:(UIButton *)sender {
    
    //create dictionary for parameters of web service//UserID, organizationId, bookingAt,
    NSMutableDictionary *parameters=[NSMutableDictionary new];
    [parameters setObject:AppKey forKey:@"AppKey"];
    [parameters setObject:[AppHelper userDefaultsForKey:uId] forKey:@"UserID"];
    [parameters setObject:[self.dataDict valueForKey:@"_id"] forKey:@"organizationId"];
    
    if(self.strBookingDate && ![self.strBookingDate isEqualToString:@""])
    {
        [parameters setObject:self.strBookingDate forKey:@"bookingAt"];
        [self hitServiceWithParam:parameters];
    }
    else
        [AppHelper showAlertWithTitle:@"No Date and Time selected!" message:@"Please choose Date and Time first" tag:0 delegate:nil cancelButton:@"Ok" otherButton:nil];
    
}
-(void)btnProfileClicked:(UIButton *)sender
{
    if ([[sender class] isSubclassOfClass: [UIButton class]]) {
        ValidationCProfileVC *VProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ValidationCProfileVC"];
        VProfileVC.allData=self.dataDict;
        [self.navigationController pushViewController:VProfileVC animated:YES];
    }
    
}
-(void)hitServiceWithParam:(NSDictionary *)params
{
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection]) {
        
        //show indicator on screen
        [SVProgressHUD showWithStatus:@"Please wait" maskType:SVProgressHUDMaskTypeBlack];
        
        //call global web service class
        [Services serviceCallWithPath:ServiceBookOrganization withParam:params success:^(NSDictionary *responseDict)
         {
             [SVProgressHUD dismiss];//dissmiss indicator
             
             if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
             {
                
                 if ([[responseDict objectForKey:@"error"] intValue] == 0) {
                 
                     if([[responseDict allKeys]containsObject:@"booking"])
                     {
                         [AppHelper showAlertWithTitle:[responseDict objectForKey:@"errorMsg"] message:@"" tag:0 delegate:nil cancelButton:ok otherButton:nil];
                          if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                          AppointmentVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AppointmentVC"];
                              vc.dictUserDetails=[responseDict objectForKey:@"user"];
                              vc.dictOrganizationDetails=[responseDict objectForKey:@"organization"];
                              vc.dictBookingDetails=[responseDict objectForKey:@"booking"];
                              [self.navigationController pushViewController:vc animated:YES];

                              if(![[responseDict objectForKey:@"errorMsg"] isEqualToString:@"Already Booked."])
                                  [self addEventToCalendarWithInfo:[responseDict objectForKey:@"booking"] withTitle:@"ProactiveLiving Appointment" withNotes:[NSString stringWithFormat:@"You have an appointment with %@",[[responseDict objectForKey:@"organization"] valueForKey:@"name"]]];
                          }
                         
                     }
                     else
                     {
                         // SetUp Popup view
                         self.modal = (BookingPopUp*)[self.storyboard instantiateViewControllerWithIdentifier:@"BookingPopUp"];
                         self.modal.view.userInteractionEnabled = TRUE;
                         self.modal.arrTimings=[responseDict objectForKey:@"result"];
                         self.modal.strBookingDate=[responseDict valueForKey:@"bookOnDate"];
                         [self.modal.btnBook addTarget:self action:@selector(btnBookClick:) forControlEvents:UIControlEventTouchUpInside];
                         [self addChildViewController:self.modal];
                         self.modal.view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-64);
                         [self.view addSubview:self.modal.view];
                         [UIView animateWithDuration:0.3 animations:^{
                             self.modal.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);;
                         } completion:^(BOOL finished) {
                             [self.modal didMoveToParentViewController:self];
                         }];
 
                     }
                     
                 
                 }
                 else
                 {
                 [AppHelper showAlertWithTitle:[responseDict objectForKey:@"errorMsg"] message:@"" tag:0 delegate:nil cancelButton:ok otherButton:nil];
                 
                 }
                
             }
             else
             {
                 [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
             }
             
         } failure:^(NSError *error)
         {
             [SVProgressHUD dismiss];
             NSLog(@"%@",error);
             [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
         }];
        
    }
    else {
        //show internet not available
        [AppHelper showAlertWithTitle:netError message:netErrorMessage tag:0 delegate:nil cancelButton:ok otherButton:nil];
    }


}

- (void)addEventToCalendarWithInfo:(NSDictionary *)dateInfo withTitle:(NSString *)title withNotes:(NSString *)notes {
    
     NSString *strDateTime = [NSString stringWithFormat:@"%@ %@",[dateInfo valueForKey:@"bookingDate"],[self timeFormatted:[[dateInfo valueForKey:@"bookingTime"]intValue]]];
    
    NSString *dateString=[AppHelper convertUTCFormattedDate:strDateTime];
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        EKEvent *event = [EKEvent eventWithEventStore:eventStore];
        EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:-30];
        event.alarms = [NSArray arrayWithObject:alarm];
        event.title = title;
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        event.startDate = [df dateFromString:dateString];
        event.endDate = [event.startDate dateByAddingTimeInterval:90*60];
        event.notes = notes;
        
        [event setCalendar:[eventStore defaultCalendarForNewEvents]];
        
        NSError *err;
        [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
    }];
}

- (void)btnBookClick:(id)sender {
    
    //create dictionary for parameters of web service//UserID, organizationId, bookingAt,
    NSMutableDictionary *parameters=[NSMutableDictionary new];
    [parameters setObject:AppKey forKey:@"AppKey"];
    [parameters setObject:[AppHelper userDefaultsForKey:uId] forKey:@"UserID"];
    [parameters setObject:[self.dataDict valueForKey:@"_id"] forKey:@"organizationId"];
    
    if([self.modal.selectedRowsArray count]>0)
    {
        if(self.modal){
            [UIView animateWithDuration:0.3 animations:^{
                self.modal.view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-64);
            } completion:^(BOOL finished) {
                [self.modal.view removeFromSuperview];
                [self.modal removeFromParentViewController];
            }];}
        NSString *strDateTime = [NSString stringWithFormat:@"%@ %@",self.modal.strBookingDate,[self timeFormatted:[[self.modal.selectedRowsArray objectAtIndex:0]intValue]]];
        
    [parameters setObject:[AppHelper convertUTCFormattedDate:strDateTime] forKey:@"bookingAt"];
    [self hitServiceWithParam:parameters];
    }
    else
        [AppHelper showAlertWithTitle:@"No Time selected!" message:@"Please choose a Time from list" tag:0 delegate:nil cancelButton:@"Ok" otherButton:nil];

}

- (NSDate*) dateFromString:(NSString*)aStr
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    //[dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss a"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSLog(@"%@", aStr);
    NSDate   *aDate = [dateFormatter dateFromString:aStr];
    return aDate;
}

- (IBAction)btnBackClick:(id)sender {
    //back to previous view controller
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
