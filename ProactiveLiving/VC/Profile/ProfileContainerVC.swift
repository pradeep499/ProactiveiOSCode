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
    
    
    //to check owner or friend not nill all time
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
    var friendDict:[String:AnyObject]?
    
    var popOverTableView:UITableView?
    var popover:DXPopover = DXPopover()
    var popoverHeight:CGFloat = 130
    var popOverCellData = ["Block access to my profile", "Block access to my cell number", "Add to Favorites",  "Unfriend", "Report Member"]


    override func viewDidLoad() {
        super.viewDidLoad()

        bottomTabBar = self.tabBarController as? CustonTabBarController
        
        self.setUpViewControllers()
        self.setUpProfilePage()
        
        //popover table
        popOverTableView = UITableView()
        popOverTableView?.frame = CGRectMake(0, 0, 170, popoverHeight)
        popOverTableView?.dataSource = self
        popOverTableView?.delegate = self
      //  popOverTableView?.separatorStyle = .None
       
    }
    
    override func viewDidLayoutSubviews() {
      //  self.view.layoutIfNeeded()
      //  self.view.layoutSubviews()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(false)
        
        self.navigationController?.navigationBarHidden = true
        
     //   bottomTabBar!.setTabBarVisible(false, animated: true) { (finish) in
            // print(finish)
     //   }
        
        
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
        firstVC.viewerUserID = viewerUserID
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
            
            self.getFriendProfileDetailsAPI(viewerUserID)
            
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
            
            let windowHeight = self.view.frame.size.height
            let button = sender as? UIButton
            //        NSLog("button tag \(button!.tag)")
            let frameInWindow = button!.convertRect(button!.bounds, toView: self.view)
            let popoverY = frameInWindow.origin.y
            var startPoint = CGPointMake(frameInWindow.midX, frameInWindow.maxY)
            var popoverPosition:DXPopoverPosition = .Down
            if (windowHeight-popoverY<160){
                startPoint = CGPointMake(frameInWindow.midX, frameInWindow.minY)
                popoverPosition = .Up
            }
            self.popover.showAtPoint(startPoint, popoverPostion: popoverPosition, withContentView: self.popOverTableView, inView: self.view)
        }
    }

    
    
    
    @IBAction func onClickSendRequestBtn(sender: AnyObject) {
        HelpingClass.showAlertControllerWithType(.Alert, fromController: self, title: AppName, message: "Do you want to send friend request ?", cancelButtonTitle: "No", otherButtonTitle: ["Yes"]) { (str) in
            
            if str == "Yes"{
                self.sendFriendRequestAPI()
            }
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
        let mobilePhone = self.friendDict!["mobilePhone"] as! String
        if let phoneCallURL:NSURL = NSURL(string: "tel://\(mobilePhone)") {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
        
    }
    
    @IBAction func onClickChatBtn(sender: AnyObject) {
        
        
        let chatMainVC: ChattingMainVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("ChattingMainVC") as! ChattingMainVC
        //   chatMainObj.contObj = anObject
      //  chatMainObj.isFromClass="ChatF"
        chatMainVC.isGroup="0"
        
        //
        let contObj = ChatContactModelClass()
        contObj.userId = self.friendDict!["_id"] as! String
        contObj.loginUserId = ChatHelper.userDefaultForKey(_ID)
        contObj.name =  self.friendDict!["firstName"] as! String
        contObj.email = self.friendDict!["email"] as! String
        contObj.isBlock = "0";
        contObj.isReport = "0";
        contObj.isFav = "no";
        contObj.isFriend = "yes";
        contObj.userImgString = self.friendDict!["imgUrl"] as! String
        contObj.isFromCont = "yes";
        contObj.phoneNumber = self.friendDict!["mobilePhone"] as! String
        contObj.firstName = self.friendDict!["firstName"] as! String
        
        chatMainVC.contObj = contObj;
        chatMainVC.isFromClass = "";
        chatMainVC.isGroup = "0";
        chatMainVC.isFromDeatilScreen = "0";
        //chatMainVC.recentChatObj = recentObj;
        chatMainVC.recentChatObj = nil;
        
        
        
        self.navigationController?.pushViewController(chatMainVC, animated: true)
        
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
    
    //MARK:- API
    
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
    
    
    
    
    
    func getFriendProfileDetailsAPI(friendId:String) -> Void {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = friendId
            
            
            
            
            //call global web service class latest
            Services.postRequest(ServiceGetUserProfile, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                       
                        print("Friend Details....", responseDict["result"])
                        
                        self.friendDict = responseDict["result"] as! [String:AnyObject]
                        
                        // set UI
                        
                        let url = NSURL(string: self.friendDict!["imgUrl"] as! String )
                        let bgUrl = NSURL(string: self.friendDict!["imgCoverUrl"] as! String)
                        
                        self.iv_profile.sd_setImageWithURL(url, placeholderImage: UIImage(named: "user"))
                        self.iv_profileBg.sd_setImageWithURL(bgUrl, placeholderImage: UIImage(named: ""))
                        
                        
                        
                        let fName = self.friendDict!["firstName"] as! String
                        let lName = self.friendDict!["lastName"] as! String
                        
                        self.lbl_name.text = fName + " " + lName
                        self.lbl_address.text = self.friendDict!["liveIn"] as! String
                        
                        friendDetailsDict = self.friendDict!
                        
                        NSNotificationCenter.defaultCenter().postNotificationName("NotifyFrDetails", object: self.friendDict!)
 
                        
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
    
    
    
    
    
    func sendFriendRequestAPI() {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            parameters["friendMobile"] =  self.friendDict!["mobilePhone"] as! String
            
            //call global web service class latest
            Services.postRequest(ServiceSendFriendRequest, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        print(responseDict["result"])
                        
                        AppHelper.showAlertWithTitle(AppName, message:"Friend request sent successfuly.", tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                        
                        
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

extension ProfileContainerVC:UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == popOverTableView{
            return 5
        }
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == popOverTableView{
            let cell = UITableViewCell.init(style: .Default, reuseIdentifier: "cell")
            cell.textLabel?.text = popOverCellData[indexPath.row]
            cell.textLabel?.textAlignment = .Center
            cell.selectionStyle = .None
            return cell
        }
        
        return UITableViewCell.init(style: .Default, reuseIdentifier: "cell")
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if tableView == popOverTableView{
            NSLog("\(popOverCellData[indexPath.row]) selected")
            self.popover.dismiss()
            
            if indexPath.row == 0 {
                //block  member
                HelpingClass.showAlertControllerWithType(.Alert, fromController: self, title: AppName, message: "Do you want to block member's profile ?", cancelButtonTitle: "No", otherButtonTitle: ["Yes"]) { (str) in
                    
                    if str == "Yes"{
                        self.blockFriendAPI()
                    }
                }
                
            }else if indexPath.row == 1 {
                //block ceel number
                HelpingClass.showAlertControllerWithType(.Alert, fromController: self, title: AppName, message: "Do you want to block member's cell number ?", cancelButtonTitle: "No", otherButtonTitle: ["Yes"]) { (str) in
                    
                    if str == "Yes"{
                        self.blockFriendAPI()
                    }
                }
                
            }else if indexPath.row == 2 {
                
            }else if indexPath.row == 3{
                 //unfriend
                
                HelpingClass.showAlertControllerWithType(.Alert, fromController: self, title: AppName, message: "Do you want unfriend ?", cancelButtonTitle: "No", otherButtonTitle: ["Yes"]) { (str) in
                    
                    if str == "Yes"{
                     }
                }
            }else{
                self.sendMail()
            }
            
        }
    }
    
    
   
    
    
    func blockFriendAPI() {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            parameters["status"] = NSNumber.init(int: 3)
            parameters["friendId"] = viewerUserID
             
            
            //call global web service class latest
            Services.postRequest(ServiceFriendRequestAction, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        print(responseDict["result"])
                        
                        AppHelper.showAlertWithTitle(AppName, message:"Friend has been blocked.", tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                        
                        
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

extension ProfileContainerVC:MFMailComposeViewControllerDelegate{
    
    
    func sendMail() -> Void {
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients(["support@proactively.com"])
        composeVC.setSubject("Report Member.")
        
        let fName = self.friendDict!["firstName"] as! String
        let lName = self.friendDict!["lastName"] as! String
        let email = self.friendDict!["email"] as! String
        let mobilePhone = self.friendDict!["mobilePhone"] as! String
        
        let body = "Name: " + fName + " " + lName + "/n" + "Mb: " + mobilePhone + "/n" + "Email: " + email
        
        composeVC.setMessageBody(body , isHTML: true)
        
        // Present the view controller modally.
        self.presentViewController(composeVC, animated: true, completion: nil)
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
