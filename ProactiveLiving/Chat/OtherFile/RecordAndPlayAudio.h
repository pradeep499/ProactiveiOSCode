//
//  RecordAndPlayAudio.h
//  ChatApp
//
//  Created by Sudeep Srivastava on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import<AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface RecordAndPlayAudio : NSObject<AVAudioPlayerDelegate,AVAudioRecorderDelegate> {

	BOOL toggle;
	//Variables setup for access in the class:
	
    AVAudioRecorder * recorder;
	AVAudioPlayer * avPlayer;
}
@property(nonatomic,retain) NSURL * recordedTmpFile;
-(void)playAndStopButtClicked;
-(void)stopRecording;
-(void)recordButtClicked;
-(void)stopPlaying;
@end
