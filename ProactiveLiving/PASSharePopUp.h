//
//  PASSharePopUp.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 15/06/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PASSharePopUp : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIView *dimView;

@property (nonatomic, copy) NSString* pas;
@property (nonatomic, copy) NSString* level;
@property (nonatomic, copy) NSString* rating;
@property (nonatomic, copy) NSString* date;
@property (nonatomic, retain) NSArray* employers;
@property (weak, nonatomic) IBOutlet UITextView *txtViewInst;


-(void)showPopUp;
-(void)hidePopUp;
@end
