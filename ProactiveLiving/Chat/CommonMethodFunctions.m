//
//  CommonMethodFunctions.m
//  Quorier
//
//  Created by Sakshi on 2/3/15.
//  Copyright (c) 2015 Shariq Hussain. All rights reserved.
//

#import "CommonMethodFunctions.h"
#import <MediaPlayer/MediaPlayer.h>

#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789."

@implementation CommonMethodFunctions

#pragma mark- UIAlert View
+ (void) showAlertViewWithTag:(NSInteger)tag title:(NSString*)title message:(NSString*)msg delegate:(id)delegate
            cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate
                                          cancelButtonTitle:CbtnTitle otherButtonTitles:otherBtnTitles, nil];
    alert.tag = tag;
    [alert show];
}


+(UIView *) GetAlertViewWithAlertText:(NSString *)alertText numberOfButtons:(int) numberOfButtons andFrame:(CGRect)frame
{
    UIView *alertView =[[UIView alloc] initWithFrame:CGRectMake(25, 200, 260, 150)];
    
    CGFloat y=(frame.size.height-180)/2 ;
    
    UILabel *label=[[UILabel alloc] init];
    label.font=[UIFont systemFontOfSize:18.0f];
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.frame=CGRectMake(90, 0, 60, [self ReturnAlertViewHeightWithText:alertText andFont:[UIFont boldSystemFontOfSize:18.0f]]);
    label.text=@"PurseApp";
    label.numberOfLines=0;
    [alertView addSubview:label];
    
    //    y=y+55;
    
    UIView *horizontalLine= [[UIView alloc]initWithFrame:CGRectMake(0,35, alertView.frame.size.width,1)];
    [horizontalLine setBackgroundColor:[UIColor whiteColor]];
    [alertView addSubview:horizontalLine];
    
    UILabel *alertLabel=[[UILabel alloc] init];
    alertLabel.font=[UIFont systemFontOfSize:18.0f];
    alertLabel.textColor=[UIColor whiteColor];
    alertLabel.backgroundColor=[UIColor clearColor];
    alertLabel.textAlignment=NSTextAlignmentCenter;
    alertLabel.frame=CGRectMake(42, 40, 210, [self ReturnAlertViewHeightWithText:alertText andFont:[UIFont systemFontOfSize:18.0f]]);
    alertLabel.text=alertText;
    alertLabel.numberOfLines=2;
    [alertView addSubview:alertLabel];
    y=y+50;
    
    UIView *horizontalLine2= [[UIView alloc]initWithFrame:CGRectMake(0,95, alertView.frame.size.width,1)];
    [horizontalLine2 setBackgroundColor:[UIColor whiteColor]];
    [alertView addSubview:horizontalLine2];
    
    if(numberOfButtons==2)
    {
        y=y+[self ReturnAlertViewHeightWithText:alertText andFont:[UIFont systemFontOfSize:18.0f]]-3;
        
        UIButton *okButton=[UIButton buttonWithType:UIButtonTypeCustom];
        okButton.tag=75001;
        [okButton setTitle:@"OK" forState:UIControlStateNormal];
        okButton.frame=CGRectMake(5, 96, 129, 46);
        [okButton setUserInteractionEnabled:YES];
        [alertView addSubview:okButton];
        
        UIButton *noButton=[UIButton buttonWithType:UIButtonTypeCustom];
        noButton.tag=75000;
        [noButton setBackgroundColor:[UIColor redColor]];
        noButton.frame=CGRectMake(150, 100, 129, 46);
        [noButton setTitle:@"CANCEL" forState:UIControlStateNormal];
        [noButton setUserInteractionEnabled:YES];
        [alertView addSubview:noButton];
    }
    UIView *verticalLine= [[UIView alloc]initWithFrame:CGRectMake( 130,96,1,46)];
    [verticalLine setBackgroundColor:[UIColor whiteColor]];
    [alertView addSubview:verticalLine];
    
    if(numberOfButtons==1)
    {
        y=y+[self ReturnAlertViewHeightWithText:alertText andFont:[UIFont systemFontOfSize:18.0f]]-3;
        
        UIButton *okButton=[UIButton buttonWithType:UIButtonTypeCustom];
        okButton.tag=7051;
        [okButton setImage:[UIImage imageNamed:@"yesbtn.png"] forState:UIControlStateHighlighted];
        [okButton setImage:[UIImage imageNamed:@"yesbtn_normal.png"] forState:UIControlStateNormal];
        okButton.frame=CGRectMake(90, y+20, 129, 46);
        [alertView addSubview:okButton];
        
    }
    return alertView;
}

