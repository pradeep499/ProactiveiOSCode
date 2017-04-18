//
//  Defines.swift
//  OurLiveStreaming
//
//  Created by Saurabh Shukla on 10/8/15.
//  Copyright © 2015 Affle AppStudioz India Pvt Ltd. All rights reserved.
//



/*
 
 Error Code :
 
 0 => 'SUCCESS',
 1 => 'FAIL',
 2 => 'PARAMETER_MISSING',
 3 => 'LOGGED_IN_SUCESSFULLY',
 4 => 'REGISTERED_SUCESSFULLY',
 5 => 'PASSWORD_NOT_MATCHED' ,
 6 => 'SOME_PROBLEM_OCCURRED' ,
 7 => 'PROBLEM_OCCURRED_WHILE_IMAGE_UPLOADING'
 8 => 'PROFILE_IS_ALREADY_UPDATED'
 */




import Foundation
import UIKit


let APP_NAME = "ProactiveLiving"

let IS_IOS_7 = UIDevice.currentDevice().systemVersion.hasPrefix("7")
let IS_IOS_8 = UIDevice.currentDevice().systemVersion.hasPrefix("8")

let IS_IPHONE_7 = UIScreen.mainScreen().bounds.size.height > 736.0
let IS_IPHONE_6plus = UIScreen.mainScreen().bounds.size.height == 736.0
let IS_IPHONE_6 = UIScreen.mainScreen().bounds.size.height == 667.0
let IS_IPHONE_5 = UIScreen.mainScreen().bounds.size.height == 568.0
let IS_IPHONE_4 = UIScreen.mainScreen().bounds.size.height == 480.0

//#define RESIGN_KEYBOARD_FROM_APP [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

let DISMISS_KEYBOARD = UIApplication.sharedApplication().keyWindow?.endEditing(true)

let screenWidth = UIScreen.mainScreen().bounds.width
let screenHeight = UIScreen.mainScreen().bounds.height
let screen = UIScreen.mainScreen().bounds

let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
let Google_Browser_Key = "AIzaSyDToz4zX8fG4fsgnej7ae3zDA3xBqU7GM4"

let tabBarInactiveColor=UIColor(red: 171/255.0, green: 8/255.0, blue: 0/255.0, alpha: 1.0)
let tabBarActiveColor=UIColor(red: 130/255.0, green: 6/255.0, blue: 0/255.0, alpha: 1.0)
let tabBarTintColor=UIColor(red: 110/255.0, green: 5/255.0, blue: 0/255.0, alpha: 1.0)



//Fonts Proactive

let fontBold = UIFont(name: "Roboto-Bold", size: 16)
let fontRegular = UIFont(name: "Roboto-Regular", size: 16)
let fontMedium = UIFont(name: "Roboto-Light", size: 14)
let fontThin = UIFont(name: "Roboto-Thin", size: 14)
let fontSmall = UIFont(name: "Roboto-Light", size: 12)


// MARK: Alerts by msy

let groupNameEmpty="Please enter Group Name"
let groupMemberEmpty="Please select atleast one member"
let groupImageEmpty="Please Add group image"


// MARK: complete profile alerts by msy

let heightEmpty="Please set your height"
let weightEmpty="Please set your weight"

// User Info Alerts
let nameEmpty="Please enter your name"
let locationEmpty="Please enter your location"
let dayEmpty="Please enter day"
let monthEmpty="Please enter month"
let yearEmpty="Please enter year"
let dateEmpty="Please enter date"
let genderEmpty="Please select gender"
let emailEmpty="Please enter email or phone number"
let imageEmpty="Please enter email or phone number"
let invalidEmail="Please enter valid email or phone number"
let selectBloodGroup="Please specify your blood group"
let selectPhysicalActivity="Please select your physical activity"
let fileNameEmpty="Please enter file name"

let totalCholosterolEmpty = "Please enter your total cholosterol"
let hdlCholosterolEmpty = "Please enter your HDL cholosterol"
let sbpEmpty = "Please enter your Systolic Blood Pressure"


let Base_imgurl = ""

let chatCDNbaseUrl=""

//----------------************Chat URL **************-------------
//for chat profile images

