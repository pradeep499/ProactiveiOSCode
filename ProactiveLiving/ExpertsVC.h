//
//  ExpertsVC.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 14/04/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpertsVC : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *menuCollection;
@property (weak, nonatomic) IBOutlet UILabel *screenTitle;
@property (copy, nonatomic) NSString *menuTitle;
@property (copy, nonatomic) NSArray *arrMenueImages;
@end
