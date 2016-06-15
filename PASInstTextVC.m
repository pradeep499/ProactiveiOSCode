//
//  PASInstTextVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 30/03/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "PASInstTextVC.h"
#import "AppHelper.h"
#import "AppDelegate.h"
#import "Defines.h"
#import "AboutPASInstVC.h"

@interface PASInstTextVC ()
@property (weak, nonatomic) IBOutlet UITextView *txtPASInst;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation PASInstTextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [AppHelper setBorderOnView:self.containerView];
    self.txtPASInst.text=[AppDelegate getAppDelegate].PASInst;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackClick:(id)sender {
    //back to previous view controller
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnInfoClick:(id)sender {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        AboutPASInstVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutPASInstVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
