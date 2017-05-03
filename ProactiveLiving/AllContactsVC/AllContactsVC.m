//
//  AllContactsVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 17/05/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "AllContactsVC.h"
#import "YSLContainerViewController.h"
#import "ContactsVC.h"
#import "ContactFriendsVC.h"
#import "Defines.h"
#import "ProactiveLiving-Swift.h"

@interface AllContactsVC ()<YSLContainerViewControllerDelegate, UIGestureRecognizerDelegate>
{
    NSMutableArray *arrServices;
    NSMutableArray *arrTypes;
    ContactsVC *contactVC1;
   // ContactFriendsVC *contactVC2;
    ContactsVC *contactVC2;
    ContactsVC *contactVC3;
    ContactsVC *contactVC4;
    ContactsVC *contactVC5;
    
    UIViewController *currentController;
    
}


@end

@implementation AllContactsVC
@synthesize contactSelectBlock;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpViewControllers];
    [self.btnDone setHidden:YES];
    
     if([self.fromVC isEqualToString:@"Inbox"])
        [self.btnCreateNewGroup setHidden:NO];
    
     else if([self.fromVC isEqualToString:@"Menu"]){
         [self.btnCreateNewGroup setHidden:YES];
         [self.btnDone setHidden:YES];
     }
     else{
         
         [self.btnCreateNewGroup setHidden:YES];
         //badru
         [self.btnDone setHidden:NO];
     }
    
 
}
-(void)someAction
{
    //do something
    NSLog(@"...Done...");
    [self.btnCreateNewGroup setHidden:YES];
    [self.btnDone setHidden:NO];
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
-(void)setPhontactBlock:(ContactSelectBlock)block
{
    self.contactSelectBlock = block;
}

-(void)setUpViewControllers
{
    // SetUp ViewControllers
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    contactVC1 = [storyboard instantiateViewControllerWithIdentifier:@"ContactsVC"];
    contactVC1.delegate = self;
    contactVC1.delegate1 = self;
    contactVC1.delegate2=self;
    contactVC1.title = @"ALL";
    contactVC1.contactType=@"all";
    
//    contactVC2 = [storyboard instantiateViewControllerWithIdentifier:@"ContactFriendsVC"];
    contactVC2 = [storyboard instantiateViewControllerWithIdentifier:@"ContactsVC"];
    contactVC2.delegate = self;
    contactVC2.contactType=@"friends";
    contactVC2.title = @"FRIENDS";

    contactVC3 = [storyboard instantiateViewControllerWithIdentifier:@"ContactsVC"];
    contactVC3.delegate = self;
    contactVC3.delegate1 = self;
    contactVC3.title = @"COLLEAGUES";
    contactVC3.contactType=@"colleagues";

    contactVC4 = [storyboard instantiateViewControllerWithIdentifier:@"ContactsVC"];
    contactVC4.delegate = self;
    contactVC4.delegate1 = self;
    contactVC4.title = @"HEALTH CLUBS";
    contactVC4.contactType=@"healthclub";

    contactVC5 = [storyboard instantiateViewControllerWithIdentifier:@"ContactsVC"];
    contactVC5.delegate = self;
    contactVC5.delegate1 = self;
    contactVC5.title = @"OTHERS";
    contactVC5.contactType=@"";

    // ContainerView
    //float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    //float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]
                                               initWithControllers:@[contactVC1,contactVC2,contactVC3,contactVC4]
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
-(void)getSelectedPhone:(NSString*)phoneNumber
{
    self.contactSelectBlock(phoneNumber);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addMemberInGroup:(GroupDetailVC*)groupObj withInfo:(ChatContactModelClass *)frndObj
{
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //GroupDetailVC *groupObj = [storyboard instantiateViewControllerWithIdentifier:@"GroupDetailVC"];
    //groupObj.deletedGroup = YES;
    [groupObj addNewFrndIngrp:frndObj];
    [self.navigationController popViewControllerAnimated:YES];
   
}

#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    [self.view endEditing:YES];
    NSLog(@"current Index : %ld",(long)index);
    NSLog(@"current controller : %@",controller);
    currentController=controller;
    //[currentController viewWillAppear:YES];  commented to fix the double api hit issue on 6th April 2017
    
}

- (IBAction)btnBackClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)btnCreateGroupClick:(id)sender {
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHOW_GROUP_VIEW_CLICKED object:self];

}
- (IBAction)btnDoneClick:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    [self enableButtonWithDelay:sender];
    
    if([self.fromVC isEqualToString:@"Inbox"]){
        
        if([currentController isKindOfClass:[ContactsVC class]])
        {
            ContactsVC *currentVC=(ContactsVC*) currentController;
            [currentVC createGroupWithContacts];
        }
        else if([currentController isKindOfClass:[ContactFriendsVC class]])
        {
            ContactFriendsVC *currentVC=(ContactFriendsVC*) currentController;
            //[currentVC createGroupWithContacts];
        }
    }else{
        //badru
        //Create MeetUp or Creat a pac
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"POP_CONTCT_VC" object:self];
    }
    
}

- (void)enableButtonWithDelay:(UIButton*)sender {

    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        sender.userInteractionEnabled = YES;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
