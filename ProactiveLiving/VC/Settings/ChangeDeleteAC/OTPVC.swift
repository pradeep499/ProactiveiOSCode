//
//  OTPVC.swift
//  ProactiveLiving
//
//  Created by Affle on 26/12/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit

class OTPVC: UIViewController {
    
    
    @IBOutlet weak var tf_otp: UITextField!
    @IBOutlet weak var viewOTP: UIView!
    
    var oldMBStr:String!
    var newMBStr:String!
    var pwdStr:String!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewOTP.layer.borderWidth = 1
        self.viewOTP.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.navigationController?.navigationBarHidden = true
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickBackBtn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func onClickResendOTPBtn(sender: AnyObject) {
   
    
    }
    
    
    
    @IBAction func onClickSubmitBtn(sender: AnyObject) {
    }
    
    
    
    
    
    //MARKS: - Service Call
    
    
    func requestOTPAPI() {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            parameters["password"] = self.pwdStr
            parameters["oldMobile"] = self.oldMBStr
            
            //call global web service class latest
            Services.postRequest(ServiceRequestOTP, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        print(responseDict["result"])
                        
                        if let otp = responseDict["result"]{
                            
                            AppHelper.showAlertWithTitle(AppName, message: "Your OTP is " + String(otp), tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                            
                        }
                        
                        
                        
                    } else {
                        
                        AppHelper.showAlertWithTitle(AppName, message: responseDict["errorMsg"] as! String, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    }
                    
                } else if (status == "Error"){
                    
                    AppHelper.showAlertWithTitle(AppName, message: serviceError, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    
                }
            })
            
        }
        else {
            AppDelegate.dismissProgressHUD()
            //show internet not available
            AppHelper.showAlertWithTitle(netError, message: netErrorMessage, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
        }
        
    }
    
    func sendOTPAPI() {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            parameters["otp"] = self.tf_otp.text
            parameters["newMobile"] = self.newMBStr
            
            //call global web service class latest
            Services.postRequest(ServiceRequestOTP, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        print(responseDict["result"])
                        
                        
                        AppHelper.showAlertWithTitle(AppName, message: responseDict["result"] as! String, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                        
                    } else {
                        
                        AppHelper.showAlertWithTitle(AppName, message: responseDict["errorMsg"] as! String, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    }
                    
                } else if (status == "Error"){
                    
                    AppHelper.showAlertWithTitle(AppName, message: serviceError, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    
                }
            })
            
        }
        else {
            AppDelegate.dismissProgressHUD()
            //show internet not available
            AppHelper.showAlertWithTitle(netError, message: netErrorMessage, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
        }
        
    }

}

 
