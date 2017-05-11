//
//  MenuVC.swift
//  ProactiveLiving
//
//  Created by Affle on 26/10/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit
import CoreTelephony

enum userType {
    case Own
    case Friend
}

class MenuVC: UIViewController, UISearchBarDelegate {

    
    
//MARK:- Outlets
    
   // @IBOutlet weak var search_bar: UISearchBar!
    @IBOutlet weak var table_view: UITableView!
    @IBOutlet var viewAddFriend: UIView!

    
//MARK:- Properties
    
    var bottomTabBar : CustonTabBarController!
    var statusLbl : UILabel!
    
    
//MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        bottomTabBar = self.tabBarController as? CustonTabBarController
        table_view.tableFooterView = UIView(frame : CGRectZero)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        
        
        
        bottomTabBar!.setTabBarVisible(true, animated: true) { (finish) in
            // print_debug(finish)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Search bar resign
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
       // self.search_bar.resignFirstResponder()
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
      //  self.search_bar.resignFirstResponder()
    }
    
    
    
    //MARKS: - Service Call
    
    func sendStatusAPI(textStr:String) {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            parameters["userStatus"] = textStr
            
            //call global web service class latest
            Services.postRequest(ServiceUpdateProfileStatus, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        print_debug(responseDict["result"])

                        if let result = responseDict["result"] {
                            
                       //     AppHelper.showAlertWithTitle(AppName, message: "Status is  " + String(otp), tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                            AppHelper.saveToUserDefaults(result, withKey: userProfileStatus)
                            
                            self.table_view.reloadData()
                            
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


 // MARK: - UITableViewDataSource Method

extension MenuVC: UITableViewDataSource{
    
   
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        if indexPath.row == 0 {
            return 52
        }
        else if indexPath.row == 5 || indexPath.row == 6{    // as per client request 3/04/2017
            return 0
        }
        else{
        return 55
        
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 12
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell-" + String(indexPath.row + 1)
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        cell.selectionStyle = .Default
        cell.accessoryType = .DisclosureIndicator
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        
        // self.table_view.separatorColor = UIColor.lightGrayColor()
        
        
        switch indexPath.row {
        case 0:
            let iv_profile = cell.contentView.viewWithTag(1) as! UIImageView
            let lbl_title = cell.contentView.viewWithTag(2) as! UILabel
            
            let url = NSURL(string: HelpingClass.getUserDetails().imgUrl)
            
            iv_profile.sd_setImageWithURL(url, placeholderImage: UIImage(named: "user"))
            lbl_title.text = AppHelper.userDefaultsForKey("user_firstName") as? String
            cell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, cell.bounds.size.width)

            
            
            //make circle profile image
            iv_profile.layer.borderWidth = 2.0
            iv_profile.contentMode = .ScaleAspectFill
            iv_profile.backgroundColor = UIColor.whiteColor()
            iv_profile.layer.masksToBounds = false
            iv_profile.layer.borderColor = UIColor.lightGrayColor().CGColor
            iv_profile.layer.cornerRadius = 17
            iv_profile.clipsToBounds = true
            
            break
            
        case 1:  // Status Sharing
            let lbl_title = cell.contentView.viewWithTag(2) as! UILabel
            lbl_title.layer.borderColor = UIColor(red:172.0/255.0, green:172.0/255.0, blue:172.0/255.0, alpha: 1.0).CGColor
            lbl_title.textColor = UIColor.blackColor()
            lbl_title.layer.borderWidth = 1.0
            cell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, cell.bounds.size.width)
            cell.accessoryType = .None
        
           // self.table_view.separatorColor = UIColor.clearColor()
            
            self.statusLbl = lbl_title
            
            
            if let status = AppHelper.userDefaultsForKey(userProfileStatus) {
                statusLbl.text = status as? String
            }else{
                 statusLbl.textColor = UIColor.grayColor()
                 statusLbl.text = "Share your status here."
            }
            
            break
            
      /*  case 4:
            cell.selectionStyle = .None
            cell.accessoryType = .None
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            cell.layoutMargins = UIEdgeInsetsZero;
            break*/
            
        case 11:
            cell.selectionStyle = .Default
            cell.accessoryType = .None
            break
            
        default:
            break
            
        }
        
        
        return cell;
    }
}


//MARK:- Table View Delegate

extension MenuVC:UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        switch indexPath.row {
            
            //Profile
        case 0:

            let vc = AppHelper.getProfileStoryBoard().instantiateViewControllerWithIdentifier("ProfileContainerVC") as! ProfileContainerVC
            vc.viewerUserID = AppHelper.userDefaultsForKey(_ID) as! String
       //     let v = AppHelper.getProfileStoryBoard().instantiateViewControllerWithIdentifier("ProfileVC") as! ProfileVC
            self.navigationController?.pushViewController(vc , animated: true)
            self.navigationController?.navigationBarHidden = true
     
            break
            
            //Profile status
        case 1:

            self.showAlert()
            break
            
            //Contacts
        case 2:
            
            let vc = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("AllContactsVC") as! AllContactsVC
            vc.fromVC = "Menu"
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
           // Invite Friend
        case 3:
            
             self.openDefaultSharing("")
             break
            
            //add afriend
        case 4:
            
            let vc = AppHelper.getSecondStoryBoard().instantiateViewControllerWithIdentifier("DeleteACVC") as! DeleteACVC
            vc.vcType = .AddFriend
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
            //Get my pass
        case 5:

            break
            
            //Fav
        case 6:

            break
         
            //Settings
        case 7:
            
            let settingVC: SettingsMainVC = self.storyboard!.instantiateViewControllerWithIdentifier("SettingsMainVC") as! SettingsMainVC
            self.navigationController?.pushViewController(settingVC, animated: true)
            break
            
             //Help
        case 8:
           
            let helpVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("HelpViewController") as! HelpViewController
            self.navigationController?.pushViewController(helpVC, animated: true)
            break
            
            
            //TERMS N POLICIES
        case 9:
            
            let WebVC:WebViewVC = self.storyboard!.instantiateViewControllerWithIdentifier("WebViewVC") as! WebViewVC
            WebVC.pageName = "TERMSNPOLICIES"
            self.navigationController?.pushViewController(WebVC, animated: true)
            break
            
        
            //About Us
        case 10:
            
            //let aboutVC: AboutPASInstVC = self.storyboard!.instantiateViewControllerWithIdentifier("AboutPASInstVC") as! AboutPASInstVC
            //self.navigationController?.pushViewController(aboutVC, animated: true)
            
            let WebVC:WebViewVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("WebViewVC") as! WebViewVC
            WebVC.title = "About Us"
            WebVC.urlStr = "http://www.proactively.com/"
            self.navigationController?.pushViewController(WebVC, animated: true)
            break
            
            //LogOut
        case 11:
            
            let alertController = UIAlertController(title:APP_NAME, message: "Do you want to logout ?" , preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
            }))
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                
                do{
                    //Disconect Chat
                    let x = try? ChatListner.getChatListnerObj().closeConnection()
                    print_debug("",x)
                }catch {
                    
                }
                
                
                do{
                    //Disconect Chat
                    let x = try?
                        //delete all key from User Default
                        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
                    NSUserDefaults.standardUserDefaults().synchronize()
                    DataBaseController.sharedInstance.deleteEverything()
                    print_debug("",x)
                }catch {
                    
                }
                
