//
//  PASShareVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 10/06/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "PASShareVC.h"
#import"PASShareCell.h"
#import "PASShareInstSection.h"
#import "PASShareScoreSection.h"
#import "AppHelper.h"
#import "AppDelegate.h"
#import "Defines.h"
#import "PASSharePopUp.h"

@interface PASShareVC ()
{
    BOOL shouldHide;
    NSArray* notAllZeros;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *orgDataArray;
@property (strong, nonatomic) NSMutableArray *pasDataArray;
@property (strong,nonatomic) PASSharePopUp *modal;



@end

@implementation PASShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
   // [self fetchScoreData];
}

-(void)viewWillAppear:(BOOL)animated{
   
    
    [self fetchScoreData];

    
}


-(void)fetchScoreData
{
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection]) {
        
        //show indicator on screen
        [AppDelegate showProgressHUDWithStatus:@"Please wait.."];
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
        [parameters setValue:AppKey forKey:@"AppKey"];
        [parameters setValue:[AppHelper userDefaultsForKey:uId] forKey:@"UserID"];
        
        //call global web service class
        [Services serviceCallWithPath:ServiceSharePAS withParam:parameters success:^(NSDictionary *responseDict)
         {
             [AppDelegate dismissProgressHUD];//dissmiss indicator
             
             if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
             {
                 if ([[responseDict objectForKey:@"error"] intValue] == 0)
                 {
                     self.pasDataArray=[[[responseDict objectForKey:@"result"] objectForKey:@"pas"] mutableCopy];
                     self.orgDataArray=[[[responseDict objectForKey:@"result"] objectForKey:@"organizations"] mutableCopy];
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

#pragma mark - uitableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *InstSectionIdentifier = @"PASShareInstSection";
    static NSString *ScoreSectionIdentifier = @"PASShareScoreSection";
    PASShareInstSection *headerInstruction = [tableView dequeueReusableCellWithIdentifier:InstSectionIdentifier];
    PASShareScoreSection *headerScore = [tableView dequeueReusableCellWithIdentifier:ScoreSectionIdentifier];

    
    switch (section) {
            
        case 0:
        {
            if (headerInstruction == nil)
                [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
            UILabel *labelInst = (UILabel *)[headerInstruction viewWithTag:111];
            UIButton *btnClose = (UIButton *)[headerInstruction viewWithTag:222];
            [btnClose addTarget:self action:@selector(closeInstructionSection) forControlEvents:UIControlEventTouchUpInside];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            paragraphStyle.alignment = NSTextAlignmentJustified;
            
            NSString *strInst=@"You have created a link with the following entities in Settings. Below you can select what information (PAS/ PAS Level/ PAS Rating) you want to send the entities linked.\n\nPlease note, the latest PAS informtion will be sent with today's date and time. Once sent this can not be undone.";
            
            NSAttributedString *attString = [[NSAttributedString alloc] initWithString:strInst
                                                                            attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                        paragraphStyle, NSParagraphStyleAttributeName ,
                                                                                        [NSNumber numberWithFloat:0],NSBaselineOffsetAttributeName,
                                                                                        nil]];
            
            labelInst.attributedText = attString;

            return headerInstruction;
            break;
        }
        case 1:
        {
            if (headerScore == nil)
                [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
            
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy"];
            NSDate *inputDate=[dateFormatter dateFromString:[[[self.pasDataArray objectAtIndex:0] objectForKey:@"pasId"] valueForKey:@"createDate"]];
            [dateFormatter setDateFormat:@"MMM dd, yyyy"];
            NSString *outputDate=[dateFormatter stringFromDate:inputDate];
            
            headerScore.lblPASValidationDate.text=(outputDate)?[NSString stringWithFormat:@"Most Recent PAS Validation Date: %@",outputDate]:@"";
            headerScore.lblCurrentDate.text=[NSString stringWithFormat:@"Today's Date: %@",[dateFormatter stringFromDate:[NSDate date]]];
            
            headerScore.lblPAScore.text=[[self.pasDataArray objectAtIndex:0] valueForKey:@"pasScore"];
            headerScore.lblPALevel.text=[[[self.pasDataArray objectAtIndex:0] objectForKey:@"pasId"] valueForKey:@"level"];
            headerScore.lblPARating.text=[[[self.pasDataArray objectAtIndex:0] objectForKey:@"pasId"]valueForKey:@"rating"];
            
            return headerScore;
            break;
        }
        default:
            return nil;
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            if(shouldHide)
                return 0;
            else
                return 170.0;
            break;
        case 1:
            return 130.0;
            break;
        default:
            return 0.0;
            break;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //number of rows in tableview
    switch (section) {
            
        case 0:
            return 0;
            break;
        case 1:
            return self.orgDataArray.count;
            break;
        default:
            return 0;
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"PASShareCell";

    switch (indexPath.section) {
            
        case 0:
            return nil;
            break;
        case 1:
        {
            PASShareCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.sideColorView.backgroundColor=[UIColor blueColor];
            cell.lblTitle.font=[UIFont fontWithName:FONT_BOLD size:16];
            
            NSString * orgName=[NSString stringWithFormat:@"%@ (%@)",[[self.orgDataArray objectAtIndex:indexPath.row] objectForKey:@"organizationId"][@"name"],[[self.orgDataArray objectAtIndex:indexPath.row] objectForKey:@"organizationName"]];
            
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc]
                                               initWithString:orgName];
            
            [text addAttribute:NSFontAttributeName
                         value:[UIFont fontWithName:FONT_THIN size:13]
                         range:[orgName rangeOfString:[NSString stringWithFormat:@"(%@)",[[self.orgDataArray objectAtIndex:indexPath.row] objectForKey:@"organizationName"]]]];
            
            if (![text isKindOfClass:[NSNull class]] && text && text != NULL)
                cell.lblTitle.attributedText=text;
            
            [cell.btnClose addTarget:self action:@selector(closeThisCell:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
            break;
        }
        default:
            return nil;
            break;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            break;
        case 1:
            break;
        default:
            break;
    }

    
}

-(void)closeInstructionSection
{
    shouldHide=YES;
    [self.tableView reloadData];
    
}

-(void)closeThisCell:(UIButton *)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];

    [self.orgDataArray removeObjectAtIndex:indexPath.row];
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView endUpdates];
    
}


- (IBAction)btnSendClick:(UIButton *)sender {
    
    sender.enabled=NO;
    [self performSelector:@selector(delayEnable:) withObject:sender afterDelay:0.5];

    NSMutableArray *dataArray=[NSMutableArray array];
    
    for (int count=0; count<self.orgDataArray.count; count++) {
        NSMutableDictionary *dataDict=[NSMutableDictionary dictionary];
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:count inSection:1];
        PASShareCell *cell =[self.tableView cellForRowAtIndexPath:indexPath];
        BOOL pas= cell.checkBoxScore.checked;
        BOOL level= cell.checkBoxLevel.checked;
        BOOL rating= cell.checkBoxRating.checked;
        
        [dataDict setObject:[[self.orgDataArray objectAtIndex:count] objectForKey:@"organizationId"][@"_id"] forKey:@"orgId"];
        
        [dataDict setObject:[NSNumber numberWithBool:pas] forKey:@"pas"];
        [dataDict setObject:[NSNumber numberWithBool:level] forKey:@"level"];
        [dataDict setObject:[NSNumber numberWithBool:rating] forKey:@"rating"];
        
        [dataArray addObject:dataDict];
    }
    
//    NSArray* notAllZeros = [dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%@ IN self.@allValues",[NSNumber numberWithBool:YES] ]];
    
     notAllZeros = [dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%@ IN self.@allValues",[NSNumber numberWithBool:YES] ]];

    
    
    if([notAllZeros count]==0 )
    {
        [AppHelper showAlertWithTitle:@"PAS information not selected!" message:@"Please select PAS information you want to share with an Entity." tag:0 delegate:nil cancelButton:@"Ok" otherButton:nil];
        return;
    }
    
    
    //By me 17 march
    NSMutableArray *finalOrgListArr = [NSMutableArray array];
    
    for(int i =0; i<notAllZeros.count; i++){
        
        NSString * strID = [[notAllZeros objectAtIndex:i] objectForKey:@"orgId"];
        
        for (int j=0; j<self.orgDataArray.count ; j++){
            
            NSString * strOrgId = [[[self.orgDataArray objectAtIndex:j] objectForKey:@"organizationId"] objectForKey:@"_id"];
            
            if (strID == strOrgId) {
                
                
                NSString * orgName =  [[[self.orgDataArray objectAtIndex:j] objectForKey:@"organizationId"] objectForKey:@"name"];
                [finalOrgListArr addObject:orgName];
                
            }
            
            
        }
        
    }
    
       
    self.modal = (PASSharePopUp*)[self.storyboard instantiateViewControllerWithIdentifier:@"PASSharePopUp"];
    
    self.modal.pas=[NSString stringWithFormat:@"PAS %@",[[self.pasDataArray objectAtIndex:0] valueForKey:@"pasScore"]];
    self.modal.level=[NSString stringWithFormat:@"Level %@",[[[self.pasDataArray objectAtIndex:0] objectForKey:@"pasId"] valueForKey:@"level"]];
    self.modal.rating=[[[self.pasDataArray objectAtIndex:0] objectForKey:@"pasId"]valueForKey:@"rating"];
    self.modal.employers= finalOrgListArr; //[[finalOrgListArr valueForKey:@"organizationId"] valueForKey:@"name"];
  
    
    
    if([[AppDelegate getAppDelegate].window.subviews containsObject:self.modal.view])
        [self.modal hidePopUp];
    else
        [self.modal showPopUp];
    
    [self.modal.btnShare addTarget:self action:@selector(btnShareClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)delayEnable:(UIButton *)sender
{
    sender.enabled = YES;
}

-(void)btnShareClick
{
// commentd on 18/04/2017 since not required
    
//    NSMutableArray *dataArray=[NSMutableArray array];
//    for (int count=0; count<self.orgDataArray.count; count++) {
//        NSMutableDictionary *dataDict=[NSMutableDictionary dictionary];
//
//        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:count inSection:1];
//        PASShareCell *cell =[self.tableView cellForRowAtIndexPath:indexPath];
//        BOOL pas= cell.checkBoxScore.checked;
//        BOOL level= cell.checkBoxLevel.checked;
//        BOOL rating= cell.checkBoxRating.checked;
//        
//        [dataDict setObject:[[self.orgDataArray objectAtIndex:count] objectForKey:@"organizationId"][@"_id"] forKey:@"orgId"];
//
//        [dataDict setObject:[NSNumber numberWithBool:pas] forKey:@"pas"];
//        [dataDict setObject:[NSNumber numberWithBool:level] forKey:@"level"];
//        [dataDict setObject:[NSNumber numberWithBool:rating] forKey:@"rating"];
//
//        [dataArray addObject:dataDict];
//    }
//    //NSLog(@"\n PAS Details:%@",dataArray);
    
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection])
    {
        //show indicator on screen
        [AppDelegate showProgressHUDWithStatus:@"Please wait.."];
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
        [parameters setValue:AppKey forKey:@"appkey"];
        [parameters setValue:[AppHelper userDefaultsForKey:uId] forKey:@"UserID"];
        [parameters setObject:notAllZeros forKey:@"organizations"];
        
        [Services postRequest:ServiceSendPAS parameters:parameters completionHandler:^(NSString *status, NSDictionary *responseDict) {
        
            //NSLog(@"Response:%@",responseDict);
            [AppDelegate dismissProgressHUD];//dissmiss indicator
            if([status isEqualToString:@"Success"])
            {
                if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
                {
                    //if ([[responseDict objectForKey:@"error"] intValue] == 0)
                    [self.modal hidePopUp];
                    [AppHelper showAlertWithTitle:[responseDict objectForKey:@"errorMsg"] message:@"" tag:0 delegate:nil cancelButton:ok otherButton:nil];
                }
                else
                [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
            
            }
           else
            [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
         
        }];
    }
    else
        [AppHelper showAlertWithTitle:netError message:netErrorMessage tag:0 delegate:nil cancelButton:ok otherButton:nil];
    
}

/*
 // when you setup your button, set an image for the selected and normal states
 [myCheckBoxButton setImage:nonCheckedImage forState:UIControlStateSelected];
 [myCheckBoxButton setImage:nonCheckedImage forState:UIControlStateNormal];
 
 - (void)myCheckboxToggle:(id)sender
 {
 myCheckboxButton.selected = !myCheckboxButton.selected; // toggle the selected property, just a simple BOOL
 }
 */

- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
