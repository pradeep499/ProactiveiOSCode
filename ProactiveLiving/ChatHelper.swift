//
//  ChatHelper.swift
//  MelderEventApp
//
//  Created by Sunil Kaushik on 9/15/15.
//  Copyright (c) 2015 Jyoti Sharma. All rights reserved.
//

import UIKit
import Foundation


class ChatHelper: NSObject {
    
    var activityIndicator:UIActivityIndicatorView?
    
    var activityView:UIView?
    
    class var sharedInstance : ChatHelper
    {
        struct Static
        {
            static var onceToken : dispatch_once_t = 0
            static var instance : ChatHelper? = nil
        }
        dispatch_once(&Static.onceToken)
            {
                Static.instance = ChatHelper()
        }
        return Static.instance!
    }
    
    //MARK: UserDefault
    class func saveToUserDefault(value:AnyObject, key:String)
    {
        
        NSUserDefaults.standardUserDefaults().setObject(value, forKey:key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func userDefaultForKey(key:String) -> String
    {
        var optional:String?
        optional = NSUserDefaults.standardUserDefaults().objectForKey(key) as? String
        
        if (optional != nil)
        {
            return NSUserDefaults.standardUserDefaults().objectForKey(key) as! String
        }
        else
        {
            return ""
        }
    }
    
    class func userDefaultForAny(key:String) -> AnyObject
    {
        //var optional:AnyObject?
        if let _: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(key) as AnyObject!
        {
            //        if (optional != nil)
            //        {
            return NSUserDefaults.standardUserDefaults().objectForKey(key) as AnyObject!
        }
        else
        {
            return ""
        }
        
        //return NSUserDefaults.standardUserDefaults().objectForKey(key) as AnyObject!
        
    }
    
    class func userdefaultForArray(key:String) -> Array<AnyObject>
    {
        
        return NSUserDefaults.standardUserDefaults().objectForKey(key) as! Array
        
    }
    
    class func removeFromUserDefaultForKey(key:String)
    {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        NSUserDefaults.standardUserDefaults().synchronize()
        
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
    
    //MARK:- Dynamic Height for Label
    class func heightForLabel(text:String, font:UIFont, width:CGFloat, numberOfLines:Int) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = numberOfLines
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    //MARK:- Adjust Height with Max Height Limit
    class func adjustHeight_Label(text:String, font:UIFont, width:CGFloat, maxHeight:CGFloat, numberOfLines:Int) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, maxHeight))
        label.numberOfLines = numberOfLines
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    //MARK:- Dynamic Width for Label
    class func widthForLabel(text:String, font:UIFont, height:CGFloat, numberOfLines:Int) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, CGFloat.max, height))
        label.numberOfLines = numberOfLines
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        
        return label.frame.width
    }
}

//MARK:- Add Delay
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

//MARK:- Activity Indicator
func showActivityIndicator(view:UIView)
{
    activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    activityIndicator!.backgroundColor = UIColor.blackColor()
    activityIndicator!.frame = CGRectMake(200.0, 200.0, 60.0, 60.0)
    activityIndicator!.layer.cornerRadius = 10.0
    activityIndicator!.alpha = 0.7
    activityIndicator!.center = view.center
    view.addSubview(activityIndicator!)
    activityIndicator!.startAnimating()
}

func stopActivityIndicator(view:UIView)
{
    if(activityIndicator != nil)
    {
        activityIndicator!.stopAnimating()
    }
}

func showActivityIndicatorFullScreen(view:UIView)
{
    activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    activityIndicator!.backgroundColor = UIColor.clearColor()
    
    let myview = UIView(frame: CGRectMake(0, 0, view.frame.size.width, view.frame.size.height))
    myview.backgroundColor = UIColor.blackColor()
    myview.alpha = 0.7
    
    activityIndicator!.frame = CGRectMake(200.0, 200.0, 60.0, 60.0)
    activityIndicator!.layer.cornerRadius = 10.0
    activityIndicator!.alpha = 0.7
    activityIndicator!.center = myview.center
    myview.addSubview(activityIndicator!)
    view.addSubview(myview)
    activityIndicator!.startAnimating()
}

func stopActivityIndicatorFullScreen(view:UIView)
{
    if(activityIndicator != nil)
    {
        activityIndicator!.stopAnimating()
    }
}

func showInternetNotAvailable_Alert(view:UIViewController)
{
    if(UIDevice.currentDevice().systemVersion.hasPrefix("7"))
    {
        ChatHelper.showALertWithTag(121, title: "Error", message: "Internet Connection not available.", delegate: view, cancelButtonTitle: "Ok", otherButtonTitle: nil)
    }
    else
    {
        let alertController = UIAlertController(title:"Error", message: "Internet Connection not available.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        view.presentViewController(alertController, animated: true, completion: nil)
    }
}

//MARK:- Fetch user Name
func fetch_PhoneName(userId:String)->String
{
    let str:String = "userId == \"\(userId)\""
    let instance = DataBaseController.sharedInstance
    let fetchResult=instance.fetchData("AppContactList", predicate: str, sort: ("name",true))!
    if fetchResult.count > 0
    {
        for myobject : AnyObject in fetchResult
        {
            let anObject = myobject as! AppContactList
            if(anObject.name!.characters.count > 0)
            {
                return (anObject.name! as String)
            }
        }
    }
    else
    {
        return " "
    }
    return " "
}

class UIBorderedLabel: UILabel
{
    
    var topInset:       CGFloat = 0
    var rightInset:     CGFloat = 0
    var bottomInset:    CGFloat = 0
    var leftInset:      CGFloat = 0
    
    override func drawTextInRect(rect: CGRect)
    {
        let insets: UIEdgeInsets = UIEdgeInsets(top: self.topInset, left: self.leftInset, bottom: self.bottomInset, right: self.rightInset)
        self.setNeedsLayout()
        return super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
    
}


//NSDate Extension
extension NSDate
{
//    func yearsFrom(date:NSDate) -> Int{
//        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: nil).year
//    }
//    func monthsFrom(date:NSDate) -> Int{
//        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: nil).month
//    }
//    func weeksFrom(date:NSDate) -> Int{
//        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekOfYear, fromDate: date, toDate: self, options: nil).weekOfYear
//    }
//    func daysFrom(date:NSDate) -> Int{
//        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitDay, fromDate: date, toDate: self, options: nil).day
//    }
//    func hoursFrom(date:NSDate) -> Int{
//        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour, fromDate: date, toDate: self, options: nil).hour
//    }
//    func minutesFrom(date:NSDate) -> Int{
//        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMinute, fromDate: date, toDate: self, options: nil).minute
//    }
//    func secondsFrom(date:NSDate) -> Int{
//        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitSecond, fromDate: date, toDate: self, options: nil).second
//    }
//    func offsetFrom(date:NSDate) -> String
//    {
//        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
//        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
//        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
//        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
//        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
//        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
//        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
//        return ""
//    }
    
 //   return ""

   
}
