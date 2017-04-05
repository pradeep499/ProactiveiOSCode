//
//  CommentsVC.swift
//  ProactiveLiving
//
//  Created by Affle on 21/11/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit
import MediaPlayer

class CommentsVC: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var view_tableHeader: UIView!
    @IBOutlet weak var iv_CommentsProfile: UIImageView!
    @IBOutlet weak var lbl_CommentsTitle: UILabel!
    @IBOutlet weak var lbl_timeAgo: UILabel!
    @IBOutlet weak var lbl_commentsText: UILabel!
    @IBOutlet weak var lbl_organizationName: UILabel!
    @IBOutlet weak var tv_writeComment: UITextView!
    @IBOutlet weak var imgAttachment: UIImageView!
    @IBOutlet weak var btnPlayVideo: UIButton!
    @IBOutlet weak var playActivityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var table_view: UITableView!
    
    
    @IBOutlet weak var layOutConstrain_view_writeComments_bottom: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraint_lblCPost: NSLayoutConstraint!

    
    var commentsArr = [AnyObject]()
    var selectedCommentDict = [String:AnyObject]()
    var tapGesture = UITapGestureRecognizer()
    var moviePlayerController = MPMoviePlayerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentsVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentsVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)

        self.setUpHeader()
        self.getPostUpdate()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(CommentsVC.returnKeyBoard))
        
        //hide separotor while cell empty
        self.table_view.tableFooterView = UIView.init()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        
        //dynamic Header view height
        let newString = self.selectedCommentDict["text"]!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let str = newString.stringByReplacingEmojiCheatCodesWithUnicode()
        
        //                    let fontName = AppHelper .userDefaultForAny("fontName") as String
        //                    let fontSize = AppHelper .userDefaultForAny("fontSize") as CGFloat
        let w = self.table_view.bounds.size.width - 30
        let size : CGSize = CommonMethodFunctions.sizeOfCell(str, fontSize: 16 , width: Float(w) , fontName: "Roboto-Regular")
        
        let height:CGFloat
        
        if self.selectedCommentDict["postType"] as! String == "text" {
            height = size.height + 150
            layoutConstraint_lblCPost.constant = 8
        }
        else {
            height = size.height + 320
            layoutConstraint_lblCPost.constant = 200
        }
            var fm = self.view_tableHeader.frame
            fm.size.height = height
            self.view_tableHeader.frame = fm
            self.table_view.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Keyborad
    
    func returnKeyBoard() -> Void {
        self.tv_writeComment.resignFirstResponder()
        
        
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height {
                
                self.table_view.addGestureRecognizer(tapGesture)
                layOutConstrain_view_writeComments_bottom.constant = keyboardHeight - 40
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height {
                
                self.table_view.removeGestureRecognizer(tapGesture)
                layOutConstrain_view_writeComments_bottom.constant = 0
                UIView.animateWithDuration(0.25, animations: { () -> Void in self.view.layoutIfNeeded() })
            }
        } }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setUpHeader() -> Void {
        
        
        iv_CommentsProfile.layer.borderWidth = 1.0
        iv_CommentsProfile.contentMode = .ScaleAspectFill
        iv_CommentsProfile.backgroundColor = UIColor.whiteColor()
        iv_CommentsProfile.layer.masksToBounds = false
        iv_CommentsProfile.layer.borderColor = UIColor.lightGrayColor().CGColor
        iv_CommentsProfile.layer.cornerRadius = iv_CommentsProfile.frame.size.height/2
        iv_CommentsProfile.clipsToBounds = true
        
        let tapProfileImage = UITapGestureRecognizer.init(target: self, action: #selector(CommentsVC.onClickUserProfileImage))
        iv_CommentsProfile.addGestureRecognizer(tapProfileImage)
        
        //shared by name
        if let sharedByFname = (self.selectedCommentDict as NSDictionary).valueForKeyPath("sharedBy.firstName") as? String {
            
            let sharedByID = (self.selectedCommentDict as NSDictionary).valueForKeyPath("sharedBy._id") as? String
            
            let ownerID = (self.selectedCommentDict as NSDictionary).valueForKeyPath("createdBy._id") as? String
            
            let ownerFName = (self.selectedCommentDict as NSDictionary).valueForKeyPath("createdBy.firstName") as? String
            
            if (sharedByID != ownerID) {
                
                lbl_CommentsTitle.text = sharedByFname + " shared " + ownerFName! + "'s post"
                
            }else{
                lbl_CommentsTitle.text = sharedByFname + " shared post"
            }
            
        }
        else {
            //Posted by name
            
            if let name = (self.selectedCommentDict as NSDictionary).valueForKeyPath("createdBy.firstName") as? String {
                
                lbl_CommentsTitle.text = name + " Shared a Post"
            }

        }

        if let logoUrlStr = (self.selectedCommentDict as NSDictionary).valueForKeyPath("createdBy.imgUrl") as? String    {
            
            let image_url = NSURL(string: logoUrlStr )
            if (image_url != nil) {
                
                let placeholder = UIImage(named: "ic_booking_profilepic")
                iv_CommentsProfile.sd_setImageWithURL((URL: image_url!), placeholderImage: placeholder)
            }
            
        }
        if let createdDate = self.selectedCommentDict["createdDate"] as? String {
            
            let df = NSDateFormatter.init()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            //   df.timeZone = NSTimeZone(name: "UTC")
            
            lbl_timeAgo.text = HelpingClass.timeAgoSinceDate(df.dateFromString(createdDate)!, numericDates: false)
            
            lbl_commentsText.text =  self.selectedCommentDict["text"] as? String
            // will display Organisation name
            lbl_organizationName.text = ""
        }
        print("Dict = ", self.selectedCommentDict)
        
        //--
        if self.selectedCommentDict["postType"] as! String != "text" {
            
            self.imgAttachment.contentMode = .ScaleAspectFit
            self.imgAttachment.clipsToBounds = true
            
            let imgUrls = self.selectedCommentDict["attachments"] as! [String]
            
            
            let thumbNailName = self.selectedCommentDict["thumNailName"] as! String
            
            //check the thumbNail name is exist ? or generate from video url and save to db
            HelpingClass.isFileExistsAtPath(directory: "/ChatFile", fileName: thumbNailName, completion: {(isExistPath, fileUrl) -> Void in
                
                if self.selectedCommentDict["postType"] as! String == "image"{
                    
                    //let recognizer = UITapGestureRecognizer(target: self, action:#selector(NewsFeedsAllVC.clickUserImage(_:)))
                    //recognizer.delegate = self
                    //self.imgAttachment.addGestureRecognizer(recognizer)
                    self.imgAttachment.userInteractionEnabled = true
                    
                    self.btnPlayVideo.setImage(UIImage(named: ""), forState: .Normal)
                    self.playActivityIndicator.startAnimating()
                    
                    self.playActivityIndicator.hidden = false
                    
                    if isExistPath {
                        let img = UIImage(contentsOfFile: fileUrl!)
                        self.imgAttachment.image =  CommonMethodFunctions.imageWithImage(img, scaledToWidth: Float( UIScreen.mainScreen().bounds.size.width) - 30);
                        self.playActivityIndicator.hidden = true
                        self.playActivityIndicator.stopAnimating()
                    }else{
                        self.imgAttachment.sd_setImageWithURL(NSURL(string: imgUrls.first!), placeholderImage: UIImage(named:  "cell_blured_heigh")) {
                            (img,  err,  cacheType,  imgUrl) -> Void in
                            
                            self.imgAttachment.image =  CommonMethodFunctions.imageWithImage(img, scaledToWidth: Float( UIScreen.mainScreen().bounds.size.width) - 30);
                            self.playActivityIndicator.hidden = true
                            self.playActivityIndicator.stopAnimating()
                            
                        }
                    }
                    
                }else{
                    //for video
                    
                    self.btnPlayVideo.hidden = true
                    self.playActivityIndicator.hidden = false
                    self.playActivityIndicator.startAnimating()
                    self.btnPlayVideo.setImage(UIImage(named: "button_chat_play"), forState: .Normal)

                    
                    if isExistPath {
                        let img = UIImage(contentsOfFile: fileUrl!)
                        self.imgAttachment.image = CommonMethodFunctions.imageWithImage(img, scaledToWidth: Float( UIScreen.mainScreen().bounds.size.width) - 30);
                        self.playActivityIndicator.hidden = true
                        self.playActivityIndicator.stopAnimating()
                        self.btnPlayVideo.hidden = false
                    } else {
                        
                        //generate thumb from video url    and display on cell
                        let img =  CommonMethodFunctions.generateThumbImage(NSURL(string: imgUrls.first!)!) //self.generateThumnail(sourceURL: NSURL(string: imgUrls.first!)!)
                        self.imgAttachment.image = CommonMethodFunctions.imageWithImage(img, scaledToWidth: Float( UIScreen.mainScreen().bounds.size.width) - 30);
                        
                        //write to db
                        let imgData = UIImagePNGRepresentation(img) as NSData?
                        
                        HelpingClass.writeToPath(directory: "/ChatFile", fileName: thumbNailName, dataToWrite: imgData!, completion: {(isWritten:Bool, err:NSError?) -> Void in
                            
                            if isWritten{
                                
                                self.playActivityIndicator.hidden = true
                                self.playActivityIndicator.stopAnimating()
                                self.btnPlayVideo.hidden = false
                                
                            }
                        })
                    }
                    
                }
                
            })
            
        }
        else {
            
            self.btnPlayVideo.hidden = true
            self.playActivityIndicator.hidden = true

        }
        //--
        if let thumbName = (self.selectedCommentDict as NSDictionary).valueForKeyPath("createdBy.thumNailName") as? String    {
            
            let image_url = NSURL(string: thumbName )
            if (image_url != nil) {
                
                let placeholder = UIImage(named: "ic_booking_profilepic")
                iv_CommentsProfile.sd_setImageWithURL((URL: image_url!), placeholderImage: placeholder)
            }
            
        }
        
        
        
        if let arr = self.selectedCommentDict["comments"] {
            commentsArr =   arr as! [AnyObject]
        }
         self.table_view.reloadData()
        
        
    }
    
    
    @IBAction func btnPlayClick(sender: AnyObject) {
        
        let postType = self.selectedCommentDict["postType"] as! String
        
        if postType == "image" {
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let fullImageVC: FullScreenImageVC = storyBoard.instantiateViewControllerWithIdentifier("FullScreenImageVC") as! FullScreenImageVC
            
            let imgUrls = (self.selectedCommentDict["attachments"] as! [String]).first!
            let thumbNailName = self.selectedCommentDict["thumNailName"] as! String

            //check the thumbNail name is exist ? or generate from video url and save to db
            HelpingClass.isFileExistsAtPath(directory: "/ChatFile", fileName: thumbNailName, completion: {(isExistPath, fileUrl) -> Void in
                
                if isExistPath {
                    fullImageVC.imagePath = fileUrl
                    fullImageVC.downLoadPath = "4"
                }else{
                    fullImageVC.imagePath = imgUrls
                    fullImageVC.downLoadPath = "3"
                }
                self.navigationController?.pushViewController(fullImageVC, animated: true)
                
            })
            

            fullImageVC.imagePath = (self.selectedCommentDict["attachments"] as! [String]).first!
            fullImageVC.downLoadPath="1"
            
        }else if(postType == "video"){
            
            let thumbNailName = self.selectedCommentDict["thumNailName"] as! String
            var videoName = thumbNailName.stringByReplacingOccurrencesOfString("Thumb", withString: "Video")
            videoName = videoName.stringByReplacingOccurrencesOfString(".jpg", withString: ".mp4")
            let imgUrls = self.selectedCommentDict["attachments"] as! [String]
            
            HelpingClass.isFileExistsAtPath(directory: "/ChatFile", fileName: videoName, completion: {(isExistPath, fileUrl) -> Void in
                
                if isExistPath{
                    
                    self.moviePlayerController = MPMoviePlayerViewController(contentURL:NSURL.fileURLWithPath(fileUrl!))
                    
                }else{
                    
                    self.moviePlayerController = MPMoviePlayerViewController(contentURL:NSURL(string: imgUrls.first!))
                }
                
                //moviePlayerController.movieSourceType = MPMovieSourceType.Streaming
                //self.view.addSubview(self.moviePlayerController.view)
                self.presentMoviePlayerViewControllerAnimated(self.moviePlayerController)
                //self.moviePlayerController.fullscreen = true
                self.moviePlayerController.moviePlayer.play()
            })
        }
        
    }
    
    @IBAction func onClickBackBtn(sender: UIButton) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    @IBAction func onClickSendBtn(sender: UIButton) {
        
        self.sendCommentToServer()
        
        self.tv_writeComment.resignFirstResponder()
        self.tv_writeComment.text = "Leave Your Comments..."
    }
    
    // Comment user profile
    func onClickCellProfileImage(recognizer: UITapGestureRecognizer) {
        
        let location = recognizer.locationInView(self.table_view)
        let indexPath = self.table_view.indexPathForRowAtPoint(location)
        let dict = commentsArr[indexPath!.row] as! NSDictionary
        if let profileUrlStr = (dict as NSDictionary).valueForKeyPath("commentedBy._id") as? String    {
            let vc = AppHelper.getProfileStoryBoard().instantiateViewControllerWithIdentifier("ProfileContainerVC") as! ProfileContainerVC
            vc.viewerUserID = profileUrlStr
            self.navigationController?.pushViewController(vc , animated: true)
        }
        
    }
    
    //Main user profile
    func onClickUserProfileImage() {
    
        if let userID = (self.selectedCommentDict as NSDictionary).valueForKeyPath("sharedBy._id") as? String {
            let vc = AppHelper.getProfileStoryBoard().instantiateViewControllerWithIdentifier("ProfileContainerVC") as! ProfileContainerVC
            vc.viewerUserID = userID
            self.navigationController?.pushViewController(vc , animated: true)
        }
        else {
            
            let userID = (self.selectedCommentDict as NSDictionary).valueForKeyPath("createdBy._id") as? String
            let vc = AppHelper.getProfileStoryBoard().instantiateViewControllerWithIdentifier("ProfileContainerVC") as! ProfileContainerVC
            vc.viewerUserID = userID
            self.navigationController?.pushViewController(vc , animated: true)
        }
        
    }
    
    //MARK: TextView Delegate 
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        if self.tv_writeComment.text == "Leave Your Comments..." {
            textView.text = ""
        }
        
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"  // Recognizes enter key in keyboard
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    
    //MARK: - Socket
    
    //mark- Fetch Meetups/Invites listing data
    func sendCommentToServer() {
        if self.tv_writeComment.text?.characters.count < 1 {
            AppHelper.showAlertWithTitle(AppName, message: "Post text can't be blank.", tag: 0, delegate: nil, cancelButton: "OK", otherButton: nil)
            return
        }
        if self.tv_writeComment.text ==  "Leave Your Comments..." {
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
            
            dict["text"] = self.tv_writeComment.text
            
            dict["postId"] = self.selectedCommentDict["_id"]
            
            
            ChatListner .getChatListnerObj().socket.emit("comment", dict)
            
            
        }else
        {
            AppDelegate.dismissProgressHUD()
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Internet Connection not available.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
        }
    }
    
    func getPostUpdate() -> Void {
        
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
                print(" response = ", resultDict)
                
                self.commentsArr = resultDict["comments"] as! [AnyObject]
                
                self.table_view.reloadData()
                //self.table_view.setOffsetToBottom(true)
                self.table_view.scrollToLastRow(true)

                
            }
                else
                {
                    //SharedClass.sharedInstance.showOkAlertViewController(result!["response_string"] as! String, viewController: self)
                }
                
            }
        }
        
        
    }



