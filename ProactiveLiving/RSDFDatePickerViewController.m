//
// RSDFDatePickerViewController.m
//
// Copyright (c) 2013 Evadne Wu, http://radi.ws/
// Copyright (c) 2013-2015 Ruslan Skorb, http://ruslanskorb.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "RSDFDatePickerViewController.h"
#import "RSDFDatePickerView.h"
#import "RSDFCustomDatePickerView.h"
#import "Defines.h"
#import "AppDelegate.h"
#import "AppHelper.h"
#import "NSDate+Components.h"
#import "CKCalendarEvent.h"
#import "AllAppointmentsVC.h"
#import "ProactiveLiving-Swift.h"
#import <EventKit/EventKit.h>


@interface RSDFDatePickerViewController() <RSDFDatePickerViewDelegate, RSDFDatePickerViewDataSource>

@property (copy, nonatomic) NSArray *datesToMark;
@property (copy, nonatomic) NSDictionary *statesOfTasks;
@property (copy, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) RSDFDatePickerView *datePickerView;
@property (strong, nonatomic) RSDFCustomDatePickerView *customDatePickerView;
@property (copy, nonatomic) UIColor *completedTasksColor;
@property (copy, nonatomic) UIColor *uncompletedTasksColor;
@property (copy, nonatomic) NSDate *today;

@property (nonatomic, strong) NSMutableDictionary *eventData;
@property (strong, nonatomic) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *btnSwitchView;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@property NSDate *selectedDate;

@property BOOL recordNotFound;

@end

@implementation RSDFDatePickerViewController{
    NSMutableArray *recuringArr;
}

#pragma mark - Lifecycle

/*
//type = 0 for daily basis
type = 1 for weekly basis
type = 2 for month basis
type = 3 for yeary basis
*/

