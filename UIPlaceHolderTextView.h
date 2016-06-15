//
//  UIPlaceHolderTextView.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 09/06/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;
@property (nonatomic, retain) UIImage *placeholderImage;

-(void)textChanged:(NSNotification*)notification;

@end