//
//  UploadInS3.h
//  YourBubble
//
//  Created by Mahendra Yadav on 7/24/15.
//  Copyright (c) 2015 Jyoti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSRuntime/AWSRuntime.h>
#import <AWSS3/AWSS3.h>
#import <objc/runtime.h>


typedef enum
{
    VideoFeedType,
    ImageFeedType,
    TextFeedType,
    CheckinFeedType,
    
}FeedType;


typedef enum
{
    ImageUploadRequest=0,
    Image2UploadRequest=1,
    Image3UploadRequest=2,
    
    VideoUploadRequest=3,
    VideoImageRequest=4,
}S3UploadRequest;


typedef void (^operationFinishedBlockTH)(id responseData);
typedef void (^s3Handler)(BOOL success, NSString * urlString);

typedef void (^s3Progress)(BOOL success, double progress);

@interface UploadInS3 : NSObject<NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>


@property(retain,nonatomic) NSMutableDictionary * dicS3;
@property(retain,nonatomic) NSMutableArray * chatImagesFiles;
@property(retain,nonatomic) NSString * strFilesName;
@property (nonatomic) double progress_;
-(void)resetDictIntialPosistion;
+ (id)sharedGlobal;
//- (void)uploadImageTos3:(NSData *)imageToUpload type:(int)imageOrVideo completion:(s3Handler)completionBlock;

//- (void)uploadImageTos3:(NSData *)imageToUpload type:(int)imageOrVideo meldID:(NSString*)meldId completion:(s3Handler)completionBlock;

- (void)uploadImageTos3:(NSData *)imageToUpload type:(int)imageOrVideo fromDist:(NSString*)classtype meldID:(NSString*)meldFileName completion:(s3Handler)completionBlock completionProgress:(s3Progress)completionBlockProgress;

- (void)uploadMultipleImagesOnChatTos3:(NSData *)imageToUpload type:(int)imageOrVideo dictInfo:(NSDictionary*)dic fromDist:(NSString*)classType meldID:(NSString*)meldFileName completion:(s3Handler)completionBlock completionProgress:(s3Progress)completionBlockProgress;

@end
