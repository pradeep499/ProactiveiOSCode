//
//  ProfileContainerVC.swift
//  ProactiveLiving
//
//  Created by Affle on 09/01/2017.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit


 

class ProfileContainerVC: UIViewController, YSLContainerViewControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate, GenericProfileCollectionVCDelegate {
    
    var firstVC: ProfileVC!
    var secondVC: MyPAStodoVC!
    var thirdVC: NewsFeedsAllVC!
    var fourthVC: RSDFDatePickerViewController!
    
    var viewerUserID:String!
    var imgUploadType:String?
    
    
    
    @IBOutlet weak var iv_profileBg: UIImageView!
    
    @IBOutlet weak var iv_profile: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_address: UILabel!
    
    @IBOutlet weak var btnEditOrMore: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    
    @IBOutlet weak var btnChat: UIButton!
    
    
    @IBOutlet weak var btnSendRequest: UIButton!
    
    
    
    @IBOutlet weak var layOutConstrain_ivBg_height: NSLayoutConstraint!
    
    @IBOutlet weak var btnBgImg: UIButton!
    @IBOutlet weak var btnProfileImg: UIButton!
 
    
    var arrViewControllers = [AnyObject]()
 
    var bottomTabBar : CustonTabBarController!


    override func viewDidLoad() {
        super.viewDidLoad()

        bottomTabBar = self.tabBarController as? CustonTabBarController
        
        self.setUpViewControllers()
        self.setUpProfilePage()
        
        
       
    }
    
