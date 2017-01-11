//
//  EditAboutMeVC.swift
//  ProactiveLiving
//
//  Created by Affle on 11/01/2017.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit

class EditAboutMeVC: UIViewController {
    
    
    
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    
    
    @IBOutlet weak var tv_summary: UITextView!
    @IBOutlet weak var tf_liveIn: CustomTextField!
    @IBOutlet weak var tf_workAt: CustomTextField!
    @IBOutlet weak var tf_grewUp: CustomTextField!
    @IBOutlet weak var tf_highSchool: CustomTextField!
    @IBOutlet weak var tf_sportsCer: CustomTextField!
    @IBOutlet weak var tf_college: CustomTextField!
    @IBOutlet weak var tf_sportsPlayed: CustomTextField!
    @IBOutlet weak var tf_graduateSchool: CustomTextField!
    @IBOutlet weak var tf_currentSports: CustomTextField!
    @IBOutlet weak var tv_interest: UITextView!
    @IBOutlet weak var tv_favQuote: UITextView!
    @IBOutlet weak var tv_myNotFavQuote: UITextView!
    @IBOutlet weak var tv_myBio: UITextView!
    
    
    var errorStr:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tv_summary.text = ""
        self.tv_interest.text = ""
        self.tv_favQuote.text = ""
        self.tv_myNotFavQuote.text = ""
        self.tv_myBio.text = ""
        
        self.tv_interest!.layer.borderWidth = 0.4
        self.tv_interest!.layer.borderColor = UIColor.grayColor().CGColor
        
        self.tv_favQuote!.layer.borderWidth = 0.4
        self.tv_favQuote!.layer.borderColor = UIColor.grayColor().CGColor
        
        self.tv_myNotFavQuote!.layer.borderWidth = 0.4
        self.tv_myNotFavQuote!.layer.borderColor = UIColor.grayColor().CGColor
        
        self.tv_summary!.layer.borderWidth = 0.4
        self.tv_summary!.layer.borderColor = UIColor.grayColor().CGColor
        
        self.tv_myBio!.layer.borderWidth = 0.4
        self.tv_myBio!.layer.borderColor = UIColor.grayColor().CGColor
        
        IQKeyboardManager.sharedManager().enable=true
        IQKeyboardManager.sharedManager().enableAutoToolbar=true
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onClickCancelBtn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func onClickDoneBtn(sender: AnyObject) {
        
        errorStr = ""
        if self.tv_summary.text?.characters.count < 1 {
            errorStr = "Summary field can't be blank."
           
        }else if self.tf_liveIn.text?.characters.count < 1 {
            
            errorStr = "Live in field can't be blank."
        }else if self.tv_interest.text?.characters.count < 1 {
           
            errorStr = "Interest field can't be blank."
        }else if self.tv_myBio.text?.characters.count < 1 {
            
            errorStr = "My Bio field can't be blank."
        }
        
        if errorStr?.characters.count > 1 {
            AppHelper.showAlertWithTitle(AppName, message: errorStr, tag: 0, delegate: nil, cancelButton: "Ok", otherButton: nil)
            return
        }
        
        self.updateProfileAPI()
    }
    
    @IBAction func onClickMaleBtn(sender: AnyObject) {
    }
    
    
    @IBAction func onClickFeMaleBtn(sender: AnyObject) {
    }
    
    
    
    
    //MARKS: - Service Call
    
    func updateProfileAPI() {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
        //    parameters["password"] = self.tf_pwd.text
        //   parameters["oldMobile"] = self.tf_OldMb.text
            
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
    
    
    

}