+(int) ReturnAlertViewHeightWithText:(NSString *)alertText andFont:(UIFont *)font
{
    
    CGSize maximumLabelSize;
    maximumLabelSize = CGSizeMake(210,9999);
    
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine |
    NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    NSDictionary *attr = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:14.0]};
    CGRect labelBounds = [alertText boundingRectWithSize:maximumLabelSize
                                                options:options
                                             attributes:attr
                                                context:nil];

    if(labelBounds.size.height>20)
        return labelBounds.size.height+20;
    return 20;
}

#pragma mark- UIAlertController
+(UIAlertController*)createAlertControllerwithTitle:(NSString*)title andMessage:(NSString*)message preferreStyle:(UIAlertControllerStyle)preferredStyle andOkAction:(UIAlertAction*)okAction cancelButton:(UIAlertAction*)cancelAction
{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    
    if(okAction)
        [alertController addAction:okAction];
    if(cancelAction)
        [alertController addAction:cancelAction];
    
    return alertController;
    
    //Use it Like dis in Class you want to use
    
//    UIAlertAction *alertOK=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
//                            {
//                                [self.navigationController popViewControllerAnimated:YES];
//                                
//                            }];
//    
//    UIAlertController *alertControllerObj=[AppHelper createAlertControllerwithTitle:APP_NAME andMessage:@"To enable package tracking, go to device Settings->Privacy->Location Services->Select Always corresponding to Quorier" preferreStyle:UIAlertControllerStyleAlert andOkAction:alertOK cancelButton:nil];
//    
//    
//    [self presentViewController:alertControllerObj animated:YES completion:nil];
}

#pragma mark- Get Device Height
+(float) getHeightOfDevice
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480.0f)
        {
            return 410;
        }
        if(result.height == 568.0f)
        {
            return 498;
        }
    }
    return 0;
}


#pragma mark- User Defaults
+(void)saveToUserDefaults:(id)value withKey:(NSString*)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults)
    {
        [standardUserDefaults setObject:value forKey:key];
        [standardUserDefaults synchronize];
    }
}

+(void)saveToUserDefaultsAlbumDate:(NSDate *)value withKey:(NSString*)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:value forKey:key];
        [standardUserDefaults synchronize];
    }
}

+(NSString*)userDefaultsForKey:(NSString*)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults objectForKey:key];
    
    return val;
}

+(void)removeFromUserDefaultsWithKey:(NSString*)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults removeObjectForKey:key];
    [standardUserDefaults synchronize];
}

+(NSString*)getDeviceUDID
{
    NSString *udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return udid;
}

+(void)makeCallOnNumber:(NSString*)contactNo
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:contactNo]];
}

+(NSDate*)setMaximumDateUsingDate : (NSDate*) stratDate subtractingYears:(int)value
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //  NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-5];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:stratDate options:0];
    //    [comps setYear:-30];
    //
    //   NSDate *minDate = [calendar dateByAddingComponents:comps toDate:stratDate options:0];
    
    return maxDate;
    //    [datePicker setMaximumDate:maxDate];
    //    [datePicker setMinimumDate:minDate];
}

#pragma mark- Email Validation
+ (BOOL)validateEmailWithString:(NSString *)email
{
    if ((email == nil) || (email.length == 0)) {
        return FALSE;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailTest evaluateWithObject:email])
    {
        return FALSE;
    }
    else return TRUE;
}

#pragma mark- PhoneNumber Validation
+(BOOL)validatePhone:(NSString *)phoneNumber
{
    NSString *phoneRegex = @"^+(?:[0-9] ?){6,14}[0-9]$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phoneNumber];
}

#pragma mark- Prevent Keyboard from hiding TextField
+(CGRect)keyboardNotHideTextField:(UITextField*)textField inScrollView:(UIScrollView*)scrollVc
{
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:scrollVc];
    rc.origin.x = 0 ;
    rc.origin.y -= 60 ;
    
    rc.size.height = 400;
    //write it in The view
   // [self.scroll scrollRectToVisible:rc animated:YES];
    
    return rc;
}

