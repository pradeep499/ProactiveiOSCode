//
//  CustonTabBarController.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 06/04/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustonTabBarController : UITabBarController
@property (nonatomic, strong) UIButton* middleButton;

-(void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated completion:(void (^)(BOOL))completion;
-(void)setCenterImage;
@end
