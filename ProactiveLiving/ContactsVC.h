//
//  ContactsVC.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 16/05/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol phoneSelectForInvite <NSObject>
-(void)getSelectedPhone:(NSString*)phoneNumber;
@end

@interface ContactsVC : UIViewController
@property (copy, nonatomic)  NSString *contactType;
@property (nonatomic, weak) id <phoneSelectForInvite> delegate;
@property (nonatomic,copy)NSArray *arrContacts;

@end
