//
//  PASInstVideoVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 30/03/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "PASInstVideoVC.h"
#import "PASInstTextVC.h"
#import "AppHelper.h"
#import "Defines.h"
#import "AppDelegate.h"
#import "AboutPASInstVC.h"

@interface PASInstVideoVC ()
{
    
}
@property (weak, nonatomic) IBOutlet UIButton *btnVideo;
@property (weak, nonatomic) IBOutlet UIView *containerView;
- (IBAction)btnVideoClick:(id)sender;

@end

@implementation PASInstVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [AppHelper setBorderOnView:self.containerView];
    // Do any additional setup after loading the view.
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

- (IBAction)btnPASInstClick:(id)sender {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        PASInstTextVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PASInstTextVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (IBAction)btnVideoClick:(id)sender {
    
    
    self.moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[AppDelegate getAppDelegate].PASInstVideo]];
    
    self.moviePlayer.moviePlayer.movieSourceType = MPMovieSourceTypeUnknown;
    [[self.moviePlayer moviePlayer] prepareToPlay];
    [[self.moviePlayer moviePlayer] setShouldAutoplay:YES];
    //[[self.moviePlayer moviePlayer] setControlStyle:MPMovieControlStyleNone];
    //[[self.moviePlayer moviePlayer] setFullscreen:YES animated:YES];
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
    
    /*
     NSURL *url = [NSURL URLWithString:
     @"http://www.ebookfrenzy.com/ios_book/movie/movie.mov"];
     
     _moviePlayer =  [[MPMoviePlayerController alloc]
     initWithContentURL:url];
     [_moviePlayer prepareToPlay];
     _moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(moviePlayBackDidFinish:)
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:_moviePlayer];
     
     _moviePlayer.controlStyle = MPMovieControlStyleDefault;
     [_moviePlayer play];
     [self.view addSubview:_moviePlayer.view];
     [_moviePlayer setFullscreen:YES animated:YES];
     */
}

- (void)MPMoviePlayerLoadStateDidChange:(NSNotification *)notification
{
//    NSLog(@"loadstate change: %lu", (unsigned long)[self.moviePlayer moviePlayer].loadState);
//    
//    if (([self.moviePlayer moviePlayer].loadState & MPMovieLoadStatePlayable) == MPMovieLoadStatePlayable)
//    {
//        NSLog(@"yay, it became playable");
//    }
}

-(void)moviePlaybackDidFinish
{
    NSLog(@"Movie finished!!!");
}
@end
