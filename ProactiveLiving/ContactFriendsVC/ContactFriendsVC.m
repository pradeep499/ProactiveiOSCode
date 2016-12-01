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
#import "ProactiveLiving-Swift.h"
#import "MyPAStodoVC.h"

@interface ContactFriendsVC ()
{
    UIRefreshControl * refreshControl;
}
@property (nonatomic,strong)NSMutableArray *arrContacts;
@property (strong, nonatomic) NSMutableDictionary *dicAlphabet;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,retain) NSMutableArray *selectedRowsArray;
@property (weak, nonatomic) IBOutlet UIButton *imgGroup;
@property (weak, nonatomic) IBOutlet UITextField *txtTitleGroup;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalSelected;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrHeightGroupView;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCreateGroup:) name:NOTIFICATION_SHOW_GROUP_VIEW_CLICKED object:nil];
    self.selectedRowsArray=[NSMutableArray new];
    self.constrHeightGroupView.constant=0;
    self.lblTotalSelected.text=[NSString stringWithFormat:@"%@ selected",@0];
    
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

-(void)showCreateGroup:(id)info
{
    
    if(self.constrHeightGroupView.constant!=0)
    {
        self.constrHeightGroupView.constant=0;
        
    }
    else
    {
        self.constrHeightGroupView.constant=60;
        
    }
    
    [self.tableView reloadData];
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
        
        if([numbers count]== 0) { [numbers addObject:@"No Number"]; }
        if([fullName  isEqual: @""]) { fullName = @"Unknown"; }
        
        NSMutableDictionary *contact = [NSMutableDictionary dictionary];
        [contact setObject: fullName forKey:@"name"];
        [contact setObject: numbers forKey:@"numbers"];
        [contact setObject: profileImage forKey:@"image"];
        
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
    
    if(self.constrHeightGroupView.constant == 0)
    {
        if([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[MyPAStodoVC class]])
        {
            if([self.delegate respondsToSelector:@selector(getSelectedPhone:)])
                [self.delegate getSelectedPhone:[[[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] valueForKey:@"numbers"] objectAtIndex:0]];
                //[self.delegate getSelectedPhone:[[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] valueForKey:@"mobilePhone"]];
        }
        /* else if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId])
        {
            
            NSDictionary *frndDict=[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            NSLog(@"%@",frndDict);
            
            NSString * login_id = [AppHelper userDefaultsForKey:uId];
            NSString *predicate = [NSString stringWithFormat:@"loginUserId contains[cd] %@ AND friendId contains[cd] %@",login_id, [frndDict objectForKey:@"_id"]];
            DataBaseController *dbInstance = [DataBaseController sharedInstance];
            //RecentChatList * recentObj = [dbInstance fetchDataRecentChatObject:@"RecentChatList" predicate:predicate];
            
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            ChattingMainVC *chatMainVC = [storyboard instantiateViewControllerWithIdentifier:@"ChattingMainVC"];
            
            ChatContactModelClass *anobject = [[ChatContactModelClass alloc] init];
            anobject.userId =[frndDict  valueForKey:@"_id"];
            anobject.loginUserId =[AppHelper userDefaultsForKey:_ID];
            anobject.name =  [frndDict valueForKey:@"firstName"];
            anobject.email = @"etrfgg";
            anobject.isBlock = @"0";
            anobject.isReport = @"0";
            anobject.isFav = @"no";
            anobject.isFriend = @"yes";
            anobject.userImgString = [frndDict valueForKey:@"imgUrl"];
            anobject.isFromCont = @"yes";
            anobject.phoneNumber = [frndDict valueForKey:@"mobilePhone"];
            
            chatMainVC.contObj=anobject;
            chatMainVC.isFromClass = @"chatd";
            chatMainVC.isGroup = @"0";
            chatMainVC.isFromDeatilScreen = @"0";
            //chatMainVC.recentChatObj = recentObj;
            chatMainVC.recentChatObj = nil;
            
            [self.navigationController pushViewController:chatMainVC animated:YES];
        }*/
    }
 /*   else
    {
        if (indexPath != nil)
        {
            if ([self.selectedRowsArray containsObject:[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]])
            {
                [self.selectedRowsArray removeObject:[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]];
            }
            else
            {
                [self.selectedRowsArray addObject:[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]];
            }
            [self.tableView reloadData];
        }
        
        self.lblTotalSelected.text=[NSString stringWithFormat:@"%d selected",(int)[self.selectedRowsArray count]];
        
        
    } */

}


-(void)createGroupWithContacts
{
    
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection]) {
        
        if ([self.txtTitleGroup.text length]==0)
        {
            [self.txtTitleGroup becomeFirstResponder];
            [AppHelper showAlertWithTitle:AppName message:@"Group name is empty!" tag:0 delegate:nil cancelButton:ok otherButton:nil];
            return;
        }
        
        if ([self.selectedRowsArray count]==0)
        {
            [self.txtTitleGroup resignFirstResponder];
            [AppHelper showAlertWithTitle:AppName message:@"Please select atleast one group member!" tag:0 delegate:nil cancelButton:ok otherButton:nil];
            return;
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary new];
        dict[@"userid"]=[AppHelper userDefaultsForKey:_ID];
        dict[@"groupname"]=self.txtTitleGroup.text;
        
        NSMutableArray *userIdArray = [NSMutableArray new];
        
        
        for (id myobject in self.selectedRowsArray)
        {
            NSDictionary *anObject=myobject;
            NSMutableDictionary *tempDict = [NSMutableDictionary new];
            tempDict[@"userid"]=[anObject valueForKey:@"_id"];
            tempDict[@"phoneNumber"]=[anObject valueForKey:@"mobilePhone"];
            
            [userIdArray addObject:tempDict];
        }
        
        NSMutableDictionary *tempDict = [NSMutableDictionary new];
        tempDict[@"userid"]=[ChatHelper userDefaultForKey:_ID];
        tempDict[@"phoneNumber"]=[AppHelper userDefaultsForKey:cellNum];
        
        [userIdArray addObject:tempDict];
        dict[@"users"] = userIdArray;
        
        UIImageView *groupImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
        groupImage.image=[UIImage imageNamed:@"logo"];
        
        dict[@"imgUrl"] = @"";
        
        [[[ChatListner getChatListnerObj] socket] emit:@"createGroup" withItems:[NSArray arrayWithObject:dict]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        });
        
    }
    else
    {
        [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
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
