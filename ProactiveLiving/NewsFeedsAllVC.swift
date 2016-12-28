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

class NewsFeedsAllVC: UIViewController, UIGestureRecognizerDelegate, UICollectionViewDataSource, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,  UIActionSheetDelegate, DKImagePickerControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet weak var view_share: UIView!
    @IBOutlet weak var view_post: UIView!
    
    @IBOutlet weak var tf_share: CustomTextField!
    
    
    @IBOutlet weak var layOutConstrain_view_Post_bottom: NSLayoutConstraint!
    @IBOutlet weak var attachmentViewS: UIView!
    
    
    @IBOutlet weak var layoutAttachmetBottom: NSLayoutConstraint!
    
    
    //  var dataArr = [AnyObject]()
    var profileArr = [String]()
    var urlArr = [String]()
    var postAllArr:NSMutableArray = NSMutableArray()
    var postFriendsArr:NSMutableArray = NSMutableArray()
    var postColleagueArr:NSMutableArray = NSMutableArray()
    var postHealthClubsArr:NSMutableArray = NSMutableArray()
    
    var tapGesture = UITapGestureRecognizer()
    var moviePlayerController = MPMoviePlayerController()
    var globalAssets: [DKAsset]?
 //   var isFromGallery:Bool!
    
    var isBackFromChildVC:Bool!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     //   isFromGallery = false
        isBackFromChildVC = false
        viewWillAppaerCount = 0
        
     tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewsFeedsAllVC.hideSocialSharingView))
     
        
        self.view_share.hidden = true
        
        self.view_post.layer.borderWidth = 1.0
        self.view_post.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        
       
        if self.title == "ALL" || self.title == "FRIENDS" || self.title == "COLLEAGUES" || self.title == "HEALTH CLUBS"{
            
            self.collectionView.registerClass(HeaderScrollerView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderScrollerView")
            
            
            
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewsFeedsAllVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewsFeedsAllVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        
        
        
        
       
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
         //to avoid blocking the UI
        if (viewWillAppaerCount > 0) {
            
            viewWillAppaerCount = viewWillAppaerCount + 1
            
            if viewWillAppaerCount == 5{
                
                viewWillAppaerCount = 0
            }
            
            
            return
        }
        
        if isBackFromChildVC == true{
            isBackFromChildVC = false
            return
        }
        
        if self.title == "ALL" || self.title == "EXPLORE" {
            
            self.fetchExploreDataFromServer()
        }
        if self.title == "ALL" || self.title == "FRIENDS" || self.title == "COLLEAGUES" || self.title == "HEALTH CLUBS"{
            
            self.getPostEvent()
            self.getLikeUpdate()
        }
        
        if !isPostServiceCalled  {
            self.fetchPostDataFromServer()
        }
        
        
        self.collectionView.reloadData()
        
        self.layoutAttachmetBottom.constant = -200;
        
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // When user comes back from gallery Does not post come on time line
        self.getPostEvent()
        self.getLikeUpdate()
        
       
    }
    
    
    func hideSocialSharingView() -> Void {
        
        self.view_share.hidden = true
        self.collectionView.removeGestureRecognizer(tapGesture)
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
    
    //MARK: - onClickBtn
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
            
            if self.title == "ALL" {
                resultData = self.postAllArr[indexPath!.row ] as! [String:AnyObject]
            }
            else if self.title == "FRIENDS" {
                resultData = self.postFriendsArr[indexPath!.row ] as! [String:AnyObject]
            }
            else if self.title == "COLLEAGUES" {
                resultData = self.postColleagueArr[indexPath!.row ] as! [String:AnyObject]
            }
            else if self.title == "HEALTH CLUBS" {
                resultData = self.postHealthClubsArr[indexPath!.row ] as! [String:AnyObject]
            }
            
           
            dict["typeId"] = resultData["_id"] as! String
        }
        
        ChatListner .getChatListnerObj().socket.emit("like", dict)
        
        
    }
    
    
    @IBAction func onClickComments(sender: AnyObject) {
        
        var resultData = [String:AnyObject]()
        
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.collectionView)
        let indexPath =  self.collectionView.indexPathForItemAtPoint(buttonPosition)
        if indexPath != nil {
                        
            if self.title == "ALL" {
                resultData = self.postAllArr[indexPath!.row ] as! [String:AnyObject]
            }
            else if self.title == "FRIENDS" {
                resultData = self.postFriendsArr[indexPath!.row ] as! [String:AnyObject]
            }
            else if self.title == "COLLEAGUES" {
                resultData = self.postColleagueArr[indexPath!.row ] as! [String:AnyObject]
            }
            else if self.title == "HEALTH CLUBS" {
                resultData = self.postHealthClubsArr[indexPath!.row ] as! [String:AnyObject]
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
                    
                    if self.title == "ALL" {
                        resultData = self.postAllArr[indexPath!.row ] as! [String:AnyObject]
                    }
                    else if self.title == "FRIENDS" {
                        resultData = self.postFriendsArr[indexPath!.row ] as! [String:AnyObject]
                    }
                    else if self.title == "COLLEAGUES" {
                        resultData = self.postColleagueArr[indexPath!.row ] as! [String:AnyObject]
                    }
                    else if self.title == "HEALTH CLUBS" {
                        resultData = self.postHealthClubsArr[indexPath!.row ] as! [String:AnyObject]
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
            
            if self.title == "ALL" {
                resultData = self.postAllArr[indexPath!.row ] as! [String:AnyObject]
            }
            else if self.title == "FRIENDS" {
                resultData = self.postFriendsArr[indexPath!.row ] as! [String:AnyObject]
            }
            else if self.title == "COLLEAGUES" {
                resultData = self.postColleagueArr[indexPath!.row ] as! [String:AnyObject]
            }
            else if self.title == "HEALTH CLUBS" {
                resultData = self.postHealthClubsArr[indexPath!.row ] as! [String:AnyObject]
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
            
            self.isFileExistsAtPath(directory: "/ChatFile", fileName: videoName, completion: {(isExistPath, fileUrl) -> Void in
                
                if isExistPath{
                    
                    self.moviePlayerController = MPMoviePlayerController(contentURL:NSURL.fileURLWithPath(fileUrl!))
                    
                }else{
                    
                    self.moviePlayerController = MPMoviePlayerController(contentURL:NSURL(string: imgUrls.first!))
                }
                
                //moviePlayerController.movieSourceType = MPMovieSourceType.Streaming
                self.view.addSubview(self.moviePlayerController.view)
                self.moviePlayerController.fullscreen = true
                self.moviePlayerController.play()
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
            facebookSheet.setInitialText(self.tf_share.text
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
            twitterSheet.setInitialText(self.tf_share.text)
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
        
        self.attachmentViewS.backgroundColor=UIColor.lightGrayColor()
        
        self.layoutAttachmetBottom.constant = 120;
        self.view.bringSubviewToFront(self.attachmentViewS)
        
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
        
        self.collectionView.removeGestureRecognizer(tapGesture)
        self.collectionView.addGestureRecognizer(tapGesture)
        
        self.view_share.alpha = 0
    //    UIApplication.sharedApplication().keyWindow?.bringSubviewToFront(self.view_share)
    //    self.view_share.layer.zPosition = 1;
    //    self.view_share.superview!.bringSubviewToFront(self.view_share)
        
        UIView.animateWithDuration(0.3, animations: {
            self.view_share.alpha = 1.0
            self.view_share.hidden = false
        })
        
    }
    
   
    @IBAction func onClickPostBtn(sender: AnyObject) {
        
        if self.tf_share.text?.characters.count < 1 {
            AppHelper.showAlertWithTitle(AppName, message: "Post text can't be blank.", tag: 0, delegate: nil, cancelButton: "OK", otherButton: nil)
            return
        }

        self.sendPostToServer("text", isShared: false, createdDict: nil, imgOrVideoUlr: nil, captionText: nil, thumNailName:nil)
      
        
        self.tf_share.text = ""
        self.tf_share.resignFirstResponder()
        
    }
    
    
    func clickUserImage(recognizer: UITapGestureRecognizer )
    {
        
        let pointInTable = recognizer.locationInView(self.collectionView)
        let indexPath:NSIndexPath = self.collectionView.indexPathForItemAtPoint(pointInTable)!
        
        var dict = NSDictionary()
        
        if self.title == "ALL" {
            dict = self.postAllArr[indexPath.row ] as! [String:AnyObject]
        }
        else if self.title == "FRIENDS" {
            dict = self.postFriendsArr[indexPath.row ] as! [String:AnyObject]
        }
        else if self.title == "COLLEAGUES" {
            dict = self.postColleagueArr[indexPath.row ] as! [String:AnyObject]
        }
        else if self.title == "HEALTH CLUBS" {
            dict = self.postHealthClubsArr[indexPath.row ] as! [String:AnyObject]
        }
        
        
        let imgUrls = dict["attachments"] as! [String]
        let thumbNailName = dict["thumNailName"] as! String
        
        
        
        let fullImageVC: FullScreenImageVC =  AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("FullScreenImageVC") as! FullScreenImageVC
        
        fullImageVC.hidesBottomBarWhenPushed = true
        fullImageVC.parentNewsFeed = self
        
        
        
        
        //check the thumbNail name is exist ? or generate from video url and save to db
        self.isFileExistsAtPath(directory: "/ChatFile", fileName: thumbNailName, completion: {(isExistPath, fileUrl) -> Void in
            
            if isExistPath {
                fullImageVC.imagePath = fileUrl
                fullImageVC.downLoadPath = "4"
            }else{
                fullImageVC.imagePath = imgUrls.first
                fullImageVC.downLoadPath = "3"
            }
            
            })
        
       
        
        self.navigationController?.pushViewController(fullImageVC, animated: true)
    }

    
    //MARK: - TextField Delegate
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
       // layOutConstrain_view_Post_bottom.constant = 300
        
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        layOutConstrain_view_Post_bottom.constant = 125
        textField.resignFirstResponder()
        
        return true
    }
    
    //MARK:- Keyborad
    
    func keyboardWillShow(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height {
                
                layOutConstrain_view_Post_bottom.constant = keyboardHeight + 80
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height {
                
                layOutConstrain_view_Post_bottom.constant = 123
                UIView.animateWithDuration(0.25, animations: { () -> Void in self.view.layoutIfNeeded() })
            }
        } }
    
    
    
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
            
            
            if self.title == "ALL" {
                dict["section"] = "ALL"
            }
            else if self.title == "FRIENDS" {
                dict["section"] = "FRIENDS"
            }
            else if self.title == "COLLEAGUES" {
                dict["section"] = "COLLEAGUES"
            }
            else if self.title == "HEALTH CLUBS" {
                dict["section"] = "HEALTH CLUBS"
            }
            //=======
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
                    
                    dict["text"] = self.tf_share.text
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
                    
                    
                    dict["text"] = self.tf_share.text
                    dict["createdBy"] = ChatHelper.userDefaultForKey(_ID)
                }
                
            }else{
                 dict["url"] = imgOrVideoUlr
                 dict["text"] = captionText!
                dict["createdBy"] = ChatHelper.userDefaultForKey(_ID)
                
               dict["thumNailName"] = thumNailName
                
                
            }*/
            
             dict["postType"] = postType
            
            
            
            print("Request dict = ", dict)
            
           
            
            ChatListner .getChatListnerObj().socket.emit("createPost", dict)
            
            
        }else
        {
            AppDelegate.dismissProgressHUD()
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Internet Connection not available.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
        }
    }
    
    func getPostEvent() -> Void {
        
        //unowned let weakself = self
         ChatListner .getChatListnerObj().socket.off("getPost")
        ChatListner .getChatListnerObj().socket.on("getPost") {data, ack in
            
            
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
                
           
                
                var predicate = NSPredicate(format: "(%K == %@)", "_id", resultDict["_id"] as! String)
                if resultDict["section"] as! String == "all" {
                    
                   self.postAllArr.insertObject(resultDict, atIndex: 0)
                 //  self.title = "ALL"
                    
                }
                else if resultDict["section"] as! String  == "friends" {
                    
                   self.postFriendsArr.insertObject(resultDict, atIndex: 0)
                   // self.title =  "FRIENDS"
                    
                }
                    
                else if resultDict["section"] as! String  == "colleagues" {
                    
                    self.postColleagueArr.insertObject(resultDict, atIndex: 0)
                  //  self.title = "COLLEAGUES"
                }
                else if resultDict["section"] as! String  == "health clubs" {
                    
                    self.postHealthClubsArr.insertObject(resultDict, atIndex: 0)
                    
                  //  self.title =  "HEALTH CLUBS"
                }
                
//                dispatch_async(dispatch_get_main_queue()) {
//                    self.collectionView.reloadData()
//                }
                
                let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC)))
                dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                    self.collectionView.reloadData()
                })
                
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                
             //   self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Top, animated: true);
            }
            else
            {
                //SharedClass.sharedInstance.showOkAlertViewController(result!["response_string"] as! String, viewController: self)
                
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
            headerView.setViewTitle(top: "EXPLORE", bottomTitle: "UPDATES")
            return headerView
            
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "FooterAllReUsableView", forIndexPath: indexPath) as! FooterAllReUsableView
            return footerView
            
        default:
            
            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView.init(frame: CGRectMake(0, 0, 0, 0))
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if self.title == "FRIENDS" || self.title == "COLLEAGUES" || self.title == "HEALTH CLUBS"{
        
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
        
        if self.title == "ALL" {
            dict = self.postAllArr[indexPath.row ] as! [String:AnyObject]
        }
        else if self.title == "FRIENDS" {
            dict = self.postFriendsArr[indexPath.row ] as! [String:AnyObject]
        }
        else if self.title == "COLLEAGUES" {
            dict = self.postColleagueArr[indexPath.row ] as! [String:AnyObject]
        }
        else if self.title == "HEALTH CLUBS" {
            dict = self.postHealthClubsArr[indexPath.row ] as! [String:AnyObject]
        }
        
        
        
        let newString = dict["text"]!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let str = newString.stringByReplacingEmojiCheatCodesWithUnicode()
        
        //                    let fontName = AppHelper .userDefaultForAny("fontName") as String
        //                    let fontSize = AppHelper .userDefaultForAny("fontSize") as CGFloat
        let w = collectionView.bounds.size.width - 30
        let size : CGSize =  CommonMethodFunctions.sizeOfCell(str, fontSize: 16 , width: Float(w) , fontName: "Roboto-Regular")
        
        var height = size.height + (150)
        
        if dict["postType"] as! String != "text" {
         /*   if IS_IPHONE_7{
                height = height + (410 - 200)
                
            }else if IS_IPHONE_6plus{
                height = height + (400 - 200)
                
            }else if IS_IPHONE_6{
                height = height + (390 - 200)
                
            }else{
                height = height + (380 - 200)
            }*/
            
            height = height + (380 - 200)
            
        }
        
        return CGSize(width: w, height: height)
        
        
    
    }



    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //let dataArr = self.dataDict["members"] as! [AnyObject]
        
        if self.title == "ALL" {
            return self.postAllArr.count
        }
        else if self.title == "FRIENDS" {
            return self.postFriendsArr.count
        }
        else if self.title == "COLLEAGUES" {
            return self.postColleagueArr.count
        }
        else if self.title == "HEALTH CLUBS" {
            return self.postHealthClubsArr.count
        }
        return 0
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var dict = NSDictionary()
        
        if self.title == "ALL" {
            dict = self.postAllArr[indexPath.row ] as! [String:AnyObject]
        }
        else if self.title == "FRIENDS" {
            dict = self.postFriendsArr[indexPath.row ] as! [String:AnyObject]
        }
        else if self.title == "COLLEAGUES" {
            dict = self.postColleagueArr[indexPath.row ] as! [String:AnyObject]
        }
        else if self.title == "HEALTH CLUBS" {
            dict = self.postHealthClubsArr[indexPath.row ] as! [String:AnyObject]
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
        let lbl_details = cell.viewWithTag(4) as! UILabel
        let lbl_subDetails = cell.viewWithTag(5) as! UILabel
        
        let btn_like = cell.viewWithTag(6) as! UIButton
        let btn_comments = cell.viewWithTag(7) as! UIButton
        let btn_share = cell.viewWithTag(8) as! UIButton

        iv_profile.layer.borderWidth = 1.0
        iv_profile.contentMode = .ScaleAspectFill
        iv_profile.backgroundColor = UIColor.whiteColor()
        iv_profile.layer.masksToBounds = false
        iv_profile.layer.borderColor = UIColor.lightGrayColor().CGColor
        iv_profile.layer.cornerRadius = iv_profile.frame.size.height/2
        iv_profile.clipsToBounds = true
        
        btn_like.setImage(UIImage(named: "like_filled"), forState: .Normal)
        btn_like.setImage(UIImage(named: "like_nav_color"), forState: .Selected)
        
        
        
        
        //shared by name
        if let sharedByFname = (dict as NSDictionary).valueForKeyPath("sharedBy.firstName") as? String {
            
            
            let sharedByLName = (dict as NSDictionary).valueForKeyPath("sharedBy.lastName") as? String
            
            
            let sharedByID = (dict as NSDictionary).valueForKeyPath("sharedBy._id") as? String
            
            let ownerID = (dict as NSDictionary).valueForKeyPath("createdBy._id") as? String
            
            let ownerFName = (dict as NSDictionary).valueForKeyPath("createdBy.firstName") as? String
            let ownerLName = (dict as NSDictionary).valueForKeyPath("createdBy.lastName") as? String
            
            if (sharedByID != ownerID) {
                
                lbl_name.text = sharedByFname + " " + sharedByLName! + " shared " + ownerFName! + " "+ownerLName! + "'s post"
                
            }else{
                lbl_name.text = sharedByFname + " " + sharedByLName! +  " shared post"
            }
            
            
            
        }else{
            //Posted by name
            
            if let fName = (dict as NSDictionary).valueForKeyPath("createdBy.firstName") as? String {
                
                let lName = (dict as NSDictionary).valueForKeyPath("createdBy.lastName") as? String
                
                lbl_name.text = fName + " " + lName! + " shared post"
            }
        }
        
        //height of lbl
        
        
        let text = lbl_name.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let str = text.stringByReplacingEmojiCheatCodesWithUnicode()
        
        let w = collectionView.bounds.size.width - 82
        let size : CGSize =  CommonMethodFunctions.sizeOfCell(str, fontSize: 18 , width: Float(w) , fontName: "Roboto-Regular")
        
        cell.layOut_lbl_Name_height.constant = size.height
        
        
        
        
        //shared by profile image
        if let logoUrlStr = (dict as NSDictionary).valueForKeyPath("sharedBy.imgUrl") as? String    {
            
            let image_url = NSURL(string: logoUrlStr )
            if (image_url != nil) {
                
                let placeholder = UIImage(named: "ic_booking_profilepic")
                iv_profile.sd_setImageWithURL((URL: image_url!), placeholderImage: placeholder)
            }
            
        }else{
             //Posted by profile image
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
            
            
            
            df.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            df.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            let tempDate = df.dateFromString(createdDate) as NSDate!
            
            df.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
            let dateStr = df.stringFromDate(tempDate)
           /* df.dateFormat = "HH:mm:ss.sss"
            df.timeZone = NSTimeZone()
            let timeStr = df.stringFromDate(tempDate)
            
            */
            
            lbl_timeAgo.text = HelpingClass.timeAgoSinceDate(df.dateFromString(dateStr)!, numericDates: false)
           
        }
        
        lbl_details.text =  dict["text"] as? String
        // will display Organisation name
        lbl_subDetails.text = ""
        
        btn_like.selected = false
        
        // if user id is available in likes arr set btn selected
        if let likes = dict["likes"] as? [String]{
            
            for id in likes {
                if ChatHelper.userDefaultForKey(_ID) == id {
                    
                    btn_like.selected = true
                }
            }
            btn_like.setTitle(String((dict["likes"] as? [String])!.count), forState: .Normal)
            
        }
        
        btn_comments.setTitle(String((dict["comments"] as? [AnyObject])!.count), forState: .Normal)
    
        
        if dict["postType"] as! String != "text" {
            
            let thumbIV =  cell.viewWithTag(20) as! UIImageView
            let btn_videoPlay =  cell.viewWithTag(21) as! UIButton
            let indicator = cell.viewWithTag(22) as! UIActivityIndicatorView
            
            
             thumbIV.contentMode = .ScaleAspectFill
            
            let imgUrls = dict["attachments"] as! [String]
            
            
             let thumbNailName = dict["thumNailName"] as! String
               
            //check the thumbNail name is exist ? or generate from video url and save to db
            self.isFileExistsAtPath(directory: "/ChatFile", fileName: thumbNailName, completion: {(isExistPath, fileUrl) -> Void in
                
                if dict["postType"] as! String == "image"{
                    
                    let recognizer = UITapGestureRecognizer(target: self, action:#selector(NewsFeedsAllVC.clickUserImage(_:)))
                    recognizer.delegate = self
                    thumbIV.addGestureRecognizer(recognizer)
                    thumbIV.userInteractionEnabled = true
                    
                    btn_videoPlay.hidden = true
                    indicator.startAnimating()
                    
                    indicator.hidden = false
                    
                    if isExistPath {
                        thumbIV.image = UIImage(contentsOfFile: fileUrl!)
                        indicator.hidden = true
                        indicator.stopAnimating()
                    }else{
                        thumbIV.sd_setImageWithURL(NSURL(string: imgUrls.first!), placeholderImage: UIImage(named:  "cell_blured_heigh")) {
                            (img,  err,  cacheType,  imgUrl) -> Void in
                            
                            thumbIV.image = img
                            indicator.hidden = true
                            indicator.stopAnimating()
                            
                        }
                        
                        
                        
                    }
                    
                    
                }else{
                    //for video
                    
                    btn_videoPlay.hidden = false
                    
                    
                    
                    if isExistPath {
                        thumbIV.image = UIImage(contentsOfFile: fileUrl!)
                    } else {
                        
                        //generate thumb from video url    and display on cell
                        let img = self.generateThumnail(sourceURL: NSURL(string: imgUrls.first!)!)
                        thumbIV.image = img
                        
                        //write to db
                        let imgData = UIImagePNGRepresentation(img) as NSData?
                        
                        self.writeToPath(directory: "/ChatFile", fileName: thumbNailName, dataToWrite: imgData!, completion: {(isWritten:Bool, err:NSError?) -> Void in
                            
                            if isWritten{
                                
                            }
                        })
                    }
                    
                }
                
                
            })
           
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
    
    
    //MARK:-
    
    func generateLocalFilePath(directory directryName:String, fileName:String) -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let documentsDirectory = paths.stringByAppendingPathComponent(directryName)
        let fileManager = NSFileManager.defaultManager()
        do {
            try fileManager.createDirectoryAtPath(documentsDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
        let path = documentsDirectory.stringByAppendingPathComponent(fileName)
        
        return path;
    }
    
    func isFileExistsAtPath(directory directryName:String, fileName:String, completion: (isExistPath: Bool, fileUrl:String?) -> Void){
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let documentsDirectory = paths.stringByAppendingPathComponent(directryName)
        let filePath = documentsDirectory.stringByAppendingPathComponent(fileName as String)
        
        
        if (NSFileManager.defaultManager().fileExistsAtPath(filePath)) {
            completion(isExistPath: true, fileUrl: filePath)
        }else{
            completion(isExistPath: false, fileUrl: nil)
        }
        
        
        
    }
    
    func writeToPath(directory directoryName:String, fileName:String, dataToWrite:NSData, completion:(isWritten:Bool, err:NSError?) -> Void) {
        
        //get the chat path
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let documentsDirectory = paths.stringByAppendingPathComponent(directoryName)
        let fileManager = NSFileManager.defaultManager()
        do {
            try fileManager.createDirectoryAtPath(documentsDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
        
        let saveImagePath = documentsDirectory.stringByAppendingPathComponent(fileName)
        dataToWrite.writeToFile(saveImagePath, atomically: true)
        
        completion(isWritten: true, err: nil)
        
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
        dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateStr = dateFormatter.stringFromDate(date)
        
        return dateStr
        
    }
    
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
    

    
    //MARK:- Collection Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        //   self.handleSingleTapAtIndex(indexPath)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    
    //MARKS: - Service Call
    
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
    
    func fetchPostDataFromServer() {
        
        if AppDelegate.checkInternetConnection() {
            isPostServiceCalled = true
            
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            parameters["section"] = self.title
            
            print("Dict = \(parameters)")
            //call global web service class latest
            Services.postRequest(ServiceGetNewsFeed, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                isPostServiceCalled = false
                
                print("Response = \(responseDict)")
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                  if ((responseDict["error"] as! Int) == 0) {
                    
                    
                    if let resultArr = responseDict["result"]  as? NSArray{
                        
                        if self.title == "ALL" {
                            self.postAllArr = NSMutableArray.init(array: resultArr)
                        }
                        else if self.title == "FRIENDS" {
                            self.postFriendsArr = NSMutableArray.init(array: resultArr)
                        }
                        else if self.title == "COLLEAGUES" {
                            self.postColleagueArr = NSMutableArray.init(array: resultArr)
                        }
                        else if self.title == "HEALTH CLUBS" {
                            self.postHealthClubsArr = NSMutableArray.init(array: resultArr)
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
         self.layoutAttachmetBottom.constant = -200;
        
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
                self.presentViewController(imagePicker, animated: true, completion: nil)
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
                self.presentViewController(imagePicker, animated: true, completion: nil)
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
                    
                    self.showCustomController()
                    
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Send Video", style: UIAlertActionStyle.Default, handler: { (ACTION :UIAlertAction!)in
                UIApplication.sharedApplication().statusBarHidden=true;
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imagePicker.mediaTypes = [String(kUTTypeMovie)]
                imagePicker.delegate = self
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (ACTION :UIAlertAction!)in
                
            }))
            
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
    }
    
    func showCustomController() {
        let pickerController = DKImagePickerController()
        pickerController.pickerDelegate = self
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
         self.globalAssets = assets
      //   self.addCaptionOnPost(assets, cameraImage: nil, videoUrl: nil)
        
        self.handleMultipleImages(assets!, captionText: "")
        
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
        
        
        self.writeToPath(directory: "/ChatFile", fileName: thumbNailName, dataToWrite: thumbData!, completion: {(isWritten:Bool, err:NSError?) -> Void in
            
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
        let thumbImg = CommonMethodFunctions.getThumbNail(videoUrl);
        let thumbData = UIImageJPEGRepresentation(thumbImg, 1.0)
        
        self.writeToPath(directory: "/ChatFile", fileName: thumbNailName, dataToWrite: thumbData!, completion: {(isWritten:Bool, err:NSError?) -> Void in
            
            if isWritten{
                
            }
            
        })
        
        
        //Make low quality and save to DB
        
        let outPutPath = self.generateLocalFilePath(directory: "/ChatFile", fileName: videoName)
        
        CommonMethodFunctions.convertVideoToLowQuailtyWithInputURL(videoUrl, outputURL: NSURL.fileURLWithPath(outPutPath), handler: { (exportSession : AVAssetExportSession!) -> Void in
            switch(exportSession.status)
            {
            case .Completed:
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let compressedVideoData =  NSData(contentsOfURL: NSURL.fileURLWithPath(outPutPath))
                    
                    self.writeToPath(directory: "/ChatFile", fileName: videoName, dataToWrite: compressedVideoData!, completion: {(isWritten:Bool, err:NSError?) -> Void in
                        
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
    
    
    //MARK:-
    
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
        
        for (_, asset) in assets!.enumerate() {
            
            
            let locId = CommonMethodFunctions.nextIdentifies()
            let strId = String(locId)
            
            let timeStamp = generateTimeStamp()
            
            let tempImage = UIImageView(image: asset.fullScreenImage)
            //     let thumbImg = UIImageView(image: asset.thumbnailImage)
            
            let imgData = UIImageJPEGRepresentation(tempImage.image!, 0.8)
            
            //    let thumbImg = CommonMethodFunctions.generatePhotoThumbnail(uploadImage);
            //   let thumbData = UIImageJPEGRepresentation(thumbImg, 0.0)
            let thumbNailName = "Thumb" + timeStamp + ".jpg"
            
            
            self.writeToPath(directory: "/ChatFile", fileName: thumbNailName, dataToWrite: imgData!, completion: {(isWritten:Bool, err:NSError?) -> Void in
                
                if isWritten{
                    
                }
                
            })
           
            var dict = Dictionary<String, AnyObject>()
            
        
            dict["message"] = ""
            dict["type"] = "image"
       //     dict["localThumbPath"] = saveThumbImagePath
       //     dict["localFullPath"] = saveFullImagePath
            dict["mediaUrl"] = ""
            dict["mediaThumbUrl"] = ""
            dict["localmsgid"] = strId
        //    dict["mediaThumb"] = base64String
            
            NSOperationQueue.mainQueue().addOperationWithBlock() { () in
                
                AppDelegate.showProgressHUDWithStatus("Please wait..")
                
                let name = self.uniqueName("")                
                
                UploadInS3.sharedGlobal().uploadMultipleImagesOnChatTos3(imgData, type: 0, dictInfo: dict, fromDist: "chat", meldID: name, completion: { ( bool_val : Bool, pathUrl : String!) -> Void in
                    
                    AppDelegate.dismissProgressHUD()
                    
                    if bool_val == true{
                        self.sendPostToServer("image", isShared: false, createdDict: nil, imgOrVideoUlr: pathUrl , captionText: captionText, thumNailName:thumbNailName)
                     
                    }
                    
                    
                    } , completionProgress: { ( bool_val : Bool, progress) -> Void in
                       
                })
            }
        }
        
      //  self.dismissViewControllerAnimated(true, completion: nil)
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
    
}
