//
//  MoreVCTableCell.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 16/02/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "MoreVCTableCell.h"
#import "AppHelper.h"

@implementation MoreVCTableCell

- (void)awakeFromNib {
    // Initialization code
    
    [AppHelper setBorderOnView:self.txtCalender];
    [AppHelper setBorderOnView:self.txtTime];
    
    [AppHelper addShadowOnView:self.btnCall withOffset:CGSizeMake(0.0, 0.5) withColor:[UIColor blackColor]];
    [AppHelper addShadowOnView:self.btnBook withOffset:CGSizeMake(0.0, 0.5) withColor:[UIColor blackColor]];
 
    //[AppHelper addShadowOnView:self.btnProfile withOffset:CGSizeMake(0.0, 0.5) withColor:[UIColor blackColor]];
    //[AppHelper addShadowOnView:self.btnSpecials withOffset:CGSizeMake(0.0, 0.5) withColor:[UIColor blackColor]];
    //[AppHelper addShadowOnView:self.btnAddToFav withOffset:CGSizeMake(0.0, 0.5) withColor:[UIColor blackColor]];
    //[AppHelper addShadowOnView:self.btnStaff withOffset:CGSizeMake(0.0, 0.5) withColor:[UIColor blackColor]];
    
    //[AppHelper addShadowOnView:self.btnLike withOffset:CGSizeMake(0.0, 0.5) withColor:[UIColor blackColor]];
    //[AppHelper addShadowOnView:self.btnJoin withOffset:CGSizeMake(0.0, 0.5) withColor:[UIColor blackColor]];
    //[AppHelper addShadowOnView:self.btnEmail withOffset:CGSizeMake(0.0, 0.5) withColor:[UIColor blackColor]];
    //[AppHelper addShadowOnView:self.btnEducation withOffset:CGSizeMake(0.0, 0.5) withColor:[UIColor blackColor]];
    
    //[AppHelper addShadowOnView:self.btnVideos withOffset:CGSizeMake(0.0, 0.5) withColor:[UIColor blackColor]];
    //[AppHelper addShadowOnView:self.btnWebsite withOffset:CGSizeMake(0.0, 0.5) withColor:[UIColor blackColor]];
    //[AppHelper addShadowOnView:self.btnShare withOffset:CGSizeMake(0.0, 0.5) withColor:[UIColor blackColor]];
    //[AppHelper addShadowOnView:self.btnChat withOffset:CGSizeMake(0.0, 0.5) withColor:[UIColor blackColor]];

    
    self.txtTimings.textContainer.lineFragmentPadding = 0;
    self.txtTimings.textContainerInset = UIEdgeInsetsZero;
    
    self.txtAddress.textContainer.lineFragmentPadding = 0;
    self.txtAddress.textContainerInset = UIEdgeInsetsZero;
    
    self.txtPopoup.textContainer.lineFragmentPadding = 0;
    self.txtPopoup.textContainerInset = UIEdgeInsetsZero;
    
    [self.popupView setHidden:YES];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)btnBookClick:(id)sender {
    
    //[AppHelper showAlertWithTitle:@"Coming Soon.." message:@"" tag:0 delegate:nil cancelButton:@"Ok" otherButton:nil];

}

- (IBAction)btnEducationClick:(id)sender {
    [AppHelper showAlertWithTitle:@"Coming Soon.." message:@"" tag:0 delegate:nil cancelButton:@"Ok" otherButton:nil];

}

- (IBAction)btnVideosClick:(id)sender {
    [AppHelper showAlertWithTitle:@"Coming Soon.." message:@"" tag:0 delegate:nil cancelButton:@"Ok" otherButton:nil];

}

- (IBAction)btnSpecialsClick:(id)sender {
    [AppHelper showAlertWithTitle:@"Coming Soon.." message:@"" tag:0 delegate:nil cancelButton:@"Ok" otherButton:nil];

}

- (IBAction)btnJoinClick:(id)sender {
    [AppHelper showAlertWithTitle:@"Coming Soon.." message:@"" tag:0 delegate:nil cancelButton:@"Ok" otherButton:nil];

}

- (IBAction)btnWebsiteClick:(id)sender {
    [AppHelper showAlertWithTitle:@"Coming Soon.." message:@"" tag:0 delegate:nil cancelButton:@"Ok" otherButton:nil];

}

- (IBAction)btnAddToFavoClick:(id)sender {
    [AppHelper showAlertWithTitle:@"Coming Soon.." message:@"" tag:0 delegate:nil cancelButton:@"Ok" otherButton:nil];

}

- (IBAction)btnLikeClick:(id)sender {
    [AppHelper showAlertWithTitle:@"Coming Soon.." message:@"" tag:0 delegate:nil cancelButton:@"Ok" otherButton:nil];

}

- (IBAction)btnShareClick:(id)sender {
    [AppHelper showAlertWithTitle:@"Coming Soon.." message:@"" tag:0 delegate:nil cancelButton:@"Ok" otherButton:nil];

}

- (IBAction)btnStaffClick:(id)sender {
    [AppHelper showAlertWithTitle:@"Coming Soon.." message:@"" tag:0 delegate:nil cancelButton:@"Ok" otherButton:nil];

}

- (IBAction)btnEmailClick:(id)sender {
    [AppHelper showAlertWithTitle:@"Coming Soon.." message:@"" tag:0 delegate:nil cancelButton:@"Ok" otherButton:nil];

}

- (IBAction)btnChatClick:(id)sender {
    [AppHelper showAlertWithTitle:@"Coming Soon.." message:@"" tag:0 delegate:nil cancelButton:@"Ok" otherButton:nil];

}
@end
