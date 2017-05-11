//
//  SettingsOrganizationsVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 31/05/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "SettingsOrganizationsVC.h"
#import "SettingsOrgCell.h"
#import "Defines.h"
#import "AppDelegate.h"
#import "AppHelper.h"

@interface SettingsOrganizationsVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *txtOrgID;
@property (weak, nonatomic) IBOutlet UIButton *btnApplyCode;

@end

@implementation SettingsOrganizationsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [AppHelper setBorderOnView:self.txtOrgID];
    [AppHelper addShadowOnView:self.btnApplyCode withOffset:CGSizeMake(0.0, 1.0) withColor:[UIColor blackColor]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

#pragma mark - uitableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataDict count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *HeaderCellIdentifier = @"SettingsOrgHeader";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
    UILabel *headerLabel=(UILabel *)[cell.contentView viewWithTag:111];
    switch (section) {
        case 0:
            [headerLabel setText:@"Health Clubs"];
            break;
        case 1:
            [headerLabel setText:@"Workplace"];
            break;
        default:
            [headerLabel setText:@"Other"];
            break;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //number of rows in tableview
    return [[self.dataDict objectAtIndex:section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"SettingsOrgCell";
    SettingsOrgCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString * orgName=[[[self.dataDict objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"organizationId"][@"name"];
    if(![[[[self.dataDict objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"organizationStatus"] boolValue])
    {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]
                                           initWithString:[NSString stringWithFormat:@"%@ (Pending)",orgName]];
        
        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor grayColor]
                     range:[[NSString stringWithFormat:@"%@ (Pending)",orgName]rangeOfString:@"(Pending)"]];
        
        [text addAttribute:NSFontAttributeName
                     value:[UIFont fontWithName:FONT_THIN size:14]
                     range:[[NSString stringWithFormat:@"%@ (Pending)",orgName]rangeOfString:@"(Pending)"]];
        
        cell.lblOrganization.attributedText=text;
    }
    else
    {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]
                                           initWithString:[NSString stringWithFormat:@"%@ (Linked)",orgName]];
        
        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor grayColor]
                     range:[[NSString stringWithFormat:@"%@ (Linked)",orgName]rangeOfString:@"(Linked)"]];
        
        [text addAttribute:NSFontAttributeName
                     value:[UIFont fontWithName:FONT_THIN size:14]
                     range:[[NSString stringWithFormat:@"%@ (Linked)",orgName]rangeOfString:@"(Linked)"]];
        
        cell.lblOrganization.attributedText=text;
    }

    cell.lblUID.text=[NSString stringWithFormat:@"Unique ID: %@",[[[self.dataDict objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"uniqueId"]];
    cell.lblType.text=[[[self.dataDict objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"organizationName"];
    [cell.orgSwitch setOn:[[[[self.dataDict objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"userStatus"] boolValue]];
    cell.orgSwitch.tag=indexPath.row;
    [cell.orgSwitch addTarget:self action:@selector(updateOrgSettings:) forControlEvents:UIControlEventValueChanged];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.view endEditing:YES];
}

-(void)updateOrgSettings:(UISwitch *)sender
{
    CGPoint switchPosition = [sender convertPoint:CGPointZero
                                           toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:switchPosition];
    //organizationId
    //userStatus
    
    if ([AppDelegate checkInternetConnection]) {
        
        //show indicator on screen
        [AppDelegate showProgressHUDWithStatus:@"Please wait.."];
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
        [parameters setValue:AppKey forKey:@"AppKey"];
        [parameters setValue:[AppHelper userDefaultsForKey:uId] forKey:@"UserID"];
        [parameters setValue:[[[self.dataDict objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"organizationId"][@"_id"] forKey:@"organizationId"];
        [parameters setValue:[[NSNumber numberWithBool:[sender isOn]] stringValue] forKey:@"userStatus"];

        //call global web service class
        [Services serviceCallWithPath:ServiceUpdateOrgSettings withParam:parameters success:^(NSDictionary *responseDict)
         {
             [AppDelegate dismissProgressHUD];//dissmiss indicator
             
             if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
             {
                 if ([[responseDict objectForKey:@"error"] intValue] == 0) {
                     
                     //self.dataDict=[responseDict objectForKey:@"result"];
                     //[self.tableView reloadData];
                 }
                 else
                 {
                     [AppHelper showAlertWithTitle:[responseDict objectForKey:@"errorMsg"] message:@"" tag:0 delegate:nil cancelButton:ok otherButton:nil];
                 }
                 
             }
             else
                 [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
             
         } failure:^(NSError *error)
         {
             [AppDelegate dismissProgressHUD];//dissmiss indicator
             [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
         }];
        
    }
    else
        //show internet not available
        [AppHelper showAlertWithTitle:netError message:netErrorMessage tag:0 delegate:nil cancelButton:ok otherButton:nil];
}

-(void)applyOrganizationCode:(NSString *)orgID
{
    if ([AppDelegate checkInternetConnection]) {
        
        //show indicator on screen
        [AppDelegate showProgressHUDWithStatus:@"Please wait.."];
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
        [parameters setValue:AppKey forKey:@"AppKey"];
        [parameters setValue:[AppHelper userDefaultsForKey:uId] forKey:@"UserID"];
        [parameters setValue:orgID forKey:@"UniqueID"];
        //call global web service class
        [Services serviceCallWithPath:ServiceApplyOrgID withParam:parameters success:^(NSDictionary *responseDict)
         {
             [AppDelegate dismissProgressHUD];//dissmiss indicator
             
             if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
             {
                 if ([[responseDict objectForKey:@"error"] intValue] == 0) {
                     
                     [self.view endEditing:YES];
                     self.dataDict=[responseDict objectForKey:@"result"];
                     [self.tableView reloadData];
                 }
                 else
                 {
                     [AppHelper showAlertWithTitle:[responseDict objectForKey:@"errorMsg"] message:@"" tag:0 delegate:nil cancelButton:ok otherButton:nil];
                 }
                 
             }
             else
                 [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
             
         } failure:^(NSError *error)
         {
             [AppDelegate dismissProgressHUD];//dissmiss indicator
             [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
         }];
        
    }
    else
        //show internet not available
        [AppHelper showAlertWithTitle:netError message:netErrorMessage tag:0 delegate:nil cancelButton:ok otherButton:nil];
}
- (IBAction)btnApplyClick:(id)sender {
    if([self.txtOrgID.text length]>0)
        [self applyOrganizationCode:self.txtOrgID.text];
    else
        [AppHelper showAlertWithTitle:AppName message:@"Please input Organization ID" tag:0 delegate:nil cancelButton:ok otherButton:nil];
 
}

- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