-(NSMutableArray *)setupRecurringEventFromStartingDate:(NSDate*)sDate toEndDate:(NSDate*)eDate withType:(NSInteger)type interval:(NSInteger)interval{
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd-mm-yyyy"];
    //NSString *startDate = [dateFormate stringFromDate: sDate];
    
    //NSString *endDate = [dateFormate stringFromDate: eDate];
    
    NSMutableArray *recuringArr = [[NSMutableArray alloc]init];
//    NSMutableDictionary *recurringDict = [NSMutableDictionary dictionary];
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
//        if ([date1 compare:date2] == NSOrderedDescending) {
//            NSLog(@"date1 is later than date2");
//        }
        
        //save event date in date as a key
        
        
        
        
        
        if ([nextRecurringDate compare:eDate] == NSOrderedDescending) {
            NSLog(@"nextRecurringDate is later than eDate");
            return recuringArr;
        }
        /*else if ([nextRecurringDate compare:eDate] == NSOrderedAscending) {
            NSLog(@"nextRecurringDate is earlier than eDate");
        } else {
            NSLog(@"dates are the same");
        }*/
        
        
        [recuringArr addObject: nextRecurringDate];
        
        
    }while (1);
    
    return recuringArr;
    
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *todayBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStylePlain target:self action:@selector(onTodayButtonTouch:)];
    self.navigationItem.rightBarButtonItem = todayBarButtonItem;
    
    UIBarButtonItem *restyleBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Restyle" style:UIBarButtonItemStylePlain target:self action:@selector(onRestyleButtonTouch:)];
    self.navigationItem.leftBarButtonItem = restyleBarButtonItem;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
    
    NSDateComponents *todayComponents = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today = [self.calendar dateFromComponents:todayComponents];
    [self.datePickerView selectDate:today];
    
    self.customDatePickerView.hidden = YES;
    [self.view addSubview:self.datePickerView];
   
    // To take button on front most
    [self.view addSubview:self.btnSwitchView];
    [self.datePickerView bringSubviewToFront:self.btnSwitchView];
    [self.btnSwitchView addTarget:self action:@selector(onEventsButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    if([self.fromScreen isEqualToString:@"AboutPacVC"]) {
        [self.btnBack setHidden:NO];
    }
    else {
        [self.btnBack setHidden:YES];

    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _recordNotFound = false;

    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self getAppointmentListingData];
  
    recuringArr = [[NSMutableArray alloc]init];
    
  //  [self createRecurringEvent];

}

-(void)createRecurringEvent{
    NSDate *endDate = [NSDate dateWithDay:31 month:12 year:2020];
    
    EKRecurrenceRule *rule = [[EKRecurrenceRule alloc]
                              initRecurrenceWithFrequency:EKRecurrenceFrequencyMonthly
                              interval:1
                              end:[EKRecurrenceEnd recurrenceEndWithEndDate:endDate]];
    
    NSLog(@"Rules = %@", rule);
    
    EKEventStore *store = [[EKEventStore alloc] init];
    
    // Get the appropriate calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Create the start date components
    NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
    oneDayAgoComponents.day = -1;
    NSDate *oneDayAgo = [calendar dateByAddingComponents:oneDayAgoComponents
                                                  toDate:[NSDate date]
                                                 options:0];
    
    // Create the end date components
    NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc] init];
    oneYearFromNowComponents.year = 1;
    NSDate *oneYearFromNow = [calendar dateByAddingComponents:oneYearFromNowComponents
                                                       toDate:[NSDate date]
                                                      options:0];
    
    // Create the predicate from the event store's instance method
    NSPredicate *predicate = [store predicateForEventsWithStartDate:oneDayAgo
                                                            endDate:oneYearFromNow
                                                          calendars:nil];
    
    // Fetch all events that match the predicate
    NSArray *events = [store eventsMatchingPredicate:predicate];
    
    //======================
  //  EKEventStore *store = [[EKEventStore alloc] init];
    
    
    EKEvent *event = [EKEvent eventWithEventStore:store];
    event.title = @"title";
    event.startDate = [NSDate date];
    event.endDate = [NSDate dateWithDay:3 month:12 year:2017];
    
    
    
    // The EKRecurrenceRule accepts an NSArray of day objects, I did this to make adding multiple days easier
    NSMutableArray *daysArr = [[NSMutableArray alloc] init];
    
    // Days of the week are ordered Sunday to Saturday, 1-7
    EKRecurrenceDayOfWeek *theDay = [[EKRecurrenceDayOfWeek alloc] initWithDayOfTheWeek:6 weekNumber:0];
    
    // Add Friday to the array
    [daysArr addObject:theDay];
    
    // Instantiate the EKRecurrenceRule, giving it a weekly frequency and the day of the week
  //  EKRecurrenceRule *recurrenceRule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:1 daysOfTheWeek:daysArr daysOfTheMonth:nil monthsOfTheYear:nil weeksOfTheYear:nil daysOfTheYear:nil setPositions:nil end:nil];
    
    EKRecurrenceRule *recurrenceRule =  [[EKRecurrenceRule alloc]
     initRecurrenceWithFrequency:EKRecurrenceFrequencyMonthly
     interval:1
     end:[EKRecurrenceEnd recurrenceEndWithEndDate:endDate]];
    
    // Apply it to the event
    [event setRecurrenceRules:@[recurrenceRule]];
    NSLog(@"Event = %@", event);
    
    
}

#pragma mark - preferredStatusBarStyle
-(UIStatusBarStyle)preferredStatusBarStyle {
    // to set the light color of status bar
    return UIStatusBarStyleLightContent;
}

#pragma mark - Custom Accessors
- (void)setCalendar:(NSCalendar *)calendar
{
    if (![_calendar isEqual:calendar]) {
        _calendar = calendar;
        
        //self.title = [_calendar.calendarIdentifier capitalizedString];
    }
}

- (NSArray *)datesToMark
{
    if (!_datesToMark) {
//        NSArray *numberOfDaysFromToday = @[@(1), @(2), @(3), @(0), @(-1), @(-2), @(-3), @(13), @(22)];
//        
//        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
//        NSMutableArray *datesToMark = [[NSMutableArray alloc] initWithCapacity:[numberOfDaysFromToday count]];
//        [numberOfDaysFromToday enumerateObjectsUsingBlock:^(NSNumber *numberOfDays, NSUInteger idx, BOOL *stop) {
//            dateComponents.month = [numberOfDays integerValue];
//            NSDate *date = [self.calendar dateByAddingComponents:dateComponents toDate:self.today options:0];
//            [datesToMark addObject:date];
//            NSLog(@"Next Recursive = %@", date);
//        }];
//        
//        _datesToMark = [datesToMark copy];
        
    }
    return _datesToMark;
}

