//
//  ContactsVC.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 16/05/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatContactModelClass;
@class GroupDetailVC;

@protocol phoneSelectForInvite <NSObject>
-(void)getSelectedPhone:(NSString*)phoneNumber;
@end

//MARK:- Chat Protocol
@protocol GroupChatProtocol <NSObject>
-(void)addMemberInGroup:(GroupDetailVC*)group withInfo:(ChatContactModelClass*)frndObj;
@end

@protocol SomeProtocol <NSObject>
- (void)someAction;
@end

@interface ContactsVC : UIViewController<UIGestureRecognizerDelegate>

@property (copy, nonatomic)  NSString *contactType;
@property (nonatomic, weak) id <phoneSelectForInvite> delegate;
@property (nonatomic, weak) id <GroupChatProtocol> delegate1;
@property (nonatomic, weak) id<SomeProtocol> delegate2;
@property (nonatomic,copy)NSArray *arrContacts;
-(void)createGroupWithContacts;
@end
