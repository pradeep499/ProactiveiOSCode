//
//  UploadInS3.m
//  YourBubble
//
//  Created by Mahendra Yadav on 7/24/15.
//  Copyright (c) 2015 Jyoti. All rights reserved.
//

#import "UploadInS3.h"
#import "ProactiveLiving-Swift.h"


#define AWS_ACCESS_KEY_ID                                       @"AKIAJ47XZOVZVDUDNIGA"
#define AWS_SECRET_KEY                                          @"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"
#define AWS_MEDIA_BUCKET                                        @"melder"
#define AWS_Image_Folder_Name                                   @"meldermedia"

@interface UploadInS3()<AmazonServiceRequestDelegate>

@property (nonatomic, retain) AmazonS3Client *s3;
@property (nonatomic, assign) S3UploadRequest s3UploadRequest;
@property (nonatomic, retain) NSString *mediaName;
@property (nonatomic, retain) NSString *videoS3Url;
@property (nonatomic, retain) NSString *fileName;

@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionUploadTask *uploadTask;
@property (strong, nonatomic) NSURL *uploadFileURL;

@end

@implementation UploadInS3{
    s3Handler _completionHandler;
    s3Progress _completionHandlerProgress;
}


@synthesize s3UploadRequest;
@synthesize mediaName;
@synthesize videoS3Url;
@synthesize dicS3;
@synthesize fileName;
@synthesize strFilesName;
@synthesize progress_;
@synthesize chatImagesFiles;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.dicS3=[NSMutableDictionary dictionary];
        self.chatImagesFiles=[NSMutableArray array];
        
        self.s3UploadRequest=0;
        self.mediaName=@"";
        self.videoS3Url=@"";
        self.s3 = [[AmazonS3Client alloc] initWithAccessKey:AWS_ACCESS_KEY_ID withSecretKey:AWS_SECRET_KEY];
        self.s3.endpoint = [AmazonEndpoints s3Endpoint:US_EAST_1];
        [AmazonErrorHandler shouldNotThrowExceptions];
        
    }
    return self;
}

+ (id)sharedGlobal {
    
    static UploadInS3 *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


-(void)upload:(NSData*)dataToUpload inBucket:(NSString*)bucket forKey:(NSString*)key
{
    bool using3G = true;
    
    @try {
        
        S3CreateBucketRequest *cbr = [[S3CreateBucketRequest alloc] initWithName:bucket];
        [self.s3 createBucket:cbr];
        
        S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:key inBucket:bucket];
        
        // The S3UploadInputStream was deprecated after the release of iOS6.
        S3UploadInputStream *stream = [S3UploadInputStream inputStreamWithData:dataToUpload];
        
       /* if ( using3G ) {
            // If connected via 3G "throttle" the stream.
            stream.delay = 0.2; // In seconds
            stream.packetSize = 16; // Number of 1K blocks
        }*/
        
        por.contentLength = [dataToUpload length];
        por.stream = stream;
        
        [self.s3 putObject:por];
    }
    @catch ( AmazonServiceException *exception ) {
        NSLog( @"Upload Failed, Reason: %@", exception );
    }	
}
- (void)uploadMultipleImagesOnChatTos3:(NSData *)imageToUpload type:(int)imageOrVideo dictInfo:(NSDictionary*)dic fromDist:(NSString*)classType meldID:(NSString*)meldFileName completion:(s3Handler)completionBlock completionProgress:(s3Progress)completionBlockProgress{
    
   // NSLog(@"%@",dic);
    
    NSString *fileContentTypeStr = @"image/png";
    
    if (![classType isEqualToString:@"Create Meld"]) {
        
        // For chat screen type ======
        self.progressView.progress = 0;
        
        if(imageOrVideo==0){
            self.mediaName=[NSString stringWithFormat:@"%@/%@",AWS_Image_Folder_Name,meldFileName];
            self.strFilesName = meldFileName;
        }
        else if(imageOrVideo==1){
            fileContentTypeStr = @"video/mp4";
            self.mediaName=[NSString stringWithFormat:@"%@/%@",AWS_Image_Folder_Name,meldFileName];
            self.strFilesName = meldFileName;
            
            
        }
        else if(imageOrVideo==2){
            fileContentTypeStr = @"audio/mp3";
            self.mediaName=[NSString stringWithFormat:@"%@/%@",AWS_Image_Folder_Name,meldFileName];
            self.strFilesName = meldFileName;
            
        }
    }
    
    _completionHandler=[completionBlock copy];
    _completionHandlerProgress = [completionBlockProgress copy];

    if(imageToUpload==nil)
        return;
    
    
    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:self.mediaName inBucket:AWS_MEDIA_BUCKET];
    por.contentType =fileContentTypeStr;
    
    if (![classType isEqualToString:@"Create Meld"]) {
        if(imageOrVideo==1){
            self.s3UploadRequest=VideoUploadRequest;
        }
        else if (imageOrVideo==0)
        {
            self.s3UploadRequest=ImageUploadRequest;
            if (![self.chatImagesFiles containsObject:meldFileName]) {
                
                NSMutableDictionary*dictChat3=[NSMutableDictionary dictionary];
                [dictChat3 setObject:meldFileName forKey:@"chatImagesName"];
                [dictChat3 setObject:dic forKey:@"chatImgDicInfo"];
                
                [self.chatImagesFiles addObject:dictChat3];
            }
            
        }
        else{
            self.s3UploadRequest=ImageUploadRequest;
        }
        
    }
  //  NSLog(@"Final s3 server dict ===%@",chatImagesFiles);

    por.data = imageToUpload;
    por.delegate = self;
    [self.s3 putObject:por];
    
}





