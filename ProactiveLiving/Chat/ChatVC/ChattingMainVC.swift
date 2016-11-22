//
//  ChattingMainVC.swift
//  Whatsumm
//
//  Created by mawoon on 07/04/15.
//  Copyright (c) 2015 AppStudioz. All rights reserved.
//

import UIKit
import MediaPlayer
import MessageUI
import CoreData
import MobileCoreServices


class ChattingMainVC: UIViewController ,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,MFMailComposeViewControllerDelegate,ABNewPersonViewControllerDelegate,NSFetchedResultsControllerDelegate,DKImagePickerControllerDelegate,HPGrowingTextViewDelegate {
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var table_Y_cts_constraint: NSLayoutConstraint!
    @IBOutlet weak var attachmentViewS: UIView!
    @IBOutlet weak var textViewLineWidthConst: NSLayoutConstraint!
    var contObj : ChatContactModelClass!
    var recentChatObj : RecentChatList!
    var isFromClass : NSString!
    var isFromDeatilScreen : NSString!
    var  manageChatTableH : NSString!
    var isGroup : NSString!
  var isPastMeld_ : NSString!
    
    var groupUserName : String!

    var chatArray : NSMutableArray!
    var assets : NSMutableArray!
    @IBOutlet weak var frndName: UILabel!
    @IBOutlet weak var frndImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var lblPastMeldMsg: UILabel!
    
    var growingTextView : HPGrowingTextView!
    var copyTextStr : String!
    var msgId : String!
    var deleteIndexP : NSIndexPath!
    
    var dictData = Dictionary<String, AnyObject>()
    var colorDict = Dictionary<String, AnyObject>()

    
    @IBOutlet weak var bottomPlusConstraint: NSLayoutConstraint!
    @IBOutlet weak var contanierHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var bottomContainerConst: NSLayoutConstraint!
    
    @IBOutlet weak var cameraBtnOutlet: UIButton!
    @IBOutlet weak var sendBtnOutlet: UIButton!
    @IBOutlet weak var audioBtnOutlet: UIButton!
    @IBOutlet weak var audioContainerView: UIView!
    @IBOutlet weak var leadContAudioConst: NSLayoutConstraint!
    @IBOutlet weak var timeRecordLabel: UILabel!
    @IBOutlet weak var leadslidetoCancelLabel: NSLayoutConstraint!
    @IBOutlet weak var audioBtnWidthConst: NSLayoutConstraint!
    
    var timerForProgress : NSTimer!
    var maxIntForProgress : Int!
    var intForProgress : Int!
    var countTimer : Int!
    var secTimer : Int!
    var minTimer : Int!
    var hourTimer : Int!
    var location :CGPoint!
    
    var recordObj : RecordAndPlayAudio!
    var moviePlayerController = MPMoviePlayerController()
    
    var timerForTyping : NSTimer!
    var timerForGroupTyping1 : NSTimer!
    var timerForGroupTyping2 : NSTimer!
    
    var isTyping : Bool!
    var isPossibleToChangeTheUser : Bool!
    var groupUserDic : NSMutableDictionary!
    var font : UIFont!
    var bottomTabBar : CustonTabBarController!
    
   // let socket = SocketIOClient(socketURL: "192.168.5.76:3000")
    @IBOutlet weak var onOffLabel: UILabel!
    @IBOutlet weak var exitedView: UIView!
    
    
    
    // MARK: - Copy And Delete View
    
    @IBOutlet weak var viewCopyAndDelete: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnCopy: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgBackGround: UIImageView!

    
    
    var audioSend : Bool!
    
    var earlierView : UIView!
    var loadMoreBtn : UIButton!
    
    let homeCoreData = AppDelegate.getAppDelegate()
    
//    let bottomTabBar = self.tabBarController
    
    
   
    
    func receiveMessages(note:NSNotification) {
        print(note)
        if isGroup == "0" {
            var msgObj : UserChat!
            msgObj = note.object as! UserChat
            self.chatArray.addObject(msgObj)
            
            var path = [NSIndexPath]()
            path.append(NSIndexPath(forRow:self.chatArray.count-1,inSection:0))
            self.chatTableView.beginUpdates()
            self.chatTableView.insertRowsAtIndexPaths(path, withRowAnimation: UITableViewRowAnimation.None)
            self.chatTableView.endUpdates()
            
            if(self.chatTableView.cellForRowAtIndexPath(NSIndexPath(forRow:self.chatArray.count-2,inSection:0)) != nil) {
                if self.chatArray.count > 2 {
                    self.chatTableView.scrollToRowAtIndexPath(NSIndexPath(forRow:self.chatArray.count-1,inSection:0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                }
                // row is not visible
            } else {
                AudioServicesPlaySystemSound(1002);
            }
            
            //HIDE++++++++++++
//            if AppDelegate.getAppDelegate().checkBgForChange == false {
                self.userChatStatus()
//            }
            
            if self.chatArray.count == 3 {
                chatTableView.tableHeaderView=nil;
                chatTableView.reloadData()
            }
            
        } else {
            var msgObj : GroupChat!
            msgObj = note.object as! GroupChat
            self.chatArray.addObject(msgObj)
            var path = [NSIndexPath]()
            path.append(NSIndexPath(forRow:self.chatArray.count-1,inSection:0))
            self.chatTableView.beginUpdates()
            self.chatTableView.insertRowsAtIndexPaths(path, withRowAnimation: UITableViewRowAnimation.None)
            self.chatTableView.endUpdates()
            
            if(self.chatTableView.cellForRowAtIndexPath(NSIndexPath(forRow:self.chatArray.count-2,inSection:0)) != nil) {
                if self.chatArray.count > 2 {
                    self.chatTableView.scrollToRowAtIndexPath(NSIndexPath(forRow:self.chatArray.count-1,inSection:0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                }
            } else {
                // row is not visible
                AudioServicesPlaySystemSound(1002);
            }
            
            //HIDE++++++++++++
//            if AppDelegate.getAppDelegate().checkBgForChange == false  {
                     self.userChatStatus()
//            }
            
            if self.chatArray.count == 3 {
                chatTableView.tableHeaderView=nil;
                chatTableView.reloadData()
            }
        }
    }
    
    func receiveMessagesUpdate(note:NSNotification) {
      print(note)
        
        if isGroup == "0" || note.valueForKey("userInfo")?.valueForKey("group")! as! NSString == "0" {
            let msgObj:UserChat = note.valueForKey("userInfo")?.valueForKey("bfr") as! UserChat
         
            var index : Int
            index=chatArray.indexOfObject(msgObj) as Int
            
            if index < chatArray.count {
                var path = [NSIndexPath]()
                path.append(NSIndexPath(forRow:index,inSection:0))
                self.chatTableView.beginUpdates()
                chatTableView.reloadRowsAtIndexPaths(path, withRowAnimation: UITableViewRowAnimation.None)
                self.chatTableView.endUpdates()
            }
            
            if self.chatArray.count == 3 {
                chatTableView.tableHeaderView=nil;
                chatTableView.reloadData()
            }
            
        } else {
            let msgObj:GroupChat = note.valueForKey("userInfo")?.valueForKey("bfr") as! GroupChat
            var index : Int
            index=chatArray.indexOfObject(msgObj) as Int
            
            if index < chatArray.count {
                var path = [NSIndexPath]()
                path.append(NSIndexPath(forRow:index,inSection:0))
                self.chatTableView.beginUpdates()
                chatTableView.reloadRowsAtIndexPaths(path, withRowAnimation: UITableViewRowAnimation.None)
                self.chatTableView.endUpdates()
            }
            
            if self.chatArray.count == 3 {
                chatTableView.tableHeaderView=nil;
                chatTableView.reloadData()
            }
        }
        self.userChatStatus()
    }
    
    //MARK: - Update Name Method
    
    func updateNameNotification(note:NSNotification) {
        print(note)
        if contObj != nil {
            frndName.text=contObj.name
        } else {
            frndName.text=recentChatObj.friendName
        }
        
        chatTableView.tableHeaderView=nil;
        chatTableView.reloadData()
    }
    
    //MARK: - User Typing Methods
    
    func userTypingChangedInGroup() {
        if timerForGroupTyping1 != nil {
            timerForGroupTyping1.invalidate()
            timerForGroupTyping1=nil;
        }
        
        timerForGroupTyping1 = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(ChattingMainVC.userTypingChangedInGroup), userInfo: nil, repeats: false)
        
        if timerForGroupTyping2 != nil {
            timerForGroupTyping2.invalidate()
            timerForGroupTyping2=nil;
        }
        
        timerForGroupTyping2 = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(ChattingMainVC.userTypingChangedInGroup), userInfo: nil, repeats: false)
    }
    
    func isTypingChanged(note:NSNotification) {
        let isSender:String = note.valueForKey("userInfo")?.valueForKey("senderid") as! String
        let isType:String = note.valueForKey("userInfo")?.valueForKey("isTyping") as! String
        let chatType:String = note.valueForKey("userInfo")?.valueForKey("chatType") as! String
        
        if chatType == "group" {
            
            if isType == "1" {
                
                if (isPossibleToChangeTheUser == true) {
                    isPossibleToChangeTheUser = false;
                    
                    if timerForGroupTyping2 != nil {
                        timerForGroupTyping2.invalidate()
                        timerForGroupTyping2=nil;
                    }
                    
                    timerForGroupTyping2 = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(ChattingMainVC.timer2), userInfo: nil, repeats: false)
                    
                    if let _: AnyObject = self.groupUserDic[isSender] {
                        self.onOffLabel.text = self.groupUserDic[isSender] as! String + " is Typing..."
                    } else {
                        self.onOffLabel.text =  "Group member is Typing..."
                    }
                }
                
                if timerForGroupTyping1 != nil {
                    timerForGroupTyping1.invalidate()
                    timerForGroupTyping1=nil;
                }
                
                timerForGroupTyping1 = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(ChattingMainVC.timer1), userInfo: nil, repeats: false)
            }else {
                self.onOffLabel.text = groupUserName
            }
            
        } else {
            var strReceiver = ""
            
            if contObj != nil {
                strReceiver = contObj.userId as String
            } else {
                strReceiver = recentChatObj.friendId! as String
            }
            
            if strReceiver == isSender {
                
                if isType == "1" {
                    self.onOffLabel.text = "Typing..."
                } else {
                    self.onOffLabel.text = "Online"
                }
            }
        }
    }
    
    func isTypingStopNot(note:NSNotification) {
        if isTyping != nil && isTyping == true {
            self.isTypingStop()
        }
    }
    
    func timer2() -> Void {
        isPossibleToChangeTheUser = true;
    }
    
    func timer1() -> Void {
        self.onOffLabel.text = groupUserName
    }
    
    //MARK: - Message seened Methods
    
    func messageSeened(note:NSNotification) {
        self.userChatStatus()
    }
    
    func userChatStatus() -> Void {
        if isGroup == "0" {
            let strLogin:String = ChatHelper .userDefaultForAny("userId") as! String
            let strStatus = "0"
            let strStatus1 = "1"
            let strSender:String = ChatHelper .userDefaultForAny("userId") as! String
            var strReceiver = ""
            
            if contObj != nil {
                strReceiver = contObj.userId as String
            } else {
                strReceiver = recentChatObj.friendId! as String
            }
            
            let strPred:String = "loginUserId contains[cd] \"\(strLogin)\" AND (messageStatus contains[cd] \"\(strStatus)\" OR messageStatus contains[cd] \"\(strStatus1)\") AND ( senderId contains[cd] \"\(strReceiver)\" AND receiverId contains[cd] \"\(strSender)\")"
            let instance = DataBaseController.sharedInstance
            let fetchResult = instance.fetchLattestData("UserChat", predicate: strPred, sort: ("messageId",false))! as NSArray
            
            for myobject : AnyObject in fetchResult {
                let chatObj = myobject as! UserChat
                var dict = Dictionary<String, AnyObject>()
                
                if contObj != nil {
                    dict["senderid"] = contObj.userId as String
                } else {
                    dict["senderid"] = recentChatObj.friendId! as String
                }
                
                dict["lastHitDate"]=ChatHelper.userDefaultForKey("lastHitDate")
                dict["userid"] = ChatHelper .userDefaultForAny("userId") as! String
                dict["id"] = chatObj.messageId
                dict["msgStatus"] = "2"
                ChatListner .getChatListnerObj().socket.emit("messageSeened", dict)
                chatObj.messageStatus="2"
                homeCoreData.saveContext()
            }
        } else {
            let strLogin:String = ChatHelper .userDefaultForAny("userId") as! String
            let strStatus = "0"
            let strStatus1 = "1"
            let strGroupId = self.recentChatObj.groupId! as String
        
            let strPred:String = "loginUserId contains[cd] \"\(strLogin)\" AND (messageStatus contains[cd] \"\(strStatus)\" OR messageStatus contains[cd] \"\(strStatus1)\") AND groupId LIKE \"\(strGroupId)\" AND NOT (senderId contains[cd] \"\(strLogin)\")"
            let instance = DataBaseController.sharedInstance
            let fetchResult = instance.fetchData("GroupChat", predicate: strPred, sort: ("messageId",true))! as NSArray
            
            for myobject : AnyObject in fetchResult {
                let chatObj = myobject as! GroupChat
                var dict = Dictionary<String, AnyObject>()
                dict["userid"] = ChatHelper .userDefaultForAny("userId") as! String
                dict["id"] = chatObj.messageId
                dict["groupid"] = strGroupId
                dict["msgStatus"] = "2"
                dict["senderid"] = chatObj.senderId
                print(dict)
                
                ChatListner .getChatListnerObj().socket.emit("messageSeened", dict)
                chatObj.messageStatus="2"
                homeCoreData.saveContext()
            }
        }
        
        self.chatTableView.reloadData()
    }
    
    //MARK: - Check User Online Methods add to contact
    
    func userStatus() -> Void {
        var dict = Dictionary<String, AnyObject>()
        
        if contObj != nil {
            dict["recieverid"] = contObj.userId
        } else {
            dict["recieverid"] = recentChatObj.friendId
        }
        
        dict["userid"] = ChatHelper .userDefaultForAny("userId") as! String
    
        ChatListner .getChatListnerObj().socket.emit("checkUserStatus", dict)
        unowned let weakself = self
        ChatListner .getChatListnerObj().socket.off("getUserStatus")
        ChatListner .getChatListnerObj().socket.on("getUserStatus") {data, ack in
            var receiveMsgDic = Dictionary<String,AnyObject>()
            
            receiveMsgDic = data[0] as! Dictionary
            print(receiveMsgDic)
            
            let lastHitDate = receiveMsgDic["lastHitDate"] as! String
            ChatHelper .saveToUserDefault(lastHitDate, key: "lastHitDate");
            let status = receiveMsgDic["status"] as! Int
            
            if status == 1 {
                weakself.onOffLabel.text = "Online"
            } else {
                weakself.onOffLabel.text = ""
                let tempDateStr = receiveMsgDic["lastSeen"] as? String
                
                if tempDateStr != nil && tempDateStr != "0000-00-00 00:00:00" {
                      var tempDate : NSDate
                      var dateStr : String!
                      var dateStr1 : String!
                      var timeStr : String!
                      let date = NSDate()
                      let dateFormatter = NSDateFormatter()
                      dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                      dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                      tempDate = dateFormatter.dateFromString(tempDateStr!)!
                      dateFormatter.dateFormat = "dd MMM"
                      dateStr = dateFormatter.stringFromDate(tempDate)
                      dateStr1 = dateFormatter.stringFromDate(date)
                      dateFormatter.dateFormat = "hh:mm a"
                      dateFormatter.timeZone = NSTimeZone()
                      timeStr = dateFormatter.stringFromDate(tempDate)
                    
                    if dateStr == dateStr1 {
                        weakself.onOffLabel.text = "Last seen Today at \(timeStr)"
                    } else {
                        weakself.onOffLabel.text = "Last seen at \(dateStr)"
                    }
                }
            }
        }
    }
    
    //MARK: - Group User Info Methods
    
    func getGroupUserInfo() {
        groupUserName = ""
        let str:String = ChatHelper.userDefaultForKey("userId") as String!
        let str1:String = self.recentChatObj.groupId as String!
        let strPred:String = "loginUserId contains[cd] \"\(str)\" AND groupId LIKE \"\(str1)\""
        let instance = DataBaseController.sharedInstance
        
        let fetchResult=instance.fetchData("GroupUserList", predicate: strPred, sort: ("groupId",false))! as NSArray
        // print(fetchResult)
        for myobject : AnyObject in fetchResult {
            let groupObj = myobject as! GroupUserList
            self.groupUserDic[groupObj.userId!] = groupObj.userName
           // print(groupObj.userName)
           // print(self.groupUserDic[groupObj.userId])
            let nameStr = groupObj.userName! as String
            let mb = ChatHelper.userDefaultForKey("PhoneNumber") as String
            
     //       let trimmedString = nameStr.stringByReplacingOccurrencesOfString("+91", withString: "")
     //       let trimmedString1 = mb.stringByReplacingOccurrencesOfString("+91", withString: "")
            
            
            if groupObj.userId == ChatHelper.userDefaultForAny(_ID) as! String {
                groupUserName = groupUserName + "You" + ", "
            } else {
                groupUserName = groupUserName + groupObj.userName! + ", "
            }
            
            if groupObj.userId == ChatHelper.userDefaultForKey("userId") as String! {
                if groupObj.isDeletedGroup == "1" {
                    dispatch_after(0, dispatch_get_main_queue(),{
                        self.containerView.hidden=true
                        self.exitedView.hidden = false
                        self.groupUserName = self.groupUserName.stringByReplacingOccurrencesOfString("You,", withString: "")
                    })
                }
            }
        }
   
        //code hide by pk 1 oct
      //  let substringIndex = countElements(groupUserName)-2
      //  groupUserName = groupUserName.substringToIndex(advance(groupUserName.startIndex, substringIndex))
        dispatch_after(0, dispatch_get_main_queue(), {
            let myInt:Int = fetchResult.count
            let myString:String = String(myInt)
            let string2 = " Members"
            let appendString2 = myString+string2
            self.onOffLabel.text = appendString2
        })
    }
    
