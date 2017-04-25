//
//  ChatHomeVC.swift
//  Whatsumm
//
//  Created by mawoon on 06/04/15.
//  Copyright (c) 2015 AppStudioz. All rights reserved.
//

import UIKit
import CoreData
class ChatHomeVC: UIViewController, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var searchBar1: UISearchBar!
    @IBOutlet weak var recent_chatTable: UITableView!
    var recentChatArray : NSMutableArray!
    var searchChatArray : NSMutableArray!
    var isSearchingOn : Bool!
    var locIndexPath : NSIndexPath!
    var unreadCount:NSInteger!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var cIndicatior: UIActivityIndicatorView!
    
    @IBOutlet weak var seachRecentChatBtn: UIButton!
    var navigationTitleLable:UILabel!
    
//    private lazy var navigationTitleLable:UILabel = {
//        let label = UILabel()
//        label.textColor = UIColor.whiteColor()
//        label.backgroundColor = UIColor.clearColor()
//        label.numberOfLines = 0
//        label.textAlignment = .Center
//        return label
//    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (AppHelper.userDefaultsForKey("userId")) != nil {
            [ChatHelper .saveToUserDefault(AppHelper.userDefaultsForKey("userId"), key: "userId")]
        }

        self.searchBar1.hidden=true
        
        let textFieldInsideSearchBar = self.searchBar1.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.whiteColor()
        
        self.searchBar1.barTintColor = UIColor.whiteColor()
        self.searchBar1.tintColor = UIColor.whiteColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatHomeVC.isConnecting(_:)),name:"ConnectingNotificationForChat", object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatHomeVC.popToRootViewControllerAnimated),name:"POP_TO_CHAT_MAIN_SCREEN", object:nil)

        unreadCount=0;
        
        recentChatArray = NSMutableArray()
        searchChatArray = NSMutableArray()
        isSearchingOn = false
        
         let str:String = ChatHelper .userDefaultForAny("userId") as! String
        let strPred:String = "loginUserId contains[cd] \"\(str)\""
        
        fetchedResultsController.fetchRequest.predicate = NSPredicate(format:strPred)
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        
        //headerBackButton.setImage(UIImage(named:"signupBack"), forState: .Normal)
        //headerBackButton.setTitle(" Expert Chat", forState: .Normal)
        //headerBackButton.titleLabel!.font = UIFont(name: "Helvetica-bold", size: 10)
        enableSearchFeature(true)
        
        recent_chatTable.tableFooterView = UIView.init(frame: CGRectZero)
        
        if ChatListner.getChatListnerObj().socket.status == .Connected {
            headerLabel.text = ""
            cIndicatior.hidden = true
        }else {
            headerLabel.text = "Connecting..."
            cIndicatior.hidden = false
        }
        
        self.setUpNavigationView()
        
        //self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        //self.navigationController!.navigationBar.shadowImage = UIImage()
        //self.navigationController!.navigationBar.translucent = true
        
        
        

    }
    
    func toggleDeleteChats(status:Bool) {

        self.recent_chatTable.setEditing(status, animated: false)
    }
    
    func popToRootViewControllerAnimated()
    {
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    func enableSearchFeature(isSearchEnable:Bool) {
        searchBar1.hidden = isSearchEnable
        seachRecentChatBtn.hidden = isSearchEnable
    }
    
    func isConnecting(note:NSNotification) {
        headerLabel.text = ""
        cIndicatior.hidden = true
        
        navigationTitleLable.attributedText = getNavigationTitle()
        self.navigationItem.titleView = navigationTitleLable
        
        // Update Msg Badge
        if DataBaseController.sharedInstance.fetchUnreadCount() > 0{
            AppDelegate.getAppDelegate().tabbarController.tabBar.items![1].badgeValue = String(DataBaseController.sharedInstance.fetchUnreadCount())
        }else{
            AppDelegate.getAppDelegate().tabbarController.tabBar.items![1].badgeValue = nil
        }
    }
    
    func isPushed(note:NSNotification) {
        let str:String = ChatHelper .userDefaultForKey("chatId") as String
        if str.characters.count > 0 {
            self.getChatUserForPush()
        }
    }
    
    
    func getNavigationTitle() ->NSMutableAttributedString {
        let titleAttribute = [ NSFontAttributeName: UIFont.boldSystemFontOfSize(16.0) ]
        let headerTitle = NSMutableAttributedString(string: "EXPERT CHAT", attributes: titleAttribute )
        
        if ChatListner.getChatListnerObj().socket.status != .Connected {
            let subTitleAttribute = [ NSFontAttributeName: UIFont.systemFontOfSize(14.0) ]
            let subTitleTitle = NSMutableAttributedString(string: "\nConnecting...", attributes: subTitleAttribute )
            headerTitle.appendAttributedString(subTitleTitle)
        }
        return headerTitle
    }
    
    
    func setUpNavigationView(){
        let backBtn = UIBarButtonItem(image:UIImage(named: "signupBack")?.imageWithRenderingMode(.AlwaysOriginal), style:UIBarButtonItemStyle.Plain, target: self, action:#selector(self.onClickBackAction))
        navigationItem.leftBarButtonItem = backBtn
        
        if navigationTitleLable == nil {
            navigationTitleLable = UILabel()
            navigationTitleLable.textColor = UIColor.whiteColor()
            navigationTitleLable.backgroundColor = UIColor.clearColor()
            navigationTitleLable.numberOfLines = 0
            navigationTitleLable.textAlignment = .Center
        }
        navigationTitleLable.attributedText = getNavigationTitle()
        navigationTitleLable.sizeToFit()
        
        self.navigationItem.titleView = navigationTitleLable
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //Manage Connection it from server if not connected
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatHomeVC.callNotification),name:"PostNotificationToChatNotification", object:nil)
        
        if(!ChatHelper .userDefaultForKey("userId").isEmpty) {
            dispatch_after(1, dispatch_get_main_queue()) { () -> Void in
                if ChatListner.getChatListnerObj().socket.status != .Connected {
                    //print("connectToSocket ==connectToSocket")
                    ChatListner.sharedInstance.connectToSocket()   // call your method.
                }
            }
        }
        
        let str:String = ChatHelper .userDefaultForKey("chatId") 
        if str.characters.count > 0 {
            self.getChatUserForPush()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatHomeVC.isPushed(_:)),name:"PushNotificationForChat", object:nil)
        
        isSearchingOn = false
        delay(0.1, closure: {
            self.searchDisplayController!.setActive(false, animated: true)
            self.searchDisplayController!.searchBar .resignFirstResponder()
        })
        
        self.fetchRecentChatFromDb()
        let instance = DataBaseController.sharedInstance
        let unreadCount=instance.fetchUnreadCount()   //Manage unread count.
        let myString:String = String(unreadCount)
        
        if myString == "0" {
        }
        delay(0.1,
            closure: {
                UIApplication.sharedApplication().statusBarHidden = false;
                UIApplication.sharedApplication().statusBarStyle = .LightContent
        })
        
        recent_chatTable.reloadData()
        
        // Update Msg Badge
        
        if DataBaseController.sharedInstance.fetchUnreadCount() > 0{
            AppDelegate.getAppDelegate().tabbarController.tabBar.items![1].badgeValue = String(DataBaseController.sharedInstance.fetchUnreadCount())
        }else{
            AppDelegate.getAppDelegate().tabbarController.tabBar.items![1].badgeValue = nil
        }
        
        
    }
    
    func callNotification()->Void {
         NSNotificationCenter.defaultCenter().removeObserver(self, name: "PostNotificationToChatNotification", object: nil)
    }
    
    func setPushCount3() -> Void {
        //print("  Cancel Push setPushCount3")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "PushNotificationForChat", object: nil)
    }
    
    //MARK:-FETCH UNREAD COUNT
       // MARK: - Get Puch Chat from db
    func getChatUserForPush() -> Void {
        let str:String = ChatHelper .userDefaultForAny("userId") as! String
        let str1:String = ChatHelper .userDefaultForKey("chatId")
        let strPred:String = "loginUserId contains[cd] \"\(str)\" AND friendId contains[cd] \"\(str1)\""
        let instance = DataBaseController.sharedInstance
        let recentObj=instance.fetchDataRecentChatObject("RecentChatList", predicate: strPred) as RecentChatList?
        
        delay(1.0, closure: {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let chatMainObj: ChattingMainVC = storyBoard.instantiateViewControllerWithIdentifier("ChattingMainVC") as! ChattingMainVC
            chatMainObj.fromVC = self
            chatMainObj.isFromClass="Recent"
            chatMainObj.isFromDeatilScreen = "0"
            chatMainObj.recentChatObj=recentObj
            if recentObj?.groupId == "0" {
                chatMainObj.isGroup="0"
            }else {
                chatMainObj.isGroup="1"
            }
            self.navigationController?.pushViewController(chatMainObj, animated: true)
        })
        ChatHelper .removeFromUserDefaultForKey("chatId")
    }
    
    // fetchedResultsController
    // MARK: - UITableViewDelegate Method
    func showAlert()->Void {
        let alert = UIAlertController(title: AppName, message: "No result found", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func tableView(tableView:UITableView!, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat {
        return 95
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return searchChatArray.count
        }else {
            if let sections = fetchedResultsController.sections {
                let currentSection = sections[section] as NSFetchedResultsSectionInfo
                if currentSection.numberOfObjects == 0 {
                   // self.showAlert()
                }
                return currentSection.numberOfObjects
            }
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell! {
        let cell: UITableViewCell = recent_chatTable.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.selectionStyle = .None
        
        let userImage = cell.contentView.viewWithTag(1) as! UIImageView
        let userName = cell.contentView.viewWithTag(2) as! UILabel
        let lastMessage = cell.contentView.viewWithTag(3) as! UILabel
        let totalMembers = cell.contentView.viewWithTag(6) as! UILabel
        let lastMessageDate = cell.contentView.viewWithTag(44) as! UILabel
        let lastMessageTime = cell.contentView.viewWithTag(4) as! UILabel
        let messageCount = cell.contentView.viewWithTag(5) as! UILabel
        
        messageCount.layer.cornerRadius = 6
        messageCount.clipsToBounds=true
        
        userImage.image=nil;

        var anObject :  RecentChatList!
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            anObject = searchChatArray[indexPath.row] as! RecentChatList
        } else {
            anObject = fetchedResultsController.objectAtIndexPath(indexPath) as! RecentChatList
        }
        
        //NSLog(anObject.friendImageUrl!)
        let imageString = NSString(format:"%@", anObject.friendImageUrl!) as String
        userName.text = anObject.friendName
        
        if anObject.isTyping != "0" {
            lastMessage.text=anObject.isTyping
            lastMessage.textColor=UIColor(red:48.0/255.0, green:58.0/255.0,blue:166.0/255.0,alpha:1.0)
        } else {

            lastMessage.text=anObject.lastMessage!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByReplacingEmojiCheatCodesWithUnicode()
            lastMessage.textColor=UIColor.grayColor()
        }
 
        if anObject.notificationCount == "0" {
            messageCount.hidden = true
        } else {
            messageCount.hidden = false
            messageCount.text = anObject.notificationCount as String!
           // print(messageCount.text)
        }

        if anObject.lastMessageTime!.characters.count > 0 {
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss.sss"
            dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT:0)
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            let date = dateFormatter.dateFromString(anObject.lastMessageTime!)
            dateFormatter = NSDateFormatter()
            dateFormatter.timeZone = NSTimeZone()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")

            dateFormatter.dateFormat = "dd MMM"
            let dateStr = dateFormatter.stringFromDate(date!)
            lastMessageDate.text=dateStr
            dateFormatter.dateFormat = "hh:mm a"
            let timeStr = dateFormatter.stringFromDate(date!)
            lastMessageTime.text = timeStr
            
        } else {
            lastMessageTime.text = ""
        }
        
        if anObject.groupId == "0" {
            if (imageString.characters.count > 2) {
                userImage.sd_setImageWithURL(NSURL(string:imageString), placeholderImage: UIImage(named:"ic_booking_profilepic"))
            } else {
                userImage.image=UIImage(named:"ic_booking_profilepic")
            }
            
            //go to profile page
            
            let imgRecognizer = UITapGestureRecognizer(target: self, action:#selector(ChattingMainVC.clickFrndImage(_:)))
            imgRecognizer.delegate = self
            userImage.addGestureRecognizer(imgRecognizer)
            userImage.userInteractionEnabled = true
            totalMembers.text = ""
            
        }
        else {
            
            //--
            let str:String = ChatHelper.userDefaultForKey("userId") as String!
            let gpId : String = anObject.groupId! as String
            let strPred:String = "loginUserId contains[cd] \"\(str)\" AND groupId LIKE \"\(gpId)\""
            let instance = DataBaseController.sharedInstance
            let fetchResult=instance.fetchData("GroupUserList", predicate: strPred, sort: ("groupId",false))! as NSArray
            
            dispatch_after(0, dispatch_get_main_queue(), {
                let myInt:Int = fetchResult.count
                if(myInt==1) {
                    totalMembers.text = "\(myInt) Member"
                }
                else {
                    totalMembers.text = "\(myInt) Members"
                }
            })

            //Group Msg
           /* let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(name: "UTC")
            let date = dateFormatter.dateFromString(anObject.meldDate!)
           // NSDate *date = [dateFormatter dateFromString:@"2015-04-01T11:42:00"]
            
            // change to a readable time format and change to local time zone
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
            let timeStamp = dateFormatter.stringFromDate(date!)
            
            //  var tempMeldDate = anObject.meldDate

            let tempMeldDate = timeStamp
//           let dateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
           let tempDate = dateFormatter.dateFromString(tempMeldDate) as NSDate!
            
           let dateServer = NSDate()

            if tempDate.compare(dateServer) == NSComparisonResult.OrderedDescending {
            } else if tempDate.compare(dateServer) == NSComparisonResult.OrderedAscending {
                NSLog("date1 after date2");
                lastMessage.text="CLOSED"
                lastMessage.textColor=UIColor.redColor()
            } else {
                NSLog("dates are equal");
            } */
            
              ///new code
            
//            if  (anObject.lastMessage == "CLOSED" && anObject.lastMessageTime == "")
//            {
//                lastMessage.text=anObject.lastMessage
//                lastMessage.textColor=UIColor.redColor()
//            }
//            else
//            {
//                lastMessage.text=anObject.lastMessage
//                lastMessage.textColor=UIColor.grayColor()
//            }
            userImage.setImageWithURL(NSURL(string:anObject.friendImageUrl!), placeholderImage: UIImage(named:"ic_booking_profilepic"))
        }
        userImage.layer.masksToBounds = true
        userImage.layer.cornerRadius = userImage.frame.size.height/2
       
        
            
        
        
        
        
        return cell;
    }
    
    func clickFrndImage(recognizer: UITapGestureRecognizer) {
        
        let location = recognizer.locationInView(recent_chatTable)
        let indexPath = recent_chatTable.indexPathForRowAtPoint(location)
        
        let vc = AppHelper.getProfileStoryBoard().instantiateViewControllerWithIdentifier("ProfileContainerVC") as! ProfileContainerVC
        
        let anObject : RecentChatList!
        
        if recent_chatTable == self.searchDisplayController!.searchResultsTableView {
            anObject = searchChatArray[indexPath!.row] as! RecentChatList
        } else {
            anObject = fetchedResultsController.objectAtIndexPath(indexPath!) as! RecentChatList
        }
        vc.viewerUserID = anObject.friendId
        
        
        
        self.navigationController?.pushViewController(vc , animated: true)
        self.navigationController?.navigationBarHidden = true
    }
    
    
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var anObject : RecentChatList!
        if tableView == self.searchDisplayController!.searchResultsTableView {
            anObject = searchChatArray[indexPath.row] as! RecentChatList
        } else {
            anObject = fetchedResultsController.objectAtIndexPath(indexPath) as! RecentChatList
        }
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let chatMainObj: ChattingMainVC = storyBoard.instantiateViewControllerWithIdentifier("ChattingMainVC") as! ChattingMainVC
        
        if anObject.groupId == "0" {
           
            chatMainObj.isFromClass="Recent"
            chatMainObj.isFromDeatilScreen = "0"
            chatMainObj.recentChatObj=anObject
            chatMainObj.isGroup="0"
            self.navigationController?.pushViewController(chatMainObj, animated: true)

        } else {
            locIndexPath=indexPath;
            //hitServiceForMeldDetails(anObject.groupId! as String)

            let strPred:String = "groupId contains[cd] \"\(anObject.groupId!)\""

            let instance = DataBaseController.sharedInstance
            let recentObj=instance.fetchDataRecentChatObject("RecentChatList", predicate: strPred) as RecentChatList?
            
            if (recentObj != nil) {
                
                chatMainObj.isFromClass="df"
                chatMainObj.isFromDeatilScreen = "0"
                chatMainObj.recentChatObj=recentObj
                chatMainObj.isGroup="0"
                chatMainObj.manageChatTableH="0"
                if recentObj!.groupId == "0"
                {
                    chatMainObj.isGroup = "0"
                }else
                {
                    chatMainObj.isGroup = "1"
                }
                self.navigationController?.pushViewController(chatMainObj, animated: true)
            }
        }
    }

    //Below delegate prevent swipe to delete
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if self.recent_chatTable.editing {return .Delete}
        return .None
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
        }
        else if editingStyle == UITableViewCellEditingStyle.Insert {
            
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
      
        let archiveAction = UITableViewRowAction(style: .Default, title: "Clear",handler: { (action: UITableViewRowAction!, indexPath: NSIndexPath!) in
            // maybe show an action sheet with more options
            self.clearConversationAlert(indexPath)
            //self.recent_chatTable.setEditing(false, animated: false)
            }
        )
        archiveAction.backgroundColor = UIColor.lightGrayColor()
        var anObject : RecentChatList!
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            anObject = searchChatArray[indexPath.row] as! RecentChatList
        } else {
            if let _ = fetchedResultsController.objectAtIndexPath(indexPath) as? RecentChatList {
                anObject = fetchedResultsController.objectAtIndexPath(indexPath) as! RecentChatList
            } else {
                return nil
            }
            //anObject = recentChatArray[indexPath.row] as RecentChat
        }
        
        if anObject.groupId == "0" {
            let deleteAction = UITableViewRowAction(style: .Normal, title: "Delete",
                handler: { (action: UITableViewRowAction!, indexPath: NSIndexPath!) in
                    self.deleteUserAlert(indexPath)
                    // self.recent_chatTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic);
                }
            );
            deleteAction.backgroundColor = UIColor.redColor()
            return [deleteAction, archiveAction]
        } else {
            let deleteAction = UITableViewRowAction(style: .Normal, title: "Delete",
                handler: { (action: UITableViewRowAction!, indexPath: NSIndexPath!) in
                    self.deleteUserAlert(indexPath)
                    // self.recent_chatTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic);
                }
            );
            
            var anObject : RecentChatList!
            if isSearchingOn == true {
                anObject = searchChatArray[indexPath.row] as! RecentChatList
            } else {
                anObject = fetchedResultsController.objectAtIndexPath(indexPath) as! RecentChatList
                //anObject = recentChatArray[indexPath.row] as RecentChat
            }
            
            let instance = DataBaseController.sharedInstance
            
            let gpId : String = anObject.groupId! as String
            
            let str1:String = ChatHelper.userDefaultForKey("userId") as String!
            let strPred1:String = "userId contains[cd] \"\(str1)\" AND groupId LIKE \"\(gpId)\""
            
            let grpObj = instance.fetchDataGrpUserObj("GroupUserList", predicate: strPred1) as GroupUserList?
            
         //   print(grpObj?.isDeletedGroup)
        //    print(grpObj?.groupId)
        //    print(grpObj?.userName)
            
//            if grpObj?.isDeletedGroup == "0" && grpObj != nil {
//                deleteAction.backgroundColor = UIColor.redColor()
//                return [archiveAction]
//            } else {
                deleteAction.backgroundColor = UIColor.redColor()
                return [deleteAction, archiveAction]
            //}
            //return [archiveAction]
        }
    }
    
    func deleteUserAlert(indexPath: NSIndexPath) {
        locIndexPath = indexPath
        var anObject : RecentChatList!
        if isSearchingOn == true {
            anObject = searchChatArray[indexPath.row] as! RecentChatList
        } else {
            anObject = fetchedResultsController.objectAtIndexPath(indexPath) as! RecentChatList
        }
        let strAlert = "Are you sure, you want to delete " + anObject.friendName! + "?"
        if(IS_IOS_7) {
            ChatHelper.showALertWithTag(1000, title: APP_NAME, message: strAlert, delegate: self, cancelButtonTitle: "Cancel", otherButtonTitle: "OK")
        } else {
            let alertController = UIAlertController(title:APP_NAME, message: strAlert , preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                
            }))
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                self.deleteModelAt(indexPath)
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func deleteModelAt(indexPath: NSIndexPath) {
        var anObject : RecentChatList!
        if isSearchingOn == true {
            anObject = searchChatArray[indexPath.row] as! RecentChatList
        } else {
            anObject = fetchedResultsController.objectAtIndexPath(indexPath) as! RecentChatList
        }
        if anObject.groupId == "0" {
            let strLogin:String = ChatHelper .userDefaultForAny("userId") as! String
            let strSender:String = anObject.friendId!
            let strPred:String = "loginUserId contains[cd] \"\(strLogin)\" AND friendId contains[cd] \"\(strSender)\""
            
            let instance = DataBaseController.sharedInstance
            
            let strSender1:String = ChatHelper .userDefaultForAny("userId") as! String
            let strReceiver:String = anObject.friendId! as String
            let strPred1:String = "loginUserId contains[cd] \"\(strLogin)\" AND (( senderId contains[cd] \"\(strSender1)\" AND receiverId contains[cd] \"\(strReceiver)\") OR ( senderId contains[cd] \"\(strReceiver)\" AND receiverId contains[cd] \"\(strSender1)\"))"
            
            instance.deleteData("UserChat", predicate: strPred1)
            instance.deleteData("RecentChatList", predicate: strPred)
        } else {
            let strLogin:String = ChatHelper .userDefaultForAny("userId") as! String
            let strGroupId:String = anObject.groupId! as String
            let strPred:String = "loginUserId contains[cd] \"\(strLogin)\" AND groupId LIKE \"\(strGroupId)\""
            
            let instance = DataBaseController.sharedInstance
            
            instance.deleteData("GroupChat", predicate: strPred)
            instance.deleteData("RecentChatList", predicate: strPred)
            instance.deleteData("GroupList", predicate: strPred)
            instance.deleteData("GroupUserList", predicate: strPred)
        }
        
        let instance = DataBaseController.sharedInstance
        let unreadCount=instance.fetchUnreadCount()   //Manage unread count.
        let myString:String = String(unreadCount)
        
        
        if myString == "0" {
        }
    }
    
    func deleteAllChatHistory()
    {
        
    }
    
    func clearConversationAlert(indexPath: NSIndexPath) {
        locIndexPath = indexPath
        var anObject : RecentChatList!
        if isSearchingOn == true {
            anObject = searchChatArray[indexPath.row] as! RecentChatList
        } else {
            anObject = fetchedResultsController.objectAtIndexPath(indexPath) as! RecentChatList
        }
        let strAlert = "Are you sure, you want to clear conversation " + anObject.friendName! + "?"
        
        if(IS_IOS_7) {
            ChatHelper.showALertWithTag(1001, title: APP_NAME, message: strAlert, delegate: self, cancelButtonTitle: "Cancel", otherButtonTitle: "OK")
        } else {
            let alertController = UIAlertController(title:APP_NAME, message: strAlert, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                
            }))
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                self.clearConversation(indexPath)
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func clearConversation(indexPath: NSIndexPath) {
        var anObject : RecentChatList!
        if isSearchingOn == true {
            anObject = searchChatArray[indexPath.row] as! RecentChatList
        } else {
            anObject = fetchedResultsController.objectAtIndexPath(indexPath) as! RecentChatList
            //anObject = recentChatArray[indexPath.row] as RecentChat
        }
        
        anObject.notificationCount = "0"
        anObject.lastMessageTime = ""
        
        if anObject.groupId == "0" {
            anObject.lastMessage = ""
            let strLogin:String = ChatHelper .userDefaultForAny("userId") as! String
            let strSender:String = ChatHelper .userDefaultForAny("userId") as! String
            
            let strReceiver = anObject.friendId! as NSString
            
            let strPred:String = "loginUserId contains[cd] \"\(strLogin)\" AND (( senderId contains[cd] \"\(strSender)\" AND receiverId contains[cd] \"\(strReceiver)\") OR ( senderId contains[cd] \"\(strReceiver)\" AND receiverId contains[cd] \"\(strSender)\"))"
            
            let instance = DataBaseController.sharedInstance
            instance.deleteData("UserChat", predicate: strPred)
        } else {
            if (anObject.lastMessage == "CLOSED" && anObject.lastMessageTime == "") {
                anObject.lastMessage = "CLOSED"
            } else {
                anObject.lastMessage = ""
            }
            
            let strLogin:String = ChatHelper .userDefaultForAny("userId") as! String
            let strGroupId:String = anObject.groupId! 
            let strPred:String = "loginUserId contains[cd] \"\(strLogin)\" AND groupId LIKE \"\(strGroupId)\""
            
            let instance = DataBaseController.sharedInstance
            instance.deleteData("GroupChat", predicate: strPred)
        }
        
         AppDelegate.getAppDelegate().saveContext()
        
        let instance = DataBaseController.sharedInstance
        let unreadCount=instance.fetchUnreadCount()   //Manage unread count.
        let myString:String = String(unreadCount)
        
        
        if myString == "0" {
        }
    }
    
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        switch View.tag {
         case 1000:
            if buttonIndex == 1 {
                self.deleteModelAt(locIndexPath)
            }
            break;
         case 1001:
            if buttonIndex == 1 {
                self.clearConversation(locIndexPath)
            }
            break;
        default:
            break;
        }
    }
    
    // MARK: - Plus Btn Method
    @IBAction func searchRecentChat(sender: AnyObject) {
        
        //self.headerBackButton.hidden=true
        self.headerLabel.hidden=true
        self.cIndicatior.hidden=true
        self.seachRecentChatBtn.hidden=true
        self.searchBar1.hidden=false
        
        self.searchDisplayController!.searchBar .becomeFirstResponder()

    }
    
    @IBAction func openNotificationVC(sender: AnyObject) {
        
     //   self.searchDisplayController!.active = false
     //   let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
       // let notiObj: PendingNotificationVC = storyBoard.instantiateViewControllerWithIdentifier("PendingNotificationVC") as! PendingNotificationVC
       // self.navigationController?.pushViewController(notiObj, animated: true)
        
    }
    
    @IBAction func plusBtnClick(sender: AnyObject) {
        self.searchDisplayController!.active = false
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let friendListObj: AllChatFriendsVC = storyBoard.instantiateViewControllerWithIdentifier("AllChatFriendsVC") as! AllChatFriendsVC
        friendListObj.fromGroupVC="Chat"
        self.navigationController?.pushViewController(friendListObj, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Search Method
    func fetchRecentChatFromDb()-> Void {
        let str:String = ChatHelper .userDefaultForAny("userId") as! String
        let strPred:String = "loginUserId contains[cd] \"\(str)\""
        self.recentChatArray.removeAllObjects()
        let instance = DataBaseController.sharedInstance
        //var fetchResult=instance.fetchData("RecentChatList", predicate: strPred, sort: ("friendName",true))!
        let fetchResult=instance.fetchDataWithSorting("RecentChatList", predicate: strPred, sort: ("friendName",true), sort2: ("lastMessageTime",false))!

        if fetchResult.count > 0 {
            for myobject : AnyObject in fetchResult {
                let anObject = myobject as! RecentChatList
                self.recentChatArray.addObject(anObject);
            }
        }
    }
    
    func filterContentForSearchText(searchText: String) {
        isSearchingOn=true
        if(!searchText.isEmpty) {
            if (searchChatArray.count > 0) {
                searchChatArray.removeAllObjects()
            }
            
            let searchPredicate = NSPredicate(format: "(friendName BEGINSWITH[cd] %@) OR (friendName CONTAINS[cd] %@)",searchText," "+searchText)
            let filteredArray = self.recentChatArray.filteredArrayUsingPredicate(searchPredicate)
            searchChatArray.addObjectsFromArray(filteredArray)
        }
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        if(searchString.characters.count >= 25) {
            self.searchDisplayController?.searchBar.text = self.searchDisplayController?.searchBar.text!.substringToIndex(searchString.endIndex.predecessor())
           // print_debug(self.searchDisplayController?.searchBar.text)
            return false
        } else {
            isSearchingOn=true
            self.filterContentForSearchText(searchString)
            return true
        }
    }
    
    func searchDisplayControllerDidEndSearch(controller: UISearchDisplayController) {
        isSearchingOn = false
        
        //self.headerBackButton.hidden=false
        self.headerLabel.hidden=true
        self.cIndicatior.hidden=true
        self.seachRecentChatBtn.hidden=false
        self.searchBar1.hidden=true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        isSearchingOn = false;
        
        //self.headerBackButton.hidden=false
        self.headerLabel.hidden=true
        self.cIndicatior.hidden=true
        self.seachRecentChatBtn.hidden=false
        self.searchBar1.hidden=true
    }
    // MARK: - NSFetchResultsController Delegates

   
    
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let animalsFetchRequest = NSFetchRequest(entityName: "RecentChatList")
        let primarySortDescriptor = NSSortDescriptor(key:"lastMessageTime", ascending: false)
        animalsFetchRequest.sortDescriptors = [primarySortDescriptor]
        
        let homeCoreData = AppDelegate.getAppDelegate()
        
        let frc = NSFetchedResultsController(
            fetchRequest: animalsFetchRequest,
            managedObjectContext: homeCoreData.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        frc.delegate = self
        
        return frc
        }()

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        recent_chatTable.beginUpdates()
    }
    
    /* called:
    - when a new model is created
    - when an existing model is updated
    - when an existing model is deleted */
    
    func controller(controller: NSFetchedResultsController,
        didChangeObject object: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?) {
            switch type {
            case .Insert:
                recent_chatTable.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .None)
            case .Update:
                _ = recent_chatTable.cellForRowAtIndexPath(indexPath!)
                recent_chatTable.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .None)
            case .Move:
                recent_chatTable.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                recent_chatTable.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            case .Delete:
                recent_chatTable.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            default:
                return
            }
    }
    
    /* called last
    tells `UITableView` updates are complete */
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        recent_chatTable.endUpdates()
    }
    
    //MARK: Back Button Action
    @IBAction  func onClickBackAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func groupBtnClick(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let chatMainObj: GroupHomeVC = storyBoard.instantiateViewControllerWithIdentifier("GroupHomeVC") as! GroupHomeVC
        self.navigationController?.pushViewController(chatMainObj, animated: true)
    }
  
    // Pk added extra method for 
    func hitServiceForClearConversationOfMeld(searchText: String) {
        
//        AppDelegate.getAppDelegate().showActivityViewer(String())
//        var dict = Dictionary<String, AnyObject>()
//        dict["meldId"] = searchText
//        dict["method"] = "deleteMeld"
//        dict["userId"] = ChatHelper .userDefaultForAny("userId") as! String
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getClearConversationMeldRecords:",name:Notification_deleteMeldsFromServer, object:nil)
//        Service.sharedInstance().deleteMeldsFromServer(dict as Dictionary)
    }
    
    func getClearConversationMeldRecords(note:NSNotification) {
//       // print(note.userInfo)
//        AppDelegate.getAppDelegate().hideActivityViewer()
//        NSNotificationCenter.defaultCenter().removeObserver(self, name:Notification_deleteMeldsFromServer, object:nil)
//        var tempdict = note.userInfo as! Dictionary<String,AnyObject>
//        if tempdict["error_code"]?.integerValue! == 1 {
//          // print("getClearConversationMeldRecords")
//            self.clearConversation(locIndexPath)
//        } else {
//           // print("else")
//        }
    }
    
    func hitServiceForMeldDetails(searchText: String) {
//        AppDelegate.getAppDelegate().showActivityViewer(String())
//        var dict = Dictionary<String, AnyObject>()
//        dict["meldId"] = searchText
//        dict["method"] = "getMeldDetail"
//        dict["userId"] = ChatHelper .userDefaultForAny("userId") as! String
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gettingAllMeldRecords:",name:Notification_getMeldDetails, object:nil)
//        Service.sharedInstance().getMeldDetails(dict as Dictionary)
    }
    
    func gettingAllMeldRecords(note:NSNotification) {
//       // print(note.userInfo)
//        AppDelegate.getAppDelegate().hideActivityViewer()
//        NSNotificationCenter.defaultCenter().removeObserver(self, name:Notification_getMeldDetails, object:nil)
//        var tempdict = note.userInfo as! Dictionary<String,AnyObject>
//        if tempdict["error_code"]?.integerValue! == 1 {
//            
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let meldDetailsObj = storyBoard.instantiateViewControllerWithIdentifier("MeldDetailsVC") as! MeldDetailsVC
//            meldDetailsObj.dicMeldDetails = tempdict["result"] as! NSMutableDictionary
//            meldDetailsObj.strChat="ChatScreen"
//            self.navigationController?.pushViewController(meldDetailsObj, animated: true)
//        } else if tempdict["error_code"]?.integerValue! == 5 {
//           // print("getClearConversationMeldRecords")
//            
//            let strAlert = "This meld has been deleted so you can not continue chat. Do you want to keep this meld chat or want to delete" +  "?"
//            if(IS_IOS_7) {
//                ChatHelper.showALertWithTag(1001, title: APP_NAME, message: strAlert, delegate: self, cancelButtonTitle: "Cancel", otherButtonTitle: "OK")
//            } else {
//                let alertController = UIAlertController(title:APP_NAME, message: strAlert, preferredStyle: UIAlertControllerStyle.Alert)
//                alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
//                    
//                }))
//                alertController.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
//                  //  self.clearConversation(self.locIndexPath)
//                 //   deleteModelAt
//                    self.deleteModelAt(self.locIndexPath)
//                }))
//                self.presentViewController(alertController, animated: true, completion: nil)
//            }
//        } else {
//           // print("else")
//        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