//Testing URL
let ChatBaseMediaUrl = "http://192.168.1.40:3000/"

// Live Server URL
// let ChatBaseMediaUrl = "http://52.23.211.77:3000/"

//Production URL
//let ChatBaseMediaUrl = "http://52.89.149.60:3000/"


//------------------------*********************
let ChatMediaPath = "api/v1/sendMedia"



//----------------************Socket IO URL **************-------------
// Test Server
let socketIO_BaseURL =  "http://192.168.1.40:3000/"

//Live Server
//let socketIO_BaseURL = "http://52.23.211.77:3000/"

//Production Serever
//let socketIO_BaseURL = "http://52.89.149.60:3000"


//----------------************Socket IO URL **************-------------

// MARK : GLOBAL Functions
func print_debug <T> (object:T)
{
    print(object)
}


//MARK:- Enumerations

enum CustomFonts: String
{
    case museosans100 = "museosans-100"
    case museosans300 = "museosans-300"
    case museosans500 = "museosans-500"
}

enum cardSizes :String{
    
    case S1 = "100,200"
    case S2 = "200,100"
    case S3 = "300,200"
    case S4 = "200,200"
    case S5 = "100,300"
    case S6 = "100,400"
    case Unknown = "100,100"
}

enum ServiceUrls : String
{
    //current testing url
    //case BaseUrl        = "http://fivedots.w3studioz.com/user.json"
    
    //current live url
    case BaseUrl        = "http://5dotstest.w3studioz.com/user.json"
    case imageBaseUrl   = "http://ols.w3studioz.com"
    case watchUrl  = "http://ols.w3studioz.com/Video.json"
    case commentUrl = "http://ols.w3studioz.com/Comment.json"
    case catchUpUrl = "http://ols.w3studioz.com/Catchup.json"
    case groupUrl = "http://ols.w3studioz.com/Friend.json"
    case AppKey = "!@#$%^&*()_-@@@#####$$$$$$^^^^^^^^^1234567890!!!!!!!!!"
    
}


enum ServiceMethods : String
{
    case methodLogin = "login"
    case methodSignup = "signup"
    case methodEditProfile = "edit-profile"
    case methodForgotPassword = "forgetPassword"
    case methodGetPasscode = "getPasscode"
    case methodVideoList = "videoList"
    case methodVideoDetail = "videoDeatil"
    case methodRateVideo = "rateVideo"
    case commentList = "commentList"
    case insertComment = "insertComment"
    
    case methodHomeResult = "getUserDetailsWithAllDevices"
    case methodHomeGraphResult = "getGraphDataByUserId"
    case methodgetDeviceStatusByUserId = "getDeviceStatusByUserId"
    case methodsetHeartRateZoneLevel = "setHeartRateZoneLevel"
    
    
    
    case methodupdateUserDeviceToken = "updateUserDeviceToken"
    case methoddeleteActivityByActivityId = "deleteActivityByActivityId"
    
    
    case methodMakeLikeVideo = "makeLikeVideo"
    case methodMakeSubscribeCategory = "makeSubscribeCategory"
    case methodMakeFavouriteVideo = "makeFavouriteVideo"
    case methodCatchUpList = "catchupList"
    case methodMostViewVideoList = "mostViewVideoList"
    case methodTrendingVideoList = "trendingVideoList"
    case methodRecentVideoList = "recentVideoList"
    
    case methodGetStoreList = "getStoreList"
    case methodPostStoreProduct = "postStoreProduct"
    case methodPostShoutout = "postShoutOut"
    case methodCheckInPost = "checkInPost"
    case methdgetLatestManualActivityByUserId = "getLatestManualActivityByUserId"
    
    
    
    // My Group
    case methodCreateGroup = "createGroup"
    case methodFriendList = "friendList"
    case methodGroupMemberList = "getMemberList"
    case methodMyCreatedGroupList = "myGroupList"
    case methodJoinedGroupList = "myJoinedGroupList"
    case methodGroupInviteList = "getGroupInviteList"
    case getGroupDetail = "getGroupDetail"
    case methodAddGroupMember = "addGroupMember"
    case methodExitGroup = "deleteGroup"
    case methodLeaveGroup = "leaveGroup"
    case methoddeleteGroupMember = "deleteGroupMember"
    case methoddeacceptGroupRequest = "acceptGroupRequest"
    
