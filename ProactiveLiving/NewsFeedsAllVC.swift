//
//  NewsFeedsAllVC.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 22/09/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit
import Social
import MediaPlayer
import AVKit

class NewsFeedsAllVC: UIViewController, UIGestureRecognizerDelegate, UICollectionViewDataSource, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,  UIActionSheetDelegate, DKImagePickerControllerDelegate , HPGrowingTextViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var view_share: UIView!
    @IBOutlet weak var attachmentViewS: UIView!
    @IBOutlet weak var postContainerView: UIView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var btnPost: UIButton!
    
    //  var dataArr = [AnyObject]()
    var profileArr = [String]()
    var urlArr = [String]()
    var postAllArr:NSMutableArray = NSMutableArray()
    var postFriendsArr:NSMutableArray = NSMutableArray()
    var postColleagueArr:NSMutableArray = NSMutableArray()
    var postHealthClubsArr:NSMutableArray = NSMutableArray()
    var postCircleArr:NSMutableArray = NSMutableArray()
    var pacWallArr:NSMutableArray = NSMutableArray()
    var textView:HPGrowingTextView = HPGrowingTextView()
    //var containerView: UIView = UIView()
    var pacID:String = String()
    var tapGesture = UITapGestureRecognizer()
    var moviePlayerController = MPMoviePlayerViewController()
    var globalAssets: [DKAsset]?
    
    var imgaeProfile  = UIImage(named: "ic_booking_profilepic")
    
 //   var isFromGallery:Bool!
    
      var isBackFromChildVC:Bool!
      var indexForCommentcount = -1  // 25 April
      var newsFeedID = ""
      var dictValuePacRole = [String:AnyObject]()
    //  var isFromCommentVC = false   // used for service hit on the basic of bool value. true if comments has some value
    

    
    
    @IBOutlet weak var layoutConstHeightShareView: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     //   isFromGallery = false
        isBackFromChildVC = false
        viewWillAppaerCount = 0
        //layOutConstrain_view_Post_bottom.constant = 320
        //layoutConstraint_collectionview_bottom.constant = 350
        var viewFrame = self.view.bounds
        viewFrame.size.height = screenHeight-200
        //self.view.frame = viewFrame
        //IQKeyboardManager.sharedManager().enableAutoToolbar = false

        //tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewsFeedsAllVC.hideSocialSharingView))
     
        
        self.view_share.hidden = true
        
       
        if self.title == "ALL" || self.title == "EXPLORE"{
            
            self.collectionView.registerClass(HeaderScrollerView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderScrollerView")
        }
        
        if(self.title != "PACs") {
            self.layoutConstHeightShareView.constant = 87
            self.plusButton.hidden = false
            self.btnPost.hidden = false

        }
        else {
            self.layoutConstHeightShareView.constant = 0
            self.plusButton.hidden = true
            self.btnPost.hidden = true

        }
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewsFeedsAllVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewsFeedsAllVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        //self.collectionView.keyboardDismissMode = .OnDrag
        //self.hideKeyboardWhenTappedAround()

        
        
        //self.fetchPostDataFromServer()
        //if self.title == "ALL" || self.title == "EXPLORE" {
            
           // self.fetchExploreDataFromServer()
        //}

    }
    
    //MARK:- CommentsVCDelegate