    override func viewDidLayoutSubviews() {
      //  self.view.layoutIfNeeded()
      //  self.view.layoutSubviews()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(false)
        
        self.navigationController?.navigationBarHidden = true
        
        bottomTabBar!.setTabBarVisible(false, animated: true) { (finish) in
            // print(finish)
        }
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func setUpViewControllers() {
        
        // SetUp ViewControllers
        let storyboard = AppHelper.getStoryBoard()
        let profileStoryboard = AppHelper.getProfileStoryBoard()
        
        firstVC = profileStoryboard.instantiateViewControllerWithIdentifier("ProfileVC") as! ProfileVC
        firstVC.title = "PROFILE"
        firstVC.cvHeight = 230 // as profile y position is y = 230
         
        let nav = UINavigationController.init(rootViewController: firstVC)
        
        secondVC = storyboard.instantiateViewControllerWithIdentifier("MyPAStodoVC") as! MyPAStodoVC
        secondVC.title = "ACTIVITY"
        
        
        thirdVC = storyboard.instantiateViewControllerWithIdentifier("NewsFeedsAllVC") as! NewsFeedsAllVC
        thirdVC.title = "BROADCASTS"
        
        //      thirdVC.feedsType = "FRIENDS"
        
        fourthVC = storyboard.instantiateViewControllerWithIdentifier("CalendarVC") as! RSDFDatePickerViewController
        fourthVC.title = "CALENDAR"
        
        //    fourthVC.feedsType = "COLLEAGUES"
        
       
        
        //   fifthVC.feedsType = "HEALTH CLUBS"
        
        arrViewControllers = [firstVC]
        
        let containerVC = YSLContainerViewController.init(controllers: arrViewControllers, topBarHeight: 0, parentViewController: self)
        
        
        
        
        containerVC.delegate = self
        containerVC.menuItemFont = UIFont(name: "Roboto-Regular", size: 11)
        containerVC.menuItemSelectedFont = UIFont(name: "Roboto-Bold", size: 11.5)
        containerVC.menuBackGroudColor = UIColor(red: 1.0 / 255, green: 174.0 / 255, blue: 240.0 / 255, alpha: 1.0)
        containerVC.menuItemTitleColor = UIColor.whiteColor()
        containerVC.menuItemSelectedTitleColor = UIColor.whiteColor()
     //   containerVC.view.frame = CGRectMake(0, self.layOutConstrain_ivBg_height.constant, containerVC.view.frame.size.width, containerVC.view.frame.size.height - self.layOutConstrain_ivBg_height.constant)
        
        containerVC.view.frame = CGRectMake(0, 230, containerVC.view.frame.size.width,   screenHeight - 300 )
        
        self.view.addSubview(containerVC.view)
    }
    
    func setUpProfilePage() -> Void {
        
        
        if String(AppHelper.userDefaultsForKey(_ID)) == viewerUserID{
            //Owner
            
            
            
            let url = NSURL(string: HelpingClass.getUserDetails().imgUrl)
            let bgUrl = NSURL(string: HelpingClass.getUserDetails().imgCoverUrl)
            
            self.iv_profile.sd_setImageWithURL(url, placeholderImage: UIImage(named: "user"))
            self.iv_profileBg.sd_setImageWithURL(bgUrl, placeholderImage: UIImage(named: ""))
            
            
            
            let name = ((AppHelper.userDefaultsForKey(userFirstName) as? String)! + " " + (AppHelper.userDefaultsForKey(userLastName) as! String))
            
            self.lbl_name.text = name
            self.lbl_address.text = HelpingClass.getUserDetails().liveIn
            
            
            self.btnEditOrMore.setImage(UIImage(named: ""), forState: .Normal)
            self.btnEditOrMore.setTitle("Edit", forState: .Normal)
            self.btnBgImg.hidden = true
            self.btnProfileImg.hidden = true
            self.btnSendRequest.hidden = true
            self.btnChat.hidden = true
            self.btnCall.hidden = true
            
        }else{
            //Friend
            
            self.btnEditOrMore.setImage(UIImage(named: "pf_more"), forState: .Normal)
            
            
            self.btnSendRequest.hidden = false
            self.btnChat.hidden = false
            self.btnCall.hidden = false
            self.btnBgImg.hidden = true
            self.btnProfileImg.hidden = true
            
        }
        
       
        
        //make circle profile image
        self.iv_profile.layer.borderWidth = 1.0
        self.iv_profile.contentMode = .ScaleAspectFill
        self.iv_profile.backgroundColor = UIColor.whiteColor()
        self.iv_profile.layer.masksToBounds = false
        self.iv_profile.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.iv_profile.layer.cornerRadius = iv_profile.frame.size.height/2
        self.iv_profile.clipsToBounds = true
        
        self.iv_profileBg.userInteractionEnabled = true
        self.iv_profile.userInteractionEnabled = true
        
        let tapBgGesture = UITapGestureRecognizer.init(target: self, action: #selector(ProfileContainerVC.bgIvTaped(_:)))
        self.iv_profileBg.addGestureRecognizer(tapBgGesture)
        
        let tapProfileGesture = UITapGestureRecognizer.init(target: self, action: #selector(ProfileContainerVC.profileIvTaped(_:)))
        self.iv_profile.addGestureRecognizer(tapProfileGesture)
    }
    
    
    func bgIvTaped(gesture:UIGestureRecognizer) -> Void {
        
        if String(HelpingClass.getUserDetails().imgCoverUrl).characters.count > 1 {
            self.goToFullScreen(HelpingClass.getUserDetails().imgCoverUrl)
        }
        
    
    }
    
    func profileIvTaped(gesture:UIGestureRecognizer) -> Void {
        
        if String(HelpingClass.getUserDetails().imgUrl).characters.count > 1 {
            self.goToFullScreen(HelpingClass.getUserDetails().imgUrl)
        }
        
       
    }
    
    
    func goToFullScreen(urlStr:String) -> Void {
        
        
        let fullImageVC: FullScreenImageVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("FullScreenImageVC") as! FullScreenImageVC
        fullImageVC.imagePath = urlStr
        fullImageVC.downLoadPath="3"
        
        self.navigationController?.pushViewController(fullImageVC, animated: true)
        
        
    }
    
    
    
    
    // MARK: -- YSLContainerViewControllerDelegate
    func containerViewItemIndex(index: Int, currentController controller: UIViewController) {
     //   self.view.endEditing(true)
        print("current Index : \(Int(index))")
        print("current controller : \(controller)")
        currentIndex = index
     //   controller.viewWillAppear(true)
        
    }
    
    
    //MARK: Btn Click
    @IBAction func onClickBackBtn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func onClickEditOrMoreBtn(sender: AnyObject) {
        
        if String(AppHelper.userDefaultsForKey(_ID)) == viewerUserID{
            //Owner
            //show edit btn
            
            if self.btnEditOrMore.titleLabel?.text == "Edit" {
                
                self.btnEditOrMore.setTitle("Done", forState: .Normal)
                self.btnBgImg.hidden = false
                self.btnProfileImg.hidden = false
            }else{
                self.btnEditOrMore.setTitle("Edit", forState: .Normal)
                self.btnBgImg.hidden = true
                self.btnProfileImg.hidden = true
                
                
                
            }
            
        }else{
            //Friend
            
            
        }
    }

    
    
    
    @IBAction func onClickSendRequestBtn(sender: AnyObject) {
        if String(AppHelper.userDefaultsForKey(_ID)) == viewerUserID{
            //Owner show edit btn
        
        }
    }
    
    @IBAction func onClickProfileImg(sender: AnyObject) {
        
        
        HelpingClass.showAlertControllerWithType(.Alert, fromController: self, title: AppName, message: "Do you want to change Profile  image?", cancelButtonTitle: "No", otherButtonTitle: ["Yes"], completion: { (str) in
            if str == "Yes"{
                self.gotTOPhotosPage()
                self.imgUploadType = "profile"
            }
        })
    }
    
    @IBAction func onClickBgImgBtn(sender: AnyObject) {
        
        HelpingClass.showAlertControllerWithType(.Alert, fromController: self, title: AppName, message: "Do you want to change Profile background image?", cancelButtonTitle: "No", otherButtonTitle: ["Yes"], completion: { (str) in
            if str == "Yes"{
                self.gotTOPhotosPage()
                self.imgUploadType = "bg"
            }
        })
    }
    
    
    
    @IBAction func onClickCallBtn(sender: AnyObject) {
    }
    
    @IBAction func onClickChatBtn(sender: AnyObject) {
    }
    
    
    //MARK:-
    
    func bgPictureTap(sender: UITapGestureRecognizer? = nil) {
        self.openActionSheet()
    }
    
    func profilePictureTap(sender: UITapGestureRecognizer? = nil) {
        self.openActionSheet()
    }
    
    func openActionSheet() -> Void
    {
        
        if(IS_IOS_7)
        {
            let actionSheet = UIActionSheet(title:"", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle:nil, otherButtonTitles: "Open Camera","Open Gallery")
            actionSheet.tag=10001
            //   actionSheet.showFromTabBar((bottomTabBar?.tabBar)!)
        }
        else
        {
            let actionSheet =  UIAlertController(title:"", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Open Camera", style: UIAlertActionStyle.Default, handler:
                { (ACTION :UIAlertAction!)in
                    
                    let imagePicker = UIImagePickerController()
                    imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                    
                    imagePicker.delegate = self
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                    
                    
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Open Gallery", style: UIAlertActionStyle.Default, handler: { (ACTION :UIAlertAction!)in
                UIApplication.sharedApplication().statusBarHidden=true;
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                
                imagePicker.delegate = self
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (ACTION :UIAlertAction!)in
                
            }))
            
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
    }
    func gotTOPhotosPage() -> Void {
        
        let vc = AppHelper.getProfileStoryBoard().instantiateViewControllerWithIdentifier("GenericProfileCollectionVC") as! GenericProfileCollectionVC
        vc.genericType = .Gallery
        vc.pageFrom = "ProfileContainer"
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK:- ActionSheet Delegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        if (actionSheet.tag==10001)
        {
            switch buttonIndex{
            case 0:
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                
                imagePicker.delegate = self
                self.presentViewController(imagePicker, animated: true, completion: nil)
                break;
            case 1:
                UIApplication.sharedApplication().statusBarHidden=true;
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imagePicker.delegate = self
                self.presentViewController(imagePicker, animated: true, completion: nil)
                
                break;
            default:
                
                break;
            }
        }
        
        
    }
    
    
    
    //MARK:- Image Picker Delegate
    
    
    //MARK:- Image Picker Delegates
    func imagePickerControllerDidCancel(picker:UIImagePickerController)
    {
        //  isFromGallery = true
        viewWillAppaerCount = 1
        
        self.dismissViewControllerAnimated(true, completion: nil)
        delay(0.1,
              closure: {
                UIApplication.sharedApplication().statusBarHidden = false;
                UIApplication.sharedApplication().statusBarStyle = .LightContent
        })
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        //  isFromGallery = true
        
        self.dismissViewControllerAnimated(true, completion: nil)
        delay(0.1,
              closure: {
                UIApplication.sharedApplication().statusBarHidden = false;
                UIApplication.sharedApplication().statusBarStyle = .LightContent
        })
        
        //UIImagePickerControllerEditedImage
        
        if(info["UIImagePickerControllerMediaType"] as! String == "public.image") {
            
            if ServiceClass.checkNetworkReachabilityWithoutAlert() {
                
             //   self.uploadImage((info[UIImagePickerControllerOriginalImage] as? UIImage)!)
            }
        }
    }
    
    
    //MARK:- upload
    
    func generateTimeStamp() -> String {
        
        let date = NSDate()
        var dateStr : String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss.sss"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateStr = dateFormatter.stringFromDate(date)
        
        print("time stam ", dateStr);
        
        return dateStr
        
    }
    
    //MARK:- Generic Delegate
    
    func getSelectedImgData(imgData:NSData, imgName:String) -> Void {
        
       // self.performSelector(Selector(""), withObject: imgData, afterDelay: 0.5)
        self.uploadImage(imgData, imgName: imgName)
        
    }
    
    //MARK:- upload
    
    func uploadImage(imgData:NSData, imgName: String) -> Void {
        
       
        
        NSOperationQueue.mainQueue().addOperationWithBlock() { () in
            
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            
            
            UploadInS3.sharedGlobal().uploadImageTos3( imgData, type: 0, fromDist: "chat", meldID: imgName, completion: { ( bool_val : Bool, pathUrl : String!) -> Void in
                
                AppDelegate.dismissProgressHUD()
                
                if bool_val == true
                {
                    let fileName =  UploadInS3.sharedGlobal().strFilesName
                    
                    if fileName != nil{
                        
                        self.sendToServerAPI(pathUrl, thumNailName: imgName)
                    }
                }
                else{
                    AppDelegate.dismissProgressHUD()
                }
                
                
                }
                , completionProgress: { ( bool_val : Bool, progress) -> Void in
                    
                    
                    
                }
            )
            
        }
        
    }
    
    
    func sendToServerAPI( imgUrl:String, thumNailName:String!) {
        
        
        
        if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {
            
            var dict = Dictionary<String,AnyObject>()
            
            dict["userId"] = ChatHelper.userDefaultForKey(_ID)
            
            if imgUploadType == "bg" {
                
                dict["imgCoverUrl"] = imgUrl
              //  dict["imgUrl"] = HelpingClass.getUserDetails().imgUrl
                
            }else{
                
                dict["imgUrl"] = imgUrl
              //  dict["imgCoverUrl"] =  HelpingClass.getUserDetails().imgCoverUrl
            }
            
            
            
            //call global web service class latest
            Services.postRequest(ServiceUpdateUserProfile, parameters: dict, completionHandler:{
                (status,responseDict) in
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        print(responseDict["result"])
                        
                        let resultDict = responseDict["result"] as! [String: AnyObject]
                        
                        let userObj = HelpingClass.getUserDetails() as! Beans.UserDetails
                        
                        if self.imgUploadType == "bg" {
                            
                            userObj.imgCoverUrl =  resultDict["imgCoverUrl"] as! String
                            
                             let bgUrl = NSURL(string:userObj.imgCoverUrl)
                            self.iv_profileBg.sd_setImageWithURL(bgUrl, placeholderImage: UIImage(named: ""))
                            
                            
                        }else{
                            userObj.imgUrl =  resultDict["imgUrl"] as! String
                            
                            let url = NSURL(string:userObj.imgUrl)
                            self.iv_profile.sd_setImageWithURL(url, placeholderImage: UIImage(named: "user"))
                            
                          
                        }
                        
                        
                        HelpingClass.saveUserDetails(userObj)
                        
                        
                    } else {
                        
                        AppHelper.showAlertWithTitle(AppName, message: responseDict["errorMsg"] as! String, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    }
                    
                } else if (status == "Error"){
                    
                    AppHelper.showAlertWithTitle(AppName, message: serviceError, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    
                }
            })
            
        }else {
            AppDelegate.dismissProgressHUD()
            //show internet not available
            AppHelper.showAlertWithTitle(netError, message: netErrorMessage, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
        }
    }
    
    
    
    
}
