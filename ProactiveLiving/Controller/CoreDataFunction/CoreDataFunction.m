//
//  CoreDataFunction.m
//  ProactiveLiving
//
//  Created by Hitesh on 1/12/16.
//  Copyright © 2016 MaverickHitesh. All rights reserved.
//

#import "CoreDataFunction.h"

@implementation CoreDataFunction
static CoreDataFunction *singletonInstance = nil;
#pragma mark - init
- (id)init{
    self = [super init];
    if (self){
        managedObjectContext = [[AppDelegate getAppDelegate] managedObjectContext];
    }
    return self;
}
#pragma mark - sharedInstance
+(CoreDataFunction *) sharedInstance {
    if (nil != singletonInstance) return singletonInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        singletonInstance = [[CoreDataFunction alloc] init];
    });
    
    return singletonInstance;
}
/*#pragma mark - getBasicRequestForEntityName
- (NSFetchRequest *)getBasicRequestForEntityName: (NSString *)entityName{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    return request;
}
#pragma mark - getUserProfileModel
-(UserInfo *)getUserProfileModel:(NSString*)userId{
    //NSLog(@"%@",userId);
    NSFetchRequest *request = [self getBasicRequestForEntityName:@"UserInfo"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId=%@", userId];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    //NSLog(@"%@",results);
    
    UserInfo *userObj = nil;
    if (!error && [results count] > 0){
        userObj = [results objectAtIndex:0];
    }
    if (error){
        //NSLog(@"fetch request error = %@", [error localizedDescription]);
    }
    
    return userObj;
}
#pragma mark - insertUserInfo
-(void)insertUserInfo:(NSDictionary*)dictionary
{
    UserInfo *userObj = nil;
    userObj = [self getUserProfileModel:[dictionary objectForKey:@"userId"]];
    
    //NSLog(@"%@",userObj);
    
    if(!userObj){
        userObj =  [NSEntityDescription
                    insertNewObjectForEntityForName:@"UserInfo"
                    inManagedObjectContext:managedObjectContext];
    }
    
    if (![[dictionary  objectForKey:@"UserID"] isKindOfClass:[NSNull class]]&&([dictionary objectForKey:@"UserID"] )){
        userObj.userId = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"UserID"]];
    }
    if (![[dictionary  objectForKey:@"email"] isKindOfClass:[NSNull class]]&&([dictionary objectForKey:@"email"] )){
        userObj.email = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"email"]];
    }
    if (![[dictionary  objectForKey:@"firstName"] isKindOfClass:[NSNull class]]&&([dictionary objectForKey:@"firstName"] )){
        userObj.firstName = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"firstName"]];
    }
    if (![[dictionary  objectForKey:@"lastName"] isKindOfClass:[NSNull class]]&&([dictionary objectForKey:@"lastName"] )){
        userObj.lastName = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"lastName"]];
    }
    if (![[dictionary  objectForKey:@"middleName"] isKindOfClass:[NSNull class]]&&([dictionary objectForKey:@"middleName"] )){
        userObj.middleName = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"middleName"]];
    }
    if (![[dictionary  objectForKey:@"mobilePhone"] isKindOfClass:[NSNull class]]&&([dictionary objectForKey:@"mobilePhone"] )){
        userObj.mobilePhone = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"mobilePhone"]];
    }
    if (![[dictionary  objectForKey:@"status"] isKindOfClass:[NSNull class]]&&([dictionary objectForKey:@"status"] )){
        userObj.status = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"status"]];
    }
    if (![[dictionary  objectForKey:@"zipCode"] isKindOfClass:[NSNull class]]&&([dictionary objectForKey:@"zipCode"] )){
        userObj.zipCode = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"zipCode"]];
    }
    
    
    
    NSError *error;
    if (![managedObjectContext save:&error]){
        //NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }else{
        //NSLog(@"savedAllproduct");
    }
}
*/
@end