extension CommentsVC:UITableViewDataSource{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
   
        let dict = commentsArr[indexPath.row] as! NSDictionary
        
        
        
        let newString = dict["comment"]!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let str = newString.stringByReplacingEmojiCheatCodesWithUnicode()
        
        //                    let fontName = AppHelper .userDefaultForAny("fontName") as String
        //                    let fontSize = AppHelper .userDefaultForAny("fontSize") as CGFloat
        let w = tableView.bounds.size.width - 30
        let size : CGSize =  CommonMethodFunctions.sizeOfCell(str, fontSize: 16 , width: Float(w) , fontName: "Roboto-Regular")
        
        let height = size.height + 120
        
        
        return height
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentsArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("CommentsCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.selectionStyle = .None
        
        
        
        let iv_profile = cell.viewWithTag(1) as! UIImageView
        let lbl_name = cell.viewWithTag(2) as! UILabel
        let lbl_timeAgo = cell.viewWithTag(3) as! UILabel
        let lbl_details = cell.viewWithTag(4) as! UILabel
   //     let lbl_orgName = cell.viewWithTag(5) as! UILabel
        
        
        
        iv_profile.layer.borderWidth = 1.0
        iv_profile.contentMode = .ScaleAspectFill
        iv_profile.backgroundColor = UIColor.whiteColor()
        iv_profile.layer.masksToBounds = false
        iv_profile.layer.borderColor = UIColor.lightGrayColor().CGColor
        iv_profile.layer.cornerRadius = iv_profile.frame.size.height/2
        iv_profile.clipsToBounds = true
        let tapProfileImage = UITapGestureRecognizer.init(target: self, action: #selector(CommentsVC.onClickCellProfileImage(_:)))
        iv_profile.addGestureRecognizer(tapProfileImage)
        
        
        let dict = commentsArr[indexPath.row] as! NSDictionary
        
        print("dict = ", dict)
        
        if let name = (dict as NSDictionary).valueForKeyPath("commentedBy.firstName") as? String {
            
            lbl_name.text = name + " commented on Post"
        }
        
        if let logoUrlStr = (dict as NSDictionary).valueForKeyPath("commentedBy.imgUrl") as? String    {
            
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
            
            
            
            lbl_details.text =  dict["comment"] as? String
            // will display Organisation name
   //         lbl_orgName.text = ""
            
        }
        
       return cell
    }
}
