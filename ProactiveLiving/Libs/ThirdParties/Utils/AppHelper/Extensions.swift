//
//  Extensions.swift
//  Hathway
//
//  Created by Aseem Akarshan on 5/26/16.
//  Copyright © 2016 Affle_Appstudioz. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    /**
     Create corner radius of UIView/SubClass.
     
     - parameter radius: corner radius.
     */
    
    func cornerRadius(radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.contentMode = UIViewContentMode.ScaleAspectFill
        self.clipsToBounds = true
    }
    
    
    /**
     make round border of UIView/SubClass by 4 px.
     */
    func roundBorder() {
        self.cornerRadius(4)
    }
    
    
    /**
     Make corner radius of specified value and add shadow effect around UIView/SubClass.
     
     - parameter cornerRadius: corner radius
     - parameter shadowRadius: shadow radius
     */
    
    func setCornerRadiusWithShadow(cornerRadius:CGFloat, shadowRadius:CGFloat) {
        self.layer.masksToBounds = false;
        self.layer.cornerRadius = cornerRadius; // if you like rounded corners
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = shadowRadius;
        self.layer.shadowOpacity = 0.5;
//        self.clipsToBounds = true
    }
    
    func setCornerRadiusWithBorderWidthAndColor(cornerRadius:CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = cornerRadius // if you like rounded corners
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.CGColor
//        self.clipsToBounds = true
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UITextField {
    func bottomBorder(borderColor color:UIColor, borderWidth width:CGFloat) {
        let bottomBorder:CALayer = CALayer()
        bottomBorder.frame = CGRectMake(0, self.frame.size.height - width, self.frame.size.width, width);
        bottomBorder.backgroundColor = UIColor.grayColor().CGColor
        self.layer.addSublayer(bottomBorder)
    }
    
    func addImage(image:UIImage) {
        
        let paddingView:UIImageView = UIImageView(frame: CGRectMake(0, 0, image.size.width + 22, image.size.height))
        let imageView:UIImageView = UIImageView(frame: CGRectMake(11, 0, image.size.width, image.size.height))
        imageView.image = image;
        paddingView.addSubview(imageView)
        self.leftView = paddingView
        self.leftViewMode = .Always
    }
    
    func addImageToRight(image:UIImage) {
        
        let paddingView:UIImageView = UIImageView(frame: CGRectMake(self.frame.width -  image.size.width  , 0, image.size.width, image.size.height))
        let imageView:UIImageView = UIImageView(frame: CGRectMake(-5, 0, image.size.width, image.size.height))
        imageView.image = image;
        paddingView.addSubview(imageView)
        self.rightView = paddingView
        self.rightViewMode = .Always
    }
    
    func rightPadding(size:CGFloat) {
        let paddingView:UIImageView = UIImageView(frame: CGRectMake(0, 0, size, self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .Always
    }
    
    func leftPadding(size:CGFloat) {
        let paddingView:UIImageView = UIImageView(frame: CGRectMake(0, 0, size, self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .Always
    }
}

extension UIButton {
    
    func toggleSelection() {
        self.selected = self.selected ? false : true
    }
    
    func setBackgroundColor(color: UIColor, forUIControlState state: UIControlState) {
        self.setBackgroundImage(imageWithColor(color), forState: state)
    }
    
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context!, color.CGColor)
        CGContextFillRect(context!, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }

}

extension Dictionary {
    mutating func addDictionary(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}

extension UILabel {
    
    func totalNumberOfLines() -> Int {
        let size:CGSize  = self.sizeThatFits(CGSizeMake(self.frame.size.width, CGFloat.max))
        return max(Int(size.height / self.font.lineHeight), 0)
    }
    
    func isTextTruncated() -> Bool {
        
        if let string = self.text {
            
            let size: CGSize = (string as NSString).boundingRectWithSize(
                CGSize(width: self.frame.size.width, height: CGFloat(FLT_MAX)),
                options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                attributes: [NSFontAttributeName: self.font],
                context: nil).size
            
            if (size.height > self.bounds.size.height) {
                return true
            }
        }
        
        return false
    }
}

extension NSDate {
    func yearsFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date: NSDate) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
    
    func getDayStringForFormat(format: String) -> String{
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(self)
    }
    
    func getTimeStringForFormat(format: String) -> String{
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(self)
    }
}

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    func isValidURL() -> Bool{
        let length:Int = self.characters.count
        var err:NSError?
        var dataDetector:NSDataDetector? = NSDataDetector()
        do{
            dataDetector = try NSDataDetector(types: NSTextCheckingType.Link.rawValue)
        }catch{
            err = error as NSError
        }
        if dataDetector != nil{
            let range = NSMakeRange(0, length)
            let notFoundRange = NSRange(location: NSNotFound, length: 0)
            let linkRange = dataDetector?.rangeOfFirstMatchInString(self, options: NSMatchingOptions.init(rawValue: 0), range: range)
            if !NSEqualRanges(notFoundRange, linkRange!) && NSEqualRanges(range, linkRange!){
                return true
            }
        }else{
            print("Could not create link data detector: \(err?.localizedDescription): \(err?.userInfo)")
        }
        
        return false
    }
}

extension UITableView {
    func setOffsetToBottom(animated: Bool) {
        self.setContentOffset(CGPointMake(0, self.contentSize.height - self.frame.size.height), animated: true)
    }
    
    func scrollToLastRow(animated: Bool) {
        if self.numberOfRowsInSection(0) > 0 {
            self.scrollToRowAtIndexPath(NSIndexPath(forRow: self.numberOfRowsInSection(0) - 1, inSection: 0), atScrollPosition: .Bottom, animated: animated)
        }
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}

extension UIColor {
    convenience init(_ r: CGFloat,_ g: CGFloat,_ b: CGFloat,_ a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}