    func groupCreatedOrUpdatedListener(note:NSNotification) {
        stopActivityIndicator(self.view)
        
        if isGroup == "1" {
            growingTextView.resignFirstResponder()
            frndName.text=recentChatObj.friendName!.stringByReplacingEmojiCheatCodesWithUnicode()
            
            frndImage.setImageWithURL(NSURL(string:recentChatObj.friendImageUrl!), placeholderImage: UIImage(named:"default_userImage"))
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                self.getGroupUserInfo()
            })
        }
    }
    
    //MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomTabBar = self.tabBarController as? CustonTabBarController
        self.exitedView.hidden = true
        ChatHelper .removeFromUserDefaultForKey("chatId")
        copyTextStr = ""
        msgId = ""
        audioSend = true
        isPossibleToChangeTheUser = true
        self.groupUserDic = NSMutableDictionary()
        
        isTyping = false
        
        //AppDelegate.getAppDelegate().btnCreateMeld.hidden = true
 
        //if ChatListner .getChatListnerObj().socket.status == SocketIOClientStatus.NotConnected {
                //ChatListner .getChatListnerObj().socket.reconnect()
        //}
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if (defaults.stringForKey("fontName") != nil) {

        } else {
            ChatHelper .saveToUserDefault("Roboto-Regular", key: "fontName")
            ChatHelper .saveToUserDefault(14.0, key: "fontSize")
        }
        
        chatArray=NSMutableArray()
        recordObj=RecordAndPlayAudio()
       
        frndImage.layer.masksToBounds = true
        frndImage.layer.cornerRadius = 20.0
        frndImage.layer.borderColor = UIColor(red: 14.0/255.0, green: 0.0/255.0, blue: 175.0/255.0, alpha: 1.0).CGColor
        let imgRecognizer = UITapGestureRecognizer(target: self, action:#selector(ChattingMainVC.clickFrndImage(_:)))
        imgRecognizer.delegate = self
        frndImage.addGestureRecognizer(imgRecognizer)
        frndImage.userInteractionEnabled = true

        let recognizer = UITapGestureRecognizer(target: self, action:#selector(ChattingMainVC.clickChatTable(_:)))
        recognizer.delegate = self
        chatTableView.addGestureRecognizer(recognizer)
        chatTableView.userInteractionEnabled = true
        
        let recognizer1 = UILongPressGestureRecognizer(target: self, action:#selector(ChattingMainVC.pressChatTable(_:)))
        recognizer1.delegate = self
        chatTableView.addGestureRecognizer(recognizer1)
        let fontName = ChatHelper .userDefaultForAny("fontName") as! String
        let fontSize = ChatHelper .userDefaultForAny("fontSize") as! CGFloat
        
          self.lblPastMeldMsg.hidden=true
        self.font = UIFont(name: fontName, size: fontSize)

        self.addInputView()
        
        attachmentViewS.backgroundColor = UIColor.clearColor()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
    
        bottomTabBar!.setTabBarVisible(false, animated: true) { (finish) in
           // print(finish)
        }
        
        self.navigationController?.navigationBarHidden = true
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().enableAutoToolbar=false
        
        delay(2.0, closure: {
            self.attachmentViewS.backgroundColor=UIColor.whiteColor()
        })
        
        if ChatListner .getChatListnerObj().socket.status == SocketIOClientStatus.NotConnected {
            ChatListner .getChatListnerObj().socket.connect()
        }
        
        self.isFromDeatilScreen = "1"
        self.manageChatTableH = "1"
        
        topView.hidden = false
        // print(self.isPastMeld_)
        self.lblPastMeldMsg.hidden=true
        //chat from
         //   print(self.ispast)
            
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "TypeMsgObserverStop", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChattingMainVC.isTypingStopNot(_:)),name:"TypeMsgObserverStop", object:nil)
        
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "receiveMsgObserverUpdate", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "receiveMsgObserver", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChattingMainVC.receiveMessages(_:)),name:"receiveMsgObserver", object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChattingMainVC.receiveMessagesUpdate(_:)),name:"receiveMsgObserverUpdate", object:nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "groupCreateNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChattingMainVC.groupCreatedOrUpdatedListener(_:)),name:"groupCreateNotification", object:nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "TypeMsgObserver", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "receiveMsgFrombgToFg", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "updateNameObserver", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChattingMainVC.isTypingChanged(_:)),name:"TypeMsgObserver", object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChattingMainVC.messageSeened(_:)),name:"receiveMsgFrombgToFg", object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChattingMainVC.updateNameNotification(_:)),name:"updateNameObserver", object:nil)
      
        if contObj != nil {
             print(contObj)
            
            frndName.text=contObj.name
            //ChatHelper .saveToUserDefault("5721f430dfcde77833f9daf2", key: "friendId")
            ChatHelper .saveToUserDefault(contObj.userId, key: "friendId")
            let imageString = NSString(format:"%@",contObj.userImgString) as String
            if (imageString.characters.count > 2) {
                frndImage.setImageWithURL(NSURL(string:imageString), placeholderImage: UIImage(named:"ic_booking_profilepic"))
            } else {
                frndImage.image=UIImage(named:"ic_booking_profilepic")
            }
            
        } else {
            // Got crash here with andriod meld for two member
            print(recentChatObj)
            
            frndName.text=recentChatObj.friendName
            //ChatHelper .saveToUserDefault("5721f430dfcde77833f9daf2", key: "friendId")
            ChatHelper .saveToUserDefault(recentChatObj.friendId!, key: "friendId")
            let imageString = NSString(format:"%@",recentChatObj.friendImageUrl!) as String
            if (imageString.characters.count > 2) {
                frndImage.setImageWithURL(NSURL(string:imageString), placeholderImage: UIImage(named:"ic_booking_profilepic"))
            } else {
                frndImage.image=UIImage(named:"ic_booking_profilepic")
            }
            
            recentChatObj.notificationCount = "0"
            homeCoreData.saveContext()
        }
      
        if isGroup == "0" {
            self.userStatus()
            self.fetchChatFromDb()
        } else {
            frndImage.setImageWithURL(NSURL(string:recentChatObj.friendImageUrl!), placeholderImage: UIImage(named:"ic_booking_profilepic"))
            ChatHelper .saveToUserDefault(recentChatObj.groupId!, key: "friendId")
            self.fetchGroupChatFromDb()
        }
     
        if isGroup == "1" {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: "groupBack", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChattingMainVC.backBtnGroup(_:)),name:"groupBack", object:nil)
        
            frndName.text=recentChatObj.friendName
            frndImage.setImageWithURL(NSURL(string:recentChatObj.friendImageUrl!), placeholderImage: UIImage(named:"ic_booking_profilepic"))

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                self.getGroupUserInfo()
            })
        }
   
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChattingMainVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChattingMainVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        UIApplication.sharedApplication().statusBarHidden = false;
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        leadContAudioConst.constant = 400
        bottomPlusConstraint.constant = -290
        
        leadContAudioConst.constant = self.view.frame.width
        self.view.layoutIfNeeded()
        attachmentViewS.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
        UIApplication.sharedApplication().statusBarHidden = false;
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        if contObj == nil {
            
            if self.recentChatObj.isTyping != "0" {
                self.onOffLabel.text = self.recentChatObj.isTyping
            }
            
            recentChatObj.notificationCount = "0"
            homeCoreData.saveContext()
        }
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        bottomTabBar!.setTabBarVisible(true, animated: true) { (finish) in
            //print(finish)
        }
        
        self.navigationController?.navigationBarHidden = false
        IQKeyboardManager.sharedManager().enable = true
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "groupCreateNotification", object: nil)
        //ChatHelper .saveToUserDefault("", key: "friendId")
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    

    
     //MARK: - To show user image in full view  Method
    
    func clickFrndImage(recognizer: UITapGestureRecognizer) {
       
        //HIDE++++++++++++++
       /* let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let myprofileVc: MyProfileVCViewController = storyBoard.instantiateViewControllerWithIdentifier("MyProfileVCViewController") as MyProfileVCViewController
        myprofileVc.ProfileId = ChatHelper.userDefaultForKey("friendId")
            self.navigationController?.pushViewController(myprofileVc, animated: true)
 */
    }
    
    func clickChatTable(recognizer: UITapGestureRecognizer) {
        growingTextView.resignFirstResponder()
    }
    
     //MARK: - Copy and delete Method
    
    func pressChatTable(recognizer: UILongPressGestureRecognizer) {
        let pointInTable = recognizer.locationInView(chatTableView)
        
        if let indexPath = chatTableView.indexPathForRowAtPoint(pointInTable) {
            
            if (chatTableView.cellForRowAtIndexPath(indexPath) != nil) {
                let cell:UITableViewCell = chatTableView.cellForRowAtIndexPath(indexPath)!
                
                if isGroup == "0" {
                    
                    if (!chatTableView.userInteractionEnabled) {
                        return
                    }
                    
                    let chatObj = chatArray[indexPath.row] as! UserChat
                    
                    if chatObj.messageType != "notification" {
                        cell.selectionStyle = .Blue
                        cell.selected = true
                        chatTableView.userInteractionEnabled = false
                        let cellBGView = UIView()
                        cellBGView.backgroundColor = UIColor(red: 0, green: 0, blue: 200, alpha: 0.4)
                        cell.selectedBackgroundView = cellBGView
                        
                        if chatObj.messageStatus == "3" {
                            msgId = chatObj.locMessageId
                            deleteIndexP = indexPath
                        } else if chatObj.messageStatus == "5" {
                            msgId = chatObj.locMessageId
                            deleteIndexP = indexPath
                        } else {
                            msgId = chatObj.messageId
                            deleteIndexP = indexPath
                        }
                    }
                    
                    if chatObj.messageType == "text" {
                        copyTextStr = chatObj.message
                        //self.openCopyDeleteActionSheet()
                        viewCopyAndDelete.hidden = false
                        btnCopy.hidden = false
                        imgBackGround.hidden = false
                        
                    } else if chatObj.messageType == "video" || chatObj.messageType == "audio" || chatObj.messageType == "image" {
                        viewCopyAndDelete.hidden = false
                        btnCopy.hidden = true
                        imgBackGround.hidden = false
                    }
                    
                } else {
                    
                    if (!chatTableView.userInteractionEnabled) {
                        return
                    }
                    
                    let chatObj = chatArray[indexPath.row] as! GroupChat
                    
                    if chatObj.messageType != "notification" {
                        
                        cell.selectionStyle = .Blue
                        cell.selected = true
                        chatTableView.userInteractionEnabled = false
                        let cellBGView = UIView()
                        cellBGView.backgroundColor = UIColor(red: 0, green: 0, blue: 200, alpha: 0.4)
                        cell.selectedBackgroundView = cellBGView
                        
                        if chatObj.messageStatus == "3" {
                            msgId = chatObj.locMessageId
                            deleteIndexP = indexPath
                        } else if   chatObj.messageStatus == "5" {
                            msgId = chatObj.locMessageId
                            deleteIndexP = indexPath
                        } else {
                            msgId = chatObj.messageId
                            deleteIndexP = indexPath
                        }
                    }
                    
                    if chatObj.messageType == "text" {
                        copyTextStr = chatObj.message
                        self.openCopyDeleteActionSheet()
                        
                    } else if chatObj.messageType == "video" || chatObj.messageType == "audio" || chatObj.messageType == "image" {
                        self.openDeleteActionSheet()
                    }
                }
            }
        }
    }
    
    @IBAction func onClickCopy(sender: UIButton) {
        self.copyText(self.copyTextStr)
    }
    
    @IBAction func onClickDelete(sender: UIButton) {
        //print(self.deleteIndexP)
        //  AppDelegate .getAppdelegate().currentOperationDict.removeObjectForKey(newIndexPath)
        let operation =  ChatListner .getChatListnerObj().currentOperationDict[self.deleteIndexP] as? AFHTTPRequestOperation
        
        if operation != nil {
            //print("operation")
            operation!.cancel()
        }
        
        //print("onClickDelete")
        //print(self.deleteIndexP)
        self.deleteMessage(self.msgId, indexp: self.deleteIndexP)
        
        viewCopyAndDelete.hidden = true
        imgBackGround.hidden = true
        chatTableView.userInteractionEnabled = true
        //print(self.deleteIndexP)
        
        let visibleCell : NSArray = chatTableView.indexPathsForVisibleRows!
        
        if(visibleCell.containsObject(self.deleteIndexP)) {
            let cell:UITableViewCell = self.chatTableView.cellForRowAtIndexPath(self.deleteIndexP)!
            cell.backgroundColor = UIColor.clearColor()
            self.chatTableView.reloadRowsAtIndexPaths([self.deleteIndexP], withRowAnimation: .None)
        }
    }
    
    @IBAction func onClickBack(sender: UIButton) {
        viewCopyAndDelete.hidden = true
        imgBackGround.hidden = true
        chatTableView.userInteractionEnabled = true
        
        let visibleCell : NSArray = chatTableView.indexPathsForVisibleRows!
        
        if self.deleteIndexP != nil {
            
            if(visibleCell.containsObject(self.deleteIndexP)) {
                let cell:UITableViewCell = self.chatTableView.cellForRowAtIndexPath(self.deleteIndexP)!
                cell.backgroundColor = UIColor.clearColor()
                self.chatTableView.reloadRowsAtIndexPaths([self.deleteIndexP], withRowAnimation: .None)
            }
        }
    }
    
    func btnCopyCancle() {
        chatTableView.userInteractionEnabled = true
        
        let visibleCell : NSArray = chatTableView.indexPathsForVisibleRows!
        
        if self.deleteIndexP != nil {
            
            if(visibleCell.containsObject(self.deleteIndexP)) {
                let cell:UITableViewCell = self.chatTableView.cellForRowAtIndexPath(self.deleteIndexP)!
                cell.backgroundColor = UIColor.clearColor()
                self.chatTableView.reloadRowsAtIndexPaths([self.deleteIndexP], withRowAnimation: .None)
            }
        }
    }
    
    func copyText(text: String) -> Void {
        UIPasteboard.generalPasteboard().string = text
        copyTextStr="";
        viewCopyAndDelete.hidden = true
        imgBackGround.hidden = true
        chatTableView.userInteractionEnabled = true
        let visibleCell : NSArray = self.chatTableView.indexPathsForVisibleRows!
        
        if(visibleCell.containsObject(self.deleteIndexP)) {
            let cell:UITableViewCell = self.chatTableView.cellForRowAtIndexPath(self.deleteIndexP)!
        //////print(cell)
        //print(self.deleteIndexP)
           cell.backgroundColor = UIColor.clearColor()
           self.chatTableView.reloadRowsAtIndexPaths([self.deleteIndexP], withRowAnimation: .None)
        }
    }
    
    func deleteMessageWithAlert() -> Void {
        let refreshAlert = UIAlertController(title: "Delete", message: "Are you sure you want to delete?.", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
           // print("Handle Ok logic here")
            self.chatTableView.userInteractionEnabled = true
             self.deleteMessage(self.msgId, indexp: self.deleteIndexP)
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                self.btnCopyCancle()
        }))
       presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    func deleteMessage(mid: String, indexp : NSIndexPath) -> Void {
        if isGroup == "0" {
            let messageId:String = mid 
            var strPred:String = ""
            let instance = DataBaseController.sharedInstance
            var dateL : String!
            let chatObj = chatArray[indexp.row] as! UserChat
            
            if chatObj.messageStatus == "3" {
                strPred = "locMessageId LIKE \"\(messageId)\""
            } else {
                strPred = "messageId LIKE \"\(messageId)\""
            }
            
            dateL = chatObj.messageDate
            let strLogin:String = ChatHelper .userDefaultForAny("userId") as! String
            let strSender:String = ChatHelper .userDefaultForAny("userId") as! String
            var strReceiver = ""
            
            if contObj != nil {
                strReceiver = contObj.userId as String
            } else {
                strReceiver = recentChatObj.friendId! as String
            }
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
            let date = dateFormatter.dateFromString(dateL)
            dateFormatter.dateFormat = "YYYY-MM-dd"
            dateL = dateFormatter.stringFromDate(date!)
            
            let strDeletePred:String = "loginUserId contains[cd] \"\(strLogin)\" AND (( senderId contains[cd] \"\(strSender)\" AND receiverId contains[cd] \"\(strReceiver)\") OR ( senderId contains[cd] \"\(strReceiver)\" AND receiverId contains[cd] \"\(strSender)\")) AND messageDate contains[cd] \"\(dateL)\""
    
            let fetchResult = instance.fetchChatData("UserChat", predicate: strDeletePred, sort: ("localSortID",false))! as NSArray
            
            if fetchResult.count == 2 {
                
                instance.deleteData("UserChat", predicate: strPred)
                self.chatArray.removeObjectAtIndex(indexp.row)
                chatTableView.deleteRowsAtIndexPaths([indexp], withRowAnimation: .None)
                
                let strPred1:String = "messageDate LIKE \"\(dateL)\""
                instance.deleteData("UserChat", predicate: strPred1)
                let indexp2 : NSIndexPath = NSIndexPath(forRow:indexp.row-1,inSection:0)
                self.chatArray.removeObjectAtIndex(indexp2.row)
                chatTableView.deleteRowsAtIndexPaths([indexp2], withRowAnimation: .None)
            } else {
                instance.deleteData("UserChat", predicate: strPred)
                self.chatArray.removeObjectAtIndex(indexp.row)
                chatTableView.deleteRowsAtIndexPaths([indexp], withRowAnimation: .Fade)
            }
            
        } else {
            let messageId:String = mid as String
            var strPred:String = ""
            
            let instance = DataBaseController.sharedInstance
            var dateL : String!
            let chatObj = chatArray[indexp.row] as! GroupChat
            
            if chatObj.messageStatus == "3" {
                strPred = "locMessageId LIKE \"\(messageId)\""
            } else if   chatObj.messageStatus == "5" {
               strPred = "locMessageId LIKE \"\(messageId)\""
            } else {
                strPred = "messageId LIKE \"\(messageId)\""
            }
            
            dateL = chatObj.messageDate
            let strLogin:String = ChatHelper .userDefaultForAny("userId") as! String
            let groupId:String = self.recentChatObj.groupId! as String
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
            let date = dateFormatter.dateFromString(dateL)
            dateFormatter.dateFormat = "YYYY-MM-dd"
            dateL = dateFormatter.stringFromDate(date!)
            
            let strDeletePred:String = "loginUserId contains[cd] \"\(strLogin)\" AND groupId LIKE \"\(groupId)\" AND messageDate contains[cd] \"\(dateL)\""
            let fetchResult = instance.fetchChatData("GroupChat", predicate: strDeletePred, sort: ("localSortID",false))! as NSArray
            
            if chatObj.messageType != "text" {
                let strPred2:String = "mediaUrl LIKE \"\(chatObj.groupChatFile!.mediaUrl)\""
                instance.deleteData("GroupChatFile", predicate: strPred2)
            }
            
            if fetchResult.count == 2 {
                instance.deleteData("GroupChat", predicate: strPred)
                self.chatArray.removeObjectAtIndex(indexp.row)
                chatTableView.deleteRowsAtIndexPaths([indexp], withRowAnimation: .None)
                
                let strPred1:String = "messageDate LIKE \"\(dateL)\""
                instance.deleteData("GroupChat", predicate: strPred1)
                let indexp2 : NSIndexPath = NSIndexPath(forRow:indexp.row-1,inSection:0)
                self.chatArray.removeObjectAtIndex(indexp2.row)
                chatTableView.deleteRowsAtIndexPaths([indexp2], withRowAnimation: .None)
            } else {
                instance.deleteData("GroupChat", predicate: strPred)
                self.chatArray.removeObjectAtIndex(indexp.row)
                chatTableView.deleteRowsAtIndexPaths([indexp], withRowAnimation: .None)
            }
        }
        msgId = ""
    }
    
    //MARK: - Fetch Chat from db Method
    
    func fetchChatFromDb()-> Void {
        let strLogin:String = ChatHelper .userDefaultForAny("userId") as! String
        let strSender:String = ChatHelper .userDefaultForAny("userId") as! String
        var strReceiver = ""
        
        if contObj != nil {
            strReceiver = contObj.userId as String
        } else {
            strReceiver = recentChatObj.friendId! as String
        }
        
        let strPred:String = "loginUserId contains[cd] \"\(strLogin)\" AND (( senderId contains[cd] \"\(strSender)\" AND receiverId contains[cd] \"\(strReceiver)\") OR ( senderId contains[cd] \"\(strReceiver)\" AND receiverId contains[cd] \"\(strSender)\"))"
        
        self.chatArray.removeAllObjects()
        let instance = DataBaseController.sharedInstance
        let fetchResult = instance.fetchChatData("UserChat", predicate: strPred, sort: ("localSortID",false))! as NSArray
    
        //print(fetchResult)
        
        for myobject : AnyObject in fetchResult {
            let anObject = myobject as! UserChat
            chatArray.insertObject(anObject, atIndex: 0)
        }
        //print(chatArray)
        
        self.chatTableView.reloadData()
        if self.chatArray.count > 2 {
            delay(0.0001, closure: {
                    self.chatTableView.scrollToRowAtIndexPath(NSIndexPath(forRow:self.chatArray.count-1,inSection:0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
            })
        }
   
        //HIDE +++++++++++++++
//        if AppDelegate.getAppDelegate().checkBgForChange == false
//        {
           self.userChatStatus()
//        }
         self.getHeaderFile()
        
        if contObj == nil && self.recentChatObj.isNameAvail == "0" && self.chatArray.count == 2 {
           // self.addContactHeaderViewInTable()
        }
    }
    
    func fetchGroupChatFromDb()-> Void {
        let strLogin:String = ChatHelper .userDefaultForAny("userId") as! String
        let strGroupId = self.recentChatObj.groupId! as String
        
        let strPred:String = "loginUserId contains[cd] \"\(strLogin)\" AND groupId LIKE \"\(strGroupId)\""
        
        self.chatArray.removeAllObjects()
        let instance = DataBaseController.sharedInstance
        let fetchResult = instance.fetchChatData("GroupChat", predicate: strPred, sort: ("localSortID",false))! as NSArray
        
        for myobject : AnyObject in fetchResult {
            let anObject = myobject as! GroupChat
            chatArray.insertObject(anObject, atIndex: 0)
        }

        chatTableView.reloadData()
        
        if chatArray.count > 2 {
            delay(0.0001,closure: {
                self.chatTableView.scrollToRowAtIndexPath(NSIndexPath(forRow:self.chatArray.count-1,inSection:0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
            })
        }
     
        //HIDE+++++++++++
//        if AppDelegate.getAppDelegate().checkBgForChange == false
//        {
            self.userChatStatus()
//        }
        self.getHeaderFile()
    }
    
    //MARK: - TableView header Method
    func addHeaderViewInTable() {

        if (IS_IPHONE_4 || IS_IPHONE_5) {
             earlierView = UIView(frame: CGRectMake( 0,  0, 320,  50))
            loadMoreBtn = UIButton(frame: CGRectMake(0, 0, 320,50))
        } else if (IS_IPHONE_6) {
             earlierView = UIView(frame: CGRectMake( 0,  0, 365,  50))
            loadMoreBtn = UIButton(frame: CGRectMake(0, 0, 365,50))
        } else {
             earlierView = UIView(frame: CGRectMake( 0,  0, 405,  50))
            loadMoreBtn = UIButton(frame: CGRectMake(0, 0, 405,50))
        }
        
        earlierView.backgroundColor=UIColor.lightGrayColor()
        earlierView.alpha=0.6;
       
        loadMoreBtn.addTarget(self, action: #selector(ChattingMainVC.viewEarlierMessageClick(_:)), forControlEvents:
            UIControlEvents.TouchUpInside)
        loadMoreBtn.setTitle("Load More", forState: UIControlState.Normal)
        loadMoreBtn.titleLabel!.font =  UIFont(name: FONT_REGULAR, size: 16)
        earlierView.addSubview(loadMoreBtn)
        chatTableView.tableHeaderView=earlierView;
    }
    
    func addContactHeaderViewInTable() {
        var headerContactView : UIView!
        var addContactBtn : UIButton!
        
        if (IS_IPHONE_4 || IS_IPHONE_5) {
            headerContactView = UIView(frame: CGRectMake( 0,  0, 320,  50))
            addContactBtn = UIButton(frame: CGRectMake(0, 0, 320,50))
        } else if (IS_IPHONE_6) {
            headerContactView = UIView(frame: CGRectMake( 0,  0, 365,  50))
            addContactBtn = UIButton(frame: CGRectMake(0, 0, 365,50))
        } else {
            headerContactView = UIView(frame: CGRectMake( 0,  0, 405,  50))
            addContactBtn = UIButton(frame: CGRectMake(0, 0, 405,50))
        }
        
        headerContactView.backgroundColor=UIColor.lightGrayColor()
        headerContactView.alpha=1;
        
        addContactBtn.addTarget(self, action: #selector(ChattingMainVC.addContactClick(_:)), forControlEvents:
            UIControlEvents.TouchUpInside)
        addContactBtn.setTitle("Add to contact", forState: UIControlState.Normal)
        addContactBtn.titleLabel!.font =  UIFont(name: "Roboto-Medium", size: 20)
        
        headerContactView.addSubview(addContactBtn)
        chatTableView.tableHeaderView=headerContactView;
    }
    
    // MARK: - UITableView Delegate Methods

    func tableView(tableView:UITableView!, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat {
        var str : String!
        
        if isGroup == "0" {
                let chatObj = chatArray[indexPath.row] as! UserChat
            
                if chatObj.messageType == "text" {
                    let newString = chatObj.message!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    str = newString.stringByReplacingEmojiCheatCodesWithUnicode()
                    
//                    let fontName = AppHelper .userDefaultForAny("fontName") as String
//                    let fontSize = AppHelper .userDefaultForAny("fontSize") as CGFloat
                    
                    let size : CGSize =  CommonMethodFunctions.sizeOfCell(str, fontSize: 14 , width: 221.0, fontName: "Roboto-Regular")
                    
                    let height = size.height
                    let width = size.width
                    
                    if height < 20 && width < 160 {
                        return height+25
                    } else if height < 35 {
                        return height+20 + 15
                    } else if height < 96 {
                        return height+20 + 17
                    } else if height < 441 {
                        return height+30 + 17
                    } else if height < 882 {
                        return height+30+34
                    } else if height < 1323 {
                        return height+30+51
                    } else if height < 1764 {
                        return height+30+68
                    } else if height < 2205 {
                        return height+30+85
                    } else if height < 2646 {
                        return height+30+102
                    } else {
                        return height+30+119
                    }
                    
                } else if(chatObj.messageType == "notification") {
                    return 40
                    
                } else if(chatObj.messageType == "audio") {
                    return 90
                } else {
                    return 170
                }
        } else {
                let chatObj = chatArray[indexPath.row] as! GroupChat
            
                if chatObj.messageType == "text" {
                    let newString = chatObj.message!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    
                    str = newString.stringByReplacingEmojiCheatCodesWithUnicode()
                    
                 //   let fontName = AppHelper .userDefaultForAny("fontName") as String
                 //   let fontSize = AppHelper .userDefaultForAny("fontSize") as CGFloat
                    
                    let size : CGSize =  CommonMethodFunctions.sizeOfCell(str, fontSize: 14 , width: 221.0, fontName: "Roboto-Regular")
                    
                    let height = size.height
                    let width = size.width
                    
                    if chatObj.senderId != ChatHelper .userDefaultForAny("userId") as? String {
                        
                        if height < 20 && width < 160 {
                            return height+40+5
                            
                        } else if height < 35 {
                            return height+40+10+5
                            
                        } else if height < 96 {
                            return height+40 + 17+5
                            
                        }
                        else if height < 441
                        {
                            return height+50 + 17+5
                            
                        }else if height < 882
                        {
                            return height+50+34+5
                            
                        }else if height < 1323
                        {
                            return height+50+51+5
                            
                        }else if height < 1764
                        {
                            return height+50+68+5
                            
                        }else if height < 2205
                        {
                            return height+50+85+5
                            
                        }else if height < 2646
                        {
                            return height+50+102+5
                        }else
                        {
                            return height+50+119+5
                        }
                        
                    }else
                    {
                        if height < 20 && width < 160
                        {
                            return height+20+5
                            
                        }else if height < 35
                        {
                            return height+20 + 10+5
                            
                        }
                        else if height < 96
                        {
                            return height+20 + 17+5
                        }
                        else if height < 441
                        {
                            return height+30 + 17+5
                            
                        }else if height < 882
                        {
                            return height+30+34+5
                            
                        }else if height < 1323
                        {
                            return height+30+51+5
                            
                        }else if height < 1764
                        {
                            return height+30+68+5
                            
                        }else if height < 2205
                        {
                            return height+30+85+5
                            
                        }else if height < 2646
                        {
                            return height+30+102+5
                        }else
                        {
                            return height+30+119+5
                        }
                    }
                }else if(chatObj.messageType == "notification")
                {
                    return 40
                }else if(chatObj.messageType == "audio")
                {
                    if chatObj.senderId != ChatHelper .userDefaultForAny("userId") as? String
                    {
                        return 110
                    }else
                    {
                        return 90
                    }
                }
                else
                {
                    if chatObj.senderId != ChatHelper .userDefaultForAny("userId") as? String
                    {
                        return 190
                    }else
                    {
                        return 170
                    }
                }

           // }
            /// group chat 
            /*
            var chatObj = chatArray[indexPath.row] as GroupChat
            if chatObj.messageType == "text"
            {
                str = chatObj.message.stringByReplacingEmojiCheatCodesWithUnicode()

                var height =  CommonMethodFunctions.sizeOfCell(str, fontSize: 14, width: 221.0, fontName: "HelveticaNeue")
                if chatObj.senderId != ChatHelper .userDefaultForAny("userId") as NSString
                {
                    if height < 441
                    {
                        return height+50+17
                    }else if height < 882
                    {
                        return height+50+34
                    }else if height < 1323
                    {
                        return height+50+51
                    }else
                    {
                        return height+50+68
                    }
                }else
                {
                    if height < 441
                    {
                        return height+35+17
                    }else if height < 882
                    {
                        return height+35+34
                    }else if height < 1323
                    {
                        return height+35+51
                    }else
                    {
                        return height+35+68
                    }
                }
            }else if(chatObj.messageType == "notification")
            {
                return 40
            }else if(chatObj.messageType == "audio")
            {
                if chatObj.senderId != ChatHelper .userDefaultForAny("userId") as NSString
                {
                    return 110
                }else
                {
                    return 90
                }
                
            }
            else
            {
                if chatObj.senderId != ChatHelper .userDefaultForAny("userId") as NSString
                {
                    return 190
                }else
                {
                    return 170
                }

            }
           */
        }
        
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
         return chatArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell! {
        if isGroup == "0" {
            let chatObj = chatArray[indexPath.row] as! UserChat
            if chatObj.senderId != ChatHelper .userDefaultForAny("userId") as? String {
                
                if chatObj.messageType == "text" {
                    let cell: ChatTextCell = tableView.dequeueReusableCellWithIdentifier("TextChatCell1", forIndexPath: indexPath) as! ChatTextCell
                    cell.selectionStyle = .None
                    
                    let textMessage = cell.contentView.viewWithTag(10) as! UITextView
                    let timeLabel = cell.contentView.viewWithTag(11) as! UILabel
                    let fontName = ChatHelper .userDefaultForAny("fontName") as! String
                    let fontSize = ChatHelper .userDefaultForAny("fontSize") as! CGFloat
                    let bgImageView = cell.contentView.viewWithTag(9) as! UIImageView
                    let myImage = UIImage(named: "recevier_bg.png")!
                    //bgImageView.image = myImage.stretchableImageWithLeftCapWidth(40, topCapHeight: 32);

                    bgImageView.image=myImage.resizableImageWithCapInsets(UIEdgeInsetsMake(17, 27, 21, 17))
                    
                    textMessage.font=UIFont(name: fontName, size: fontSize)
                    textMessage.text = chatObj.message!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByReplacingEmojiCheatCodesWithUnicode()
                    textMessage.scrollEnabled = false
                    var size : CGSize!
                    size = self.sizeForTextView(textMessage.text, font: textMessage.font!)
                    cell.textViewWidthConst.constant = size.width
                    
                    if size.width > 170 {
                        cell.horizontalSpacingConst1.constant = -65
                        cell.timelblsetConst.constant = -8
                    } else {
                        cell.horizontalSpacingConst1.constant = 5
                        cell.timelblsetConst.constant = -2
                    }
                    
                    if isGroup == "1" {
                        //group
                        cell.heightNameLabel.constant = 20
                    } else {
                        //onetoone
                        cell.heightNameLabel.constant = 0
                    }
                 
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "HH:mm:ss.sss"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                    let date = dateFormatter.dateFromString(chatObj.messageTime!)
                    dateFormatter.dateFormat = "hh:mm a"
                    let dateStr = dateFormatter.stringFromDate(date!)
                    timeLabel.text = dateStr
                    return cell
                    
                } else if(chatObj.messageType == "notification") {
                    let cell: ChatNotificationCell = tableView.dequeueReusableCellWithIdentifier("NotificationCell", forIndexPath: indexPath) as! ChatNotificationCell
                    cell.selectionStyle = .None
                    
                    let userImage = cell.contentView.viewWithTag(11) as! UIImageView
                    let today = NSDate()
                    let yesterday = today.dateByAddingTimeInterval(-24 * 60 * 60)
                    
                    let dateLabel = cell.contentView.viewWithTag(10) as! UILabel
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM-dd"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                    dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
                    let date = dateFormatter.dateFromString(chatObj.messageDate!)
                    dateFormatter.dateFormat = "MMMM dd, yyyy"
                    let dateStr = dateFormatter.stringFromDate(date!)
                    let dateStr1 = dateFormatter.stringFromDate(today)
                    let dateStr2 = dateFormatter.stringFromDate(yesterday)
                    
                    if dateStr1 == dateStr {
                        dateLabel.text = "Today"
                    } else if dateStr2 == dateStr {
                        dateLabel.text = "Yesterday"
                    } else {
                        dateLabel.text = dateStr
                    }
                    
                    userImage.layer.masksToBounds = true
                    userImage.layer.cornerRadius = 5.0
                    return cell
                } else if(chatObj.messageType == "audio") {
                    
                    let cell: ChatAudioRecCell = tableView.dequeueReusableCellWithIdentifier("AudioCellReceiver", forIndexPath: indexPath) as! ChatAudioRecCell
                    cell.selectionStyle = .None
                    cell.imageHeightConst.constant = 80
                    let chatImage = cell.contentView.viewWithTag(10) as! UIImageView
                    let timeLabel = cell.contentView.viewWithTag(11) as! UILabel
                    let bgImageView = cell.contentView.viewWithTag(9) as! UIImageView
                    let progressV = cell.contentView.viewWithTag(22) as! PICircularProgressView
                    let downloadBtn = cell.contentView.viewWithTag(23) as! UIButton
                    let playBtn = cell.contentView.viewWithTag(24) as! UIButton
                    let nameLabel = cell.contentView.viewWithTag(60) as! UILabel
                    
                    nameLabel.hidden = true
                    progressV.hidden = true
                    downloadBtn.hidden = true
                    playBtn.hidden = true
                    let myImage = UIImage(named: "recevier_bg.png")!
                    bgImageView.image=myImage.resizableImageWithCapInsets(UIEdgeInsetsMake(17, 27, 21, 17))
                    
                    downloadBtn.addTarget(self, action: #selector(ChattingMainVC.tapOnDownloadBtn(_:)), forControlEvents:
                        UIControlEvents.TouchUpInside)
                    playBtn.addTarget(self, action: #selector(ChattingMainVC.playFileBtnClick(_:)), forControlEvents:
                        UIControlEvents.TouchUpInside)
                    
                    let tempStr = chatObj.chatFile!.mediaLocalPath! as String
                    
                    if tempStr.characters.count > 0 {
                        playBtn.hidden = false
                        downloadBtn.hidden = true
                        
                    } else {
                        playBtn.hidden = true
                        downloadBtn.hidden = false
                    }
                    
                    if let _: AnyObject =     ChatListner .getChatListnerObj().chatProgressV[chatObj.locMessageId!] {
                        downloadBtn.hidden = true
                        progressV.hidden = false
                        ChatListner .getChatListnerObj().chatProgressV[chatObj.locMessageId!] = progressV
                    }
                
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "HH:mm:ss.sss"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                    let date = dateFormatter.dateFromString(chatObj.messageTime!)
                    dateFormatter.dateFormat = "hh:mm a"
                    let dateStr = dateFormatter.stringFromDate(date!)
                    timeLabel.text = dateStr
                    let recognizer = UITapGestureRecognizer(target: self, action:#selector(ChattingMainVC.clickUserImage(_:)))
                    recognizer.delegate = self
                    chatImage.addGestureRecognizer(recognizer)
                    chatImage.userInteractionEnabled = true
                    
                    return cell
                    
                } else {
                    
                    let cell: ChatImageCell = tableView.dequeueReusableCellWithIdentifier("cellImageChat1", forIndexPath: indexPath) as! ChatImageCell
                    cell.imageLeadingConst.constant=18
                    cell.bubbleConstLead.constant=2
                    
                    if isGroup == "1" {
                        cell.nameLabelConst.constant=21
                    } else {
                        cell.nameLabelConst.constant=0
                    }
                    
                    if (IS_IPHONE_5 || IS_IPHONE_4) {
                        cell.imageTrailingConst.constant=88
                        cell.bubbleConstTralng.constant=82
                    } else if (IS_IPHONE_6) {
                        cell.imageTrailingConst.constant=120
                        cell.bubbleConstTralng.constant=114
                    }else {
                        cell.imageTrailingConst.constant=150
                        cell.bubbleConstTralng.constant=144
                    }
                    cell.selectionStyle = .None
                    cell.timerightAlignment.constant = -80
                    let chatImage = cell.contentView.viewWithTag(10) as! UIImageView
                    let timeLabel = cell.contentView.viewWithTag(11) as! UILabel
                    let bgImageView = cell.contentView.viewWithTag(9) as! UIImageView
                    let tickBtn = cell.contentView.viewWithTag(12) as! UIButton
                    let progressV = cell.contentView.viewWithTag(22) as! PICircularProgressView
                    let downloadBtn = cell.contentView.viewWithTag(23) as! UIButton
                    let playBtn = cell.contentView.viewWithTag(24) as! UIButton
                    let videoIcon = cell.contentView.viewWithTag(30) as! UIImageView
                    
                    // Resend Button
                    let resendBtn = cell.contentView.viewWithTag(58) as! UIButton
                    resendBtn.hidden=true
                    
                    resendBtn.addTarget(self, action: #selector(ChattingMainVC.reSendMultiMedia(_:)), forControlEvents:
                        UIControlEvents.TouchUpInside)
                    
                    //
                    videoIcon.hidden = true
                    progressV.hidden = true
                    tickBtn.hidden = true
                    downloadBtn.hidden = true
                    playBtn.hidden = true
                    let myImage = UIImage(named: "recevier_bg.png")!
                    bgImageView.image=myImage.resizableImageWithCapInsets(UIEdgeInsetsMake(17, 27, 21, 17))
                    
                    downloadBtn.addTarget(self, action: #selector(ChattingMainVC.tapOnDownloadBtn(_:)), forControlEvents:
                        UIControlEvents.TouchUpInside)
                    
                    playBtn.addTarget(self, action: #selector(ChattingMainVC.playFileBtnClick(_:)), forControlEvents:
                        UIControlEvents.TouchUpInside)
                    let tempStr = chatObj.chatFile!.mediaLocalThumbPath! as String
                    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
                    let documentsDirectory = paths.stringByAppendingPathComponent("/ChatFile")
                    let getImagePath = documentsDirectory.stringByAppendingPathComponent(tempStr as String)
                    let checkValidation = NSFileManager.defaultManager()
                    
                    if (checkValidation.fileExistsAtPath(getImagePath)) {
                        if chatObj.messageType == "video" {
                            playBtn.hidden = false
                        } else {
                            playBtn.hidden = true
                        }
                        
                        downloadBtn.hidden = true
                        chatImage.image = UIImage(contentsOfFile: getImagePath)
                    } else {
                        playBtn.hidden = true
                        downloadBtn.hidden = false
                        let decodedData = NSData(base64EncodedString: chatObj.chatFile!.mediaThumbUrl!, options: NSDataBase64DecodingOptions(rawValue: 0))
                        
                        if decodedData != nil {
                            chatImage.image = UIImage(data: decodedData!)
                        }
                    }
                    
                    if chatObj.messageType == "video" {
                        videoIcon.hidden = false
                    }else {
                        videoIcon.hidden = true
                    }
                    
                    if let _:AnyObject =     ChatListner .getChatListnerObj().chatProgressV[chatObj.locMessageId!] {
                        downloadBtn.hidden = true
                        progressV.hidden = false
                        ChatListner .getChatListnerObj().chatProgressV[chatObj.locMessageId!] = progressV
                    }
                    
                    chatImage.layer.cornerRadius=5.0
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "HH:mm:ss.sss"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                    let date = dateFormatter.dateFromString(chatObj.messageTime!)
                    dateFormatter.dateFormat = "hh:mm a"
                    let dateStr = dateFormatter.stringFromDate(date!)
                    timeLabel.text = dateStr
                    let recognizer = UITapGestureRecognizer(target: self, action:#selector(ChattingMainVC.clickUserImage(_:)))
                    recognizer.delegate = self
                    chatImage.addGestureRecognizer(recognizer)
                    chatImage.userInteractionEnabled = true
                    
                    
                    // Resend Button
                    if chatObj.messageStatus == "5" {
                        playBtn.hidden = true
                        videoIcon.hidden = true
                        resendBtn.hidden=false
                    }
                    
                    return cell
                }
            } else {
                //
                
                if chatObj.messageType == "text" {
                    
                    let cell: ChatTextCell1 = tableView.dequeueReusableCellWithIdentifier("TextChatCell2", forIndexPath: indexPath) as! ChatTextCell1
                    cell.selectionStyle = .None
                    let bgImageView = cell.contentView.viewWithTag(9) as! UIImageView
                    let textMessage = cell.contentView.viewWithTag(10) as! UITextView
                    let timeLabel = cell.contentView.viewWithTag(11) as! UILabel
                    let tickBtn = cell.contentView.viewWithTag(12) as! UIButton
                    let fontName = ChatHelper .userDefaultForAny("fontName") as! String
                    let fontSize = ChatHelper .userDefaultForAny("fontSize") as! CGFloat
                    textMessage.font=UIFont(name: fontName, size: fontSize)
                    //resendBtn.addTarget(self, action: "buttonResendClicked:", forControlEvents:
                      //  UIControlEvents.TouchUpInside)
                    textMessage.text = chatObj.message!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByReplacingEmojiCheatCodesWithUnicode()
                    
                    
                    //for deliver to server
                    if chatObj.messageStatus == "0" {
                        let image = UIImage(named: "ic_tick_single") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                        
                    } else if chatObj.messageStatus == "1" { //for deliver to receiver
                        let image = UIImage(named: "ic_tick_double") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                        
                    }else if chatObj.messageStatus == "2" {//receiver seen the message
                        let image = UIImage(named: "ic_tick_read") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                    } else {
                        let image = UIImage(named: "ic_chat_pending") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                    }
                    textMessage.scrollEnabled = false
                    var size : CGSize!
                    size = self.sizeForTextView(textMessage.text, font: textMessage.font!)
                    cell.textViewCellWidth1.constant = size.width
                    
                    if size.width > 170 {
                        cell.horizontalSpacingConst.constant = -65
                        cell.timelblsetConst.constant = -8
                        
                    }else {
                        cell.horizontalSpacingConst.constant = 5
                        cell.timelblsetConst.constant = -2
                    }
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "HH:mm:ss.sss"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                    
                    let date = dateFormatter.dateFromString(chatObj.messageTime!)
                    dateFormatter.dateFormat = "hh:mm a"
                    let dateStr = dateFormatter.stringFromDate(date!)
                    timeLabel.text = dateStr
                    
                    let myImage = UIImage(named: "sender_bg.png")!
                    bgImageView.image=myImage.resizableImageWithCapInsets(UIEdgeInsetsMake(17, 27, 21, 17))
                    return cell
                } else if(chatObj.messageType == "notification") {
                    let cell: ChatNotificationCell = tableView.dequeueReusableCellWithIdentifier("NotificationCell", forIndexPath: indexPath) as! ChatNotificationCell
                    cell.selectionStyle = .None
                    let userImage = cell.contentView.viewWithTag(11) as! UIImageView
                    userImage.layer.masksToBounds = true
                    userImage.layer.cornerRadius = 5.0
                    let dateLabel = cell.contentView.viewWithTag(10) as! UILabel
                    
                    let today = NSDate()
                    let yesterday = today.dateByAddingTimeInterval(-24 * 60 * 60)
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM-dd"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                    dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
                    let date = dateFormatter.dateFromString(chatObj.messageDate!)
                    dateFormatter.dateFormat = "MMMM dd, yyyy"
                    let dateStr = dateFormatter.stringFromDate(date!)
                    let dateStr1 = dateFormatter.stringFromDate(today)
                    let dateStr2 = dateFormatter.stringFromDate(yesterday)
                    
                    if dateStr1 == dateStr {
                        dateLabel.text = "Today"
                    } else if dateStr2 == dateStr {
                        dateLabel.text = "Yesterday"
                    } else {
                        dateLabel.text = dateStr
                    }
                    
                    return cell
                } else if(chatObj.messageType == "audio") {
                    let cell: ChatAudioSenderCell = tableView.dequeueReusableCellWithIdentifier("AudioCellSender", forIndexPath: indexPath) as! ChatAudioSenderCell
                    cell.selectionStyle = .None
                    let chatImage = cell.contentView.viewWithTag(10) as! UIImageView
                    let timeLabel = cell.contentView.viewWithTag(11) as! UILabel
                    let bgImageView = cell.contentView.viewWithTag(9) as! UIImageView
                    let tickBtn = cell.contentView.viewWithTag(12) as! UIButton
                    let progressV = cell.contentView.viewWithTag(22) as! PICircularProgressView
                    let downloadBtn = cell.contentView.viewWithTag(23) as! UIButton
                    let playBtn = cell.contentView.viewWithTag(24) as! UIButton
                    playBtn.hidden = true
                    
                    //chakshu
                    let resendBtn = cell.contentView.viewWithTag(58) as! UIButton
                    resendBtn.hidden=true
                    resendBtn.addTarget(self, action: #selector(ChattingMainVC.reSendMultiMedia(_:)), forControlEvents:
                        UIControlEvents.TouchUpInside)
                    
                    downloadBtn.hidden = true
                    progressV.hidden = true
                    tickBtn.hidden = false
                    playBtn.addTarget(self, action: #selector(ChattingMainVC.playFileBtnClick(_:)), forControlEvents:
                        UIControlEvents.TouchUpInside)
                    
                    let myImage = UIImage(named: "sender_bg.png")!
                    bgImageView.image=myImage.resizableImageWithCapInsets(UIEdgeInsetsMake(17, 27, 21, 17))
                    
                    let tempStr = chatObj.chatFile!.mediaLocalPath! as String
                    
                    if tempStr.characters.count > 0 {
                        playBtn.hidden = false
                        
                    } else {
                        playBtn.hidden = true
                    }
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "HH:mm:ss.sss"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                    let date = dateFormatter.dateFromString(chatObj.messageTime!)
                    dateFormatter.dateFormat = "hh:mm a"
                    let dateStr = dateFormatter.stringFromDate(date!)
                    timeLabel.text = dateStr
                    
                    let recognizer = UITapGestureRecognizer(target: self, action:#selector(ChattingMainVC.clickUserImage(_:)))
                    recognizer.delegate = self
                    chatImage.addGestureRecognizer(recognizer)
                    chatImage.userInteractionEnabled = true
                    
                    
                    if let _: AnyObject =     ChatListner .getChatListnerObj().chatProgressV[chatObj.locMessageId!] {
                        progressV.hidden = false
                        playBtn.hidden = true
                        
                        ChatListner .getChatListnerObj().chatProgressV[chatObj.locMessageId!] = progressV
                    }
                    
                    if chatObj.messageStatus == "0" {
                        let image = UIImage(named: "ic_tick_single") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                    } else if chatObj.messageStatus == "1" {
                        let image = UIImage(named: "ic_tick_double") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                    } else if chatObj.messageStatus == "2" {
                        let image = UIImage(named: "ic_tick_read") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                    } else if chatObj.messageStatus == "5" {
                        playBtn.hidden = true
                        resendBtn.hidden=false
                        progressV.hidden = true
                        let image = UIImage(named: "ic_chat_pending") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                    } else {
                        let image = UIImage(named: "ic_chat_pending") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                    }
                    
                    return cell
                    
                } else
                {
                    let cell: ChatImageCell = tableView.dequeueReusableCellWithIdentifier("cellImageChat1", forIndexPath: indexPath) as! ChatImageCell
                    if (IS_IPHONE_5 || IS_IPHONE_4)
                    {
                        cell.imageLeadingConst.constant=88
                        cell.bubbleConstLead.constant=82
                    }
                    else if (IS_IPHONE_6)
                    {
                        cell.imageLeadingConst.constant=120
                        cell.bubbleConstLead.constant=114
                    }else
                    {
                        cell.imageLeadingConst.constant=150
                        cell.bubbleConstLead.constant=144
                    }
                    cell.timerightAlignment.constant = -100
                    cell.nameLabelConst.constant=0
                    cell.bubbleConstTralng.constant=2
                    cell.imageTrailingConst.constant=18
                    cell.selectionStyle = .None
                    
                    let chatImage = cell.contentView.viewWithTag(10) as! UIImageView
                    let timeLabel = cell.contentView.viewWithTag(11) as! UILabel
                    let bgImageView = cell.contentView.viewWithTag(9) as! UIImageView
                    let tickBtn = cell.contentView.viewWithTag(12) as! UIButton
                    let progressV = cell.contentView.viewWithTag(22) as! PICircularProgressView
                    let downloadBtn = cell.contentView.viewWithTag(23) as! UIButton
                    let playBtn = cell.contentView.viewWithTag(24) as! UIButton
                    
                    // Resend Button
                    let resendBtn = cell.contentView.viewWithTag(58) as! UIButton
                    resendBtn.hidden=true
                    resendBtn.addTarget(self, action: #selector(ChattingMainVC.reSendMultiMedia(_:)), forControlEvents:
                        UIControlEvents.TouchUpInside)
                    playBtn.hidden = true
                    downloadBtn.hidden = true
                    progressV.hidden = true
                    tickBtn.hidden = false
                    playBtn.addTarget(self, action: #selector(ChattingMainVC.playFileBtnClick(_:)), forControlEvents:
                        UIControlEvents.TouchUpInside)
                    
                    let myImage = UIImage(named: "sender_bg.png")!
                    bgImageView.image=myImage.resizableImageWithCapInsets(UIEdgeInsetsMake(17, 27, 21, 17))
                    
                    let tempStr = chatObj.chatFile!.mediaLocalThumbPath! as String
                    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
                    let documentsDirectory = paths.stringByAppendingPathComponent("/ChatFile")
               
                    let getImagePath = documentsDirectory.stringByAppendingPathComponent(tempStr)
                    let checkValidation = NSFileManager.defaultManager()
                    
                    if (checkValidation.fileExistsAtPath(getImagePath))
                    {
                        if chatObj.messageType == "video"
                        {
                            //print_debug(" Media messageId")
                            //  button_chat_retry
                            
                            playBtn.hidden = false
                            
                        }else
                        
                        {
                            playBtn.hidden = true
                        }
                        chatImage.image = UIImage(contentsOfFile: getImagePath)
                    }else
                    {
                        playBtn.hidden = true
                        chatImage.image=UIImage(named:"ic_booking_profilepic")
                    }
                    
                    let videoIcon = cell.contentView.viewWithTag(30) as! UIImageView
                    videoIcon.hidden = true
                    if chatObj.messageType == "video"
                    {
                        videoIcon.hidden = false
                        
                    }else
                    {
                        videoIcon.hidden = true
                    }
                    chatImage.layer.cornerRadius=5.0
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "HH:mm:ss.sss"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                    let date = dateFormatter.dateFromString(chatObj.messageTime!)
                    dateFormatter.dateFormat = "hh:mm a"
                    let dateStr = dateFormatter.stringFromDate(date!)
                    timeLabel.text = dateStr
                    let recognizer = UITapGestureRecognizer(target: self, action:#selector(ChattingMainVC.clickUserImage(_:)))
                    recognizer.delegate = self
                    chatImage.addGestureRecognizer(recognizer)
                    chatImage.userInteractionEnabled = true
                    
                    if chatObj.messageStatus == "0"
                    {
                        let image = UIImage(named: "ic_tick_single") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                        
                    }else if chatObj.messageStatus == "1"
                        
                    {
                        let image = UIImage(named: "ic_tick_double") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                    }else if chatObj.messageStatus == "2"
                    {
                        let image = UIImage(named: "ic_tick_read") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                    }
                    else  if chatObj.messageStatus == "5"
                    {
                        // Resend Button
                        playBtn.hidden = true
                        videoIcon.hidden = true
                        resendBtn.hidden=false
                        let image = UIImage(named: "ic_chat_pending") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                        
                        
                    }
                        
                    else
                    {
                        let image = UIImage(named: "ic_chat_pending") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                    }
                    
                    
                    if let _: AnyObject = ChatListner .getChatListnerObj().chatProgressV[chatObj.locMessageId!]
                    {
                       // print_debug("val")
                        //print_debug(val)
                        progressV.hidden = false
                        playBtn.hidden = true
                        ChatListner .getChatListnerObj().chatProgressV[chatObj.locMessageId!] = progressV
                    }
                    return cell
                }
            }
        }else
        {
            let chatObj = chatArray[indexPath.row] as! GroupChat
            if chatObj.senderId != ChatHelper .userDefaultForAny("userId") as? String
            {
                if chatObj.messageType == "text"
                {
                    let cell: ChatTextCell = tableView.dequeueReusableCellWithIdentifier("TextChatCell1", forIndexPath: indexPath) as! ChatTextCell
                    cell.selectionStyle = .None
                    
                    let nameLabel = cell.contentView.viewWithTag(13) as! UILabel
                    let textMessage = cell.contentView.viewWithTag(10) as! UITextView
                    let timeLabel = cell.contentView.viewWithTag(11) as! UILabel
                    let fontName = ChatHelper .userDefaultForAny("fontName") as! String
                    let fontSize = ChatHelper .userDefaultForAny("fontSize") as! CGFloat
                    let bgImageView = cell.contentView.viewWithTag(9) as! UIImageView
                    let myImage = UIImage(named: "recevier_bg.png")!
                    
                    bgImageView.image = myImage.resizableImageWithCapInsets(UIEdgeInsetsMake(17, 27, 21, 17))
                    let tintedImage = myImage.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                    bgImageView.image = tintedImage
                    bgImageView.tintColor = getRandomColor(chatObj.senderId!)
                    
                    textMessage.font=UIFont(name: fontName, size: fontSize)
                    textMessage.text = chatObj.message!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByReplacingEmojiCheatCodesWithUnicode()
                    nameLabel.text = chatObj.senderName
                    textMessage.scrollEnabled = false
                    var size : CGSize!
                    size = self.sizeForTextView(textMessage.text, font: textMessage.font!)
                    let widthName =  CommonMethodFunctions.widthOfText(chatObj.senderName, fontSize: 12, height: 21.0, fontName: "Roboto-Regular")
                    if size.width < widthName
                    {
                        cell.textViewWidthConst.constant = widthName
                        if widthName > 150
                        {
                            cell.horizontalSpacingConst1.constant = -65
                        }else
                        {
                            cell.horizontalSpacingConst1.constant = 5
                        }
                    }
                    else
                    {
                        cell.textViewWidthConst.constant = size.width
                        if size.width > 170
                        {
                            cell.horizontalSpacingConst1.constant = -65
                            cell.timelblsetConst.constant = -8
                        }else
                        {
                            cell.horizontalSpacingConst1.constant = 5
                            cell.timelblsetConst.constant = -2
                        }
                        
                    }
                    if isGroup == "1"
                    {
                        //group
                        cell.heightNameLabel.constant = 20
                    }else
                    {
                        //onetoone
                        cell.heightNameLabel.constant = 0
                    }
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "HH:mm:ss.sss"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                    let date = dateFormatter.dateFromString(chatObj.messageTime!)
                    dateFormatter.dateFormat = "hh:mm a"
                    let dateStr = dateFormatter.stringFromDate(date!)
                    timeLabel.text = dateStr
                    return cell
                }else if(chatObj.messageType == "notification")
                {
                    let cell: ChatNotificationCell = tableView.dequeueReusableCellWithIdentifier("NotificationCell", forIndexPath: indexPath) as! ChatNotificationCell
                    cell.selectionStyle = .None
                    
                    let today = NSDate()
                    let yesterday = today.dateByAddingTimeInterval(-24 * 60 * 60)
                    
                    let userImage = cell.contentView.viewWithTag(11) as! UIImageView
                    userImage.layer.masksToBounds = true
                    userImage.layer.cornerRadius = 5.0
                    let dateLabel = cell.contentView.viewWithTag(10) as! UILabel
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM-dd"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                    dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
                    let date = dateFormatter.dateFromString(chatObj.messageDate!)
                    dateFormatter.dateFormat = "MMMM dd, yyyy"
                    let dateStr = dateFormatter.stringFromDate(date!)
                    let dateStr1 = dateFormatter.stringFromDate(today)
                    let dateStr2 = dateFormatter.stringFromDate(yesterday)
                    if dateStr1 == dateStr
                    {
                        dateLabel.text = "Today"
                    }else if dateStr2 == dateStr
                    {
                        dateLabel.text = "Yesterday"
                    }
                    else
                    {
                        dateLabel.text = dateStr
                    }
                    return cell
                    
                }else if(chatObj.messageType == "audio")
                {
                    let cell: ChatAudioRecCell = tableView.dequeueReusableCellWithIdentifier("AudioCellReceiver", forIndexPath: indexPath) as! ChatAudioRecCell
                    cell.selectionStyle = .None
                    cell.imageHeightConst.constant = 100
                    let chatImage = cell.contentView.viewWithTag(10) as! UIImageView
                    let timeLabel = cell.contentView.viewWithTag(11) as! UILabel
                    let bgImageView = cell.contentView.viewWithTag(9) as! UIImageView
                    let progressV = cell.contentView.viewWithTag(22) as! PICircularProgressView
                    let downloadBtn = cell.contentView.viewWithTag(23) as! UIButton
                    let playBtn = cell.contentView.viewWithTag(24) as! UIButton
                    let nameLabel = cell.contentView.viewWithTag(60) as! UILabel
                    
                   
                    
                    progressV.hidden = true
                    downloadBtn.hidden = true
                    playBtn.hidden = true
                    nameLabel.hidden = false
                    nameLabel.text = chatObj.senderName
                    let myImage = UIImage(named: "recevier_bg.png")!
                    bgImageView.image=myImage.resizableImageWithCapInsets(UIEdgeInsetsMake(17, 27, 21, 17))
                    
                    downloadBtn.addTarget(self, action: #selector(ChattingMainVC.tapOnDownloadBtn(_:)), forControlEvents:
                        UIControlEvents.TouchUpInside)
                    playBtn.addTarget(self, action: #selector(ChattingMainVC.playFileBtnClick(_:)), forControlEvents:
                        UIControlEvents.TouchUpInside)
                    
                    let tempStr = chatObj.groupChatFile!.mediaLocalPath! as String
                    if tempStr.characters.count > 0
                    {
                        playBtn.hidden = false
               
                        
                        downloadBtn.hidden = true
                    }else
                    {
                        playBtn.hidden = true
                        downloadBtn.hidden = false
                    }
                    
                    if ([chatObj.locMessageId] != nil)
                    {
                        if ((ChatListner .getChatListnerObj().chatProgressV[chatObj.locMessageId!] as? String) != nil)
          
    
                        
                        
                        
                        
                        {
                            downloadBtn.hidden = true
                            
                            progressV.hidden = false
                            
                            ChatListner .getChatListnerObj().chatProgressV[chatObj.locMessageId!] = progressV
                            
                        }
                    }
                    
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "HH:mm:ss.sss"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                    let date = dateFormatter.dateFromString(chatObj.messageTime!)
                    dateFormatter.dateFormat = "hh:mm a"
                    let dateStr = dateFormatter.stringFromDate(date!)
                    timeLabel.text = dateStr
                    let recognizer = UITapGestureRecognizer(target: self, action:#selector(ChattingMainVC.clickUserImage(_:)))
                    recognizer.delegate = self
                    chatImage.addGestureRecognizer(recognizer)
                    chatImage.userInteractionEnabled = true
   
                    
                    return cell
                    
                }
                else
                {
                    let cell: ChatImageCell = tableView.dequeueReusableCellWithIdentifier("cellImageChat1", forIndexPath: indexPath) as! ChatImageCell
                    cell.imageLeadingConst.constant=18
                    cell.bubbleConstLead.constant=2
                    if isGroup == "1"
                    {
                        cell.nameLabelConst.constant=21
                    }else
                    {
                        cell.nameLabelConst.constant=0
                    }
                    
                    if (IS_IPHONE_5 || IS_IPHONE_4)
                    {
                        cell.imageTrailingConst.constant=88
                        cell.bubbleConstTralng.constant=82
                    }
                    else if (IS_IPHONE_6)
                    {
                        cell.imageTrailingConst.constant=120
                        cell.bubbleConstTralng.constant=114
                    }else
                    {
                        cell.imageTrailingConst.constant=150
                        cell.bubbleConstTralng.constant=144
                    }
                    cell.selectionStyle = .None
                    cell.timerightAlignment.constant = -80
                    let chatImage = cell.contentView.viewWithTag(10) as! UIImageView
                    let timeLabel = cell.contentView.viewWithTag(11) as! UILabel
                    let bgImageView = cell.contentView.viewWithTag(9) as! UIImageView
                    let tickBtn = cell.contentView.viewWithTag(12) as! UIButton
                    let nameLabel = cell.contentView.viewWithTag(13) as! UILabel
                    let progressV = cell.contentView.viewWithTag(22) as! PICircularProgressView
                    let downloadBtn = cell.contentView.viewWithTag(23) as! UIButton
                    let playBtn = cell.contentView.viewWithTag(24) as! UIButton
                    let videoIcon = cell.contentView.viewWithTag(30) as! UIImageView
                    
                    // Resend Button
                    let resendBtn = cell.contentView.viewWithTag(58) as! UIButton
                    resendBtn.hidden=true
                    resendBtn.addTarget(self, action: #selector(ChattingMainVC.reSendMultiMedia(_:)), forControlEvents:
                        UIControlEvents.TouchUpInside)
                    videoIcon.hidden = true
                    playBtn.hidden = true
                    downloadBtn.hidden = true
                    progressV.hidden = true
                    nameLabel.text = chatObj.senderName
                    tickBtn.hidden = true
                    
                    downloadBtn.addTarget(self, action: #selector(ChattingMainVC.tapOnDownloadBtn(_:)), forControlEvents:
                        UIControlEvents.TouchUpInside)
                    playBtn.addTarget(self, action: #selector(ChattingMainVC.playFileBtnClick(_:)), forControlEvents:
                        UIControlEvents.TouchUpInside)
                    
                    let myImage = UIImage(named: "recevier_bg.png")!
                    bgImageView.image=myImage.resizableImageWithCapInsets(UIEdgeInsetsMake(17, 27, 21, 17))
                    
                    
                    let tempStr = chatObj.groupChatFile!.mediaLocalThumbPath! as String
                    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
                    let documentsDirectory = paths.stringByAppendingPathComponent("/ChatFile")
                    let getImagePath = documentsDirectory.stringByAppendingPathComponent(tempStr)
                    let checkValidation = NSFileManager.defaultManager()
                    if (checkValidation.fileExistsAtPath(getImagePath))
                    {
                        if chatObj.messageType == "video"
                        {
                            playBtn.hidden = false
                        }else
                        {
                            playBtn.hidden = true
                        }
                        downloadBtn.hidden = true
                        chatImage.image = UIImage(contentsOfFile: getImagePath)
                    }else
                    {
                        playBtn.hidden = true
                        downloadBtn.hidden = false
                        let decodedData = NSData(base64EncodedString: chatObj.groupChatFile!.mediaThumbUrl!, options: NSDataBase64DecodingOptions(rawValue: 0))
                        
                        if decodedData != nil
                        {
                            chatImage.image = UIImage(data: decodedData!)
                        }
                    }
                    
                    
                    if chatObj.messageType == "video"
                    {
                        videoIcon.hidden = false
                    }else
                    {
                        videoIcon.hidden = true
                    }
                    
                    if ([chatObj.locMessageId] != nil)
                    {
                        if let _:AnyObject =     ChatListner .getChatListnerObj().chatProgressV[chatObj.locMessageId!]
                        {
                            downloadBtn.hidden = true
                            progressV.hidden = false
                            ChatListner .getChatListnerObj().chatProgressV[chatObj.locMessageId!] = progressV
                        }
                    }
                    // Resend Button
                    if chatObj.messageStatus == "5"
                    {
                        playBtn.hidden = true
                        videoIcon.hidden = true
                        resendBtn.hidden=false
                        
                    }
                    
                    chatImage.layer.cornerRadius=5.0
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "HH:mm:ss.sss"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                    let date = dateFormatter.dateFromString(chatObj.messageTime!)
                    dateFormatter.dateFormat = "hh:mm a"
                    let dateStr = dateFormatter.stringFromDate(date!)
                    timeLabel.text = dateStr
                    
                    
                    
                    let recognizer = UITapGestureRecognizer(target: self, action:#selector(ChattingMainVC.clickUserImage(_:)))
                    recognizer.delegate = self
                    chatImage.addGestureRecognizer(recognizer)
                    chatImage.userInteractionEnabled = true
                    
                    return cell
                }
            }else
            {
                if chatObj.messageType == "text"
                {
                    let cell: ChatTextCell1 = tableView.dequeueReusableCellWithIdentifier("TextChatCell2", forIndexPath: indexPath) as! ChatTextCell1
                    cell.selectionStyle = .None
                    
                    let bgImageView = cell.contentView.viewWithTag(9) as! UIImageView
                    let textMessage = cell.contentView.viewWithTag(10) as! UITextView
                    let timeLabel = cell.contentView.viewWithTag(11) as! UILabel
                    let tickBtn = cell.contentView.viewWithTag(12) as! UIButton
                    
                    let fontName = ChatHelper .userDefaultForAny("fontName") as! String
                    let fontSize = ChatHelper .userDefaultForAny("fontSize") as! CGFloat
                    textMessage.font=UIFont(name: fontName, size: fontSize)
                    //resendBtn.addTarget(self, action: "buttonResendClicked:", forControlEvents:
                      //  UIControlEvents.TouchUpInside)
                    textMessage.text = chatObj.message!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByReplacingEmojiCheatCodesWithUnicode()
                    if chatObj.messageStatus == "0"
                    {
                        let image = UIImage(named: "ic_tick_single") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                    }else if chatObj.messageStatus == "1"
                    {
                        let image = UIImage(named: "ic_tick_double") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                    }else if chatObj.messageStatus == "2"
                    {
                        let image = UIImage(named: "ic_tick_read") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                    }
                    else
                    {
                        let image = UIImage(named: "ic_chat_pending") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                    }
                    
                    textMessage.scrollEnabled = false
                    var size : CGSize!
                    size = self.sizeForTextView(textMessage.text, font: textMessage.font!)
                    cell.textViewCellWidth1.constant = size.width
                    
                    if size.width > 150
                    {
                        cell.horizontalSpacingConst.constant = -65
                    }else
                    {
                        cell.horizontalSpacingConst.constant = 5
                    }
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "HH:mm:ss.sss"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                    let date = dateFormatter.dateFromString(chatObj.messageTime!)
                    dateFormatter.dateFormat = "hh:mm a"
                    let dateStr = dateFormatter.stringFromDate(date!)
                    timeLabel.text = dateStr
                    
                    let myImage = UIImage(named: "sender_bg.png")!
                    bgImageView.image=myImage.resizableImageWithCapInsets(UIEdgeInsetsMake(17, 27, 21, 17))
                    return cell
                }else if(chatObj.messageType == "notification")
                {
                    
                    let cell: ChatNotificationCell = tableView.dequeueReusableCellWithIdentifier("NotificationCell", forIndexPath: indexPath) as! ChatNotificationCell
                    cell.selectionStyle = .None
                    let today = NSDate()
                    let yesterday = today.dateByAddingTimeInterval(-24 * 60 * 60)
                    
                    let userImage = cell.contentView.viewWithTag(11) as! UIImageView
                    userImage.layer.masksToBounds = true
                    userImage.layer.cornerRadius = 5.0
                    let dateLabel = cell.contentView.viewWithTag(10) as! UILabel
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM-dd"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                    dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
                    let date = dateFormatter.dateFromString(chatObj.messageDate!)
                    dateFormatter.dateFormat = "MMMM dd, yyyy"
                    let dateStr = dateFormatter.stringFromDate(date!)
                    let dateStr1 = dateFormatter.stringFromDate(today)
                    let dateStr2 = dateFormatter.stringFromDate(yesterday)
                    if dateStr1 == dateStr
                    {
                        dateLabel.text = "Today"
                    }else if dateStr2 == dateStr
                    {
                        dateLabel.text = "Yesterday"
                    }
                    else
                    {
                        dateLabel.text = dateStr
                    }
                    return cell
                    
                }else if(chatObj.messageType == "audio")
                {
                    let cell: ChatAudioSenderCell = tableView.dequeueReusableCellWithIdentifier("AudioCellSender", forIndexPath: indexPath) as! ChatAudioSenderCell
                    cell.selectionStyle = .None
                    
                    let chatImage = cell.contentView.viewWithTag(10) as! UIImageView
                    let timeLabel = cell.contentView.viewWithTag(11) as! UILabel
                    let bgImageView = cell.contentView.viewWithTag(9) as! UIImageView
                    let tickBtn = cell.contentView.viewWithTag(12) as! UIButton
                    let progressV = cell.contentView.viewWithTag(22) as! PICircularProgressView
                    let downloadBtn = cell.contentView.viewWithTag(23) as! UIButton
                    let playBtn = cell.contentView.viewWithTag(24) as! UIButton
                    playBtn.hidden = true
                    downloadBtn.hidden = true
                    progressV.hidden = true
                    tickBtn.hidden = false
                    playBtn.addTarget(self, action: #selector(ChattingMainVC.playFileBtnClick(_:)), forControlEvents:
                        UIControlEvents.TouchUpInside)
                    
                    //chakshu
                    let resendBtn = cell.contentView.viewWithTag(58) as! UIButton
                    resendBtn.hidden=true
                    resendBtn.addTarget(self, action: #selector(ChattingMainVC.reSendMultiMedia(_:)), forControlEvents:
                        UIControlEvents.TouchUpInside)
                    
                    
                    
                    let myImage = UIImage(named: "sender_bg.png")!
                    bgImageView.image=myImage.resizableImageWithCapInsets(UIEdgeInsetsMake(17, 27, 21, 17))
                    let tempStr = chatObj.groupChatFile!.mediaLocalPath! as String
                    if tempStr.characters.count > 0
                    {
                        playBtn.hidden = false
                    }else
      
                    {
                        playBtn.hidden = true
                    }
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "HH:mm:ss.sss"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                    let date = dateFormatter.dateFromString(chatObj.messageTime!)
                    dateFormatter.dateFormat = "hh:mm a"
                    let dateStr = dateFormatter.stringFromDate(date!)
                    timeLabel.text = dateStr
             
                    
                    let recognizer = UITapGestureRecognizer(target: self, action:#selector(ChattingMainVC.clickUserImage(_:)))
                    recognizer.delegate = self
                    chatImage.addGestureRecognizer(recognizer)
                    chatImage.userInteractionEnabled = true
                    
                    if let _: AnyObject =     ChatListner .getChatListnerObj().chatProgressV[chatObj.locMessageId!]
                    {
                        
                        progressV.hidden = false
                        playBtn.hidden = true
                        
                        
                        ChatListner .getChatListnerObj().chatProgressV[chatObj.locMessageId!] = progressV
                    }
                    
                    if chatObj.messageStatus == "0"
                    {
                        let image = UIImage(named: "ic_tick_single") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                    }else if chatObj.messageStatus == "1"
                    {
                        let image = UIImage(named: "ic_tick_double") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                    }else if chatObj.messageStatus == "2"
                    {
                        let image = UIImage(named: "ic_tick_read") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                    }
                    else if chatObj.messageStatus == "5"
                    {
                        playBtn.hidden = true
                        resendBtn.hidden=false
                        progressV.hidden = true
                        let image = UIImage(named: "ic_chat_pending") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                    }
                        
                        
                    else
                    {
                        let image = UIImage(named: "ic_chat_pending") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                    }
                    
                    
                    return cell
                    
                }
                else
                {
                    let cell: ChatImageCell = tableView.dequeueReusableCellWithIdentifier("cellImageChat1", forIndexPath: indexPath) as! ChatImageCell
                    if (IS_IPHONE_5 || IS_IPHONE_4)
                    {
                        cell.imageLeadingConst.constant=88
                        cell.bubbleConstLead.constant=82
                    }
                    else if (IS_IPHONE_6)
                    {
                        cell.imageLeadingConst.constant=120
                        cell.bubbleConstLead.constant=114
                    }else
                    {
                        cell.imageLeadingConst.constant=150
                        cell.bubbleConstLead.constant=144
                    }
                    cell.nameLabelConst.constant=0
                    cell.bubbleConstTralng.constant=2
                    cell.imageTrailingConst.constant=18
                    cell.selectionStyle = .None
                    
                    let chatImage = cell.contentView.viewWithTag(10) as! UIImageView
                    let timeLabel = cell.contentView.viewWithTag(11) as! UILabel
                    let bgImageView = cell.contentView.viewWithTag(9) as! UIImageView
                    let tickBtn = cell.contentView.viewWithTag(12) as! UIButton
                    let progressV = cell.contentView.viewWithTag(22) as! PICircularProgressView
                    let downloadBtn = cell.contentView.viewWithTag(23) as! UIButton
                    let playBtn = cell.contentView.viewWithTag(24) as! UIButton
                    
                    // Resend Button
                    let resendBtn = cell.contentView.viewWithTag(58) as! UIButton
                    resendBtn.hidden=true
                    resendBtn.addTarget(self, action: #selector(ChattingMainVC.reSendMultiMedia(_:)), forControlEvents:
                        UIControlEvents.TouchUpInside)
                    playBtn.hidden = true
                    
                    playBtn.addTarget(self, action: #selector(ChattingMainVC.playFileBtnClick(_:)), forControlEvents:
                        UIControlEvents.TouchUpInside)
                    
                    downloadBtn.hidden = true
                    progressV.hidden = true
                    let myImage = UIImage(named: "sender_bg.png")!
                    bgImageView.image=myImage.resizableImageWithCapInsets(UIEdgeInsetsMake(17, 27, 21, 17))
                    let tempStr = chatObj.groupChatFile!.mediaLocalThumbPath! as String
                    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
                    let documentsDirectory = paths.stringByAppendingPathComponent("/ChatFile")
                    let getImagePath = documentsDirectory.stringByAppendingPathComponent(tempStr)
                    let checkValidation = NSFileManager.defaultManager()
                    
                    if (checkValidation.fileExistsAtPath(getImagePath)) {
                        
                        if chatObj.messageType == "video" {
                            playBtn.hidden = false
                        } else {
                            playBtn.hidden = true
                        }
                        
                        chatImage.image = UIImage(contentsOfFile: getImagePath)
                    }else
                    {
                        playBtn.hidden = true
                        chatImage.image=UIImage(named:"ic_booking_profilepic")
                    }
                    
                    let videoIcon = cell.contentView.viewWithTag(30) as! UIImageView
                    videoIcon.hidden = true
                    
                    if chatObj.messageType == "video"
                    {
                        videoIcon.hidden = false
                    }else
                    {
                        videoIcon.hidden = true
                    }
                    
                    chatImage.layer.cornerRadius=5.0
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "HH:mm:ss.sss"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                    let date = dateFormatter.dateFromString(chatObj.messageTime!)
                    dateFormatter.dateFormat = "hh:mm a"
                    let dateStr = dateFormatter.stringFromDate(date!)
                    timeLabel.text = dateStr
                    
                    let recognizer = UITapGestureRecognizer(target: self, action:#selector(ChattingMainVC.clickUserImage(_:)))
                    recognizer.delegate = self
                    chatImage.addGestureRecognizer(recognizer)
                    chatImage.userInteractionEnabled = true
                    
                    if chatObj.messageStatus == "0"
                    {
                        let image = UIImage(named: "ic_tick_single") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                    }else if chatObj.messageStatus == "1"
                    {
                        let image = UIImage(named: "ic_tick_double") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                    }else if chatObj.messageStatus == "2"
                    {
                        let image = UIImage(named: "ic_tick_read") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                    }
                    else  if chatObj.messageStatus == "5"
                    {
                        // Resend Button
                        playBtn.hidden = true
                        videoIcon.hidden = true
                        resendBtn.hidden=false
                        let image = UIImage(named: "ic_chat_pending") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                    }
                    else
                    {
                        let image = UIImage(named: "ic_chat_pending") as UIImage!
                        tickBtn.setImage(image, forState: .Normal)
                    }
                    
                    if let _: AnyObject =     ChatListner .getChatListnerObj().chatProgressV[chatObj.locMessageId!]
                    {

                        progressV.hidden = false
                        playBtn.hidden = true
                        
                        ChatListner .getChatListnerObj().chatProgressV[chatObj.locMessageId!] = progressV
                    }
                    return cell
                }
                
            }
        }
        
    }
    
    func getRandomColor(userID:String) -> UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())
        
        let randomGreen:CGFloat = CGFloat(drand48())
        
        let randomBlue:CGFloat = CGFloat(drand48())
        
        if(colorDict[userID]==nil)
        {
            colorDict[userID]=UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 0.3)
        }
        return colorDict[userID] as! UIColor
        
    }
    
    //MARK: - Download Button Method
    
    @IBAction func tapOnDownloadBtn(sender: UIButton)
    {
        
        let pointInTable = sender.convertPoint(sender.bounds.origin, toView: chatTableView)
        let indexPath:NSIndexPath = chatTableView.indexPathForRowAtPoint(pointInTable)!
        let cell = sender.tableViewCell() as UITableViewCell!
        
        var chatObj : UserChat!
        var grpChatObj : GroupChat!
        
        var progressV = cell.contentView.viewWithTag(22) as! PICircularProgressView
        let downloadBtn = cell.contentView.viewWithTag(23) as! UIButton
        let chatImage = cell.contentView.viewWithTag(10) as! UIImageView
        let playBtn = cell.contentView.viewWithTag(24) as! UIButton
        playBtn.hidden = true
        progressV.hidden = false
        downloadBtn.hidden = true
        
        var localStr : String! = ""
        var imageNameStr : String!
        var checkfile : String!
        
        if isGroup == "0"
        {
            chatObj = chatArray[indexPath.row] as! UserChat
            
            ChatListner .getChatListnerObj().chatProgressV[chatObj.locMessageId!] = progressV
            
            // downloading
            //HIDE++++++++
            localStr = chatCDNbaseUrl + "/" + chatObj.chatFile!.mediaUrl!
            //print(localStr)
            imageNameStr = chatObj.chatFile!.mediaUrl
            
            
        }else
        {
            grpChatObj = chatArray[indexPath.row] as! GroupChat
            
            ChatListner .getChatListnerObj().chatProgressV[grpChatObj.locMessageId!] = progressV
            
            
            // localStr = ChatBaseMediaUrl + "?" + grpChatObj.groupChatFile.mediaUrl
            //HIDE++++++++
            localStr = chatCDNbaseUrl + "/" + grpChatObj.groupChatFile!.mediaUrl!
            
            imageNameStr = grpChatObj.groupChatFile!.mediaUrl
            
        }
        
        let request: NSURLRequest = NSURLRequest(URL: NSURL(string: localStr)!)
        let operation: AFHTTPRequestOperation = AFHTTPRequestOperation(request: request) as AFHTTPRequestOperation
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let documentsDirectory = paths.stringByAppendingPathComponent("/ChatFile")
        let fileManager = NSFileManager.defaultManager()
        
        do {
            try fileManager.createDirectoryAtPath(documentsDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
        
        var saveThumbImagePath = "Thumb"+imageNameStr
        saveThumbImagePath = saveThumbImagePath.stringByReplacingOccurrencesOfString(".mp4", withString: ".jpg")
        let saveImagePath = documentsDirectory.stringByAppendingPathComponent(saveThumbImagePath)
        checkfile = ""
        
        
        if isGroup == "0"
        {
            if chatObj.messageType == "video"
            {
                checkfile = ".mp4"
                
            }
            else if chatObj.messageType == "audio"
            {
                checkfile = ".wav"
            }
        }else
        {
            if grpChatObj.messageType == "video"
            {
                checkfile = ".mp4"
                
            }
            else if grpChatObj.messageType == "audio"
            {
                checkfile = ".wav"
            }
        }
        let saveFullImagePath = "full" + imageNameStr + checkfile
        
        let saveImagePathFull = documentsDirectory.stringByAppendingPathComponent(saveFullImagePath)
        
        let instance = DataBaseController.sharedInstance
        operation.outputStream = NSOutputStream(toFileAtPath: saveImagePathFull, append: false)
        
        operation .setDownloadProgressBlock { (bytesWritten : UInt, totalBytesWritten : Int64, totalBytesExpectedToRead: Int64) -> Void in
            let progress: Double =  Double(totalBytesWritten) / Double(totalBytesExpectedToRead);
            if self.isGroup == "0"
            {
                if chatObj.locMessageId != "0"
                {
                    progressV = ChatListner .getChatListnerObj().chatProgressV[chatObj.locMessageId!
                        ] as! PICircularProgressView
                }else
                {
                    return ;
                }
            }else
            {
                if grpChatObj.locMessageId != "0"
                {
                    progressV =     ChatListner .getChatListnerObj().chatProgressV[grpChatObj.locMessageId!] as! PICircularProgressView
                }else
                {
                    return ;
                    
                }
            }
            
            progressV.progress=fabs(progress);
        }
        operation.setCompletionBlockWithSuccess({ (operation : AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            progressV.hidden = true
            if self.isGroup == "0"
            {
                if chatObj.messageType == "image"
                {
                    
                    let tempImage: UIImage =  UIImage(contentsOfFile: saveImagePathFull)!
                    let thumbImg1 = CommonMethodFunctions.generatePhotoThumbnail1(tempImage);
                    chatImage.image =  thumbImg1
                    let data2 = UIImageJPEGRepresentation(thumbImg1, 1.0)
                    data2!.writeToFile(saveImagePath, atomically: true)
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        // Set the imageView's image to the image we just saved.
                        UIImageWriteToSavedPhotosAlbum(UIImage(contentsOfFile: saveImagePath)!, nil, nil, nil);
                        
                    });
                    
                    var passDic = Dictionary<String,AnyObject>()
                    passDic["imagePath"] = saveImagePathFull as String!
                    NSNotificationCenter.defaultCenter().postNotificationName("showImageFOrFullScreen", object: nil, userInfo: passDic)
                    
                }
                else if chatObj.messageType == "video"
                {
                    playBtn.hidden = false
                    let fileURL=NSURL.fileURLWithPath(saveImagePathFull)
                   // print(saveImagePathFull)
                    let thumbImg = CommonMethodFunctions.getThumbNail(fileURL);
                    if thumbImg != nil
                    {
                        chatImage.image =  thumbImg
                        let data2 = UIImageJPEGRepresentation(thumbImg, 1.0)
                        data2!.writeToFile(saveImagePath, atomically: true)
                    }
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        // Set the imageView's image to the image we just saved.
                        UISaveVideoAtPathToSavedPhotosAlbum(saveImagePath,nil,nil,nil);
                        
                    });
                }else if  chatObj.messageType == "audio"
                {
                    playBtn.hidden = false
                }
                
                ChatListner .getChatListnerObj().chatProgressV.removeObjectForKey(chatObj.locMessageId!)
                if chatObj.messageType != "audio"
                {
                    instance.UpdateChatLocalPath(chatObj, fullImgStr: saveFullImagePath, thumbImgStr: saveThumbImagePath)
                }else
                {
                    instance.UpdateChatLocalPath(chatObj, fullImgStr: saveFullImagePath, thumbImgStr: "")
                }
            }else
            {
                if grpChatObj.messageType == "image"
                {
                    let tempImage: UIImage =  UIImage(contentsOfFile: saveImagePathFull)!
                    let thumbImg1 = CommonMethodFunctions.generatePhotoThumbnail1(tempImage);
                    chatImage.image =  thumbImg1
                    let data2 = UIImageJPEGRepresentation(thumbImg1, 1.0)
                    data2!.writeToFile(saveImagePath, atomically: true)
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        // Set the imageView's image to the image we just saved.
                        UIImageWriteToSavedPhotosAlbum(UIImage(contentsOfFile: saveImagePath)!, nil, nil, nil);
                        
                    });
                    
                    var passDic = Dictionary<String,AnyObject>()
                    passDic["imagePath"] = saveImagePathFull as String!
                    NSNotificationCenter.defaultCenter().postNotificationName("showImageFOrFullScreen", object: nil, userInfo: passDic)
                    
                }
                else if grpChatObj.messageType == "video"
                {
                    playBtn.hidden = false
                    
                    //print(saveImagePathFull)
                    // var saveImagePathFull = saveImagePathFull + "mp4"
                    // print(saveImagePathFull)
                    let fileURL=NSURL.fileURLWithPath(saveImagePathFull)
                    
                    let thumbImg = CommonMethodFunctions.getThumbNail(fileURL);
                    if thumbImg != nil
                    {
                        chatImage.image =  thumbImg
                        let data2 = UIImageJPEGRepresentation(thumbImg, 1.0)
                        data2!.writeToFile(saveImagePath, atomically: true)
                    }
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        // Set the imageView's image to the image we just saved.
                        UISaveVideoAtPathToSavedPhotosAlbum(saveImagePath,nil,nil,nil);
                        
                    });
                }else if  grpChatObj.messageType == "audio"
                {
                    playBtn.hidden = false
                }
                
                ChatListner .getChatListnerObj().chatProgressV.removeObjectForKey(grpChatObj.locMessageId!)
                
                if grpChatObj.messageType != "audio"
                {
                    instance.UpdateGroupChatLocalPath(grpChatObj, fullImgStr: saveFullImagePath, thumbImgStr: saveThumbImagePath)
                }else
                {
                    instance.UpdateGroupChatLocalPath(grpChatObj, fullImgStr: saveFullImagePath, thumbImgStr: "")
                }
            }
            
            },
            failure: { (operation : AFHTTPRequestOperation!, error: NSError!) -> Void in
        })
        operation.start()
        
    }
    
     //MARK: - Play Button Method
    
    @IBAction func playFileBtnClick(sender: UIButton)
    {
        if isGroup == "0"
        {
            let pointInTable = sender.convertPoint(sender.bounds.origin, toView: chatTableView)
            let indexPath:NSIndexPath = chatTableView.indexPathForRowAtPoint(pointInTable)!
            let chatObj = chatArray[indexPath.row] as! UserChat
            let tempStr = chatObj.chatFile!.mediaLocalPath! as String
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let documentsDirectory = paths.stringByAppendingPathComponent("/ChatFile")
            let getImagePath = documentsDirectory.stringByAppendingPathComponent(tempStr)
            let checkValidation = NSFileManager.defaultManager()
            if chatObj.messageType == "video"
            {
                if (checkValidation.fileExistsAtPath(getImagePath))
                {
                    let fileURL=NSURL.fileURLWithPath(getImagePath)
                    moviePlayerController = MPMoviePlayerController(contentURL: fileURL)
                    self.view.addSubview(moviePlayerController.view)
                    moviePlayerController.fullscreen = true
                    moviePlayerController.play()
                }else
                {
                }
      
            }else if chatObj.messageType == "audio"
            {
                if (checkValidation.fileExistsAtPath(getImagePath))
                {
                    let fileURL=NSURL.fileURLWithPath(getImagePath)
                    moviePlayerController = MPMoviePlayerController(contentURL: fileURL)
                    self.view.addSubview(moviePlayerController.view)
                    moviePlayerController.fullscreen = true
                    moviePlayerController.play()
                }else
                {
                }
            }
        }else
        {
            
            let pointInTable = sender.convertPoint(sender.bounds.origin, toView: chatTableView)
            let indexPath:NSIndexPath = chatTableView.indexPathForRowAtPoint(pointInTable)!
            let chatObj = chatArray[indexPath.row] as! GroupChat
            let tempStr = chatObj.groupChatFile!.mediaLocalPath!  as String
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let documentsDirectory = paths.stringByAppendingPathComponent("/ChatFile")
            let getImagePath = documentsDirectory.stringByAppendingPathComponent(tempStr)
            let checkValidation = NSFileManager.defaultManager()
            if chatObj.messageType == "video"
            {
                if (checkValidation.fileExistsAtPath(getImagePath))
                {
                    let fileURL=NSURL.fileURLWithPath(getImagePath)
                  // print (fileURL)
                    moviePlayerController = MPMoviePlayerController(contentURL: fileURL)
                    
                    
                    dispatch_async(dispatch_get_main_queue(),{
                    self.view.addSubview(self.moviePlayerController.view)
                       
                    self.moviePlayerController.fullscreen = true
                    self.moviePlayerController.play()
                         })
                }else
                {
                }
            }else if chatObj.messageType == "audio"
            {
                if (checkValidation.fileExistsAtPath(getImagePath))
                {
                    let fileURL=NSURL.fileURLWithPath(getImagePath)
                    moviePlayerController = MPMoviePlayerController(contentURL: fileURL)
                    self.view.addSubview(moviePlayerController.view)
                    moviePlayerController.fullscreen = true
                    moviePlayerController.play()
                }else
                {
                }
            }
        }

    }
    
    
     //MARK: - Chat Image Click Method
    
    
    func clickUserImage(recognizer: UITapGestureRecognizer)
    {
        if isGroup == "0"
        {
            let pointInTable = recognizer.locationInView(chatTableView)
            let indexPath:NSIndexPath = chatTableView.indexPathForRowAtPoint(pointInTable)!
            let chatObj = chatArray[indexPath.row] as! UserChat
            let tempStr = chatObj.chatFile!.mediaLocalPath! as String
          
            let userId = ChatHelper .userDefaultForAny("userId") as! String
            
            if(chatObj.senderId == userId)
            {
                if (chatObj.messageStatus == "3")
                {
                    //return
                }
            }
            if tempStr.characters.count == 0
            {
                return
            }
            
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let documentsDirectory = paths.stringByAppendingPathComponent("/ChatFile")
            let getImagePath = documentsDirectory.stringByAppendingPathComponent(tempStr)
            let checkValidation = NSFileManager.defaultManager()
            if chatObj.messageType == "video"
            {
                if (checkValidation.fileExistsAtPath(getImagePath))
                {
                    let fileURL=NSURL.fileURLWithPath(getImagePath)
                    moviePlayerController = MPMoviePlayerController(contentURL: fileURL)
                    self.view.addSubview(moviePlayerController.view)
                    moviePlayerController.fullscreen = true
                    moviePlayerController.play()
                }else
                {
                }
            }
            else if chatObj.messageType == "audio"
            {
            }else if (chatObj.messageType == "image")
            {
                if (checkValidation.fileExistsAtPath(getImagePath))
                {
                    
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let fullImageVC: FullScreenImageVC = storyBoard.instantiateViewControllerWithIdentifier("FullScreenImageVC") as! FullScreenImageVC
                        fullImageVC.imagePath=getImagePath
                        fullImageVC.downLoadPath="0"
                    
                        self.navigationController?.pushViewController(fullImageVC, animated: true)
                        
                }else
                {
                    var localStr : String! = ""
                    //
                    localStr = ChatBaseMediaUrl + "?" + chatObj.chatFile!.mediaUrl!
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let fullImageVC: FullScreenImageVC = storyBoard.instantiateViewControllerWithIdentifier("FullScreenImageVC") as! FullScreenImageVC
                    fullImageVC.imagePath = localStr
                    fullImageVC.downLoadPath="1"
                    self.navigationController?.pushViewController(fullImageVC, animated: true)
                }
                
            }
        }else
        {
            let pointInTable = recognizer.locationInView(chatTableView)
            
            let indexPath:NSIndexPath = chatTableView.indexPathForRowAtPoint(pointInTable)!
            let chatObj = chatArray[indexPath.row] as! GroupChat
            var tempStr = chatObj.groupChatFile!.mediaLocalThumbPath! as String
            if (chatObj.messageType == "image")
            {
              tempStr = chatObj.groupChatFile!.mediaLocalPath! as String
            }
           // print(tempStr)
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let documentsDirectory = paths.stringByAppendingPathComponent("/ChatFile")
            let getImagePath = documentsDirectory.stringByAppendingPathComponent(tempStr)
           // print(getImagePath)
            let checkValidation = NSFileManager.defaultManager()
            if chatObj.messageType == "video"
            {
                if (checkValidation.fileExistsAtPath(getImagePath))
                {
                    let fileURL=NSURL.fileURLWithPath(getImagePath)
                    moviePlayerController = MPMoviePlayerController(contentURL: fileURL)
                    self.view.addSubview(moviePlayerController.view)
                    moviePlayerController.fullscreen = true
                    moviePlayerController.play()
                }else
                {
                }
            }else if chatObj.messageType == "audio"
            {

            }else if (chatObj.messageType == "image")
            {
                if (checkValidation.fileExistsAtPath(getImagePath))
                {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let fullImageVC: FullScreenImageVC = storyBoard.instantiateViewControllerWithIdentifier("FullScreenImageVC") as! FullScreenImageVC
                    fullImageVC.imagePath=getImagePath
                    fullImageVC.downLoadPath="0"
                    
                    self.navigationController?.pushViewController(fullImageVC, animated: true)
                }else
                {
                    var localStr : String! = ""
                    //HIDE+++++
                    localStr = ChatBaseMediaUrl + "?" + chatObj.groupChatFile!.mediaUrl!
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let fullImageVC: FullScreenImageVC = storyBoard.instantiateViewControllerWithIdentifier("FullScreenImageVC") as! FullScreenImageVC
                    fullImageVC.imagePath = localStr
                    fullImageVC.downLoadPath="1"
                    self.navigationController?.pushViewController(fullImageVC, animated: true)
                }
                
            }
        }
    }
    
    @IBAction func buttonResendClicked(sender: UIButton)
    {
        _ = sender.tableViewCell() as UITableViewCell!
       // self.openResendBtnActionSheet()
    }
    
    
    // MARK: - Add Input View Method
    
    func addInputView() -> Void
    {
        if (IS_IPHONE_5 || IS_IPHONE_4)
        {
            growingTextView = HPGrowingTextView(frame: CGRectMake(45, 6, 190, 33))
            textViewLineWidthConst.constant = 190;
        }
        else if (IS_IPHONE_6)
        {
            growingTextView = HPGrowingTextView(frame: CGRectMake(45, 6, 245, 33))
            textViewLineWidthConst.constant = 245;
            
        }else
        {
            growingTextView = HPGrowingTextView(frame: CGRectMake(45, 6, 285, 33))
            textViewLineWidthConst.constant = 285;
        }
         self.view.layoutIfNeeded()
        growingTextView.isScrollable = false;
        growingTextView.textColor = UIColor.blackColor();
        growingTextView.contentInset = UIEdgeInsetsMake(0, 2, 0, 2);
        growingTextView.minNumberOfLines = 1;
        growingTextView.maxNumberOfLines = 6;
        growingTextView.returnKeyType = .Default; //just as an example
        growingTextView.font = UIFont(name: "Roboto-Regular", size: 14);
        growingTextView.delegate = self;
        growingTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(2, 0, 2, 0);
        growingTextView.clipsToBounds = true;
        growingTextView.layer.cornerRadius = 10.0;
        growingTextView.placeholder="Your message";
        growingTextView.placeholderColor = UIColor.lightGrayColor();
        growingTextView.backgroundColor = UIColor.whiteColor();
        growingTextView.keyboardType = .Default
        if (IS_IPHONE_6) {

        }
        containerView.addSubview(growingTextView)
        containerView.bringSubviewToFront(audioContainerView)
        
    }
    
    // MARK: - back Button Method
    
    @IBAction func backBtnClick(sender: AnyObject)
    {
        if isTyping == true
        {
            self.isTypingStop()
        }
        
        ChatListner .getChatListnerObj().socket.off("getUserStatus")
        var offDic = Dictionary<String, AnyObject>()
        offDic["userid"] = ChatHelper .userDefaultForAny("userId") as! String
        if contObj != nil
        {
            offDic["recieverid"] = contObj.userId
        }else
        {
            offDic["recieverid"] = recentChatObj.friendId
        }
        
        ChatListner .getChatListnerObj().socket.emit("backUpdateUserStatus", offDic)
        ChatHelper .removeFromUserDefaultForKey("friendId")
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "TypeMsgObserverStop", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "TypeMsgObserver", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "receiveMsgFrombgToFg", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "receiveMsgObserverUpdate", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "receiveMsgObserver", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "updateNameObserver", object: nil)
     
        self.saveRecentChat()

            if self.isFromClass == "ChatF"
            {
                self.navigationController?.popToRootViewControllerAnimated(true)
            }else if self.isFromClass == "AddressD"
            {
                self.navigationController?.popViewControllerAnimated(true)
            }else
            {
                self.navigationController?.popViewControllerAnimated(true)
            }
    }
    
    
    func backBtnGroup(notification: NSNotification)
    {
        if isTyping == true
        {
            self.isTypingStop()
        }
        
        ChatListner .getChatListnerObj().socket.off("getUserStatus")
        var offDic = Dictionary<String, AnyObject>()
        offDic["userid"] = ChatHelper .userDefaultForAny("userId") as! String
        if contObj != nil
        {
            offDic["recieverid"] = contObj.userId
        }else
        {
            offDic["recieverid"] = recentChatObj.friendId
        }
        
        ChatListner .getChatListnerObj().socket.emit("backUpdateUserStatus", offDic)
        ChatHelper .removeFromUserDefaultForKey("friendId")
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "TypeMsgObserverStop", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "TypeMsgObserver", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "receiveMsgFrombgToFg", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "receiveMsgObserverUpdate", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "receiveMsgObserver", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "updateNameObserver", object: nil)
        
        self.saveRecentChat()
        
        if self.isFromClass == "ChatF"
        {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }else if self.isFromClass == "AddressD"
        {
            self.navigationController?.popViewControllerAnimated(true)
        }else
        {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    
    
    
    
     //MARK: - Update recent chat Method
    
    func saveRecentChat(
        ) -> Void
    {
       if isGroup == "0"
       {
        if chatArray.count > 0
        {
       // print(chatArray.count)
            let chatObj = chatArray.lastObject as! UserChat
            if self.recentChatObj == nil
            {
                var dict = Dictionary<String, AnyObject>()
                dict["name"] = contObj.name
                dict["friendId"] = contObj.userId
                dict["imageStr"] = contObj.userImgString
                 dict["isNameAvail"] = "1"
                if (chatObj.messageType == "text")
                {
                    dict["message"] = chatObj.message
                    dict["messageTime"] = chatObj.messageDate
                }
                else if chatObj.messageType == "image"
                {
                    dict["message"] = "Image"
                    dict["messageTime"] = chatObj.messageDate
                }
                else if chatObj.messageType == "audio"
                {
                    dict["message"] = "Audio"
                    dict["messageTime"] = chatObj.messageDate
                }
                else if chatObj.messageType == "video"
                {
                    dict["message"] = "Video"
                    dict["messageTime"] = chatObj.messageDate
                }
                self.AddContact(dict)
            }else
            {
                let instance = DataBaseController.sharedInstance
                if (chatObj.messageType == "text")
                {
                    instance.updateRecentChatObj1(recentChatObj, msg: chatObj.message!, time: chatObj.messageDate!)
                }
                else if chatObj.messageType == "image"
                {
                    instance.updateRecentChatObj1(recentChatObj, msg: "Image", time: chatObj.messageDate!)
                }
                else if chatObj.messageType == "audio"
                {
                    instance.updateRecentChatObj1(recentChatObj, msg: "Audio", time: chatObj.messageDate!)
                }
                else if chatObj.messageType == "video"
                {
                    instance.updateRecentChatObj1(recentChatObj, msg: "Video", time: chatObj.messageDate!)
                }
            }
        }
        else
        {
            if self.recentChatObj != nil
            {
                if chatArray.count > 0
                {
                    let chatObj = chatArray.lastObject as! UserChat
                    let instance = DataBaseController.sharedInstance
                    instance.updateRecentChatObj1(recentChatObj, msg: "", time: chatObj.messageDate!)
                }else
                {
                    let instance = DataBaseController.sharedInstance
                    instance.updateRecentChatObj1(recentChatObj, msg: "", time: "")
                }
            }
        }
       }
       else
       {
        if chatArray.count > 0
        {
            let chatObj = chatArray.lastObject as! GroupChat
            if self.recentChatObj == nil
            {
                var dict = Dictionary<String, AnyObject>()
                dict["name"] = contObj.name
                dict["friendId"] = contObj.userId
                dict["imageStr"] = contObj.userImgString
                dict["isNameAvail"] = "1"
                if (chatObj.messageType == "text")
                {
                    dict["message"] = chatObj.message
                    dict["messageTime"] = chatObj.messageDate
                }
                else if chatObj.messageType == "image"
                {
                    dict["message"] = "Image"
                    dict["messageTime"] = chatObj.messageDate
                }
                else if chatObj.messageType == "audio"
                {
                    dict["message"] = "Audio"
                    dict["messageTime"] = chatObj.messageDate
                }
                else if chatObj.messageType == "video"
                {
                    dict["message"] = "Video"
                    dict["messageTime"] = chatObj.messageDate
                }
                self.AddContact(dict)
            }else
            {
                let instance = DataBaseController.sharedInstance
                if (chatObj.messageType == "text")
                {
                    instance.updateRecentChatObj1(recentChatObj, msg: chatObj.message!, time: chatObj.messageDate!)
                }
                else if chatObj.messageType == "image"
                {
                    instance.updateRecentChatObj1(recentChatObj, msg: "Image", time: chatObj.messageDate!)
                }
                else if chatObj.messageType == "audio"
                {
                    instance.updateRecentChatObj1(recentChatObj, msg: "Audio", time: chatObj.messageDate!)
                }
                else if chatObj.messageType == "video"
                {
                    instance.updateRecentChatObj1(recentChatObj, msg: "Video", time: chatObj.messageDate!)
                }
            }
        }
        else
        {
            if self.recentChatObj != nil
            {
                if chatArray.count > 0
                {
                    let chatObj = chatArray.lastObject as! GroupChat
                    let instance = DataBaseController.sharedInstance
                    instance.updateRecentChatObj1(recentChatObj, msg: "", time: chatObj.messageDate!)
                }else
                {
                    let instance = DataBaseController.sharedInstance
                    if self.recentChatObj.lastMessage != "New Group"
                    {
                    instance.updateRecentChatObj1(recentChatObj, msg: "", time: "")
                    }
                }
            }
            
        }
       }
        
    }
    
    
    func AddContact(contactList:Dictionary<String, AnyObject>)
    {
        let instance = DataBaseController.sharedInstance
        instance.insertRecentChatData1("RecentChatList", params: contactList)
         self.recentChatObj = instance.checkIfChatUserAlreadyExist1("RecentChatList", params: contactList)
    }
    
   
     // MARK: - Keyboard Notifications
  
    func keyboardWillShow(notification: NSNotification)
    {
        var keyboardFrame: CGRect = CGRect.null
        if let info = notification.userInfo {
            keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            bottomContainerConst.constant=keyboardFrame.size.height
            self.view.layoutIfNeeded()
            if chatArray.count > 2
            {
                chatTableView.scrollToRowAtIndexPath(NSIndexPath(forRow:chatArray.count-1,inSection:0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        bottomContainerConst.constant=0
        self.view.layoutIfNeeded()
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - growingTextView Delegates
    
     func growingTextView(growingTextView: HPGrowingTextView!, willChangeHeight height: Float)
     {
        let myIntValue:Int = Int(height)
        contanierHeightLayout.constant = CGFloat(myIntValue + 15);
        self.view.layoutIfNeeded()
    }
    
    
//    - (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView;

    func growingTextViewShouldBeginEditing(growingTextView: HPGrowingTextView!) -> Bool
    {
        viewCopyAndDelete.hidden = true
        imgBackGround.hidden = true
        chatTableView.userInteractionEnabled = true
        
        growingTextView.enablesReturnKeyAutomatically = true
        return true
    }
    
    func growingTextViewDidChange(growingTextView: HPGrowingTextView!)
    {
        if growingTextView.text.characters.count > 0
        {
            growingTextView.enablesReturnKeyAutomatically = true
            sendBtnOutlet.hidden = false
            audioBtnOutlet.hidden = true
            cameraBtnOutlet.hidden = true
            if growingTextView.text.characters.count == 1 && growingTextView.text != "\n"
            {
                if (IS_IPHONE_5 || IS_IPHONE_4)
                {
                    self.growingTextView.frame = CGRectMake(45, 6, 235, 33)
                    textViewLineWidthConst.constant = 235;
                }
                else if (IS_IPHONE_6)
                {
                    self.growingTextView.frame = CGRectMake(45, 6, 290, 33)
                    textViewLineWidthConst.constant = 290;
                }else
                {
                    self.growingTextView.frame = CGRectMake(45, 6, 330, 33)
                    textViewLineWidthConst.constant = 330;
                }
                
            }else if growingTextView.text.characters.count == 1 && growingTextView.text == "\n"
            {
                if (IS_IPHONE_5 || IS_IPHONE_4)
                {
                    self.growingTextView.frame = CGRectMake(45, 6, 235, 48)
                    textViewLineWidthConst.constant = 235;
                }
                else if (IS_IPHONE_6)
                {
                    self.growingTextView.frame = CGRectMake(45, 6, 290, 48)
                    textViewLineWidthConst.constant = 290;
                    
                }else
                {
                    self.growingTextView.frame = CGRectMake(45, 6, 330, 48)
                    textViewLineWidthConst.constant = 330;
                }
            }
        }else
        {
            growingTextView.enablesReturnKeyAutomatically = false
            sendBtnOutlet.hidden = true
            audioBtnOutlet.hidden = false
            cameraBtnOutlet.hidden = false
            if (IS_IPHONE_5 || IS_IPHONE_4)
            {
                self.growingTextView.frame =  CGRectMake(45, 6, 185, 33)
                textViewLineWidthConst.constant = 185;
            }
            else if (IS_IPHONE_6)
            {
                self.growingTextView.frame = CGRectMake(45, 6, 240, 33)
                textViewLineWidthConst.constant = 240;
            }else
            {
                self.growingTextView.frame = CGRectMake(45, 6, 280, 33)
                textViewLineWidthConst.constant = 280;
            }
        }
        if isTyping == false && growingTextView.text.characters.count > 0
        {
            isTyping = true
            self.isTypingStart()
        }
        if isGroup == "0"
        {
            if timerForTyping != nil
            {
                timerForTyping.invalidate()
                timerForTyping=nil;
            }
           // timerForTyping = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(ChattingMainVC.isTypingStop), userInfo: nil, repeats: false)
        }else
        {
            if timerForTyping != nil
            {
                timerForTyping.invalidate()
                timerForTyping=nil;
            }
            timerForTyping = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ChattingMainVC.isTypingStop), userInfo: nil, repeats: false)
        }
    }
    
     //MARK: - iSTyping Method
    
    func isTypingStart() -> Void
    {
        var sendDic = Dictionary<String, AnyObject>()
        sendDic["userid"] = ChatHelper .userDefaultForAny("userId") as! String
         sendDic["typeStatus"] = "1"
        if isGroup == "0"
        {
            if contObj != nil
            {
                sendDic["recieverid"] = contObj.userId
            }else
            {
                sendDic["recieverid"] = recentChatObj.friendId
            }
        }else
        {
            sendDic["groupid"] = recentChatObj.groupId
        }
            ChatListner .getChatListnerObj().socket.emit("userTyping", sendDic)
    }
    
    func isTypingStop() -> Void
    {
        isTyping = false
        var sendDic = Dictionary<String, AnyObject>()
        sendDic["userid"] = ChatHelper .userDefaultForAny("userId") as! String
        sendDic["typeStatus"] = "0"
        if isGroup == "0"
        {
            if contObj != nil
            {
                sendDic["recieverid"] = contObj.userId
            }else
            {
                sendDic["recieverid"] = recentChatObj.friendId
            }
        }else
        {
            sendDic["groupid"] = recentChatObj.groupId
        }
            ChatListner .getChatListnerObj().socket.emit("userTyping", sendDic)
    }
   
     // MARK: - More Button Methods
    
    @IBAction func topMoreBtnClick(sender: AnyObject) {
        
        
        self.cancelAttchView()
        self.openMoreBtnActionSheet()
        
        
    }
    
    func openMoreBtnActionSheet() -> Void
    {
        var blockStr : String!
        var reportStr : String!
        var friendName : String!
        
        if isGroup == "0"
        {
            if contObj != nil
            {
                friendName=contObj.name
            }
            else
            {
                friendName=recentChatObj.friendName
            }
            if (self.recentChatObj != nil && self.recentChatObj.isBlock == "1") || (self.contObj != nil && self.contObj.isBlock == "1")
            {
                blockStr = "Unblock user"
            }else
            {
                blockStr = "Block user"
            }
            if (self.recentChatObj != nil && self.recentChatObj.isReport == "1") || (self.contObj != nil && self.contObj.isReport == "1")
            {
                reportStr = "Already reported"
            }else
            {
                reportStr = "Report user"
            }
            if(IS_IOS_7)
            {
                
                let actionSheet = UIActionSheet(title: friendName, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle:nil, otherButtonTitles: "Email Conversation","Delete Conversation","Cancel")
                
                actionSheet.tag=200
                actionSheet.showFromTabBar((bottomTabBar?.tabBar)!)
            }
            else
            {
                let actionSheet =  UIAlertController(title: friendName, message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
                actionSheet.addAction(UIAlertAction(title: "Email Conversation", style: UIAlertActionStyle.Default, handler:
                    {(ACTION :UIAlertAction!)in
                        self.emailAlertMethod()
                }))
                
                actionSheet.addAction(UIAlertAction(title: "Delete Conversation", style: UIAlertActionStyle.Default, handler:
                    { (ACTION :UIAlertAction!)in
                        
                        self.deleteAlertMethod()
                }))
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(actionSheet, animated: true, completion: nil)
            }
        }else
        {
            
            if(IS_IOS_7)
            {
                let actionSheet = UIActionSheet(title: recentChatObj.friendName, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle:nil, otherButtonTitles: "Email Conversation","Delete Conversation","Cancel")
                actionSheet.tag=300
                actionSheet.showFromTabBar((bottomTabBar?.tabBar)!)
            }
            else
            {
                let actionSheet =  UIAlertController(title: recentChatObj.friendName, message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
                actionSheet.addAction(UIAlertAction(title: "Email Conversation", style: UIAlertActionStyle.Default, handler:
                    {(ACTION :UIAlertAction!)in
                        self.emailAlertMethod()
                }))
                
                
                actionSheet.addAction(UIAlertAction(title: "Delete Conversation", style: UIAlertActionStyle.Default, handler:
                    { (ACTION :UIAlertAction!)in
                        
                        self.deleteAlertMethod()
                }))
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(actionSheet, animated: true, completion: nil)
            }
        }
        
    }
    
    func openResendBtnActionSheet() -> Void
    {
        if(IS_IOS_7)
        {
            let actionSheet = UIActionSheet(title: APP_NAME, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle:nil, otherButtonTitles: "Resend","Delete","Cancel")
            actionSheet.tag=210
            actionSheet.showFromTabBar((bottomTabBar?.tabBar)!)
        }
        else
        {
            let actionSheet =  UIAlertController(title: APP_NAME, message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
            actionSheet.addAction(UIAlertAction(title: "Resend", style: UIAlertActionStyle.Default, handler:
                {(ACTION :UIAlertAction!)in
                    
                    
            }))
            actionSheet.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler:
                { (ACTION :UIAlertAction!)in
                    
                    
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
    }
    
    func openCopyDeleteActionSheet() -> Void
    {
        var friendName : String!
        if contObj != nil
        {
            friendName=contObj.name
        }
        else
        {
            friendName=recentChatObj.friendName
        }
        if(IS_IOS_7)
        {
            let actionSheet = UIActionSheet(title: friendName, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle:nil, otherButtonTitles: "Copy","Delete","Cancel")
            actionSheet.tag=220
            actionSheet.showFromTabBar((bottomTabBar?.tabBar)!)
        }
        else
        {
            let actionSheet =  UIAlertController(title: friendName, message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
            actionSheet.addAction(UIAlertAction(title: "Copy", style: UIAlertActionStyle.Default, handler:
                {(ACTION :UIAlertAction!)in
                    
                    self.copyText(self.copyTextStr)
                    
            }))
            actionSheet.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler:
                { (ACTION :UIAlertAction!)in
                   self.deleteMessageWithAlert()
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (ACTION :UIAlertAction!)in

                self.btnCopyCancle()
            }))
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
    }
    
    func openDeleteActionSheet() -> Void
    {
        var friendName : String!
        if contObj != nil
        {
            friendName=contObj.name
        }
        else
        {
            friendName=recentChatObj.friendName
        }
        if(IS_IOS_7)
        {
            let actionSheet = UIActionSheet(title: friendName, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle:nil, otherButtonTitles: "Delete","Cancel")
            actionSheet.tag=230
            actionSheet.showFromTabBar((bottomTabBar?.tabBar)!)
        }
        else
        {
            let actionSheet =  UIAlertController(title: friendName, message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler:
                { (ACTION :UIAlertAction!)in
                    self.deleteMessage(self.msgId, indexp: self.deleteIndexP)
                    
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (ACTION :UIAlertAction!)in

            }))
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        if actionSheet.tag==200
        {
            switch buttonIndex{
            case 0:
                self.emailAlertMethod()
                break;
                //            case 1:
                //                self.blockAlertMethod()
                //                break;
                //            case 2:
                //                if (self.recentChatObj != nil && self.recentChatObj.isReport == "0") || (self.contObj != nil && self.contObj.isReport == "0")
                //                {
                //                self.reportAlertMethod()
                //                }
                
                break;
            case 1:
                self.deleteAlertMethod()
                break;
            default:
                break;
            }
        }else if actionSheet.tag==220
        {
            switch buttonIndex{
            case 0:
                self.copyText(self.copyTextStr)
                
                break;
            case 1:
                 self.deleteMessage(self.msgId, indexp: self.deleteIndexP)
                break;
            case 2:
                self.btnCopyCancle()
                break;
            default:
                break;
            
            }
        }else if actionSheet.tag==230
        {
            switch buttonIndex{
            case 0:
                self.deleteMessage(self.msgId, indexp: self.deleteIndexP)
                break;
            case 1:
                break;
            default:
    
                break;
                
            }
        }else if(actionSheet.tag==300)
        {
            switch buttonIndex{
            case 0:
                self.emailAlertMethod()
                break;
            case 1:
                self.deleteAlertMethod()
                break;
            default:
                break;
            }
        }else if (actionSheet.tag==10001)
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
        }else if (actionSheet.tag==10002)
        {
            switch buttonIndex{
            case 0:
                // bellow code is commented by pk on 2 dec 2015

             //   self.sendVideoToServer(dictData["dict"] as NSDictionary , videoData: dictData["data"] as NSData , index: dictData["index"] as Int)
                
                // bellow code is WRITTEN by pk on 2 dec 2015

                NSOperationQueue.mainQueue().addOperationWithBlock() { () in
                    
                    let name = self.uniqueName("")
                    UploadInS3.sharedGlobal().uploadImageTos3(self.dictData["data"] as! NSData , type: 1, fromDist: "chat", meldID: name, completion: { ( bool_val : Bool, pathUrl : String!) -> Void in
                        if bool_val == true
                        {
                            let fileName =  UploadInS3.sharedGlobal().strFilesName
                            //  progressV.hidden = true
                            if fileName != nil{
                                self.sendVideoFilePathToChatServer(self.dictData["dict"] as! NSDictionary, filePath: fileName, index: self.dictData["index"] as! Int)
                            }
                        }
                        else
                        {
                            print("fail to set file on aws")
                        }
                        
                        }
                        , completionProgress: { ( bool_val : Bool, progress) -> Void in
                            
                            
                            
                            // print("pathSelected \(pathSelected)")
                            
                            
                            //let newIndexPath:NSIndexPath = NSIndexPath(forRow:dict["index"] as Int,inSection:0)
                            //
                            //
                            //                            let cell:UITableViewCell = self.chatTableView.cellForRowAtIndexPath(pathSelected)!
                            //                            var progressV = cell.contentView.viewWithTag(22) as PICircularProgressView
                            //                            progressV.hidden = false
                            //                            progressV.progress=progress
                            //
                            //                            if(progress == 1.0)
                            //                            {
                            //                                progressV.hidden = true
                            //                                
                            //                            }
                        }
                    )
                    
                }
                break;
            default:
                break;
            }
        }

    }
    
    func deleteConversation() -> Void
    {
        if isGroup == "0"
        {
            let strLogin:String = ChatHelper .userDefaultForAny("userId") as! String
            let strSender:String = ChatHelper .userDefaultForAny("userId")  as! String
            var strReceiver:String = ""
            if contObj != nil
            {
                strReceiver = contObj.userId as String
            }else
            {
                strReceiver = recentChatObj.friendId! as String
            }
    
            let strPred:String = "loginUserId contains[cd] \"\(strLogin)\" AND (( senderId contains[cd] \"\(strSender)\" AND receiverId contains[cd] \"\(strReceiver)\") OR ( senderId contains[cd] \"\(strReceiver)\" AND receiverId contains[cd] \"\(strSender)\"))"
            
            let instance = DataBaseController.sharedInstance
            instance.deleteData("UserChat", predicate: strPred)
            self.chatArray.removeAllObjects()
            chatTableView.tableHeaderView=nil;
            chatTableView.reloadData()
        }else
        {
            let strLogin:String = ChatHelper .userDefaultForAny("userId") as! String
            let groupId = recentChatObj.groupId! as String
            
            
        
            let strPred:String = "loginUserId contains[cd] \"\(strLogin)\" AND groupId LIKE \"\(groupId)\""
            
            let instance = DataBaseController.sharedInstance
            instance.deleteData("GroupChat", predicate: strPred)
            self.chatArray.removeAllObjects()
            chatTableView.tableHeaderView=nil;
            chatTableView.reloadData()
        }
        

    }
     // MARK: - Plus Button Methods
    
    @IBAction func plusBtnClick(sender: AnyObject) {
        
        if (self.recentChatObj != nil && self.recentChatObj.isBlock == "1") || (self.contObj != nil && self.contObj.isBlock == "1")
        {
            if(IS_IOS_7)
            {
                ChatHelper.showALertWithTag(32, title: APP_NAME, message: "Please unblock user first to send message.", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitle: "OK")
            }
            else
            {
                let alertController = UIAlertController(title:APP_NAME, message: "Please unblock user first to send message.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                   // self.blockUserMethod()
                 
                    self.hitServiceForUnBlockFriends(self.recentChatObj.friendId!)
                    
                    
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
        }else
        {
            self.attachmentViewS.backgroundColor=UIColor.whiteColor()
            growingTextView .resignFirstResponder()
            bottomPlusConstraint.constant=0;
            
            UIView.animateWithDuration(0.5, animations:
                {
                //    self.attachmentViewS.layoutIfNeeded()
                 //  self.view.setTranslatesAutoresizingMaskIntoConstraints(false)
                    //older
                   self.view.layoutIfNeeded()
                    
            })
        }
        
    }
    
    @IBAction func cancelAttachviewClick(sender: AnyObject) {
        self.cancelAttchView()
    }
    
    func cancelAttchView()-> Void
    {
        bottomPlusConstraint.constant = -290;
        
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
    
    @IBAction func choosePicfromgalleryClick(sender: AnyObject)
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
    
    @IBAction func takeVideoFromGalleryClick(sender: AnyObject)
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
                   
                    dict["sender"] = ChatHelper .userDefaultForAny("userId") as! String
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
                        //arrayofMessage += [chatObj]
                        chatArray.addObject(chatObj)
                        
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
                        // arrayofMessage.append(chatObj)
                        //arrayofMessage += []
                        chatObj.groupChatFile = fileObj
                    }
                    homeCoreData.saveContext()
                    growingTextView.text=""
                    dict["index"] = self.chatArray.count-1
                    var path = [NSIndexPath]()
                    
                    path.append(NSIndexPath(forRow:dict["index"] as! Int,inSection:0))
                    chatTableView.insertRowsAtIndexPaths(path, withRowAnimation: UITableViewRowAnimation.Bottom)
                    if chatArray.count > 2
                    {
                        chatTableView.scrollToRowAtIndexPath(NSIndexPath(forRow:chatArray.count-1,inSection:0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                    }
                    
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
                    }
                    
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
                    
                    dict["sender"] = ChatHelper .userDefaultForAny("userId") as! String
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
                    // New pic by PK
                    
                    //    print("sent frow ====\(myRow)")
                    
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
                        
                    })
                    
                    
                    
                }
            }
        }
    
    
    //MARK:- Audio Buttons
    
    @IBAction func audioBtnDragExt(sender: AnyObject) {
        
        
        AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
            if granted {
                
                
                self.audioBtnWidthConst.constant=35;
                self.leadslidetoCancelLabel.constant = 160
                self.leadContAudioConst.constant = self.view.frame.width
                UIView.animateWithDuration(0.25, animations:
                    {
                        self.view.layoutIfNeeded()
                })
                
                if self.timerForProgress != nil
                {
                    self.timerForProgress.invalidate()
                    self.timerForProgress=nil;
                }
                self.recordObj.stopRecording();
                if self.audioSend == true && (self.secTimer > 0 || self.minTimer > 0)
                {
                    self.sendAudio()
                }
                
            } else{
                
                let alertController = UIAlertController(title:APP_NAME, message:"You have not provided permission to use microphone. Please go to settings and allow.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
        })
    }
    
    @IBAction func audioBtnDrag(sender: AnyObject, forEvent event: UIEvent) {
        let buttonView = sender as! UIView;
        if let touch = event.touchesForView(buttonView)?.first {
            
             audioSend = false
   
            if location == nil
            {
                location=touch.locationInView(buttonView)
            }
            if location.x >= touch.locationInView(buttonView).x
            {
                if leadslidetoCancelLabel.constant > 80
                {
                    leadslidetoCancelLabel.constant = leadslidetoCancelLabel.constant - 3
                }else
                {
                    self.audioBtnTouchCancel(1)
                }
                location=touch.locationInView(buttonView)
            }else
            {
                if leadslidetoCancelLabel.constant <= 160
                {
                    leadslidetoCancelLabel.constant = leadslidetoCancelLabel.constant + 3
                }else
                {
                    self.audioBtnTouchCancel(1)
                }
                 location=touch.locationInView(buttonView)
            }
            if location.x < 0
            {
                audioSend = false
            }else
            {
                audioSend = true
            }
        }

    }
    
    @IBAction func audioBtnDrag(sender: AnyObject)
    {

    }
    
    @IBAction func audioBtnTouchCancel(sender: AnyObject!) {
        audioBtnWidthConst.constant=35;
        leadslidetoCancelLabel.constant = 160
        leadContAudioConst.constant = self.view.frame.width
        UIView.animateWithDuration(0.25, animations:
            {
                self.view.layoutIfNeeded()
        })
        if timerForProgress != nil
        {
            timerForProgress.invalidate()
            timerForProgress=nil;
        }
        recordObj.stopRecording();
        maxIntForProgress = intForProgress;
        
    }
    
    @IBAction func audioBtnTouchDown(sender: AnyObject) {
        
        if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {
            if (self.recentChatObj != nil && self.recentChatObj.isBlock == "1") ||  (self.contObj != nil && self.contObj.isBlock == "1")
            {
                if(IS_IOS_7)
                {
                    ChatHelper.showALertWithTag(32, title: APP_NAME, message: "Please unblock user first to send message.", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitle: "OK")
                }
                else
                {
                    let alertController = UIAlertController(title:APP_NAME, message: "Please unblock user first to send message.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                        //  self.blockUserMethod()
                        self.hitServiceForUnBlockFriends(self.recentChatObj.friendId!)
                    }))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
            }else
            {
                
                AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                    if granted {
                        
                        self.audioSend = true
                        self.leadslidetoCancelLabel.constant = 160
                        self.audioBtnWidthConst.constant=300
                        self.leadContAudioConst.constant = 0
                        UIView.animateWithDuration(0.05, animations:
                            {
                                
                                self.view.layoutIfNeeded()
                        })
                        self.timeRecordLabel.text = "00 : 00";
                        self.maxIntForProgress=1800;
                        self.intForProgress=0;
                        self.minTimer=0;
                        self.secTimer=0;
                        self.hourTimer=0;
                        self.timerForProgress = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ChattingMainVC.incProgress), userInfo: nil, repeats: true)
                        self.recordObj.recordButtClicked()
                        
                    } else{
                        
                        let alertController = UIAlertController(title:APP_NAME, message:"You have not provided permission to use microphone. Please go to settings and allow.", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                    }
                })
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
    
    @IBAction func audioBtnClick(sender: AnyObject) {
        if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {
            if (self.recentChatObj != nil && self.recentChatObj.isBlock == "1") || (self.contObj != nil && self.contObj.isBlock == "1")
            {
                if(IS_IOS_7)
                {
                    ChatHelper.showALertWithTag(32, title: APP_NAME, message: "Please unblock user first to send message.", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitle: "OK")
                }
                else
                {
                    let alertController = UIAlertController(title:APP_NAME, message: "Please unblock user first to send message.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                        // self.blockUserMethod()
                        
                        self.hitServiceForUnBlockFriends(self.recentChatObj.friendId!)
                    }))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
            }else
            {
                
                AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                    if granted {
                        
                        self.audioBtnWidthConst.constant=35;
                        self.leadslidetoCancelLabel.constant = 160
                        self.leadContAudioConst.constant = self.view.frame.width
                        UIView.animateWithDuration(0.05, animations:
                            {
                                self.view.layoutIfNeeded()
                        })
                        if self.timerForProgress != nil
                        {
                            self.timerForProgress.invalidate()
                            self.timerForProgress=nil;
                        }
                        
                        self.recordObj.stopRecording();
                        self.maxIntForProgress = self.intForProgress;
                    
                        if self.audioSend == true && (self.secTimer > 0 || self.minTimer > 0)
                        {
                            self.sendAudio()
                        }
                        
                    } else{
                        
                        let alertController = UIAlertController(title:APP_NAME, message:"You have not provided permission to use microphone. Please go to settings and allow.", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                    }
                })
                
                
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
    
    func incProgress() -> Void
    {
    if(maxIntForProgress>intForProgress)
    {
        secTimer = secTimer + 1;
    
        if(secTimer<60)
        {
            if (minTimer<10)
            {
                if (secTimer<10)
                {
                    timeRecordLabel.text = NSString(format:"%@%d : %@%d","0",minTimer,"0",secTimer) as String
                    
                    intForProgress = intForProgress+1;
                }else{
                    timeRecordLabel.text = NSString(format:"%@%d : %d","0",minTimer,secTimer) as String
                    intForProgress = intForProgress+1;
                }
            }
            else
            {
                if (secTimer<10)
                {
                    timeRecordLabel.text = NSString(format:"%d : %@%d",minTimer,"0",secTimer) as String
                    intForProgress = intForProgress+1;
                }else{
                    timeRecordLabel.text = NSString(format:"%d : %d",minTimer,secTimer) as String
                    intForProgress = intForProgress+1;
                }
            }
    
        }
        else if(minTimer<60){
            minTimer = minTimer+1;
            secTimer=0;
            if (minTimer<10) {
                if (secTimer<10)
                {
                    timeRecordLabel.text = NSString(format:"%@%d : %@%d","0",minTimer,"0",secTimer) as String
                    intForProgress = intForProgress+1;
                }else{
                    timeRecordLabel.text = NSString(format:"%@%d : %d","0",minTimer,secTimer) as String
                    intForProgress = intForProgress+1;
                }
    
            }else{
                if (secTimer<10)
                {
                    timeRecordLabel.text = NSString(format:"%d : %d",minTimer,secTimer) as String
                    intForProgress = intForProgress+1;
                }else{
                    timeRecordLabel.text = NSString(format:"%d : %d",minTimer,secTimer) as String
                    intForProgress = intForProgress+1;
                }
            }
    
        }else
        {
            hourTimer = hourTimer + 1;
            minTimer=0;
            secTimer=0;
            timeRecordLabel.text = NSString(format:"%0d : %d : %d" ,hourTimer,minTimer,secTimer) as String
        }
    
    
    
    }
    else
    {

        if timerForProgress != nil
        {
            timerForProgress.invalidate()
            timerForProgress=nil;
        }
   
        recordObj.stopRecording();
  
        if(IS_IOS_7)
        {
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "You have reached the maximum limit of recording.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
        }
        else
        {
            let alertController = UIAlertController(title:APP_NAME, message:"You have reached the maximum limit of recording.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    
        }
    }

    @IBAction func cameraBtnClick(sender: AnyObject) {
        if AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) ==  AVAuthorizationStatus.Authorized
        {
            // Already Authorized
            self.openCamera()
        }
        else
        {
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (granted :Bool) -> Void in
                if granted == true
                {
                    // User granted
                    dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                        self.openCamera()
                    }
                }
                else
                {
                    // User Rejected
                    let alert = UIAlertController(title: AppName, message: "Please check your camera settings", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            });
        }
        
        
        
    }
    func openCamera()->Void
    {
        if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {
            if (self.recentChatObj != nil && self.recentChatObj.isBlock == "1") || (self.contObj != nil && self.contObj.isBlock == "1")
            {
                if(IS_IOS_7)
                {
                    ChatHelper.showALertWithTag(32, title: APP_NAME, message: "Please unblock user first to send message.", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitle: "OK")
                }
                else
                {
                    let alertController = UIAlertController(title:APP_NAME, message: "Please unblock user first to send message.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                        //  self.blockUserMethod()
                        
                        self.hitServiceForUnBlockFriends(self.recentChatObj.friendId!)
                    }))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
            }else
            {
                UIApplication.sharedApplication().statusBarHidden=true;
                let imagePicker = UIImagePickerController()
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
                {
                    imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                    imagePicker.mediaTypes = [String(kUTTypeImage)]
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
    
    @IBAction func sendTextBtnClick(sender: AnyObject)
    {
        isTyping = false
        self.isTypingStop()
        if timerForTyping != nil
        {
            timerForTyping.invalidate()
            timerForTyping=nil;
        }
        let myString = growingTextView.text
        let newString = myString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        //print(contObj)
        
        if (self.recentChatObj != nil && self.recentChatObj.isBlock == "1") || (self.contObj != nil && self.contObj.isBlock == "1")
        {
            if(IS_IOS_7)
            {
                ChatHelper.showALertWithTag(32, title: APP_NAME, message: "Please unblock user first to send message.", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitle: "OK")
            }
            else
            {
                let alertController = UIAlertController(title:APP_NAME, message: "Please unblock user first to send message.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                 //   self.blockUserMethod()
                    
                    self.hitServiceForUnBlockFriends(self.recentChatObj.friendId!)
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
        }else
        {
            if newString.characters.count > 0
            {
                //print_debug(newString.stringByReplacingEmojiUnicodeWithCheatCodes())

                self.sendTextMsg(newString.stringByReplacingEmojiUnicodeWithCheatCodes())
            }
        }
    }
    
    func sendAudio() -> Void
    {
        if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {
            
            let instance = DataBaseController.sharedInstance
            var date = NSDate()
            var dateStr : String
            var timeStr : String
            let locId = CommonMethodFunctions.nextIdentifies()
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
            dateStr = dateFormatter.stringFromDate(date)
            dateFormatter.dateFormat = "HH:mm:ss.sss"
            timeStr = dateFormatter.stringFromDate(date)
            
            let data:NSData! = NSData(contentsOfURL: recordObj.recordedTmpFile)
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let documentsDirectory = paths.stringByAppendingPathComponent("/ChatFile")
            let fileManager = NSFileManager.defaultManager()
            do {
                try fileManager.createDirectoryAtPath(documentsDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
            let saveFilePath = "Audio"+dateStr+".wav"
            let saveAudioPath = documentsDirectory.stringByAppendingPathComponent(saveFilePath)
            data.writeToFile(saveAudioPath, atomically: true)
            
            var dict = Dictionary<String, AnyObject>()
            dict["date"] = dateStr
            dict["sortDate"] = dateStr
            dict["time"] = timeStr
            dict["message"] = ""
            dict["type"] = "audio"
            dict["localThumbPath"] = ""
            dict["localFullPath"] = saveFilePath
            dict["mediaUrl"] = ""
            dict["mediaThumbUrl"] = ""
            let strId = String(locId)
            dict["localmsgid"] = strId
            
            dict["sender"] = ChatHelper .userDefaultForAny("userId") as!  String
            if contObj != nil
            {
                dict["receiver"] = contObj.userId
            }else
            {
                dict["receiver"] = recentChatObj.friendId
            }
            
            
            
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
            var path = [NSIndexPath]()
            path.append(NSIndexPath(forRow:chatArray.count-1,inSection:0))
            chatTableView.insertRowsAtIndexPaths(path, withRowAnimation: UITableViewRowAnimation.None)
            if chatArray.count > 2
            {
                chatTableView.scrollToRowAtIndexPath(NSIndexPath(forRow:chatArray.count-1,inSection:0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
            }
            
            // New pic by PK
             dict["index"] = chatArray.count-1
           // print("sent frow ====\(myRow)")
            
            // bellow code is hidden by pk on 2 dec 2015
            
            // self.sendAudioToServer(dict, audioData: data, index: chatArray.count-1)
            
            // bellow code is WRITTEN by pk on 2 dec 2015
            
            let newIndexPath:NSIndexPath = NSIndexPath(forRow:dict["index"] as! Int,inSection:0)
            
            let cell:UITableViewCell = chatTableView.cellForRowAtIndexPath(newIndexPath)!
            
            var progressV = cell.contentView.viewWithTag(22) as! PICircularProgressView
            let playBtn = cell.contentView.viewWithTag(24) as! UIButton
            playBtn.hidden = true
            progressV.hidden = false
            let str : String = dict["localmsgid"] as! String
            
            ChatListner .getChatListnerObj().chatProgressV[str] = progressV
            
            NSOperationQueue.mainQueue().addOperationWithBlock() { () in
                
                let name = self.uniqueName("")
                UploadInS3.sharedGlobal().uploadImageTos3( data, type: 2, fromDist: "chat", meldID: name, completion: { ( bool_val : Bool, pathUrl : String!) -> Void in
                    
                    if bool_val == true
                    {
                        progressV =     ChatListner .getChatListnerObj().chatProgressV[str] as! PICircularProgressView
                        
                        let progresss = UploadInS3.sharedGlobal().progress_
                        
                        progressV.progress=Double(progresss)
                        
                        let fileName =  UploadInS3.sharedGlobal().strFilesName
                        //progressV.hidden = true
                        if fileName != nil{
                            self.sendAudioFilePathToChatServer(dict, filePath: fileName, index: dict["index"] as! Int)
                        }
                    }
                        
                    else
                    {
                        if self.isGroup == "0"
                        {
                            
                            //dict["index"] as Int
                            instance.multimediaChatStatusChangeSingleChat(self.chatArray .objectAtIndex(dict["index"] as! Int) as! UserChat)
                        }
                        else
                        {
                            instance.multimediaChatStatusChangeGroupChat(self.chatArray .objectAtIndex(dict["index"] as! Int) as! GroupChat)
                            
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
                        
                        
                            if     let cell:ChatAudioSenderCell = self.chatTableView.cellForRowAtIndexPath(newIndexPath)! as? ChatAudioSenderCell
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
        }
    }
     //MARK:- View Delegates receiveMassege

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // stuff
        if (touches.first != nil) && touches.first == containerView {
            growingTextView.resignFirstResponder()
        }
        self.view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func heightForTextView(text:String, font:UIFont) -> CGFloat
    {
        let textV:UITextView = UITextView(frame: CGRectMake(0, 0, 225.0, CGFloat.max))
        textV.font = font
        textV.text = text
        textV.sizeToFit()
        return textV.frame.height
    }
    func sizeForTextView(text:String, font:UIFont) -> CGSize
    {
        let textV:UITextView = UITextView(frame: CGRectMake(0, 0, 225.0, CGFloat.max))
        textV.font = font
        textV.text = text
        textV.sizeToFit()
        return textV.frame.size
    }
    
    
    //MARK:- Send Text Message to server
    
    func sendTextMsg(text : String!) -> Void
    {
            let locId = CommonMethodFunctions.nextIdentifies()
            let strId = String(locId)
            
            var date = NSDate()
            var dateStr : String
            var timeStr : String
            let dateFormatter = NSDateFormatter()
        
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
            dateStr = dateFormatter.stringFromDate(NSDate())
            dateFormatter.dateFormat = "HH:mm:ss.sss"
            timeStr = dateFormatter.stringFromDate(date)
            let instance = DataBaseController.sharedInstance
            var dict = Dictionary<String, AnyObject>()
            dict["date"] = dateStr
            dict["sortDate"] = dateStr
            dict["time"] = timeStr
            dict["message"] = text
            dict["type"] = "text"
            dict["sender"] = ChatHelper .userDefaultForAny("userId") as! String
            dict["localmsgid"] = strId
        
            if self.isGroup == "0"
            {
                if contObj != nil
                {
                    dict["receiver"] = contObj.userId
                }else
                {
                    dict["receiver"] = recentChatObj.friendId
                }
                
                self.checkDateIsDifferent(dict)
                date = NSDate()
                dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
                dateStr = dateFormatter.stringFromDate(date)
                dict["date"] = dateStr
                
                dict["user_firstName"] = AppHelper.userDefaultsForKey("user_firstName")
                dict["profile_image"] = AppHelper.userDefaultsForKey("user_imageUrl") // NEW LINE ADDED BY ME 18 OCT
               
                
              //  print(AppHelper.userDefaultsForKey("user_imageUrl"))
                
                print(dict)
                
                
                let chatObj =  instance.insertChatMessageInDb1("UserChat", params: dict) as UserChat
                print(chatObj)
                
                chatArray.addObject(chatObj)
               // if self.recentChatObj == nil || chatArray.count == 2
               // {
                    self.saveRecentChat()
                //}
             
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
                chatArray.addObject(chatObj)
                
               // if self.recentChatObj == nil || chatArray.count == 2
                //{
                    self.saveRecentChat()
                //}
            }
          
            var sendMsgD = Dictionary<String,String>() 
        
            sendMsgD["userid"]=ChatHelper.userDefaultForKey("userId")
            sendMsgD["message"]=growingTextView.text
            sendMsgD["localmsgid"] = strId
            sendMsgD["type"] = "text"
        
            if self.isGroup == "0"
            {
                sendMsgD["recieverid"]=dict["receiver"] as? String
                sendMsgD["chatType"] = "oneToOne"
                
               // print(AppHelper.userDefaultsForKey("user_firstName"))
                if (AppHelper.userDefaultsForKey("user_firstName") as? String) != nil
                {
                    sendMsgD["user_firstName"] = AppHelper.userDefaultsForKey("user_firstName") as? String
                }
                if (AppHelper.userDefaultsForKey("user_imageUrl") as? String) != nil
                {
                    sendMsgD["profile_image"] = AppHelper.userDefaultsForKey("user_imageUrl") as? String
                }
                
                
                
                
                
                
               // sendMsgD["user_firstName"] = AppHelper.userDefaultsForKey("user_firstName") as String   // NEW LINE ADDED BY ME 18 OCT
               // sendMsgD["profile_image"] = AppHelper.userDefaultsForKey("user_imageUrl") as NSString // NEW LINE ADDED BY ME 18 OCT
                
              //  sendMsgD["phoneNumber"] = ChatHelper.userDefaultForKey("PhoneNumber") as String
                
            }else
            {
                
                if (AppHelper.userDefaultsForKey("user_firstName") as? String) != nil
                {
                    sendMsgD["user_firstName"] = AppHelper.userDefaultsForKey("user_firstName") as? String
                    sendMsgD["groupid"]=self.recentChatObj.groupId
                    sendMsgD["chatType"] = "groupChat"
                }
                if (AppHelper.userDefaultsForKey("user_imageUrl") as? String) != nil
                {
                    sendMsgD["profile_image"] = AppHelper.userDefaultsForKey("user_imageUrl") as? String
                }

//                sendMsgD["user_firstName"] = AppHelper.userDefaultsForKey("user_firstName") as String // NEW LINE ADDED BY ME 2 DEC
//                sendMsgD["profile_image"] = AppHelper.userDefaultsForKey("user_imageUrl") as NSString // NEW LINE ADDED BY ME 2 DEC
                
                
            }
        
            print(sendMsgD);
        
            ChatListner .getChatListnerObj().socket.emit("sendMessage", sendMsgD)

            growingTextView.text=""
            var path = [NSIndexPath]()
            path.append(NSIndexPath(forRow:chatArray.count-1,inSection:0))
            chatTableView.beginUpdates()
            chatTableView.insertRowsAtIndexPaths(path, withRowAnimation: UITableViewRowAnimation.None)
            chatTableView.endUpdates()
            
            if chatArray.count > 2
            {
                chatTableView.scrollToRowAtIndexPath(NSIndexPath(forRow:chatArray.count-1,inSection:0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
             }
    }
    
    func checkDateIsDifferent(dic : Dictionary<String, AnyObject>) -> Void
    {
        let instance = DataBaseController.sharedInstance
        var dict = Dictionary<String, AnyObject>()
        dict["date"] = dic["date"]
        
        dict["time"] = dic["time"]
        dict["message"] = ""
        dict["type"] = "notification"
        
        dict["sendername"] = ""
//        // ABOVE CODE COMMENTED BY ME - 18 OCT -2015
//        dict["user_firstName"] = ChatHelper .userDefaultForKey("user_firstName") as NSString
//        dict["profile_image"] = ChatHelper .userDefaultForKey("user_imageUrl") as NSString // NEW LINE ADDED BY ME 18 OCT
        
        dict["sender"] = ChatHelper .userDefaultForKey("userId") as NSString
        if self.isGroup == "0"
        {
            dict["receiver"] = dic["receiver"]
            
            
        }else
        {
            dict["groupid"] = self.recentChatObj.groupId
        }
        dict["localmsgid"] = ""
        if chatArray.count == 0
        {
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
            dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
            
            let date1 = dateFormatter.dateFromString(dict["date"] as! String)
            
            dateFormatter.dateFormat = "YYYY-MM-dd"
            let dateStr = dateFormatter.stringFromDate(date1!)
            dict["date"] = dateStr
            dict["sortDate"] = dateStr
            if self.isGroup == "0"
            {
                let chatObj = instance.insertChatMessageInDb1("UserChat", params: dict) as UserChat
                chatArray.addObject(chatObj)
            }else
            {
                let chatObj = instance.insertGroupChatMessageInDb1("GroupChat", params: dict) as GroupChat
                chatArray.addObject(chatObj)
            }
           
            var path = [NSIndexPath]()
            path.append(NSIndexPath(forRow:chatArray.count-1,inSection:0))
            chatTableView.beginUpdates()
            chatTableView.insertRowsAtIndexPaths(path, withRowAnimation: UITableViewRowAnimation.None)
            chatTableView.endUpdates()
            
            if chatArray.count > 2
            {
                chatTableView.scrollToRowAtIndexPath(NSIndexPath(forRow:chatArray.count-1,inSection:0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
            }
        }else
        {
            if self.isGroup == "0"
            {
                let chatObj = chatArray.lastObject as! UserChat
                let dateFormatter = NSDateFormatter()
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
                dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
                
                let date1 = dateFormatter.dateFromString(chatObj.messageDate!)
              //  print(chatObj.messageDate)
                dateFormatter.dateFormat = "YYYY-MM-dd"
                let dateStr = dateFormatter.stringFromDate(date1!)
                
                let date = NSDate()
                dateFormatter.timeZone = NSTimeZone()

                let dateStr1 = dateFormatter.stringFromDate(date)
                dict["date"] = dateStr1
                dict["sortDate"] = dateStr
                if dateStr != dateStr1
                {
                    let chatObj = instance.insertChatMessageInDb1("UserChat", params: dict) as UserChat
                    chatArray.addObject(chatObj)
                    var path = [NSIndexPath]()
                    path.append(NSIndexPath(forRow:chatArray.count-1,inSection:0))
                    chatTableView.beginUpdates()
                    chatTableView.insertRowsAtIndexPaths(path, withRowAnimation: UITableViewRowAnimation.None)
                    chatTableView.endUpdates()
                    
                    if chatArray.count > 2
                    {
                        chatTableView.scrollToRowAtIndexPath(NSIndexPath(forRow:chatArray.count-1,inSection:0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                    }
                }
            }else
            {
                let chatObj = chatArray.lastObject as! GroupChat
                let dateFormatter = NSDateFormatter()
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
                dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC");

                let date1 = dateFormatter.dateFromString(chatObj.messageDate!)
                dateFormatter.dateFormat = "YYYY-MM-dd"
                let dateStr = dateFormatter.stringFromDate(date1!)
                
                let date = NSDate()
                let dateStr1 = dateFormatter.stringFromDate(date)
                dict["date"] = dateStr1
                dict["sortDate"] = dateStr
                if dateStr != dateStr1
                {
                    let chatObj = instance.insertGroupChatMessageInDb1("GroupChat", params: dict) as GroupChat
                    chatArray.addObject(chatObj)
                    var path = [NSIndexPath]()
                    path.append(NSIndexPath(forRow:chatArray.count-1,inSection:0))
                    chatTableView.beginUpdates()
                    chatTableView.insertRowsAtIndexPaths(path, withRowAnimation: UITableViewRowAnimation.None)
                    chatTableView.endUpdates()
                    
                    if chatArray.count > 2
                    {
                        chatTableView.scrollToRowAtIndexPath(NSIndexPath(forRow:chatArray.count-1,inSection:0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                    }
                }
            }
            
        }
    }
    
    //MARK:- Send Image Message to server
    
    func sendImageFilePathToChatServer(dic : NSDictionary, filePath: String!, index: Int) -> Void
    {
        // print("sendImageFilePathToChatServer ====== sendMsgD to server====0")
        
         // print("index path -\(dic)")
        
        var newIndexPath:NSIndexPath = NSIndexPath(forRow:index,inSection:0)
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
        
      //   print_debug("sendMsgD to server====1")
        

        var sendMsgD = Dictionary<String, AnyObject>()
        
        sendMsgD["userid"] = ChatHelper .userDefaultForAny("userId") as! String
        sendMsgD["message"] = "image"
        sendMsgD["localmsgid"] = dic["localmsgid"]
        sendMsgD["type"] = "image"
        sendMsgD["mediaThumb"] = dic["mediaThumb"]
        
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
        
        sendMsgD["mediaUrl"] = filePath
        
    
     //   print("sendMsgD to server ==== 2")
        
        
        ChatListner .getChatListnerObj().socket.emit("sendMessage", sendMsgD)
        
      //  print(sendMsgD)

        
    }
    
    func sendVideoFilePathToChatServer(dic : NSDictionary, filePath: String!, index: Int) -> Void
    {
        //print("got video file 0")
        
        //print("sendVideoFilePathToChatServer \(dic)")
        
        var newIndexPath:NSIndexPath = NSIndexPath(forRow:index,inSection:0)
       // print(newIndexPath)

        if index == -1
        {
            newIndexPath = NSIndexPath(forRow:dic["index"] as! Int,inSection:0)
        }
        
        
        let visibleCell : NSArray = chatTableView.indexPathsForVisibleRows!
        let str : String = dic["localmsgid"] as! String
        
        if(visibleCell.containsObject(newIndexPath))
        {
            let cell:UITableViewCell = chatTableView.cellForRowAtIndexPath(newIndexPath)!
            
            let progressV = cell.contentView.viewWithTag(22) as! PICircularProgressView
            let playBtn = cell.contentView.viewWithTag(24) as! UIButton
            playBtn.hidden = true
            progressV.hidden = false
            
            // New below code open by prabodh 14 dec 2015
            
          //  let str : String = dic["localmsgid"] as String!
            
            ChatListner .getChatListnerObj().chatProgressV[str] = progressV
            ChatListner .getChatListnerObj().chatProgressV.removeObjectForKey(str)
            let image = UIImage(named: "button_chat_play") as UIImage!
            playBtn.setImage(image, forState: .Normal)
        }
        // New above code open by prabodh 14 dec 2015
        
        
        var sendMsgD = Dictionary<String, AnyObject>()
        
        sendMsgD["userid"] = ChatHelper .userDefaultForAny("userId") as! String
        sendMsgD["message"] = "video"
        sendMsgD["localmsgid"] = dic["localmsgid"]
        sendMsgD["type"] = "video"
        sendMsgD["mediaThumb"] = dic["mediaThumb"]
        
         sendMsgD["mediaUrl"] = filePath
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
            
          //  sendMsgD["user_firstName"] = ChatHelper .userDefaultForKey("user_firstName") as NSString // NEW LINE ADDED BY ME 18 OCT
           // sendMsgD["profile_image"] = ChatHelper .userDefaultForKey("user_imageUrl") as NSString // NEW LINE ADDED BY ME 18 OCT
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
        
        ChatListner .getChatListnerObj().socket.emit("sendMessage", sendMsgD)

    }
    
    
    func sendAudioFilePathToChatServer(dic : NSDictionary, filePath: String!, index: Int) -> Void
    {
        
        //print("got audio file 0")
        
       // print("sendAudioFilePathToChatServer \(dic)")
        
        var newIndexPath:NSIndexPath = NSIndexPath(forRow:index,inSection:0)
        if index == -1
        {
            newIndexPath = NSIndexPath(forRow:dic["index"] as! Int,inSection:0)
        }
        
        let visibleCell : NSArray = chatTableView.indexPathsForVisibleRows!
        let str : String = dic["localmsgid"] as! String
        
        if(visibleCell.containsObject(newIndexPath))
        {
           // print("got audio file 2")
            if     let cell:ChatAudioSenderCell = self.chatTableView.cellForRowAtIndexPath(newIndexPath)! as? ChatAudioSenderCell
            {
           // let cell:UITableViewCell = chatTableView.cellForRowAtIndexPath(newIndexPath)!
            let progressV = cell.contentView.viewWithTag(22) as! PICircularProgressView
            let  playBtn = cell.contentView.viewWithTag(24) as! UIButton
    
            playBtn.hidden = false
            progressV.hidden = true
            
             //   print("got audio file 3")
            // New below code open by prabodh 14 dec 2015
           // let str : String = dic["localmsgid"] as String!
            
            ChatListner .getChatListnerObj().chatProgressV[str] = progressV
            
            ChatListner .getChatListnerObj().chatProgressV.removeObjectForKey(str)
            
            let image = UIImage(named: "button_chat_play") as UIImage!
            playBtn.setImage(image, forState: .Normal)
            }
        }
        // New above code open by prabodh 14 dec 2015

       // print("got audio file 4")

        var sendMsgD = Dictionary<String, AnyObject>()
        
        
        sendMsgD["userid"] = ChatHelper .userDefaultForAny("userId") as! String
        sendMsgD["message"] = "audio"
        sendMsgD["localmsgid"] = dic["localmsgid"]
        sendMsgD["type"] = "audio"
        sendMsgD["mediaThumb"] = dic["mediaThumb"]
         sendMsgD["mediaUrl"] = filePath
        if isGroup == "0"
        {
            sendMsgD["chatType"] = "oneToOne"
            sendMsgD["user_firstName"] = ChatHelper .userDefaultForAny("user_firstName") as! String // NEW LINE ADDED BY ME 18 OCT
            sendMsgD["profile_image"] = ChatHelper .userDefaultForAny("user_imageUrl") as! String // NEW LINE ADDED BY ME 18 OCT
            
            sendMsgD["phoneNumber"] = ChatHelper.userDefaultForKey("PhoneNumber") as String
            sendMsgD["recieverid"] = dic["receiver"]
        }else
        {
            
            sendMsgD["user_firstName"] = ChatHelper .userDefaultForAny("user_firstName") as! String // NEW LINE ADDED BY ME 8 dec
            sendMsgD["profile_image"] = ChatHelper .userDefaultForAny("user_imageUrl") as! String // NEW LINE ADDED BY ME  8 dec
            
            sendMsgD["chatType"] = "groupChat"
            sendMsgD["groupid"] = recentChatObj.groupId
        }
 
        ChatListner .getChatListnerObj().socket.emit("sendMessage", sendMsgD)
        
      //  print(sendMsgD)

    }
    
    
    /* SEND IMAGE TO SEVER WITHOUT CDN
    
    func sendImageToServer(dic : NSDictionary, imageData: NSData!, index: Int) -> Void
    {
        let newIndexPath:NSIndexPath = NSIndexPath(forRow:index,inSection:0)
        let cell:UITableViewCell = chatTableView.cellForRowAtIndexPath(newIndexPath)!
        var progressV = cell.contentView.viewWithTag(22) as PICircularProgressView
        progressV.hidden = false
        
        let str : String = dic["localmsgid"] as String!
        ChatListner .getChatListnerObj().chatProgressV[str] = progressV
        
        let baseUrlString = ChatBaseMediaUrl+ChatMediaPath
        let url = NSURL(string: baseUrlString)?.absoluteString
        let manager=AFHTTPRequestOperationManager()
        var requestOperation=AFHTTPRequestOperation()
        var sendMsgD = Dictionary<String, AnyObject>()
        
        sendMsgD["userid"] = ChatHelper .userDefaultForAny("userId") as NSString
        sendMsgD["message"] = "image"
        sendMsgD["localmsgid"] = dic["localmsgid"]
        sendMsgD["type"] = "image"
        sendMsgD["mediaThumb"] = dic["mediaThumb"]
        
        if isGroup == "0"
        {
            sendMsgD["chatType"] = "oneToOne"
            sendMsgD["user_firstName"] = ChatHelper.userDefaultForKey("user_firstName") as NSString // NEW LINE ADDED BY ME 18 OCT
            sendMsgD["profile_image"] = ChatHelper.userDefaultForKey("user_imageUrl") as NSString // NEW LINE ADDED BY ME 18 OCT
            
            sendMsgD["phoneNumber"] = ChatHelper.userDefaultForKey("PhoneNumber") as String
            sendMsgD["recieverid"] = dic["receiver"]
        }else
        {
            sendMsgD["chatType"] = "groupChat"
            sendMsgD["groupid"] = recentChatObj.groupId
        }
        
        print_debug("sendMsgD to server")
        
        requestOperation = manager.POST(url, parameters: nil, constructingBodyWithBlock: {
            (formdata:AFMultipartFormData!)-> Void  in
            
            if(imageData != nil)
            {
                formdata.appendPartWithFileData(imageData, name: "files", fileName: dic["localFullPath"] as String, mimeType: "image/jpeg")
            }
            
            
            },
            success:
            {
                operation, response -> Void in
                progressV.hidden = true
                //Parsing JSON
                var parsedData = JSONValue(response)
                
                print_debug(" server response===")
                
                // Media Url PK SEARCH PATH
                
                sendMsgD["mediaUrl"] = parsedData["filesUrl"].string
                
                ChatListner .getChatListnerObj().chatProgressV.removeObjectForKey(str)
                
                print_debug("message ready for send === ")
                ChatListner .getChatListnerObj().socket.emit("sendMessage", sendMsgD)
                
            }, failure:
            {
                operation, response -> Void in
                print_debug(response)
     
            }
        )
        requestOperation .setUploadProgressBlock { (bytesWritten : UInt, totalBytesWritten : Int64, totalBytesExpectedToWrite: Int64) -> Void in
            
            var progress: Float = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite);
            progressV =     ChatListner .getChatListnerObj().chatProgressV[str] as PICircularProgressView
            progressV.progress=Double(progress);
        }
        requestOperation.start()
        
    }
    */
 
    //MARK:- Send Video Message to server without CDN
    /*
    func sendVideoToServer(dic : NSDictionary, videoData: NSData!, index: Int) -> Void
    {
        let newIndexPath:NSIndexPath = NSIndexPath(forRow:index,inSection:0)
        let cell:UITableViewCell = chatTableView.cellForRowAtIndexPath(newIndexPath)!
        var progressV = cell.contentView.viewWithTag(22) as PICircularProgressView
        var playBtn = cell.contentView.viewWithTag(24) as UIButton
        playBtn.hidden = true
        progressV.hidden = false
        
        let str : String = dic["localmsgid"] as String!
            ChatListner .getChatListnerObj().chatProgressV[str] = progressV
        
        let baseUrlString = ChatBaseMediaUrl+ChatMediaPath
        let url = NSURL(string: baseUrlString)?.absoluteString
        let manager=AFHTTPRequestOperationManager()
        var requestOperation=AFHTTPRequestOperation()
        var sendMsgD = Dictionary<String, AnyObject>()
        
        
        sendMsgD["userid"] = ChatHelper .userDefaultForAny("userId") as NSString
        sendMsgD["message"] = "video"
        sendMsgD["localmsgid"] = dic["localmsgid"]
        sendMsgD["type"] = "video"
        sendMsgD["mediaThumb"] = dic["mediaThumb"]
        
        if isGroup == "0"
        {
            sendMsgD["chatType"] = "oneToOne"
            sendMsgD["user_firstName"] = ChatHelper .userDefaultForKey("user_firstName") as NSString // NEW LINE ADDED BY ME 18 OCT
            sendMsgD["profile_image"] = ChatHelper .userDefaultForKey("user_imageUrl") as NSString // NEW LINE ADDED BY ME 18 OCT
            sendMsgD["phoneNumber"] = ChatHelper.userDefaultForKey("PhoneNumber") as String
            sendMsgD["recieverid"] = dic["receiver"]
        }else
        {
            sendMsgD["chatType"] = "groupChat"
            sendMsgD["groupid"] = recentChatObj.groupId
        }
   
       requestOperation = manager.POST(url, parameters: nil, constructingBodyWithBlock: {
            (formdata:AFMultipartFormData!)-> Void  in
            
            if(videoData != nil)
            {
                formdata.appendPartWithFileData(videoData, name: "files", fileName: dic["localFullPath"] as String, mimeType: "video/quicktime")
            }
            },
            success:
            {
                operation, response -> Void in
                progressV.hidden = true
                playBtn.hidden = false
                let image = UIImage(named: "button_chat_play") as UIImage!
                playBtn.setImage(image, forState: .Normal)
  
                //Parsing JSON
                var parsedData = JSONValue(response)
          
                sendMsgD["mediaUrl"] = parsedData["filesUrl"].string
   
                    ChatListner .getChatListnerObj().chatProgressV.removeObjectForKey(str)
               
                    ChatListner .getChatListnerObj().socket.emit("sendMessage", sendMsgD)
                
            }, failure:
            {
                operation, response -> Void in
                print_debug(response)
                
            }
        
        )
        requestOperation .setUploadProgressBlock { (bytesWritten : UInt, totalBytesWritten : Int64, totalBytesExpectedToWrite: Int64) -> Void in

            var progress: Float = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite);
             progressV =     ChatListner .getChatListnerObj().chatProgressV[str] as PICircularProgressView
            progressV.progress=Double(progress);
        }
        requestOperation.start()
        
        
    }
    */
    
     //MARK:- Send Audio Message to server
    /*
    func sendAudioToServer(dic : NSDictionary, audioData: NSData!, index: Int) -> Void
    {
        let newIndexPath:NSIndexPath = NSIndexPath(forRow:index,inSection:0)
        let cell:UITableViewCell = chatTableView.cellForRowAtIndexPath(newIndexPath)!
       
        var progressV = cell.contentView.viewWithTag(22) as PICircularProgressView
        var playBtn = cell.contentView.viewWithTag(24) as UIButton
        playBtn.hidden = true
        progressV.hidden = false
        
        let str : String = dic["localmsgid"] as String!
            ChatListner .getChatListnerObj().chatProgressV[str] = progressV
        
        let baseUrlString = ChatBaseMediaUrl+ChatMediaPath
        let url = NSURL(string: baseUrlString)?.absoluteString
        let manager=AFHTTPRequestOperationManager()
        var requestOperation=AFHTTPRequestOperation()
        var sendMsgD = Dictionary<String, AnyObject>()
        
        
        sendMsgD["userid"] = ChatHelper .userDefaultForAny("userId") as NSString
        sendMsgD["message"] = "audio"
        sendMsgD["localmsgid"] = dic["localmsgid"]
        sendMsgD["type"] = "audio"
        sendMsgD["mediaThumb"] = dic["mediaThumb"]
        
        if isGroup == "0"
        {
            sendMsgD["chatType"] = "oneToOne"
            sendMsgD["user_firstName"] = ChatHelper .userDefaultForAny("user_firstName") as NSString // NEW LINE ADDED BY ME 18 OCT
            sendMsgD["profile_image"] = ChatHelper .userDefaultForAny("user_imageUrl") as NSString // NEW LINE ADDED BY ME 18 OCT

            sendMsgD["phoneNumber"] = ChatHelper.userDefaultForKey("PhoneNumber") as String
            sendMsgD["recieverid"] = dic["receiver"]
        }else
        {
            sendMsgD["chatType"] = "groupChat"
            sendMsgD["groupid"] = recentChatObj.groupId
        }
        requestOperation = manager.POST(url, parameters: nil, constructingBodyWithBlock: {
            (formdata:AFMultipartFormData!)-> Void  in
            
            if(audioData != nil)
            {
                formdata.appendPartWithFileData(audioData, name: "files", fileName: dic["localFullPath"] as String, mimeType: "audio/mp3")
            }
            },
            success:
            {
                operation, response -> Void in
                progressV.hidden = true
                playBtn.hidden = false
                //Parsing JSON
                var parsedData = JSONValue(response)
           
                sendMsgD["mediaUrl"] = parsedData["filesUrl"].string
                    ChatListner .getChatListnerObj().chatProgressV.removeObjectForKey(str)
                    ChatListner .getChatListnerObj().socket.emit("sendMessage", sendMsgD)
                
            }, failure:
            {
                operation, response -> Void in
                print_debug(response)
                
            }
            
            
        )
        requestOperation .setUploadProgressBlock { (bytesWritten : UInt, totalBytesWritten : Int64, totalBytesExpectedToWrite: Int64) -> Void in
            var progress: Float = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite);
             progressV =     ChatListner .getChatListnerObj().chatProgressV[str] as PICircularProgressView
            progressV.progress=Double(progress);
        }
        requestOperation.start()
    }
    */
    
     //MARK:- Group Detail Click
    
    @IBAction func groupDetailClick(sender: AnyObject)
    {
        //return// meldr app
        if isGroup == "1"
        {
            //HIDE++++++++
            
            let str:String = ChatHelper.userDefaultForKey("userId") as String!
            let str1:String = recentChatObj.groupId as String!
            let strPred:String = "loginUserId contains[cd] \"\(str)\" AND groupId LIKE \"\(str1)\""
            let instance = DataBaseController.sharedInstance
            let fetchResult=instance.fetchData("GroupList", predicate: strPred, sort: ("groupId",false))! as NSArray
            var groupObj : GroupList!
            for myobject : AnyObject in fetchResult
            {
                groupObj = myobject as! GroupList
                
            }
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let chatMainObj: GroupDetailVC = storyBoard.instantiateViewControllerWithIdentifier("GroupDetailVC") as! GroupDetailVC
            chatMainObj.groupObj=groupObj
            
            if self.exitedView.hidden == false
            {
                chatMainObj.deletedGroup=true
            }else
            {
                chatMainObj.deletedGroup=false
            }
            
            
            self.navigationController?.pushViewController(chatMainObj, animated: true)
 
        }
        else
        {
            /*if self.recentChatObj != nil
            {
                let str:String = ChatHelper.userDefaultForKey("userId") as String!
                let str1:String = recentChatObj.friendId as String!
                let strPred:String = "loginUserId contains[cd] \"\(str)\" AND userId contains[cd] \"\(str1)\""
                
                
                let instance = DataBaseController.sharedInstance
                let appContObj=instance.fetchDataAppContObject("AppContactList", predicate: strPred) as AppContactList?
                if appContObj == nil
                {
                    let newRecord: ABRecordRef = ABPersonCreate().takeRetainedValue()
                    
                    let phoneNumbers: ABMutableMultiValue =
                    ABMultiValueCreateMutable(ABPropertyType(kABMultiStringPropertyType)).takeRetainedValue()
                    ABMultiValueAddValueAndLabel(phoneNumbers, self.recentChatObj.friendName, kABPersonPhoneMainLabel, nil)
                    ABRecordSetValue(newRecord, kABPersonPhoneProperty, phoneNumbers,nil);
                    
                    
                    let controller = ABNewPersonViewController()
                    controller.displayedPerson = newRecord;
                    controller.newPersonViewDelegate = self
                    let navigationController = UINavigationController(rootViewController: controller)
                    self.presentViewController(navigationController, animated: true, completion: nil)
                }
            }*/
        }
    }
    
     //MARK:- Add to Contact Click
    
    func newPersonViewController(newPersonView: ABNewPersonViewController, didCompleteWithNewPerson person: ABRecordRef?) {
        
        newPersonView.navigationController?.dismissViewControllerAnimated(true, completion: nil);
        if person != nil
        {
            ChatHelper .removeFromUserDefaultForKey("oneTimePostNotification")
        }
    }
    
    
     //MARK:- Email conversation click
    
    func emailAlertMethod() -> Void
    {
        var strAlert : String!
        if self.recentChatObj != nil
        {
            strAlert = "Are you sure you want to email conversation to " + self.recentChatObj.friendName! + "?"
        }
        else
        {
            strAlert = "Are you sure you want to email conversation to " + self.contObj.name + "?"
        }
        if(IS_IOS_7)
        {
            ChatHelper.showALertWithTag(1000, title: APP_NAME, message: strAlert, delegate: self, cancelButtonTitle: "Cancel", otherButtonTitle: "OK")
        }
        else
        {
            let alertController = UIAlertController(title:APP_NAME, message: strAlert , preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                
            }))
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                self.emailConversationWithMedia()
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
     //MARK:- Block Methods
    
    func blockAlertMethod() -> Void
    {
        if(IS_IOS_7)
        {
            ChatHelper.showALertWithTag(1001, title: APP_NAME, message: "Under Development", delegate: self, cancelButtonTitle: "OK", otherButtonTitle: nil)
        }
        else
        {
            let alertController = UIAlertController(title:APP_NAME, message: "Under Development" , preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
   
    }

    func reportAlertMethod() -> Void
    {
        var reportStr : String!
        
        if self.recentChatObj != nil
        {
            if  self.recentChatObj.isReport == "0"
            {
                reportStr = "Are you sure you want to " + "report " + self.recentChatObj.friendName! + "?"
            }
        }else
        {
            if self.contObj.isReport == "0"
            {
                reportStr = "Are you sure you want to " + "report " + self.contObj.name + "?"
            }
        }

        if(IS_IOS_7)
        {
            ChatHelper.showALertWithTag(1002, title: APP_NAME, message: reportStr, delegate: self, cancelButtonTitle: "Cancel", otherButtonTitle: "OK")
        }
        else
        {
            let alertController = UIAlertController(title:APP_NAME, message: reportStr , preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                
            }))
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                self.reportUserMethod()
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func deleteAlertMethod() -> Void
    {
        var reportStr : String!
        
        if self.recentChatObj != nil
        {
            reportStr = "Are you sure you want to " + "delete conversation with " + self.recentChatObj.friendName! + "?"
        }else
        {
            reportStr = "Are you sure you want to " + "delete conversation with " + self.contObj.name + "?"
        }
        if(IS_IOS_7)
        {
            ChatHelper.showALertWithTag(1003, title: APP_NAME, message: reportStr, delegate: self, cancelButtonTitle: "Cancel", otherButtonTitle: "OK")
        }
        else
        {
            let alertController = UIAlertController(title:APP_NAME, message: reportStr , preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                
            }))
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                self.deleteConversation()
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int)
    {
        switch View.tag
        {
        case 1000:
            if buttonIndex == 1
            {
                self.emailAlertMethod()
            }
            break;
        case 1001:
            if buttonIndex == 1
            {
                self.blockAlertMethod()
            }
            break;
        case 1002:
            if buttonIndex == 1
            {
                self.reportUserMethod()
            }
            break;
        case 1003:
            if buttonIndex == 1
            {
                self.deleteConversation()
            }
            break;
        default:
            break;
        }
    }
    
    func emailConversationWithMedia() -> Void
    {
        if MFMailComposeViewController.canSendMail()
        {
            let instance = DataBaseController.sharedInstance
            let picker = MFMailComposeViewController()
            picker.mailComposeDelegate = self
            if isGroup == "0"
            {
                var bodyStr : String!
                if contObj != nil
                {
                    picker.setSubject(AppName+" app chat with "+self.contObj.name)
                    bodyStr = "Chat history is attached as "+AppName+" chat with " + self.contObj.name + " file to this email."
                }else
                {
                    picker.setSubject(AppName+" app chat with "+self.recentChatObj.friendName!)
                    bodyStr = "Chat history is attached as "+AppName+" chat with " + self.recentChatObj.friendName! + " file to this email."
                }
                
                picker.setMessageBody(bodyStr, isHTML: true)
                var messageStr : String!
                var completeStr : String!
                var dateStr : String!
                var timeStr : String!
                var senderName : String!
                completeStr = ""
                dateStr = ""
                messageStr = ""
                senderName = ""
                timeStr = ""
                let dateFormatter = NSDateFormatter()
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                for myObject : AnyObject in chatArray
                {
                    let chatObj = myObject as! UserChat
                    if chatObj.messageType != "notification"
                    {
                        dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
                        let date = dateFormatter.dateFromString(chatObj.messageDate!)
                        dateFormatter.dateFormat = "HH:mm:ss.sss"
                        let date1 = dateFormatter.dateFromString(chatObj.messageTime!)
                        
                        dateFormatter.dateFormat = "dd MMM"
                        dateStr = dateFormatter.stringFromDate(date!)
                        dateFormatter.dateFormat = "HH:mm"
                        timeStr = dateFormatter.stringFromDate(date1!)
                        dateStr = timeStr + ", " + dateStr
                        let str1:String = chatObj.senderId as String!
                        let strPred1:String = "userId contains[cd] \"\(str1)\""
                        let appContObj=instance.fetchDataAppContObject("AppContactList", predicate: strPred1) as AppContactList?
                        if chatObj.senderId != ChatHelper .userDefaultForAny("userId") as? String
                        {
                            if appContObj != nil
                            {
                                senderName = appContObj?.name
                            }
                        }else
                        {
                            senderName = "Me"
                        }
                        if chatObj.messageType == "text"
                        {
                            messageStr = chatObj.message
                        }
                        else if chatObj.messageType == "image"
                        {

                        }else if chatObj.messageType == "audio"
                        {
                            //messageStr = "send a audio"
                        }else if chatObj.messageType == "video"
                        {
                            //messageStr = "send a video"
                        }
                        if completeStr.characters.count == 0
                        {
                            completeStr = " " + dateStr + " " + senderName + " " + messageStr + "\n"
                        }
                        else
                        {
                            completeStr = completeStr+" "+dateStr + " " + senderName + " " + messageStr + "\n"
                        }
         
                    }
                }
                let myData : NSData? = completeStr.dataUsingEncoding(NSUTF8StringEncoding)
                picker.addAttachmentData(myData!, mimeType: "text/plain", fileName: AppName+" chat with "+senderName)
            }else
            {
                var bodyStr : String!
                
                picker.setSubject(AppName+" app chat with "+self.recentChatObj.friendName!)
                bodyStr = "Chat history is attached as "+AppName+" chat with " + self.recentChatObj.friendName! + " file to this email."
                
                
                picker.setMessageBody(bodyStr, isHTML: true)
                var messageStr : String!
                var completeStr : String!
                var dateStr : String!
                var timeStr : String!
                var senderName : String!
                completeStr = ""
                dateStr = ""
                messageStr = ""
                senderName = ""
                timeStr = ""
                let dateFormatter = NSDateFormatter()
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                for myObject : AnyObject in chatArray
                {
                    let chatObj = myObject as! GroupChat
                    if chatObj.messageType != "notification"
                    {
                        dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
                        let date = dateFormatter.dateFromString(chatObj.messageDate!)
                        dateFormatter.dateFormat = "HH:mm:ss.sss"
                        let date1 = dateFormatter.dateFromString(chatObj.messageTime!)
                        
                        dateFormatter.dateFormat = "dd MMM"
                        dateStr = dateFormatter.stringFromDate(date!)
                        dateFormatter.dateFormat = "HH:mm"
                        timeStr = dateFormatter.stringFromDate(date1!)
                        dateStr = timeStr + ", " + dateStr
                        if chatObj.senderId != ChatHelper .userDefaultForAny("userId") as? String
                        {
                            senderName = chatObj.senderName
                        }else
                        {
                            senderName = "Me"
                        }
                        if chatObj.messageType == "text"
                        {
                            messageStr = chatObj.message
                        }
                        else if chatObj.messageType == "image"
                        {
                        }else if chatObj.messageType == "audio"
                            
                        {
                        }else if chatObj.messageType == "video"
                        {
                        }
                        if completeStr.characters.count == 0
                        {
                            completeStr = " " + dateStr + " " + senderName + " " + messageStr + "\n"
                        }
                        else
                        {
                            completeStr = completeStr+" "+dateStr + " " + senderName + " " + messageStr + "\n"
                        }
             
                    }
                }
                let myData : NSData? = completeStr.dataUsingEncoding(NSUTF8StringEncoding)
                picker.addAttachmentData(myData!, mimeType: "text/plain", fileName: AppName+" chat with "+senderName)
            }
            
             presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult,
                                                   error: NSError?){
            
            switch(result.rawValue){
            case MFMailComposeResultSent.rawValue:
                print("Email sent")
                
            default:
                print("Whoops")
            }
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
    }
    // videoMaximumDuration
    func blockUserMethod() -> Void
    {
        if self.recentChatObj != nil
        {
            let str:String = self.recentChatObj.friendId as String!
            let strPred:String = "userId contains[cd] \"\(str)\""
            let instance = DataBaseController.sharedInstance
            let appContObj=instance.fetchDataAppContObject("AppContactList", predicate: strPred) as AppContactList?
            
            if  self.recentChatObj.isBlock == "1"
            {
                self.recentChatObj.isBlock = "0"
                appContObj?.isBlock = "0"
            }else
            {
                self.recentChatObj.isBlock = "1"
                appContObj?.isBlock = "1"
            }


        }else
        {
            if  self.contObj.isBlock == "1"
            {
                self.contObj.isBlock = "0"
            }else
            {
                self.contObj.isBlock = "1"
            }
        }
        
        homeCoreData.saveContext()
    }
    
    func reportUserMethod() -> Void
    {
        if self.recentChatObj != nil
        {
            
            if self.recentChatObj.isReport == "0"
            {
                self.recentChatObj.isReport = "1"
                let str:String = self.recentChatObj.friendId as String!
                let strPred:String = "userId contains[cd] \"\(str)\""
                let instance = DataBaseController.sharedInstance
                let appContObj=instance.fetchDataAppContObject("AppContactList", predicate: strPred) as AppContactList?
                appContObj?.isReport = "1"
                homeCoreData.saveContext()
            }
        }else
        {
            if self.contObj.isReport == "0"
            {
                self.contObj.isReport = "1"
                homeCoreData.saveContext()
            }
        }
        
    }
    
    @IBAction func viewEarlierMessageClick(sender: UIButton)
    {
        dispatch_after(1, dispatch_get_main_queue(), {
            // your function here
            self.getLoadPreviousMsg()
        })
    }
    
     //MARK:- Add To Contact Click
    
    
    @IBAction func addContactClick(sender: UIButton)
    {
        if self.recentChatObj != nil && self.isGroup == "0"
        {
            let str:String = ChatHelper.userDefaultForKey("userId") as String!
            let str1:String = recentChatObj.friendId as String!
            let strPred:String = "loginUserId contains[cd] \"\(str)\" AND userId contains[cd] \"\(str1)\""
            
            
            let instance = DataBaseController.sharedInstance
            let appContObj=instance.fetchDataAppContObject("AppContactList", predicate: strPred) as AppContactList?
            if appContObj == nil
            {
                
                let newRecord: ABRecordRef = ABPersonCreate().takeRetainedValue()
                
                let phoneNumbers: ABMutableMultiValue =
                ABMultiValueCreateMutable(ABPropertyType(kABMultiStringPropertyType)).takeRetainedValue()
                ABMultiValueAddValueAndLabel(phoneNumbers, self.recentChatObj.friendName, kABPersonPhoneMainLabel, nil)
               ABRecordSetValue(newRecord, kABPersonPhoneProperty, phoneNumbers,nil);
                
                let controller = ABNewPersonViewController()

                controller.displayedPerson = newRecord;
                controller.newPersonViewDelegate = self
                let navigationController = UINavigationController(rootViewController: controller)
                self.presentViewController(navigationController, animated: true, completion: nil)
            }
        }
    }
    
     //MARK:- Load Earlier Message Click
    
    func getLoadPreviousMsg()
    {
        if isGroup == "0"
        {
            let strLogin:String = ChatHelper .userDefaultForAny("userId") as! String
            let strSender:String = ChatHelper .userDefaultForAny("userId") as! String
            var strReceiver = ""
            if contObj != nil
            {
                strReceiver = contObj.userId as String
            }else
            {
                strReceiver = recentChatObj.friendId! as String
            }
            
            let strPred:String = "loginUserId contains[cd] \"\(strLogin)\" AND (( senderId contains[cd] \"\(strSender)\" AND receiverId contains[cd] \"\(strReceiver)\") OR ( senderId contains[cd] \"\(strReceiver)\" AND receiverId contains[cd] \"\(strSender)\"))"
            
            
            let instance = DataBaseController.sharedInstance
            let fetchResult = instance.fetchNextChatData("UserChat", predicate: strPred, sort: ("localSortID",false), messageCount: self.chatArray.count)! as NSArray
            
            self.chatArray.removeAllObjects()
            for myobject : AnyObject in fetchResult
            {
                let anObject = myobject as! UserChat
                chatArray.insertObject(anObject, atIndex: 0)
            }
        }else
        {
            let strLogin:String = ChatHelper .userDefaultForAny("userId") as! String
            let strGroupId = self.recentChatObj.groupId! as String
            
            
            let strPred:String = "loginUserId contains[cd] \"\(strLogin)\" AND groupId LIKE \"\(strGroupId)\""
            let instance = DataBaseController.sharedInstance
            let fetchResult = instance.fetchNextChatData("GroupChat", predicate: strPred, sort: ("localSortID",false), messageCount: self.chatArray.count)! as NSArray
            
            self.chatArray.removeAllObjects()
            for myobject : AnyObject in fetchResult
            {
                let anObject = myobject as! GroupChat
                chatArray.insertObject(anObject, atIndex: 0)
            }
        }
        self.getHeaderFile()
    }
    
    func getHeaderFile()
    {
        if isGroup == "0"
        {
            let strLogin:String = ChatHelper .userDefaultForAny("userId") as! String
            let strSender:String = ChatHelper .userDefaultForAny("userId") as! String
            var strReceiver = ""
            if contObj != nil
            {
                strReceiver = contObj.userId as String
            }else
            {
                strReceiver = recentChatObj.friendId! as String
            }
            
            let strPred:String = "loginUserId contains[cd] \"\(strLogin)\" AND (( senderId contains[cd] \"\(strSender)\" AND receiverId contains[cd] \"\(strReceiver)\") OR ( senderId contains[cd] \"\(strReceiver)\" AND receiverId contains[cd] \"\(strSender)\"))"
            let instance = DataBaseController.sharedInstance
            let count = instance.fetchChatDataCount("UserChat", predicate: strPred) as Int
            
            if (count == self.chatArray.count)
            {
                chatTableView.tableHeaderView=nil;
                chatTableView.reloadData()
            }else
            {
                self.addHeaderViewInTable()
                chatTableView.reloadData()
            }
        }else
        {
            let strLogin:String = ChatHelper .userDefaultForAny("userId") as! String
            let strGroupId = self.recentChatObj.groupId! as String
            
            
            let strPred:String = "loginUserId contains[cd] \"\(strLogin)\" AND groupId LIKE \"\(strGroupId)\""
            
            let instance = DataBaseController.sharedInstance
            let count = instance.fetchChatDataCount("GroupChat", predicate: strPred) as Int
            
            if (count == self.chatArray.count)
            {
                chatTableView.tableHeaderView=nil;
                chatTableView.reloadData()
            }else
            {
                self.addHeaderViewInTable()
                chatTableView.reloadData()
            }
        }
        
    }
    
   
    func controllerWillChangeContent(controller: NSFetchedResultsController)
    {
        
    }

    func controller(controller: NSFetchedResultsController,
        didChangeObject object: AnyObject,
                        atIndexPath indexPath: NSIndexPath?,
                                    forChangeType type: NSFetchedResultsChangeType,
                                                  newIndexPath: NSIndexPath?) {
            switch type {
                
            case .Insert:
                //print("Insert")
                return
            case .Update:
                //print("Update")
                return
            case .Move:
                //print("Move")
                return
            case .Delete:
                //print("Delete")
                return
            default:
                return
            }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController)
    {
        
    }
    
    
    
    // Multiple Image Seleting Code
    
    
    
    func openActionSheet() -> Void
    {
        
        if(IS_IOS_7)
        {
            let actionSheet = UIActionSheet(title:"", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle:nil, otherButtonTitles: "Send images","Send Video")
            actionSheet.tag=10001
            actionSheet.showFromTabBar((bottomTabBar?.tabBar)!)
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
    
    func openActionSheetOnFailedMessage(dic : NSDictionary , videoData: NSData!, index: Int) -> Void
    {
        
        if(IS_IOS_7)
        {
            let actionSheet = UIActionSheet(title:"", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle:nil, otherButtonTitles: "Resend Video")
            actionSheet.tag=10002
            actionSheet.showFromTabBar((bottomTabBar?.tabBar)!)
        }
        else
        {
            let actionSheet =  UIAlertController(title:"", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Resend Video", style: UIAlertActionStyle.Default, handler:
                { (ACTION :UIAlertAction!)in
                    
                    
                    // bellow code is WRITTEN by pk on 2 dec 2015
                    
                  //  self.sendVideoToServer(dic, videoData: videoData , index: index)
                    
                    // bellow code is WRITTEN by pk on 2 dec 2015
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock() { () in
                        
                        let name = self.uniqueName("")
                        UploadInS3.sharedGlobal().uploadImageTos3( videoData, type: 1, fromDist: "chat", meldID: name, completion: { ( bool_val : Bool, pathUrl : String!) -> Void in
                            if bool_val == true
                            {
                                let fileName =  UploadInS3.sharedGlobal().strFilesName
                                //  progressV.hidden = true
                                if fileName != nil{
                                    self.sendVideoFilePathToChatServer(dic, filePath: fileName, index: index)
                                }
                            }
                            
                            }
                            , completionProgress: { ( bool_val : Bool, progress) -> Void in
                                
                                
                                
                                // print("pathSelected \(pathSelected)")
                                
                                
                                //let newIndexPath:NSIndexPath = NSIndexPath(forRow:dict["index"] as Int,inSection:0)
                                //
                                //
                                //                            let cell:UITableViewCell = self.chatTableView.cellForRowAtIndexPath(pathSelected)!
                                //                            var progressV = cell.contentView.viewWithTag(22) as PICircularProgressView
                                //                            progressV.hidden = false
                                //                            progressV.progress=progress
                                //
                                //                            if(progress == 1.0)
                                //                            {
                                //                                progressV.hidden = true
                                //
                                //                            }
                            }
                        )
                        
                    }
                    
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
    
    func imagePickerControllerDidSelectedAssets(assets: [DKAsset]!)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
        delay(0.1,
            closure: {
                UIApplication.sharedApplication().statusBarHidden = false;
                UIApplication.sharedApplication().statusBarStyle = .LightContent
        })
        
        
        var arrayofMessage=[UserChat]()
        
        var arrayofMessageGroup=[GroupChat]()
        
        var arrayImageIndex = [NSIndexPath]()
        for (index, asset) in assets.enumerate()
            
            
            
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
                
               // print_debug("saveThumbImagePath == ")
               // print_debug(saveThumbImagePath)
                
              //  print_debug("saveFullImagePath == ")
              //  print_debug(saveFullImagePath)
                
              //  print_debug("localmsgid == ")
              //  print_debug(strId)
                
                dict["sender"] = ChatHelper .userDefaultForAny("userId") as! NSString
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
                    
                    arrayofMessage += [chatObj]
                    chatArray.addObject(chatObj)
                    
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
                    arrayofMessageGroup += [chatObj]
                    chatObj.groupChatFile = fileObj
                }
                homeCoreData.saveContext()
                
                growingTextView.text=""
                dict["index"] = chatArray.count-1
                
                arrayImageIndex += [NSIndexPath(forRow:dict["index"] as! Int,inSection:0)]
                
                var path = [NSIndexPath]()
                path.append(NSIndexPath(forRow:dict["index"] as! Int,inSection:0))
                
                
                
                
                // New pic by PK
                
                
                
                // delay(10.0, {
                
                //below code is written  by me for cdn from 1 dec
                
                /*
                let newIndexPath:NSIndexPath = NSIndexPath(forRow:self.chatArray.count-1,inSection:0)
                let cell:UITableViewCell = chatTableView.cellForRowAtIndexPath(newIndexPath)!
                var progressV = cell.contentView.viewWithTag(22) as PICircularProgressView
                progressV.hidden = false
                
                let str : String = dict["localmsgid"] as String!
                ChatListner .getChatListnerObj().chatProgressV[str] = progressV
                */
                
                //   UploadInS3.sharedGlobal().uploadImageTos3( data, type: 0, fromDist: "chat", meldID: name, completion:
                
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
                            
                           // print(UploadInS3.sharedGlobal().chatImagesFiles as NSMutableArray)
                            //                            let fileName =  UploadInS3.sharedGlobal().strFilesName
                            //
                            //                            //  progressV.hidden = true
                            //                            if fileName != nil{
                            //                                self.sendImageFilePathToChatServer(dict, filePath: fileName, index: self.chatArray.count-1)
                            //                            }
                            
                            
                        }
                        else
                        {
                            if self.isGroup == "0"
                            {
                                for  chatObj  in arrayofMessage
                                {
                                    instance.multimediaChatStatusChangeSingleChat(chatObj)
                                }
                            }
                            else
                            {
                                for  chatObj  in arrayofMessageGroup
                                {
                                    instance.multimediaChatStatusChangeGroupChat(chatObj)
                                }
                                
                            }
                            
                            self.chatTableView.beginUpdates()
                            self.chatTableView.reloadRowsAtIndexPaths(arrayImageIndex, withRowAnimation: UITableViewRowAnimation.None)
                            self.chatTableView.endUpdates()
                            
                            // chatTableView.reloadRowsAtIndexPaths(<#indexPaths: [AnyObject]#>, withRowAnimation: <#UITableViewRowAnimation#>)
                            
                          //  print("Fails to upload  files ")
                        }
                        
                        } , completionProgress: { ( bool_val : Bool, progress) -> Void in
                            
                            
                            
                          //  print("pathSelected \(pathSelected)")
                            
                            
                            //let newIndexPath:NSIndexPath = NSIndexPath(forRow:dict["index"] as Int,inSection:0)
                            
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
                            }
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                    )
                    
                }
                
                chatTableView.insertRowsAtIndexPaths(path, withRowAnimation: UITableViewRowAnimation.Bottom)
                if chatArray.count > 2
                {
                    chatTableView.scrollToRowAtIndexPath(NSIndexPath(forRow:chatArray.count-1,inSection:0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                }
                // local server===== code hide by me for cdn 1 dec
                
                // self.sendImageToServer(dict, imageData: data, index: self.chatArray.count-1)
                //})
                
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func uniqueName(fileName: String) -> String {
        
        let uniqueImageName = NSString(format: "%@%f", fileName , NSDate().timeIntervalSince1970 * 1000)
       // print(uniqueImageName)
        return uniqueImageName as String
    }
    
    func hitServiceForUnBlockFriends(searchText: String) {
        
     /*   let msg2=""
      //  AppDelegate.getAppdelegate().showActivityViewer(String())
        var dict = Dictionary<String, AnyObject>()
        dict["status"] = "2"
        dict["method"] = "blockUser"
        dict["blockUserId"] = searchText
        dict["userId"] = ChatHelper .userDefaultForAny("userId") as! String
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gettingUnBlockFriendsRecords:",name:Notification_serviceForBlockOrUnBlock, object:nil)
        Service.sharedInstance().serviceForBlockOrUnBlock(dict as Dictionary)
 */
    }
    
    func gettingUnBlockFriendsRecords(note:NSNotification)
    {
        //print(note.userInfo)
     /*   AppDelegate.getAppDelegate().hideActivityViewer()
        NSNotificationCenter.defaultCenter().removeObserver(self, name:Notification_serviceForBlockOrUnBlock, object:nil)
        var tempdict = note.userInfo as Dictionary<String,AnyObject>
        if tempdict["error_code"]?.integerValue! == 1
        {
            let predicate2 = NSString(format: "friendId contains[cd] %@", self.recentChatObj.friendId )
           DataBaseController.sharedInstance.updateBlockUserEntry("RecentChatList", predicate: predicate2, blockStaus: "0", blockID: self.recentChatObj.friendId)
        }
        else
        {
            print("else")
        }
 */
        
    }
    
    func imagePickerControllerCancelled() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func reSendMultiMedia(sender: UIButton)
    {
        var dict = Dictionary<String, AnyObject>()
        if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {
            
            let pointInTable = sender.convertPoint(sender.bounds.origin, toView: chatTableView)
            let indexPath:NSIndexPath = chatTableView.indexPathForRowAtPoint(pointInTable)!
            let cell = sender.tableViewCell() as UITableViewCell!
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let documentsDirectory = paths.stringByAppendingPathComponent("/ChatFile")
            
            var messageType:String = ""
            var chatObj : UserChat!
            //var chatObj : UserChat!
            var grpChatObj : GroupChat!
            _ = cell.contentView.viewWithTag(22) as! PICircularProgressView
            var data:NSData?
            
            
            let resendBtn = cell.contentView.viewWithTag(58) as! UIButton
            resendBtn.hidden=true
            // ChatListner .getChatListnerObj().chatProgressV[chatObj.locMessageId] = progressV
            
            if isGroup == "0"
            {
                chatObj = chatArray[indexPath.row] as! UserChat
                
                let date = NSDate()
                var dateStr : String
                var timeStr : String
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                dateStr = dateFormatter.stringFromDate(date)
                dateFormatter.dateFormat = "HH:mm:ss.sss"
                timeStr = dateFormatter.stringFromDate(date)
                
                dict["date"] = dateStr
                dict["sortDate"] = dateStr
                dict["time"] = timeStr
                dict["message"] = chatObj.messageTime
                dict["type"] = chatObj.messageType
                dict["localThumbPath"] = chatObj.chatFile!.mediaLocalThumbPath
                dict["localFullPath"] = chatObj.chatFile!.mediaLocalPath
                dict["mediaUrl"] = chatObj.chatFile!.mediaUrl
                dict["mediaThumbUrl"] = chatObj.chatFile!.mediaThumbUrl
                dict["localmsgid"] = chatObj.locMessageId
                dict["mediaThumb"] = chatObj.chatFile!.mediaLocalPath
                dict["sender"] = ChatHelper .userDefaultForAny("userId") as! String
                if contObj != nil
                {
                    dict["receiver"] = contObj.userId
                }else
                {
                    dict["receiver"] = recentChatObj.friendId
                }
                
                messageType =  chatObj.messageType!
                
                
                let getImagePath = documentsDirectory.stringByAppendingPathComponent("\(chatObj.chatFile!.mediaLocalPath)")
                
                data = UIImageJPEGRepresentation(UIImage(contentsOfFile: getImagePath)!, 0.8)
                
            }
            else
            {
                
                grpChatObj = chatArray[indexPath.row] as! GroupChat
                
                messageType =  grpChatObj.messageType!
                
                
                
                let date = NSDate()
                var dateStr : String
                var timeStr : String
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                dateStr = dateFormatter.stringFromDate(date)
                dateFormatter.dateFormat = "HH:mm:ss.sss"
                timeStr = dateFormatter.stringFromDate(date)
                
                dict["date"] = dateStr
                dict["sortDate"] = dateStr
                dict["time"] = timeStr
                dict["message"] = grpChatObj.messageTime
                dict["type"] = grpChatObj.messageType
                dict["localThumbPath"] = grpChatObj.groupChatFile!.mediaLocalThumbPath
                dict["localFullPath"] = grpChatObj.groupChatFile!.mediaLocalPath
                dict["mediaUrl"] = grpChatObj.groupChatFile!.mediaUrl
                dict["mediaThumbUrl"] = grpChatObj.groupChatFile!.mediaThumbUrl
                dict["localmsgid"] = grpChatObj.locMessageId
                dict["mediaThumb"] = grpChatObj.groupChatFile!.mediaLocalPath
                
                dict["sender"] = ChatHelper .userDefaultForAny("userId") as! String
                if contObj != nil
                {
                    dict["receiver"] = contObj.userId
                }else
                {
                    dict["receiver"] = recentChatObj.friendId
                }
                
                let getImagePath = documentsDirectory.stringByAppendingPathComponent("\(grpChatObj.groupChatFile!.mediaLocalPath)")
                
                data = UIImageJPEGRepresentation(UIImage(contentsOfFile: getImagePath)!, 0.8)
            }
            dict["index"] = indexPath.row
            
        if messageType == "video"
            {
                
                let getImagePath = documentsDirectory.stringByAppendingPathComponent(dict["localThumbPath"] as! String)
                
                //print(getImagePath)
                _ = NSURL.fileURLWithPath(getImagePath)
                let getVideoPath = documentsDirectory.stringByAppendingPathComponent(dict["localFullPath"] as! String)
               // print(getVideoPath)
                
                dispatch_async(dispatch_get_main_queue(), {
                    //let saveVideoPath = NSURL.fileURLWithPath(getVideoPath)
                    //  print(saveVideoPath)
                    let videodata: NSData? = NSData.dataWithContentsOfMappedFile(getVideoPath) as? NSData
                    var imageSize   = videodata!.length as Int
                    imageSize = imageSize/1024
                    
                    
                  //  print_debug(imageSize)
                    
                    // bellow code is commented by pk on 2 dec 2015
                    
                    // self.sendVideoToServer(dict, videoData: data, index: self.chatArray.count-1)
                    
                    // bellow code is WRITTEN by pk on 2 dec 2015
                    NSOperationQueue.mainQueue().addOperationWithBlock() { () in
                        
                        let name = self.uniqueName("")
                        UploadInS3.sharedGlobal().uploadImageTos3( videodata, type: 1, fromDist: "chat", meldID: name, completion: { ( bool_val : Bool, pathUrl : String!) -> Void in
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
                                
                                let instance = DataBaseController.sharedInstance
                                
                                if self.isGroup == "0"
                                {
                                    let instance = DataBaseController.sharedInstance
                                    instance.multimediaChatStatusChangeSingleChat(chatObj)
                                }
                                else
                                {
                                    instance.multimediaChatStatusChangeGroupChat(grpChatObj)
                                    
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
                
                
                
            }
                
                
            else if messageType == "audio"
                
                
                
            {
                
                
                
                NSOperationQueue.mainQueue().addOperationWithBlock() { () in
                    
                    let getAudioPath = documentsDirectory.stringByAppendingPathComponent(dict["localFullPath"] as! String)
                    let audioData: NSData? = NSData.dataWithContentsOfMappedFile(getAudioPath) as? NSData
                    var imageSize   = audioData!.length as Int
                    imageSize = imageSize/1024
                    
                  //  print_debug(imageSize)
                    
                    let name = self.uniqueName("")
                    UploadInS3.sharedGlobal().uploadImageTos3( audioData, type: 2, fromDist: "chat", meldID: name, completion: { ( bool_val : Bool, pathUrl : String!) -> Void in
                        
                        if bool_val == true
                        {
                            
                            
                            let fileName =  UploadInS3.sharedGlobal().strFilesName
                            //progressV.hidden = true
                            if fileName != nil{
                                
                                self.sendAudioFilePathToChatServer(dict, filePath: fileName, index: self.chatArray.count-1)
                            }
                        }
                            
                        else
                        {
                            let instance = DataBaseController.sharedInstance
                            if self.isGroup == "0"
                            {
                                
                                
                                instance.multimediaChatStatusChangeSingleChat(chatObj)
                            }
                            else
                            {
                                instance.multimediaChatStatusChangeGroupChat(grpChatObj)
                                
                            }
                            self.chatTableView.beginUpdates()
                            self.chatTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow:self.chatArray.count-1,inSection:0)], withRowAnimation: UITableViewRowAnimation.None)
                            self.chatTableView.endUpdates()
                            
                        }
                        
                        }
                        , completionProgress: { ( bool_val : Bool, progress) -> Void in
                            
                            
                            
                            let newIndexPath:NSIndexPath = NSIndexPath(forRow:self.chatArray.count-1,inSection:0)
                            
                            let visibleCell : NSArray = self.chatTableView.indexPathsForVisibleRows!
                            
                            if(visibleCell.containsObject(newIndexPath))
                            {
                                if     let cell:ChatAudioSenderCell = self.chatTableView.cellForRowAtIndexPath(newIndexPath)! as? ChatAudioSenderCell
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
                
                
                
            }
                
            else
            {
                
                
                NSOperationQueue.mainQueue().addOperationWithBlock() { () in
                    
                    let name = self.uniqueName("")
                    
                    UploadInS3.sharedGlobal().uploadImageTos3( data, type: 0, fromDist: "chat", meldID: name, completion: { ( bool_val : Bool, pathUrl : String!) -> Void in
                        
                        
                        if bool_val == true
                            
                        {
                            //  var fileName : NSString
                            let fileName =  UploadInS3.sharedGlobal().strFilesName
                            
                            if fileName != nil{
                                self.sendImageFilePathToChatServer(dict, filePath: fileName, index:-1)
                            }
                            
                            
                        }
                        else
                        {
                            let instance = DataBaseController.sharedInstance
                            
                            if self.isGroup == "0"
                            {
                                let instance = DataBaseController.sharedInstance
                                instance.multimediaChatStatusChangeSingleChat(chatObj)
                            }
                            else
                            {
                                instance.multimediaChatStatusChangeGroupChat(grpChatObj)
                                
                            }
                            
                            self.chatTableView.beginUpdates()
                            self.chatTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow:dict["index"] as! Int,inSection:0)], withRowAnimation: UITableViewRowAnimation.None)
                            self.chatTableView.endUpdates()
                            
                            // chatTableView.reloadRowsAtIndexPaths(<#indexPaths: [AnyObject]#>, withRowAnimation: <#UITableViewRowAnimation#>)
                            
                         //   print("Fails to upload  files ")
                        }
                        
                        }
                        
                        , completionProgress: { ( bool_val : Bool, progress) -> Void in
                            
                            // print("pathSelected \(pathSelected)")
                            
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
            }
            
            
        }
        else
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
            //showInternetNotAvailable_Alert
            
        }
        
        
    }
    
}