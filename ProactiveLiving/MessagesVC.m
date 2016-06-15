//
//  MessagesVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 20/05/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "MessagesVC.h"
#import "MessageCell.h"
#import "AppHelper.h"
#import "AppDelegate.h"
#import "Defines.h"
#import "ChatVC.h"
#import <UIImageView+AFNetworking.h>

@interface MessagesVC ()
{
    UIRefreshControl *refreshControl;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *origDataArray;
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation MessagesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Please wait.."]; //to give the attributedTitle
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.searchBar setReturnKeyType:UIReturnKeyDone];
    [self.tableView setBackgroundView:refreshControl];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //show indicator on screen
    [AppDelegate showProgressHUDWithStatus:@"Please wait.."];
    [self getListingsFromServer];
}

- (void)refreshTable {
    //TODO: refresh your data
    if (refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm:ss a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        refreshControl.attributedTitle = attributedTitle;
        
        [refreshControl endRefreshing];
    }
    [self getListingsFromServer];
    [self.tableView reloadData];
}

#pragma mark- service calls
-(void)getListingsFromServer{
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection]) {
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
        [parameters setValue:AppKey forKey:@"AppKey"];
        [parameters setValue:[AppHelper userDefaultsForKey:uId] forKey:@"UserID"];
        [parameters setObject:[AppHelper userDefaultsForKey:cellNum] forKey:@"senderPhone"];
        
        //call global web service class
        [Services serviceCallWithPath:ServiceGetMessageListing withParam:parameters success:^(NSDictionary *responseDict)
         {
             [AppDelegate dismissProgressHUD];//dissmiss indicator
             
             if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
             {
                 if ([[responseDict objectForKey:@"error"] intValue] == 0) {
                     self.origDataArray = [responseDict objectForKey:@"result"];
                     self.dataArray=[self.origDataArray copy];
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

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    [self filter:text];
}

-(void)filter:(NSString*)text
{
    if(text.length>0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"firstName CONTAINS[cd] %@", text];
        self.dataArray = [self.origDataArray filteredArrayUsingPredicate: predicate];
    }
    else
    {
        self.dataArray=[self.origDataArray copy];
    }
    
    [self.tableView reloadData];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}

/*
 Works only if View contains any TextField on it
 - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
 
 [[self view] endEditing:TRUE];
 
 }*/

#pragma mark - uitableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //number of rows in tableview
    return [self.dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"MessageCell";
    MessageCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSURL *url = [NSURL URLWithString:[[self.dataArray objectAtIndex:indexPath.row][@"userDetails"] valueForKey:@"imgUrl"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"ic_booking_profilepic"];
    
    __weak MessageCell *weakCell = cell;
    
    [cell.imgPerson setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       
                                       weakCell.imgPerson.image = image;
                                       [weakCell setNeedsLayout];
                                       
                                   } failure:nil];
    
    cell.lblName.text=[NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:indexPath.row][@"userDetails"] valueForKey:@"firstName"]];
    cell.lblDesc.text=[[self.dataArray objectAtIndex:indexPath.row][@"userDetails"] valueForKey:@"membership"];
    cell.txtMessage.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"text"];
    if([[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"readStatus"] integerValue]==0)
        [cell.txtMessage setFont:[UIFont fontWithName:FONT_REGULAR size:14]];
    else
        [cell.txtMessage setFont:[UIFont fontWithName:FONT_THIN size:14]];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId])
    {
        [self updateReadStatusForMessage:[[self.dataArray objectAtIndex:indexPath.row]valueForKey:@"_id"]];
        ChatVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatVC"];
        vc.partnerDict=[self.dataArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)updateReadStatusForMessage:(NSString *)msgID
{
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection]) {
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
        [parameters setValue:AppKey forKey:@"AppKey"];
        [parameters setValue:[AppHelper userDefaultsForKey:uId] forKey:@"UserID"];
        [parameters setObject:msgID forKey:@"messageId"];
        
        //call global web service class
        [Services serviceCallWithPath:ServiceUpdateReadUnread withParam:parameters success:^(NSDictionary *responseDict)
         {
             
             if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
             {
                 if ([[responseDict objectForKey:@"error"] intValue] == 0) {
                    
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
             [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
         }];
        
    }
    else
        //show internet not available
        [AppHelper showAlertWithTitle:netError message:netErrorMessage tag:0 delegate:nil cancelButton:ok otherButton:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
