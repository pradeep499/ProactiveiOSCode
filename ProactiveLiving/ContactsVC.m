//
//  ContactsVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 16/05/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "ContactsVC.h"
#import "AppHelper.h"
#import "AppDelegate.h"
#import "Defines.h"
#import "ContactsCell.h"
#import <UIImageView+AFNetworking.h>
#import "PASToDoVC.h"
@interface ContactsVC ()
{
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSMutableDictionary *dicAlphabet;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;



@end

@implementation ContactsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.searchBar setReturnKeyType:UIReturnKeyDone];
    [AppHelper setBorderOnView:self.tableView];
   // [self getContactsListing];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getContactsListing];
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    [self filter:text];
}

-(void)getContactsListing
{
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection]) {
        
        //show indicator on screen
        [AppDelegate showProgressHUDWithStatus:@"Please wait.."];
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
        [parameters setValue:AppKey forKey:@"AppKey"];
        [parameters setValue:[AppHelper userDefaultsForKey:uId] forKey:@"UserID"];
        [parameters setObject:@"00000000" forKey:@"mobilePhone"];
        [parameters setObject:self.contactType forKey:@"filter"];

        //call global web service class
        [Services serviceCallWithPath:ServiceGetContacts withParam:parameters success:^(NSDictionary *responseDict)
         {
             [AppDelegate dismissProgressHUD];//dissmiss indicator
             
             if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
             {
                 if ([[responseDict objectForKey:@"error"] intValue] == 0) {
                     
                     //Short coming array of dictionaries on Name key
                     NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
                     NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
                     self.dataArray = [[responseDict objectForKey:@"result"] sortedArrayUsingDescriptors:sortDescriptors];
                     
                     //self.dataArray=[[responseDict objectForKey:@"result"] valueForKey:@"userDetails"];
                     [self breakDataAlphabaticallyWithArray:self.dataArray];
                     [self.tableView reloadData];
                 }
                 else
                 {
                     [AppHelper showAlertWithTitle:[responseDict objectForKey:@"errorMsg"] message:@"" tag:0 delegate:nil cancelButton:ok otherButton:nil];
                     [self.tableView reloadData];

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

-(void)breakDataAlphabaticallyWithArray:(NSArray *)dataArray
{
    // Dictionary will hold our sub-arrays
    self.dicAlphabet = [NSMutableDictionary dictionary];
    
    // Iterate over all the values in our sorted array
    for (NSDictionary *dict in dataArray) {
        
        // Get the first letter and its associated array from the dictionary.
        // If the dictionary does not exist create one and associate it with the letter.
        NSString *firstLetter = [[dict valueForKey:@"firstName"] substringWithRange:NSMakeRange(0, 1)];
        NSMutableArray *arrayForLetter = [self.dicAlphabet objectForKey:firstLetter];
        if (arrayForLetter == nil) {
            arrayForLetter = [NSMutableArray array];
            [self.dicAlphabet setObject:arrayForLetter forKey:firstLetter];
        }
        
        // Add the value to the array for this letter
        [arrayForLetter addObject:dict];
    }
    
    // arraysByLetter will contain the result you expect
    NSLog(@"Dictionary: %@", self.dicAlphabet);
}

-(void)filter:(NSString*)text
{
    if(text.length>0)
    {
    
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"firstName CONTAINS[cd] %@", text];
        NSArray *filteredArray = [self.dataArray filteredArrayUsingPredicate: predicate];
        [self breakDataAlphabaticallyWithArray:filteredArray];

    }
    else
    {
        [self breakDataAlphabaticallyWithArray:self.dataArray];

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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dicAlphabet count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self allShortedKeys:[self.dicAlphabet allKeys]]objectAtIndex:section];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //number of rows in tableview
    return [[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:section]] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"ContactsCell";
    ContactsCell*cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSURL *url = [NSURL URLWithString:[[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] valueForKey:@"profilePic"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"ic_booking_profilepic"];
    
    __weak ContactsCell *weakCell = cell;
    
    [cell.imgPerson setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       
                                       weakCell.imgPerson.image = image;
                                       [weakCell setNeedsLayout];
                                       
                                   } failure:nil];
    
    
    cell.lblName.text=[NSString stringWithFormat:@"%@",[[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] valueForKey:@"firstName"]];
    cell.lblDesc.text=[[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] valueForKey:@"membership"];
        
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[PASToDoVC class]])
    {
        [self.delegate getSelectedPhone:[[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] valueForKey:@"mobilePhone"]];
    }
    else if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId])
    {
        //AppointmentDetailsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AppointmentDetailsVC"];
        //vc.dataDict=[self.dataArray objectAtIndex:indexPath.row];
        //[self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSArray*)allShortedKeys:(NSArray*)allKeys{
    NSArray* arrShortedKeys = [allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return arrShortedKeys;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
