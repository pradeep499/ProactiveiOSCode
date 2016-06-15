//
//  AllContactsVC.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 17/05/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsVC.h"
#import "ContactFriendsVC.h"
typedef void (^ContactSelectBlock)(NSString*);
@interface AllContactsVC : UIViewController <phoneSelectForInvite,phoneSelectForInviteFriends>
@property (strong, nonatomic) ContactSelectBlock contactSelectBlock;
-(void)setPhontactBlock:(ContactSelectBlock)block;

@end
