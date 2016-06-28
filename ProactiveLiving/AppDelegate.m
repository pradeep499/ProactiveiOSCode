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

@interface AppDelegate ()
{
    UIImageView *splashView;
}

@end

@implementation AppDelegate


+(BOOL)checkInternetConnection {
    //global method to check internet connectivity throughout app
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
     // fetch and store static data
    [AppDelegate connectedCompletionBlock:^(BOOL connected) {
        if (connected)
            [self getStaticData];
        else
            NSLog(@"NOT REACHABLE");
    }];

    //Put location using ZipCode by default
    NSLog(@"location::::::> %@",[LocationManagerSingleton sharedSingleton].locationManager.location);
    
    //UISearchBar Global look n feel alteration
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:
                                                [NSDictionary dictionaryWithObjectsAndKeys:                                                                                                  [UIColor whiteColor],                                                                                                  NSForegroundColorAttributeName,                                                                                                 [UIColor whiteColor],                                                                                              NSForegroundColorAttributeName,                                                                                                  [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],                                                                                                  NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    //UITabBar Global look n feel alteration
    //[[UITabBar appearance] setTintColor:[UIColor blueColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    
    //Statusbar appearance
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

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
    
    return YES;
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

-(void)getStaticData
{
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection]) {
        
        //show indicator on screen
        //[SVProgressHUD showWithStatus:@"Please wait" maskType:SVProgressHUDMaskTypeBlack];
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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "MaverickHitesh.ProactiveLiving" in the application's documents directory.
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
#pragma mark - getAppdelegate
+ (AppDelegate*)getAppDelegate {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
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


@end
