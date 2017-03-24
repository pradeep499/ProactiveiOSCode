//
//  Defines.h
//  ProactiveLiving
//
//  Created by Hitesh on 1/12/16.
//  Copyright © 2016 MaverickHitesh. All rights reserved.
//


//Custom Fonts
#define FONT_BOLD @"Roboto-Bold" //15pix
#define FONT_REGULAR @"Roboto-Regular" //15pix
#define FONT_LIGHT @"Roboto-Light" //13pix
#define FONT_LIGHT_SMALL @"Roboto-Light" //13pix
#define FONT_THIN @"Roboto-Thin" //12pix

//Device info
#define DEVICE_TOKEN @"PushToken"
#define DEVICE_TYPE @"DeviceType"
#define CURRENT_DEVICE (IS_IPAD ? @"iPad" : @"iPhone")


//iOS Version check
#define IS_IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

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

//LiveServer URL
#define BASE_URL @"http://52.23.211.77/api/v1/"

//Production URL
//#define BASE_URL @"http://52.89.149.60:3000/api/v1/"

//Testing ULR
//#define BASE_URL @"http://192.168.1.40:3000/api/v1/"

#define RESIGN_KEYBOARD_FROM_APP [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

//RGB anf HEX Colors
#define UIColorFromHEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:((float)r)/255.0 green:((float)g)/255.0 blue:((float)b)/255.0 alpha:1.0]


// Web Services
#define ServiceRegister                 @"users/SignUp"
#define ServiceLogin                    @"users/Login"
#define ServiceForgotPassword           @"users/ForgotPassword"
#define ServiceValidationCenters        @"organization/getOrganizationList"
#define ServicePersonalTrainers         @"organization/getPersonalTrainers"
#define ServiceValidationCenterTypes    @"organization/getOrganizationTypeList"
#define ServiceGetCodelist              @"organization/getCategoryList"
#define ServiceLocationFilter           @"organization/locationFilter"
#define ServiceBookOrganization         @"organization/bookOrganizationByUser"
#define QRImageBaseUrl                  @"qrImg/"
#define ServiceGetPASInst               @"users/getPasInstruction"
#define ServiceGetAppointmentList       @"organization/userBookingList"
#define ServiceGetAppointment           @"organization/userBookingDetail"
#define ServiceGetCertifications        @"organization/getCertifications"
#define ServiceGetContacts              @"users/getContactList"
#define ServiceGetMessages              @"users/getMessages"
#define ServiceSendMessage              @"users/sendMessage"
#define ServiceGetMessageListing        @"users/getMessageListing"
#define ServiceRefreshMessages          @"users/refreshMessages"
#define ServiceUserContactSettings      @"users/getUserContactSettings"
#define ServiceUserOrganizationSettings @"users/getUserOrganizationSettings"
#define ServiceApplyOrgID               @"users/applyId"
#define ServiceUpdateOrgSettings        @"users/updateUserOrgSetting"
#define ServiceUpdateReadUnread         @"users/readLastMessage"
#define ServiceInviteOrGiftPAS          @"users/sendPasInvite"
#define ServiceSharePAS                 @"users/getPasShareOptions"
#define ServiceSendPAS                  @"users/sendPasShare"
#define ServiceMeetUpInviteStaticData   @"getMeetupInviteFor"
#define ServiceGetAllStories            @"getStories"
#define ServiceGetSubscribedStories     @"getSubscribeStories"
#define ServiceGetNewsFeed              @"getNewsFeed"
#define ServiceRequestOTP               @"users/requestOTP"
#define ServiceChangeMobile             @"users/changeMobile"
#define ServiceDeleteAC                 @"users/deleteAccount"
#define ServiceUpdateProfileStatus      @"users/updateStatus"
#define ServiceUpdateUserProfile        @"users/updateUserProfile"
#define ServiceUploadContent           @"users/uploadContent"
#define ServiceGetProfileDataByFilter          @"users/getProfileDataByFilter"
#define ServiceEditVideos          @"users/editVideos"
#define ServiceUploadVideos          @"users/uploadVideos"
#define ServiceDeleteVideo          @"users/deleteVideo"
#define ServiceSendFriendRequest          @"users/sendFriendRequest"
#define ServiceGetUserProfile          @"users/getUserProfile"
#define ServiceGetAllRequest         @"users/getAllRequest"
#define ServiceGetAllPACRequest         @"users/getAllPacRequest"
#define ServiceFriendRequestAction         @"users/friendRequestAction"
#define ServicePACRequestAction         @"users/pacRequestAction"
#define ServiceGetUserFriendList        @"users/getUserFriendList"
#define ServiceBlockUserAction        @"users/blockUserAction"
#define ServiceGetPACDetails            @"users/getPacDetail"
#define ServiceCreatePAC               @"users/createPac"
#define ServiceCreateResource           @"users/addResource"
#define ServiceGetAllResource           @"users/getAllResource"
#define ServiceDeleteResource           @"users/deleteResource"
#define ServiceEditResource             @"users/editResource"
#define ServiceLikePAC                  @"users/likePac"
#define ServiceGetPACRole               @"users/getPacRole"
#define ServiceAddMemberToPac           @"users/addMemberToPac"
#define ServicePACActionProfile         @"users/pacActionProfile"
#define ServiceGetMyPAC                 @"users/getMyPacListing"
#define ServiceExitPAC                  @"users/exitPAC"
#define ServiceGetAllCategoriesListing  @"users/getAllCategoriesListing/1b24e5f9-5318-4838-b81a-85d2ee7dc403"
#define ServiceDeletePAC                @"users/deletePac"

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

