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

    
    @IBOutlet weak var search_bar: UISearchBar!
    
    @IBOutlet weak var table_view: UITableView!
    
    var bottomTabBar : CustonTabBarController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        bottomTabBar = self.tabBarController as? CustonTabBarController
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        
        
        
        bottomTabBar!.setTabBarVisible(true, animated: true) { (finish) in
            // print(finish)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Search bar resign
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        self.search_bar.resignFirstResponder()
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.search_bar.resignFirstResponder()
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
                        
                        print(responseDict["result"])
                        
                         
                        
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

extension MenuVC: UITableViewDataSource{
    

    // MARK: - UITableViewDelegate Method
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 55
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
        
        
        
        
        switch indexPath.row {
        case 0:
            let iv_profile = cell.contentView.viewWithTag(1) as! UIImageView
            let lbl_title = cell.contentView.viewWithTag(2) as! UILabel
            
            let url = NSURL(string: AppHelper.userDefaultsForKey("user_imageUrl") as! String)
            
            iv_profile.sd_setImageWithURL(url, placeholderImage: UIImage(named: "user"))
            lbl_title.text = AppHelper.userDefaultsForKey("user_firstName") as? String
            
            //make circle profile image
            iv_profile.layer.borderWidth = 1.0
            iv_profile.contentMode = .ScaleAspectFill
            iv_profile.backgroundColor = UIColor.whiteColor()
            iv_profile.layer.masksToBounds = false
            iv_profile.layer.borderColor = UIColor.lightGrayColor().CGColor
            iv_profile.layer.cornerRadius = iv_profile.frame.size.height/2
            iv_profile.clipsToBounds = true
            
            break
            
        case 1:
            let lbl_title = cell.contentView.viewWithTag(2) as! UILabel
            
            if let status = AppHelper.userDefaultsForKey(userProfileStatus) {
                lbl_title.text = status as? String
            }else{
                lbl_title.text = "Share your status here."
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
extension MenuVC:UITableViewDelegate{
    
    
    //MARK:-
    
    func showAlert() -> Void {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: AppName, message: "Update your status.", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            // textField.text = "Some default text."
        })
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { [weak alert] (action) -> Void in
            let textField = alert!.textFields![0] as UITextField
            print("Text field: \(textField.text)")
            
            // hit API
            self.sendStatusAPI(textField.text!)
            
            }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        switch indexPath.row {
            
            //Profile
        case 0:
            let vc = AppHelper.getProfileStoryBoard().instantiateViewControllerWithIdentifier("ProfileContainerVC") as! ProfileContainerVC
            vc.viewerUserID = AppHelper.userDefaultsForKey(_ID) as! String
            let v = AppHelper.getProfileStoryBoard().instantiateViewControllerWithIdentifier("ProfileVC") as! ProfileVC
            self.navigationController?.pushViewController(vc , animated: true)
            self.navigationController?.navigationBarHidden = true
     
            break
            
            //Profile status
        case 1:
            self.showAlert()
            break
            
            //Contacts
        case 2:
            break
            
           // Invite Friend
        case 3:
            break
            
            //add afriend
        case 4:
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
            break
            
         
            
            
            //TERMS N POLICIES
        case 9:
            let WebVC:WebViewVC = self.storyboard!.instantiateViewControllerWithIdentifier("WebViewVC") as! WebViewVC
            WebVC.pageName = "TERMSNPOLICIES"
            self.navigationController?.pushViewController(WebVC, animated: true)
            break
            //About Us
        case 10:
            let aboutVC: AboutPASInstVC = self.storyboard!.instantiateViewControllerWithIdentifier("AboutPASInstVC") as! AboutPASInstVC
            
            self.navigationController?.pushViewController(aboutVC, animated: true)
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
        self.search_bar.resignFirstResponder()
        
    }

}