- (NSDictionary *)statesOfTasks
{
    if (!_statesOfTasks) {
        NSMutableDictionary *statesOfTasks = [[NSMutableDictionary alloc] initWithCapacity:[self.datesToMark count]];
        [self.datesToMark enumerateObjectsUsingBlock:^(NSDate *date, NSUInteger idx, BOOL *stop) {
            BOOL isCompletedAllTasks = NO;
            if ([date compare:self.today] == NSOrderedAscending) {
                isCompletedAllTasks = YES;
            }
            statesOfTasks[date] = @(isCompletedAllTasks);
        }];
        
        _statesOfTasks = [statesOfTasks copy];
    }
    return _statesOfTasks;
}

- (NSDate *)today
{
    if (!_today) {
        NSDateComponents *todayComponents = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
        _today = [self.calendar dateFromComponents:todayComponents];
    }
    return _today;
}

- (UIColor *)completedTasksColor
{
    if (!_completedTasksColor) {
        _completedTasksColor = [UIColor colorWithRed:83/255.0f green:215/255.0f blue:105/255.0f alpha:1.0f];
    }
    return _completedTasksColor;
}

- (UIColor *)uncompletedTasksColor
{
    if (!_uncompletedTasksColor) {
        _uncompletedTasksColor = [UIColor colorWithRed:184/255.0f green:184/255.0f blue:184/255.0f alpha:1.0f];
    }
    return _uncompletedTasksColor;
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setCalendar:self.calendar];
        [_dateFormatter setLocale:[self.calendar locale]];
        [_dateFormatter setDateStyle:NSDateFormatterFullStyle];
    }
    return _dateFormatter;
}

- (RSDFDatePickerView *)datePickerView
{
	if (!_datePickerView) {
		_datePickerView = [[RSDFDatePickerView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT) calendar:self.calendar];
        _datePickerView.delegate = self;
        _datePickerView.dataSource = self;
		_datePickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _datePickerView.pagingEnabled=YES;
	}
	return _datePickerView;
}

- (RSDFCustomDatePickerView *)customDatePickerView
{
    if (!_customDatePickerView) {
        _customDatePickerView = [[RSDFCustomDatePickerView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT) calendar:self.calendar];
        _customDatePickerView.delegate = self;
        _customDatePickerView.dataSource = self;
		_customDatePickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _customDatePickerView.pagingEnabled = YES;
    }
    return _customDatePickerView;
}