+(CGRect)labelRectForText:(NSString*)text withFont:(UIFont*)font
{
    CGSize  textSize = { 247.0, 10000.0 };
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine |
    NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    //[UIFont fontWithName:@"Lato-Regular" size:14.0]
    
    NSDictionary *attr = @{NSFontAttributeName: font};
    CGRect labelBounds = [text boundingRectWithSize:textSize
                                                options:options
                                             attributes:attr
                                                context:nil];
    
    return labelBounds;
}

#pragma mark- Send Email
-(MFMailComposeViewController*)sendEmailwithEmailTitle:(NSString*)title emailId:(NSString*)emailId messageBody:(NSString*)message
{
    // Email Subject
    NSString *emailTitle = @"Test Email";
    // Email Content
    NSString *messageBody = @"iOS programming is so fun!";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"support@appcoda.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    return mc;
    
    // Present mail view controller on screen
    //[self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            ////NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            ////NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            ////NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            ////NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
   // [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -Save Into Database
+(NSInteger)nextIdentifies
{
    static NSString* lastID = @"lastID";
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger identifier = [defaults integerForKey:lastID] + 1;
    [defaults setInteger:identifier forKey:lastID];
    [defaults synchronize];
    return identifier;
}


#pragma mark -Save Into Database
+(NSInteger)nextChatIdentifies
{
    static NSString* lastChatID = @"lastChatID";
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger identifier = [defaults integerForKey:lastChatID] + 1;
    [defaults setInteger:identifier forKey:lastChatID];
    [defaults synchronize];
    return identifier;
}


+(CGSize)sizeOfCell:(NSString*)str fontSize:(CGFloat)size width:(float)weigth fontName:(NSString*)fontName
{
    CGSize maximumLabelSize = CGSizeMake(weigth,CGFLOAT_MAX);
    CGSize expectedLabelSize ;
    if([str length]>0)
    {
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        {
            
            NSMutableAttributedString *attributedString;
            attributedString = [[NSMutableAttributedString alloc] init];
            NSDictionary *attributes = @{NSFontAttributeName : [UIFont fontWithName:fontName size:size]};
            
            [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:str attributes:attributes]];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:0];
            
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
            
            expectedLabelSize =[attributedString boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        }
        else{
            expectedLabelSize = [str sizeWithFont:[UIFont fontWithName:fontName size:size] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
        }
        return expectedLabelSize;
    }
    return CGSizeZero;
}



+(CGFloat)widthOfText:(NSString*)str fontSize:(int)size height:(float)height fontName:(NSString*)fontName
{
    CGSize maximumLabelSize = CGSizeMake(CGFLOAT_MAX, height);
    CGSize expectedLabelSize ;
    if([str length]>0)
    {
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        {
            
            NSMutableAttributedString *attributedString;
            attributedString = [[NSMutableAttributedString alloc] init];
            NSDictionary *attributes = @{NSFontAttributeName : [UIFont fontWithName:fontName size:size]};
            
            [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:str attributes:attributes]];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:0];
            
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
            
            expectedLabelSize =[attributedString boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        }
        else{
            expectedLabelSize = [str sizeWithFont:[UIFont fontWithName:fontName size:size] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
        }
        return expectedLabelSize.width;
    }
    return 0.0;
}

#pragma mark - Get Content Size of Uitextview ios7

- (CGFloat)measureHeightOfUITextView:(UITextView *)textView
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        // This is the code for iOS 7. contentSize no longer returns the correct value, so
        // we have to calculate it.
        //
        // This is partly borrowed from HPGrowingTextView, but I've replaced the
        // magic fudge factors with the calculated values (having worked out where
        // they came from)
        
        CGRect frame = textView.bounds;
        
        // Take account of the padding added around the text.
        
        UIEdgeInsets textContainerInsets = textView.textContainerInset;
        UIEdgeInsets contentInsets = textView.contentInset;
        
        CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + textView.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right;
        CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
        
        frame.size.width -= leftRightPadding;
        frame.size.height -= topBottomPadding;
        
        NSString *textToMeasure = textView.text;
        if ([textToMeasure hasSuffix:@"\n"])
        {
            textToMeasure = [NSString stringWithFormat:@"%@-", textView.text];
        }
        
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName: textView.font, NSParagraphStyleAttributeName : paragraphStyle };
        
        CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
        
        CGFloat measuredHeight = ceilf(CGRectGetHeight(size) + topBottomPadding);
        return measuredHeight;
    }
    else
    {
        return textView.contentSize.height;
    }
}
#pragma Mark- Calculate Time
-(NSString *)calculateTimeDifferenceWith:(NSString *)previousdate
{
    if(previousdate !=nil)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
       
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSDate *dateFromString = [[NSDate alloc] init];
        // voila!
        dateFromString = [dateFormatter dateFromString:previousdate];
        
        NSDate *nowDate = [NSDate date];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
        NSDateComponents *components = [calendar components:NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                                   fromDate:dateFromString
                                                     toDate:nowDate
                                                    options:0];
        
        // ////NSLog(@"Difference in date components: %i/%i/%i/%i/%i/%i",components.year, components.month, components.day,components.hour, components.minute, components.second);
        NSString * diff = nil;
        
        if(components.minute)
        {
            diff = [NSString stringWithFormat:@"%li",(long)components.minute];
        }
        
        return diff;
    }
    return nil;
}

