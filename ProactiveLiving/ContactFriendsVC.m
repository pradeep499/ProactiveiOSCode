//
//  ContactFriendsVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 19/05/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "ContactFriendsVC.h"
#import "AppHelper.h"
#import "AppDelegate.h"
#import "Defines.h"
#import "ContactsCell.h"
#import <UIImageView+AFNetworking.h>
#import <AddressBook/AddressBook.h>

@interface ContactFriendsVC ()
{
    UIRefreshControl * refreshControl;
}
@property (nonatomic,strong)NSMutableArray *arrContacts;
@property (strong, nonatomic) NSMutableDictionary *dicAlphabet;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation ContactFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
    [self.searchBar setReturnKeyType:UIReturnKeyDone];
    [AppHelper setBorderOnView:self.tableView];

    self.arrContacts=[NSMutableArray new];
    refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Please Wait..."]; //to give the attributedTitle
    //[refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    //[self.tableView setBackgroundView:refreshControl];
    
    //fetch contacts from device
    [self contactSyncRequired];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contactSyncRequired) name:NOTIFICATION_SYNCCONTACT_CLICKED object:nil];
    
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
    
    [self.tableView reloadData];
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

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    [self filter:text];
}


-(void)contactSyncRequired
{
    if([[AppHelper userDefaultsForKey:SyncStatus] isEqualToString:@"YES"])
        [self getContactsFromDevice];
    else
    {
        [self.dicAlphabet removeAllObjects];
        [self.tableView reloadData];
    }
}

-(void)getContactsFromDevice
{

    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    
    if (status == kABAuthorizationStatusDenied || status == kABAuthorizationStatusRestricted) {
        // if you got here, user had previously denied/revoked permission for your
        // app to access the contacts, and all you can do is handle this gracefully
        
        [[[UIAlertView alloc] initWithTitle:nil message:@"Allow access to your phone contacts. Please visit to \"Privacy\" section in Settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (!addressBook) {
        NSLog(@"ABAddressBookCreateWithOptions error: %@", CFBridgingRelease(error));
        return;
    }
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (error) {
            NSLog(@"ABAddressBookRequestAccessWithCompletion error: %@", CFBridgingRelease(error));
        }
        
        if (granted) {
            // if they gave you permission, then just carry on
            
            [self listPeopleInAddressBook:addressBook];
        } else {
            // however, if they didn't give you permission, handle it gracefully, for example...
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // BTW, this is not on the main thread, so dispatch UI updates back to the main queue
                
                [[[UIAlertView alloc] initWithTitle:nil message:@"Allow access to your phone contacts. Please visit to \"Privacy\" section in Settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            });
        }
        
        CFRelease(addressBook);
        //[[NSNotificationCenter defaultCenter] removeObserver:NOTIFICATION_SYNCCONTACT_CLICKED];
    });
}

- (void)listPeopleInAddressBook:(ABAddressBookRef)addressBook
{
    NSArray *allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    NSInteger numberOfPeople = [allPeople count];
    
    for (NSInteger i = 0; i < numberOfPeople; i++) {
        ABRecordRef person = (__bridge ABRecordRef)allPeople[i];
        
        NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName  = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSLog(@"Name:%@ %@", (firstName)? firstName : @"", (lastName)? lastName : @"");
        
        NSString *fullName = @"";
        
        if (firstName != nil)
        {
            fullName = [fullName stringByAppendingString:firstName];
        }
        if (lastName != nil)
        {
            fullName = [fullName stringByAppendingString:@" "];
            fullName = [fullName stringByAppendingString:lastName];
        }
        
        UIImage *profileImage;
        if (ABPersonHasImageData(person))
            profileImage = [UIImage imageWithData:CFBridgingRelease(ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail))];
        else
            profileImage = [UIImage imageNamed:@"ic_booking_profilepic"];
        
        
        
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        CFIndex numberOfPhoneNumbers = ABMultiValueGetCount(phoneNumbers);
        
        NSMutableArray *numbers = [NSMutableArray array];
        
        for (CFIndex i = 0; i < numberOfPhoneNumbers; i++) {
            NSString *phoneNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, i));
            NSLog(@"  phone:%@", phoneNumber);
            [numbers addObject:phoneNumber];
        }
        CFRelease(phoneNumbers);
        
        NSMutableDictionary *contact = [NSMutableDictionary dictionary];
        [contact setObject:(firstName)? fullName : @"Unknown" forKey:@"name"];
        [contact setObject:numbers forKey:@"numbers"];
        [contact setObject:profileImage forKey:@"image"];
        
        [self.arrContacts addObject:contact];
        
        NSLog(@"=============================================");
    }
    
    //Short array before make up
    NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
    [self breakDataAlphabaticallyWithArray:[self.arrContacts sortedArrayUsingDescriptors:sortDescriptors]];
    dispatch_async(dispatch_get_main_queue(),^(void){[self.tableView reloadData];});

}

-(void)filter:(NSString*)text
{
    if(text.length>0)
    {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"name CONTAINS[cd] %@", text];
        NSArray *filteredArray = [self.arrContacts filteredArrayUsingPredicate: predicate];
        [self breakDataAlphabaticallyWithArray:filteredArray];
        
    }
    else
    {
        [self breakDataAlphabaticallyWithArray:self.arrContacts];
        
    }
    [self.tableView reloadData];
    
}

-(void)breakDataAlphabaticallyWithArray:(NSArray *)dataArray
{
    // Dictionary will hold our sub-arrays
    self.dicAlphabet = [NSMutableDictionary dictionary];
    
    // Iterate over all the values in our sorted array
    for (NSDictionary *dict in dataArray) {
        
        // Get the first letter and its associated array from the dictionary.
        // If the dictionary does not exist create one and associate it with the letter.
        NSString *firstLetter = [[dict valueForKey:@"name"] substringWithRange:NSMakeRange(0, 1)];
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



#pragma mark - tableview delegates
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
    
    cell.imgPerson.layer.cornerRadius = cell.imgPerson.frame.size.width / 2;
    cell.imgPerson.clipsToBounds = YES;
    UIImage *image=[[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"image"];
    [cell.imgPerson setImage:image];
    
    cell.lblName.text=[[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    if([[[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] valueForKey:@"numbers"] count]>0)
    cell.lblDesc.text=[[[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] valueForKey:@"numbers"] objectAtIndex:0];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSLog(@"Data: %@",[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]);
    
    if([self.delegate respondsToSelector:@selector(getSelectedPhone:)])
     [self.delegate getSelectedPhone:[[[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] valueForKey:@"numbers"] objectAtIndex:0]];
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        //AppointmentDetailsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AppointmentDetailsVC"];
        //vc.dataDict=[self.dataArray objectAtIndex:indexPath.row];
        //[self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSArray*)allShortedKeys:(NSArray*)allKeys{
    NSArray* arrShortedKeys = [allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return arrShortedKeys;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
