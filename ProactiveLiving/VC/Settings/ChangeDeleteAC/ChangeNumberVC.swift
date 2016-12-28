//
//  ChangeNumberVC.swift
//  ProactiveLiving
//
//  Created by Affle on 26/12/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit

class ChangeNumberVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var tf_OldMbCountryCode: CustomTextField!

    @IBOutlet weak var tf_OldMb: CustomTextField!
    @IBOutlet weak var tf_newMbCountryCode: CustomTextField!
    
    @IBOutlet weak var tf_newMb: CustomTextField!
    
    @IBOutlet weak var tf_pwd: CustomTextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = true
        
        IQKeyboardManager.sharedManager().enable=true
        IQKeyboardManager.sharedManager().enableAutoToolbar=true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func resignTextField() -> Void{
        
        self.tf_newMbCountryCode.resignFirstResponder()
        self.tf_OldMbCountryCode.resignFirstResponder()
        self.tf_newMb.resignFirstResponder()
        self.tf_OldMb.resignFirstResponder()
        self.tf_pwd.resignFirstResponder()
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.resignTextField()
    }
    
    //MARK: textfield Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       
        return true
    }
    
    @IBAction func onClickBackBtn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    

    @IBAction func onClickSendOTPBtn(sender: AnyObject) {
        
        if  self.tf_OldMbCountryCode.text?.characters.count < 1 {
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Country code cann't be blank.", delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            return
        }
        
        if  self.tf_newMbCountryCode.text?.characters.count < 1 {
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Country code cann't be blank.", delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            return
        }
        if  self.tf_OldMb.text?.characters.count < 1 {
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Old mb no cann't be blank.", delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            return
        }
        if  self.tf_newMb.text?.characters.count < 1 {
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "New mb no cann't be blank.", delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            return
        }
        if  self.tf_pwd.text?.characters.count < 1 {
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Password cann't be blank.", delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            return
        }
        
     
        
        self.requestOTPAPI()
        
        self.resignTextField()
        
        
    }
    
    
    
    
    
    //MARKS: - Service Call
    
    func requestOTPAPI() {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            parameters["password"] = self.tf_pwd.text
            parameters["oldMobile"] = self.tf_OldMb.text
            
            //call global web service class latest
            Services.postRequest(ServiceRequestOTP, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        print(responseDict["result"])
                        
                        let otpVC:OTPVC = AppHelper.getSecondStoryBoard().instantiateViewControllerWithIdentifier("OTPVC") as! OTPVC
                        
                        otpVC.oldMBStr = self.tf_OldMb.text
                        otpVC.newMBStr = self.tf_newMb.text
                        otpVC.pwdStr = self.tf_pwd.text
                        
                        
                        self.navigationController?.pushViewController(otpVC, animated: true)
                         
                        
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

}
