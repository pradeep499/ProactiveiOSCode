//
//  HelpingClass.swift
//  Five Dots
//
//  Created by Alok on 2/26/16.
//  Copyright © 2016 Appstudioz. All rights reserved.
//

import UIKit


class HelpingClass: NSObject,UIAlertViewDelegate {
    var loadingView: UIView!
    var activityIndicator:UIActivityIndicatorView?

    //MARK: User Defaults
    // save to user default
    class func saveToUserDefault (value: AnyObject? , key: String!) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(value, forKey: key! as String)
        defaults.synchronize()
    }
    
    // get from user default
    class func userDefaultForKey ( key: String?) -> String{
        let defaults = NSUserDefaults.standardUserDefaults()
        let value = defaults.stringForKey(key! as String)
        if (value != nil) {
            return value!
            
        }
        return ""
    }
    
    // remove from user default
    class  func removeFromUserDefaultForKey(key: NSString!) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let value = defaults.stringForKey(key! as String)
        if (value != nil) {
            defaults.removeObjectForKey(key! as String)
        }
        defaults.synchronize()
        
    }
    //MARK: AlertView
    class func showALertWithTag(tag:Int, title:String, message:String?,delegate:AnyObject!, cancelButtonTitle:String?, otherButtonTitle:String?)
    {
        let alert = UIAlertView()
        
        alert.tag = tag
        alert.title = title
        alert.message = message
        alert.delegate = delegate
        if (cancelButtonTitle != nil)
        {
            alert.addButtonWithTitle(cancelButtonTitle!)
        }
        if (otherButtonTitle != nil)
        {
            alert.addButtonWithTitle(otherButtonTitle!)
        }
        
        alert.show()
        
    }
    
    //MARK:-  Convert Int value to String
    class func convertIntToString(intValue:Int)->String
    {
        let x : Int = intValue
        let stringValue = String(x)
        return stringValue
    }
    //MARK:- Convert Number to String
    class func convertNumberToString(numValue:NSNumber)->String
    {
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        // Configure the number formatter to your liking
        let stringValue = nf.stringFromNumber(numValue)
        return stringValue!
    }
    
    
    //MARK:- dynamic height Of A Label
    class func heightForTextView(text:String, font:UIFont, width:CGFloat, numberOfLines:Int) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRectMake(5, 0, width, CGFloat.max))
        label.numberOfLines = numberOfLines
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    //MARK:- rounded corners
    class func  setViewWithRoundedCorners(anyView:UIView, color:UIColor, cornerRadius:CGFloat, borderColor:UIColor, borderWidth:CGFloat)
    {
        anyView.backgroundColor = color
        anyView.layer.cornerRadius = cornerRadius
        anyView.layer.borderColor = borderColor.CGColor
        anyView.layer.borderWidth = borderWidth
        anyView.clipsToBounds = true
    }
    
    class func  setImageViewWithRoundedCorners(anyView:UIImageView, color:UIColor, cornerRadius:CGFloat, borderColor:UIColor, borderWidth:CGFloat)
    {
        anyView.backgroundColor = color
        anyView.layer.cornerRadius = cornerRadius
        anyView.layer.borderColor = borderColor.CGColor
        anyView.layer.borderWidth = borderWidth
        anyView.clipsToBounds = true
    }
    
    
    class func roundCorners(corners:UIRectCorner, radius: CGFloat, anyView:UILabel)
    {
        let maskPath = UIBezierPath(roundedRect: anyView.bounds, byRoundingCorners: corners, cornerRadii: CGSizeMake(radius, radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = anyView.bounds;
        maskLayer.path = maskPath.CGPath;
        anyView.layer.mask = maskLayer;
    }
    
    
    //MARK:- Add Delay
    class func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    //MARK:- Loading View
    func createLoadingView(loaderString:String,textOfLoader:String, displayText:Bool,largeLoader:Bool)->UIView
    {
        let backgroundView : UIView = UIView()
        
        if(largeLoader)
        {
            backgroundView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
            
            let backgroundImageView : UIImageView = UIImageView()
            backgroundImageView.frame = CGRectMake(0, 0, backgroundView.frame.size.width, backgroundView.frame.size.height)
            backgroundImageView.backgroundColor = UIColor.blackColor()
            backgroundImageView.alpha = 0.7
            // backgroundView.userInteractionEnabled = false
            backgroundView.addSubview(backgroundImageView)
            // println_debug("backgroundImageView.frame: \(backgroundImageView.frame)")
            
            let activityIndicatorView : UIActivityIndicatorView = UIActivityIndicatorView()
            activityIndicatorView.frame = CGRectMake(0, 0, 50.0,50.0)
            activityIndicatorView.center = backgroundView.center
            activityIndicatorView.startAnimating()
            backgroundView.addSubview(activityIndicatorView)
            
            let loadingLabel : UILabel = UILabel()
            
            //loadingLabel.textAlignment = NSTextAlignment.Center
            //   loadingLabel.frame = CGRectMake(backgroundView.center.x-40, backgroundView.center.y+5, backgroundView.frame.size.width-120, 60)
            
            loadingLabel.frame = CGRectMake(backgroundView.frame.origin.x+50, backgroundView.center.y+5, backgroundView.frame.size.width-90, 65)
            
            loadingLabel.text = loaderString
            loadingLabel.textColor = UIColor.whiteColor()
            loadingLabel.font = UIFont(name: CustomFonts.museosans300.rawValue, size: 16)
            loadingLabel.numberOfLines = 0
            loadingLabel.adjustsFontSizeToFitWidth = true
            loadingLabel.hidden = true
            backgroundView.addSubview(loadingLabel)
            
            if(displayText)
            {
                let loadingResonLabel : UILabel = UILabel()
                loadingResonLabel.frame = CGRectMake(backgroundView.frame.origin.x+50, backgroundView.center.y+5, backgroundView.frame.size.width-90, 65)
                loadingResonLabel.text = textOfLoader
                loadingResonLabel.textColor = UIColor.whiteColor()
                loadingResonLabel.font = UIFont(name:  CustomFonts.museosans300.rawValue, size: 15)
                loadingResonLabel.numberOfLines = 0
                loadingResonLabel.adjustsFontSizeToFitWidth = true
                loadingResonLabel.textAlignment = NSTextAlignment.Center
                backgroundView.addSubview(loadingResonLabel)
            }
        }
        else
        {
            backgroundView.frame = CGRectMake(0, 64, screenWidth, screenHeight-64)
            
            let backgroundImageView : UIImageView = UIImageView()
            backgroundImageView.frame = CGRectMake(backgroundView.frame.size.width/2-50, backgroundView.frame.size.height/2-50, 100, 100)
            backgroundImageView.backgroundColor = UIColor.blackColor()
            backgroundImageView.alpha = 0.7
            //backgroundView.userInteractionEnabled = false
            backgroundView.addSubview(backgroundImageView)
            // println_debug("backgroundImageView.frame: \(backgroundImageView.frame)")
            
            HelpingClass.setImageViewWithRoundedCorners(backgroundImageView, color: UIColor.blackColor(), cornerRadius: 3.0, borderColor: UIColor.clearColor(), borderWidth: 1.0)
            
            
            let activityIndicatorView : UIActivityIndicatorView = UIActivityIndicatorView()
            
            // activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            
            activityIndicatorView.frame = CGRectMake(backgroundView.frame.size.width/2-25, backgroundView.frame.size.height/2-25, 50.0,50.0)
            
            //            activityIndicatorView.center = backgroundView.center
            activityIndicatorView.color = UIColor.whiteColor()
            
            activityIndicatorView.startAnimating()
            
            backgroundView.addSubview(activityIndicatorView)
        }
        
        
        
        return backgroundView
    }
    
    func showGloabalLoader(title: String, text: String, displayText: Bool,view: UIView,largeLoaderUse: Bool)
    {
        self.loadingView = self.createLoadingView(title, textOfLoader: text, displayText: displayText,largeLoader:largeLoaderUse)
        
        
        
        view.addSubview(self.loadingView )
        view.bringSubviewToFront(self.loadingView)
    }
    
    
    
    func hideGloabalLoader()
    {
        if(self.loadingView != nil)
        {
            self.loadingView.removeFromSuperview()
            
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    //set Tabbar Controller as a Root
    
    //MARK:- Validations
    
    //   class func isValidEmail(testStr:String) -> Bool {
    //
    //        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    //        let range = testStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
    //        let result = range != nil ? true : false
    //        return result
    //
    //    }
    //    class func isValidPhone(value: String) -> Bool {
    //
    //        let charcter  = NSCharacterSet(charactersInString: "+0123456789").invertedSet
    //        var filtered:NSString!
    //        let inputString:NSArray = value.componentsSeparatedByCharactersInSet(charcter)
    //        filtered = inputString.componentsJoinedByString("")
    //        return  value == filtered
    //    }
    
    
    class func timeAgoSinceDate(date:NSDate,currentDate:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.currentCalendar()
        let now = currentDate
        let earliest = now.earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:NSDateComponents = calendar.components([NSCalendarUnit.Minute , NSCalendarUnit.Hour , NSCalendarUnit.Day , NSCalendarUnit.WeekOfYear , NSCalendarUnit.Month , NSCalendarUnit.Year , NSCalendarUnit.Second], fromDate: earliest, toDate: latest, options: NSCalendarOptions())
        
        if (components.year >= 2) {
            return "\(components.year) years ago"
        } else if (components.year >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month >= 2) {
            return "\(components.month) months ago"
        } else if (components.month >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear >= 2) {
            return "\(components.weekOfYear) weeks ago"
        } else if (components.weekOfYear >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day >= 2) {
            return "\(components.day) days ago"
        } else if (components.day >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour >= 2) {
            return "\(components.hour) hours ago"
        } else if (components.hour >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute >= 2) {
            return "\(components.minute) minutes ago"
        } else if (components.minute >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second >= 3) {
            return "\(components.second) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
   class func isValidEmail(testStr:String) -> Bool {
        
        print("validate emilId: \(testStr)")
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluateWithObject(testStr)
        
        return result
       
    }
    
   class func validatePhone(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        
        let phoneResult =  phoneTest.evaluateWithObject(value)
        
        return phoneResult
        
    }
    
    
}
