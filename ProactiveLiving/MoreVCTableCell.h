//
//  MoreVCTableCell.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 16/02/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASStarRatingView.h"

@interface MoreVCTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet ASStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *lblServices;
@property (weak, nonatomic) IBOutlet UITextView *txtAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@property (weak, nonatomic) IBOutlet UITextField *txtCalender;
@property (weak, nonatomic) IBOutlet UIButton *btnBook;
@property (weak, nonatomic) IBOutlet UITextField *txtTime;
@property (weak, nonatomic) IBOutlet UITextView *txtTimings;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
- (IBAction)btnBookClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnProfile;
@property (weak, nonatomic) IBOutlet UIButton *btnEducation;
@property (weak, nonatomic) IBOutlet UIButton *btnVideos;
@property (weak, nonatomic) IBOutlet UIButton *btnSpecials;
@property (weak, nonatomic) IBOutlet UIButton *btnJoin;
@property (weak, nonatomic) IBOutlet UIButton *btnWebsite;
@property (weak, nonatomic) IBOutlet UIButton *btnAddToFav;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnStaff;
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnChat;
- (IBAction)btnEducationClick:(id)sender;
- (IBAction)btnVideosClick:(id)sender;
- (IBAction)btnSpecialsClick:(id)sender;
- (IBAction)btnJoinClick:(id)sender;
- (IBAction)btnWebsiteClick:(id)sender;
- (IBAction)btnAddToFavoClick:(id)sender;
- (IBAction)btnLikeClick:(id)sender;
- (IBAction)btnShareClick:(id)sender;
- (IBAction)btnStaffClick:(id)sender;
- (IBAction)btnEmailClick:(id)sender;
- (IBAction)btnChatClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) IBOutlet UITextView *txtPopoup;

@end
