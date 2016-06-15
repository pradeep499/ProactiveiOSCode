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
@property (weak, nonatomic) IBOutlet UILabel *lblMsg;
@property (weak, nonatomic) IBOutlet UILabel *lblPASInfo;
@property (weak, nonatomic) IBOutlet UIView *dimView;

@end
