//
//  BookingPopUp.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 23/03/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingPopUp : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnBook;
@property (weak, nonatomic) IBOutlet UIButton *btnSeeAll;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblDateTime;
@property (weak, nonatomic) IBOutlet UILabel *lblMsg;
@property (nonatomic, copy) NSString *strBookingDate;
@property (nonatomic,retain) NSMutableArray *arrTimings;
@property (nonatomic,retain) NSMutableArray *selectedRowsArray;

@end
