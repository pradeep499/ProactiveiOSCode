//
//  ProfileVCTableCell2.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 18/02/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeNode.h"

@interface ProfileVCTableCell2 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet UIImageView *imgSideBar;
@property (retain, strong) TreeNode *treeNode;


@end
