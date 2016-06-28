//
//  Defines.h
//  ProactiveLiving
//
//  Created by Hitesh on 1/12/16.
//  Copyright © 2016 MaverickHitesh. All rights reserved.
//


//Custom Fonts
#define FONT_BOLD @"Roboto-Bold"
#define FONT_REGULAR @"Roboto-Regular"
#define FONT_LIGHT @"Roboto-Light"
#define FONT_THIN @"Roboto-Thin"



//iOS Version check
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

//Devices and Screens
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4 (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define RESIGN_KEYBOARD_FROM_APP [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

//RGB anf HEX Colors
#define UIColorFromHEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:((float)r)/255.0 green:((float)g)/255.0 blue:((float)b)/255.0 alpha:1.0]

#define ServiceRegister                 @"http://52.23.211.77:3000/api/v1/users/SignUp"
#define SERVICE                         @"http://52.23.211.77:3000/api/v1/users/SignUpUp"
#define ServiceLogin                    @"http://52.23.211.77:3000/api/v1/users/Login"
#define ServiceForgotPassword           @"http://52.23.211.77:3000/api/v1/users/ForgotPassword"
#define ServiceValidationCenters        @"http://52.23.211.77:3000/api/v1/organization/getOrganizationList"
#define ServicePersonalTrainers         @"http://52.23.211.77:3000/api/v1/organization/getPersonalTrainers"
#define ServiceValidationCenterTypes    @"http://52.23.211.77:3000/api/v1/organization/getOrganizationTypeList"
#define ServiceGetCodelist              @"http://52.23.211.77:3000/api/v1/organization/getCategoryList"
#define ServiceLocationFilter           @"http://52.23.211.77:3000/api/v1/organization/locationFilter"
#define ServiceBookOrganization         @"http://52.23.211.77:3000/api/v1/organization/bookOrganizationByUser"
#define QRImageBaseUrl                  @"http://52.23.211.77:3000/api/v1/qrImg/"
#define ServiceGetPASInst               @"http://52.23.211.77:3000/api/v1/users/getPasInstruction"
#define ServiceGetAppointmentList       @"http://52.23.211.77:3000/api/v1/organization/userBookingList"
#define ServiceGetAppointment           @"http://52.23.211.77:3000/api/v1/organization/userBookingDetail"
#define ServiceGetCertifications        @"http://52.23.211.77:3000/api/v1/organization/getCertifications"
#define ServiceGetContacts              @"http://52.23.211.77:3000/api/v1/users/getContactList"
#define ServiceGetMessages              @"http://52.23.211.77:3000/api/v1/users/getMessages"
#define ServiceSendMessage              @"http://52.23.211.77:3000/api/v1/users/sendMessage"
#define ServiceGetMessageListing        @"http://52.23.211.77:3000/api/v1/users/getMessageListing"
#define ServiceRefreshMessages          @"http://52.23.211.77:3000/api/v1/users/refreshMessages"
#define ServiceUserContactSettings      @"http://52.23.211.77:3000/api/v1/users/getUserContactSettings"
#define ServiceUserOrganizationSettings @"http://52.23.211.77:3000/api/v1/users/getUserOrganizationSettings"
#define ServiceApplyOrgID               @"http://52.23.211.77:3000/api/v1/users/applyId"
#define ServiceUpdateOrgSettings        @"http://52.23.211.77:3000/api/v1/users/updateUserOrgSetting"
#define ServiceUpdateReadUnread         @"http://52.23.211.77:3000/api/v1/users/readLastMessage"
#define ServiceInviteOrGiftPAS          @"http://52.23.211.77:3000/api/v1/users/sendPasInvite"
#define ServiceSharePAS                 @"http://52.23.211.77:3000/api/v1/users/getPasShareOptions"
#define ServiceSendPAS                  @"http://52.23.211.77:3000/api/v1/users/sendPasShare"

#define maxLength                       25
#define maxPhoneLength                  15
#define minimumPhoneLength              8
#define minimumPasswordLength           6

#define loginBorderColor                [UIColor colorWithRed:176.0/255.0 green:176.0/255.0 blue:176.0/255.0 alpha:1.0]
#define signUpButtonColor               [UIColor colorWithRed:149.0/255.0 green:149.0/255.0 blue:149.0/255.0 alpha:1.0]
#define signupColor                     [UIColor colorWithRed:141.0/255.0 green:199.0/255.0 blue:63.0/255.0 alpha:1.0]
#define iAgreeColor                     [UIColor colorWithRed:143.0/255.0 green:143.0/255.0 blue:143.0/255.0 alpha:1.0]
#define termsColor                      [UIColor colorWithRed:10.0/255.0 green:10.0/255.0 blue:10.0/255.0 alpha:1.0]

#define AppName                          @"ProactiveLiving"
#define AppKey                          @"DFd$$@@#454gHGer$#"
#define HeaderKey                       @"$%#^%%7hg54634243k5lu79626%$#$%@$#hg$%#$#hggf"


#define uId                             @"uId" // userid of logged in user
#define isRememberUser                  @"isRemember"// to check, need to remember credentials
#define pwd                             @"pwd"// remember password
#define cellNum                         @"cellNum"
#define uImage                          @"uImage"

#define ACCEPTABLE_CHARACTERS           @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define ACCEPTABLE_MOBILE               @"+*#0123456789"


#define netError                        @"Network Error"
#define netErrorMessage                 @"Please check your internet connection"
#define signUpSuccess                   @"Sign up successfull, please login with your credentials"
#define userExist                       @"User already exist"
#define ok                              @"OK"
#define cancel                          @"Cancel"
#define yes                             @"Yes"
#define no                              @"No"
#define allMandatory                    @"Please enter mandatory fields"
#define cellNumberMandatory             @"Please enter Cell Number"
#define validCellNumber                 @"Please enter valid Cell Number"
#define validPassword                   @"Please enter valid password of minimum 6 characters long"
#define passwordMandatory               @"Please enter Password"
#define requiredTitle                   @"Required"
#define passwordMismatch                @"Password do not match"
#define terms                           @"Please agree to our Terms and Conditions"
#define invalidEmail                    @"Please enter a valid email address"
#define serviceError                    @"Server Error!"
#define pleaseLogin                     @"We have sent a mail to your registered email, please login with new password"
#define invalidPassword                 @"Incorrect Cell number and Password"
#define userNotExist                    @"Cell number is not registered with us"

//Notifications
#define NOTIFICATION_VALIDATION_CENTER_FLTER @"VALIDATION_CENTER_FLTER_NOTIFICATION"
#define NOTIFICATION_ANNOTATION_CLICKED @"NOTIFICATION_ANNOTATION_CLICKED"
#define NOTIFICATION_SYNCCONTACT_CLICKED @"NOTIFICATION_SYNCCONTACT_CLICKED"

#define BOOK_POPUP_HEIGHT 392

//UserDefaults
#define BookinTime                      @"BookinTime"
#define SyncStatus                      @"SyncStatus"
#define GPSStatus                       @"GPSStatus"