- (void)uploadImageTos3:(NSData *)imageToUpload type:(int)imageOrVideo fromDist:(NSString*)classType meldID:(NSString*)meldFileName completion:(s3Handler)completionBlock  completionProgress:(s3Progress)completionBlockProgress{
    
    /* if (self.uploadTask)
     {
     return;
     }*/
    
    
    //NSLog(@"imageOrVideo type =========  %d", imageOrVideo);
    
    NSString *fileContentTypeStr = @"image/png";
    if ([classType isEqualToString:@"Create Meld"]) {
        
        // For create and edit meld type ======
        if(imageOrVideo==0){
            self.mediaName=[NSString stringWithFormat:@"%@/%@",AWS_Image_Folder_Name,meldFileName];
        }
        else if (imageOrVideo==1)
        {
            self.mediaName=[NSString stringWithFormat:@"%@/%@",AWS_Image_Folder_Name,meldFileName];
        }
        else if (imageOrVideo==2)
        {
            self.mediaName=[NSString stringWithFormat:@"%@/%@",AWS_Image_Folder_Name,meldFileName];
        }
        else if (imageOrVideo==3)
        {
            fileContentTypeStr = @"video/mp4";
            self.mediaName=[NSString stringWithFormat:@"%@/%@",AWS_Image_Folder_Name,meldFileName];
        }
        else
        {
            self.mediaName=[NSString stringWithFormat:@"%@/%@",AWS_Image_Folder_Name,meldFileName];
        }
    }
    else
    {
        // For chat screen type ======
        self.progressView.progress = 0;

        if(imageOrVideo==0){
            self.mediaName=[NSString stringWithFormat:@"%@/%@",AWS_Image_Folder_Name,meldFileName];
            self.strFilesName = meldFileName;
        }
       else if(imageOrVideo==1){
            fileContentTypeStr = @"video/mp4";
            self.mediaName=[NSString stringWithFormat:@"%@/%@",AWS_Image_Folder_Name,meldFileName];
           self.strFilesName = meldFileName;

           
        }
       else if(imageOrVideo==2){
           
           fileContentTypeStr = @"audio/mp3";
           self.mediaName=[NSString stringWithFormat:@"%@/%@",AWS_Image_Folder_Name,meldFileName];
           self.strFilesName = meldFileName;
           
           
       }
    }
    
  //  NSLog(@"%@",self.mediaName);
    
    _completionHandler=[completionBlock copy];
    _completionHandlerProgress = [completionBlockProgress copy];
    
    
    /*  static NSURLSession *session = nil;
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
     NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.yourBubble1"];
     session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
     });
     
     self.session = session;
     */
    
    
    
    // Create a test file in the temporary directory

    if(imageToUpload==nil)
        return;
    
    
    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:self.mediaName inBucket:AWS_MEDIA_BUCKET];
    por.contentType =fileContentTypeStr;
    
    if ([classType isEqualToString:@"Create Meld"]) {
        
        if(imageOrVideo==0){
            self.s3UploadRequest=ImageUploadRequest;
            
            [self.dicS3 setObject:meldFileName forKey:@"image1"];
            
        }
        else if (imageOrVideo==1)
        {
            self.s3UploadRequest=Image2UploadRequest;
            [self.dicS3 setObject:meldFileName forKey:@"image2"];
            
        }
        else if (imageOrVideo==2)
        {
            self.s3UploadRequest=Image3UploadRequest;
            [self.dicS3 setObject:meldFileName forKey:@"image3"];
            
        }
        else if (imageOrVideo==3)
        {
            self.s3UploadRequest=VideoUploadRequest;
            [self.dicS3 setObject:meldFileName forKey:@"meld_video"];
            
            
        }
        else
        {
            self.s3UploadRequest=VideoImageRequest;
            [self.dicS3 setObject:meldFileName forKey:@"video_thumb"];
        }
    }
    else
    {
        //For chat
 
        
        if(imageOrVideo==1){
            self.s3UploadRequest=VideoUploadRequest;
        }
       else if (imageOrVideo==0)
       {
              self.s3UploadRequest=ImageUploadRequest;
           if (![self.chatImagesFiles containsObject:meldFileName]) {
              
               [self.chatImagesFiles addObject:meldFileName];
           }
           
       }
       else{
              self.s3UploadRequest=ImageUploadRequest;
       }
    }
    
   
    
   // NSLog(@"Final s3 server dict ===%@",dicS3);
    
    /* NSData *data = [[NSFileManager defaultManager] contentsAtPath:@"/Users/Sagar_Dabas/Desktop/output.mp4"];
     NSURL *uploadURL = [NSURL fileURLWithPath:@"/Users/Sagar_Dabas/Desktop/hey.mp4"];
     NSData *data1 = [[NSFileManager defaultManager] contentsAtPath:[uploadURL path]];
     */
    
    
    
    //NSLog(@"url1 is in upload..........");
    por.data = imageToUpload;
    por.delegate = self;
    [self.s3 putObject:por];
    
    
    
}
-(void)resetDictIntialPosistion {
    
    [self.dicS3 removeAllObjects];
    
    //NSLog(@"After ==resetDictIntialPosistion %@",self.dicS3);
}

