//
//  ValidationFiltersVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 03/02/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "ValidationFiltersVC.h"
#import "YSLContainerViewController.h"
#import "AppHelper.h"
#import "AppDelegate.h"
#import "Defines.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "Services.h"
#import "FilterVC1.h"
#import "FilterVC2.h"
#import "FilterVC3.h"
#import "FilterVC4.h"

@interface ValidationFiltersVC ()<YSLContainerViewControllerDelegate>
{
    NSMutableArray *arrServices;
    NSMutableArray *arrTypes;
    FilterVC1 *filterVC1;
    FilterVC2 *filterVC2;
    FilterVC3 *filterVC3;
    FilterVC4 *filterVC4;
}
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation ValidationFiltersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lblTitle.text=self.screenTitle;
    [self prepareDataForFilter];
        
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

-(void)setUpViewControllers
{
    // SetUp ViewControllers
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    filterVC1 = [storyboard instantiateViewControllerWithIdentifier:@"FilterVC1"];
    filterVC1.title = @"SERVICES";
    filterVC1.dataArray=arrServices;
    
    
    filterVC2 = [storyboard instantiateViewControllerWithIdentifier:@"FilterVC2"];
    filterVC2.title = @"AVAILABILITY";
    
    filterVC3 = [storyboard instantiateViewControllerWithIdentifier:@"FilterVC3"];
    filterVC3.title = @"LOCATION";
    
    filterVC4 = [storyboard instantiateViewControllerWithIdentifier:@"FilterVC4"];
    filterVC4.title = @"TYPES";
    filterVC4.dataArray=arrTypes;
    
    // ContainerView
    //float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    //float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:@[filterVC4,filterVC1,filterVC2,filterVC3]
                                                                                        topBarHeight:0
                                                                                parentViewController:self];
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:@"Roboto-Regular" size:13];
    containerVC.menuItemSelectedFont = [UIFont fontWithName:@"Roboto-Bold" size:14];
    containerVC.menuBackGroudColor=[UIColor colorWithRed:1.0/255 green:174.0/255 blue:240.0/255 alpha:1.0];
    containerVC.menuItemTitleColor=[UIColor whiteColor];
    containerVC.menuItemSelectedTitleColor=[UIColor whiteColor];
    containerVC.view.frame=CGRectMake(0, 64, containerVC.view.frame.size.width, containerVC.view.frame.size.height-64);
    
    [self.view addSubview:containerVC.view];
}

-(void)prepareDataForFilter
{
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection]) {
        //show indicator on screen
        [SVProgressHUD showWithStatus:@"Please wait" maskType:SVProgressHUDMaskTypeBlack];
        
        //create dictionary for parameters of web service
        NSDictionary *parameters = @{
                                     @"AppKey" : AppKey,
                                     @"UserID" : [AppHelper userDefaultsForKey:uId]
                                     };
        
        //call global web service class
        [Services serviceCallWithPath:ServiceGetCodelist withParam:parameters success:^(NSDictionary *responseDict)
         {
             [SVProgressHUD dismiss];//dissmiss indicator
             
             if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
             {
                 if ([[responseDict objectForKey:@"error"] intValue] == 0) {
                     // services
                     arrServices = [responseDict valueForKey:@"services"];//set dictionary
                     //types
                     arrTypes = [responseDict valueForKey:@"types"];//set dictionary
                     
                     // SetUp ViewControllers
                     [self setUpViewControllers];
                 }
                 else
                 {
                     [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
                     
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
#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
        NSLog(@"current Index : %ld",(long)index);
        NSLog(@"current controller : %@",controller);
    [controller viewWillAppear:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self setupPageControl];

}


- (IBAction)btnBackClick:(id)sender {
    //back to previous view controller
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnDoneClick:(id)sender {
    //DO FILTER RELATED TASKS
    
    //[AppHelper saveToUserDefaults:filterVC1.selectedRowsArray withKey:@"arrServices"];
    //[AppHelper saveToUserDefaults:filterVC3.selectedRowsArray withKey:@"arrLocations"];
    //[AppHelper saveToUserDefaults:filterVC4.selectedRowsArray withKey:@"arrTypes"];

    NSMutableDictionary *aDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 filterVC1.selectedRowsArray, @"arrServices",
                                 filterVC3.selectedRowsArray, @"arrLocations",
                                 filterVC4.selectedRowsArray, @"arrTypes",
                                 nil];
    
    
    //If availability selecetd
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:filterVC2.selectedDate];
    NSDateComponents *timeComponents = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:filterVC2.selectedTime];
    
    if(dateComponents || timeComponents)
    {
    NSDateComponents *newComponents = [[NSDateComponents alloc]init];
    newComponents.timeZone = [NSTimeZone systemTimeZone];
    
    if(dateComponents)
    {
        [newComponents setDay:[dateComponents day]];
        [newComponents setMonth:[dateComponents month]];
        [newComponents setYear:[dateComponents year]];
    }
    else
    {
        [newComponents setDay:0];
        [newComponents setMonth:0];
        [newComponents setYear:0];
    }
    
    if(timeComponents)
    {
        [newComponents setHour:[timeComponents hour]];
        [newComponents setMinute:[timeComponents minute]];
    }
    else
    {
        [newComponents setHour:0];
        [newComponents setMinute:0];
    }
        NSDate *combDate = [calendar dateFromComponents:newComponents];
        [aDictionary setObject:[self getUTCFormateDate:combDate] forKey:@"strTimeStamp"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VALIDATION_CENTER_FLTER object:nil userInfo:aDictionary];
    
    [self.navigationController popViewControllerAnimated:YES];


}

-(NSString *)getUTCFormateDate:(NSDate *)Date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:Date];
    return dateString;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
