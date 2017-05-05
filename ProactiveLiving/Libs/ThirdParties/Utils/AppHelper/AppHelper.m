//
//  AppHelper.m
//  ProactiveLiving
//
//  Created by Hitesh on 1/12/16.
//  Copyright © 2016 MaverickHitesh. All rights reserved.
//

#import "AppHelper.h"
#import "AVFoundation/AVFoundation.h"
#import <EventKitUI/EventKitUI.h>


@implementation AppHelper

+(UIStoryboard*)getStoryBoard{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+(UIStoryboard*)getSecondStoryBoard{
     
    return [UIStoryboard storyboardWithName:@"SecondStoryboard" bundle:[NSBundle mainBundle]];
}

+(UIStoryboard*)getProfileStoryBoard{
 
    return [UIStoryboard storyboardWithName:@"Profile" bundle:[NSBundle mainBundle]];
}

+(UIStoryboard*)getPacStoryBoard{
    return [UIStoryboard storyboardWithName:@"PAC" bundle:[NSBundle mainBundle]];
}

#pragma mark - saveToUserDefaults
+(void)saveToUserDefaults:(id)value withKey:(NSString*)key {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:value forKey:key];
        [standardUserDefaults synchronize];
    }
}
#pragma mark - userDefaultsForKey
+(id)userDefaultsForKey:(NSString*)key {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    id val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults objectForKey:key];
    
    return val;
}
#pragma mark - removeFromUserDefaultsWithKey
+(void)removeFromUserDefaultsWithKey:(NSString*)key {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    [standardUserDefaults removeObjectForKey:key];
    [standardUserDefaults synchronize];
}

#pragma mark - showAlertWithTitle
+(void)showAlertWithTitle:(NSString*)title message:(NSString*)message tag:(NSInteger)tag delegate:(id)delegate
            cancelButton:(NSString*)cancelButton otherButton:(NSString*)otherButton{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate
                                              cancelButtonTitle:cancelButton otherButtonTitles:otherButton, nil];
    
    alertView.tag = tag;
    alertView.delegate = delegate;
    [alertView show];
    
}

#pragma mark - addShadowOnView
+(void)addShadowOnView:(UIView *)view
{
    [view.layer setMasksToBounds:NO];
    [view.layer setShadowColor:[UIColor blackColor].CGColor];
    [view.layer setShadowOpacity:0.8f];
    [view.layer setShadowRadius:1.0];
    [view.layer setShadowOffset:CGSizeMake(-0.5, -0.5)];//Change value of X n Y as per your need of shadow to appear
    [view.layer setShadowPath: [UIBezierPath bezierPathWithRect:view.bounds].CGPath];

}

#pragma mark - addShadowOnView with Offset
+(void)addShadowOnView:(UIView *)view withOffset:(CGSize)shadowOffset withColor:(UIColor *)color
{
    [view.layer setMasksToBounds:NO];
    [view.layer setShadowColor:color.CGColor];
    [view.layer setShadowOpacity:0.5f];
    [view.layer setShadowRadius:1.0];
    [view.layer setShadowOffset:shadowOffset];//Change value to adgest shadow offset
    //[view.layer setShadowPath: [UIBezierPath bezierPathWithRect:view.bounds].CGPath];
    
}

#pragma mark - setBorderOnView
+(void)setBorderOnView:(UIView *)view
{
    view.layer.borderWidth=1.0f;
    view.layer.borderColor=[UIColor colorWithRed:235.0/255.0f green:235.0/255.0f blue:235.0/255.0f alpha:1.0].CGColor;

}

#pragma mark - colorFromHexString

// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    
    if(![hexString isEqual:[NSNull null]]&&![hexString isEqualToString:@""]&&!([hexString length]<=0) )
    {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
    }
    else
    return [UIColor lightGrayColor];
}

#pragma mark - imageFromColor
+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 10, 10);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - convertUTCFormattedDate
+ (NSString *)convertUTCFormattedDate:(NSString *)strDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    NSDate *localDate = [dateFormatter dateFromString:strDate];

    [dateFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //[dateFormatter setDateFormat:@"EEE, MMM d, yyyy - h:mm a"];//EEEE->long day name and MMMM->long month name
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    return dateString;
}

#pragma mark - convertUTCToLocal
+ (NSString *)convertUTCToLocal:(NSString *)strDate//@"2015-04-01T11:42:00"
{
    // create dateFormatter with UTC time format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *date = [dateFormatter dateFromString:strDate]; // create date from string
    
    // change to a readable time format and change to local time zone
    [dateFormatter setDateFormat:@"EEE, MMM d, yyyy - h:mm a"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *timestamp = [dateFormatter stringFromDate:date];
    return timestamp;
}

#pragma mark - timeFormattedFromSeconds
+ (NSString *)timeFormattedFromSeconds:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm:ss"];
    NSDate *date1 = [dateFormat dateFromString:[NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    return [formatter stringFromDate:date1];
    
}

#pragma Mark- Add event to phone Calander
+ (void)addEventToPhoneCalendarWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate withTitle:(NSString *)title withNotes:(NSString *)notes {
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        EKEvent *event = [EKEvent eventWithEventStore:eventStore];
        EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:-30];
        event.alarms = [NSArray arrayWithObject:alarm];
        
        event.title = title;
        event.startDate = startDate;
        event.endDate = endDate;
        event.notes = notes;
        
        [event setCalendar:[eventStore defaultCalendarForNewEvents]];
        
        NSError *err;
        [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
    }];
}

#pragma mark - dayFromDateString

// Convert the Date string to Day
+(NSString *)dayFromDateString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [dateFormatter dateFromString:dateString];
    dateFormatter.dateFormat = @"EEEE";
    NSString *dayName = [dateFormatter stringFromDate:date];
    //NSLog(@"Day Name: %@", dayName);
    return dayName;
}

#pragma mark - thumbnail generator from Url
- (UIImage *)thumbnailImageFromURL:(NSURL *)videoURL {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL: videoURL options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    NSError *err = NULL;
    CMTime requestedTime = CMTimeMake(1, 60);     // To create thumbnail image
    CGImageRef imgRef = [generator copyCGImageAtTime:requestedTime actualTime:NULL error:&err];
    //NSLog(@"err = %@, imageRef = %@", err, imgRef);
    
    UIImage *thumbnailImage = [[UIImage alloc] initWithCGImage:imgRef];
    CGImageRelease(imgRef);    // MUST release explicitly to avoid memory leak
    
    return thumbnailImage;
}

@end

#pragma mark- NSObject Category
@interface NSObject (NullCheck)

- (BOOL)isNull;
- (BOOL)isNotNull;

@end

@implementation NSObject (NullCheck)

- (BOOL)isNull
{
    if (!self) return YES;
    else if (self == [NSNull null]) return YES;
    else if ([self isKindOfClass:[NSString class]])
    {
        return ([((NSString *)self)isEqualToString : @""]
                || [((NSString *)self)isEqualToString : @"null"]
                || [((NSString *)self)isEqualToString : @"<null>"]
                || [((NSString *)self)isEqualToString : @"(null)"]
                );
    }
    return NO;
}

- (BOOL)isNotNull
{
    return ![self isNull];
}

@end
