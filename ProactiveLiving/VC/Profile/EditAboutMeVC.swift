//
//  EditAboutMeVC.swift
//  ProactiveLiving
//
//  Created by Affle on 11/01/2017.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit

class EditAboutMeVC: UIViewController, UIAlertViewDelegate {
    
    
    
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    
    @IBOutlet weak var btnBack: UIButton!
    
    
    @IBOutlet weak var tv_summary: UITextView!
    @IBOutlet weak var tf_liveIn: CustomTextField!
    @IBOutlet weak var tf_workAt: CustomTextField!
    @IBOutlet weak var tf_grewUp: CustomTextField!
    @IBOutlet weak var tf_highSchool: CustomTextField!
    @IBOutlet weak var tf_highSchoolSpotsPlayed: CustomTextField!
    @IBOutlet weak var tf_college: CustomTextField!
    @IBOutlet weak var tf_collegeSportsPlayed: CustomTextField!
    @IBOutlet weak var tf_graduateSchool: CustomTextField!
    @IBOutlet weak var tf_currentSports: CustomTextField!
    @IBOutlet weak var tv_interest: UITextView!
    @IBOutlet weak var tv_favQuote: UITextView!
    @IBOutlet weak var tv_myNotFavQuote: UITextView!
    @IBOutlet weak var tv_myBio: UITextView!
    
  
    
    var errorStr:String?
    var gendarStr:String?
    var firstTimeLogin:String?

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
        
