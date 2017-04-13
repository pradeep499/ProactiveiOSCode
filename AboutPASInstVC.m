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


@interface AboutPASInstVC (){
    NSDictionary * resultDict ;
    NSString *strVideoURL;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) MPMoviePlayerViewController *moviePlayer;
@property (weak, nonatomic) IBOutlet UITextView *txtAboutPAS;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;




@end

@implementation AboutPASInstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [AppHelper setBorderOnView:self.contentView];
    
//    self.txtAboutPAS.text=[AppDelegate getAppDelegate].aboutPAS;
    
    self.lblTitle.text = self.strTitle;
    
    // api call
    [self getPasInstruction];
    
    
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

#pragma mark:- API Hit

-(void)getPasInstruction
{
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection]) {
        
        //show indicator on screen
        [AppDelegate showProgressHUDWithStatus:@""];
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
       
        [parameters setValue:self.strType forKey:@"type"];
        
        //call global web service class
        [Services postRequest:ServiceGetPasInstruction parameters:parameters completionHandler:^(NSString *err, NSDictionary *responseDict) {
            
            [AppDelegate dismissProgressHUD];//dissmiss indicator
            
            if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
            {
                if ([[responseDict objectForKey:@"error"] intValue] == 0) {
                    
                    
                   // self.dataArray=[responseDict objectForKey:@"result"];
                    NSLog(@"$#$#$# %@",responseDict);
                   // NSDictionary * resultDict = [[NSDictionary alloc] init];
                    resultDict = [responseDict objectForKey:@"result"];
                    strVideoURL = [resultDict objectForKey:@"video"];
                    self.txtAboutPAS.text= [resultDict objectForKey:@"about"];
                    
                    
                }
                else
                {
                    [AppHelper showAlertWithTitle:[responseDict objectForKey:@"errorMsg"] message:@"" tag:0 delegate:nil cancelButton:ok otherButton:nil];
                    
                }
                
            }
            else
                [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
            
        } ];
        
        
        
    }
    else
        //show internet not available
        [AppHelper showAlertWithTitle:netError message:netErrorMessage tag:0 delegate:nil cancelButton:ok otherButton:nil];
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
    
    
    self.moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:strVideoURL]];
    
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