    //PKS: Risk Score Service method
    
    case methodHeartRiskScore = "setUserHeartRiskZone"
    case getUserHeartRiskDetails = "getUserHeartRiskZone"
    
    //PKS: Profile
    
    case methodGetUserProfile   = "getUserProfile"
    
    
    //PKS: Health Records
    
    case methodGetHealthRecordResult = "getHealthRecord"
    case methodSetHealthRecord = "setHealthRecord"
    case methodDeleteHealthRecord = "deleteHealthRecord"
    case methodUpdateHealthRecord = "updateHealthRecord"
    
    case methodHeartRateByPolar = "addDeviceDataWithoutNativeApi"
}

enum ServiceKeys : String
{
    //Login
    case keyUserEmail = "email"
    case keyMethod = "method"
    case keyUserPassword = "password"
    case keyConfirmPassword = "confirmPassword"
    case keyFacebookID = "facebookId"
    case keyGoogelID = "googlePlusId"
    case keyPasscode="passCode"
    case keyAppKey="appKey"
    case keyUserId="userId"
    case keyDeviceToken="deviceToken"
    case keyDeviceType="deviceType"
    case keyLoginType = "loginType"
    case keyRegistrationType="registrationType"
    case keyUserName="userName"
    case keyFirstName="firstName"
    case keyLastName="lastName"
    case keyPhoneNumber="phoneNumber"
    case keyStreamNumber="streamNumber"
    case keyLocation="location"
    case keyGender="gender"
    
    //Watch
    
    case keyVideoListId = "videoListId"
    case keyRateCount = "rateCount"
    case keyAge="age"
    case keyDob="dateOfBirth"
    
    case keyUserImage = "image"
    
    case keyInterest = "interests"
    case keyProfilePicUrl = "profilePicUrl"
    
    //Response
    case keyErrorCode = "errorCode"
    case keyErrorMessage = "errMessage"
    case key_result = "result"
    case key_response_string = "responseString"
    case key_recoveryType = "recoverType"
    case key_user_type = "userType"
    case key_userDetail = "userDetail"
    case key_mobile = "mobile"
    case key_OTP = "OTP"
    case key_countryCode = "countryCode"
    
    //Comment Service
    case keyMinCommentId = "minCommentId"
    case keyMaxCommentId = "maxCommentId"
    case keyDescription = "description"
    
    case keyMinCatchUpId = "minCatchupId"
    case keyStatus = "status"
    case keyCategoryId = "categoryId"
    
    case keyPage = "pageNo"
    
    case keyStoreListId = "storeListId"
    case keyStoreName = "storeName"
    case keyStoreImage = "storeImage"
    
    case keyProductId = "productId"
    case keyProductName = "productName"
    case keyproductImage = "productImage"
    case keyType = "type"
    
    case keyCatchUpMessage = "catchupMessage"
    case keyCaptionMessage = "captionMessage"
    case keyCatchUpImage = "catchupImage"
    
    
    case keyLatitude = "latitude"
    case keyLongitude = "longitude"
    case keyLocationName = "locationName"
    
    
    
    // Create Group Service
    case keyGroupName = "groupName"
    case keymemberIds = "memberIds"
    case lastUserId = "lastUserId"
    case groupListId = "groupListId"
    case KeygroupImage = "groupImage"
    case keyjoinListId = "joinListId"
    
}

enum deviceInfo : String
{
    case IS_OS_8_OR_LATER = "Ok"
    case yes = "Yes"
    case no = "No"
}

enum constants : String
{
    case Ok = "Ok"
    case yes = "Yes"
    case no = "No"
    case AppName = "OurliveStream"
    case deviceID = "76565646409654390124568"
    case appKey = "%#$@@#$@!#!"
    
    case UserIDAfterLogin = "UserIDAfterLogin"
    
    case viewController = "viewController"
    
    case User_Name = "User_Name"
    case User_Email = "User_Email"
    case Person_Type = "Person_Type"
    case User_Image = "User_Image"
    
