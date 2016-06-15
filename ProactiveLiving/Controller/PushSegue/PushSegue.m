//
//  PushSegue.m
//  We Own You
//
//  Created by Hitesh on 11/28/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "PushSegue.h"
#import "AppHelper.h"
#import "Defines.h"

@implementation PushSegue
-(void) perform
{
    if([AppHelper userDefaultsForKey:uId])
    {
        [[[self sourceViewController] navigationController] pushViewController:[self destinationViewController] animated:NO];
    }
    else
    {
        [[[self sourceViewController] navigationController] pushViewController:[self destinationViewController] animated:YES];
    }
}
@end
