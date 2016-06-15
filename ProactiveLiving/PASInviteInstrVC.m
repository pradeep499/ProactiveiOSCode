//
//  PASInviteInstrVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 07/06/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "PASInviteInstrVC.h"
#import "AllPasVC.h"
#import "Defines.h"
#import "AppDelegate.h"
#import "AppHelper.h"

@interface PASInviteInstrVC ()
{
}
@property (weak, nonatomic) IBOutlet UITextView *txtInstView;
@property (weak, nonatomic) IBOutlet UIButton *btnYes;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@end

@implementation PASInviteInstrVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.txtInstView.text=@"Getting a PAS helps individuals be more proactive about their health in specific and life in general. Make a difference in someone's life -- Invite them to get a PAS so they can transform their life and realize their true potential.\n\n In addition to improved health and wellbeing, other perks they get may include things like lower health insurance premiums, increased savings, and much more.\n\n Your gift is bound to keep giving as they live a life of health and prosperity - simply by being more proactive.  We can all make a difference in other peoples lives. Let us work together to create a better future for everyone.";
    [AppHelper addShadowOnView:self.btnYes withOffset:CGSizeMake(0.0, 1.0) withColor:[UIColor blackColor]];
    [AppHelper setBorderOnView:self.containerView];

}
- (IBAction)btnYesClicked:(id)sender {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        AllPasVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AllPasVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)btnBackClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