-(void)request:(AmazonServiceRequest *)request didSendData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite{
    
    
   // NSLog(@"Request %@",request.url);
    
   // NSLog(@"taotl didSendData :totalBytesWritten %lld and sent: %lld",totalBytesWritten,bytesWritten);
    
    float progress= (float)totalBytesWritten/(float)totalBytesExpectedToWrite;
    self.progress_ =(double)progress;
     _completionHandlerProgress(false, self.progress_);
   // NSLog(@"Progress value:%.2f",progress);
//    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithFloat:progress],@"progress", nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"Upload_progress" object:nil userInfo:dic];
    
    
    
    
  //  self.progressView=[ChatListner getChatListnerObj].chatProgressV
    
    /*
    var progress: Float = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite);
    progressV =     ChatListner .getChatListnerObj().chatProgressV[str] as PICircularProgressView
    progressV.progress=Double(progress);
     */

}

-(void)request:(AmazonServiceRequest *)request didReceiveResponse:(NSURLResponse *)response{
   // NSLog(@"response is %@",response);
}

-(void)request:(AmazonServiceRequest *)request didReceiveData:(NSData *)data{
    
   // NSLog(@"data received is %@",data);
}

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
//    if (self.s3UploadRequest==ImageUploadRequest) {
//        
//        [self.dicS3 setObject:self.mediaName forKey:@"image1"];
//    }
//    else if (self.s3UploadRequest==Image2UploadRequest) {
//        
//        [self.dicS3 setObject:self.mediaName forKey:@"image2"];
//    }
//    else if (self.s3UploadRequest==Image3UploadRequest) {
//        
//        [self.dicS3 setObject:self.mediaName forKey:@"image3"];
//    }
//    else if (self.s3UploadRequest==VideoImageRequest) {
//        
//        [self.dicS3 setObject:self.mediaName forKey:@"video_thumb"];
//    }
//    else if (self.s3UploadRequest==VideoUploadRequest) {
//        
//        [self.dicS3 setObject:self.mediaName forKey:@"meld_video"];
//    }
    
    //NSLog(@"AmazonServiceRequest = response = dicS3 ==== %@",self.dicS3);
    [self MedaiUrl];
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
//    NSLog(@"error========%@",error);
//    [[AppDelegate ] hideActivityViewer];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME
//                                                    message:ERROR_SomethingWentWrong
//                                                   delegate:self
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
    
    _completionHandler(false,nil);
    
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