#pragma mark - Action handling
- (IBAction)onTodayButtonTouch:(id)sender {
    
    if (!self.datePickerView.hidden) {
        [self.datePickerView scrollToToday:YES];
    } else {
        [self.customDatePickerView scrollToToday:YES];
    }
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
                                      if([self.fromScreen isEqualToString:@"AboutPacVC"]) {
                                          vc.fromScreenFlag = @"PAC";
                                          vc.pacID = self.pacID; 
                                          vc.arrPACMembers = self.arrPACMembers;
                                          NSLog(@"arrPACMembers %@",self.arrPACMembers);
                                      }
                                      else {
                                          vc.fromScreenFlag = @"private";
                                          vc.currentDateVal = _selectedDate;
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
                                         if([self.fromScreen isEqualToString:@"AboutPacVC"])
                                         {
                                             vc.fromScreenFlag = @"PAC";
                                             vc.pacID = self.pacID;
                                             vc.arrPACMembers = self.arrPACMembers;
                                         }
                                         else {
                                             vc.fromScreenFlag = @"private";
                                             vc.currentDateVal = _selectedDate;

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
    
    
    if([self.fromScreen isEqualToString:@"AboutPacVC"]) {
        if(self.allowToCreateWebinvite == TRUE || self.allowToCreateMeetup == TRUE) {
            
            if(self.allowToCreateMeetup == TRUE)
                [alertActionSheet addAction:meetup];
            if(self.allowToCreateWebinvite == TRUE)
                [alertActionSheet addAction:webinvite];
            
            [alertActionSheet addAction:cancel];
            [self presentViewController:alertActionSheet animated:YES completion:nil];
        }
    }
    else {
       // [alertActionSheet addAction:appointment];
        [alertActionSheet addAction:meetup];
        [alertActionSheet addAction:webinvite];
       // [alertActionSheet addAction:other];
        [alertActionSheet addAction:cancel];
        [self presentViewController:alertActionSheet animated:YES completion:nil];

    }
    
    
}

- (IBAction)onBackButtonTouch:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onEventsButtonTouch:(id)sender {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        AllAppointmentsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AllAppointmentsVC"];
        if([self.fromScreen isEqualToString:@"AboutPacVC"]) {
            vc.fromScreenFlag = @"pac";
            vc.pacID = self.pacID;
            vc.recordNotFound = self.recordNotFound;
            vc.allowToCreateMeetup = self.allowToCreateMeetup;
            vc.allowToCreateWebinvite = self.allowToCreateWebinvite;
            vc.arrPACMembers = self.arrPACMembers;
        }
        else {
            vc.fromScreenFlag = @"private";
        }
        [self.navigationController pushViewController:vc animated:NO];
    }
}

- (void)onRestyleButtonTouch:(UIBarButtonItem *)sender
{
    if (!self.datePickerView.hidden) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:244/255.0f green:245/255.0f blue:247/255.0f alpha:1.0f];
        self.datePickerView.hidden = YES;
        self.customDatePickerView.hidden = NO;
    } else {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f];
        self.customDatePickerView.hidden = YES;
        self.datePickerView.hidden = NO;
    }
}
#pragma mark - getAppointmentListingData

