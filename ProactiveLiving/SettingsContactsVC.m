//
//  SettingsContactsVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 31/05/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "SettingsContactsVC.h"
#import "SettingsConCell.h"
#import "CustomUISwitch.h"
#import "Defines.h"
#import "AppHelper.h"

@interface SettingsContactsVC ()
{
    NSMutableArray *arrMenu;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet CustomUISwitch *switchSyncContacts;

@end

@implementation SettingsContactsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.switchSyncContacts setOn:[[AppHelper userDefaultsForKey:SyncStatus] boolValue]];
    [self.switchSyncContacts addTarget:self action:@selector(contactSyncStatusChange:) forControlEvents:UIControlEventValueChanged];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    arrMenu=[[NSMutableArray alloc] initWithObjects:    @{
                                                        
                                                          @"Everyone":@0,
                                                          @"Friends":@0,
                                                          @"Collegues":@0,
                                                          @"Health Club Members":@0,
                                                          @"Males":@1,
                                                          @"Females":@1,
                                                          
                                                          },
                                                        @{
                                                        
                                                          @"Everyone":@0,
                                                          @"Friends":@0,
                                                          @"Collegues":@0,
                                                          @"Health Club Members":@0,
                                                          @"Males":@0,
                                                          @"Females":@0,
                                                          
                                                          }, nil];
}

- (void)contactSyncStatusChange:(id)sender
{
    BOOL state = [sender isOn];
    NSString *syncStatus = state == YES ? @"YES" : @"NO";
    [AppHelper saveToUserDefaults:syncStatus withKey:SyncStatus];
    [self.switchSyncContacts setOn:[[AppHelper userDefaultsForKey:SyncStatus] boolValue]];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SYNCCONTACT_CLICKED object:nil];
}

#pragma mark - uitableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [arrMenu count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *HeaderCellIdentifier = @"SettingsConHeader";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
    UILabel *headerLabel=(UILabel *)[cell.contentView viewWithTag:111];
    switch (section) {
        case 0:
            [headerLabel setText:@"Share My Contact With"];
            break;
        case 1:
            [headerLabel setText:@"Who Can Contact Me"];
            break;
        default:
            break;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 66;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //number of rows in tableview
    switch (section) {
        case 0:
            return [[arrMenu objectAtIndex:section] count];
            break;
        case 1:
            return [[arrMenu objectAtIndex:section] count];
            break;
        default:
            break;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"SettingsConCell";
    SettingsConCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section) {
        case 0:
            cell.lblContactTypes.text=[[[arrMenu objectAtIndex:indexPath.section] allKeys]objectAtIndex:indexPath.row];
            [cell.switchShareContact setOn:[[[[arrMenu objectAtIndex:indexPath.section] allValues]objectAtIndex:indexPath.row] boolValue]];
            cell.switchShareContact.tag=indexPath.row;
            [cell.switchShareContact addTarget:self action:@selector(switchTappedSetionOne:) forControlEvents:UIControlEventValueChanged];
            break;
        case 1:
            cell.lblContactTypes.text=[[[arrMenu objectAtIndex:indexPath.section] allKeys]objectAtIndex:indexPath.row];
            [cell.switchShareContact setOn:[[[[arrMenu objectAtIndex:indexPath.section] allValues]objectAtIndex:indexPath.row] boolValue]];
            cell.switchShareContact.tag=indexPath.row;
            [cell.switchShareContact addTarget:self action:@selector(switchTappedSetionTwo:) forControlEvents:UIControlEventValueChanged];
            break;
        default:
            break;
    }
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)switchTappedSetionOne:(id)event
{
    
}

-(void)switchTappedSetionTwo:(id)event
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
