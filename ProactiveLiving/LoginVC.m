//
//  ViewController.m
//  ProactiveLiving
//
//  Created by Hitesh on 1/12/16.
//  Copyright © 2016 MaverickHitesh. All rights reserved.
//

#import "LoginVC.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "Defines.h"
#import "AppDelegate.h"
#import "Services.h"
#import "AppHelper.h"
#import "CoreDataFunction.h"
#import "GetPasVC.h"
#import "HomeVC.h"
#import "MyPAStodoVC.h"
//#import "CalendarVC.h"
#import "ImproveVC.h"
#import "RSDFDatePickerViewController.h"
#import "InboxVC.h"
#import "CustonTabBarController.h"
#import <AFNetworking/AFNetworking.h>
#import "ProactiveLiving-Swift.h"


@interface LoginVC ()<UITextFieldDelegate, UIAlertViewDelegate> {
    BOOL isRememberMe;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *rememberMeButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *emailBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (strong, nonatomic) NSDictionary *detailDictionary;
@property (nonatomic, retain) CustonTabBarController *tabBarController;


@end

@implementation LoginVC
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        //[self performSegueWithIdentifier:@"GetPasVC" sender:nil];
        [self setupTabBarController];        
    }
    else
        [self setUpInitialView];
    
   

    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

    
}

