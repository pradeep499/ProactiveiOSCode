//
//  JCTagCell.m
//  JCTagListView
//
//  Created by 李京城 on 15/7/3.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "JCTagCell.h"
#import "Defines.h"

@implementation JCTagCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1.0f;
        
        UIImage *image=[UIImage imageNamed:@"annoation"];
        self.annotImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [self.annotImage setImage:image];
        [self.annotImage setContentMode:UIViewContentModeScaleAspectFit];
        [self.contentView addSubview:self.annotImage];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.annotImage.frame.size.width, 0, self.bounds.size.width-self.annotImage.frame.size.width, self.annotImage.frame.size.height)];
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        self.titleLabel.font = [UIFont fontWithName:FONT_REGULAR size:13.0f];
        [self.contentView addSubview:self.titleLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = self.bounds;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.titleLabel.text = @"";
}

@end
