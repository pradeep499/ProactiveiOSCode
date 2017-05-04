//
//  SettingsMainVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 31/05/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "SettingsMainVC.h"
#import "SettingsContactsVC.h"
#import "SettingsOrganizationsVC.h"
#import "AppDelegate.h"
#import "AppHelper.h"
#import "Defines.h"
#import "ProactiveLiving-swift.h"

@interface SettingsMainVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingsMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}


#pragma mark - uitableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //number of rows in tableview
    return 4;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Changed as per client request 3rd May
    
    if (indexPath.row == 0 || indexPath.row == 1)
    {
        return 0 ;
    }
    else {
        return 50;
    }
   

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"SettingsMainCell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *headerLabel=(UILabel *)[cell.contentView viewWithTag:111];
    
    switch (indexPath.row) {
        case 0:
            headerLabel.text=@"Organizations linked";
            break;
        case 1:
            headerLabel.text=@"Contacts";
            break;
        case 2:
            headerLabel.text=@"Change Number";
            break;
        case 3:
            headerLabel.text=@"Delete Account";
            break;
        default:
            break;
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                
                if ([AppDelegate checkInternetConnection]) {
                    
                    //show indicator on screen
                    [AppDelegate showProgressHUDWithStatus:@"Please wait.."];
                    
                    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
                    [parameters setValue:AppKey forKey:@"AppKey"];
                    [parameters setValue:[AppHelper userDefaultsForKey:uId] forKey:@"UserID"];
                    
                    //call global web service class
                    [Services serviceCallWithPath:ServiceUserOrganizationSettings withParam:parameters success:^(NSDictionary *responseDict)
                     {
                         [AppDelegate dismissProgressHUD];//dissmiss indicator
                         
                         if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
                         {
                             if ([[responseDict objectForKey:@"error"] intValue] == 0) {
                                 SettingsOrganizationsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsOrganizationsVC"];
                                 vc.dataDict=[responseDict objectForKey:@"result"];
                                 [self.navigationController pushViewController:vc animated:YES];
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
            break;
        case 1:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                
                if ([AppDelegate checkInternetConnection]) {
                    
                    //show indicator on screen
                    [AppDelegate showProgressHUDWithStatus:@"Please wait.."];
                    
                    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
                    [parameters setValue:AppKey forKey:@"AppKey"];
                    [parameters setValue:[AppHelper userDefaultsForKey:uId] forKey:@"UserID"];
                    
                    //call global web service class
                    [Services serviceCallWithPath:ServiceUserContactSettings withParam:parameters success:^(NSDictionary *responseDict)
                     {
                         [AppDelegate dismissProgressHUD];//dissmiss indicator
                         
                         if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
                         {
                             if ([[responseDict objectForKey:@"error"] intValue] == 0) {
                                 SettingsContactsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsContactsVC"];
                                 vc.dataArray=[responseDict objectForKey:@"result"];
                                 [self.navigationController pushViewController:vc animated:YES];
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
            break;
        case 2:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                
                
                ChangeNumberVC * VC = [[AppHelper getSecondStoryBoard] instantiateViewControllerWithIdentifier:@"ChangeNumberVC"];
                
                [self.navigationController pushViewController:VC animated:YES];
                
            }
            
            break;
        case 3:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                
                DeleteACVC * VC = [[AppHelper getSecondStoryBoard] instantiateViewControllerWithIdentifier:@"DeleteACVC"];
                
                [self.navigationController pushViewController:VC animated:YES];
            }
            
            break;
        default:
            break;
    }
    
}

- (IBAction)btnBackClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
