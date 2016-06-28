//
//  MyPAStodoVC.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 24/06/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPAStodoVC : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *menuCollection;
@property (copy, nonatomic) NSString *menuTitle;
@property (copy, nonatomic) NSArray *arrMenueImages;
@end
