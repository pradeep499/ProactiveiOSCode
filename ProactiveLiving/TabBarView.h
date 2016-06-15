//
//  TabBarView.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 25/02/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TabBarView;

@protocol TabViewDelegate <NSObject>
-(void)tabView:(TabBarView *)tabView didSelectTabAtIndex:(NSUInteger)itemIndex;
@end

@interface TabBarView : UIView
{
    
}
@property (nonatomic,assign) IBOutlet id<TabViewDelegate> delegate;

@end