#pragma mark-Uploaded Date
-(NSString *)whenUploaded:(NSString *)dateString
{
    NSDateFormatter *formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy'-'MM'-'dd'T'HH:mm:ssZ"];
    NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:[formater dateFromString:dateString]];
    
    NSDate *createdDate=[[formater dateFromString:dateString] dateByAddingTimeInterval:timeZoneOffset];
    NSInteger difference=[createdDate timeIntervalSinceDate:[[NSDate date] dateByAddingTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]]]];
    
    difference=labs(difference);
    float days=difference/(60*60*24);
    float hours=difference/(60*60);
    float miniutes=difference/60;
    
    if (days>=1)
    {
        [formater setDateFormat:@"MMM dd"];
        return [formater stringFromDate:createdDate];
    }
    else if (hours>1)
        return [[NSString stringWithFormat:@"%ld",difference/(60*60)] stringByAppendingString:@"h ago"];
    else if (miniutes>1)
        return [[NSString stringWithFormat:@"%ld",difference/60] stringByAppendingString:@"m ago"];
    else
        return [[NSString stringWithFormat:@"%ld",(long)difference] stringByAppendingString:@"s ago"];
}

#pragma  mark
#pragma  mark Method for generate Photo Thumbnail and scaling
+(UIImage *)generatePhotoThumbnail1:(UIImage *)image
{
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    if(width>height)
    {
        //        width=414;
        //        height=300;
        
        height = height * 414 / width;
        width=414;
    }
    else
    {
        //height=414;
        //width=300;
        width = width * 414 / height;
        height=414;
    }
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(width, height);
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            break;
    }
    
    
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
    
}

+(UIImage *)generatePhotoThumbnail:(UIImage *)image
{
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    if(width>height)
    {
        width=414;
        height=300;
        
        
    }
    else
    {
        height=300;
        width=414;
        
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(width, height);
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            break;
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
    
}
+(UIImage *)getThumbNail:(NSURL*)videoURL
{
    
    //stringPath is a path of stored video file from document directory
    //NSURL *videoURL = [NSURL fileURLWithPath:stringPath];
    
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    
    UIImage *thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    
    //Player autoplays audio on init
    [player stop];
    
    
    return thumbnail;
}

+(UIImage *)generateThumbImage : (NSURL *)fileUrl {
    
    AVAsset *asset = [AVAsset assetWithURL:fileUrl];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = [asset duration];
    time.value = 0;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    return thumbnail;
}

#pragma mark convert video to MP4
+ (void)convertVideoToLowQuailtyWithInputURL:(NSURL*)inputURL
                                   outputURL:(NSURL*)outputURL
                                     handler:(void (^)(AVAssetExportSession*))handler
{
    [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         handler(exportSession);
     }];
}

#pragma mark: - image scalling
+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

#pragma mark- NSObject Category
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

#pragma mark- NSString Category
@implementation NSString (TrimSpaces)

-(void)trimTrailingSpaces:(NSString *)text
{
    [text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end
