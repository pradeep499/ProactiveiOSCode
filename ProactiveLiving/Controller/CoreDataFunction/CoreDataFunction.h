//
//  CoreDataFunction.h
//  ProactiveLiving
//
//  Created by Hitesh on 1/12/16.
//  Copyright © 2016 MaverickHitesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@interface CoreDataFunction : NSObject
{
    NSManagedObjectContext *managedObjectContext;
}

+(CoreDataFunction *) sharedInstance;
//-(void)insertUserInfo:(NSDictionary*)dictionary;
//-(UserInfo *)getUserProfileModel:(NSString*)userId;

@end
