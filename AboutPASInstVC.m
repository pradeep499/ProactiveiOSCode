//
//  AboutPASInstVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 30/03/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "AboutPASInstVC.h"
#import "PASInstVideoVC.h"
#import "AppHelper.h"
#import "Defines.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>


@interface AboutPASInstVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) MPMoviePlayerViewController *moviePlayer;
@property (weak, nonatomic) IBOutlet UITextView *txtAboutPAS;

@end

@implementation AboutPASInstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [AppHelper setBorderOnView:self.contentView];
    self.txtAboutPAS.text=[AppDelegate getAppDelegate].aboutPAS;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = self.contentView.frame.size;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackClick:(id)sender {
    //back to previous view controller
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnPASInstClick:(id)sender {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        PASInstVideoVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PASInstVideoVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (IBAction)btnVideoClick:(id)sender {
    
    
    self.moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[AppDelegate getAppDelegate].PASInstVideo]];
    
    self.moviePlayer.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
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