-(void)setupTabBarController
{
    //CalendarVC *firstViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CalendarVC"];
    //firstViewController.title=@"Calendar";
    //firstViewController.tabBarItem.image=[UIImage imageNamed:@"ic_more_tabar_calendar"];
    //UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                   //initWithRootViewController:firstViewController];
    
    RSDFDatePickerViewController *firstViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CalendarVC"];
    firstViewController.title=@"Calendar";
    firstViewController.tabBarItem.image=[UIImage imageNamed:@"ic_more_tabar_calendar"];
    firstViewController.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    firstViewController.calendar.locale = [NSLocale currentLocale];
    UIViewController *firstNavigationController = [[UINavigationController alloc] initWithRootViewController:firstViewController];
    

    InboxVC *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InboxVC"];
    secondViewController.title=@"Inbox";
    secondViewController.tabBarItem.image=[UIImage imageNamed:@"ic_more_tabar_inbox"];
    UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:secondViewController];

    
    NewsFeedsAllVC *firstVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsFeedsAllVC"];
    firstVC.title = @"ALL";

    ExploreVC *secondVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ExploreVC"];
    secondVC.title = @"EXPLORE";

    NewsFeedsAllVC *thirdVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsFeedsAllVC"];
    thirdVC.title = @"FRIENDS";
    
    NewsFeedsAllVC *fourthVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsFeedsAllVC"];
    fourthVC.title = @"COLLEAGUES";
    
    NewsFeedsAllVC *fifthVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsFeedsAllVC"];
    fifthVC.title = @"HEALTH CLUBS";
    
    NSArray *arrVCs=[NSArray arrayWithObjects:firstVC,secondVC,thirdVC,fourthVC,fifthVC, nil];
    
    NewsFeedContainer *thirdViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsFeedContainer"];
    thirdViewController.title=@"Home";
    thirdViewController.arrViewControllers=arrVCs;
    thirdViewController.tabBarItem.image=[UIImage imageNamed:@"ic_more_tabar_home"];
    UIViewController *thirdNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:thirdViewController];
    /* Changed by client
     
    MyPAStodoVC *fourthViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyPAStodoVC"];
    fourthViewController.title=@"Activate";
    fourthViewController.tabBarItem.image=[UIImage imageNamed:@"ic_tabbar_activate"];
    UIViewController *fourthNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:fourthViewController];
    
    
    
    */
    ImproveVC *fourthViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ImproveVC"];
    fourthViewController.menuTitle=@"";
    fourthViewController.arrMenueImages=[NSArray arrayWithObjects:
                       @"ic_improve_experts",
                       @"ic_improve_webinars",
                       @"ic_improve_webcasts",
                       @"ic_improve_event",
                       @"ic_improve_PAccircle",
                       @"ic_improve_PASduel",
                       @"ic_improve_education",
                       @"ic_improve_prevention",
                       @"ic_improve_volunteer",
                       @"ic_improve_eatingguide",
                       @"ic_improve_dietplans",
                       @"ic_improve_healthymeals",
                       @"ic_improve_wellnessapps",
                       @"ic_improve_device",
                       @"ic_improve_workout",
                       @"ic_improve_inspotstionalvideos",
                       @"ic_improve_inspirationalmessage",
                       @"ic_improve_gratitudejournal",
                       @"ic_improve_city",
                       @"ic_improve_communityprograme",
                       @"ic_improve_specialized",
                       @"ic_improve_kids",
                       @"ic_improve_youthprograms",
                       @"ic_improve_seniorprograms",nil];
    fourthViewController.title=@"Activate";
    fourthViewController.tabBarItem.image=[UIImage imageNamed:@"ic_tabbar_activate"];
    
    UIViewController *fourthNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:fourthViewController];
    
    
    
    

  /*  GetPasVC *fifthViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GetPasVC"];
    fifthViewController.title=@" Menu";
    fifthViewController.tabBarItem.image=[UIImage imageNamed:@"ic_more_tabar_menu"];
    UIViewController *fifthNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:fifthViewController];
    */
    
    
    MenuVC *fifthViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuVC"];
    fifthViewController.title=@" Menu";
    fifthViewController.tabBarItem.image=[UIImage imageNamed:@"ic_more_tabar_menu"];
    UIViewController *fifthNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:fifthViewController];
    

    
    self.tabBarController = [[CustonTabBarController alloc] init];
    
    
    [self.tabBarController setViewControllers:@[firstNavigationController , secondNavigationController, thirdNavigationController, fourthNavigationController,fifthNavigationController]];
    [self.tabBarController setSelectedIndex:2];
    
    //set up badge Icon
    [AppDelegate getAppDelegate].tabbarController = self.tabBarController;
    
    if ([[DataBaseController sharedInstance] fetchUnreadCount] > 0) {
        
        [[AppDelegate getAppDelegate].tabbarController.tabBar.items objectAtIndex:1].badgeValue = [NSString stringWithFormat:@"%zd",  [[DataBaseController sharedInstance] fetchUnreadCount]  ];
    }else{
        [[AppDelegate getAppDelegate].tabbarController.tabBar.items objectAtIndex:1].badgeValue = nil;
    }
    
    
    
    
    
    [self.navigationController pushViewController:self.tabBarController animated:YES];
    //OR
    //[[AppDelegate getAppDelegate].window addSubview:self.tabBarController.view];
    //OR
    //[self.view addSubview:self.tabBarController.view];
    
    //[[self.tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:@"6"];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:true animated:yes];
    
    NSLog(@"%@",[AppHelper userDefaultsForKey:isRememberUser]);
    if (![[AppHelper userDefaultsForKey:isRememberUser] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:isRememberUser]) {
        if (![[AppHelper userDefaultsForKey:cellNum] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:cellNum]) {
            self.emailTextField.text = [AppHelper userDefaultsForKey:cellNum];
        }
        if (![[AppHelper userDefaultsForKey:pwd] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:pwd]) {
            self.passwordTextField.text = [AppHelper userDefaultsForKey:pwd];
        }
    }
    else {
        self.emailTextField.text = @"";
        self.passwordTextField.text = @"";
    }
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.tableView.contentInset = UIEdgeInsetsZero;
}
#pragma mark - setUpInitialView
-(void)setUpInitialView {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.emailBackgroundImageView.layer.borderWidth = 1;
    self.emailBackgroundImageView.layer.borderColor = loginBorderColor.CGColor;
    
    self.passwordBackgroundImageView.layer.borderWidth = 1;
    self.passwordBackgroundImageView.layer.borderColor = loginBorderColor.CGColor;
    
    UIFont *font = [UIFont fontWithName:@"Roboto-Regular" size:13.0];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"Don't have an account yet? SIGN UP"];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 26)];
    [attrString addAttribute:NSForegroundColorAttributeName value:signUpButtonColor range:NSMakeRange(0, 26)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Regular" size:16.0] range:NSMakeRange(26, 8)];
    
    [self.signupButton setAttributedTitle:attrString forState:UIControlStateNormal];

    
    [self.rememberMeButton setSelected:YES];
    isRememberMe = YES;

    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPhonePad)], [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(dontPhonePad)]];
    [numberToolbar sizeToFit];
    self.emailTextField.inputAccessoryView = numberToolbar;
}
#pragma mark - cancelPhonePad
-(void)cancelPhonePad {
    [self.view endEditing:YES];
}
#pragma mark - dontPhonePad
-(void)dontPhonePad {
    [self.passwordTextField becomeFirstResponder];
}
#pragma mark - keyboardwillshow
-(void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyBoardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    
    UIEdgeInsets inset = self.tableView.contentInset;
    inset.bottom = keyBoardSize.height + 20;
    self.tableView.contentInset = inset;
}
#pragma mark - keyboardwillhide
-(void)keyboardWillHide:(NSNotification *)notification {
    self.tableView.contentInset = UIEdgeInsetsZero;

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100 && buttonIndex == 0) {
        self.emailTextField.text = @"";
        [self.emailTextField becomeFirstResponder];
    }
    else if (alertView.tag && buttonIndex == 0) {
        self.passwordTextField.text = @"";
        [self.passwordTextField becomeFirstResponder];
    }
}
#pragma mark - signIn
- (IBAction)signIn:(id)sender {
    [self.view endEditing:YES];
    
    if ([[self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        //show alert, email can't be empty
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:requiredTitle message:cellNumberMandatory delegate:self cancelButtonTitle:ok otherButtonTitles:nil, nil];
        alert.tag = 100;
        [alert show];

    }
    else if ([[self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < minimumPhoneLength) {
        //show alert, email can't be empty
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:requiredTitle message:validCellNumber delegate:self cancelButtonTitle:ok otherButtonTitles:nil, nil];
        alert.tag = 100;
        [alert show];
        
    }
    else if ([[self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        //show alert, password can't be empty
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:requiredTitle message:passwordMandatory delegate:self cancelButtonTitle:ok otherButtonTitles:nil, nil];
        alert.tag = 101;
        [alert show];

    }
    else if ([[self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < minimumPasswordLength) {
        //show alert, password can't be empty
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:requiredTitle message:validPassword delegate:self cancelButtonTitle:ok otherButtonTitles:nil, nil];
        alert.tag = 101;
        [alert show];
    }
    else {
        if ([AppDelegate checkInternetConnection]) {
            [SVProgressHUD showWithStatus:@"Signing In" maskType:SVProgressHUDMaskTypeBlack];
            NSMutableDictionary *parameters=[NSMutableDictionary dictionary];;
            
            [parameters setObject:AppKey forKey:@"AppKey"];
            [parameters setObject:[self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"emailOrPhone"];
            [parameters setObject:[self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"password"];
            
            
            #if TARGET_IPHONE_SIMULATOR
            [parameters setObject:@"iPhone" forKey:@"deviceType"];
            #else
            if([AppHelper userDefaultsForKey:DEVICE_TYPE])
                [parameters setObject:[AppHelper userDefaultsForKey:DEVICE_TYPE] forKey:@"deviceType"];
            else
                [parameters setObject:@"NA" forKey:@"deviceType"];
            #endif

            #if TARGET_IPHONE_SIMULATOR
            [parameters setObject:@"DUMMY_TOKEN" forKey:@"deviceToken"];
            #else
            if([AppHelper userDefaultsForKey:DEVICE_TOKEN])
                [parameters setObject:[AppHelper userDefaultsForKey:DEVICE_TOKEN] forKey:@"deviceToken"];
            else
                [parameters setObject:@"NA" forKey:@"deviceToken"];
            #endif
            
            
            [Services serviceCallWithPath:ServiceLogin withParam:parameters success:^(NSDictionary *responseDict) {
                [SVProgressHUD dismiss];
                NSLog(@"%@",responseDict);
                
                self.detailDictionary = responseDict;
                
                
                
                NSLog(@"%@",self.detailDictionary);
                
                if (![[self.detailDictionary objectForKey:@"error"] isKindOfClass:[NSNull class]] && [self.detailDictionary objectForKey:@"error"]) {
                    if ([[self.detailDictionary objectForKey:@"error"] intValue] == 0) {
                        // success login
                        
                        if (![[self.detailDictionary objectForKey:@"result"] isKindOfClass:[NSNull class]] && [self.detailDictionary objectForKey:@"result"]) {
                            [AppHelper saveToUserDefaults:[[self.detailDictionary objectForKey:@"result"] valueForKey:@"_id"] withKey:uId];
                            [AppHelper saveToUserDefaults:[[self.detailDictionary objectForKey:@"result"] valueForKey:@"userStatus"] withKey:userProfileStatus];
                            
                            
                            
                            //CHAT RELATED
                            [ChatHelper saveToUserDefault:[[self.detailDictionary objectForKey:@"result"] valueForKey:@"_id"] key:_ID];
                            [ChatHelper saveToUserDefault:[[self.detailDictionary objectForKey:@"result"] valueForKey:@"mobilePhone"] key:cellNum];
                            [ChatHelper saveToUserDefault:[[self.detailDictionary objectForKey:@"result"] valueForKey:@"firstName"] key:userFirstName];
                            [ChatHelper saveToUserDefault:[[self.detailDictionary objectForKey:@"result"] valueForKey:@"lastName"] key:userLastName];
                            

                            if ([[self.detailDictionary objectForKey:@"result"] valueForKey:@"imgUrl"]) {
                                [AppHelper saveToUserDefaults:[[self.detailDictionary objectForKey:@"result"] valueForKey:@"imgUrl"] withKey:@"user_imageUrl"];
                            }
                            
                            
                            
                            [AppHelper saveToUserDefaults:[[self.detailDictionary objectForKey:@"result"] valueForKey:@"firstName"] withKey:@"user_firstName"];
                            
                            [AppHelper saveToUserDefaults:[self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] withKey:pwd];
                            [AppHelper saveToUserDefaults:[self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] withKey:cellNum];
                            
                            //Create connection
                            [[ChatListner getChatListnerObj] createConnection];
                            
                        }
                        NSLog(@"%@",[AppHelper userDefaultsForKey:uId]);//print uid
                        if (isRememberMe) {
                            [AppHelper saveToUserDefaults:@"yes" withKey:isRememberUser];
                        }
                        else {
                            [AppHelper removeFromUserDefaultsWithKey:isRememberUser];
                        }
                        
                        if ( [[[self.detailDictionary objectForKey:@"result"] valueForKey:@"isFirstLogin"] boolValue]) {
                            //first time logged in
                            
                            //goto Edit page
                            
                            EditAboutMeVC *editVC = (EditAboutMeVC *)[[AppHelper getProfileStoryBoard]instantiateViewControllerWithIdentifier:@"EditAboutMeVC"];
                            
                             editVC.firstTimeLogin = @"1";
                            
                            [self.navigationController pushViewController:editVC animated:true];
                            
                        }else{
                            [self setupTabBarController];
                            //save user details to userDefault
                            
                            NSDictionary *dict = [self.detailDictionary objectForKey:@"result"];
                            UserDetails *obj =   UserDetails.sharedInstance;
                            
                            obj.userID = [dict valueForKey:@"_id"];
                            obj.userName = [NSString stringWithFormat:@"%@ %@", [dict valueForKey:@"firstName"], [dict valueForKey:@"lastName"]];
                            obj.gender = [dict valueForKey:@"gender"];
                            obj.summary = [dict valueForKey:@"summary"];
                            obj.liveIn = [dict valueForKey:@"liveIn"];
                            obj.workAt = [dict valueForKey:@"workAt"];
                            obj.grewUp = [dict valueForKey:@"grewup"];
                            obj.highSchool = [dict valueForKey:@"highSchool"];
                            obj.college = [dict valueForKey:@"college"];
                            obj.graduateSchool = [dict valueForKey:@"graduateSchool"];
                            obj.highSchoolSportsPlayed = [dict valueForKey:@"highSchoolSportsPlayed"];
                            obj.collegeSportsPlayed = [dict valueForKey:@"collegeSportsPlayed"];
                            obj.currentSport = [dict valueForKey:@"currentSport"];
                            
                            obj.interests = [dict valueForKey:@"intrests"];
                            obj.favFamousQuote = [dict valueForKey:@"favFamousQuote"];
                            obj.notFamousQuote = [dict valueForKey:@"notFamousQuote"];
                            obj.bio = [dict valueForKey:@"bio"];
                            obj.imgUrl = [dict valueForKey:@"imgUrl"];
                            obj.imgCoverUrl = [dict valueForKey:@"imgCoverUrl"];
                            
                 
                            
                            
                            [HelpingClass saveUserDetails:obj];
                            
                        }
                        
                        
                        

                    }
                    else if ([[self.detailDictionary objectForKey:@"error"] intValue] == 1){
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[self.detailDictionary objectForKey:@"errorMsg"]  delegate:nil cancelButtonTitle:ok otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    else {
                        [self showAlert];
                    }
                }
                else {
                    [self showAlert];
                }
                
            } failure:^(NSError *error) {
                [SVProgressHUD dismiss];
                NSLog(@"%@",error);
                [self showAlert];
            }];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:netError message:netErrorMessage delegate:nil cancelButtonTitle:ok otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}
#pragma mark - showAlert
-(void)showAlert {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:serviceError delegate:nil cancelButtonTitle:ok otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark - forgotPassword
- (IBAction)forgotPassword:(id)sender {
    [self.view endEditing:YES];
}
#pragma mark - signUp
- (IBAction)signUp:(id)sender {
    [self.view endEditing:YES];
    
    [AppHelper removeFromUserDefaultsWithKey:isRememberUser];
    [AppHelper removeFromUserDefaultsWithKey:cellNum];
    [AppHelper removeFromUserDefaultsWithKey:pwd];
    [AppHelper removeFromUserDefaultsWithKey:uId];
    
    
}
#pragma mark - tapOnHeaderView
- (IBAction)tapOnHeaderView:(id)sender {
    [self.view endEditing:YES];
}
#pragma mark - touch
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark - rememberMe
- (IBAction)rememberMe:(id)sender {
    [self.view endEditing:YES];
    
    if (isRememberMe) {
        [self.rememberMeButton setSelected:NO];
    }
    else {
        [self.rememberMeButton setSelected:YES];
    }
    isRememberMe = !isRememberMe;
}

#pragma mark - textfield
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == self.passwordTextField) {
        NSLog(@"%ld",(long)[[self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]);
        if ([[self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
            [self signIn:nil];
        }
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if(str.length > 0 && [[str substringToIndex:1] isEqualToString:@" "]) {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if (textField == self.emailTextField) {
        return (newLength > maxPhoneLength ? NO : YES);
    }
    else {
        return (newLength > maxLength) ? NO : YES;
    }
    return YES;
}

#pragma mark - preferredStatusBarStyle
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
#pragma mark - segue 
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"HomeVCScreen"]) {
        self.emailTextField.text = @"";
        self.passwordTextField.text = @"";
    }
}
@end
