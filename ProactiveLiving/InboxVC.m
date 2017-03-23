//
//  InboxVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 17/05/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "InboxVC.h"
#import "AppHelper.h"
#import "Defines.h"
#import "AllContactsVC.h"
#import "YSLContainerViewController.h"
#import "FriendRequestVC.h"
#import "PACNotificationVC.h"
#import "ProactiveLiving-Swift.h"

@interface InboxVC () <YSLContainerViewControllerDelegate>
{
    NSMutableArray *arrServices;
    NSMutableArray *arrTypes;
    ChatHomeVC *mesagesVC;
    MeetUpsListingVC *meetUpVC;
    MeetUpsListingVC *webInviteVC;
    NSInteger currentIndex;
}
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnDeleteAll;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateNew;
@property (weak, nonatomic) IBOutlet UIButton *btnContacts;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_widthOfBtnCreateNew;



@end

@implementation InboxVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpViewControllers];
    
    [self.btnEdit setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    //[self.btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
    [self.btnEdit setImage:[UIImage imageNamed:@"done"] forState:UIControlStateSelected];
    //[self.btnEdit setTitle:@"Edit" forState:UIControlStateSelected];
    [self.btnDeleteAll setHidden:YES];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - preferredStatusBarStyle
-(UIStatusBarStyle)preferredStatusBarStyle {
    // to set the light color of status bar
    return UIStatusBarStyleLightContent;
}

-(void)setUpViewControllers
{
    // SetUp ViewControllers
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //UIStoryboard *chatStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    mesagesVC = [storyboard instantiateViewControllerWithIdentifier:@"ChatHomeVC"];
    mesagesVC.title = @"MESSAGES   ";
    
    meetUpVC = [storyboard instantiateViewControllerWithIdentifier:@"MeetUpsListingVC"];
    meetUpVC.title = @"MEET UPS";
    
    webInviteVC = [storyboard instantiateViewControllerWithIdentifier:@"MeetUpsListingVC"];
    webInviteVC.title = @"WEB INVITES";
   
    FriendRequestVC *requestVC = [[AppHelper getSecondStoryBoard] instantiateViewControllerWithIdentifier:@"FriendRequestVC"];
      requestVC.title = @"REQUESTS";
    
    PACNotificationVC *notificationVC = [[AppHelper getStoryBoard] instantiateViewControllerWithIdentifier:@"PACNotificationVC"];
    notificationVC.title = @"NOTIFICATIONS";
    
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]
                                               initWithControllers:@[mesagesVC,meetUpVC,webInviteVC, requestVC, notificationVC]
                                               topBarHeight:0
                                               parentViewController:self];
    
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:@"Roboto-Regular" size:11];
    containerVC.menuItemSelectedFont = [UIFont fontWithName:@"Roboto-Bold" size:11.5];
    containerVC.menuBackGroudColor=[UIColor colorWithRed:1.0/255 green:174.0/255 blue:240.0/255 alpha:1.0];
    containerVC.menuItemTitleColor=[UIColor whiteColor];
    containerVC.menuItemSelectedTitleColor=[UIColor whiteColor];
    containerVC.view.frame=CGRectMake(0, 64, containerVC.view.frame.size.width, containerVC.view.frame.size.height-64);
    
    [self.view addSubview:containerVC.view];
}

#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    [self.view endEditing:YES];
    NSLog(@"current Index : %ld",(long)index);
    NSLog(@"current controller : %@",controller);
    currentIndex=index;
    
    if(currentIndex==0){
        self.btnEdit.hidden=NO;
        self.layout_widthOfBtnCreateNew.constant = 0;
        self.btnContacts.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    else if(currentIndex == 3){
        self.btnEdit.hidden = YES;
        self.btnContacts.hidden = NO;
        self.btnCreateNew.hidden = YES;
        self.layout_widthOfBtnCreateNew.constant = 0;
        self.btnContacts.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);

    }
    else if(currentIndex == 4){
        self.btnEdit.hidden = true;
        self.btnContacts.hidden = NO;
        self.btnCreateNew.hidden = true;
        self.layout_widthOfBtnCreateNew.constant = 0;
        self.btnContacts.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);

    }
    else{
        self.btnEdit.hidden=YES;
        self.btnContacts.hidden = NO;
        self.btnCreateNew.hidden = NO;
        self.layout_widthOfBtnCreateNew.constant = 46;
        self.btnContacts.imageEdgeInsets = UIEdgeInsetsMake(0, 19, 0, 0);
    }
    
    [controller viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCancelClick:(UIButton*)sender {
    
    sender.selected=!sender.selected;
    BOOL status= (sender.selected)? YES : NO;
    if(status)
    {
        [self.btnDeleteAll setHidden:NO];
        [self.btnContacts setHidden:YES];
        [self.btnCreateNew setHidden:YES];
    }
    else
    {
        [self.btnDeleteAll setHidden:YES];
        [self.btnContacts setHidden:NO];
        [self.btnCreateNew setHidden:NO];
    }
    [mesagesVC toggleDeleteChats:status];
}

- (IBAction)btnContactsClick:(id)sender {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        AllContactsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AllContactsVC"];
        vc.fromVC=@"Inbox";
        [self.navigationController pushViewController:vc animated:YES];
    }

}
- (IBAction)deleteAllClick:(id)sender {
    
    
}

- (IBAction)btnCreateNewClick:(id)sender {
    
    if(currentIndex==0)
    {
//        if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
//            UIStoryboard *chatStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//            CreateMeetUpVC *vc = [chatStoryBoard instantiateViewControllerWithIdentifier:@"CreateMeetUpVC"];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
    }
    else if (currentIndex==1)
    {
        if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
            UIStoryboard *chatStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            CreateMeetUpVC *vc = [chatStoryBoard instantiateViewControllerWithIdentifier:@"CreateMeetUpVC"];
            vc.pushedFrom=@"MEETUPS";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (currentIndex==2)
    {
        if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
            UIStoryboard *chatStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            CreateMeetUpVC *vc = [chatStoryBoard instantiateViewControllerWithIdentifier:@"CreateMeetUpVC"];
            vc.pushedFrom=@"WEBINVITES";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (currentIndex==3)
    {
//        if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
//            UIStoryboard *chatStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//            CreateMeetUpVC *vc = [chatStoryBoard instantiateViewControllerWithIdentifier:@"CreateMeetUpVC"];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
    }
    
    
}
@end
