//
//  CustomTextField.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 17/08/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit

class CustomTextField: UITextField, UITextFieldDelegate {

    let border = CALayer()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        let paddingView = UIView(frame: CGRectMake(0, 0, 2, 20))
        self.leftView = paddingView
        self.leftViewMode = .Always
        createBorder()
        //addBottomLine()
        self.delegate = self
        
    }
    
    func createBorder(){
        
        //border arround textfield
        let borderColor : UIColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1)
        self.layer.borderColor = borderColor.CGColor
        self.layer.borderWidth = 1.0
        
        //print("border created")
    }
    
    func addBottomLine() {
        //border below textfield
        let width = CGFloat(2.0)
        border.borderColor = UIColor.grayColor().CGColor
        border.frame = CGRect(x: 0, y: self.frame.size.height-width, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func pulseColor(){
        border.borderColor = UIColor.greenColor().CGColor
    }
    
    func normalColor(){
        border.borderColor = UIColor.grayColor().CGColor
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //print("focused")
        //pulseColor()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //print("lost focus")
        //normalColor()
    }
}
