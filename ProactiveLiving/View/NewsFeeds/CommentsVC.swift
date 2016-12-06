//
//  CommentsVC.swift
//  ProactiveLiving
//
//  Created by Affle on 21/11/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit

class CommentsVC: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var view_tableHeader: UIView!
    @IBOutlet weak var iv_CommentsProfile: UIImageView!
    @IBOutlet weak var lbl_CommentsTitle: UILabel!
    @IBOutlet weak var lbl_timeAgo: UILabel!
    @IBOutlet weak var lbl_commentsText: UILabel!
    @IBOutlet weak var lbl_organizationName: UILabel!
    @IBOutlet weak var tv_writeComment: UITextView!
    
    @IBOutlet weak var table_view: UITableView!
    
    
    @IBOutlet weak var layOutConstrain_view_writeComments_bottom: NSLayoutConstraint!
    
    
    var commentsArr = [AnyObject]()
    var selectedCommentDict = [String:AnyObject]()
    var tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

        self.setUpHeader()
        self.getPostUpdate()
        tapGesture = UITapGestureRecognizer(target: self, action: "returnKeyBoard")
        
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
        let size : CGSize =  CommonMethodFunctions.sizeOfCell(str, fontSize: 16 , width: Float(w) , fontName: "Roboto-Regular")
        
        let height = size.height + 140
        
        var fm = self.view_tableHeader.frame
        fm.size.height = height
        
        self.view_tableHeader.frame = fm
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
                layOutConstrain_view_writeComments_bottom.constant = keyboardHeight
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
        
        
        if let name = (self.selectedCommentDict as NSDictionary).valueForKeyPath("createdBy.firstName") as? String {
            
            lbl_CommentsTitle.text = name + " Shared a Post"
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
        
        
        
        
        
        if let arr = self.selectedCommentDict["comments"] {
            commentsArr =   arr as! [AnyObject]
        }
         self.table_view.reloadData()
        
        
    }
    
    
    
    @IBAction func onClickBackBtn(sender: UIButton) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    @IBAction func onClickSendBtn(sender: UIButton) {
        
        self.sendCommentToServer()
        
        self.tv_writeComment.resignFirstResponder()
        self.tv_writeComment.text = "Leave Your Comments..."
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
