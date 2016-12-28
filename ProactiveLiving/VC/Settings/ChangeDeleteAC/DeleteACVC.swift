//
//  DeleteAcVC.swift
//  ProactiveLiving
//
//  Created by Affle on 26/12/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit
import CoreTelephony

class DeleteACVC: UIViewController, UIAlertViewDelegate {

    @IBOutlet weak var tableView_countryList: UITableView!
   
    @IBOutlet weak var tf_countryCode: CustomTextField!
    
    @IBOutlet weak var tf_phoneNo: CustomTextField!
    
    @IBOutlet weak var tf_pwd: CustomTextField!
    
    
    @IBOutlet weak var btn_countryCode: UIButton!
    
    @IBOutlet weak var layout_viewCountryListTop: NSLayoutConstraint!
    var countries: [String] = []
    var countriesPHNOCode: [String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = true
        
        ChatHelper.getCountryLitWithTelePhoneCode { (countries, codes) in
            self.countries = countries
            self.countriesPHNOCode = codes
            
        }
        
        
        
        
        self.layout_viewCountryListTop.constant = 1000
        
        IQKeyboardManager.sharedManager().enable=true
        IQKeyboardManager.sharedManager().enableAutoToolbar=true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func onClickBackBtn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    
    @IBAction func onClickCountryBtn(sender: AnyObject) {
        self.layout_viewCountryListTop.constant = 1
        
    }
    
    
    @IBAction func onClickSubmitBtn(sender: AnyObject) {
        
        if  self.tf_countryCode.text?.characters.count < 1 {
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Country Code cann't be blank.", delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            return
        }
        
        if  self.tf_phoneNo.text?.characters.count < 1 {
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Phone no Code cann't be blank.", delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            return
        }
        if  self.tf_pwd.text?.characters.count < 1 {
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Password Code cann't be blank.", delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            return
        }
        
        self.deleteACAPI()
        
        self.resignTextField()
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.resignTextField()
    }
    
    func resignTextField() -> Void {
        self.tf_countryCode.resignFirstResponder()
        self.tf_phoneNo.resignFirstResponder()
        self.tf_pwd.resignFirstResponder()
    }
    
    func goToLogInPage() -> Void {
        
        
        do{
            //Disconect Chat
            let x = try? ChatListner.getChatListnerObj().closeConnection()
            print("",x)
        }catch {
            
        }
        
        
        do{
            //Disconect Chat
            let x = try?
                //delete all key from User Default
                NSUserDefaults.standardUserDefaults().removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
            NSUserDefaults.standardUserDefaults().synchronize()
            DataBaseController.sharedInstance.deleteEverything()
            print("",x)
        }catch {
            
        }
        self.navigationController?.navigationBarHidden = true
        
        
        let loginVC:LoginVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("LoginVC") as! LoginVC
        let nav = UINavigationController.init(rootViewController: loginVC)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = nav
    }
    
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if alertView.tag == 11{
            self.goToLogInPage()
        }
    }
   
    
    //MARK: API
    
    
    func deleteACAPI() {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            parameters["password"] = self.tf_pwd.text
            parameters["mobile"] = self.tf_phoneNo.text
            
            //call global web service class latest
            Services.postRequest(ServiceDeleteAC, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        print(responseDict["result"])
                        
                        
                        AppHelper.showAlertWithTitle(AppName, message: responseDict["result"] as! String, tag: 11, delegate: self, cancelButton: ok, otherButton: nil)
                        
                    } else {
                        
                        AppHelper.showAlertWithTitle(AppName, message: responseDict["errorMsg"] as! String, tag: 0, delegate: self, cancelButton: ok, otherButton: nil)
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



extension DeleteACVC: UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return countries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as UITableViewCell!
        
        if (cell == nil) {
            cell = UITableViewCell(style:.Default, reuseIdentifier: "CELL")
        }
        
        cell.textLabel!.text = countries[indexPath.row] + " ( " + countriesPHNOCode[indexPath.row] + " )"
        return cell
    }
}

extension DeleteACVC: UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.btn_countryCode.setTitle(self.countries[indexPath.row], forState: .Normal)
        self.tf_countryCode.text = (self.countriesPHNOCode[indexPath.row] as NSString) .substringFromIndex(1)
        
        self.layout_viewCountryListTop.constant = 1000
    }
}
