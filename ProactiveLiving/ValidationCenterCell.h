//
//  ValidationCenterCell.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 27/01/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASStarRatingView.h"

@interface ValidationCenterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgBuilding;
@property (weak, nonatomic) IBOutlet UILabel *lblCenterName;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblServices;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UILabel *lblPIN;
@property (weak, nonatomic) IBOutlet UILabel *lblReviews;
@property (weak, nonatomic) IBOutlet UIView *viewSideStrip;
@property (weak, nonatomic) IBOutlet UIButton *btnBook;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGStrip;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblOrgType;
@property (weak, nonatomic) IBOutlet ASStarRatingView *viewRatings;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblAddressTOP;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgLocationTOP;


@end
