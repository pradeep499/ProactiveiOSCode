//
//  ProfileContainerVC.swift
//  ProactiveLiving
//
//  Created by Affle on 09/01/2017.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit


 

class ProfileContainerVC: UIViewController, YSLContainerViewControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate {
    
    var firstVC: ProfileVC!
    var secondVC: MyPAStodoVC!
    var thirdVC: NewsFeedsAllVC!
    var fourthVC: RSDFDatePickerViewController!
    
    var viewerUserID:String!
    
    
    
    @IBOutlet weak var iv_profileBg: UIImageView!
    
    @IBOutlet weak var iv_profile: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_address: UILabel!
    
    @IBOutlet weak var btnEditOrMore: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    
    @IBOutlet weak var btnChat: UIButton!
    
    
    @IBOutlet weak var btnSendRequest: UIButton!
    
    
    
    @IBOutlet weak var layOutConstrain_ivBg_height: NSLayoutConstraint!
    
    /*
 
     // Calendar
     
     RSDFDatePickerViewController *firstViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CalendarVC"];
     firstViewController.title=@"Calendar";
     firstViewController.tabBarItem.image=[UIImage imageNamed:@"ic_more_tabar_calendar"];
     firstViewController.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
     firstViewController.calendar.locale = [NSLocale currentLocale];
     UIViewController *firstNavigationController = [[UINavigationController alloc] initWithRootViewController:firstViewController];
     
     
     
     //Activity
     
     MyPAStodoVC *fourthViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyPAStodoVC"];
     fourthViewController.title=@"Activate";
     fourthViewController.tabBarItem.image=[UIImage imageNamed:@"ic_tabbar_activate"];
     UIViewController *fourthNavigationController = [[UINavigationController alloc]
     initWithRootViewController:fourthViewController];
 */
    
    var arrViewControllers = [AnyObject]()
 
    var bottomTabBar : CustonTabBarController!


    override func viewDidLoad() {
        super.viewDidLoad()

        bottomTabBar = self.tabBarController as? CustonTabBarController
        
        
        
        
       
    }
    
    override func viewDidLayoutSubviews() {
      //  self.view.layoutIfNeeded()
      //  self.view.layoutSubviews()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        
        bottomTabBar!.setTabBarVisible(false, animated: true) { (finish) in
            // print(finish)
        }
        
        self.setUpViewControllers()
     //   self.setUpProfilePage()
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
        //   firstVC.feedsType = "ALL"
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
        
        //        thirdVC.collectionView.tag=222
        //        fourthVC.collectionView.tag=333
        //        fifthVC.collectionView.tag=444
        
        //     let containerVC = YSLContainerViewController(controllers: arrViewControllers, topBarHeight: 0, parentViewController: self)
        
        
        
        containerVC.delegate = self
        containerVC.menuItemFont = UIFont(name: "Roboto-Regular", size: 11)
        containerVC.menuItemSelectedFont = UIFont(name: "Roboto-Bold", size: 11.5)
        containerVC.menuBackGroudColor = UIColor(red: 1.0 / 255, green: 174.0 / 255, blue: 240.0 / 255, alpha: 1.0)
        containerVC.menuItemTitleColor = UIColor.whiteColor()
        containerVC.menuItemSelectedTitleColor = UIColor.whiteColor()
     //   containerVC.view.frame = CGRectMake(0, self.layOutConstrain_ivBg_height.constant, containerVC.view.frame.size.width, containerVC.view.frame.size.height - self.layOutConstrain_ivBg_height.constant)
        
        containerVC.view.frame = CGRectMake(0, 230, containerVC.view.frame.size.width,   0 )
        
        self.view.addSubview(containerVC.view)
    }
    
    func setUpProfilePage() -> Void {
        
        
        if String(AppHelper.userDefaultsForKey(_ID)) == viewerUserID{
            //Owner
            
            self.btnEditOrMore.setImage(UIImage(named: "pf_edit"), forState: .Normal)
            
            let url = NSURL(string: AppHelper.userDefaultsForKey("user_imageUrl") as! String)
            
            self.iv_profile.sd_setImageWithURL(url, placeholderImage: UIImage(named: "user"))
            
            let name = ((AppHelper.userDefaultsForKey(userFirstName) as? String)! + " " + (AppHelper.userDefaultsForKey(userLastName) as! String))
            
            self.lbl_name.text = name
            
            self.btnSendRequest.hidden = true
            self.btnChat.hidden = true
            self.btnCall.hidden = true
            
        }else{
            //Friend
            
            self.btnEditOrMore.setImage(UIImage(named: "pf_more"), forState: .Normal)
            
            
            self.btnSendRequest.hidden = false
            self.btnChat.hidden = false
            self.btnCall.hidden = false
            
        }
        
       
        
        //make circle profile image
        self.iv_profile.layer.borderWidth = 1.0
        self.iv_profile.contentMode = .ScaleAspectFill
        self.iv_profile.backgroundColor = UIColor.whiteColor()
        self.iv_profile.layer.masksToBounds = false
        self.iv_profile.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.iv_profile.layer.cornerRadius = iv_profile.frame.size.height/2
        self.iv_profile.clipsToBounds = true
        
        
        
        
     //   self.lbl_address.text = AppHelper.userDefaultsForKey("user_address") as? String
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
            
            let bgTap = UITapGestureRecognizer(target: self, action: #selector(ProfileContainerVC.bgPictureTap(_:)))
            self.iv_profileBg.addGestureRecognizer(bgTap)
            
            let profileTap = UITapGestureRecognizer(target: self, action: #selector(ProfileContainerVC.profilePictureTap(_:)))
            self.iv_profile.addGestureRecognizer(profileTap)
            
            self.iv_profileBg.userInteractionEnabled = true
            self.iv_profile.userInteractionEnabled = true
            
            
        }else{
            //Friend
            
            
        }
    }

    
    
    
    @IBAction func onClickSendRequestBtn(sender: AnyObject) {
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
                
                self.uploadImage((info[UIImagePickerControllerOriginalImage] as? UIImage)!)
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
    
    func uploadImage(uploadImage:UIImage) -> Void {
        
        let locId = CommonMethodFunctions.nextIdentifies()
        let strId = String(locId)
        
        let timeStamp = generateTimeStamp()
        let thumbNailName = "bg" + timeStamp + ".jpg"
        
        
        
        // let imgData = UIImageJPEGRepresentation(uploadImage, 0.8)
        
        //   let thumbImg = CommonMethodFunctions.generatePhotoThumbnail(uploadImage);
        let thumbData = UIImageJPEGRepresentation(uploadImage, 0.0)
        
        
        HelpingClass.writeToPath(directory: "/ChatFile", fileName: thumbNailName, dataToWrite: thumbData!, completion: {(isWritten:Bool, err:NSError?) -> Void in
            
            if isWritten{
                
            }
            
        })
        
    }
    
    
    
    
}
