//
//  TreeNode.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 23/02/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeNode : NSObject

@property (nonatomic) NSUInteger nodeLevel;
@property (nonatomic) BOOL isExpanded;
@property (nonatomic, strong) id nodeObject;
@property (nonatomic, strong) NSMutableArray *nodeChildren;

@end