-(NSString *)getMediaUniqeNamewithType:(NSString *)type
{
    NSString *uniqueImageName=[NSString stringWithFormat:@"%@_%f",type,[[NSDate date] timeIntervalSince1970]];
    return uniqueImageName;
}

-(void) MedaiUrl
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
        
        
        S3GetPreSignedURLRequest *gpsur = [[S3GetPreSignedURLRequest alloc] init];
        
        switch (self.s3UploadRequest)
        {
            case ImageUploadRequest:
            {
                override.contentType = @"image/jpeg";
            }
                break;
            case Image2UploadRequest:
            {
                override.contentType = @"image/jpeg";
            }
            break;
            case Image3UploadRequest:
            {
                override.contentType = @"image/jpeg";
            }
              break;
            case VideoUploadRequest:
            {
                override.contentType = @"video/mp4";
            }
                break;
            case VideoImageRequest:
            {
                override.contentType = @"image/jpeg";
            }
                break;
            default:
                break;
        }
        gpsur.key = self.mediaName;
        gpsur.bucket = AWS_MEDIA_BUCKET;
        gpsur.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 60*60*24*365*20];
        gpsur.responseHeaderOverrides = override;
        
        NSError *error = nil;
        NSURL *url = [self.s3 getPreSignedURL:gpsur error:&error];
        NSString * imageURL = [url absoluteString];
         NSLog(@"%@",imageURL);
        if(url == nil)
        {
            if(error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
               
                });
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
            _completionHandler(true,imageURL);
            });
            
//            if (self.s3UploadRequest==ImageUploadRequest) {
//               
//                [self.dicS3 setObject:self.mediaName forKey:@"image1"];
//            }
//           else if (self.s3UploadRequest==Image2UploadRequest) {
//               
//                  [self.dicS3 setObject:self.mediaName forKey:@"image2"];
//            }
//           else if (self.s3UploadRequest==Image3UploadRequest) {
//               
//                 [self.dicS3 setObject:self.mediaName forKey:@"image3"];
//           }
//           else if (self.s3UploadRequest==VideoImageRequest) {
//               
//              [self.dicS3 setObject:self.mediaName forKey:@"video_thumb"];
//           }
//           else if (self.s3UploadRequest==VideoUploadRequest) {
//               
//               [self.dicS3 setObject:self.mediaName forKey:@"meld_video"];
//           }
            
           // NSLog(@"dicS3 ==== %@",self.dicS3);
            
           /* if(self.s3UploadRequest==ImageUploadRequest)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                   NSLog(@"%@",imageURL);
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editProfileResponse:) name: Notification_editProfile object:nil];
                    
                    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:SecurityKey_For_WholeApp,@"appkey", nil];
                    [dict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userSessionId"] forKey:@"sessionid"];
                    [dict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] forKey:@"userid"];
                    [dict setObject:settingsView.editProfilePage._nameTextField.text forKey:@"name"];
                    [dict setObject:settingsView.editProfilePage._countryCodeTextField.text forKey:@"countrycode"];
                    [dict setObject:settingsView.editProfilePage._phoneTextField.text forKey:@"phone"];
                    [dict setObject:settingsView.editProfilePage._birthdayTextField.text forKey:@"birthday"];
                    [dict setObject:settingsView.editProfilePage._emailTextField.text forKey:@"email"];
                    [dict setObject:imageURL forKey:@"imageurl"];
                    
                    //NSLog(@"dict %@",dict);
                    [[VerifyServiceClass sharedController]editProfile:dict];
                });*/
            }
        
    });
}



@end
