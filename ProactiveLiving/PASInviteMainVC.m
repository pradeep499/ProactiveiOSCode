//
//  PASInviteMainVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 07/06/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "PASInviteMainVC.h"
#import "PASInviteInstrVC.h"
#import "AllPasVC.h"
#import "AppDelegate.h"
#import "AppHelper.h"
#import "Defines.h"
#import <MediaPlayer/MediaPlayer.h>

@interface PASInviteMainVC ()
@property (weak, nonatomic) IBOutlet UIButton *btnYes;
@property (strong, nonatomic) MPMoviePlayerViewController *moviePlayer;
@property (weak, nonatomic) IBOutlet UIButton *btnReadInst;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@end

@implementation PASInviteMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [AppHelper addShadowOnView:self.btnReadInst withOffset:CGSizeMake(0.0, 1.0) withColor:[UIColor blackColor]];
    [AppHelper addShadowOnView:self.btnYes withOffset:CGSizeMake(0.0, 1.0) withColor:[UIColor blackColor]];
    [AppHelper setBorderOnView:self.containerView];

}
- (IBAction)btnYesClick:(id)sender {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        AllPasVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AllPasVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)btnReadInstructionsClick:(id)sender {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        PASInviteInstrVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PASInviteInstrVC"];
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
- (IBAction)btnBackClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
