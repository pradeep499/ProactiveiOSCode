//
//  UICustomCheckBox.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 10/06/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UICustomCheckBoxDelegate <NSObject>

- (void)checkBoxTapped:(UIControl *)checkbox status:(BOOL)status;

@end

@interface UICustomCheckBox : UIControl
@property (nonatomic, weak) id <UICustomCheckBoxDelegate> delegate;

-(void)setChecked:(BOOL)boolValue;
-(void)setDisabled:(BOOL)boolValue;
-(void)setTheChecked:(BOOL)boolValue ;

@property(nonatomic, assign) BOOL checked;
@property(nonatomic, assign) BOOL disabled;
@end
