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

var friendDetailsDict:[String:AnyObject]?

class GenericProfileTableVC: UIViewController {
    
    @IBOutlet weak var btnRight: UIButton!
    var genericType:ProfileGenericType?
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var tv_summary: UITextView!
    @IBOutlet weak var tv: UITableView!
    
    @IBOutlet weak var headerView_AboutMe: UIView!    
    @IBOutlet weak var headerView_socialNetwork: UIView!
    
    var socialNetworkArr = [AnyObject]?()
    //to check owner or friend not nill all time
    var viewerUserID:String!
    
    
    
    
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
            
            self.headerView_socialNetwork.hidden = true
            self.headerView_socialNetwork = nil
            self.tv.tableFooterView = UIView(frame: CGRectMake(0, 0, 0, 0))
            self.tv.tableHeaderView = self.headerView_AboutMe
            
            self.tv_summary.text = HelpingClass.getUserDetails().summary
            
            
            //check logged in user or friend
            if String(AppHelper.userDefaultsForKey(_ID)) == viewerUserID{
                //Owner
                self.btnRight.hidden = false
            }else{
                //Friend
                self.btnRight.hidden = true
                self.tv_summary.text = self.getFriendsValue("summary")
            }
            
            
        }else if genericType == .SocialNetworks {
            
            self.lbl_title.text = "Social Networks"
            
            self.btnRight.setTitle("Save", forState: .Normal)
            self.btnRight.setImage(UIImage(named: ""), forState: .Normal)
            
            self.headerView_AboutMe.hidden = true
            self.headerView_AboutMe = nil
            
            self.tv.tableHeaderView = self.headerView_socialNetwork
            
            //check logged in user or friend
            if String(AppHelper.userDefaultsForKey(_ID)) == viewerUserID{
                //Owner
                self.btnRight.hidden = false
            }else{
                //Friend
                self.btnRight.hidden = true
            }
            
            
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
            
            
            if isValidURLCheck() == true {
                
                  self.saveSocialLinkAPI()
                
            }
            
          
            
            
        }
        
        
    }

    //MARK:- Validation check
    
    func isValidURLCheck() -> Bool{
        
        let isValidFB =  validateUrl(self.tf_fb!.text!)
        let isValidGoogle =  validateUrl(self.tf_google!.text!)
        let isValidLinked =  validateUrl(self.tf_linkedIn!.text!)
        let isValidTwitter =  validateUrl(self.tf_twitter!.text!)
        let isValidInsta =  validateUrl(self.tf_inst!.text!)

        
        if isValidFB == false {
            
            // if TextField is empty then ignore since none of the field is mandatory
            
            if isEmptyUrl(self.tf_fb!.text!) == false {
                
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please input valid url for Facebook.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                return false
                
            }
            
        }
        
        if isValidGoogle == false {
            
            // if TextField is empty then ignore since none of the field is mandatory
            
            if isEmptyUrl(self.tf_google!.text!) == false {
                
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please input valid url for Google Plus.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                return false
                
            }
         
        }
         if isValidLinked == false {
            
            // if TextField is empty then ignore since none of the field is mandatory
            
            if isEmptyUrl(self.tf_linkedIn!.text!) == false {
                
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please input valid url for Linkedin.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                return false
                
            }
           
        }
         if isValidTwitter == false {
            
            // if TextField is empty then ignore since none of the field is mandatory
            
            if isEmptyUrl(self.tf_twitter!.text!) == false {
                
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please input valid url for Twitter.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                return false
                
            }
         
        }
        
        if isValidInsta == false {
            
            // if TextField is empty then ignore since none of the field is mandatory
            
            if isEmptyUrl(self.tf_inst!.text!) == false {
                
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please input valid url for Instagram.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                return false
                
            }
           
        }
        return true
    }
    
    
    func isEmptyUrl(str : String) -> Bool {
        
        
        if str.characters.count > 0 {
            
            return false
            
        }
        else {
            return true
        }
    }
    
    
    
    @IBAction func onClickBackBatn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        self.tf_fb?.resignFirstResponder()
        self.tf_google?.resignFirstResponder()
        self.tf_linkedIn?.resignFirstResponder()
        self.tf_twitter?.resignFirstResponder()
        self.tf_inst?.resignFirstResponder()
    
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

//MARK:- UITextFieldDelegate

extension GenericProfileTableVC:UITextFieldDelegate{
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
       
