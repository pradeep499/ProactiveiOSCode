//
//  AppDelegate.m
//  ProactiveLiving
//
//  Created by Hitesh on 1/12/16.
//  Copyright © 2016 MaverickHitesh. All rights reserved.
//

#import "AppDelegate.h"
#import "AppHelper.h"
#import "Defines.h"
#import "LocationManagerSingleton.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "ProactiveLiving-Swift.h"
@interface AppDelegate ()
{
    UIImageView *splashView;
}

@end

@implementation AppDelegate


#pragma mark - App delegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
     
    
    
    // Reset badge count
    [UIApplication sharedApplication].applicationIconBadgeNumber =0;
    
    // Register for Push Notification
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeNewsstandContentAvailability| UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }

    
     // fetch and hold static data
    [AppDelegate connectedCompletionBlock:^(BOOL connected) {
        if (connected)
            [self getStaticData];
        else
            NSLog(@"NOT REACHABLE");
    }];

    // Check current location (Use ZipCode by default)
    CLLocation *location= [LocationManagerSingleton sharedSingleton].locationManager.location;
    NSLog(@"location-> %@",location);
    
    //UISearchBar Global look n feel alteration
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:
                                                [NSDictionary dictionaryWithObjectsAndKeys:                                                                                                  [UIColor whiteColor],                                                                                                  NSForegroundColorAttributeName,                                                                                                 [UIColor whiteColor],                                                                                              NSForegroundColorAttributeName,                                                                                                  [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],                                                                                                  NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    //UITabBar appearance
    //[[UITabBar appearance] setTintColor:[UIColor blueColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    
    //Statusbar appearance
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //Navigationbar appearence
    [[UINavigationBar appearance] setBarTintColor: [UIColor colorWithRed:1.0/255 green:174.0/255 blue:240.0/255 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor: [UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, [UIFont fontWithName:FONT_REGULAR size:16], NSFontAttributeName,nil]];

    /*
    BOOL isLoggedIn;
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId])
        isLoggedIn = YES;    // from your server response
    else
        isLoggedIn=NO;
  
    NSString *storyboardId = isLoggedIn ? @"ValidationCentersVC" : @"LoginVC";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *initViewController = [storyboard instantiateViewControllerWithIdentifier:storyboardId];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = initViewController;
    [self.window makeKeyAndVisible];
    */
    //--OR--
    /*
    UINavigationController *navigation = (UINavigationController *) self.window.rootViewController;
    [navigation.visibleViewController performSegueWithIdentifier:@"GetPasVC" sender:nil];
     */
    
    
    /*
    // After this line: [window addSubview:tabBarController.view];
    
    splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    splashView.image = [UIImage imageNamed:@"Default.png"];
    [self.window addSubview:splashView];
    [self.window bringSubviewToFront:splashView];
    
    // Do your time consuming setup
    
    [splashView removeFromSuperview];
     */
    
    //Create socket connection
    [[ChatListner getChatListnerObj] createConnection];
    
    // Method execution in each 15 seconds.
    //[NSTimer scheduledTimerWithTimeInterval: 15.0 target:self selector: @selector(timerFired:) userInfo: nil repeats: YES];
    
    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * token = [NSString stringWithFormat:@"%@", deviceToken];
    //Format token as you need:
    NSString *tokenString = [NSString stringWithFormat:@"%@",token];
    tokenString = [tokenString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    tokenString = [tokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Device Token:%@",tokenString);
    [AppHelper saveToUserDefaults:tokenString withKey:DEVICE_TOKEN];
    [AppHelper saveToUserDefaults:CURRENT_DEVICE withKey:DEVICE_TYPE];

}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:   (UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
    
    
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString   *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    // NSLog(@"identifier ====%@ , userInfo===%@",userInfo,identifier);
    
    //   [AppHelper showAlertViewWithTag:0 title:APP_NAME message:@"push notification" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok"];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber =0;
    
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
        
    }
    else if ([identifier isEqualToString:@"answerAction"]){
        
    }
}
#endif

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber =0;
    NSLog(@"[userInfo didReceiveRemoteNotification == %@",[userInfo valueForKey:@"aps"]);
    
    if ([AppHelper userDefaultsForKey:@"userId"]) {
        
        //NSString*strMsg= [[userInfo valueForKey:@"aps"] objectForKey:@"alert"];
        NSDictionary *info_dic = [userInfo valueForKey:@"aps"];
        self.notyDic=[NSMutableDictionary dictionaryWithDictionary:info_dic];
        int pushType = [[info_dic objectForKey:@"push_type"] intValue]; // 20->one to one & 21->group chat
        
        if (pushType == 20 || pushType==21) {
            
            // Pk 30 Oct 2015
            
            if ([[AppHelper userDefaultsForKey:@"APP_STATUS"]isEqualToString:@"didBecomeInActive"])
            {
                NSLog(@"abc");
                
                //NSString *senderid  = info_dic[@"senderid"];
                
                UINavigationController *nav=(UINavigationController *)[AppDelegate getAppDelegate].self.window.rootViewController;
                NSArray*vcArray=[nav viewControllers];
                UITabBarController *tabBarController=nil;
                BOOL isTab=NO;
                NSInteger tabBarValue=0;
                for (int i = 0; i<vcArray.count; i++)
                {
                    UIViewController* controller = [vcArray objectAtIndex:i];
                    //  NSLog(@"$UIViewController===1%@",controller);
                    if([controller isKindOfClass:NSClassFromString(@"TabBarViewController")])
                    {
                        isTab=YES;
                        tabBarValue = i;
                        tabBarController=(UITabBarController*)controller;
                        break;
                    }
                }
                if (isTab) {
                    tabBarController.selectedIndex=3;
                    
                    
                }
                
                
            }
            else{
                
                UINavigationController *nav=(UINavigationController *)[AppDelegate getAppDelegate].self.window.rootViewController;
                NSArray*vcArray=[nav viewControllers];
                UITabBarController *tabBarController=nil;
                BOOL isTab=NO;
                NSInteger tabBarValue= 0;
                for (int i = 0; i<vcArray.count; i++)
                {
                    UIViewController* controller = [vcArray objectAtIndex:i];
                    //  NSLog(@"$UIViewController===1%@",controller);
                    if([controller isKindOfClass:NSClassFromString(@"TabBarViewController")])
                    {
                        isTab=YES;
                        tabBarValue = i;
                        tabBarController=(UITabBarController*)controller;
                        break;
                    }
                }
                
                NSInteger aChatPushCount = [[DataBaseController sharedInstance] fetchUnreadCount];
                if ([AppDelegate getAppDelegate].barItemForChat) {
                    if (aChatPushCount>0) {
                        
                        [AppDelegate getAppDelegate].barItemForChat.badgeValue=[NSString stringWithFormat:@"%ld",(long)[[DataBaseController sharedInstance] fetchUnreadCount]];
                    }
                    else
                    {
                        [AppDelegate getAppDelegate].barItemForChat.badgeValue=nil;
                    }
                    
                }
                
            }
        }
    }
}

#pragma mark - Utility methods

+ (AppDelegate*)getAppDelegate {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

+(BOOL)checkInternetConnection {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (void)showProgressHUDWithStatus:(NSString *)status {
    
    if(status && [status length]>0)
        [SVProgressHUD showWithStatus:status];
    else
        [SVProgressHUD show];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

+ (void)dismissProgressHUD {
    [SVProgressHUD dismiss];
}

+(void)connectedCompletionBlock:(void(^)(BOOL connected))block {
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        BOOL con = NO;
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            
            con = YES;
        }
        
        if (block) {
            [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
            block(con);
        }
        
    }];
}

-(void)getStaticData
{
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection]) {
        
        NSMutableDictionary *parameters=[NSMutableDictionary new];
        //call global web service class
        [Services serviceCallWithPath:ServiceGetPASInst withParam:parameters success:^(NSDictionary *responseDict)
         {
             //[SVProgressHUD dismiss];//dissmiss indicator
             
             if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
             {
                 if ([[responseDict objectForKey:@"error"] intValue] == 0) {
                     
                     [AppDelegate getAppDelegate].PASInst=[[responseDict objectForKey:@"result"] valueForKey:@"PasValidationInstruction"];
                     [AppDelegate getAppDelegate].PASInstVideo=[[responseDict objectForKey:@"result"] valueForKey:@"PasValidationInstructionVideo"];
                     [AppDelegate getAppDelegate].aboutPAS=[[responseDict objectForKey:@"result"] valueForKey:@"AboutPass"];
                     
                 }
                 else
                     [AppHelper showAlertWithTitle:[responseDict objectForKey:@"errorMsg"] message:@"" tag:0 delegate:nil cancelButton:ok otherButton:nil];
                 
             }
             else
                 [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
             
         } failure:^(NSError *error)
         {
             //[SVProgressHUD dismiss];
             [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
         }];
        
    }
    else
        //show internet not available
        [AppHelper showAlertWithTitle:netError message:netErrorMessage tag:0 delegate:nil cancelButton:ok otherButton:nil];
}

- (void)timerFired:(NSTimer*)theTimer{
    if(/* DISABLES CODE */ (YES)){
        [theTimer isValid]; //recall the NSTimer
        //implement your methods
        [[ChatListner getChatListnerObj] doNotSleep];
        NSLog(@"fired...");
    }else{
        [theTimer invalidate]; //stop the NSTimer
    }
}

#pragma mark - App life-cycle methods

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [AppHelper saveToUserDefaults:@"didBecomeInActive" withKey:@"APP_STATUS"];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"POP_TO_CHAT_MAIN_SCREEN" object:nil];
    [[ChatListner getChatListnerObj]closeConnection];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[ChatListner getChatListnerObj]createConnection];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [AppHelper saveToUserDefaults:@"didBecomeActive" withKey:@"APP_STATUS"];
    [[ChatListner getChatListnerObj] createConnection];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    [[ChatListner getChatListnerObj]closeConnection];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "MaverickHitesh.ProactiveLiving" in the application's documents directory.
    
    NSLog(@"sqlite %@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory  inDomains:NSUserDomainMask] lastObject]);

    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ProactiveLiving" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ProactiveLiving.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
