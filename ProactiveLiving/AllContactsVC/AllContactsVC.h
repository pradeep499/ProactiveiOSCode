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
@interface AllContactsVC : UIViewController <phoneSelectForInvite,phoneSelectForInviteFriends,GroupChatProtocol,SomeProtocol>
@property (strong, nonatomic) ContactSelectBlock contactSelectBlock;
-(void)setPhontactBlock:(ContactSelectBlock)block;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnDone;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnCreateNewGroup;
@property (copy, nonatomic) NSString *fromVC;
@property (copy, nonatomic) NSString *fromVCName;

@end
