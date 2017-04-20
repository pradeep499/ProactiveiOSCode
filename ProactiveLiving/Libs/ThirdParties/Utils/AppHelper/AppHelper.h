//
//  AppHelper.h
//  ProactiveLiving
//
//  Created by Hitesh on 1/12/16.
//  Copyright © 2016 MaverickHitesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "Services.h"

@interface AppHelper : NSObject {
    
}


+(void)saveToUserDefaults:(id)value withKey:(NSString*)key;
+(id)userDefaultsForKey:(NSString*)key;
+(void)removeFromUserDefaultsWithKey:(NSString*)key;
+(void)showAlertWithTitle:(NSString*)title message:(NSString*)message tag:(NSInteger)tag delegate:(id)delegate cancelButton:(NSString*)cancelButton otherButton:(NSString*)otherButton;
+ (UIColor *)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+(void)addShadowOnView:(UIView *)view;
+(void)addShadowOnView:(UIView *)view withOffset:(CGSize)shadowOffset withColor:(UIColor *)color;
+ (UIImage *)imageFromColor:(UIColor *)color;
+(void)setBorderOnView:(id)view;
+(NSString *)timeFormattedFromSeconds:(int)totalSeconds;
+(NSString *)dayFromDateString:(NSString *)dateString;
+(NSString *)convertUTCFormattedDate:(NSString *)strDate;
+ (void)addEventToPhoneCalendarWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate withTitle:(NSString *)title withNotes:(NSString *)notes;

+(UIStoryboard*)getStoryBoard;
+(UIStoryboard*)getSecondStoryBoard;
+(UIStoryboard*)getProfileStoryBoard;

+(UIStoryboard*)getPacStoryBoard;


@end
