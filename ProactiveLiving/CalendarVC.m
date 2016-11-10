//
//  CalendarVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 12/04/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "CalendarVC.h"
#import <EventKit/EventKit.h>

#import "NSCalendarCategories.h"
#import "NSDate+Components.h"
#import "AppHelper.h"
#import "AppDelegate.h"
#import "Defines.h"
#import "UIView+AnimatedFrame.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "AllAppointmentsVC.h"
#import "AppointmentListingVC.h"

@interface CalendarVC ()<CKCalendarViewDelegate, CKCalendarViewDataSource>

@property (nonatomic, strong) NSMutableDictionary *data;
@property (strong, nonatomic) NSArray *dataArray;
@end

@implementation CalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /**
     *  Create a dictionary for the data source
     */
    
    self.data = [[NSMutableDictionary alloc] init];
    
    /**
     *  Wire up the data source and delegate.
     */
    
    [self setDataSource:self];
    [self setDelegate:self];
    
    
    
    /**
     *  Create some events.
     */
    
    //  An event for the new MBCalendarKit release.
    //NSString *title = NSLocalizedString(@"Release MBCalendarKit 2.2.4", @"");
    //NSDate *date = [NSDate dateWithDay:28 month:04 year:2016];
    //CKCalendarEvent *releaseUpdatedCalendarKit = [CKCalendarEvent eventWithTitle:title andDate:date andInfo:nil];
    
    
    /**
     *  Add the events to the data source.
     *
     *  The key is the date that the array of events appears on.
     */
    
//    self.data[date] = @[releaseUpdatedCalendarKit];
//    self.data[date2] = @[mockingJay, integrationEvent,anotherEvent];
//    self.data[date2] = @[mockingJay, integrationEvent];
//    self.data[date3] = @[fixBug];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnListAllClick) name:@"PUSH_ALL_LIST_VC" object:nil];

    
}

- (void)btnListAllClick {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        AllAppointmentsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AllAppointmentsVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    /*
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        AppointmentListingVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ListAllVC"];
        vc.appointmnetType=@"";
        [self.navigationController pushViewController:vc animated:YES];
    }
    */
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self getAppointmentListingData];
    
  

}

- (void)viewDidAppear:(BOOL)animated
{
    /**
     * Here's an example of setting min/max dates.
     */
    
    /*
     NSDate *min = [NSDate dateWithDay:1 month:4 year:2014];
     NSDate *max = [NSDate dateWithDay:31 month:12 year:2015];
     
     [[self calendarView] setMaximumDate:max];
     [[self calendarView] setMinimumDate:min];
     */
    
}

-(void)getAppointmentListingData
{
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection]) {
        
        //show indicator on screen
        //[SVProgressHUD showWithStatus:@"Please wait" maskType:SVProgressHUDMaskTypeBlack];
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
        [parameters setValue:AppKey forKey:@"AppKey"];
        [parameters setValue:[AppHelper userDefaultsForKey:uId] forKey:@"UserID"];
        
        //call global web service class
        [Services serviceCallWithPath:ServiceGetAppointmentList withParam:parameters success:^(NSDictionary *responseDict)
         {
             [SVProgressHUD dismiss];//dissmiss indicator
             
             if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
             {
                 if ([[responseDict objectForKey:@"error"] intValue] == 0) {
                     
                     self.dataArray=[responseDict objectForKey:@"result"];
                     
                     NSDictionary *groups = [self groupArrayIntoDictionaryWithArray:self.dataArray withBlock:^id<NSCopying>(NSDictionary *person) {
                         return person[@"bookingDate"];
                     }];
                     
                     for (id key in [groups allKeys]) {
                         NSMutableArray *eventsArray=[NSMutableArray new];
                         NSDate *date;
                         for (int i=0; i<[[groups objectForKey:key] count]; i++) {
                             //  An event for the new MBCalendarKit release.
                             NSString *title = [[[[groups objectForKey:key] objectAtIndex:i] objectForKey:@"organizationId"] valueForKey:@"name"];
                             date = [NSDate
                                        dateWithDay:[[[[[[groups objectForKey:key] objectAtIndex:i] valueForKey:@"bookingDate"] componentsSeparatedByString:@"/"]objectAtIndex:2] intValue]
                                        month:[[[[[[groups objectForKey:key] objectAtIndex:i] valueForKey:@"bookingDate"] componentsSeparatedByString:@"/"]objectAtIndex:1] intValue]
                                        year:[[[[[[groups objectForKey:key] objectAtIndex:i] valueForKey:@"bookingDate"] componentsSeparatedByString:@"/"]objectAtIndex:0] intValue]];
                             
                             CKCalendarEvent *event = [CKCalendarEvent eventWithTitle:title andDate:date andInfo:[[groups objectForKey:key] objectAtIndex:i] andColor:[AppHelper colorFromHexString:[[[[groups objectForKey:key] objectAtIndex:i] objectForKey:@"color"] valueForKey:@"color"] alpha:1.0]];
                             [eventsArray addObject:event];
                         }
                         self.data[date]=eventsArray;
                         [[self calendarView] reload];
                     }
                     
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


#pragma mark - CKCalendarViewDataSource

- (NSArray *)calendarView:(CKCalendarView *)calendarView eventsForDate:(NSDate *)date
{
    return [self data][date];
}

#pragma mark - CKCalendarViewDelegate

// Called before/after the selected date changes
- (void)calendarView:(CKCalendarView *)CalendarView willSelectDate:(NSDate *)date
{
    //[[self calendarView]setHidden:YES];
    //CGRect rect=[self calendarView].bounds;
    //[[self calendarView].table setFrame:rect];
    //[[[self calendarView] table] setFrame:rect animated:YES];
    
}

- (void)calendarView:(CKCalendarView *)CalendarView didSelectDate:(NSDate *)date
{

}

//  A row is selected in the events table. (Use to push a detail view or whatever.)
- (void)calendarView:(CKCalendarView *)CalendarView didSelectEvent:(CKCalendarEvent *)event
{
    

}

-(void)calendarView:(CKCalendarView *)CalendarView didSelectDate:(NSDate *)date withEvents:(NSArray *)events
{
    NSLog(@"Eeee:%@",events);
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        AllAppointmentsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AllAppointmentsVC"];
        vc.arrEvents=events;
        [self.navigationController pushViewController:vc animated:YES];
    }
}



#pragma mark - preferredStatusBarStyle
-(UIStatusBarStyle)preferredStatusBarStyle {
    // to set the color of status bar
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
