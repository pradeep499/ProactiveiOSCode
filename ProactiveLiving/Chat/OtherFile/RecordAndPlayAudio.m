//
//  RecordAndPlayAudio.m
//  ChatApp
//
//  Created by Sudeep Srivastava on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RecordAndPlayAudio.h"


@implementation RecordAndPlayAudio
@synthesize recordedTmpFile;
-(id)init
{
    NSError * error;
	toggle = YES;
	AVAudioSession * audioSession = [AVAudioSession sharedInstance];
	//[audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    
	[audioSession setActive:YES error: &error];
	UInt32 doChangeDefaultRoute = 1;
//    AudioSessionInitialize( NULL, NULL, NULL,NULL);
//    UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
//    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
//    UInt32 value = YES;
//    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(value), &value);
//    AudioSessionSetProperty(kAudioSessionProperty_OtherMixableAudioShouldDuck, sizeof(value), &value);
    
    
 //   [audioSession  overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
//         UInt32 doChangeDefaultRoute = 1;
//    
//    AudioSessionSetProperty (
//                             kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
//                             sizeof (doChangeDefaultRoute),
//                             &doChangeDefaultRoute
//                             );
    
   
    
	AudioSessionSetProperty (
							 kAudioSessionProperty_OverrideCategoryMixWithOthers,
							 sizeof (doChangeDefaultRoute),
							 &doChangeDefaultRoute);
    
    
	return self;
}




-(void)playAndStopButtClicked
{
	NSError * error;
	//if(avPlayer)
	//	{
	//		[avPlayer release];
	//		avPlayer=nil;
	//		
	//	}
	if(toggle)
	{
		
        toggle=NO;
		avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordedTmpFile error:&error];
		[avPlayer prepareToPlay];
		avPlayer.delegate=self;
		[avPlayer play];
	}
	else
    {
		[avPlayer stop];
		toggle=YES;
        if (recorder.recording)
        {
            [recorder setDelegate:nil];
            [recorder stop];
        }
        
	}
	
	
}

-(void)stopPlaying
{
    [avPlayer stop];
    toggle=YES;
    if (recorder.recording)
    {
        [recorder setDelegate:nil];
        [recorder stop];
    }
}
-(void)stopRecording
{
	toggle = YES;
	//[actSpinner stopAnimating];
    ////NSLog(@"Using File called: %@",recordedTmpFile);
	//Stop the recorder.
	[recorder setDelegate:nil];
	[recorder stop];
	
}

-(void)recordButtClicked
{
    NSError * error;
	if(toggle)
	{
		
		toggle = NO;

        
        NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithFloat:16000.0],AVSampleRateKey,
                                       [NSNumber numberWithInt:2],AVNumberOfChannelsKey,
                                       [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                       [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                       [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
                                       [NSNumber numberWithBool:0], AVLinearPCMIsBigEndianKey,
                                       [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                       [NSData data], AVChannelLayoutKey, nil];
        self.recordedTmpFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"ram%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"wav"]]];

        
        
		////NSLog(@"Using File called: %@",recordedTmpFile);
		//Setup the recorder to use this file and record to it.
        recorder = [[AVAudioRecorder alloc] initWithURL:self.recordedTmpFile settings:recordSetting error:&error];
        if (error)
        {
            //NSLog(@"error: %@", [error localizedDescription]);
            
        } else {
            //Use the recorder to start the recording.
            [recorder setDelegate:self];
            recorder.meteringEnabled = YES;
            //We call this to start the recording process and initialize
            //the subsstems so that when we actually say "record" it starts right away.
            [recorder prepareToRecord];
            //Start the actual Recording
            [recorder record];
            //[recordSetting release];
            //There is an optional method for doing the recording for a limited time see
            //[recorder recordForDuration:(NSTimeInterval) 10]
        }
		
        
	}
	else
	{
		[self stopRecording];
	}
}



- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
	toggle=YES;
	player=nil;
}

@end
