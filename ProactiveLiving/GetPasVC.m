//
//  GetPasVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 25/02/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "GetPasVC.h"
#import "AppHelper.h"
#import "Defines.h"
#import "PASToDoVC.h"
#import "AboutPASInstVC.h"
#import "AppDelegate.h"
#import "ValidationCentersVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SettingsMainVC.h"


@interface GetPasVC ()
@property (weak, nonatomic) IBOutlet UIButton *btnGetMyPAS;
@property (weak, nonatomic) IBOutlet UITextView *txtDetailPAS;
@property (strong, nonatomic) MPMoviePlayerViewController *moviePlayer;

- (IBAction)getMyPasClicked:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)btnInfoClick:(id)sender;
- (IBAction)btnVideoClick:(id)sender;

@end

@implementation GetPasVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [AppHelper addShadowOnView:self.btnGetMyPAS withOffset:CGSizeMake(0.0, 1.0) withColor:[UIColor blackColor]];
    
    //TextView scrolling fix-up iOS7+
    self.txtDetailPAS.scrollEnabled = NO;
    self.txtDetailPAS.scrollEnabled = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}

#pragma mark - preferredStatusBarStyle
-(UIStatusBarStyle)preferredStatusBarStyle {
    // to set the light color of status bar
    return UIStatusBarStyleLightContent;
}

#pragma -mark Tab Bar items click methods
- (void)btnHomeClick {
        
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
            [self performSegueWithIdentifier:@"HomeVCScreen" sender:nil];
    }
        
}

- (void)btnMyPASClick {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        PASToDoVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PASToDoVC"];
        [self presentViewController:vc animated:NO completion:nil];
    }
}


- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getMyPasClicked:(id)sender {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        ValidationCentersVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ValidationCentersVC"];
        vc.orgType=@"Validation Centers";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - back
- (IBAction)back:(id)sender {
    //back to previous view controller
    //[self.view endEditing:YES];
    //[self.navigationController popViewControllerAnimated:YES];
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId])
    {
        SettingsMainVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsMainVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)btnInfoClick:(id)sender {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        AboutPASInstVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutPASInstVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)btnVideoClick:(id)sender {
    self.moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[AppDelegate getAppDelegate].PASInstVideo]];
    
    self.moviePlayer.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
    [[self.moviePlayer moviePlayer] prepareToPlay];
    [[self.moviePlayer moviePlayer] setShouldAutoplay:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMoviePlayerLoadStateDidChange:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackDidFinish)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    [self presentMoviePlayerViewControllerAnimated:self.moviePlayer];
    [[self.moviePlayer moviePlayer] play];
    
}
    
- (void)MPMoviePlayerLoadStateDidChange:(NSNotification *)notification
{
    
}
    
-(void)moviePlaybackDidFinish
{
    NSLog(@"Movie finished!!!");
}

@end