        //first time user logged in
        if firstTimeLogin == "1"{
            
            self.btnBack.hidden = true
            gendarStr = "Male"
            self.btnMale.setImage(UIImage(named: "radio_selected"), forState: .Normal)
            self.btnFemale.setImage(UIImage(named: "radio"), forState: .Normal)
            
        }else{
            //Freeze the gender
            
            self.btnMale.userInteractionEnabled = false
            self.btnFemale.userInteractionEnabled = false
            self.setUpInputedField()
            
            
        }
        
        
    
      
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
        gendarStr = "Male"
        self.btnMale.setImage(UIImage(named: "radio_selected"), forState: .Normal)
        self.btnFemale.setImage(UIImage(named: "radio"), forState: .Normal)
    }
    
    
    @IBAction func onClickFeMaleBtn(sender: AnyObject) {
         gendarStr = "Female"
        self.btnFemale.setImage(UIImage(named: "radio_selected"), forState: .Normal)
        self.btnMale.setImage(UIImage(named: "radio"), forState: .Normal)
    }
    
    
    
    func setUpInputedField() -> Void {
        
            let obj:Beans.UserDetails = HelpingClass.getUserDetails() 
            
            
            self.tv_summary.text = obj.summary
            self.tf_liveIn.text = obj.liveIn
            self.tf_workAt.text = obj.workAt
            self.tf_grewUp.text = obj.grewUp
            self.tf_highSchool.text = obj.highSchool
            self.tf_highSchoolSpotsPlayed.text = obj.highSchoolSportsPlayed
            self.tf_collegeSportsPlayed.text = obj.collegeSportsPlayed
            self.tf_college.text = obj.college
            self.tf_graduateSchool.text = obj.graduateSchool
            self.tf_currentSports.text = obj.currentSport
            self.tv_interest.text = obj.interests
            self.tv_favQuote.text = obj.favFamousQuote
            self.tv_myNotFavQuote.text = obj.notFamousQuote
            self.tv_myBio.text = obj.bio
        
        if obj.gender == "Male" {
            self.btnMale.setImage(UIImage(named: "radio_selected"), forState: .Normal)
            self.btnFemale.setImage(UIImage(named: "radio"), forState: .Normal)
        }else{
            self.btnFemale.setImage(UIImage(named: "radio_selected"), forState: .Normal)
            self.btnMale.setImage(UIImage(named: "radio"), forState: .Normal)
        }
       
    }
   /*
     use less
    func setUpUserDetails(dict:[String:String]) -> Void {
        
        //save to userDefault db
        
       // AppHelper.saveToUserDefaults(dict, withKey: keyUserDetails)
        
        
        let obj:Beans.UserDetails = Beans.UserDetails(userName: dict["gender"]!, userId: "", imgUrl: dict["imgUrl"]!, imgCoverUrl: dict["imgUrl"]!, summary: dict["summary"]!, gender: dict["gender"]!, liveIn: dict["liveIn"]!, workAt: dict["workAt"]!, grewUp: dict["grewup"]!, highSchool:  dict["highSchool"]!, college: dict["college"]!, graduateSchool: dict["graduateSchool"]!, sportsPlayed: dict["sportsPlayed"]!, interest: dict["intrests"]!, favFamousQuote: dict["favFamousQuote"]!, notFamousQuote: dict["notFamousQuote"]!, bio: dict["bio"]!)
        
        
        
        
        //archive user details and save to userdetails
        let archiveUserDetails = NSKeyedArchiver.archivedDataWithRootObject(obj )
        
        AppHelper.saveToUserDefaults(archiveUserDetails, withKey: keyUserDetails)
        
        
        
        
    }
    */
    
    func setUpTabBar() -> Void {
        
    
        let storyBoard = AppHelper.getStoryBoard()
        
        let firstVC = storyBoard.instantiateViewControllerWithIdentifier("CalendarVC") as! RSDFDatePickerViewController
        firstVC.title =  "Calendar"
        firstVC.tabBarItem.image = UIImage(named: "ic_more_tabar_calendar")
        firstVC.calendar = NSCalendar.init(calendarIdentifier:NSCalendarIdentifierGregorian)
        firstVC.calendar.locale = NSLocale.currentLocale()
        
        let firstNVC = UINavigationController.init(rootViewController: firstVC)
        
        
        let secondVc = storyBoard.instantiateViewControllerWithIdentifier("InboxVC") as! InboxVC
        secondVc.title = "Inbox";
        secondVc.tabBarItem.image = UIImage(named: "ic_more_tabar_inbox")
        
        let secondNVC = UINavigationController.init(rootViewController: secondVc)
        
        //third vc
        
        let allVC = storyBoard.instantiateViewControllerWithIdentifier("NewsFeedsAllVC") as! NewsFeedsAllVC
        allVC.title = "ALL";
        
        let exploreVC = storyBoard.instantiateViewControllerWithIdentifier("ExploreVC") as! ExploreVC
        exploreVC.title = "Explore";
        
        let friendsVC = storyBoard.instantiateViewControllerWithIdentifier("NewsFeedsAllVC") as! NewsFeedsAllVC
        allVC.title = "FRIENDS";
        
        let colleaguesVC = storyBoard.instantiateViewControllerWithIdentifier("NewsFeedsAllVC") as! NewsFeedsAllVC
        colleaguesVC.title = "COLLEAGUES";
        
        
        let healthClubsVC = storyBoard.instantiateViewControllerWithIdentifier("NewsFeedsAllVC") as! NewsFeedsAllVC
        healthClubsVC.title = "HEALTH CLUBS";
        
         let arr = NSArray.init(objects: allVC, exploreVC , friendsVC, colleaguesVC, healthClubsVC)
        
        
        let thirdVC = storyBoard.instantiateViewControllerWithIdentifier("NewsFeedContainer") as! NewsFeedContainer
        thirdVC.title = "Home";
        thirdVC.arrViewControllers = arr as [AnyObject];
        thirdVC.tabBarItem.image = UIImage(named: "ic_more_tabar_home")
        
        let thirdNVC = UINavigationController.init(rootViewController: thirdVC)
        
        let fourthVC = storyBoard.instantiateViewControllerWithIdentifier("MyPAStodoVC") as!MyPAStodoVC
        fourthVC.title = "Activate";
        fourthVC.tabBarItem.image = UIImage(named:"ic_tabbar_activate");
        
        let fourthNVC = UINavigationController.init(rootViewController: fourthVC)
        
        let fifthVC = storyBoard.instantiateViewControllerWithIdentifier("MenuVC") as!MenuVC
        fifthVC.title = " Menu";
        fifthVC.tabBarItem.image = UIImage(named:"ic_more_tabar_menu")
       
        let fifthNVC = UINavigationController.init(rootViewController: fifthVC)
        
        
        
        
        let tabBarController = CustonTabBarController.init()
        
         tabBarController.setViewControllers([firstNVC, secondNVC, thirdNVC, fourthNVC, fifthNVC], animated: true)

        //set up badge Icon
        AppDelegate.getAppDelegate().tabbarController = tabBarController
        
        if DataBaseController.sharedInstance.fetchUnreadCount() > 0 {
            let items =  AppDelegate.getAppDelegate().tabbarController.tabBar.items![1]
            items.badgeValue = String(DataBaseController.sharedInstance.fetchUnreadCount)
            
        }else{

            let items =  AppDelegate.getAppDelegate().tabbarController.tabBar.items![1]
            items.badgeValue = nil

}
        

        self.navigationController?.pushViewController(tabBarController, animated: true)
        
        
        
        
        
        
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
       
        if buttonIndex == 0 {
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
  
    
    
    //MARK: - Service Call
    
    func updateProfileAPI() {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            parameters["summary"] = self.tv_summary.text
            parameters["gender"] = gendarStr
            parameters["liveIn"] = self.tf_liveIn.text
            parameters["workAt"] = self.tf_workAt.text
            parameters["grewup"] = self.tf_grewUp.text
            parameters["highSchool"] = self.tf_highSchool.text
            parameters["college"] = self.tf_college.text
            parameters["graduateSchool"] = self.tf_graduateSchool.text
            parameters["highSchoolSportsPlayed"] = self.tf_highSchoolSpotsPlayed.text
            parameters["collegeSportsPlayed"] = self.tf_collegeSportsPlayed.text
            parameters["currentSport"] = self.tf_currentSports.text
            parameters["intrests"] = self.tv_interest.text
            parameters["favFamousQuote"] = self.tv_favQuote.text
            parameters["notFamousQuote"] = self.tv_myNotFavQuote.text
            parameters["bio"] = self.tv_myBio.text
            
            //call global web service class latest
            Services.postRequest(ServiceUpdateUserProfile, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        print(responseDict["result"])
                        
                        let result = responseDict["result"]
                        
                        var dict = [String:String]()
                        
                        let userObj = Beans.UserDetails.sharedInstance
                        
                        userObj.gender = result!["gender"] as? String ?? ""
                        userObj.summary = result!["summary"] as? String ?? ""
                        userObj.liveIn = result!["liveIn"] as? String ?? ""
                        userObj.workAt = result!["workAt"] as? String ?? ""
                        userObj.grewUp = result!["grewup"] as? String ?? ""
                        userObj.highSchool = (result!["highSchool"] as? String)!
                        userObj.college = result!["college"] as? String ?? ""
                        userObj.graduateSchool = result!["graduateSchool"] as? String ?? ""
                        userObj.highSchoolSportsPlayed = result!["highSchoolSportsPlayed"] as? String ?? ""
                        userObj.collegeSportsPlayed = result!["collegeSportsPlayed"] as? String ?? ""
                        userObj.currentSport = result!["currentSport"] as? String ?? ""
                        userObj.interests = result!["intrests"] as? String ?? ""
                        userObj.favFamousQuote = result!["favFamousQuote"] as? String ?? ""
                        userObj.notFamousQuote = result!["notFamousQuote"] as? String ?? ""
                        userObj.bio = result!["bio"] as? String ?? ""
                        
                       
                        
                        HelpingClass.saveUserDetails(userObj)
                        
                        if self.firstTimeLogin == "1"{
                            //goto tabbarcontroller page
                            
                            self.setUpTabBar()
                            
                            return
                        }
                        
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
