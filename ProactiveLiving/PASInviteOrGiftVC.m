//
//  PASInviteOrGiftVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 07/06/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "PASInviteOrGiftVC.h"
#import "InviteOrGiftCell.h"
#import "CustomUISwitch.h"
#import "AppHelper.h"
#import "AppDelegate.h"
#import "Defines.h"
#import "AllContactsVC.h"
#import "UIPlaceHolderTextView.h"

@interface PASInviteOrGiftVC ()
{
    NSInteger cellCount;
    NSMutableArray *phoneArray;
}
@property (weak, nonatomic) IBOutlet UIButton *btnInviteOrGift;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet CustomUISwitch *switchIncludePIFV;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *txtViewInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblTopInfo;
@end

@implementation PASInviteOrGiftVC

- (void)viewDidLoad {
    [super viewDidLoad];
    phoneArray = [NSMutableArray arrayWithObject:@""];
    // Do any additional setup after loading the view.
    cellCount=1;
    [AppHelper setBorderOnView:self.txtViewInfo];
    self.txtViewInfo.placeholder=@"Custom Message";
    self.txtViewInfo.placeholderImage=[UIImage imageNamed:@"ic_pasinvite_message"];
    self.txtViewInfo.placeholderColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:170.0/255.0];
    
    //Button title
    if([self.vcType isEqualToString:@"Gift"])
    {
       self.lblTopInfo.text=@"Enter a custom message and add the phone number(s) of those you want to invite to get a PAS";
    }
    else if([self.vcType isEqualToString:@"Invite"])
    {
        self.lblTopInfo.text=@"Enter a custom message and add the phone number(s) of those you want to gift a PAS";
    }
    [_btnInviteOrGift setTitle:self.vcType forState:UIControlStateNormal];
    [AppHelper addShadowOnView:self.btnInviteOrGift withOffset:CGSizeMake(0.0, 1.0) withColor:[UIColor blackColor]];
    [AppHelper setBorderOnView:self.tableView];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

}

#pragma mark - uitableview


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //number of rows in tableview
    return phoneArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"InviteOrGiftCell";
    InviteOrGiftCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.txtPhone.text=phoneArray[indexPath.row];
    cell.btnOpenContacts.tag=indexPath.row;
    [cell.btnOpenContacts addTarget:self action:@selector(openContactsClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)openContactsClick:(UIButton *)sender
{
    NSLog(@"%ld",(long)sender.tag);
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        __block NSInteger selectedIndex = sender.tag;
        AllContactsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AllContactsVC"];
        vc.fromVC=@"InviteOrGift";
        [vc setPhontactBlock:^(NSString *phone) {
            [phoneArray replaceObjectAtIndex:selectedIndex withObject:phone];
            [self.tableView reloadData];
        }];
        //vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)addMoreButtonClick:(id)sender {
    
    [phoneArray addObject:@""];
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (IBAction)btnInviteOrGiftClick:(id)sender
{
    
    NSArray *arrWithNumbersOnly = [phoneArray filteredArrayUsingPredicate:
                               [NSPredicate predicateWithFormat:@"length > 0"]];
    if([arrWithNumbersOnly count]>0)
    {
    
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection]) {
        //AppKey,UserID,senderPhone,recieverPhone,text

        //show indicator on screen
        [AppDelegate showProgressHUDWithStatus:@"Please wait.."];
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
        
        if([self.vcType isEqualToString:@"Invite"])
            [parameters setValue:@"pas_invitation" forKey:@"type"];
        else if([self.vcType isEqualToString:@"Gift"])
            [parameters setValue:@"pas_gift" forKey:@"type"];
        
        [parameters setValue:AppKey forKey:@"AppKey"];
        [parameters setValue:[AppHelper userDefaultsForKey:uId] forKey:@"UserID"];
        [parameters setObject:[AppHelper userDefaultsForKey:cellNum] forKey:@"senderPhone"];
        if(phoneArray.count>0)
            [parameters setValue:[arrWithNumbersOnly componentsJoinedByString:@","] forKey:@"recieverPhone"];
        [parameters setObject:self.txtViewInfo.text forKey:@"text"];
        [parameters setObject:[[NSNumber numberWithBool:[self.switchIncludePIFV isOn]] stringValue] forKey:@"linkVideo"];
        
        //call global web service class
        [Services serviceCallWithPath:ServiceInviteOrGiftPAS withParam:parameters success:^(NSDictionary *responseDict)
         {
             [AppDelegate dismissProgressHUD];//dissmiss indicator
             
             if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
             {
                 if ([[responseDict objectForKey:@"error"] intValue] == 0)
                 {
                     [AppHelper showAlertWithTitle:@"Submitted successfully!" message:@"" tag:0 delegate:nil cancelButton:ok otherButton:nil];
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
    else
        //show internet not available
        [AppHelper showAlertWithTitle:@"Input atleast one phone number!" message:@"" tag:0 delegate:nil cancelButton:ok otherButton:nil];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
