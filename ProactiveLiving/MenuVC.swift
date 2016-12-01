//
//  MenuVC.swift
//  ProactiveLiving
//
//  Created by Affle on 26/10/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit

class MenuVC: UIViewController, UISearchBarDelegate {

    
    @IBOutlet weak var search_bar: UISearchBar!
    
    @IBOutlet weak var table_view: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
}

extension MenuVC: UITableViewDataSource{
    

    // MARK: - UITableViewDelegate Method
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 55
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10
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
            
            
        case 4:
            cell.selectionStyle = .None
            cell.accessoryType = .None
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            cell.layoutMargins = UIEdgeInsetsZero;
            break
            
        case 9:
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

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        switch indexPath.row {
        case 5:
            
            let settingVC: SettingsMainVC = self.storyboard!.instantiateViewControllerWithIdentifier("SettingsMainVC") as! SettingsMainVC
            
            self.navigationController?.pushViewController(settingVC, animated: true)
            break
        case 7:
            let WebVC:WebViewVC = self.storyboard!.instantiateViewControllerWithIdentifier("WebViewVC") as! WebViewVC
            WebVC.pageName = "TERMSNPOLICIES"
            self.navigationController?.pushViewController(WebVC, animated: true)
            break
        case 8:
            let aboutVC: AboutPASInstVC = self.storyboard!.instantiateViewControllerWithIdentifier("AboutPASInstVC") as! AboutPASInstVC
            
            self.navigationController?.pushViewController(aboutVC, animated: true)
            break
        case 9:
            
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