//UserDefaults
#define uId                             @"uId" // userid of logged in user
#define userProfileStatus                      @"userStatus" // user status of logged in user

#define isRememberUser                  @"isRemember"// to check, need to remember credentials
#define pwd                             @"pwd"// remember password
#define cellNum                         @"cellNum"
#define userFirstName                   @"firstName"
#define userLastName                   @"lastName"
#define userAddress                    @"address"
#define uImage                         @"uImage"
#define _ID                            @"userId"
#define keyUserDetails                    @"userDetails"

#define BookinTime                      @"BookinTime"
#define SyncStatus                      @"SyncStatus"
#define GPSStatus                       @"GPSStatus"

#define ACCEPTABLE_CHARACTERS           @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define ACCEPTABLE_MOBILE               @"+*#0123456789"


#define netError                        @"Network Error"
#define netErrorMessage                 @"Please check your internet connection"
#define signUpSuccess                   @"Sign up successfull, please login with your credentials"
#define userExist                       @"User already exist"
#define ok                              @"OK"
#define Cancel                          @"Cancel"
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
#define NOTIFICATION_PAC_FILTER @"NOTIFICATION_PAC_FILTER"
#define NOTIFICATION_ANNOTATION_CLICKED @"NOTIFICATION_ANNOTATION_CLICKED"
#define NOTIFICATION_SYNCCONTACT_CLICKED @"NOTIFICATION_SYNCCONTACT_CLICKED"
#define NOTIFICATION_SHOW_GROUP_VIEW_CLICKED @"NOTIFICATION_SHOW_GROUP_VIEW_CLICKED"
#define NOTIFICATION_GET_CONTACT_CLICKED @"NOTIFICATION_GET_CONTACT_CLICKED"
#define NOTIFICATION_INVITE_CONTACT_PAC @"NOTIFICATION_INVITE_CONTACT_PAC"
#define NOTIFICATION_REFRESH_PAC_CONTAINER @"NOTIFICATION_REFRESH_PAC_CONTAINER"
#define NOTIFICATION_FROM_MOREDETAILVC @"NOTIFICATION_FROM_MOREDETAILVC"

#define BOOK_POPUP_HEIGHT 392







