//
//  ContactFriendsVC.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 19/05/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol phoneSelectForInviteFriends <NSObject>
-(void)getSelectedPhone:(NSString*)phoneNumber;
@end
@interface ContactFriendsVC : UIViewController
@property (nonatomic, weak) id <phoneSelectForInviteFriends> delegate;

@end
