//
//  GenericProfileTableVC.swift
//  ProactiveLiving
//
//  Created by Affle on 10/01/2017.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit

enum ProfileGenericType{
    case AboutMe
    case Friends
    case Followers
    case Gallery
    case SocialNetworks
}

class GenericProfileTableVC: UIViewController {
    
    @IBOutlet weak var btnRight: UIButton!
    var genericType:ProfileGenericType?
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_summary: UILabel!
    @IBOutlet weak var tv: UITableView!
    
    @IBOutlet weak var headerView_AboutMe: UIView!    
    @IBOutlet weak var headerView_socialNetwork: UIView!
    
    var socialNetworkArr = [AnyObject]?()
    
    
    
    var tf_fb:UITextField?, tf_google:UITextField?, tf_linkedIn:UITextField?, tf_twitter:UITextField?, tf_inst:UITextField?
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpPage()
        
        IQKeyboardManager.sharedManager().enable=true
        IQKeyboardManager.sharedManager().enableAutoToolbar=true
         
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpPage() -> Void {
        
        
        
        if genericType == .AboutMe{
            self.lbl_title.text = "About Me"
            self.btnRight.hidden = false
            
            self.headerView_socialNetwork.hidden = true
            self.headerView_socialNetwork = nil
            
            self.lbl_summary.text = HelpingClass.getUserDetails().summary
            
        }else if genericType == .SocialNetworks {
            
            self.lbl_title.text = "Social Networks"
            self.btnRight.hidden = false
            self.btnRight.setTitle("Save", forState: .Normal)
            self.btnRight.setImage(UIImage(named: ""), forState: .Normal)
            
            self.headerView_AboutMe.hidden = true
            self.headerView_AboutMe = nil
            
            self.tv.tableHeaderView = self.headerView_socialNetwork
            
            
        }
        
        
    }
    
    
    //MARK: Btn Click
    
    
    @IBAction func onClickRightBtn(sender: AnyObject) {
        
        if genericType == .AboutMe{
            
            //go to Edit About Me
            let editAboutVC = AppHelper.getProfileStoryBoard().instantiateViewControllerWithIdentifier("EditAboutMeVC") as! EditAboutMeVC
            self.navigationController?.pushViewController(editAboutVC, animated: true)
            
        }else if genericType == .SocialNetworks {
            
            
            self.tf_fb?.resignFirstResponder()
            self.tf_google?.resignFirstResponder()
            self.tf_linkedIn?.resignFirstResponder()
            self.tf_twitter?.resignFirstResponder()
            self.tf_inst?.resignFirstResponder()
            //save social Network link 
            self.saveSocialLinkAPI()
            
            
        }
        
        
    }

    
    @IBAction func onClickBackBatn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    
    }
    
    
    
    //MARK: - Service Call
    
    func setSocialDict(tf:UITextField, type:String) -> [String:String] {
        
        
        var dict = [String:String]()
        dict["type"] = type
        
        var url = String()
        
        if((tf.text! as String).hasPrefix("http://") || (tf.text! as! String).hasPrefix("https://")){
            
            url = tf.text!
        }
        else
        {
            url = "http://" + tf.text!
        }
        
        url = url.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        
        dict["url"]  = url
        
        return dict
    }
    
    
    
    func saveSocialLinkAPI() {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
          
            var socialArr = [AnyObject]()
            
            if self.tf_fb?.text?.characters.count > 0 {
                
                socialArr.append(self.setSocialDict(self.tf_fb!, type: "fb"))
            }
            
            if self.tf_google?.text?.characters.count > 0 {
                
                socialArr.append(self.setSocialDict(self.tf_google!, type: "google"))
                
            }
            
            if self.tf_linkedIn?.text?.characters.count > 0 {
                
                socialArr.append(self.setSocialDict(self.tf_linkedIn!, type: "linkedIn"))
                
            }
            
            if self.tf_twitter?.text?.characters.count > 0 {
                
                socialArr.append(self.setSocialDict(self.tf_twitter!, type: "twitter"))
                
            }
            if self.tf_inst?.text?.characters.count > 0 {
                
                socialArr.append(self.setSocialDict(self.tf_inst!, type: "inst"))
                
            }
            
            parameters["socialNetwork"] = socialArr
            
            
            
            
            //call global web service class latest
            Services.postRequest(ServiceUpdateUserProfile, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        print(responseDict["result"])
                        
                      //  let result = responseDict["result"]
                        
                        
                        
                        AppHelper.showAlertWithTitle(AppName, message: "Your Profile is updated.", tag: 11, delegate: self, cancelButton: ok, otherButton: nil)
                        
                        
                        
                        
                        
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

extension GenericProfileTableVC:UITextFieldDelegate{
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
       
        if genericType == .SocialNetworks {
            
            textField.resignFirstResponder()
        }
        
        return true
    }
    
}
extension GenericProfileTableVC:UIAlertViewDelegate{
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if alertView.tag == 11 && buttonIndex == 0 {
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}

extension GenericProfileTableVC: UITableViewDataSource{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat    {
        
        if genericType == .AboutMe{
            
            return  self.setAboutMeCellHeight(tableView, indexPath: indexPath)
        }else if genericType == .SocialNetworks{
            return 70
        }
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if genericType == .AboutMe{
            return 13
         }else if genericType == .SocialNetworks{
            return 5
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
         if genericType == .AboutMe{
            return self.setUpAboutMeCell(tableView, indexPath:indexPath );
        }else if genericType == .SocialNetworks{
            
            return self.setUpSocialNetworkCell(tableView, indexPath: indexPath)
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        return cell
    }
    
    
    func setAboutMeCellHeight(tv: UITableView, indexPath: NSIndexPath) -> CGFloat {
        
       
        
        let obj:Beans.UserDetails = HelpingClass.getUserDetails()
        var newString = String()
        
        switch indexPath.row {
        case 0:
            newString =  obj.liveIn
            break
        case 1:
            newString =  obj.workAt
            break
            
        case 2:
           newString =  obj.grewUp
            break
            
        case 3:
           newString =  obj.highSchool
            break
            
        case 4:
           newString = obj.highSchoolSportsPlayed
            break
            
        case 5:
            newString =  obj.college
            break
            
        case 6:
            newString = obj.collegeSportsPlayed
            break
            
        case 7:
           newString =  obj.graduateSchool
            break
            
        case 8:
            newString = obj.currentSport
            break
            
        case 9:
            newString = obj.interests
            break
            
        case 10:
            newString = obj.favFamousQuote
            break
            
        case 11:
            newString = obj.notFamousQuote
            break
            
        case 12:
            newString =  obj.bio
            break
        default:
            break
        }
        
       
        
        
        let str = newString.stringByReplacingEmojiCheatCodesWithUnicode()
        
        
        let w = tv.bounds.size.width - 30
        let size : CGSize =  CommonMethodFunctions.sizeOfCell(str, fontSize: 15 , width: Float(w) , fontName: "Roboto-Regular")
        
        var height = size.height + (75)

        return height
        
    }
    
    func setUpSocialNetworkCell(tv: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =  tv.dequeueReusableCellWithIdentifier("SocialNetworkCell", forIndexPath: indexPath)
        
        
        
        let iv_social = cell.viewWithTag(1) as! UIImageView
        let tf = cell.viewWithTag(2) as! UITextField
        
        tf.delegate = self
        
        switch indexPath.row {
        case 0:
            iv_social.image = UIImage(named: "facebook")
            self.tf_fb = tf
            break
        case 1:
            iv_social.image = UIImage(named: "google")
            self.tf_google = tf
            break
        case 2:
            iv_social.image = UIImage(named: "linkden")
            self.tf_linkedIn = tf
            break
        case 3:
            iv_social.image = UIImage(named: "twitter")
            self.tf_twitter = tf
            break
        case 4:
            iv_social.image = UIImage(named: "insta")
            self.tf_inst = tf
            break
            
            
        default:
            break
        }
        
        if (self.socialNetworkArr != nil) {
 
            
            for dict in  self.socialNetworkArr! {
                let type = dict["type"] as? String
                let url = dict["url"] as? String
                
                if ( type == "fb") {
                    
                    self.tf_fb?.text = url
                }else if (type == "google" ){
                    
                    self.tf_google?.text = url
                }else if (type ) == "linkedIn" {
                    
                    self.tf_inst?.text = url
                }else if (type ) == "twitter" {
                    
                    self.tf_twitter?.text = url
                }else if (type ) == "inst" {
                    
                    self.tf_inst?.text   = url
                }
                
                
            }
        }

        
        
        
        
        
        
        return cell
    }




    
    
     func setUpAboutMeCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AboutMeCell", forIndexPath: indexPath)
        
        let iv = cell.viewWithTag(1) as! UIImageView
        let lbl_title = cell.viewWithTag(2) as! UILabel
        let lbl_details = cell.viewWithTag(3) as! UILabel
        
        //fetch archive NSData and unarchive as obj type
        let obj:Beans.UserDetails = HelpingClass.getUserDetails()
        
            
            switch indexPath.row {
            case 0:
                iv.image = UIImage(named: "mp_live_in")
                lbl_title.text = "Live in"
                lbl_details.text = obj.liveIn
                break
            case 1:
                iv.image = UIImage(named: "mp_work_at")
                lbl_title.text = "Work at"
                lbl_details.text = obj.workAt
                break
                
            case 2:
                iv.image = UIImage(named: "mp_grew_up")
                lbl_title.text = "Grew Up In"
                lbl_details.text = obj.grewUp
                break
                
            case 3:
                iv.image = UIImage(named: "mp_high_school")
                lbl_title.text = "High School"
                lbl_details.text = obj.highSchool
                break
                
            case 4:
                iv.image = UIImage(named: "mp_sports_play")
                lbl_title.text = "Sports Played"
                lbl_details.text = obj.highSchoolSportsPlayed
                break
                
            case 5:
                iv.image = UIImage(named: "mp_college")
                lbl_title.text = "College"
                lbl_details.text = obj.college
                break
                
            case 6:
                iv.image = UIImage(named: "mp_sports_played")
                lbl_title.text = "Sports Played"
                lbl_details.text = obj.collegeSportsPlayed
                break
                
            case 7:
                iv.image = UIImage(named: "mp_graduate_school")
                lbl_title.text = "Graduate School"
                lbl_details.text = obj.graduateSchool
                break
                
            case 8:
                iv.image = UIImage(named: "mp_current_sports")
                lbl_title.text = "Current Sports"
                lbl_details.text = obj.currentSport
                break
                
            case 9:
                iv.image = UIImage(named: "mp_intrests")
                lbl_title.text = "Interests"
                lbl_details.text = obj.interests
                break
                
            case 10:
                iv.image = UIImage(named: "mp_quotes")
                lbl_title.text = "Favorite Famous Quote"
                lbl_details.text = obj.favFamousQuote
                break
                
            case 11:
                iv.image = UIImage(named: "mp_quotes")
                lbl_title.text = "My Not-So-Famous Quote"
                lbl_details.text = obj.notFamousQuote
                break
                
            case 12:
                iv.image = UIImage(named: "mp_my_bio")
                lbl_title.text = "My Bio"
                lbl_details.text = obj.bio
                break
                
            default:
                break
            }
        
        
        return cell
    }
}

