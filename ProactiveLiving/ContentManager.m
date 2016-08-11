//
//  ContentManager.m
//  SOSimpleChatDemo
//
// Created by : arturdev
// Copyright (c) 2014 SocialObjects Software. All rights reserved.
//

#import "ContentManager.h"
#import "Message.h"
#import "SOMessageType.h"

@implementation ContentManager

+ (ContentManager *)sharedManager
{
    static ContentManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (NSArray *)generateConversationWithArray:(NSArray *)data
{
    NSMutableArray *result = [NSMutableArray new];
    NSDateFormatter *dateFormatter;

    for (NSDictionary *msg in data) {
        Message *message = [[Message alloc] init];
        message.fromMe = [msg[@"fromMe"] boolValue];
        message.text = msg[@"text"];
        message.type = [self messageTypeFromString:[msg[@"type"] isEqualToString:@"message"] ?@"SOMessageTypeText" :@"SOMessageTypeText"];
        
        // create dateFormatter with UTC time format
        
        if(!dateFormatter)
        dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSz"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        NSDate *date = [dateFormatter dateFromString:msg[@"createdDate"]]; // create date from string
        
        message.date = date;
        message.dateString=msg[@"createdDate"];
        
        int index = (int)[data indexOfObject:msg];
        if (index > 0) {
            //Message *prevMesage = result.lastObject;
            //message.date = [NSDate dateWithTimeInterval:((index % 2) ? 2 * 24 * 60 * 60 : 120) sinceDate:prevMesage.date];
            //--or
            //if(![self isCurrentDate:message.date isGreaterThanPrevious:prevMesage.date])
            //message.date=prevMesage.date;

        }
        
        if (message.type == SOMessageTypePhoto) {
            message.media = UIImageJPEGRepresentation([UIImage imageNamed:msg[@"image"]], 1);
        } else if (message.type == SOMessageTypeVideo) {
            message.media = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:msg[@"video"] ofType:@"mp4"]];
            message.thumbnail = [UIImage imageNamed:msg[@"thumbnail"]];
        }

        [result addObject:message];
    }
    
    return result;
}

- (BOOL)isCurrentDate:(NSDate *)currDate isGreaterThanPrevious:(NSDate *)prevDate
{
    NSDate* enddate = prevDate;
    NSDate* currentdate = currDate;
    NSTimeInterval distanceBetweenDates = [currentdate timeIntervalSinceDate:enddate];
    NSInteger secondsBetweenDates = distanceBetweenDates / 60;
    
    if (secondsBetweenDates > 0)
        return YES;
    else
        return NO;
}

- (SOMessageType)messageTypeFromString:(NSString *)string
{
    if ([string isEqualToString:@"SOMessageTypeText"]) {
        return SOMessageTypeText;
    } else if ([string isEqualToString:@"SOMessageTypePhoto"]) {
        return SOMessageTypePhoto;
    } else if ([string isEqualToString:@"SOMessageTypeVideo"]) {
        return SOMessageTypeVideo;
    }

    return SOMessageTypeOther;
}

@end