                self.navigationController?.navigationBarHidden = true
                //
                
                let loginVC:LoginVC = self.storyboard!.instantiateViewControllerWithIdentifier("LoginVC") as! LoginVC
                let nav = UINavigationController.init(rootViewController: loginVC)
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                appDelegate.window?.rootViewController = nav
                
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
            
            break
        default:
            break
        }
        
        self.table_view.reloadData()
        //self.search_bar.resignFirstResponder()
        
    }
    
    
    //MARK:- UIAlertController
    
    func showAlert() -> Void {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: AppName, message: "Update your status.", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            
            textField.delegate = self
            
            if let status = AppHelper.userDefaultsForKey(userProfileStatus) {
                textField.text = status as? String
            }else{
                textField.text = "Available."
            }
            
        })
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler:{ [weak alert] (action) -> Void in
            
            }))
        
        //3. Grab the value from the text field, and print_debug it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { [weak alert] (action) -> Void in
            
            let textField = alert!.textFields![0] as UITextField
            print_debug("Text field: \(textField.text)")
            
            if ((textField.text?.isBlank) == true) {
                self.statusLbl.text = "  Available"
                // hit API
                self.sendStatusAPI("  Available")
            }
            else{
                
                
                let finalStr = "  " + textField.text!
                self.sendStatusAPI(finalStr)
            }
            
            // hit API
            // self.sendStatusAPI(textField.text!)
            
            }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

//MARK:- Open Default Sharing

    func openDefaultSharing(textStr:String) -> Void {
        
        let textToShare = textStr
        
        if let myWebsite = NSURL(string: "http://www.proactively.com/") {
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
            //
            
            //  activityVC.popoverPresentationController?.sourceView = sender
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }

}

//MARK:- TextView Delegate

extension MenuVC : UITextFieldDelegate {
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
       
        
        if (range.location > 34){  // 35 characters limit
            return false
        }
        else{
            return true
        }
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        textField.textColor = UIColor.blackColor()
        
        if let status = AppHelper.userDefaultsForKey(userProfileStatus) {
            // white space removal from begining of string
            let range = status.rangeOfString("^\\s*", options: .RegularExpressionSearch)
            let result = status.stringByReplacingCharactersInRange(range, withString: "")
            textField.text = result
        }else{
            textField.text = "Available."
        }
        
    }
    
    
}
