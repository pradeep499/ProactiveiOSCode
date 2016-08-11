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
#import "MessagesVC.h"
#import "ProactiveLiving-Swift.h"

@interface InboxVC () <YSLContainerViewControllerDelegate>
{
    NSMutableArray *arrServices;
    NSMutableArray *arrTypes;
    ChatHomeVC *mesagesVC1;
    MessagesVC *mesagesVC2;
    MessagesVC *mesagesVC3;
    MessagesVC *mesagesVC4;
}
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnDeleteAll;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateNew;
@property (weak, nonatomic) IBOutlet UIButton *btnContacts;


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
    
    mesagesVC1 = [storyboard instantiateViewControllerWithIdentifier:@"ChatHomeVC"];
    mesagesVC1.title = @"MESSAGES";
    
    mesagesVC2 = [storyboard instantiateViewControllerWithIdentifier:@"MessagesVC"];
    mesagesVC2.title = @"MEETUPS";
    
    mesagesVC3 = [storyboard instantiateViewControllerWithIdentifier:@"MessagesVC"];
    mesagesVC3.title = @"INVITATION";
    
    mesagesVC4 = [storyboard instantiateViewControllerWithIdentifier:@"MessagesVC"];
    mesagesVC4.title = @"REQUESTS";
    
    
    // ContainerView
    //float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    //float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]
                                               initWithControllers:@[mesagesVC1]
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
    [mesagesVC1 toggleDeleteChats:status];
}

- (IBAction)btnContactsClick:(id)sender {

    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        AllContactsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AllContactsVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }

}
- (IBAction)deleteAllClick:(id)sender {
    
    
}

- (IBAction)btnCreateNewClick:(id)sender {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        //UIStoryboard *chatStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        //GroupHomeVC *vc = [chatStoryBoard instantiateViewControllerWithIdentifier:@"GroupHomeVC"];
        //[self.navigationController pushViewController:vc animated:YES];
    }
    
}
@end