//    
//    
//    func didFinishUpload(flag: Bool) {
//        
//        self.isFromCommentVC = flag
//        
//    }
    
    
    //MARK:- Growing TextView mthods
    func setupGrowingTextView() {
        
        //containerView = UIView(frame: CGRectMake(0, self.collectionView.frame.size.height - 40, 320, 40))
        //containerView.backgroundColor = UIColor.redColor()
        textView = HPGrowingTextView(frame: CGRect(x: CGFloat(35), y: CGFloat(30), width: CGFloat(screenWidth-100), height: CGFloat(35)))
        //textView.internalTextView.autocorrectionType = .No
        textView.internalTextView.inputAccessoryView = UIView(frame: CGRectZero)
        textView.internalTextView.reloadInputViews()
        textView.isScrollable = false
        textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5)
        textView.minNumberOfLines = 1
        textView.maxNumberOfLines = 4
        // you can also set the maximum height in points with maxHeight
        // textView.maxHeight = 200.0f;
        //textView.returnKeyType = .Go
        textView.font = UIFont(name: "Roboto-Light", size: 16)
        textView.delegate = self
        textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0)
        textView.backgroundColor = UIColor.whiteColor()
        textView.setCornerRadiusWithBorderWidthAndColor(5.0, borderWidth: 1.0, borderColor: UIColor.grayColor())
        textView.placeholder = "Share an update"
        textView.autoresizingMask = .FlexibleHeight
        postContainerView.addSubview(textView)
        print_debug(textView.frame)
        
        self.view.layoutIfNeeded()
        self.view.bringSubviewToFront(textView)
        //textView.animateHeightChange = NO; //turns off animation
        
    }
    func growingTextView(growingTextView: HPGrowingTextView!, didChangeHeight height: Float) {
        
    }
    func growingTextView(growingTextView: HPGrowingTextView!, willChangeHeight height: Float) {
        let diff: CGFloat = CGFloat(growingTextView.frame.size.height - CGFloat(height))
        var r: CGRect = self.postContainerView.frame
        r.size.height -= diff
        r.origin.y += diff
        
        print(r)
        self.postContainerView.frame = r
    }
    override func viewWillAppear(animated: Bool) {
        
        //createConnection 
        ChatListner.getChatListnerObj().createConnection()
        
        //super.viewWillAppear(animated)
        if self.title != "EXPLORE" {
            
            //self.postCircleArr.removeAllObjects()
            //self.collectionView.reloadData()
            self.getAllPostEvent()
            self.getLikeUpdate()
            
        }
        self.attachmentViewS.hidden = true
        IQKeyboardManager.sharedManager().enable = false
        
        print_debug("hellooo")
        print_debug(dictValuePacRole)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setupGrowingTextView()

    }


    
    func setColectionViewTags()  {
        
        if(self.title != "WALL") {
            if intValue == 0 {
                self.collectionView.tag=1111
            }
            else if intValue == 1 {
                // Explore condition
            }
            else if intValue == 2 {
                self.collectionView.tag=3333
            }
            else if intValue == 3 {
                self.collectionView.tag=4444
            }
            else if intValue == 4 {
                self.collectionView.tag=5555
            }
            else if intValue == 5 {
                self.collectionView.tag=6666
            }
        }
        else {
            self.collectionView.tag=1000
        }

    }
    
    func fetchScreenData() {
        
        if(self.title != "WALL") {
            
            if intValue == 0{   // ALL
                
               
                self.fetchPostDataFromServer()
                self.fetchExploreDataFromServer()
            }
            else if intValue == 1{   // Explore
                // Explore condition
            }
            else if intValue == 2{   // Friends
                self.fetchPostDataFromServer()
            }
            else if intValue == 3{   // Colleagues
            
                self.fetchPostDataFromServer()
            }
            else if intValue == 4{    // Health Clubs
               
                self.fetchPostDataFromServer()
            }
            else if intValue == 5{    // PAC Circles
               
                self.fetchPostDataFromServer()
            }
        }
        else{
            self.fetchPostDataFromServer() // Wall condition
        }

    }
    
    override func viewDidAppear(animated: Bool) {

        super.viewDidAppear(animated)
        print("SCREEN TAG ==> \(intValue)")
        
//        self.setColectionViewTags()
//        self.fetchScreenData()
        
        if self.indexForCommentcount >= 0 { //  if self.indexForCommentcount >= 0 && self.isFromCommentVC {
            self.fetchCommentDataFromServer()
        }
        else {
            self.setColectionViewTags()
            self.fetchScreenData()
        }
        
        print_debug(self.collectionView.tag)
        self.collectionView.reloadData()

    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = true
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    func hideSocialSharingView() -> Void {
        self.view_share.hidden = true
    }
    //MARK:- ActionSheet Delegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
         if (actionSheet.tag==10001)
        {
            switch buttonIndex{
            case 0:
                self.showCustomController()
                break;
            case 1:
                UIApplication.sharedApplication().statusBarHidden=true;
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imagePicker.mediaTypes = [String(kUTTypeMovie)]
                imagePicker.delegate = self
                self.presentViewController(imagePicker, animated: true, completion: nil)
                
                break;
            default:
                
                break;
            }
        }
        
        
    }
    
    //MARK:- onClickBtn
    @IBAction func onClickLikeBtn(sender: AnyObject) {
        
        //   let cell: UITableViewCell = sender.superview!!.superview as! UITableViewCell
        //   let index : NSIndexPath = self.tableView.indexPathForCell(cell)!
        let button: UIButton = sender as! UIButton
        button.selected = !sender.selected
        
        button.setImage(UIImage(named: "like_filled"), forState: .Normal)
        button.setImage(UIImage(named: "like_nav_color"), forState: .Selected)
        
        
        
        var dict = Dictionary<String,AnyObject>()
        
        dict["type"]="post"
         
        
        dict["likeStatus"] = sender.selected
        dict["userId"] = ChatHelper.userDefaultForKey("userId")
        
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.collectionView)
        let indexPath =  self.collectionView.indexPathForItemAtPoint(buttonPosition)
        if indexPath != nil {
            
            var resultData = [String:AnyObject]()
            
            if self.collectionView.tag ==  1111 {
                resultData = self.postAllArr[indexPath!.row ] as! [String:AnyObject]
            }
            else if self.collectionView.tag ==  3333 {
                resultData = self.postFriendsArr[indexPath!.row ] as! [String:AnyObject]
            }
            else if self.collectionView.tag ==  4444 {
                resultData = self.postColleagueArr[indexPath!.row ] as! [String:AnyObject]
            }
            else if self.collectionView.tag ==  5555 {
                resultData = self.postHealthClubsArr[indexPath!.row ] as! [String:AnyObject]
            }
            else if self.collectionView.tag ==  6666 {
                resultData = self.postCircleArr[indexPath!.row ] as! [String:AnyObject]
            }
            else if self.collectionView.tag ==  1000 {
                resultData = self.pacWallArr[indexPath!.row ] as! [String:AnyObject]
            }
            
           
            dict["typeId"] = resultData["_id"] as! String
        }
        
        ChatListner.getChatListnerObj().socket.emit("like", dict)
        
        
    }
    
    
    @IBAction func onClickComments(sender: AnyObject) {
        
        var resultData = [String:AnyObject]()
        
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.collectionView)
        let indexPath =  self.collectionView.indexPathForItemAtPoint(buttonPosition)
        if indexPath != nil {
            
            
           // self.isFromCommentVC = false
            if self.collectionView.tag ==  1111 {
                resultData = self.postAllArr[indexPath!.row ] as! [String:AnyObject]
                self.indexForCommentcount = indexPath!.row
                
                self.newsFeedID = resultData["_id"] as! String
                print_debug("ID \(newsFeedID)")
                
            }
            else if self.collectionView.tag ==  3333 {
                resultData = self.postFriendsArr[indexPath!.row ] as! [String:AnyObject]
                self.indexForCommentcount = indexPath!.row
                self.newsFeedID = resultData["_id"] as! String
            }
            else if self.collectionView.tag ==  4444 {
                resultData = self.postColleagueArr[indexPath!.row ] as! [String:AnyObject]
                self.indexForCommentcount = indexPath!.row
                self.newsFeedID = resultData["_id"] as! String
            }
            else if self.collectionView.tag ==  5555 {
                resultData = self.postHealthClubsArr[indexPath!.row ] as! [String:AnyObject]
                self.indexForCommentcount = indexPath!.row
                self.newsFeedID = resultData["_id"] as! String
            }
            else if self.collectionView.tag ==  6666 {
                resultData = self.postCircleArr[indexPath!.row ] as! [String:AnyObject]
                //self.indexForCommentcount = indexPath!.row
                self.indexForCommentcount = -1 // since we dont want to hit "fetchCommentDataFromServer" service
                self.newsFeedID = resultData["_id"] as! String
            }
            else if self.collectionView.tag ==  1000 {
                resultData = self.pacWallArr[indexPath!.row ] as! [String:AnyObject]
                self.indexForCommentcount = indexPath!.row
                self.newsFeedID = resultData["_id"] as! String
            }
            
        }
        
        let commentVc:CommentsVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("CommentsVC") as! CommentsVC
        commentVc.title = "Comments"
        commentVc.selectedCommentDict = resultData
        
        self.navigationController?.pushViewController(commentVc, animated: true)
        
        
    }
    
    
    @IBAction func onClickShareBtn(sender: AnyObject) {
        
        
        HelpingClass.showAlertControllerWithType(.Alert, fromController: self, title: AppName, message: "Do you want to share the post ?", cancelButtonTitle: "NO", otherButtonTitle: ["YES"], completion: {(clickedBtn) in
            
            print("Clicked Btn = \(clickedBtn)")
            
            if clickedBtn == "YES"{
                var resultData = [String:AnyObject]()
                
                let buttonPosition = sender.convertPoint(CGPointZero, toView: self.collectionView)
                let indexPath =  self.collectionView.indexPathForItemAtPoint(buttonPosition)
                if indexPath != nil {
                    
                    if self.collectionView.tag ==  1111 {
                        resultData = self.postAllArr[indexPath!.row ] as! [String:AnyObject]
                    }
                    else if self.collectionView.tag ==  3333 {
                        resultData = self.postFriendsArr[indexPath!.row ] as! [String:AnyObject]
                    }
                    else if self.collectionView.tag ==  4444 {
                        resultData = self.postColleagueArr[indexPath!.row ] as! [String:AnyObject]
                    }
                    else if self.collectionView.tag ==  5555 {
                        resultData = self.postHealthClubsArr[indexPath!.row ] as! [String:AnyObject]
                    }
                    else if self.collectionView.tag ==  6666 {
                        resultData = self.postCircleArr[indexPath!.row ] as! [String:AnyObject]
                    }
                    else if self.collectionView.tag ==  1000  {
                        resultData = self.pacWallArr[indexPath!.row ] as! [String:AnyObject]
                    }
                }
                
                
                self.sendPostToServer(resultData["postType"] as! String, isShared: true, createdDict: resultData, imgOrVideoUlr: nil, captionText: nil, thumNailName:nil)
                
            
            }
            })
        
    }
    
    @IBAction func onClickPlayVideoBtn(sender: AnyObject) {
        
        var resultData = [String:AnyObject]()
        
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.collectionView)
        let indexPath =  self.collectionView.indexPathForItemAtPoint(buttonPosition)
        if indexPath != nil {
            
            if self.collectionView.tag ==  1111 {
                resultData = self.postAllArr[indexPath!.row ] as! [String:AnyObject]
            }
            else if self.collectionView.tag ==  3333 {
                resultData = self.postFriendsArr[indexPath!.row ] as! [String:AnyObject]
            }
            else if self.collectionView.tag ==  4444 {
                resultData = self.postColleagueArr[indexPath!.row ] as! [String:AnyObject]
            }
            else if self.collectionView.tag ==  5555 {
                resultData = self.postHealthClubsArr[indexPath!.row ] as! [String:AnyObject]
            }
            else if self.collectionView.tag ==  6666 {
                resultData = self.postCircleArr[indexPath!.row ] as! [String:AnyObject]
            }
            else if self.collectionView.tag ==  1000 {
                resultData = self.pacWallArr[indexPath!.row ] as! [String:AnyObject]
            }
        }
        
        let postType = resultData["postType"] as! String
        
        if postType == "image" {
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let fullImageVC: FullScreenImageVC = storyBoard.instantiateViewControllerWithIdentifier("FullScreenImageVC") as! FullScreenImageVC
            fullImageVC.imagePath = (resultData["attachments"] as! [String]).first!
            fullImageVC.downLoadPath="1"
            self.navigationController?.pushViewController(fullImageVC, animated: true)
            
        }else if(postType == "video"){
            
            let thumbNailName = resultData["thumNailName"] as! String
            var videoName = thumbNailName.stringByReplacingOccurrencesOfString("Thumb", withString: "Video")
            videoName = videoName.stringByReplacingOccurrencesOfString(".jpg", withString: ".mp4")
            let imgUrls = resultData["attachments"] as! [String]
            
            HelpingClass.isFileExistsAtPath(directory: "/ChatFile", fileName: videoName, completion: {(isExistPath, fileUrl) -> Void in
                
                if isExistPath{
                    
                    self.moviePlayerController = MPMoviePlayerViewController(contentURL:NSURL.fileURLWithPath(fileUrl!))
                    
                }else{
                    
                    self.moviePlayerController = MPMoviePlayerViewController(contentURL:NSURL(string: imgUrls.first!))
                }
                
                //moviePlayerController.movieSourceType = MPMovieSourceType.Streaming
                self.presentMoviePlayerViewControllerAnimated(self.moviePlayerController)
                //self.moviePlayerController.fullscreen = true
                self.moviePlayerController.moviePlayer.play()
            })
            
            
            
        }
     
        
    }
    
    
    @IBAction func onClickFBBtn(sender: AnyObject) {
        
        UIView.animateWithDuration(0.3, animations: {
            self.view_share.alpha = 0
            self.view_share.hidden = true
        })
        
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText(self.textView.text
            )
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func onClickTwiterBtn(sender: AnyObject) {
        
        UIView.animateWithDuration(0.3, animations: {
            self.view_share.alpha = 0
            self.view_share.hidden = true
        })
        
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText(self.textView.text)
            self.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func onClickSnapChatBtn(sender: AnyObject) {
        
        UIView.animateWithDuration(0.3, animations: {
            self.view_share.alpha = 0
            self.view_share.hidden = true
        })
    }
    
    
    @IBAction func onClickPhotoBtn(sender: AnyObject) {
        
        //self.layoutAttachmetBottom.constant = 120;
        intValue = self.view.tag
        print(intValue)
        //
        self.attachmentViewS.hidden = false
        self.textView.resignFirstResponder()
        //self.view.bringSubviewToFront(self.attachmentViewS)
        
        UIView.animateWithDuration(0.5, animations:
            {
                //    self.attachmentViewS.layoutIfNeeded()
                //  self.view.setTranslatesAutoresizingMaskIntoConstraints(false)
                //older
                self.view.layoutIfNeeded()
                
        })
        
        UIView.animateWithDuration(0.3, animations: {
            self.view_share.alpha = 0
            self.view_share.hidden = true
        })
        
       
        
    }
    
   
    @IBAction func onClickPlusBtn(sender: AnyObject) {
        
        self.view_share.alpha = 0
        
        UIView.animateWithDuration(0.3, animations: {
            self.view_share.alpha = 1.0
            if(self.view_share.hidden) {
                self.view_share.hidden = false
                //self.plusButton.transform = CGAffineTransformRotate(self.plusButton.transform, CGFloat(M_PI_4))

            }
            else {
                self.view_share.hidden = true
                //self.plusButton.transform = CGAffineTransformRotate(self.plusButton.transform, CGFloat(-M_PI_4))
            }
        })
        
    }
    
   
    @IBAction func onClickPostBtn(sender: AnyObject) {
        
        self.hideSocialSharingView()
        
        if self.textView.text?.characters.count < 1 {
            AppHelper.showAlertWithTitle(AppName, message: "Post text can't be blank.", tag: 0, delegate: nil, cancelButton: "OK", otherButton: nil)
            return
        }
        
        

        self.sendPostToServer("text", isShared: false, createdDict: nil, imgOrVideoUlr: nil, captionText: nil, thumNailName:nil)
      
        
        self.textView.text = ""
        self.textView.resignFirstResponder()
        
    }
    
    func onClickProfileImage(recognizer: UITapGestureRecognizer) {
        
        let location = recognizer.locationInView(self.collectionView)
        let indexPath = self.collectionView.indexPathForItemAtPoint(location)
        let cell = self.collectionView.cellForItemAtIndexPath(indexPath!) as! CellNewsFeed
        let vc = AppHelper.getProfileStoryBoard().instantiateViewControllerWithIdentifier("ProfileContainerVC") as! ProfileContainerVC
        vc.viewerUserID = cell.userID
        self.navigationController?.pushViewController(vc , animated: true)
    }
    
    
    func onClickMessage(recognizer: UITapGestureRecognizer) {
        
        print("tapped")
        let thisMessage = recognizer.view as! UILabel
        print(thisMessage.text)
        
        let urlString = thisMessage.text! as String
        
        if( HelpingClass.validateURL(urlString) ) {
        let WebVC:WebViewVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("WebViewVC") as! WebViewVC
        WebVC.title = "Web Browser"
        WebVC.urlStr = urlString
        self.navigationController?.pushViewController(WebVC, animated: true)
        }
    }
    func onClickOptions(sender : AnyObject) {
        
        var resultData = [String:AnyObject]()
        
        let buttonPosition = sender.superview??.convertPoint(CGPointZero, toView: self.collectionView)
        let indexPath =  self.collectionView.indexPathForItemAtPoint(buttonPosition!)
        if indexPath != nil {
            
            if self.collectionView.tag ==  1111 {
                resultData = self.postAllArr[indexPath!.row ] as! [String:AnyObject]
            }
            else if self.collectionView.tag ==  3333 {
                resultData = self.postFriendsArr[indexPath!.row ] as! [String:AnyObject]
            }
            else if self.collectionView.tag ==  4444 {
                resultData = self.postColleagueArr[indexPath!.row ] as! [String:AnyObject]
            }
            else if self.collectionView.tag ==  5555 {
                resultData = self.postHealthClubsArr[indexPath!.row ] as! [String:AnyObject]
            }
            else if self.collectionView.tag ==  6666 {
                resultData = self.postCircleArr[indexPath!.row ] as! [String:AnyObject]
            }
            else if self.collectionView.tag ==  1000 {
                resultData = self.pacWallArr[indexPath!.row ] as! [String:AnyObject]
            }
        }
        
        if(IS_IOS_7)
        {
            let actionSheet = UIActionSheet(title:"", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle:nil, otherButtonTitles: "Delete Post","Cancel")
            actionSheet.tag=10001
            //   actionSheet.showFromTabBar((bottomTabBar?.tabBar)!)
        }
        else
        {
            let actionSheet =  UIAlertController(title:nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Delete Post", style: UIAlertActionStyle.Default, handler:
                { (ACTION :UIAlertAction!)in
                    self.deletePostWithData(resultData)
                }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:
                { (ACTION :UIAlertAction!)in
                        
                }))
                    
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
        
    }
    
    //MARK :- Delete post service call
    func deletePostWithData(dataDict : [String : AnyObject]) {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            parameters["newsfeedId"] = dataDict["_id"] as! String
            
            if self.collectionView.tag ==  1111 {
                parameters["section"] = "ALL"
            }
            else if self.collectionView.tag ==  3333 {
                parameters["section"] = "FRIENDS"
            }
            else if self.collectionView.tag ==  4444 {
                parameters["section"] = "COLLEAGUES"
            }
            else if self.collectionView.tag ==  5555 {
                parameters["section"] = "HEALTH CLUBS"
            }
            else if self.collectionView.tag ==  6666 {
                parameters["section"] = "PAC"
            }
            else if self.collectionView.tag ==  1000{
                parameters["section"] = "PAC"
                parameters["pacId"] = self.pacID
            }

            //call global web service class latest
            Services.postRequest(ServiceDeleteNewsFeed, parameters: parameters, completionHandler:{
                (status,responseDict) in
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {

                        if let resultArr = responseDict["result"]  as? NSArray{
                            
                            if self.collectionView.tag ==  1111 {
                                self.postAllArr = NSMutableArray.init(array: resultArr)
                            }
                            else if self.collectionView.tag ==  3333 {
                                self.postFriendsArr = NSMutableArray.init(array: resultArr)
                            }
                            else if self.collectionView.tag ==  4444 {
                                self.postColleagueArr = NSMutableArray.init(array: resultArr)
                            }
                            else if self.collectionView.tag ==  5555 {
                                self.postHealthClubsArr = NSMutableArray.init(array: resultArr)
                            }
                            else if self.collectionView.tag ==  6666 {
                                self.postCircleArr = NSMutableArray.init(array: resultArr)
                            }
                            else if self.collectionView.tag ==  1000 {
                                self.pacWallArr = NSMutableArray.init(array: resultArr)
                            }
                            self.collectionView.reloadData()
                        }
                    }
                    else {
                        AppHelper.showAlertWithTitle(AppName, message: responseDict["errorMsg"] as! String, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    }
                    
                }
                else if (status == "Error"){
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
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.sharedApplication().canOpenURL(url)
            }
        }
        return false
    }
    
    func clickUserImage(recognizer: UITapGestureRecognizer )
    {
        
        let pointInTable = recognizer.locationInView(self.collectionView)
        let indexPath:NSIndexPath = self.collectionView.indexPathForItemAtPoint(pointInTable)!
        
        var dict = NSDictionary()
        
        if self.collectionView.tag ==  1111 {
            dict = self.postAllArr[indexPath.row ] as! [String:AnyObject]
        }
        else if self.collectionView.tag ==  3333 {
            dict = self.postFriendsArr[indexPath.row ] as! [String:AnyObject]
        }
        else if self.collectionView.tag ==  4444 {
            dict = self.postColleagueArr[indexPath.row ] as! [String:AnyObject]
        }
        else if self.collectionView.tag ==  5555 {
            dict = self.postHealthClubsArr[indexPath.row ] as! [String:AnyObject]
        }
        else if self.collectionView.tag ==  6666 {
            dict = self.postCircleArr[indexPath.row ] as! [String:AnyObject]
        }
        else if self.collectionView.tag ==  1000 {
            dict = self.pacWallArr[indexPath.row ] as! [String:AnyObject]
        }
        
        
        let imgUrls = dict["attachments"] as! [String]
        let thumbNailName = dict["thumNailName"] as! String
        
        
        
        let fullImageVC: FullScreenImageVC =  AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("FullScreenImageVC") as! FullScreenImageVC
        
        //fullImageVC.hidesBottomBarWhenPushed = true
        fullImageVC.parentNewsFeed = self
        
        
        
        
        //check the thumbNail name is exist ? or generate from video url and save to db
        HelpingClass.isFileExistsAtPath(directory: "/ChatFile", fileName: thumbNailName, completion: {(isExistPath, fileUrl) -> Void in
            
            if isExistPath {
                fullImageVC.imagePath = fileUrl
                fullImageVC.downLoadPath = "4"
            }else{
                fullImageVC.imagePath = imgUrls.first
                fullImageVC.downLoadPath = "3"
            }
            self.navigationController?.pushViewController(fullImageVC, animated: true)
            
            })
        
       
        
        
    }

    
    //MARK: - TextField Delegate
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
       // layOutConstrain_view_Post_bottom.constant = 300
        
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //layOutConstrain_view_Post_bottom.constant = 125
        textField.resignFirstResponder()
        
        return true
    }
    
    //MARK:- Keyborad Delegates
    
    func keyboardWillShow(sender: NSNotification) {
        
        UIView.animateWithDuration(0.1, animations: {
           
        })
        
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if keyboardSize.height == offset.height {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                
                var postViewFrame = self.postContainerView.frame
                postViewFrame.origin.y = self.view.bounds.size.height - (postViewFrame.size.height + keyboardSize.height + 60)
                self.postContainerView.frame = postViewFrame
                
                //self.view.frame.origin.y -= keyboardSize.height
            })
        } else {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                
                var postViewFrame = self.postContainerView.frame
                //postViewFrame.origin.y = self.view.bounds.size.height - (postViewFrame.size.height + (keyboardSize.height - offset.height) + 60)
                postViewFrame.origin.y = self.view.bounds.size.height - (postViewFrame.size.height + keyboardSize.height + 100)

                self.postContainerView.frame = postViewFrame
                
                //self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
        
    }
    
    
    func keyboardWillHide(sender: NSNotification) {
        
        UIView.animateWithDuration(0.1, animations: {
            var postViewFrame = self.postContainerView.frame
            postViewFrame.origin.y = self.view.bounds.size.height - (postViewFrame.size.height + 110)
            self.postContainerView.frame = postViewFrame
        })
      
    }
    
//    func keyboardWillShow(sender: NSNotification) {
//        if let userInfo = sender.userInfo {
//            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height {
//                
//                layOutConstrain_view_Post_bottom.constant = keyboardHeight + 80
//                UIView.animateWithDuration(0.25, animations: { () -> Void in
//                    self.view.layoutIfNeeded()
//                })
//            }
//        }
//    }
//    
//    func keyboardWillHide(sender: NSNotification) {
//        if let userInfo = sender.userInfo {
//            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height {
//                
//                layOutConstrain_view_Post_bottom.constant = 123
//                UIView.animateWithDuration(0.25, animations: { () -> Void in self.view.layoutIfNeeded() })
//            }
//        } }
//    
    
    
    //MARK: - Socket
    
    //mark- post type - text/image/video 
    //isShared - if text then y or n else n
    //createdDict - if isShared = y then get value from it
    //imgOrVideoUlr - if img or video not for text
    //text - if posttype img or video
    
    func sendPostToServer(postType:String, isShared:Bool,  createdDict:NSDictionary?, imgOrVideoUlr:String?, captionText:String?, thumNailName:String?) {
        
        
        
        if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {
            
            var dict = Dictionary<String,AnyObject>()
            
            dict["type"]="post"
            
            if self.collectionView.tag ==  1111 {
                dict["section"] = "ALL"
                
            }
            else if self.collectionView.tag ==  3333 {
                dict["section"] = "FRIENDS"
                
            }
            else if self.collectionView.tag ==  4444 {
                dict["section"] = "COLLEAGUES"
                
            }
            else if self.collectionView.tag ==  5555 {
                dict["section"] = "HEALTH CLUBS"
            }
            else if self.collectionView.tag ==  6666 {
                dict["section"] = "PAC"
            }
            else if self.collectionView.tag ==  1000 {
                dict["section"] = "PAC"
                dict["pacId"] = self.pacID
            }
            
            if isShared{
                
                if postType == "text" {
                    
                    dict["createdBy"] = (createdDict! as NSDictionary).valueForKeyPath("createdBy._id") as? String
                    
                    dict["sharedBy"] =  ChatHelper.userDefaultForKey(_ID)
                    dict["text"] = createdDict!["text"] as? String
                    
                }else{
                    let imgUrls = createdDict!["attachments"] as! [String]
                    
                    dict["createdBy"] = (createdDict! as NSDictionary).valueForKeyPath("createdBy._id") as? String
                    
                    dict["sharedBy"] =  ChatHelper.userDefaultForKey(_ID)
                    dict["text"] = createdDict!["text"] as? String
                    dict["url"] = imgUrls.first!
                    dict["thumNailName"] = createdDict!["thumNailName"] as! String
                    
                }
                
                
            }else{
                if postType == "text" {
                    
                    dict["text"] = self.textView.text
                    dict["createdBy"] = ChatHelper.userDefaultForKey(_ID)
                }else{
                    
                    dict["url"] = imgOrVideoUlr
                    dict["text"] = captionText!
                    dict["createdBy"] = ChatHelper.userDefaultForKey(_ID)
                    
                    dict["thumNailName"] = thumNailName
                
                
                }
            }
            //==============
       /*     if postType == "text" {
               
                if isShared{
                    
                    dict["createdBy"] = (createdDict! as NSDictionary).valueForKeyPath("createdBy._id") as? String
                    
                    dict["sharedBy"] =  ChatHelper.userDefaultForKey(_ID)
                    dict["text"] = createdDict!["text"] as? String
                    
                }else{
                    
                    
                    dict["text"] = self.textView.text
                    dict["createdBy"] = ChatHelper.userDefaultForKey(_ID)
                }
                
            }else{
                 dict["url"] = imgOrVideoUlr
                 dict["text"] = captionText!
                dict["createdBy"] = ChatHelper.userDefaultForKey(_ID)
                
               dict["thumNailName"] = thumNailName
                
                
            }*/
            
             dict["postType"] = postType
            
            
            
            print("emit dict = ", dict)
            
           
            ChatListner .getChatListnerObj().socket.emit("createPost", dict)
            
            
        }else
        {
            AppDelegate.dismissProgressHUD()
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Internet Connection not available.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
        }
    }
    
    func getAllPostEvent() -> Void {
        
        ChatListner .getChatListnerObj().socket.off("getPost")
        ChatListner .getChatListnerObj().socket.on("getPost") {data, ack in
            
            self.setColectionViewTags()
            //self.fetchScreenData()  //  commented by me 23rd Apr

            print_debug(self.collectionView.tag)

            let errorCode = (data[0]["status"] as? String) ?? "1"
            if errorCode == "0"
            {
                guard let dictData = data[0] as? Dictionary<String, AnyObject> else {
                    return
                }
                
                guard let resultDict = dictData["result"]  as? Dictionary<String, AnyObject>  else {
                    return
                }
                
                //var predicate = NSPredicate(format: "(%K == %@)", "_id", resultDict["_id"] as! String)
                if resultDict["section"] as! String == "all" {
                    
                    self.postAllArr.insertObject(resultDict, atIndex: 0)
                    if(self.postAllArr.count > 0) {
                        self.collectionView.reloadData()
                        self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0),atScrollPosition: .Top,animated: true)
                    }
                }
                else if resultDict["section"] as! String  == "friends" {
                    self.postFriendsArr.insertObject(resultDict, atIndex: 0)
                    if(self.postFriendsArr.count > 0) {
                        self.collectionView.reloadData()
                        self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0),atScrollPosition: .Top,animated: true)
                    }
                }
                else if resultDict["section"] as! String  == "colleagues" {
                    
                    self.postColleagueArr.insertObject(resultDict, atIndex: 0)
                    if(self.postColleagueArr.count > 0) {
                        self.collectionView.reloadData()
                        self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0),atScrollPosition: .Top,animated: true)
                    }
                }
                else if resultDict["section"] as! String  == "health clubs" {
                    
                    self.postHealthClubsArr.insertObject(resultDict, atIndex: 0)
                    if(self.postHealthClubsArr.count > 0) {
                        self.collectionView.reloadData()
                        self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0),atScrollPosition: .Top,animated: true)
                    }
                }
                else if resultDict["section"] as! String  == "pac circles" {
                    
                    self.postCircleArr.insertObject(resultDict, atIndex: 0)
                    if(self.postCircleArr.count > 0) {
                        self.collectionView.reloadData()
                        self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0),atScrollPosition: .Top,animated: true)
                    }
                }
                if resultDict["section"] as! String  == "pac" {
                    
                    self.pacWallArr.insertObject(resultDict, atIndex: 0)
                    if(self.pacWallArr.count > 0) {
                        self.collectionView.reloadData()
                        self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0),atScrollPosition: .Top,animated: true)
                    }
                }
            }
        }
    }

    func getLikeUpdate() -> Void {
        
        //unowned let weakself = self
        ChatListner .getChatListnerObj().socket.off("getPostUpdate")
        ChatListner .getChatListnerObj().socket.on("getPostUpdate") {data, ack in
            
            
            print("value error_code\(data[0]["status"] as! String))")
            
            let errorCode = (data[0]["status"] as? String) ?? "1"
            
            if errorCode == "0"
            {
                guard let dictData = data[0] as? Dictionary<String, AnyObject> else
                {
                    return
                }
                
                guard let resultDict = dictData["result"]  as? Dictionary<String, AnyObject>  else
                {
                    return
                }
                
                
                
                let predicate = NSPredicate(format: "(%K == %@)", "_id", resultDict["_id"] as! String)
                if resultDict["section"] as! String == "all" {
                    
                    
                    
                    var filteredarray:[AnyObject] = self.postAllArr.filteredArrayUsingPredicate(predicate)
                    print("ID = \(resultDict["_id"])")
                    
                    if filteredarray.count > 0 {
                        let index = self.postAllArr.indexOfObject( filteredarray[0])
                        self.postAllArr.replaceObjectAtIndex(index, withObject: resultDict)
                    }

                    
                }
                else if resultDict["section"] as! String  == "friends" {
                    var filteredarray:[AnyObject] = self.postFriendsArr.filteredArrayUsingPredicate(predicate)
                    print("ID =  \(resultDict["_id"])")
                    
                    if filteredarray.count > 0 {
                        
                        let index = self.postFriendsArr.indexOfObject( filteredarray[0])
                        self.postFriendsArr.replaceObjectAtIndex(index, withObject: resultDict)
                    }

                    
                }
                    
                else if resultDict["section"] as! String  == "colleagues" {
                    
                    var filteredarray:[AnyObject] = self.postColleagueArr.filteredArrayUsingPredicate(predicate)
                    print("ID =  \(resultDict["_id"])")
                    
                    if filteredarray.count > 0 {
                        let index = self.postColleagueArr.indexOfObject( filteredarray[0])
                        self.postColleagueArr.replaceObjectAtIndex(index, withObject: resultDict)
                    }

                }
                else if resultDict["section"] as! String  == "health clubs" {
                    
                    var filteredarray:[AnyObject] = self.postHealthClubsArr.filteredArrayUsingPredicate(predicate)
                    print("ID =  \(resultDict["_id"])")
                    
                    if filteredarray.count > 0 {
                        let index = self.postHealthClubsArr.indexOfObject( filteredarray[0])
                        self.postHealthClubsArr.replaceObjectAtIndex(index, withObject: resultDict)
                    }

                }
                else if resultDict["section"] as! String  == "pac circles" {
                    
                    var filteredarray:[AnyObject] = self.postCircleArr.filteredArrayUsingPredicate(predicate)
                    print("ID =  \(resultDict["_id"])")
                    
                    if filteredarray.count > 0 {
                        let index = self.postCircleArr.indexOfObject( filteredarray[0])
                        self.postCircleArr.replaceObjectAtIndex(index, withObject: resultDict)
                    }
                    
                }
                else if resultDict["section"] as! String  == "pac" {
                    var filteredarray:[AnyObject] = self.pacWallArr.filteredArrayUsingPredicate(predicate)
                    print("ID =  \(resultDict["_id"])")
                    
                    if filteredarray.count > 0 {
                        
                        let index = self.pacWallArr.indexOfObject( filteredarray[0])
                        self.pacWallArr.replaceObjectAtIndex(index, withObject: resultDict)
                    }
                    
                    
                }
                
                self.collectionView.reloadData()
            }
            else
            {
                //SharedClass.sharedInstance.showOkAlertViewController(result!["response_string"] as! String, viewController: self)
                }
                
            }     
        
    }
    
    //MARK: - Collection Header Footer delegates
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:

            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderScrollerView", forIndexPath: indexPath) as! HeaderScrollerView
            
            //     headerView.frame.size.height = 0
            headerView.backgroundColor = UIColor.redColor()
            headerView.setDataSource(dataArrForHeader)
            headerView.setViewTitle(top: "FOLLOWING", bottomTitle: "UPDATES")
            return headerView
            
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "FooterAllReUsableView", forIndexPath: indexPath) as! FooterAllReUsableView
            return footerView
            
        default: break
            
            //assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView.init(frame: CGRectMake(0, 0, 0, 0))
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        // Require no header section in such cases
        print_debug("title for index values");
        print_debug(self.title)
        if self.title == "FRIENDS" || self.title == "COLLEAGUES" || self.title == "HEALTH CLUBS" || self.title == "WALL" || self.title == "PACs" {
        
            return CGSizeZero
        }
        var secHeight:CGFloat
        
        if dataArrForHeader.count>0 {
            secHeight=370
        } else {
            secHeight=0
        }
        return CGSize(width: self.collectionView.frame.width, height: secHeight)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterSection section: Int) -> CGSize {
        
        
        //   return CGSize(width: self.collectionView.frame.width, height: 160)
        return CGSize(width: 0, height: 0)
        
    }
    
    //MARK:- Collection DataSource
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    //    return CGSize(width: 100.0, height: 100.0)
        
        var dict = NSDictionary()
        
        if self.collectionView.tag ==  1111 {
            dict = self.postAllArr[indexPath.row ] as! [String:AnyObject]
        }
        else if self.collectionView.tag ==  3333 {
            dict = self.postFriendsArr[indexPath.row ] as! [String:AnyObject]
        }
        else if self.collectionView.tag ==  4444 {
            dict = self.postColleagueArr[indexPath.row ] as! [String:AnyObject]
        }
        else if self.collectionView.tag ==  5555 {
            dict = self.postHealthClubsArr[indexPath.row ] as! [String:AnyObject]
        }
        else if self.collectionView.tag ==  6666 {
            dict = self.postCircleArr[indexPath.row ] as! [String:AnyObject]
        }
        else if self.collectionView.tag ==  1000  {
            dict = self.pacWallArr[indexPath.row ] as! [String:AnyObject]
        }
        
        
        
        let newString = dict["text"]!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let str = newString.stringByReplacingEmojiCheatCodesWithUnicode()
        
        //                    let fontName = AppHelper .userDefaultForAny("fontName") as String
        //                    let fontSize = AppHelper .userDefaultForAny("fontSize") as CGFloat
        let w = collectionView.bounds.size.width - 40
        let size : CGSize =  CommonMethodFunctions.sizeOfCell(str, fontSize: 16 , width: Float(w) , fontName: "Roboto-Light")
        
        var height = size.height + (160)
        
        if dict["postType"] as! String != "text" {

            height = height + (400 - 200)
            //if the post is shared by then increase height of cell
            if ((dict as NSDictionary).valueForKeyPath("sharedBy.firstName") as? String) != nil {
                height = height + 10
            }
            
        }
        
        return CGSize(width: w, height: height)
        
        
    
    }



    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //let dataArr = self.dataDict["members"] as! [AnyObject]
        
        if self.collectionView.tag ==  1111 {
            return self.postAllArr.count
        }
         else if self.collectionView.tag ==  3333  {
            return self.postFriendsArr.count
        }
        else if self.collectionView.tag ==  4444  {
            return self.postColleagueArr.count
        }
        else if self.collectionView.tag ==  5555  {
            return self.postHealthClubsArr.count
        }
        else if self.collectionView.tag ==  6666  {
            return self.postCircleArr.count
        }
        else if self.collectionView.tag ==  1000  {
            if (dictValuePacRole.count > 0 ){
            let settingsDict = dictValuePacRole["result"]!["settings"] as! [String : AnyObject]
            
            let isPrivate = settingsDict["private"] as! Bool
            let  memberStatus = dictValuePacRole["result"]!["memberStatus"] as! Bool
            
            if(memberStatus == false) {
                if(isPrivate == true) {
                    var noDataImage : UIImageView
                    noDataImage  = UIImageView(frame: CGRect(x: (screenWidth/2)-160, y: screenHeight-500, width: 320, height: 153))
                    noDataImage.image = UIImage(named:"private_user_texticon")
                    self.view.addSubview(noDataImage)
                }
                postContainerView.hidden = true
            }
            else{
                postContainerView.hidden = false
            }
            }

            return self.pacWallArr.count

        }
        return 0
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var dict = NSDictionary()
        //textView.hidden = false

        if self.collectionView.tag ==  1111 {
            dict = self.postAllArr[indexPath.row ] as! [String:AnyObject]
        }
        else if self.collectionView.tag ==  3333 {
            dict = self.postFriendsArr[indexPath.row ] as! [String:AnyObject]
        }
        else if self.collectionView.tag ==  4444 {
            dict = self.postColleagueArr[indexPath.row ] as! [String:AnyObject]
        }
        else if self.collectionView.tag ==  5555 {
            dict = self.postHealthClubsArr[indexPath.row ] as! [String:AnyObject]
        }
        else if self.collectionView.tag ==  6666 {
            dict = self.postCircleArr[indexPath.row ] as! [String:AnyObject]
        }
        else if self.collectionView.tag ==  1000  {
            dict = self.pacWallArr[indexPath.row ] as! [String:AnyObject]
           
        }
        
        //cell type Text or image Or video
        var  cell:CellNewsFeed!
        if dict["postType"] as! String == "text" {
            
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellText", forIndexPath: indexPath) as! CellNewsFeed
        }else{
            
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellAttachment", forIndexPath: indexPath) as! CellNewsFeed
        }
        
        
        let lpgrMain : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ExploreVC.handleLongPress(_:)))
        lpgrMain.minimumPressDuration = 0.5
        
        lpgrMain.delegate = self
        lpgrMain.delaysTouchesBegan = true
        
        
        let iv_profile = cell.viewWithTag(1) as! UIImageView
        let lbl_name = cell.viewWithTag(2) as! UILabel
        let lbl_timeAgo = cell.viewWithTag(3) as! UILabel
        let lbl_details = cell.viewWithTag(4) as! UITextView
        lbl_details.selectable = true
        lbl_details.dataDetectorTypes = UIDataDetectorTypes.Link
        lbl_details.delegate = self
        //lbl_details.userInteractionEnabled = true
        let lbl_subDetails = cell.viewWithTag(5) as! UILabel
        
        let btn_options = cell.viewWithTag(777) as! UIButton
        let btn_like = cell.viewWithTag(6) as! UIButton
        let btn_comments = cell.viewWithTag(7) as! UIButton
        let btn_share = cell.viewWithTag(8) as! UIButton
        
        btn_like.titleLabel?.textAlignment = .Left
        lbl_subDetails.text = ""

        if(self.title != "PACs") {
            cell.layoutConstBtnShare.constant = 74
            btn_share.alpha = 1.0
            btn_comments.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            btn_options.alpha = 1.0
            cell.layoutConstBtnLike.constant = 80
            btn_like.userInteractionEnabled = true
            postContainerView.hidden = false
        }
        else {
            cell.layoutConstBtnLike.constant = screenWidth - 150
            cell.layoutConstBtnShare.constant = 0
            btn_share.alpha = 0.0
            btn_comments.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
            btn_options.alpha = 0.0
            btn_like.userInteractionEnabled = false
            postContainerView.hidden = true

        }


        iv_profile.layer.borderWidth = 1.0
        iv_profile.contentMode = .ScaleAspectFill
        iv_profile.backgroundColor = UIColor.whiteColor()
        iv_profile.layer.masksToBounds = false
        iv_profile.layer.borderColor = UIColor.lightGrayColor().CGColor
        iv_profile.layer.cornerRadius = 26
        iv_profile.clipsToBounds = true
        
        let tapProfileImage = UITapGestureRecognizer.init(target: self, action: #selector(NewsFeedsAllVC.onClickProfileImage(_:)))
        iv_profile.addGestureRecognizer(tapProfileImage)
        
        let tapMessageText = UITapGestureRecognizer.init(target: self, action: #selector(NewsFeedsAllVC.onClickMessage(_:)))
        //lbl_details.addGestureRecognizer(tapMessageText)

        
        btn_like.setImage(UIImage(named: "like_filled"), forState: .Normal)
        btn_like.setImage(UIImage(named: "like_nav_color"), forState: .Selected)
        
        btn_options.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2));
        //let theImageView = UIImageView(image: UIImage(named:"more_menu")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))
        //theImageView.tintColor = UIColor.grayColor()
        //btn_options.setImage(theImageView.image, forState: .Normal)
        btn_options.addTarget(self, action: #selector(NewsFeedsAllVC.onClickOptions(_:)), forControlEvents: .TouchUpInside)

        if let createdBy = (dict as NSDictionary).valueForKeyPath("createdBy._id") as? String {
           
            if let sharedBy = (dict as NSDictionary).valueForKeyPath("sharedBy._id") as? String {
                if(sharedBy == AppHelper.userDefaultsForKey(_ID) as? String) {
                    btn_options.hidden = false
                }
                else {
                    btn_options.hidden = true
                }
            }
            else {
                if(createdBy == AppHelper.userDefaultsForKey(_ID) as? String) {
                    btn_options.hidden = false
                }
                else {
                    btn_options.hidden = true
                }
            }
        }
        
        
        //shared by name
        if let sharedByFname = (dict as NSDictionary).valueForKeyPath("sharedBy.firstName") as? String {
            
            let sharedByLName = (dict as NSDictionary).valueForKeyPath("sharedBy.lastName") as? String
            let sharedByID = (dict as NSDictionary).valueForKeyPath("sharedBy._id") as? String
            let ownerID = (dict as NSDictionary).valueForKeyPath("createdBy._id") as? String
            let ownerFName = (dict as NSDictionary).valueForKeyPath("createdBy.firstName") as? String
            let ownerLName = (dict as NSDictionary).valueForKeyPath("createdBy.lastName") as? String
            
            if (sharedByID != ownerID) {
                
                lbl_name.text = sharedByFname + " shared " + ownerFName! + "'s post"
                
            }else{
                lbl_name.text = sharedByFname +  " shared post"
            }
            
        }else{
            //Posted by name
            if let fName = (dict as NSDictionary).valueForKeyPath("createdBy.firstName") as? String {
                let lName = (dict as NSDictionary).valueForKeyPath("createdBy.lastName") as? String
                lbl_name.text = fName + " shared post"
            }
        }
        
        //height of lbl
        let text = lbl_name.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let str = text.stringByReplacingEmojiCheatCodesWithUnicode()
        
        let w = collectionView.bounds.size.width - 90
        let size : CGSize =  CommonMethodFunctions.sizeOfCell(str, fontSize: 16 , width: Float(w) , fontName: "Roboto-Regular")
        
        cell.layOut_lbl_Name_height.constant = size.height + 15
        
        if let userID = (dict as NSDictionary).valueForKeyPath("sharedBy._id") as? String {
            cell.userID = userID
        }
        else if let userID = (dict as NSDictionary).valueForKeyPath("createdBy._id") as? String {
            cell.userID = userID
        }
        
        //shared by profile image
        iv_profile.image = UIImage(named: "ic_booking_profilepic")
        if let logoUrlStr = (dict as NSDictionary).valueForKeyPath("sharedBy.imgUrl") as? String    {
            
            let image_url = NSURL(string: logoUrlStr )
            if (image_url != nil) {
                
                let placeholder = UIImage(named: "ic_booking_profilepic")
                iv_profile.sd_setImageWithURL((URL: image_url!), placeholderImage: placeholder)
            }
            
        }else{
             //Posted by profile image
            let placeholder = UIImage(named: "ic_booking_profilepic")

            if let logoUrlStr = (dict as NSDictionary).valueForKeyPath("createdBy.imgUrl") as? String    {
                
                let ulrRequet = NSURLRequest(URL: NSURL(string: logoUrlStr)!)
            iv_profile.setImageWithURLRequest(ulrRequet, placeholderImage: placeholder, success: { [weak cell] (request:NSURLRequest!,response:NSHTTPURLResponse!, image:UIImage!) -> Void in
                
                
                }, failure: { [weak cell]
                    (request:NSURLRequest!,response:NSHTTPURLResponse!, error:NSError!) -> Void in
                    
                    
                })
             }
        
            
            if let logoUrlStr = (dict as NSDictionary).valueForKeyPath("createdBy.imgUrl") as? String    {
                
                let image_url = NSURL(string: logoUrlStr )
                if (image_url != nil) {
                    
                    let placeholder = UIImage(named: "ic_booking_profilepic")
                    iv_profile.sd_setImageWithURL((URL: image_url!), placeholderImage: placeholder)
                }
                
            }
        }
        
        if let createdDate = dict["createdDate"] as? String {
            
            let df = NSDateFormatter.init()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            df.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            //   df.timeZone = NSTimeZone(name: "UTC")
            
            
            
            df.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            let tempDate = df.dateFromString(createdDate) as NSDate!
            
            df.dateFormat = "yyyy-MM-dd-HH:mm:ss.sss"
            let dateStr = df.stringFromDate(tempDate)
           /* df.dateFormat = "HH:mm:ss.sss"
            df.timeZone = NSTimeZone()
            let timeStr = df.stringFromDate(tempDate)
            
            */
            
            lbl_timeAgo.text = HelpingClass.timeAgoSinceDate(df.dateFromString(dateStr)!, numericDates: false)
           
        }
        
        lbl_details.text =  dict["text"] as? String
        
        

        
        btn_like.selected = false
        
        // if user id is available in likes arr set btn selected
        if self.collectionView.tag !=  6666  {

        if let likes = dict["likes"] as? [String]{
            
            for id in likes {
                if ChatHelper.userDefaultForKey(_ID) == id {
                    
                    btn_like.selected = true
                }
            }
            btn_like.setTitle(String((dict["likes"] as? [String])!.count), forState: .Normal)
            
        }
        }
        
        btn_comments.setTitle(String((dict["comments"] as? [AnyObject])!.count), forState: .Normal)
    
        
        if dict["postType"] as! String != "text" {
            
            let thumbIV =  cell.viewWithTag(20) as! UIImageView
            let btn_videoPlay =  cell.viewWithTag(21) as! UIButton
            let indicator = cell.viewWithTag(22) as! UIActivityIndicatorView
            
            
            thumbIV.contentMode = .ScaleAspectFit
            thumbIV.clipsToBounds = true
            
            let imgUrls = dict["attachments"] as! [String]
            
            
             let thumbNailName = dict["thumNailName"] as! String
               
            //check the thumbNail name is exist ? or generate from video url and save to db
            HelpingClass.isFileExistsAtPath(directory: "/ChatFile", fileName: thumbNailName, completion: {(isExistPath, fileUrl) -> Void in
                
                if dict["postType"] as! String == "image"{
                    
                    let recognizer = UITapGestureRecognizer(target: self, action:#selector(NewsFeedsAllVC.clickUserImage(_:)))
                    recognizer.delegate = self
                    thumbIV.addGestureRecognizer(recognizer)
                    thumbIV.userInteractionEnabled = true
                    
                    btn_videoPlay.hidden = true
                    indicator.startAnimating()
                    
                    indicator.hidden = false
                    
                    if isExistPath {
                        let img = UIImage(contentsOfFile: fileUrl!)
                        thumbIV.image =  CommonMethodFunctions.imageWithImage(img, scaledToWidth: Float( UIScreen.mainScreen().bounds.size.width) - 30);
                        indicator.hidden = true
                        indicator.stopAnimating()
                    }else{
                        thumbIV.sd_setImageWithURL(NSURL(string: imgUrls.first!), placeholderImage: UIImage(named:  "cell_blured_heigh")) {
                            (img,  err,  cacheType,  imgUrl) -> Void in
                            
                            //thumbIV.image =  CommonMethodFunctions.imageWithImage(img, scaledToWidth: Float( UIScreen.mainScreen().bounds.size.width) - 30);
                            indicator.hidden = true
                            indicator.stopAnimating()
                            
                        }
                        
                        
                        
                    }
                    
                    
                }else{
                    //for video
                    
                    btn_videoPlay.hidden = true
                    indicator.hidden = false
                    indicator.startAnimating()
                    
                    
                    if isExistPath {
                        let img = UIImage(contentsOfFile: fileUrl!)
                        thumbIV.image = CommonMethodFunctions.imageWithImage(img, scaledToWidth: Float( UIScreen.mainScreen().bounds.size.width) - 30);
                        indicator.hidden = true
                        indicator.stopAnimating()
                        btn_videoPlay.hidden = false
                    } else {
                        
                        //generate thumb from video url    and display on cell
                        if let img =  CommonMethodFunctions.generateThumbImage(NSURL(string: imgUrls.first!)!) { //self.generateThumnail(sourceURL: NSURL(string: imgUrls.first!)!)
                        thumbIV.image = CommonMethodFunctions.imageWithImage(img, scaledToWidth: Float( UIScreen.mainScreen().bounds.size.width) - 30);
                        
                        //write to db
                        let imgData = UIImagePNGRepresentation(img) as NSData?
                        
                        HelpingClass.writeToPath(directory: "/ChatFile", fileName: thumbNailName, dataToWrite: imgData!, completion: {(isWritten:Bool, err:NSError?) -> Void in
                            
                            if isWritten{
                                
                                indicator.hidden = true
                                indicator.stopAnimating()
                                btn_videoPlay.hidden = false
                                
                            }
                        })
                        }
                    }
                    
                }
                
                
            })
           
        }
        
        
        // Pagination
        
      
        if self.collectionView.tag ==  1111 {
            // Pagination
            
            if self.postAllArr.count >= 5 {
            
            if indexPath.item == self.postAllArr.count - 1 {
                self.fetchPostDataFromServer()
            }
          }
        }
        else if self.collectionView.tag ==  3333 {
            
            if self.postFriendsArr.count >= 5 {
           
            if indexPath.item == self.postFriendsArr.count - 1 {
                self.fetchPostDataFromServer()
            }
          }
        }
        else if self.collectionView.tag ==  4444 {
            
            
             if self.postColleagueArr.count >= 5 {
            
             if indexPath.item == self.postColleagueArr.count - 1 {
                
                self.fetchPostDataFromServer()
                
            }
           }
        }
        else if self.collectionView.tag ==  5555 {
            
            if self.postHealthClubsArr.count >= 5 {

            if indexPath.item == self.postHealthClubsArr.count - 1 {
                
                self.fetchPostDataFromServer()
            }
          }
        }
        else if self.collectionView.tag ==  6666 {
            
             if self.postCircleArr.count >= 5 {
             if indexPath.item == self.postCircleArr.count - 1 {
                
                self.fetchPostDataFromServer()
                
            }
           }
        }
        else if self.collectionView.tag ==  1000  {
          
            if self.pacWallArr.count >= 5 {
                if indexPath.item == self.pacWallArr.count - 1 {
                self.fetchPostDataFromServer()
                
            }
          }
                
        }
        // will display Organisation name
        if self.collectionView.tag ==  6666  {
            let dictPAC = dict["pacId"] as! [String:AnyObject]
            btn_like.setImage(UIImage(), forState: .Normal)
            btn_like.setTitle(dictPAC["name"] as? String, forState: .Normal)

        }
        
        
        
        return cell
    }
    
    
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    

    

    
  /*(  func writeToURL(named:String, completion: (result: Bool, url:NSURL?) -> Void)  {
        
        let filePath = NSTemporaryDirectory() + named
        //var success:Bool = false
        let tmpURL = NSURL( fileURLWithPath:  filePath )
        weak var weakSelf = self
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //write to URL atomically
            if weakSelf!.writeToURL(tmpURL, atomically: true) {
                
                if NSFileManager.defaultManager().fileExistsAtPath( filePath ) {
                    completion(result: true, url:tmpURL)
                } else {
                    completion (result: false, url:tmpURL)
                }
            }
        })
    }
    */
    
    func generateTimeStamp() -> String {
        
        let date = NSDate()
        var dateStr : String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss.sss.sss"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateStr = dateFormatter.stringFromDate(date)
        
        print("time stam ", dateStr);
        
        return dateStr
        
    }
    /*
    func generateThumnail(sourceURL sourceURL:NSURL) -> UIImage {
        let asset = AVAsset(URL: sourceURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        let time = CMTime(seconds: 1, preferredTimescale: 1)
        
        do {
            let imageRef = try imageGenerator.copyCGImageAtTime(time, actualTime: nil)
            return UIImage(CGImage: imageRef)
        } catch {
            print(error)
            return UIImage(named: "some generic thumbnail")!
        }
    }
   */

    
    //MARK:- Collection Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        //   self.handleSingleTapAtIndex(indexPath)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    
    //MARK:- Service Call
    
    func fetchExploreDataFromServer() {
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            
            //call global web service class latest
            Services.postRequest(ServiceGetAllStories, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        dataArr = responseDict["allStories"] as! [AnyObject]
                        dataArrForHeader = responseDict["subscribeStories"] as! [AnyObject]
                        //self.dataArr = items.map({$0["latestArticleLogoUrl"]! as! String}) as [String]
                        self.collectionView.reloadData()
                        
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
    //MARK:- Service for comments count 
    
    func fetchCommentDataFromServer() {
        
        if AppDelegate.checkInternetConnection() {
            isPostServiceCalled = true
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
      
            
            if self.collectionView.tag ==  1111 {
                parameters["newsfeedId"] =  self.newsFeedID
            }
            else if self.collectionView.tag ==  3333 {
                parameters["newsfeedId"] = self.newsFeedID
                
            }
            else if self.collectionView.tag ==  4444 {
                parameters["newsfeedId"] = self.newsFeedID
                
            }
            else if self.collectionView.tag ==  5555 {
                parameters["newsfeedId"] = self.newsFeedID
                            }
            else if self.collectionView.tag ==  6666 {
                parameters["newsfeedId"] = self.newsFeedID
            }
            else if self.collectionView.tag ==  1000{
                parameters["newsfeedId"] = self.newsFeedID
               
            }
            
            
            print("Dict = \(parameters)")
            //call global web service class latest
            Services.postRequest(ServiceCommentsData, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                isPostServiceCalled = false
                
                print("Response = \(responseDict)")
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        if let resultDict = responseDict["result"]  as? Dictionary<String, AnyObject>{
                            
                            if self.collectionView.tag ==  1111 {
                                print_debug("RESULTDATA:\(resultDict)")
                                self.postAllArr.replaceObjectAtIndex(self.indexForCommentcount, withObject: resultDict)
                                
                            }
                            else if self.collectionView.tag ==  3333 {
                                
                                // self.postFriendsArr = NSMutableArray.init(array: resultArr)
                                
                                self.postFriendsArr.replaceObjectAtIndex(self.indexForCommentcount, withObject: resultDict)
                                
                                
                            }
                            else if self.collectionView.tag ==  4444 {
                                
                                // self.postColleagueArr = NSMutableArray.init(array: resultArr)
                                
                                 self.postColleagueArr.replaceObjectAtIndex(self.indexForCommentcount, withObject: resultDict)
                                
                            }
                            else if self.collectionView.tag ==  5555 {
                                // self.postHealthClubsArr = NSMutableArray.init(array: resultArr)
                                
                                 self.postHealthClubsArr.replaceObjectAtIndex(self.indexForCommentcount, withObject: resultDict)
                                
                            }
                            else if self.collectionView.tag ==  6666 {
                                // self.postCircleArr = NSMutableArray.init(array: resultArr)
                                self.postCircleArr.replaceObjectAtIndex(self.indexForCommentcount, withObject: resultDict)

                                
                               
                            }
                            else if self.collectionView.tag ==  1000 {
                                //self.pacWallArr = NSMutableArray.init(array: resultArr)
                                self.pacWallArr.replaceObjectAtIndex(self.indexForCommentcount, withObject: resultDict)
      
                            }
                            
                            self.collectionView.reloadData()
                            
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
    
    
    
    
    
    
    func fetchPostDataFromServer() {
        
        if AppDelegate.checkInternetConnection() {
            isPostServiceCalled = true
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            
//            if self.title == "WALL" {
//                parameters["section"] = "PAC"
//                parameters["pacId"] = self.pacID
//            }
//            else {
//                parameters["section"] = self.title
//            }
            
            if self.collectionView.tag ==  1111 {
                parameters["section"] = "ALL"
                // adding index for pagination on 20/04/2017
                parameters["index"] = self.postAllArr.count
            }
            else if self.collectionView.tag ==  3333 {
                parameters["section"] = "FRIENDS"
                parameters["index"] = self.postFriendsArr.count

            }
            else if self.collectionView.tag ==  4444 {
                parameters["section"] = "COLLEAGUES"
                parameters["index"] = self.postColleagueArr.count

            }
            else if self.collectionView.tag ==  5555 {
                parameters["section"] = "HEALTH CLUBS"
                parameters["index"] = self.postHealthClubsArr.count
            }
            else if self.collectionView.tag ==  6666 {
                parameters["section"] = "paccircle"
                parameters["index"] = self.postCircleArr.count
            }
            else if self.collectionView.tag ==  1000{
                parameters["section"] = "PAC"
                parameters["pacId"] = self.pacID
                parameters["index"] = self.pacWallArr.count
            }
            
            
            print("Dict = \(parameters)")
            //call global web service class latest
            Services.postRequest(ServiceGetNewsFeed, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                isPostServiceCalled = false
                
          //      print("Response = \(responseDict)")
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                  if ((responseDict["error"] as! Int) == 0) {
                    
                    
                    if let resultArr = responseDict["result"]  as? NSArray{
                        
                        if self.collectionView.tag ==  1111 {
                           
                            //self.postAllArr = NSMutableArray.init(array: resultArr)
                            
                            if resultArr.count > 0 {
                                self.postAllArr.addObjectsFromArray(resultArr as [AnyObject])
                               // self.newsFeedIndex = self.postAllArr.count
                            
                            }
                            else {
                                return
                            }
                            
                        }
                        else if self.collectionView.tag ==  3333 {
                            
                           // self.postFriendsArr = NSMutableArray.init(array: resultArr)
                            
                            if resultArr.count > 0 {
                                self.postFriendsArr.addObjectsFromArray(resultArr as [AnyObject])
                               // self.postFriendsIndex = self.postFriendsArr.count
                            }
                            else {
                                return
                            }
                            
                        }
                        else if self.collectionView.tag ==  4444 {
                            
                            // self.postColleagueArr = NSMutableArray.init(array: resultArr)
                            
                            if resultArr.count > 0 {
                                
                                self.postColleagueArr.addObjectsFromArray(resultArr as [AnyObject])
                              //  self.postColleagueIndex = self.postColleagueArr.count
                                
                            }
                            else {
                                return
                            }
                            
                            
                        }
                        else if self.collectionView.tag ==  5555 {
                           // self.postHealthClubsArr = NSMutableArray.init(array: resultArr)
                            
                            if resultArr.count > 0 {
                                
                                self.postHealthClubsArr.addObjectsFromArray(resultArr as [AnyObject])
                               // self.postHealthClubIndex = self.postHealthClubsArr.count
                                
                            }
                            else {
                                return
                            }
    
                            
                        }
                        else if self.collectionView.tag ==  6666 {
                           // self.postCircleArr = NSMutableArray.init(array: resultArr)
                            
                            if resultArr.count > 0 {
                                
                                self.postCircleArr.addObjectsFromArray(resultArr as [AnyObject])
                              //  self.pacCircleIndex = self.postCircleArr.count
                                
                            }
                            else {
                                return
                            }
    
                        }
                        else if self.collectionView.tag ==  1000 {
                            //self.pacWallArr = NSMutableArray.init(array: resultArr)
                            
                            if resultArr.count > 0 {
                                
                                self.pacWallArr.addObjectsFromArray(resultArr as [AnyObject])
                               // self.pacWallIndex = self.pacWallArr.count
                                
                            }
                            else {
                                return
                            }
                        
                        }
                        
                        self.collectionView.reloadData()

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
    
    
    //MARK:- Attachment View
  
    @IBAction func cancelAttachviewClick(sender: AnyObject) {
        self.cancelAttchView()
    }
    
    func cancelAttchView()-> Void
    {
        //self.layoutAttachmetBottom.constant = -200;
        self.attachmentViewS.hidden = true


        UIView.animateWithDuration(0.5, animations:
            {
                self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func takePicFromCameraClick(sender: AnyObject) {
        self.cancelAttchView()
        if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {
            UIApplication.sharedApplication().statusBarHidden=true;
            let imagePicker = UIImagePickerController()
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
            {
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                imagePicker.mediaTypes = [String(kUTTypeImage)]
                //imagePicker.allowsEditing = true
                imagePicker.delegate = self
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
                    switch authStatus {
                    case .Authorized:
                        self.presentViewController(imagePicker, animated: true, completion: nil)

                        break
                    case .Denied:
                        AppHelper.showAlertWithTitle(AppName, message:cameraSetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    case .NotDetermined:
                        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo,
                            completionHandler: { (granted:Bool) -> Void in
                                if granted {
                                    self.presentViewController(imagePicker, animated: true, completion: nil)

                                }
                                else {
                                    AppHelper.showAlertWithTitle(AppName, message:cameraSetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                                }
                        })
                    default:
                        AppHelper.showAlertWithTitle(AppName, message:cameraSetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                        
                    }
                });
                
                //self.presentViewController(imagePicker, animated: true, completion: nil)
            }else
            {
                if(IS_IOS_7)
                {
                    ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Camera not available.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                }
                else
                {
                    let alertController = UIAlertController(title:APP_NAME, message:"Camera not available.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                        
                    }))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }else
        {
            if(IS_IOS_7)
            {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Internet Connection not available.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
            else
            {
                let alertController = UIAlertController(title:APP_NAME, message:"Internet Connection not available.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                    
                }))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func takeVideoFromCameraClick(sender: AnyObject) {
        self.cancelAttchView()
        if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {
            UIApplication.sharedApplication().statusBarHidden=true;
            let imagePicker = UIImagePickerController()
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
            {
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                imagePicker.mediaTypes = [String(kUTTypeMovie)]
                imagePicker.delegate = self
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
                    switch authStatus {
                    case .Authorized:
                        self.presentViewController(imagePicker, animated: true, completion: nil)
                        
                        break
                    case .Denied:
                        AppHelper.showAlertWithTitle(AppName, message:cameraSetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    case .NotDetermined:
                        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo,
                            completionHandler: { (granted:Bool) -> Void in
                                if granted {
                                    self.presentViewController(imagePicker, animated: true, completion: nil)
                                    
                                }
                                else {
                                    AppHelper.showAlertWithTitle(AppName, message:cameraSetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                                }
                        })
                    default:
                        AppHelper.showAlertWithTitle(AppName, message:cameraSetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                        
                    }
                });
                
               // self.presentViewController(imagePicker, animated: true, completion: nil)
            }else
            {
                if(IS_IOS_7)
                {
                    ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Camera not available.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                }
                else
                {
                    let alertController = UIAlertController(title:APP_NAME, message:"Camera not available.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                        
                    }))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }else
        {
            if(IS_IOS_7)
            {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Internet Connection not available.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
            else
            {
                let alertController = UIAlertController(title:APP_NAME, message:"Internet Connection not available.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                    
                }))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func choosePicfromGalleryClick(sender: AnyObject)
    {
        self.cancelAttchView()
        
        
        if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {
            self.openActionSheet()
        }else
        {
            if(IS_IOS_7)
            {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Internet Connection not available.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
            else
            {
                let alertController = UIAlertController(title:APP_NAME, message:"Internet Connection not available.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                    
                }))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    
  /*  @IBAction func takeVideoFromGalleryClick(sender: AnyObject)
    {
        self.cancelAttchView()
        if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {
            UIApplication.sharedApplication().statusBarHidden=true;
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.mediaTypes = [String(kUTTypeMovie)]
            imagePicker.delegate = self
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        }else
        {
            if(IS_IOS_7)
            {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Internet Connection not available.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
            else
            {
                let alertController = UIAlertController(title:APP_NAME, message:"Internet Connection not available.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                    
                }))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        
    }*/
    //MARK:- 
    func uniqueName(fileName: String) -> String {
        
        let uniqueImageName = NSString(format: "%@%f", fileName , NSDate().timeIntervalSince1970 * 1000)
        // print(uniqueImageName)
        return uniqueImageName as String
    }
    
    func openActionSheet() -> Void
    {
        
        if(IS_IOS_7)
        {
            let actionSheet = UIActionSheet(title:"", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle:nil, otherButtonTitles: "Send images","Send Video")
            actionSheet.tag=10001
         //   actionSheet.showFromTabBar((bottomTabBar?.tabBar)!)
        }
        else
        {
            let actionSheet =  UIAlertController(title:"", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Send images", style: UIAlertActionStyle.Default, handler:
                { (ACTION :UIAlertAction!)in
                    
                    
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)//PHPhotoLibrary.authorizationStatus()
                        switch authStatus {
                        case .Authorized:
                            self.showCustomController()
                        break // Do your stuff here i.e. allowScanning()
                        case .Denied:
                            AppHelper.showAlertWithTitle(AppName, message:gallerySetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                        case .NotDetermined:
                            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { granted in
                                if granted {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.showCustomController()
                                    }
                                }
                            })
                        default:
                             AppHelper.showAlertWithTitle(AppName, message:gallerySetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                        }
                    })
                    
                  //  self.showCustomController()
                    
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Send Video", style: UIAlertActionStyle.Default, handler: { (ACTION :UIAlertAction!)in
                UIApplication.sharedApplication().statusBarHidden=true;
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imagePicker.mediaTypes = [String(kUTTypeMovie)]
                imagePicker.delegate = self
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)//PHPhotoLibrary.authorizationStatus()
                    switch authStatus {
                    case .Authorized:
                        self.presentViewController(imagePicker, animated: true, completion: nil)
                    break // Do your stuff here i.e. allowScanning()
                    case .Denied:
                        AppHelper.showAlertWithTitle(AppName, message:gallerySetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    case .NotDetermined:
                        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { granted in
                            if granted {
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.presentViewController(imagePicker, animated: true, completion: nil)
                                }
                            }
                        })
                    default:
                        AppHelper.showAlertWithTitle(AppName, message:gallerySetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    }
                })
                //self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (ACTION :UIAlertAction!)in
                
            }))
            
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
    }
    
    func showCustomController() {
        let pickerController = DKImagePickerController()
        pickerController.pickerDelegate = self
        pickerController.maxSelectableCount = 1
        self.presentViewController(pickerController, animated: true) {}
    }
    
    
    //MARK:- DKImagePickerController  Delegates
    
    func imagePickerControllerCancelled() {
        
     //   isFromGallery = true
        viewWillAppaerCount = 1
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidSelectedAssets(assets: [DKAsset]!)
    {
    //    isFromGallery = true
        
        self.dismissViewControllerAnimated(true, completion: nil)
        delay(0.1,
              closure: {
                UIApplication.sharedApplication().statusBarHidden = false;
                UIApplication.sharedApplication().statusBarStyle = .LightContent
        })
       //  self.globalAssets = assets
      //   self.addCaptionOnPost(assets, cameraImage: nil, videoUrl: nil)
        
       // self.handleMultipleImages(self.globalAssets!, captionText: "")
        
        if ServiceClass.checkNetworkReachabilityWithoutAlert(){
            
//            self.globalAssets = assets
            for (index, asset) in assets!.enumerate() {
                let fullimg = asset.fullScreenImage
            }
            self.addCaptionOnPost(assets, cameraImage: nil, videoUrl: nil)
            //self.handleMultipleImages(self.globalAssets!, captionText: "")
            
            
        }
 
        //handle muliple image
      /*
       var count = 0
        var thumbArr: NSMutableArray = NSMutableArray()
        
        for (index, asset) in assets.enumerate(){
            
            count = index
            
            let locId = CommonMethodFunctions.nextIdentifies()
            let strId = String(locId)
            
            let timeStamp = generateTimeStamp() + String("-") + String(index)
            
            
            let tempImage = UIImageView(image: asset.fullScreenImage)
            //     let thumbImg = UIImageView(image: asset.thumbnailImage)
            
            let imgData = UIImageJPEGRepresentation(tempImage.image!, 0.8)
            let thumbNailName = "Thumb" + timeStamp + ".jpg"
            
            thumbArr.insertObject(thumbNailName, atIndex: 0)
            
            HelpingClass.writeToPath(directory: "/ChatFile", fileName: thumbNailName, dataToWrite: imgData!, completion: {(isWritten:Bool, err:NSError?) -> Void in
                
                if isWritten{
                    
                }
                })
            
            
            var dict = Dictionary<String, AnyObject>()
            
            
            dict["message"] = ""
            dict["type"] = "image"
            dict["mediaUrl"] = ""
            dict["mediaThumbUrl"] = ""
            dict["localmsgid"] = strId
            
            NSOperationQueue.mainQueue().addOperationWithBlock() { () in
                
                AppDelegate.showProgressHUDWithStatus("Please wait..")
                
                let name = self.uniqueName("")   + String("-") + String(index)
                
                
                
                
                UploadInS3.sharedGlobal().uploadMultipleImagesOnChatTos3(imgData, type: 0, dictInfo: dict, fromDist: "chat", meldID: name, completion: { ( bool_val : Bool, pathUrl : String!) -> Void in
                    
                    
                    
                    if bool_val == true{
                        
                        count = count - 1
                        
                        /* for  index in  0 ..< (UploadInS3.sharedGlobal().chatImagesFiles as NSMutableArray).count {
                            
                            
                            if let citiesArr = UploadInS3.sharedGlobal().chatImagesFiles{
                                
                                var fileName = Dictionary<String, AnyObject>()
                                if let _:Dictionary<String, AnyObject> = citiesArr[index] as? Dictionary
                                {
                                    fileName = citiesArr[index] as! Dictionary
                                    let strFileName : String = fileName["chatImagesName"] as! String
                                    
                                    
                                        
                                    
                                    
                                    
                                }
                                else {}
                            }
                        }*/
                        
                        let thumbNameTemp = String(thumbArr.lastObject)
                        
                        self.sendPostToServer("image", isShared: false, createdDict: nil, imgOrVideoUlr: pathUrl , captionText: "", thumNailName:thumbNameTemp)
                        
                        thumbArr.removeLastObject()
                        
                        if count == -1 {
                            AppDelegate.dismissProgressHUD()
                        }
                        
                    }
                    
                    
                    } , completionProgress: { ( bool_val : Bool, progress) -> Void in
                        
                })
            }
        }
        */
          self.dismissViewControllerAnimated(true, completion: nil)
    
        
    }
    
    
    
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
                
                self.addCaptionOnPost(nil, cameraImage: info[UIImagePickerControllerOriginalImage] as? UIImage, videoUrl: nil)
            }
        }else if(info["UIImagePickerControllerMediaType"] as! String == "public.movie")
        {
            if ServiceClass.checkNetworkReachabilityWithoutAlert(){
                self.addCaptionOnPost(nil, cameraImage: nil, videoUrl: info[UIImagePickerControllerMediaURL] as? NSURL)
                
                
            }
            
        }
    }
    
    //MARK:- upload 
    
    func uploadImage(uploadImage:UIImage, captionText: String?) -> Void {
        
        let locId = CommonMethodFunctions.nextIdentifies()
        let strId = String(locId)
        
         let timeStamp = generateTimeStamp()
        
        
        // let imgData = UIImageJPEGRepresentation(uploadImage, 0.8)
        
     //   let thumbImg = CommonMethodFunctions.generatePhotoThumbnail(uploadImage);
        let thumbData = UIImageJPEGRepresentation(uploadImage, 0.0)
        let thumbNailName = "Thumb" + timeStamp + ".jpg"
        
        
        HelpingClass.writeToPath(directory: "/ChatFile", fileName: thumbNailName, dataToWrite: thumbData!, completion: {(isWritten:Bool, err:NSError?) -> Void in
            
            if isWritten{
                
            }
            
        })
        
        
        NSOperationQueue.mainQueue().addOperationWithBlock() { () in
            
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            
            let name = self.uniqueName("")
            UploadInS3.sharedGlobal().uploadImageTos3( thumbData, type: 0, fromDist: "chat", meldID: name, completion: { ( bool_val : Bool, pathUrl : String!) -> Void in
                
                 AppDelegate.dismissProgressHUD()
                
                if bool_val == true
                {
                    let fileName =  UploadInS3.sharedGlobal().strFilesName
                    
                    if fileName != nil{
                        
                         self.sendPostToServer("image", isShared: false, createdDict: nil, imgOrVideoUlr: pathUrl , captionText: captionText, thumNailName:thumbNailName)
                    }
                }
                else{}
                
                
                }
                , completionProgress: { ( bool_val : Bool, progress) -> Void in
                    
                    
                    
                }
            )
            
        }
        
    }
    
    func uploadVideo(videoUrl:NSURL, captionText:
        String?) -> Void {
        
        let locId = CommonMethodFunctions.nextIdentifies()
        let strId = String(locId)
        
        let timeStamp = generateTimeStamp()
        
        let videoName = "Video"+timeStamp+".mp4"
        let thumbNailName = "Thumb" + timeStamp + ".jpg"
        
       
       
        // generate thumb image from video url and save to path
      // let thumbImg = CommonMethodFunctions.getThumbNail(videoUrl);
        let thumbImg = CommonMethodFunctions.generateThumbImage(videoUrl)
        let thumbData = UIImageJPEGRepresentation(thumbImg, 1.0)
        
        HelpingClass.writeToPath(directory: "/ChatFile", fileName: thumbNailName, dataToWrite: thumbData!, completion: {(isWritten:Bool, err:NSError?) -> Void in
            
            if isWritten{
                
            }
            
        })
        
        
        //Make low quality and save to DB
        
        let outPutPath = HelpingClass.generateLocalFilePath(directory: "/ChatFile", fileName: videoName)
        
        CommonMethodFunctions.convertVideoToLowQuailtyWithInputURL(videoUrl, outputURL: NSURL.fileURLWithPath(outPutPath), handler: { (exportSession : AVAssetExportSession!) -> Void in
            switch(exportSession.status)
            {
            case .Completed:
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let compressedVideoData =  NSData(contentsOfURL: NSURL.fileURLWithPath(outPutPath))
                    
                    HelpingClass.writeToPath(directory: "/ChatFile", fileName: videoName, dataToWrite: compressedVideoData!, completion: {(isWritten:Bool, err:NSError?) -> Void in
                        
                        if isWritten{
                            
                        }
                        
                    })
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock() { () in
                        AppDelegate.showProgressHUDWithStatus("Please wait..")
                        
                        
                        let name = self.uniqueName("")
                        UploadInS3.sharedGlobal().uploadImageTos3( compressedVideoData, type: 1, fromDist: "chat", meldID: name, completion: { ( bool_val : Bool, pathUrl : String!) -> Void in
                            
                            AppDelegate.dismissProgressHUD()
                            
                            
                            if bool_val == true
                            {
                                let fileName =  UploadInS3.sharedGlobal().strFilesName
                                //  progressV.hidden = true
                                if fileName != nil{
                                    self.sendPostToServer("video", isShared: false, createdDict: nil, imgOrVideoUlr: pathUrl , captionText: captionText,thumNailName:thumbNailName )
                                }
                            }
                            
                            
                            
                            }, completionProgress: { ( bool_val : Bool, progress) -> Void in
                                
                        })
                    }
                    
                    
                });
                break
            default:
                break
               
            }
                
            })
            
            

                    
                    
                    //------------------------
        
       
       /*
        
        
        
        
        let videoData =  NSData(contentsOfURL: NSURL.fileURLWithPath(videoUrl.path!))
        */
       


        }
    
    
    //MARK:- To add image/Video Caption
    
    func addCaptionOnPost(assets: [DKAsset]?, cameraImage:UIImage?, videoUrl:NSURL?) -> Void {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: AppName, message: "Say something about this photo...", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
           // textField.text = "Some default text."
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { [weak alert] (action) -> Void in
            let textField = alert!.textFields![0] as UITextField
            print("Text field: \(textField.text)")
            
            if(assets != nil){
                //multiple images
                self.handleMultipleImages(assets!, captionText: textField.text!)
                
            }else if(cameraImage != nil){
                // from camera
                self.uploadImage(cameraImage!, captionText: textField.text)
            }else{
                //either from record or video from gallery
                
                self.uploadVideo(videoUrl!,captionText: textField.text)
                
                
            }
          
            }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleMultipleImages(assets: [DKAsset]!, captionText:String?) -> Void {

        
        var count = 0
        
        for (index, asset) in assets!.enumerate() {
            
            
            let locId = CommonMethodFunctions.nextIdentifies()
            let strId = String(locId)
            
            let timeStamp = generateTimeStamp() + String("-") + String(count)
            count = count + 1
            
            let fullImage = UIImageView(image: asset.fullScreenImage)
            let thumbImage = UIImageView(image: asset.thumbnailImage)
            
            let imgData = UIImageJPEGRepresentation(fullImage.image!, 0.5)
            let thumbNailName = "Thumb" + timeStamp + ".jpg"
            
            
            HelpingClass.writeToPath(directory: "/ChatFile", fileName: thumbNailName, dataToWrite: imgData!, completion: {(isWritten:Bool, err:NSError?) -> Void in
                
                if isWritten{
                    
                }
                
            })
           
            var dict = Dictionary<String, AnyObject>()
            dict["message"] = ""
            dict["type"] = "image"
            dict["mediaUrl"] = ""
            dict["mediaThumbUrl"] = ""
            dict["localmsgid"] = strId
            
            
            NSOperationQueue.mainQueue().addOperationWithBlock() { () in
                
                AppDelegate.showProgressHUDWithStatus("Please wait..")
                
                let name = self.uniqueName("") + String("-") + String(count)
                
                UploadInS3.sharedGlobal().uploadMultipleImagesOnChatTos3(imgData, type: 0, dictInfo: dict, fromDist: "chat", meldID: name, completion: { ( bool_val : Bool, pathUrl : String!) -> Void in
                    
                    AppDelegate.dismissProgressHUD()
                    
                    if bool_val == true {
                        self.sendPostToServer("image", isShared: false, createdDict: nil, imgOrVideoUlr: pathUrl , captionText: captionText, thumNailName:thumbNailName)
                    //    print("image path~~~~~~ = ", pathUrl)
                     
                    }
                    
                    
                    } , completionProgress: { ( bool_val : Bool, progress) -> Void in
                       
                })
            }
        }
        
      //  self.dismissViewControllerAnimated(true, completion: nil)
    }

}

extension NewsFeedsAllVC: UITextViewDelegate {
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
      
        let WebVC:WebViewVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("WebViewVC") as! WebViewVC
        WebVC.title = "Web Browser"
        WebVC.urlStr = URL.absoluteString!
        self.navigationController?.pushViewController(WebVC, animated: true)
        
        return false
    }
}

// MARK: - FooterAllReUsableView
class FooterAllReUsableView: UICollectionReusableView{
    
    
    var customView : CollectionHeaderCustomView? = nil
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //self.collectionView.reloadData()
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.myCustomInit()
    }
    
    func myCustomInit() {
        print("hello there from SupView")
    }
    
}



class CellNewsFeed:UICollectionViewCell{
    
    @IBOutlet weak var layOut_lbl_Name_height: NSLayoutConstraint!
    @IBOutlet weak var layoutConstBtnShare: NSLayoutConstraint!
    @IBOutlet weak var layoutConstBtnLike: NSLayoutConstraint!

    var userID:String!

}

