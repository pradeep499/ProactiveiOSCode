//
//  MessageCell.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 20/05/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    // Initialization code
    self.txtMessage.textContainerInset = UIEdgeInsetsZero;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
