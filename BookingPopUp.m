//
//  BookingPopUp.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 23/03/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "BookingPopUp.h"
#import "BookTableCell.h"
#import "Defines.h"
#import "AppHelper.h"

@interface BookingPopUp ()
{
    NSMutableArray *timingsData;
    
}
- (IBAction)btnCancelClick:(id)sender;
- (IBAction)btnBookingClick:(id)sender;
- (IBAction)loadAllTimings:(id)sender;

@end

@implementation BookingPopUp

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedRowsArray=[NSMutableArray new];
    // Do any additional setup after loading the view.

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"MMM"];
    //NSDate *mmonth=[formatter dateFromString:self.strBookingDate];
    
    NSArray *dateComponents = [self.strBookingDate componentsSeparatedByString:@"/"];
    NSString *year = [dateComponents firstObject];
    NSString *day = [dateComponents lastObject];
    NSString *month = [dateComponents objectAtIndex:1];

    
    timingsData = [[self.arrTimings subarrayWithRange:NSMakeRange(0, 3)]mutableCopy];
    self.lblDateTime.text=[NSString stringWithFormat:@"%@ %@ %@ %@",[AppHelper dayFromDateString:self.strBookingDate],day,month,year];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [timingsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCustomCellID = @"BookTableCell";
    BookTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
    if (cell == nil)
        cell = [[BookTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.lblTime.text=[NSString stringWithFormat:@"%@",[self timeFormatted:[[timingsData objectAtIndex:indexPath.row] intValue]]];
    
    if ([self.selectedRowsArray containsObject:[timingsData objectAtIndex:indexPath.row]])
    {
        [cell.imgCellSelection setImage:[UIImage imageNamed:@"ic_filterservice_radioselect.png"]];
    }
    else {
        [cell.imgCellSelection setImage:[UIImage imageNamed:@"ic_filterservice_radio.png"]];
    }
    [cell.imgCellSelection setTag:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //UIImageView *imgCellSelection = (UIImageView *)[cell viewWithTag:123123];
    
    if (indexPath != nil)
    {
        for (id element in timingsData) {
            if ([self.selectedRowsArray containsObject:element])
                [self.selectedRowsArray removeObject:element];
        }
        [self.selectedRowsArray addObject:[timingsData objectAtIndex:indexPath.row]];
        [self.tableView reloadData];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCancelClick:(id)sender {
   
    [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (IBAction)btnBookingClick:(id)sender {
   /*
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 568, 320, 284);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
    */
}

- (IBAction)loadAllTimings:(id)sender {
    [self.btnSeeAll setHidden:YES];
    [timingsData removeAllObjects];
    timingsData=[self.arrTimings mutableCopy];
    [self.tableView reloadData];
    
}
@end