    case isFromSideMenu = "isFromSideMenu"
    
    //MANUALLY
    
    case mUserID = "manualUserID"
    case manually = "manually"
    //FACEBOOK
    
    case fbID = "fbId"
    case fbAccessToken = "fbAccessToken"
    case isFaceBookLogin = "isFaceBookLogin"
    case fbAppID = "1140221082660147"
    
    //GOOGLE
    case gpID = "gpID"
    case isGoogleLogin = "isGoogleLogin"
    case googleAppID = "AIzaSyAue9In7xj0TQl2GctsbISr6jgZy7yFkBc" //"AIzaSyDtJM-lKeBqSTQtLjvi3kjKQeFDj67I39c"
    case googleBrowserKey = "AIzaSyCGtwVwJkKxNaijCJzmJuektX9S_YVhNsI" //"AIzaSyDToz4zX8fG4fsgnej7ae3zDA3xBqU7GM4" sakshi//
    case googleClientID = "365135956038-mmcibnih89cbttnj1p63ngpui5dlfilk.apps.googleusercontent.com"
    //   case googleReversedClientID = "com.googleusercontent.apps.1044089738616-5di790v67c2376gbcc65fivpfkacrdah"
    
    //case view = "View"
}

// MARK:- Error Codes
enum ErrorCodes : NSInteger
{
    case    errorCodeInternetProblem = -1 //Unable to update use
    
    case    errorCodeSuccess = 1 // 'Process successfully.'
    case    errorCodeFailed = 2 // 'Process failed.'
    //    case    error_code_invalid_method = "3" // 'Invalid method.'
    //    case    error_code_invalid_appkey = "4" // 'Invalid app_key'
    //    case    error_code_params_missing = "5" // 'Parameters are missing.
    //    case    error_code_phone_num_already = "6" // 'Phone number  already exist.
    //    case    error_code_username_already = "7" // 'Username is already exist.
    //   case    error_code_empty_email = 8 // 'email is empty.
    //   case    error_code_empty_password = 9 // 'Password is empty.
    //   case    error_code_wrong_username_or_pass = 10// 'Wrong username or password.
    //    case    error_code_invalid_sms_otp = "11" // 'Invalid sms verification code
    //    case    error_code_sms_not_verify = "12" // Sms code is not verified.
    //    case    error_code_invalid_phonenum_length = "13" // Phone number is less than 6 digits.
    //    case    error_code_invalid_phonenum = "14" // Invalid phone number.
    //    case    error_code_missing_access_token = "15" //Access token is missing
    //    case    error_code_unauthorized_user = "16" //User is not authorised.
    //    case    error_code_unable_to_update = "17" //Unable to update use
}

enum ErrorMessages : String {
    // case    error_invalid_user_name_or_password = "Please enter valid credentials"
    case errorNoConnection = "Please check your internet connection"
    case errorFBLoginfailed = "Error from fetching facebook detail"
    case errorGPLoginfailed = "Error from fetching Goggle Plus detail"
    case errorNoEmail = "Not able to retrieve email"
    case logoutAlertMsg = "Are you sure want to Logout from App ?"
    case errrologoutMsg = "Error on logout .Please try again later"
    case    errorValidPassword = "Please enter password within the range of 6-20 with no special character"
    case wrongResult = "Something went wrong."
    
    case errorValidEmail = "Please enter valid email"
    case error_email = "Please enter email"
    case errorRequiredField="Required field cannot be blank"
    case errorEmptyUsername = "Please enter the name within the range of 2-20 characters"
    case errorEmptyMobile = "Please enter mobile number within the range of 4-15"
    case errorValidMobile = "Please enter valid mobile number"
    case errorEmptyCountryCode = "PLease select valid country code"
    case errorEmptyEmailNumber = "Please enter email/mobile number"
    case errorPasswordMatch="Password and confirm password does not match!"
    case error_empty_username_and_password = "Please enter valid credentials"
    case errorTryAgain = "Oops, something went wrong. Please try again later"
    //   case error_internet_problem = "Currently you are working offline. Please check your internet connection."
    case errorInternetProblem = "Please check you internet connection and try again"
    
