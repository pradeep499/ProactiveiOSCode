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
#import "MyPAStodoVC.h"
#import "InboxVC.h"
#import "ProactiveLiving-Swift.h"

@interface ContactsVC ()
{
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSMutableDictionary *dicAlphabet;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrHeightGroupView;
@property (nonatomic,retain) NSMutableArray *selectedRowsArray;
@property (weak, nonatomic) IBOutlet UIButton *imgGroup;
@property (weak, nonatomic) IBOutlet UITextField *txtTitleGroup;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalSelected;

@end

@implementation ContactsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.searchBar setReturnKeyType:UIReturnKeyDone];
    [AppHelper setBorderOnView:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCreateGroup:) name:NOTIFICATION_SHOW_GROUP_VIEW_CLICKED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(POP_CONTCT_VC) name:@"POP_CONTCT_VC" object:nil];
    
    
    self.selectedRowsArray=[NSMutableArray new];
    self.constrHeightGroupView.constant=0;
    self.lblTotalSelected.text=[NSString stringWithFormat:@"(%@ Selected)",@0];
   // [self getContactsListing];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getContactsListing];
}

-(void)showCreateGroup:(id)info
{
    NSLog(@"Create Group Clicked..");
    if ([self.delegate2 respondsToSelector:@selector(someAction)]) {
        [self.delegate2 someAction];
    }
    
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

-(void)POP_CONTCT_VC{
    
    if ([[[[self navigationController]viewControllers] objectAtIndex:([[[self navigationController]viewControllers]count]-2)] isKindOfClass:[CreateMeetUpVC class]]   ) {
        
        CreateMeetUpVC *previousVC = [[[self navigationController]viewControllers] objectAtIndex:([[[self navigationController]viewControllers]count]-2)];
        
        for (NSDictionary *dict in self.selectedRowsArray) {
            [previousVC addCotact:dict];
            
        }
        
        
    }
    else if ([[[[self navigationController]viewControllers] objectAtIndex:([[[self navigationController]viewControllers]count]-2)] isKindOfClass:[PacContainerVC class]]){
        
        PacContainerVC *containerVC   =  [[[self navigationController]viewControllers] objectAtIndex:([[[self navigationController]viewControllers]count]-2)];  
        
        for (NSDictionary *dict in self.selectedRowsArray) {
            [containerVC addCotact:dict];
        }
        
    }
    else if ([[[[self navigationController]viewControllers] objectAtIndex:([[[self navigationController]viewControllers]count]-2)] isKindOfClass:[PACGroupsContainerVC class]]){
        
        
        NSMutableArray *userIdArray = [NSMutableArray new];
        
        
        for (NSDictionary *anObject in self.selectedRowsArray)
        {
            //NSMutableDictionary *tempDict = [NSMutableDictionary new];
            //tempDict[@"userid"]=[anObject valueForKey:@"_id"];
            //tempDict[@"phoneNumber"]=[anObject valueForKey:@"mobilePhone"];
            //tempDict[@"user_firstName"]=[anObject valueForKey:@"firstName"];
            
            [userIdArray addObject:[anObject valueForKey:@"_id"]];
        }

        NSDictionary * infoDict = [NSDictionary dictionaryWithObject:userIdArray forKey:@"userIDs"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_INVITE_CONTACT_PAC object:self userInfo:infoDict];

    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark:- 


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
        
//        [Services requestPostUrlArr:ServiceGetContacts parameters:parameters completionHandler:^(NSError * err, NSArray *responseArr) {
//            
//        }];
        
        
        
        
        //call global web service class
        [Services postRequest:ServiceGetContacts parameters:parameters completionHandler:^(NSString *err, NSDictionary *responseDict) {
            
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
            
        } ];
         
         
       
        
    }
    else
        //show internet not available
        [AppHelper showAlertWithTitle:netError message:netErrorMessage tag:0 delegate:nil cancelButton:ok otherButton:nil];
}

-(void)getContactsListingOLD
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

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if([touch.view isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    // UITableViewCellContentView => UITableViewCell
    if([touch.view.superview isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    // UITableViewCellContentView => UITableViewCellScrollView => UITableViewCell
    if([touch.view.superview.superview isKindOfClass:[UITableViewCell class]]) {
      //  return NO;
    }
    
    return true;
}

-(void)goToProfilePage:(NSString *) userId{
    
    ProfileContainerVC *PFVC = [[AppHelper getProfileStoryBoard] instantiateViewControllerWithIdentifier:@"ProfileContainerVC"];
    PFVC.viewerUserID = userId;
    
    
    [self.navigationController pushViewController:PFVC animated:true];
    
}



- (void)tapGestureTapProfileIcon:(UITapGestureRecognizer *)sender {
    
    CGPoint location = [sender locationInView:self.view];
    
    if (CGRectContainsPoint([self.view convertRect:self.tableView.frame fromView:self.tableView.superview], location))
    {
        CGPoint locationInTableview = [self.tableView convertPoint:location fromView:self.view];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:locationInTableview];
        
        if (indexPath){
            
            NSString *friendID = [[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] valueForKey:@"_id"];
            
            [self goToProfilePage:friendID];
            
        }
        
        
        
    }
}

    
    
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
    
    NSURL *url = [NSURL URLWithString:[[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] valueForKey:@"imgUrl"]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"ic_booking_profilepic"];
    
    __weak ContactsCell *weakCell = cell;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureTapProfileIcon:)];
    gesture.delegate = self;
    cell.imgPerson.userInteractionEnabled = true;
    [cell.imgPerson addGestureRecognizer:gesture];
    
    
    [cell.imgPerson sd_setImageWithURL:url placeholderImage:placeholderImage];
    /*
    [cell.imgPerson setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       
                                       weakCell.imgPerson.image = image;
                                       [weakCell setNeedsLayout];
                                       
                                   } failure:nil];
    */
    cell.imgPerson.layer.borderWidth = 1.0;
    cell.imgPerson.contentMode = UIViewContentModeScaleAspectFill;
    cell.imgPerson.layer.masksToBounds = false;
    cell.imgPerson.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.imgPerson.layer.cornerRadius = 23;
    cell.imgPerson.clipsToBounds = true;
    
    NSLog(@"%@",[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]]);
    
    NSString *lastname = [NSString stringWithFormat:@"%@",[[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] valueForKey:@"lastName"]];
    NSString *firstName = [[NSString stringWithFormat:@"%@",[[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] valueForKey:@"firstName"]] stringByAppendingString:@" "];
    
    NSString *fullName = [firstName stringByAppendingString:lastname];
    
    cell.lblName.text=fullName;//[NSString stringWithFormat:@"%@",[[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] valueForKey:@"firstName"]];
    
    
    cell.lblDesc.text=[[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] valueForKey:@"userStatus"];
    
    //badru
    if(self.constrHeightGroupView.constant == 0)
    {
        //[cell.imgCellSelection setHidden:YES];
        
        //for multiple contact selection
        
        if ([self.selectedRowsArray containsObject:[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]])
        {
             [cell.imgCellSelection setHidden:NO];
            [cell.imgCellSelection setImage:[UIImage imageNamed:@"check_round"]];
        }
        else {
          //  [cell.imgCellSelection setImage:[UIImage imageNamed:@"uncheck_round"]];
            [cell.imgCellSelection setHidden:YES];
        }
        
    }
    else{
        
        [cell.imgCellSelection setHidden:NO];
        
        if ([self.selectedRowsArray containsObject:[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]])
        {
            [cell.imgCellSelection setImage:[UIImage imageNamed:@"check_round"]];
        }
        else {
            [cell.imgCellSelection setImage:[UIImage imageNamed:@"uncheck_round"]];
        }
    }
 
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId])
    {
        
        //In case One on One Chat
    if(self.constrHeightGroupView.constant == 0) //if not creating a group
    {
        //if([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[MyPAStodoVC class]])
        //{
            //[self.delegate getSelectedPhone:[[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] valueForKey:@"mobilePhone"]];
        //}
        //else
        if ([[self.navigationController.viewControllers objectAtIndex:1] isKindOfClass:[AllContactsVC class]])
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
            anobject.firstName = [frndDict valueForKey:@"firstName"];
            
            chatMainVC.contObj=anobject;
            chatMainVC.isFromClass = @"chatd";
            chatMainVC.isGroup = @"0";
            chatMainVC.isFromDeatilScreen = @"0";
            //chatMainVC.recentChatObj = recentObj;
            chatMainVC.recentChatObj = nil;
            
            [self.navigationController pushViewController:chatMainVC animated:YES];
        }
        else //if ([[self.navigationController.viewControllers objectAtIndex:1] isKindOfClass:[AllContactsVC class]])
        {
            NSDictionary *frndDict=[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            NSLog(@"%@",frndDict);
            
            NSString * login_id = [AppHelper userDefaultsForKey:uId];
            NSString *predicate = [NSString stringWithFormat:@"loginUserId contains[cd] %@ AND friendId contains[cd] %@",login_id, [frndDict objectForKey:@"_id"]];
            DataBaseController *dbInstance = [DataBaseController sharedInstance];
            //RecentChatList * recentObj = [dbInstance fetchDataRecentChatObject:@"RecentChatList" predicate:predicate];
            
            //if let classObject = NSClassFromString("YOURAPPNAME.MyClass") as? MyClass.Type {
            //let object = classObject.init()
            //}
            if([[[[self navigationController]viewControllers] objectAtIndex:([[[self navigationController]viewControllers]count]-2)] isKindOfClass:[GroupDetailVC class]])
            {
                GroupDetailVC *previousVC = [[[self navigationController]viewControllers] objectAtIndex:([[[self navigationController]viewControllers]count]-2)];
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
                anobject.firstName = [frndDict valueForKey:@"firstName"];
                
                [previousVC addNewFrndIngrp:anobject];
                
                [self.delegate1 addMemberInGroup:previousVC withInfo:(ChatContactModelClass *)anobject];
            }
            // CreateMeetUpVC or Pac COn tainer for Create a pac
            else if([[[[self navigationController]viewControllers] objectAtIndex:([[[self navigationController]viewControllers]count]-2)] isKindOfClass:[CreateMeetUpVC class]] || [[[[self navigationController]viewControllers] objectAtIndex:([[[self navigationController]viewControllers]count]-2)] isKindOfClass:[PacContainerVC class]] )
            {
                
                [self insertRemoveToSelecetedRowArray:frndDict];
                
            }
            else if([[[[self navigationController]viewControllers] objectAtIndex:([[[self navigationController]viewControllers]count]-2)] isKindOfClass:[MeetUpDetailsVC class]])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_CONTACT_CLICKED object:self userInfo:frndDict];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else if([[[[self navigationController]viewControllers] objectAtIndex:([[[self navigationController]viewControllers]count]-2)] isKindOfClass:[PACGroupsContainerVC class]])
            {
                
                //[self.navigationController popViewControllerAnimated:YES];
                [self insertRemoveToSelecetedRowArray:frndDict];
                
            }
            // Added by me 17 April
            else if([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[MyPAStodoVC class]])
            {
            [self.delegate getSelectedPhone:[[[self.dicAlphabet objectForKey:[[self allShortedKeys:[self.dicAlphabet allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] valueForKey:@"mobilePhone"]];
            }

            
        }
    }
    else //In case Group Chat
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
        
        self.lblTotalSelected.text=[NSString stringWithFormat:@"(%d Selected)",(int)[self.selectedRowsArray count]];


    }
    }
}

#pragma Mark - 

-(void)insertRemoveToSelecetedRowArray:(NSDictionary *) dict{
    
    NSLog(@"seelcted arraty %@",_selectedRowsArray);
    
    if ([self.selectedRowsArray containsObject:dict])
    {
        [self.selectedRowsArray removeObject:dict];
    }
    else
    {
        [self.selectedRowsArray addObject:dict];
    }
    [self.tableView reloadData];
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
            tempDict[@"user_firstName"]=[anObject valueForKey:@"firstName"];

            [userIdArray addObject:tempDict];
        }
        
        NSMutableDictionary *tempDict = [NSMutableDictionary new];
        tempDict[@"userid"]=[ChatHelper userDefaultForKey:_ID];
        tempDict[@"phoneNumber"]=[AppHelper userDefaultsForKey:cellNum];
        tempDict[@"user_firstName"]=[AppHelper userDefaultsForKey:userFirstName];

        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
