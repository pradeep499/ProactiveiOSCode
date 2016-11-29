//
//  NewsFeedsAllVC.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 22/09/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit
import Social

class NewsFeedsAllVC: UIViewController, UIGestureRecognizerDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var view_share: UIView!
    @IBOutlet weak var view_post: UIView!
    
    @IBOutlet weak var tf_share: CustomTextField!
    
    
    @IBOutlet weak var layOutConstrain_view_Post_bottom: NSLayoutConstraint!
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
    }
    
    
    func hideSocialSharingView() -> Void {
        
        self.view_share.hidden = true
        self.collectionView.removeGestureRecognizer(tapGesture)
    }
    
    //MARK: - onClickLikeBtn
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
    
    //MARK: - onClickComments
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
    
    //MARK: - onClickShareBtn
    @IBAction func onClickShareBtn(sender: AnyObject) {
        
    }
    
    //MARK: - onClickFBBtn
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
    
    
    //MARK: - onClickTwiterBtn
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
    
    
    //MARK: - onClickSnapChatBtn
    @IBAction func onClickSnapChatBtn(sender: AnyObject) {
        
        UIView.animateWithDuration(0.3, animations: {
            self.view_share.alpha = 0
            self.view_share.hidden = true
        })
    }
    
    //MARK: - onClickPhotoBtn
    @IBAction func onClickPhotoBtn(sender: AnyObject) {
        
        UIView.animateWithDuration(0.3, animations: {
            self.view_share.alpha = 0
            self.view_share.hidden = true
        })
        
    }
    
    //MARK: - onClickPlusBtn
    @IBAction func onClickPlusBtn(sender: AnyObject) {
        
        self.collectionView.removeGestureRecognizer(tapGesture)
        self.collectionView.addGestureRecognizer(tapGesture)
        
        self.view_share.alpha = 0
    //    UIApplication.sharedApplication().keyWindow?.bringSubviewToFront(self.view_share)
        self.view_share.layer.zPosition = 1;
    //    self.view_share.superview!.bringSubviewToFront(self.view_share)
        
        UIView.animateWithDuration(0.3, animations: {
            self.view_share.alpha = 1.0
            self.view_share.hidden = false
        })
        
    }
    
    //MARK: - onClickPostBtn
    @IBAction func onClickPostBtn(sender: AnyObject) {
        
        self.sendPostToServer()
        
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
    func sendPostToServer() {
        if self.tf_share.text?.characters.count < 1 {
            AppHelper.showAlertWithTitle(AppName, message: "Post text can't be blank.", tag: 0, delegate: nil, cancelButton: "OK", otherButton: nil)
            return
        }
        
        if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {
            
            var dict = Dictionary<String,AnyObject>()
            if(self.title == "MEET UPS") {
                dict["type"]="post"
            }
            else {
                dict["type"]="post"
            }
            dict["userId"] = ChatHelper.userDefaultForKey(_ID)
            
            dict["text"] = self.tf_share.text
            
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
        
        if let name = (dict as NSDictionary).valueForKeyPath("postedBy.firstName") as? String {
            
            lbl_name.text = name + " Shared a Post"
        }
        
        if let logoUrlStr = (dict as NSDictionary).valueForKeyPath("postedBy.imgUrl") as? String    {
            
            let image_url = NSURL(string: logoUrlStr )
            if (image_url != nil) {
                
                let placeholder = UIImage(named: "ic_booking_profilepic")
                iv_profile.sd_setImageWithURL((URL: image_url!), placeholderImage: placeholder)
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
