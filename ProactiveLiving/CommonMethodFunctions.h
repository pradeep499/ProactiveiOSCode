//
//  CommonMethodFunctions.h
//  Quorier
//
//  Created by Sakshi on 2/3/15.
//  Copyright (c) 2015 Shariq Hussain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <AVFoundation/AVFoundation.h>
@interface CommonMethodFunctions : NSObject<MFMailComposeViewControllerDelegate>

//AlertView
+ (void) showAlertViewWithTag:(NSInteger)tag title:(NSString*)title message:(NSString*)msg delegate:(id)delegate
            cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles;

+(UIView *) GetAlertViewWithAlertText:(NSString *)alertText numberOfButtons:(int) numberOfButtons andFrame:(CGRect)frame;

//Alert Controller
+(UIAlertController*)createAlertControllerwithTitle:(NSString*)title andMessage:(NSString*)message preferreStyle:(UIAlertControllerStyle)preferredStyle andOkAction:(UIAlertAction*)okAction cancelButton:(UIAlertAction*)cancelAction;

+(float) getHeightOfDevice;

+(void)saveToUserDefaults:(id)value withKey:(NSString*)key;
+(void)saveToUserDefaultsAlbumDate:(NSDate *)value withKey:(NSString*)key;
+(NSString*)userDefaultsForKey:(NSString*)key;
+(void)removeFromUserDefaultsWithKey:(NSString*)key;

+ (BOOL)validateEmailWithString:(NSString *)email;

+(NSString*)getDeviceUDID;

+(void)makeCallOnNumber:(NSString*)contactNo;
+(BOOL)validatePhone: (NSString *) phoneNumber;

+(CGRect)labelRectForText:(NSString*)text withFont:(UIFont*)font;

-(NSString *)calculateTimeDifferenceWith:(NSString *)previousdate;
+(NSDate*)setMaximumDateUsingDate : (NSDate*) stratDate subtractingYears:(int)value;

+(UIImage *)generatePhotoThumbnail:(UIImage *)image;
+(UIImage *)generatePhotoThumbnail1:(UIImage *)image;

+(UIImage *)getThumbNail:(NSURL*)videoURL;
+ (void)convertVideoToLowQuailtyWithInputURL:(NSURL*)inputURL
                                   outputURL:(NSURL*)outputURL
                                     handler:(void (^)(AVAssetExportSession*))handler;

+(CGSize)sizeOfCell:(NSString*)str fontSize:(CGFloat)size width:(float)weigth fontName:(NSString*)fontName;
+(CGFloat)widthOfText:(NSString*)str fontSize:(int)size height:(float)height fontName:(NSString*)fontName;
+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width;
+(UIImage *)generateThumbImage: (NSURL *)fileUrl;

+(NSInteger)nextIdentifies;
+(NSInteger)nextChatIdentifies;
@end

@interface NSObject (NullCheck)

- (BOOL)isNull;
- (BOOL)isNotNull;

@end


@interface NSString (TrimSpaces)

-(void)trimTrailingSpaces:(NSString*)text;

@end