        if genericType == .SocialNetworks {
            
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    
//    func textFieldDidEndEditing(textField: UITextField) {
//        
//
////        let isValid =  validateUrl(textField.text!)
////        print("TEST \(isValid)")
////        if isValid == false {
////            
////            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please input valid url.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
////            
////        }
////        print("Did End")
//        
//    }
    
    
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
                }
                else if (type == "google" ){
                    
                    self.tf_google?.text = url
                }
                else if (type ) == "linkedIn" {
                    
                    self.tf_linkedIn?.text = url
                }
                else if (type ) == "twitter" {
                    
                    self.tf_twitter?.text = url
                }
                else if (type ) == "inst" {
                    
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
                
                //friends value
                if String(AppHelper.userDefaultsForKey(_ID)) != viewerUserID{
                    lbl_details.text = self.getFriendsValue("liveIn")
                }
                break
            case 1:
                iv.image = UIImage(named: "mp_work_at")
                lbl_title.text = "Work at"
                lbl_details.text = obj.workAt
                
                //friends value
                if String(AppHelper.userDefaultsForKey(_ID)) != viewerUserID{
                    lbl_details.text = self.getFriendsValue("workAt")
                }
                break
                
            case 2:
                iv.image = UIImage(named: "mp_grew_up")
                lbl_title.text = "Grew Up In"
                lbl_details.text = obj.grewUp
                
                //friends value
                if String(AppHelper.userDefaultsForKey(_ID)) != viewerUserID{
                    lbl_details.text = self.getFriendsValue("grewUp")
                }
                break
                
            case 3:
                iv.image = UIImage(named: "mp_high_school")
                lbl_title.text = "High School"
                lbl_details.text = obj.highSchool
                
                //friends value
                if String(AppHelper.userDefaultsForKey(_ID)) != viewerUserID{
                    lbl_details.text = self.getFriendsValue("highSchool")
                }
                break
                
            case 4:
                iv.image = UIImage(named: "mp_sports_play")
                lbl_title.text = "Sports Played"
                lbl_details.text = obj.highSchoolSportsPlayed
                
                //friends value
                if String(AppHelper.userDefaultsForKey(_ID)) != viewerUserID{
                    lbl_details.text = self.getFriendsValue("highSchoolSportsPlayed")
                }
                break
                
            case 5:
                iv.image = UIImage(named: "mp_college")
                lbl_title.text = "College"
                lbl_details.text = obj.college
                
                //friends value
                if String(AppHelper.userDefaultsForKey(_ID)) != viewerUserID{
                    lbl_details.text = self.getFriendsValue("college")
                }
                break
                
            case 6:
                iv.image = UIImage(named: "mp_sports_played")
                lbl_title.text = "Sports Played"
                lbl_details.text = obj.collegeSportsPlayed
                //friends value
                if String(AppHelper.userDefaultsForKey(_ID)) != viewerUserID{
                    lbl_details.text = self.getFriendsValue("collegeSportsPlayed")
                }
                break
                
            case 7:
                iv.image = UIImage(named: "mp_graduate_school")
                lbl_title.text = "Graduate School"
                lbl_details.text = obj.graduateSchool
                
                //friends value
                if String(AppHelper.userDefaultsForKey(_ID)) != viewerUserID{
                    lbl_details.text = self.getFriendsValue("graduateSchool")
                }
                
                break
                
            case 8:
                iv.image = UIImage(named: "mp_current_sports")
                lbl_title.text = "Current Sports"
                lbl_details.text = obj.currentSport
                
                //friends value
                if String(AppHelper.userDefaultsForKey(_ID)) != viewerUserID{
                    lbl_details.text = self.getFriendsValue("currentSport")
                }
                
                break
                
            case 9:
                iv.image = UIImage(named: "mp_intrests")
                lbl_title.text = "Interests"
                lbl_details.text = obj.interests
                
                //friends value
                if String(AppHelper.userDefaultsForKey(_ID)) != viewerUserID{
                    lbl_details.text = self.getFriendsValue("interests")
                }
                break
                
            case 10:
                iv.image = UIImage(named: "mp_quotes")
                lbl_title.text = "Favorite Famous Quote"
                lbl_details.text = obj.favFamousQuote
                
                //friends value
                if String(AppHelper.userDefaultsForKey(_ID)) != viewerUserID{
                    lbl_details.text = self.getFriendsValue("favFamousQuote")
                }
                break
                
            case 11:
                iv.image = UIImage(named: "mp_quotes")
                lbl_title.text = "My Not-So-Famous Quote"
                lbl_details.text = obj.notFamousQuote
                
                //friends value
                if String(AppHelper.userDefaultsForKey(_ID)) != viewerUserID{
                    lbl_details.text = self.getFriendsValue("notFamousQuote")
                }
                break
                
            case 12:
                iv.image = UIImage(named: "mp_my_bio")
                lbl_title.text = "My Bio"
                lbl_details.text = obj.bio
                
                //friends value
                if String(AppHelper.userDefaultsForKey(_ID)) != viewerUserID{
                    lbl_details.text = self.getFriendsValue("bio")
                }
                
                break
                
            default:
                break
            }
        cell.userInteractionEnabled = true
        
        return cell
    }
    
    func getFriendsValue(forKey:String) -> String {
        
        if  (friendDetailsDict!["result"]![forKey] != nil)  {
            
            let value = friendDetailsDict!["result"]![forKey] as? String ?? ""
            
            return value
        }
        
        return ""
    }
    
}