    case error_terms = "Please accept terms and conditions"
    //case error_internet_problem = "Please check your Internet Connection and try again"
    
}

//MARK:- MET

enum metValue:Float{
    case walking = 2.3       // if speed 2.7 km/hour
    case speedWalking = 2.9  // if speed 4 km/hour
    case highWalking = 3.3   // if speed 4.5 km/hour
    case bycycling = 3.0     //light
    case moderateBycycling = 4.0     //if speed 16km/hour
    case highBycycling = 5.5     //if speed >16km/hour
    case jogging = 7.0
    case running = 8.0     // if running or jumping
    case ropeJumping = 10.0     //if speed >16km/hour
    case swimming = 6.0
    case bicycling = 5.0
    case rockclimbing = 7.5
    case scubaDiving = 12.0
    case skiping = 12.3
    case lunges = 3.8
    
    // calory == MET * Weight(kg)*hour
}



func UIColorFromRGB(rgbValue: UInt) -> UIColor
{
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}


func validateUrl(stringURL: String) -> Bool {
    var urlRegEx = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
    var urlTest = NSPredicate(format: "SELF MATCHES %@", urlRegEx)
    return urlTest.evaluateWithObject(stringURL)
}



//MARK:- Validation Extension -

extension String {
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .CaseInsensitive)
            return regex.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    // Alpaha numeric check
    
    var isAlpaNumeric: Bool {
        //            if characters.count < 8 { return false }
        if rangeOfCharacterFromSet(.letterCharacterSet(), options: .LiteralSearch, range: nil) == nil { return false }
        if rangeOfCharacterFromSet(.decimalDigitCharacterSet(), options: .LiteralSearch, range: nil) == nil { return false }
        return true
    }
    
    //validate PhoneNumber
    var isPhoneNumber: Bool {
        
        let charcter  = NSCharacterSet(charactersInString: "+0123456789").invertedSet
        var filtered:NSString!
        let inputString:NSArray = self.componentsSeparatedByCharactersInSet(charcter)
        filtered = inputString.componentsJoinedByString("")
        if  self == filtered{
            if filtered.length>=7 && filtered.length<=15{
                return true
            }else{
                return false
            }
        }else{
            return false
        }
        
    }
    
    //validate Password
    var isValidPassword: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$", options: .CaseInsensitive)
            if(regex.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil){
                
                if(self.characters.count>=6 && self.characters.count<=20){
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
        } catch {
            return false
        }
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.stringByAppendingPathComponent(path)
    }
    
    //To convert string to Bool
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
//    func sizeWithFont(font: UIFont, constrainedToWidth width: Float, lineBreakMode: NSLineBreakMode) -> CGSize {
//        var paragraphStyle = NSMutableParagraphStyle.defaultParagraphStyle()
//        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
//        var textRect = self.boundingRectWithSize(CGSizeMake(300.0,CGFloat.max), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle], context: nil)
//        return CGSizeMake(ceilf(textRect.size.width), ceilf(textRect.size.height))
//    }
//    
//    func calculateHeightForText(inText:String, width:Float, font:UIFont ) -> CGFloat
//    {
//        var messageString = inText
//        var attributes = [UIFont(): UIFont.systemFontOfSize(15.0)]
//        var attrString:NSAttributedString? = NSAttributedString(string: messageString, attributes: attributes)
//        var rect:CGRect = attrString!.boundingRectWithSize(CGSizeMake(300.0,CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context:nil )//hear u will get nearer height not the exact value
//        var requredSize:CGRect = rect
//        return requredSize.height  //to include button's in your tableview
//        
//    }
    