-(void)getAppointmentListingData
{
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection]) {
        
        //show indicator on screen
        //[AppDelegate showProgressHUDWithStatus:@""];

        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
        [parameters setValue:AppKey forKey:@"AppKey"];
        
        if([self.fromScreen isEqualToString:@"AboutPacVC"]) {
            [parameters setValue:@"pac" forKey:@"calendarType"];
            [parameters setValue:self.pacID forKey:@"pacId"];
        }
        else {
            [parameters setValue:@"private" forKey:@"calendarType"];
        }

        
        [parameters setValue:[AppHelper userDefaultsForKey:uId] forKey:@"UserID"];
        
        //call global web service class
        [Services serviceCallWithPath:ServiceGetAppointmentList withParam:parameters success:^(NSDictionary *responseDict)
         {
             [AppDelegate dismissProgressHUD];
             
             
             NSLog(@" valusfro appoint mnt6 %@" , responseDict);
             
             if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
             {
                 if ([[responseDict objectForKey:@"error"] intValue] == 0) {
                     
                     self.dataArray=[responseDict objectForKey:@"result"];
                     printf("Events : %d",self.dataArray.count);
                     
                     self.eventData = [[NSMutableDictionary alloc] init];
                     
                     NSDictionary *groups = [self groupArrayIntoDictionaryWithArray:self.dataArray withBlock:^id<NSCopying>(NSDictionary *person) {
                         return person[@"bookingDate"];
                     }];
                     
                     NSMutableArray *datesToMark = [[NSMutableArray alloc] initWithCapacity:[[groups allKeys] count]];
                     
                     for (id key in [groups allKeys]) {
                         NSMutableArray *eventsArray=[NSMutableArray new];
                         NSDate *date;
                         for (int i=0; i<[[groups objectForKey:key] count]; i++) {
                             
                             //Title not nil means Appontment else Meet up may have recurrence
                             NSString *title = [[[[groups objectForKey:key] objectAtIndex:i] objectForKey:@"organizationId"] valueForKey:@"name"];
                             
                             
                             
                             date = [NSDate
                                     dateWithDay:[[[[[[groups objectForKey:key] objectAtIndex:i] valueForKey:@"bookingDate"] componentsSeparatedByString:@"/"]objectAtIndex:2] intValue]
                                     month:[[[[[[groups objectForKey:key] objectAtIndex:i] valueForKey:@"bookingDate"] componentsSeparatedByString:@"/"]objectAtIndex:1] intValue]
                                     year:[[[[[[groups objectForKey:key] objectAtIndex:i] valueForKey:@"bookingDate"] componentsSeparatedByString:@"/"]objectAtIndex:0] intValue]];
                             [datesToMark addObject:date];
                             
                             NSDictionary *infoDict = [[groups objectForKey:key] objectAtIndex:i];
                             UIColor *color = [AppHelper colorFromHexString:[[[groups objectForKey:key] objectAtIndex:i] valueForKey:@"bookingColor"] alpha:1.0];
                             
                             CKCalendarEvent *event = [CKCalendarEvent eventWithTitle:title andDate:date andInfo:infoDict andColor:color];
                             
                             [eventsArray addObject:event];
                             
                             if (([title isKindOfClass:[NSNull class]]) || title == nil || [title isEqualToString:@"<nil>"] || title.length == 0) {
                                 printf("Nil checking");
                                 
                             }
                             
                             // create recurrence of meet up if have. 1 = have, 0 = not have
                             if (([title isKindOfClass:[NSNull class]]) || (title == nil || [title isEqualToString:@"<nil>"] || title.length == 0) && [[[[groups objectForKey:key] objectAtIndex:i] valueForKeyPath:@"meetupInviteId.isrecur"] integerValue] == 1) {
                                 
                                 NSDictionary *recurrenceDict = [[[groups objectForKey:key] objectAtIndex:i] valueForKeyPath:@"meetupInviteId.recurrence"];
                               //  NSString *startDate = [recurrenceDict valueForKey:@""];
                                 NSString *endDate = [recurrenceDict valueForKey:@"endDate"];
                                 NSString *recurrenceType = [recurrenceDict valueForKey:@"pattern"];
                                 int interval = [[recurrenceDict valueForKey:@"recurevery"]intValue];
                                 
                                 
                                 
                                 
                                 
                                 //get the recurrence date n append array
                                 NSDateFormatter *df = [[NSDateFormatter alloc]init];
                                 [df setDateFormat:@"yyyy/MM/dd"];
                                 
                                 int rType = 0;
                                 if([recurrenceType isEqualToString:@"Weekly"])
                                     rType = 1;
                                 else if([recurrenceType isEqualToString:@"Monthly"])
                                     rType = 2;
                                 else if([recurrenceType isEqualToString:@"Yearly"])
                                     rType = 3;
                                 
                                 
                                 NSArray *recurrenceArr = [self setupRecurringEventFromStartingDate:[df dateFromString:key ] toEndDate:[df dateFromString:endDate] withType:rType interval:interval];
                                 
                                 [datesToMark addObjectsFromArray:recurrenceArr];
                                 
                                 // add event to dict
                                 for (int i = 0; i < recurrenceArr.count; i++) {
                                     
                                     event = [CKCalendarEvent eventWithTitle:title andDate: [recurrenceArr objectAtIndex:i]  andInfo:infoDict andColor:color];
                                     
                                     self.eventData[[recurrenceArr objectAtIndex:i]]= [NSArray arrayWithObject:event];
                                 }
                                 
                             }
                             
                         }
                         self.eventData[date]=eventsArray;
                     }
                     //setUp the Recurring date on a single date
                     NSDateFormatter *df = [[NSDateFormatter alloc]init];
                     [df setDateFormat:@"dd-MM-yyyy"];
                     
                   //  for (int i = 0; i< 3; i++) {
                   //      [self setupRecurringEventFromStartingDate:[df dateFromString:@"08-11-2016"] toEndDate:[df dateFromString:@"08-11-2020"] withType:0];
                  //   }
                  /*   [self setupRecurringEventFromStartingDate:[df dateFromString:@"07-11-2016"] toEndDate:[df dateFromString:@"07-11-2020"] withType:1];
                     [self setupRecurringEventFromStartingDate:[df dateFromString:@"08-11-2016"] toEndDate:[df dateFromString:@"08-11-2020"] withType:2];
                     [self setupRecurringEventFromStartingDate:[df dateFromString:@"09-11-2016"] toEndDate:[df dateFromString:@"09-11-2020"] withType:3];
                     
                     // add recurring date in arry to display on calendar
                     [datesToMark addObjectsFromArray:recuringArr]; */
                     
                     _datesToMark = [datesToMark copy];
                     _datePickerView.eventData = self.eventData;
                     [_datePickerView reloadData];
                     
                     
                 }
                 else
                 {
                     //[AppHelper showAlertWithTitle:[responseDict objectForKey:@"errorMsg"] message:@"" tag:0 delegate:nil cancelButton:ok otherButton:nil];
                     _recordNotFound = true;
                     
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

/// @return A dictionary of NSMutableArrays
- (NSDictionary *)groupArrayIntoDictionaryWithArray:(NSArray *)array withBlock:(id<NSCopying>(^)(id object))keyFromObjectCallback {
    NSParameterAssert(keyFromObjectCallback);
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (id object in array) {
        id<NSCopying> key = keyFromObjectCallback(object);
        NSMutableArray *array = [result objectForKey:key];
        if (array == nil) {
            array = [NSMutableArray new];
            [result setObject:array forKey:key];
        }
        [array addObject:object];
    }
    return [result copy];
}

#pragma mark - RSDFDatePickerViewDelegate

- (void)datePickerView:(RSDFDatePickerView *)view didSelectDate:(NSDate *)date
{
    NSArray * eventArray=[view.eventData objectForKey:date];
    if ([eventArray count]>0) {
      /*
        //add recurrence selected date to event
        CKCalendarEvent *event  = [eventArray firstObject];
        NSMutableDictionary *dict= [event.info mutableCopy] ;
        [dict setValue:date forKey:@"recurrenceDate"];
        
        NSArray *arr = [NSArray arrayWithObject:dict];
        */
            
        if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
            AllAppointmentsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AllAppointmentsVC"];
            vc.arrEvents=eventArray;
            vc.selectedRecurrenceDate = date;
            
            if([self.fromScreen isEqualToString:@"AboutPacVC"]) {
                vc.fromScreenFlag = @"pac";
                vc.pacID = self.pacID;
                vc.allowToCreateMeetup = self.allowToCreateMeetup;
                vc.allowToCreateWebinvite = self.allowToCreateWebinvite;
                vc.arrPACMembers = self.arrPACMembers;
            }
            else
                vc.fromScreenFlag = @"private";
                
            [self.navigationController pushViewController:vc animated:YES];
        }
        NSLog(@"%lu",(unsigned long)eventArray.count);
    }
    else
    {
        //let time  = convert(time: on!, fromFormat: "dd/MM/yyyy", toFormat: "MM/dd/yyyy")
        _selectedDate = date;
        [self btnCreateEventClick:nil];
        NSLog(@"No event");
    }
}

#pragma mark - RSDFDatePickerViewDataSource

- (BOOL)datePickerView:(RSDFDatePickerView *)view shouldHighlightDate:(NSDate *)date
{
    if (view == self.datePickerView) {
        return YES;
    }
    
    if ([self.today compare:date] == NSOrderedDescending) {
        return NO;
    }
    
    return YES;
}

- (BOOL)datePickerView:(RSDFDatePickerView *)view shouldSelectDate:(NSDate *)date
{
    if (view == self.datePickerView) {
        return YES;
    }
    
    if ([self.today compare:date] == NSOrderedDescending) {
        return NO;
    }
    
    return YES;
    
}

- (BOOL)datePickerView:(RSDFDatePickerView *)view shouldMarkDate:(NSDate *)date
{
    return [self.datesToMark containsObject:date];
}

- (UIColor *)datePickerView:(RSDFDatePickerView *)view markImageColorForDate:(NSDate *)date
{
   /* if (![self.statesOfTasks[date] boolValue]) {
        return self.uncompletedTasksColor;
    } else {
        return self.completedTasksColor;
    }*/
    if ([self.datesToMark containsObject:date]) {
        
        //get color form event
        CKCalendarEvent *event = [self.eventData[date] firstObject];
        return   event.color ;
    }
    return nil;
}

@end
