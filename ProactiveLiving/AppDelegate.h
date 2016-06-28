//
//  AppDelegate.h
//  ProactiveLiving
//
//  Created by Hitesh on 1/12/16.
//  Copyright © 2016 MaverickHitesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (AppDelegate*)getAppDelegate;
+(BOOL)checkInternetConnection;//global method to check internet connectivity throughout app
+ (void)showProgressHUDWithStatus:(NSString *)status;
+ (void)dismissProgressHUD;
+(void)connectedCompletionBlock:(void(^)(BOOL connected))block;

-(void)getStaticData;
@property(nonatomic,strong) CLLocation *currentLocation;
@property (nonatomic, copy) NSString *PASInst;
@property (nonatomic, copy) NSString *PASInstVideo;
@property (nonatomic, copy) NSString *aboutPAS;


@end

