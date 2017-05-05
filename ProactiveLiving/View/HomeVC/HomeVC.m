//
//  HomeVC.m
//  ProactiveLiving
//
//  Created by Hitesh on 1/21/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "HomeVC.h"
#import "AppHelper.h"
#import "Defines.h"
#import "LoginVC.h"
#import <AddressBook/AddressBook.h>


@interface HomeVC ()
{
    NSMutableArray *all_contacts;
}

@end

@implementation HomeVC
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    all_contacts=[NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - preferredStatusBarStyle
-(UIStatusBarStyle)preferredStatusBarStyle {
    // to set the color of status bar
    return UIStatusBarStyleLightContent;
}
#pragma mark - logout
- (IBAction)logout:(id)sender {
    /*
    //checking if user set to remember credentials
    if (![[AppHelper userDefaultsForKey:isRememberUser] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:isRememberUser]) {
        //checking if isRemember not yes
        if (![[AppHelper userDefaultsForKey:isRememberUser] isEqualToString:@"yes"]) {
            //remove cellnum and pwd from userdefault
            [AppHelper removeFromUserDefaultsWithKey:cellNum];
            [AppHelper removeFromUserDefaultsWithKey:pwd];
        }
    }
    else {
        //if isRememberUser does not exist
        //remove cellnum and pwd from userdefault
        [AppHelper removeFromUserDefaultsWithKey:cellNum];
        [AppHelper removeFromUserDefaultsWithKey:pwd];
    }
    //on logout remove uid
    [AppHelper removeFromUserDefaultsWithKey:uId];
     
     NSArray *array = self.navigationController.viewControllers;
     for (id controller in array) {
     if ([controller isKindOfClass:[RootViewController class]]) {
     [self.navigationController popToViewController:controller animated:YES];
     
     }
     }
     
     */
    ////NSLog(@"--%@",[[self navigationController] viewControllers]);
    //pop to root view controller
    [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];

}

@end