//    func heightForView(text:String, #font:UIFont, #width:CGFloat) -> CGFloat{
//        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
//        label.numberOfLines = 0
//        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
//        label.font = font
//        label.text = text
//        
//        label.sizeToFit()
//        return label.frame.height
//    }

    
    func sizeWithFontt(font: UIFont) -> CGSize {
        let size = self.sizeWithAttributes([NSFontAttributeName: font])
        return CGSizeMake(CGFloat(size.width), CGFloat(size.height))
    }
    
    func sizeWithFontt(font: UIFont, constrainedToSize size: CGSize, lineBreakMode: NSLineBreakMode) -> CGSize {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        let textRect = self.boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle], context: nil)
        return CGSizeMake(CGFloat(textRect.size.width), CGFloat(textRect.size.height))
    }
    
    func sizeWithFont(font: UIFont, constrainedToWidth width: CGFloat, lineBreakMode: NSLineBreakMode) -> CGSize {
        let size = CGSizeMake(width, CGFloat.max)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        let textRect = self.boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle], context: nil)
        return CGSizeMake(CGFloat(textRect.size.width), CGFloat(textRect.size.height))
    }

}

extension UIImage {
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension Double {
    func toString() -> String {
        return String(format: "%.1f",self)
    }
}

//MARK:- First of all we need an extension of Int to generate a random number in a range.
extension Int {
    init(_ range: Range<Int> ) {
        let delta = range.startIndex < 0 ? abs(range.startIndex) : 0
        let min = UInt32(range.startIndex + delta)
        let max = UInt32(range.endIndex   + delta)
        self.init(Int(min + arc4random_uniform(max - min)) - delta)
    }
}

//MARK:- Image Orientation fix
extension UIImage {
    
    func fixOrientation() -> UIImage {
        
        // No-op if the orientation is already correct
        if ( self.imageOrientation == UIImageOrientation.Up ) {
            return self;
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransformIdentity
        
        if ( self.imageOrientation == UIImageOrientation.Down || self.imageOrientation == UIImageOrientation.DownMirrored ) {
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
        }
        
        if ( self.imageOrientation == UIImageOrientation.Left || self.imageOrientation == UIImageOrientation.LeftMirrored ) {
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
        }
        
        if ( self.imageOrientation == UIImageOrientation.Right || self.imageOrientation == UIImageOrientation.RightMirrored ) {
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform,  CGFloat(-M_PI_2));
        }
        
        if ( self.imageOrientation == UIImageOrientation.UpMirrored || self.imageOrientation == UIImageOrientation.DownMirrored ) {
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
        }
        
        if ( self.imageOrientation == UIImageOrientation.LeftMirrored || self.imageOrientation == UIImageOrientation.RightMirrored ) {
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx: CGContextRef = CGBitmapContextCreate(nil, Int(self.size.width), Int(self.size.height),
                                                      CGImageGetBitsPerComponent(self.CGImage!), 0,
                                                      CGImageGetColorSpace(self.CGImage!)!,
                                                      CGImageGetBitmapInfo(self.CGImage!).rawValue)!;
        
        CGContextConcatCTM(ctx, transform)
        
        if ( self.imageOrientation == UIImageOrientation.Left ||
            self.imageOrientation == UIImageOrientation.LeftMirrored ||
            self.imageOrientation == UIImageOrientation.Right ||
            self.imageOrientation == UIImageOrientation.RightMirrored ) {
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage!)
        } else {
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage!)
        }
        
        // And now we just create a new UIImage from the drawing context and return it
        return UIImage(CGImage: CGBitmapContextCreateImage(ctx)!)
    }
}

//MARK: - Estimate the label height
extension UILabel
{
    var optimalHeight : CGFloat
        {
        get
        {
            let label = UILabel(frame: CGRectMake(0, 0, self.frame.width, CGFloat.max))
            label.numberOfLines = 0
            label.lineBreakMode = self.lineBreakMode
            label.font = self.font
            label.text = self.text
            
            label.sizeToFit()
            
            return label.frame.height
        }
    }
}

extension String {
    
    
    func stringHeightWith(fontSize:CGFloat,width:CGFloat)->CGFloat
        
    {
        let font = UIFont.systemFontOfSize(fontSize)
        let size = CGSizeMake(width,CGFloat.max)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping;
        let  attributes = [NSFontAttributeName:font,
                           NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        let text = self as NSString
        let rect = text.boundingRectWithSize(size, options:.UsesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.height
    }
}



class hello {
    var msyString = "abc"
    
    func trueValue() {
        print_debug("accesssed")
    }
    
}

//view.backgroundColor = UIColorFromRGB(0x209624)
