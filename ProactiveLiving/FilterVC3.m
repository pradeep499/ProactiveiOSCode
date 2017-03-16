//
//  FilterVC3.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 04/02/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "FilterVC3.h"
#import "FilterThreeCell.h"
#import "AppHelper.h"
#import "AppDelegate.h"
#import "Defines.h"
#import "Services.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <CoreLocation/CoreLocation.h>

@interface FilterVC3 ()<UISearchBarDelegate>
{
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy) NSArray *dataArray;
- (IBAction)switchChanged:(id)sender;

@end

@implementation FilterVC3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.selectedRowsArray=[NSMutableArray arrayWithArray:[AppHelper userDefaultsForKey:@"arrLocations"]];
    self.selectedRowsArray=[[NSMutableArray alloc]init];
    [self.searchBar setReturnKeyType:UIReturnKeyDone];
    self.searchBar.delegate=self;
    self.searchBar.placeholder = @"Zip Code";
    self.searchBar.keyboardType = UIKeyboardTypeNumberPad;

    //[self.switch1 setOn:![[AppHelper userDefaultsForKey:GPSStatus] boolValue]];
    //[self.switch2 setOn:NO];
    //[self.switch3 setOn:[[AppHelper userDefaultsForKey:GPSStatus] boolValue]];
    [self.switch1 setOn:YES];
    [self.searchBar setUserInteractionEnabled:NO];
    
    [AppHelper setBorderOnView:self.tableView];
}

-(void)prepareDataForFilterWithPostalCode:(NSString*)postalCode
{
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection]) {
        
        //show indicator on screen
        [SVProgressHUD showWithStatus:@"Please wait" maskType:SVProgressHUDMaskTypeBlack];
        
        //create dictionary for parameters of web service
        NSDictionary *parameters = @{
                                     @"AppKey" : AppKey,
                                     @"UserID" : [AppHelper userDefaultsForKey:uId],
                                     @"location":postalCode,
                                     @"latitude":[NSString stringWithFormat:@"%f",[AppDelegate getAppDelegate].currentLocation.coordinate.latitude],
                                     @"longitude":[NSString stringWithFormat:@"%f",[AppDelegate getAppDelegate].currentLocation.coordinate.longitude]
                                     };
        
        //call global web service class
        [Services serviceCallWithPath:ServiceLocationFilter withParam:parameters success:^(NSDictionary *responseDict)
         {
             [SVProgressHUD dismiss];//dissmiss indicator
             
             if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
             {
                 if ([[responseDict objectForKey:@"error"] intValue] == 0)
                 {
                     // addresses
                     self.dataArray = [responseDict valueForKey:@"result"];//set dictionary
                     [self.tableView reloadData];

                 }
                 else
                     [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
             }
             else
                 [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
             
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *kCustomCellID = @"FilterThreeCell";
    FilterThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
    if (cell == nil)
        cell = [[FilterThreeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSString *loaction=[NSString stringWithFormat:@"%@, %@",[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"city"],[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"postalCode"]];
    
   // NSString *distance=[NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"distance"]];
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:[[[self.dataArray objectAtIndex:indexPath.row][@"location"]objectAtIndex:1]floatValue] longitude:[[[self.dataArray objectAtIndex:indexPath.row][@"location"]objectAtIndex:0]floatValue]];
    CLLocation *locB = [AppDelegate getAppDelegate].currentLocation;
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    NSString *distInMiles=[NSString stringWithFormat:@"%.1f miles away",(distance/1609.344)];

    cell.lblTitle.text = loaction;
    cell.lblDistance.text=distInMiles;
    
    if ([self.selectedRowsArray containsObject:[self.dataArray objectAtIndex:indexPath.row]])
    {
        [cell.btnBox setImage:[UIImage imageNamed:@"ic_filterservice_check.png"] forState:UIControlStateNormal];
    }
    else {
        [cell.btnBox setImage:[UIImage imageNamed:@"ic_filterservice_uncheck.png"] forState:UIControlStateNormal];
    }
    
    
    [cell.btnBox setTag:indexPath.row];
    [cell.btnBox addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark- Searchbar delegates
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.selectedRowsArray removeAllObjects];
    NSDictionary *dict=@{ @"location" : searchText };
    [self.selectedRowsArray addObject:dict];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //[self prepareDataForFilterWithPostalCode:searchBar.text];
    [self.searchBar resignFirstResponder];
}

- (void)checkButtonTapped:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    
    if (indexPath != nil)
    {
        if ([self.selectedRowsArray containsObject:[self.dataArray objectAtIndex:indexPath.row]]) {
            [self.selectedRowsArray removeObject:[self.dataArray objectAtIndex:indexPath.row]];
        }
        else
        {
            [self.selectedRowsArray addObject:[self.dataArray objectAtIndex:indexPath.row]];
        }
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationNone];
        
    }
}

#pragma mark - tap- hide keyboard
- (IBAction)tapRecognizerOnView:(id)sender {
    [self.view endEditing:YES];
}


- (IBAction)switchChanged:(UISwitch*)sender {
    
    if (sender.tag==111) {
        [self.switch2 setOn:NO animated:YES];
        [self.switch3 setOn:!sender.isOn animated:YES];
    }
    if (sender.tag==222) {
        [self.switch1 setOn:!sender.isOn animated:YES];
        [self.switch3 setOn:NO animated:YES];
    }
    if (sender.tag==333) {
        [self.switch1 setOn:!sender.isOn animated:YES];
        [self.switch2 setOn:NO animated:YES];
    }
    
    if(self.switch2.isOn) {
        [self.searchBar becomeFirstResponder];
    }
    else
        [self.searchBar resignFirstResponder];

    [self.searchBar setUserInteractionEnabled:self.switch2.isOn];

    //Capture state of main GPS related switch
    [AppHelper saveToUserDefaults:[NSString stringWithFormat:@"%i",!self.switch1.isOn] withKey:GPSStatus];

    NSLog(@"GPS-%@",[AppHelper userDefaultsForKey:GPSStatus]);

}
@end
