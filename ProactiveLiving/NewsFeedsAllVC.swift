//
//  NewsFeedsAllVC.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 22/09/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit
import Social

class NewsFeedsAllVC: UIViewController, UIGestureRecognizerDelegate, UICollectionViewDataSource, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,  UIActionSheetDelegate, DKImagePickerControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
     tapGesture = UITapGestureRecognizer(target: self, action: "hideSocialSharingView")
     
        
        self.view_share.hidden = true
        
        self.view_post.layer.borderWidth = 1.0
        self.view_post.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        
       
        if self.title == "ALL" || self.title == "FRIENDS" || self.title == "COLLEAGUES" || self.title == "HEALTH CLUBS"{
            
            self.collectionView.registerClass(HeaderScrollerView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderScrollerView")
            
            
            
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        
        
        
        
       
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
        
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
                
                
                self.sendPostToServer(true, createdDict: resultData)
                
            
            }
            })
        
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
        
        self.attachmentViewS.backgroundColor=UIColor.redColor()
        
        self.layoutAttachmetBottom.constant = 200;
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
        
        self.sendPostToServer(false, createdDict: nil)
        
        self.tf_share.text = ""
        self.tf_share.resignFirstResponder()
        
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
    
    //mark- Fetch Meetups/Invites listing data
    func sendPostToServer(isShared:Bool, createdDict:NSDictionary?) {
        
        
        
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
            
            if isShared{
                
                dict["createdBy"] = (createdDict! as NSDictionary).valueForKeyPath("createdBy._id") as? String
                
                dict["sharedBy"] =  ChatHelper.userDefaultForKey(_ID)
                dict["text"] = createdDict!["text"] as? String
                
                
            }else{
                
                if self.tf_share.text?.characters.count < 1 {
                    AppHelper.showAlertWithTitle(AppName, message: "Post text can't be blank.", tag: 0, delegate: nil, cancelButton: "OK", otherButton: nil)
                    return
                }
                
                dict["text"] = self.tf_share.text
                dict["createdBy"] = ChatHelper.userDefaultForKey(_ID)
            }
            
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
                }
                else if resultDict["section"] as! String  == "friends" {
                    
                   self.postFriendsArr.insertObject(resultDict, atIndex: 0)
                    
                }
                    
                else if resultDict["section"] as! String  == "colleagues" {
                    
                    self.postColleagueArr.insertObject(resultDict, atIndex: 0)
                }
                else if resultDict["section"] as! String  == "health clubs" {
                    
                    self.postHealthClubsArr.insertObject(resultDict, atIndex: 0)
                }
                
                self.collectionView.reloadData()
                
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                
                self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Top, animated: true);
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
                
                
                
                var predicate = NSPredicate(format: "(%K == %@)", "_id", resultDict["_id"] as! String)
                if resultDict["section"] as! String == "all" {
                    
                    
                    
                    var filteredarray:[AnyObject] = self.postAllArr.filteredArrayUsingPredicate(predicate)
                    print("ID = \(resultDict["_id"])")
                    
                    if filteredarray.count > 0 {
                        var index = self.postAllArr.indexOfObject( filteredarray[0])
                        self.postAllArr.replaceObjectAtIndex(index, withObject: resultDict)
                    }

                    
                }
                else if resultDict["section"] as! String  == "friends" {
                    var filteredarray:[AnyObject] = self.postFriendsArr.filteredArrayUsingPredicate(predicate)
                    print("ID =  \(resultDict["_id"])")
                    
                    if filteredarray.count > 0 {
                        
                        var index = self.postFriendsArr.indexOfObject( filteredarray[0])
                        self.postFriendsArr.replaceObjectAtIndex(index, withObject: resultDict)
                    }

                    
                }
                    
                else if resultDict["section"] as! String  == "colleagues" {
                    
                    var filteredarray:[AnyObject] = self.postColleagueArr.filteredArrayUsingPredicate(predicate)
                    print("ID =  \(resultDict["_id"])")
                    
                    if filteredarray.count > 0 {
                        var index = self.postColleagueArr.indexOfObject( filteredarray[0])
                        self.postColleagueArr.replaceObjectAtIndex(index, withObject: resultDict)
                    }

                }
                else if resultDict["section"] as! String  == "health clubs" {
                    
                    var filteredarray:[AnyObject] = self.postHealthClubsArr.filteredArrayUsingPredicate(predicate)
                    print("ID =  \(resultDict["_id"])")
                    
                    if filteredarray.count > 0 {
                        var index = self.postHealthClubsArr.indexOfObject( filteredarray[0])
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
        
        let height = size.height + 150
        let width = size.width
        
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
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellAll", forIndexPath: indexPath) as UICollectionViewCell
        
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
        
        //shared by name
        if let name = (dict as NSDictionary).valueForKeyPath("sharedBy.firstName") as? String {
            let ownerID = (dict as NSDictionary).valueForKeyPath("createdBy._id") as? String
            let ownerName = (dict as NSDictionary).valueForKeyPath("createdBy.firstName") as? String
            if ownerID != ChatHelper.userDefaultForKey(_ID){
                
                lbl_name.text = name + " Shared a " + ownerName! + "'s Post"
                
            }else{
                lbl_name.text = name + " Shared a Post"
            }
            
            
            
        }else{
            //Posted by name
            
            if let name = (dict as NSDictionary).valueForKeyPath("createdBy.firstName") as? String {
                
                lbl_name.text = name + " Shared a Post"
            }
        }
        
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
                    
                    
                        
                        guard let resultArr = responseDict["result"]  as? NSMutableArray   else
                        {
                            return
                        }
                    
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidSelectedAssets(assets: [DKAsset]!)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
        delay(0.1,
              closure: {
                UIApplication.sharedApplication().statusBarHidden = false;
                UIApplication.sharedApplication().statusBarStyle = .LightContent
        })
        
        
        
        for (index, asset) in assets.enumerate() {
            
            
                let locId = CommonMethodFunctions.nextIdentifies()
                let strId = String(locId)
                var date = NSDate()
                var dateStr : String
                var timeStr : String
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                dateStr = dateFormatter.stringFromDate(date)
                dateFormatter.dateFormat = "HH:mm:ss.sss"
                timeStr = dateFormatter.stringFromDate(date)
                
                let tempImage = UIImageView(image: asset.fullScreenImage)
                let thumbImg = UIImageView(image: asset.thumbnailImage)
                let thumbImg1 = UIImageView(image: asset.thumbnailImage)
                
                let data1 = UIImageJPEGRepresentation(thumbImg.image!, 0.0)
                let base64String = data1!.base64EncodedStringWithOptions([])
                
                let data2 = UIImageJPEGRepresentation(thumbImg1.image!, 1.0)
                let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
                let documentsDirectory = paths.stringByAppendingPathComponent("/ChatFile")
                let fileManager = NSFileManager.defaultManager()
                
                do {
                    try fileManager.createDirectoryAtPath(documentsDirectory, withIntermediateDirectories: true, attributes: nil)
                } catch let error as NSError {
                    NSLog("Unable to create directory \(error.debugDescription)")
                }
                
                let indexes = String(index)
                
                let saveThumbImagePath = "Thumb"+dateStr+indexes+".jpg"
                
                var saveImagePath = documentsDirectory.stringByAppendingPathComponent("Thumb"+dateStr+indexes+".jpg")
                data2!.writeToFile(saveImagePath, atomically: true)
                
                let data = UIImageJPEGRepresentation(tempImage.image!, 0.8)
                let saveFullImagePath = "full"+dateStr+indexes+".jpg"
                saveImagePath = documentsDirectory.stringByAppendingPathComponent("full"+dateStr+indexes+".jpg")
                data!.writeToFile(saveImagePath, atomically: true)
                
                var dict = Dictionary<String, AnyObject>()
                
                dict["date"] = dateStr
                dict["sortDate"] = dateStr
                dict["time"] = timeStr
                dict["message"] = ""
                dict["type"] = "image"
                dict["localThumbPath"] = saveThumbImagePath
                dict["localFullPath"] = saveFullImagePath
                dict["mediaUrl"] = ""
                dict["mediaThumbUrl"] = ""
                dict["localmsgid"] = strId
                dict["mediaThumb"] = base64String
                
            
           /*
                dict["sender"] = ChatHelper .userDefaultForAny("userId") as! NSString
                if contObj != nil
                {
                    dict["receiver"] = contObj.userId
                }else
                {
                    dict["receiver"] = recentChatObj.friendId
                }
                
                let instance = DataBaseController.sharedInstance
                
            
                dict["index"] = chatArray.count-1
            
                arrayImageIndex += [NSIndexPath(forRow:dict["index"] as! Int,inSection:0)]
                */
                var path = [NSIndexPath]()
                path.append(NSIndexPath(forRow:dict["index"] as! Int,inSection:0))
                
                
            
                
                NSOperationQueue.mainQueue().addOperationWithBlock() { () in
                    
                    let name = self.uniqueName("")
                    let pathSelected = NSIndexPath(forRow:dict["index"] as! Int,inSection:0)
                    
                    UploadInS3.sharedGlobal().uploadMultipleImagesOnChatTos3(data, type: 0, dictInfo: dict, fromDist: "chat", meldID: name, completion: { ( bool_val : Bool, pathUrl : String!) -> Void in
                        
                        
                        if bool_val == true
                            
                        {
                            //  var fileName : NSString
                            
                            //print((UploadInS3.sharedGlobal().chatImagesFiles as NSMutableArray))
                            
                            //for( var index:Int = 0 ; index < (UploadInS3.sharedGlobal().chatImagesFiles as NSMutableArray).count; index += 1  )
                            for  index in  0 ..< (UploadInS3.sharedGlobal().chatImagesFiles as NSMutableArray).count {
                                // print("Upload image 1 === \(UploadInS3.sharedGlobal().chatImagesFiles)")
                                
                                if let citiesArr = UploadInS3.sharedGlobal().chatImagesFiles{
                                    
                                    //print("Upload image 2 === \(citiesArr)")
                                    
                                    var fileName = Dictionary<String, AnyObject>()
                                    
                                    //  fileName = citiesArr[index] as Dictionary
                                    if let _:Dictionary<String, AnyObject> = citiesArr[index] as? Dictionary
                                    {
                                        fileName = citiesArr[index] as! Dictionary
                                        let strFileName : String = fileName["chatImagesName"] as! String
                                        let nsDict = fileName["chatImgDicInfo"] as! NSDictionary
                                        
                                        self.sendImageFilePathToChatServer(nsDict, filePath: pathUrl, index:-1)
                                    }
                                    else
                                    {
                                        //  fileName = citiesArr[index] as Dictionary
                                    }
                                    
                                    
                                    // print("Upload image 3  ===  \(citiesArr[index])")
                                    
                                    
                                    
                                    
                                }
                            }
                            
                            
                            
                            
                            (UploadInS3.sharedGlobal().chatImagesFiles as NSMutableArray) .removeAllObjects()
                            
                            
                            
                        }
                        
                        
                        
                        } , completionProgress: { ( bool_val : Bool, progress) -> Void in
                            
                         /*
                            
                            let visibleCell : NSArray = self.chatTableView.indexPathsForVisibleRows!
                            if(visibleCell.containsObject(pathSelected))
                            {
                                if     let cell:ChatImageCell = self.chatTableView.cellForRowAtIndexPath(pathSelected)! as? ChatImageCell
                                {
                                    let progressV = cell.contentView.viewWithTag(22) as! PICircularProgressView
                                    progressV.hidden = false
                                    progressV.progress=progress
                                    
                                    if(progress == 1.0)
                                    {
                                        progressV.hidden = true
                                        
                                    }
                                }
                            }*/
                        })
                    
                }
                
            
                
            
            
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    //MARK:- Image Picker Delegates
    func imagePickerControllerDidCancel(picker:UIImagePickerController)
    {
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
        delay(0.1,
              closure: {
                UIApplication.sharedApplication().statusBarHidden = false;
                UIApplication.sharedApplication().statusBarStyle = .LightContent
        })
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)
        delay(0.1,
              closure: {
                UIApplication.sharedApplication().statusBarHidden = false;
                UIApplication.sharedApplication().statusBarStyle = .LightContent
        })
        
        //UIImagePickerControllerEditedImage
        
        if(info["UIImagePickerControllerMediaType"] as! String == "public.image") {
            
            if ServiceClass.checkNetworkReachabilityWithoutAlert() {
                let locId = CommonMethodFunctions.nextIdentifies()
                let strId = String(locId)
                
                var date = NSDate()
                var dateStr : String
                var timeStr : String
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                dateStr = dateFormatter.stringFromDate(date)
                dateFormatter.dateFormat = "HH:mm:ss.sss"
                timeStr = dateFormatter.stringFromDate(date)
                
                let tempImage = info[UIImagePickerControllerOriginalImage] as! UIImage
                let thumbImg = CommonMethodFunctions.generatePhotoThumbnail(tempImage);
                let thumbImg1 = CommonMethodFunctions.generatePhotoThumbnail1(tempImage);
                
                let thumbData = UIImageJPEGRepresentation(thumbImg, 0.0)
                let base64String = thumbData!.base64EncodedStringWithOptions([])
                
                let data2 = UIImageJPEGRepresentation(thumbImg1, 1.0)
                let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
                let documentsDirectory = paths.stringByAppendingPathComponent("/ChatFile")
                let fileManager = NSFileManager.defaultManager()
                do {
                    try fileManager.createDirectoryAtPath(documentsDirectory, withIntermediateDirectories: true, attributes: nil)
                } catch let error as NSError {
                    NSLog("Unable to create directory \(error.debugDescription)")
                }
                let saveThumbImagePath = "Thumb"+dateStr+".jpg"
                var saveImagePath = documentsDirectory.stringByAppendingPathComponent("Thumb"+dateStr+".jpg")
                data2!.writeToFile(saveImagePath, atomically: true)
                
                let imgData = UIImageJPEGRepresentation(tempImage, 0.8)
                let saveFullImagePath = "full"+dateStr+".jpg"
                saveImagePath = documentsDirectory.stringByAppendingPathComponent("full"+dateStr+".jpg")
                imgData!.writeToFile(saveImagePath, atomically: true)
                var dict = Dictionary<String, AnyObject>()
                dict["date"] = dateStr
                dict["sortDate"] = dateStr
                dict["time"] = timeStr
                dict["message"] = ""
                dict["type"] = "image"
                dict["localThumbPath"] = saveThumbImagePath
                dict["localFullPath"] = saveFullImagePath
                dict["mediaUrl"] = ""
                dict["mediaThumbUrl"] = ""
                dict["localmsgid"] = strId
                dict["mediaThumb"] = base64String
            /*
                dict["sender"] = ChatHelper .userDefaultForAny("userId") as! String
                if contObj != nil
                {
                    dict["receiver"] = contObj.userId
                }else
                {
                    dict["receiver"] = recentChatObj.friendId
                }
                
                let instance = DataBaseController.sharedInstance
                
                
                
                
                NSOperationQueue.mainQueue().addOperationWithBlock() { () in
                    
                    let name = self.uniqueName("")
                    UploadInS3.sharedGlobal().uploadImageTos3( thumbData, type: 0, fromDist: "chat", meldID: name, completion: { ( bool_val : Bool, pathUrl : String!) -> Void in
                        
                        if bool_val == true
                        {
                            let fileName =  UploadInS3.sharedGlobal().strFilesName
                            
                            if fileName != nil{
                                self.sendImageFilePathToChatServer(dict, filePath: fileName, index:-1)
                            }
                        }
                        else
                        {
                            
                            //
                            
                            
                            if self.isGroup == "0"
                            {
                                //NSIndexPath(forRow:dict["index"] as Int,inSection:0)
                                instance.multimediaChatStatusChangeSingleChat(self.chatArray.objectAtIndex(dict["index"] as! Int) as! UserChat)
                                
                            }
                            else
                            {
                                
                                instance.multimediaChatStatusChangeGroupChat(self.chatArray.objectAtIndex(dict["index"] as! Int) as! GroupChat)
                                
                            }
                            
                            self.chatTableView.beginUpdates()
                            self.chatTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow:dict["index"] as! Int,inSection:0)], withRowAnimation: UITableViewRowAnimation.None)
                            self.chatTableView.endUpdates()
                        }
                        
                        }
                        , completionProgress: { ( bool_val : Bool, progress) -> Void in
                            
                            
                            
                            let newIndexPath:NSIndexPath = NSIndexPath(forRow:dict["index"] as! Int,inSection:0)
                            
                            let visibleCell : NSArray = self.chatTableView.indexPathsForVisibleRows!
                            
                            if(visibleCell.containsObject(newIndexPath))
                            {
                                if     let cell:ChatImageCell = self.chatTableView.cellForRowAtIndexPath(newIndexPath)! as? ChatImageCell
                                {
                                    let progressV = cell.contentView.viewWithTag(22) as! PICircularProgressView
                                    progressV.hidden = false
                                    progressV.progress=progress
                                    
                                    if(progress == 1.0)
                                    {
                                        progressV.hidden = true
                                        
                                    }
                                }
                            }
                        }
                    )
                    
                    
                    // (void)uploadImageTos3:(NSData *)imageToUpload type:(int)imageOrVideo fromDist:(NSString*)classType meldID:(NSString*)meldFileName completion:(s3Handler)completionBlock{
                }*/
                
                // self.sendImageToServer(dict, imageData: data, index: chatArray.count-1)
            }
        }else if(info["UIImagePickerControllerMediaType"] as! String == "public.movie")
        {
            if ServiceClass.checkNetworkReachabilityWithoutAlert()
            {
                let locId = CommonMethodFunctions.nextIdentifies()
                let strId = String(locId)
                
                var date = NSDate()
                var dateStr : String
                var timeStr : String
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                dateStr = dateFormatter.stringFromDate(date)
                dateFormatter.dateFormat = "HH:mm:ss.sss"
                timeStr = dateFormatter.stringFromDate(date)
                
                let tempUrl = info[UIImagePickerControllerMediaURL] as! NSURL
                
                let videoName = "Video"+dateStr+".mp4"
                
                let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
                let documentsDirectory = paths.stringByAppendingPathComponent("/ChatFile")
                let fileManager = NSFileManager.defaultManager()
                do {
                    try fileManager.createDirectoryAtPath(documentsDirectory, withIntermediateDirectories: true, attributes: nil)
                } catch let error as NSError {
                    NSLog("Unable to create directory \(error.debugDescription)")
                }
                let saveVideoPath = documentsDirectory.stringByAppendingPathComponent(videoName)
                let thumbImg = CommonMethodFunctions.getThumbNail(tempUrl);
                var data = UIImageJPEGRepresentation(thumbImg, 1.0)
                let saveThumbImagePath = "Thumb"+dateStr+".jpg"
                let saveImagePath = documentsDirectory.stringByAppendingPathComponent(saveThumbImagePath)
                
                // print("saveImagePath = \(saveImagePath)")
                data!.writeToFile(saveImagePath, atomically: true)
                
                let thumbImg1 = CommonMethodFunctions.generatePhotoThumbnail(thumbImg);
                let data1 = UIImageJPEGRepresentation(thumbImg1, 0.0)
                let base64String = data1!.base64EncodedStringWithOptions([])
                var dict = Dictionary<String, AnyObject>()
                dict["date"] = dateStr
                dict["sortDate"] = dateStr
                dict["time"] = timeStr
                dict["message"] = ""
                dict["type"] = "video"
                dict["localThumbPath"] = saveThumbImagePath
                dict["localFullPath"] = videoName
                dict["mediaUrl"] = ""
                dict["mediaThumbUrl"] = ""
                dict["localmsgid"] = strId
                dict["mediaThumb"] = base64String
                
         /*       dict["sender"] = ChatHelper .userDefaultForAny("userId") as! String
                if contObj != nil
                {
                    dict["receiver"] = contObj.userId
                }else
                {
                    dict["receiver"] = recentChatObj.friendId
                }
                
                let instance = DataBaseController.sharedInstance
                if isGroup == "0"
                {
                    self.checkDateIsDifferent(dict)
                    date = NSDate()
                    dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
                    dateStr = dateFormatter.stringFromDate(date)
                    dict["date"] = dateStr
                    
                    let chatObj =  instance.insertChatMessageInDb1("UserChat", params: dict) as UserChat
                    let fileObj =  instance.insertChatFileInDb1("UserChatFile", params: dict) as UserChatFile
                    
                    chatArray.addObject(chatObj)
                    // arrayofMessage += [chatObj]
                    chatObj.chatFile = fileObj
                    
                    if self.recentChatObj == nil || chatArray.count == 2
                    {
                        self.saveRecentChat()
                    }
                }else
                {
                    self.checkDateIsDifferent(dict)
                    date = NSDate()
                    dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
                    dateStr = dateFormatter.stringFromDate(date)
                    dict["date"] = dateStr
                    
                    dict["groupid"] = self.recentChatObj.groupId
                    dict["sendername"] = ""
                    let chatObj =  instance.insertGroupChatMessageInDb1("GroupChat", params: dict) as GroupChat
                    let fileObj =  instance.insertGroupChatFileInDb1("GroupChatFile", params: dict) as GroupChatFile
                    chatArray.addObject(chatObj)
                    
                    chatObj.groupChatFile = fileObj
                }
                
                homeCoreData.saveContext()
                growingTextView.text=""
                dict["index"] = self.chatArray.count-1
                
                var path = [NSIndexPath]()
                path.append(NSIndexPath(forRow:dict["index"] as! Int,inSection:0))
                chatTableView.insertRowsAtIndexPaths(path, withRowAnimation: UITableViewRowAnimation.None)
                if chatArray.count > 2
                {
                    chatTableView.scrollToRowAtIndexPath(NSIndexPath(forRow:dict["index"] as! Int,inSection:0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
                }
          */      // New pic by PK
                
         /*       //    print("sent frow ====\(myRow)")
                
                CommonMethodFunctions.convertVideoToLowQuailtyWithInputURL(tempUrl, outputURL: NSURL.fileURLWithPath(saveVideoPath), handler: { (exportSession : AVAssetExportSession!) -> Void in
                    switch(exportSession.status)
                    {
                    case .Completed:
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            
                            
                            // print("saveVideoPath = \(saveVideoPath)")
                            data =  NSData(contentsOfURL: NSURL.fileURLWithPath(saveVideoPath))
                            
                            var imageSize   = data!.length as Int
                            imageSize = imageSize/1024
                            
                            
                            
                            // print_debug(imageSize)
                            
                            data!.writeToFile(saveVideoPath, atomically: false)
                            
                            
                            
                            // bellow code is commented by pk on 2 dec 2015
                            
                            // self.sendVideoToServer(dict, videoData: data, index: self.chatArray.count-1)
                            
                            // bellow code is WRITTEN by pk on 2 dec 2015
                            NSOperationQueue.mainQueue().addOperationWithBlock() { () in
                                
                                let name = self.uniqueName("")
                                UploadInS3.sharedGlobal().uploadImageTos3( data, type: 1, fromDist: "chat", meldID: name, completion: { ( bool_val : Bool, pathUrl : String!) -> Void in
                                    if bool_val == true
                                    {
                                        let fileName =  UploadInS3.sharedGlobal().strFilesName
                                        //  progressV.hidden = true
                                        if fileName != nil{
                                            self.sendVideoFilePathToChatServer(dict, filePath: fileName, index:-1)
                                        }
                                    }
                                    else
                                    {
                                        
                                        if self.isGroup == "0"
                                        {
                                            
                                            instance.multimediaChatStatusChangeSingleChat(self.chatArray.objectAtIndex(dict["index"] as! Int) as! UserChat)
                                            
                                        }
                                            
                                        else
                                        {
                                            
                                            instance.multimediaChatStatusChangeGroupChat(self.chatArray.objectAtIndex(dict["index"] as! Int) as! GroupChat)
                                            
                                        }
                                        
                                        
                                        self.chatTableView.beginUpdates()
                                        self.chatTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow:dict["index"] as! Int,inSection:0)], withRowAnimation: UITableViewRowAnimation.None)
                                        self.chatTableView.endUpdates()
                                        
                                    }
                                    
                                    }
                                    , completionProgress: { ( bool_val : Bool, progress) -> Void in
                                        
                                        
                                        
                                        let newIndexPath:NSIndexPath = NSIndexPath(forRow:dict["index"] as! Int,inSection:0)
                                        
                                        let visibleCell : NSArray = self.chatTableView.indexPathsForVisibleRows!
                                        
                                        if(visibleCell.containsObject(newIndexPath))
                                        {
                                            if     let cell:ChatImageCell = self.chatTableView.cellForRowAtIndexPath(newIndexPath)! as? ChatImageCell
                                            {
                                                let progressV = cell.contentView.viewWithTag(22) as! PICircularProgressView
                                                
                                                progressV.hidden = false
                                                progressV.progress=progress
                                                
                                                if(progress == 1.0)
                                                {
                                                    progressV.hidden = true
                                                    
                                                }
                                            }
                                        }
                                    }
                                    
                                )
                                
                            }
                        });
                        break
                    default:
                        break
                    }
                    
                })  */
                
                
                
            }
        }
    }
    
    
    //MARK:- 
    
    func sendImageFilePathToChatServer(dic : NSDictionary, filePath: String!, index: Int) -> Void
    {
        // print("sendImageFilePathToChatServer ====== sendMsgD to server====0")
       
    /*    var newIndexPath:NSIndexPath = NSIndexPath(forRow:index,inSection:0)
        if index == -1
        {
            newIndexPath = NSIndexPath(forRow:dic["index"] as! Int,inSection:0)
        }
        
        let visibleCell : NSArray = chatTableView.indexPathsForVisibleRows!
        let str : String = dic["localmsgid"] as! String
        
        if(visibleCell.containsObject(newIndexPath))
        {
            
            // let newIndexPath:NSIndexPath = NSIndexPath(forRow:index,inSection:0)
            let cell:UITableViewCell = chatTableView.cellForRowAtIndexPath(newIndexPath)!
            let progressV = cell.contentView.viewWithTag(22) as! PICircularProgressView
            progressV.hidden = false
            
            // let str : String = dic["localmsgid"] as String!
            ChatListner .getChatListnerObj().chatProgressV[str] = progressV
            
            // New below code open by prabodh 14 dec 2015
            
            ChatListner .getChatListnerObj().chatProgressV.removeObjectForKey(str)
            
            // New above code open by prabodh 14 dec 2015
        }
        */
        
        
        
        var sendMsgD = Dictionary<String, AnyObject>()
        
        sendMsgD["userid"] = ChatHelper .userDefaultForAny("userId") as! String
        sendMsgD["message"] = "image"
        sendMsgD["localmsgid"] = dic["localmsgid"]
        sendMsgD["type"] = "image"
        sendMsgD["mediaThumb"] = dic["mediaThumb"]
    /*
        if isGroup == "0"
        {
            sendMsgD["chatType"] = "oneToOne"
            
            if (AppHelper.userDefaultsForKey("user_firstName")) != nil
            {
                sendMsgD["user_firstName"] = AppHelper.userDefaultsForKey("user_firstName") as! String
            }
            if (AppHelper.userDefaultsForKey("user_imageUrl")) != nil
            {
                sendMsgD["profile_image"] = AppHelper.userDefaultsForKey("user_imageUrl") as! String
            }
            
            
            
            // sendMsgD["user_firstName"] = ChatHelper.userDefaultForKey("user_firstName") as NSString // NEW LINE ADDED BY ME 18 OCT
            // sendMsgD["profile_image"] = ChatHelper.userDefaultForKey("user_imageUrl") as NSString // NEW LINE ADDED BY ME 18 OCT
            
            sendMsgD["phoneNumber"] = ChatHelper.userDefaultForKey("PhoneNumber") as String
            sendMsgD["recieverid"] = dic["receiver"]
        }else
        {
            sendMsgD["user_firstName"] = ChatHelper .userDefaultForAny("user_firstName") as! String // NEW LINE ADDED BY ME 8 dec
            sendMsgD["profile_image"] = ChatHelper .userDefaultForAny("user_imageUrl") as! String // NEW LINE ADDED BY ME  8 dec
            
            sendMsgD["chatType"] = "groupChat"
            sendMsgD["groupid"] = recentChatObj.groupId
            
            
            sendMsgD["chatType"] = "groupChat"
            sendMsgD["groupid"] = recentChatObj.groupId
        }
        */
        sendMsgD["mediaUrl"] = filePath
        
        ChatListner .getChatListnerObj().socket.emit("sendMessage", sendMsgD)
        
     
        
        
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
