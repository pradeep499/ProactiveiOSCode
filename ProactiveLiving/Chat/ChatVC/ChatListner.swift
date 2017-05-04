//
//  ChatListner.swift
//  MelderEventApp
//
//  Created by Sunil Kaushik on 9/14/15.
//  Copyright (c) 2015 Jyoti Sharma. All rights reserved.
//

import UIKit


class ChatListner: NSObject {
    
    var  socket : SocketIOClient!

    class var sharedInstance: ChatListner {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: ChatListner? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ChatListner()
        }
        return Static.instance!
    }
    
    
    let homeCoreData = AppDelegate.getAppDelegate()
    
    /// This class is used to conect Socket
    var reachability: Reachability?
    
    var pushDict : Dictionary<NSObject,AnyObject>!
    var socketIdStr : String!
    var chatProgressV : NSMutableDictionary!
    var playSoundBool  = true
    var pushNotificationView:UIView!
    var userInteractionDisableView:UIView!
    var isConnectionStable = false
    var currentOperationDict : NSMutableDictionary!
    var timerConnectingStatus:NSTimer!

    override init(){
        
        
         socket = SocketIOClient(socketURL: NSURL(string: socketIO_BaseURL)!, options: [.Log(true), .ForcePolling(true)])
        
    }

    deinit{
        self.closeConnection()
        socket = nil
    }
    
    /*!
    Make a connection to socket
    */
    func createOnline(){
        
        self.isConnectionStable = true

        unowned let weakself = self
        
        var loginDic = Dictionary<String,String>()
        loginDic["userid"]=ChatHelper.userDefaultForKey("userId")
        loginDic["lastHitDate"]=ChatHelper.userDefaultForKey("lastHitDate")
        loginDic["deviceType"]="iphone"
        weakself.socket.emit("createOnline", loginDic)
        
        NSNotificationCenter.defaultCenter().postNotificationName("ConnectingNotificationForChat", object: nil, userInfo: nil)
        
        let alrt = UIAlertView(title: "hello", message: "connected", delegate: self, cancelButtonTitle: "ok")
        alrt.show()
        
    }
  
    // status
func connectToSocket() -> Void{
    
    print_debug("coonrct to scoket ")
    
    if let value:String = ChatHelper.userDefaultForKey(_ID)  {
        //Registered user
        
        
        
        if isConnectionStable == false{
            
            
            chatProgressV = NSMutableDictionary()
            currentOperationDict = NSMutableDictionary()
            
            if ChatListner.getChatListnerObj().socket.status != .Connected {
                
                self.socket.reconnects = false
                print_debug("coonrct to scoket inside ")

                self.socket.connect()
                
                unowned let weakself = self
                weakself.socket.off("recieveMessage")
                weakself.socket.off("recieveMessageAll                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  ")
                weakself.socket.off("messageStatus")
                weakself.socket.off("isUserTyping")
                weakself.socket.off("getGroupInfo")
                weakself.socket.off("delUserInGroup")
                                
                socket.on("connect") { data, ack in
                    print(weakself.isConnectionStable)
                    print_debug("connect listner")
                    if self.isConnectionStable{
                        return
                    }
                    weakself.createOnline()
                    weakself.sendOffLineMessage()
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "getState", object: nil))
                }
                weakself.isTypingChatListener()
                weakself.addReceiveMsgHandlers()
                weakself.addOffLineReceiveMsgHandlers();
                weakself.msgStatusListener()
                weakself.isTypingStopListner("")
                weakself.getGroupInfoListner()
                weakself.deleteUserFromGroupListner()
                //weakself.doNotSleepListener()
                
                //to show connecting Status
                
                
            }
            
        }
        
    }

    }
    
    
    func doNotSleep() {
        unowned let weakself = self
        var dataDic = Dictionary<String,String>()
        dataDic["beat"]="1"
        weakself.socket.emit("ping",dataDic)
        print("ping")
    }
    
    /*
    func doNotSleepListener() {
        unowned let weakself = self
        weakself.socket.on("pong") {data, ack in
        print("pong")
        weakself.doNotSleep()
        }
    }*/
    
    /*!
    return sigelton object of class
    */
   class func getChatListnerObj() -> ChatListner {
     return ChatListner.sharedInstance as ChatListner
    }
    
    
    // MARK : check the network reachability status
    func checkForReachability(){
        
        // Remove the next two lines of code. You cannot instantiate the object
        // you want to receive notifications from inside of the notification
        // handler that is meant for the notifications it emits.
        
        
            reachability =  Reachability.reachabilityForInternetConnection()
        
            // print_debug("Unable to create Reachability")
        
        
        // add the observer for the reachability tests
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatListner.reachabilityChanged(_:)),name:ReachabilityChangedNotification, object:reachability)
        
             reachability?.startNotifier()
        
            // print_debug("Unable to start notifier")
        
        
    }
    
    // check the connection reachability
    func reachabilityChanged(note: NSNotification){
        
        if let reachability = note.object as? Reachability{
            
            if reachability.isReachable(){
                
                
               self.createConnection()

                
                if reachability.isReachableViaWiFi(){
                    // print_debug("Reachable via WiFi")
                } else{
                    // print_debug("Reachable via Cellular")
                }
                
            } else{
                
                self.closeConnection()

                // print_debug("Network not reachable")
            }
        }
    }

    // MARK: - Node.js Methods for one to one chat
    
    func addReceiveMsgHandlers() {
        
       ChatListner .getChatListnerObj().socket.on("recieveMessage") {[weak self] data, ack in
            self?.playSoundBool = true
        
            var receiveMsgDic = Dictionary<String,AnyObject>()
            receiveMsgDic = data[0] as! Dictionary
         print(receiveMsgDic);
                print_debug("addReceiveMsgHandlers")
            let lastHitDate = receiveMsgDic["lastHitDate"] as! String
            ChatHelper .saveToUserDefault(lastHitDate, key: "lastHitDate")
        
            var tempDateStr : String
            var tempDate : NSDate!
            var dateStr : String
            var timeStr : String
            
            tempDateStr = receiveMsgDic["createdDate"] as! String
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            tempDate = dateFormatter.dateFromString(tempDateStr) as NSDate!
            
            dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
            dateStr = dateFormatter.stringFromDate(tempDate)
            dateFormatter.dateFormat = "HH:mm:ss.sss"
            dateFormatter.timeZone = NSTimeZone()
            timeStr = dateFormatter.stringFromDate(tempDate)
            
            if receiveMsgDic["chatType"] as! String == "group" {
               // print("receiveMsgDic in group chat string recieveMessage")
               // print(receiveMsgDic)
                var Pushdict = Dictionary<String, AnyObject>()
                let strId = receiveMsgDic["_id"] as! String
                var dict = Dictionary<String, AnyObject>()
                dict["date"] = dateStr
                //dict["sortDate"] = dateStr // getAllMessages
                dict["time"] = timeStr
                dict["message"] = receiveMsgDic["messageChat"] as! String!
                dict["groupid"] = receiveMsgDic["groupid"] as! String!
                
                if receiveMsgDic["type"] as! String == "text" {
                    dict["type"] = "text"
                    Pushdict["alert"] = String(format: "%@: %@",receiveMsgDic["user_firstName"] as! String,receiveMsgDic["messageChat"] as! String )
                } else if receiveMsgDic["type"] as! String == "image" {
                    dict["type"] = "image"
                    Pushdict["alert"] = String(format: "%@: %@",receiveMsgDic["user_firstName"] as! String,"Send image" )
                } else if receiveMsgDic["type"] as! String == "video" {
                    dict["type"] = "video"
                    Pushdict["alert"] = String(format: "%@: %@",receiveMsgDic["user_firstName"] as! String,"Send video")
                } else {
                    dict["type"] = "audio"
                    Pushdict["alert"] = String(format: "%@: %@",receiveMsgDic["user_firstName"] as! String,"Send audio")
                }
                
                dict["sender"] = receiveMsgDic["senderid"] as! String!
                Pushdict["senderid"] = receiveMsgDic["senderid"] as! String!
                
                dict["receiver"] = ChatHelper .userDefaultForAny("userId") as! NSString
                dict["messageId"] = "\(strId)"
                dict["modifiedDate"] = receiveMsgDic["modifiedDate"] as! String
                let status = receiveMsgDic["status"] as! Int
                dict["status"] = "\(status)"
                let instance = DataBaseController.sharedInstance
                
//                let str:String = dict["sender"] as! String!
//                let strPred:String = "userId contains[cd] \"\(str)\""
//                let fetchResult=instance.fetchData("GroupUserList", predicate: strPred, sort: ("userName",true))! as NSArray
//                for myobject : AnyObject in fetchResult {
//                    let contObj = myobject as! GroupUserList
//                    dict["sendername"] = contObj.userName
//                }
                
                //by Mohammad Asim
                dict["sendername"] = receiveMsgDic["user_firstName"]
                
                if dict["sender"] as! String != ChatHelper .userDefaultForAny("userId") as! String {
                    self?.checkDateIsDifferentAppGrp(dict)
                }
                //insertGroupChatMessageInDb
                let chatObj =  instance.insertGroupChatMessageInDb("GroupChat", params: dict) as GroupChat
     
                if receiveMsgDic["type"] as! String != "text" && receiveMsgDic["type"] as! String != "audio" {
                    let locId = CommonMethodFunctions.nextIdentifies()
                    chatObj.locMessageId = "\(locId)"
                    let mediaStr = receiveMsgDic["mediaThumb"] as! String
                    let mediaThumbStr = receiveMsgDic["mediaUrl"] as! String
                    let trimmedString = mediaStr.stringByReplacingOccurrencesOfString("\n", withString: "")
                    var saveThumbImagePath = "Thumb"+mediaThumbStr
                    saveThumbImagePath = saveThumbImagePath.stringByReplacingOccurrencesOfString(".mp4", withString: ".jpg")
                    dict["localThumbPath"] = saveThumbImagePath
                    dict["localFullPath"] = ""
                    dict["mediaUrl"] = receiveMsgDic["mediaUrl"] as! String
                    dict["mediaThumbUrl"] = trimmedString
                    let fileObj =  instance.insertGroupChatFileInDb1("GroupChatFile", params: dict) as GroupChatFile
                    chatObj.groupChatFile = fileObj
                    
                    self!.homeCoreData.saveContext()
                    
                } else if receiveMsgDic["type"] as! String == "audio" {
                    let locId = CommonMethodFunctions.nextIdentifies()
                    chatObj.locMessageId = "\(locId)"
                    dict["localThumbPath"] = ""
                    dict["localFullPath"] = ""
                    dict["mediaUrl"] = receiveMsgDic["mediaUrl"] as! String
                    dict["mediaThumbUrl"] = ""
                    let fileObj =  instance.insertGroupChatFileInDb1("GroupChatFile", params: dict) as GroupChatFile
                    chatObj.groupChatFile = fileObj
                    
                    self!.homeCoreData.saveContext()
                }
                
                self?.updateMessageInRecentChatFromGroup(dict)
                
                if (NSUserDefaults.standardUserDefaults().stringForKey("friendId") != nil)  {
                    if dict["groupid"] as! String == ChatHelper .userDefaultForAny("friendId") as! String {
                        NSNotificationCenter.defaultCenter().postNotificationName("receiveMsgObserver", object: chatObj, userInfo: nil)
                    } else {
                        self?.hitDeliveredMsg(dict)
                        self?.showForgroundChatNotification(Pushdict)
                    }
                } else {
                    self?.hitDeliveredMsg(dict)
                    self?.showForgroundChatNotification(Pushdict)
                }
                
            } else {
               // print("receiveMsgDic in one to one chat string recieveMessage")
               // print(receiveMsgDic)
                
                let strId = receiveMsgDic["_id"] as! String
                var dict = Dictionary<String, AnyObject>()
                dict["date"] = dateStr
                dict["time"] = timeStr
                dict["message"] = receiveMsgDic["messageChat"] as! String!
                if receiveMsgDic["type"] as! String == "text" {
                    dict["type"] = "text"
                } else if receiveMsgDic["type"] as! String == "image" {
                    dict["type"] = "image"
                } else if receiveMsgDic["type"] as! String == "video" {
                    dict["type"] = "video"
                } else {
                    dict["type"] = "audio"
                }
                dict["sender"] = receiveMsgDic["senderid"] as! String
                dict["receiver"] = ChatHelper .userDefaultForAny("userId") as! NSString
                dict["messageId"] = "\(strId)"
                dict["modifiedDate"] = receiveMsgDic["modifiedDate"] as! String
                let status = receiveMsgDic["status"] as! Int
                dict["status"] = "\(status)"
                dict["phoneNumber"] = receiveMsgDic["phoneNumber"] as! String
                dict["profile_image"] = receiveMsgDic["profile_image"] as! String
                
                if (receiveMsgDic["user_firstName"] as? String) != nil {
                    dict["user_firstName"]  = receiveMsgDic["user_firstName"] as! String
                }
                
                if (receiveMsgDic["profile_image"] as? String) != nil {
                    dict["profile_image"]  = receiveMsgDic["profile_image"] as! String
                }
                   // print("receiveMsgDic in one to one chat string recieveMessage")
              //  print(receiveMsgDic)
                let instance = DataBaseController.sharedInstance
                if dict["sender"] as! String != ChatHelper .userDefaultForAny("userId") as! String {
                    self?.checkDateIsDifferentApp(dict)
                }
                
                let chatObj =  instance.insertChatMessageInDb("UserChat", params: dict) as UserChat
                print(chatObj)
                
                if receiveMsgDic["type"] as! String != "text" && receiveMsgDic["type"] as! String != "audio" {
                  //  print("receiveMsgDic in one to one chat string ")
                
                    let locId = CommonMethodFunctions.nextIdentifies()
                    let mediaStr = receiveMsgDic["mediaThumb"] as! String
                    let mediaThumbStr = receiveMsgDic["mediaUrl"] as! String
                    let trimmedString = mediaStr.stringByReplacingOccurrencesOfString("\n", withString: "")
                    var saveThumbImagePath = "Thumb"+mediaThumbStr
                    saveThumbImagePath = saveThumbImagePath.stringByReplacingOccurrencesOfString(".mp4", withString: ".jpg")
                    
                    dict["localThumbPath"] = saveThumbImagePath
                    dict["localFullPath"] = ""
                    dict["mediaUrl"] = receiveMsgDic["mediaUrl"] as! String
                    dict["mediaThumbUrl"] = trimmedString
                    let fileObj =  instance.insertChatFileInDb1("UserChatFile", params: dict) as UserChatFile
                    chatObj.chatFile = fileObj
                    
                    chatObj.locMessageId = String(locId)
                    
                    self!.homeCoreData.saveContext()
                } else if receiveMsgDic["type"] as! String == "audio" {
                    //print("receiveMsgDic in one to one chat string ")

                    dict["localThumbPath"] = ""
                    dict["localFullPath"] = ""
                    dict["mediaUrl"] = receiveMsgDic["mediaUrl"] as! String
                    dict["mediaThumbUrl"] = ""
                    let fileObj =  instance.insertChatFileInDb1("UserChatFile", params: dict) as UserChatFile
                    let locId = CommonMethodFunctions.nextIdentifies()
                    chatObj.chatFile = fileObj
                    chatObj.locMessageId = String(locId)
                    
                    self!.homeCoreData.saveContext()
                }
                
                if (NSUserDefaults.standardUserDefaults().stringForKey("friendId") != nil) {
                    if dict["sender"] as! String == ChatHelper .userDefaultForAny("friendId") as! String {
              
                        NSNotificationCenter.defaultCenter().postNotificationName("receiveMsgObserver", object: chatObj, userInfo: nil)
                    } else {
                        self?.hitDeliveredMsg(dict)
                    }
                } else {
                    self?.hitDeliveredMsg(dict)
                }
                self?.addUserInRecentChat(dict)
            }
        }
    }
    
    
    func checkDateIsDifferentApp(dic : NSDictionary) {
        let instance = DataBaseController.sharedInstance
        var dict = Dictionary<String, AnyObject>()
        dict["date"] = dic["date"]
        dict["time"] = dic["time"]
        dict["message"] = ""
        dict["type"] = "notification"
        dict["sender"] = dic["sender"]
        dict["receiver"] = dic["receiver"]
        dict["localmsgid"] = ""
        //print(dict)
        
        let str1:String = dic["sender"] as! String
        let strPred1:String = "friendId contains[cd] \"\(str1)\""
        let recentObj=instance.fetchDataRecentChatObject("RecentChatList", predicate: strPred1) as RecentChatList?
        //print(recentObj?.lastMessageTime)
        //print(recentObj?.friendName)
        if recentObj != nil && recentObj?.lastMessageTime != "" {
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
            dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss.sss"
            let str = recentObj?.lastMessageTime as String?
            let date1 = dateFormatter.dateFromString(str!)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateStr = dateFormatter.stringFromDate(date1!)
            
            let date = NSDate()
            dateFormatter.timeZone = NSTimeZone()
            
            let dateStr1 = dateFormatter.stringFromDate(date)
            
            dict["date"] = dateStr
            dict["sortDate"] = dateStr1
            
            if dateStr != dateStr1 {
                
                let strLogin:String = ChatHelper.userDefaultForAny("userId") as! String
                let strSender = dic["sender"]
                let strReceiver = dic["receiver"]
                
                let strPred:String = "loginUserId contains[cd] \"\(strLogin)\" AND (( senderId contains[cd] \"\(strSender)\" AND receiverId contains[cd] \"\(strReceiver)\") OR ( senderId contains[cd] \"\(strReceiver)\" AND receiverId contains[cd] \"\(strSender)\"))"
                
                let instance = DataBaseController.sharedInstance
                let fetchResult = instance.fetchChatData("UserChat", predicate: strPred, sort: ("localSortID",false))! as NSArray
                print(fetchResult)
                let userChatObj = fetchResult.lastObject as? UserChat
                var dateString : String = ""
                
                if fetchResult.count > 0 {
                    if userChatObj != nil {
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
                        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss.sss"
                        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                        let str = userChatObj!.messageDate as String?
                        let date1 = dateFormatter.dateFromString(str!)
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        
                        if date1 == nil {
                            dateString = userChatObj?.messageDate as String!
                        } else {
                            dateString = dateFormatter.stringFromDate(date1!)
                        }
                    }
                }
                
                if dateStr != dateString {
                    let chatObj = instance.insertChatMessageInDb1("UserChat", params: dict) as UserChat!
                    print(chatObj)
                    if (NSUserDefaults.standardUserDefaults().stringForKey("friendId") != nil)  {
                        if dict["sender"] as! String == ChatHelper .userDefaultForAny("friendId") as! String {
                            NSNotificationCenter.defaultCenter().postNotificationName("receiveMsgObserver", object: chatObj, userInfo: nil)
                        }
                    }
                }
            }
        } else {
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
            dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss.sss"
            let date1 = dateFormatter.dateFromString(dict["date"] as! String)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateStr = dateFormatter.stringFromDate(date1!)
            dict["date"] = dateStr
            dict["sortDate"] = dateStr
            
            let chatObj = instance.insertChatMessageInDb1("UserChat", params: dict) as UserChat
            print(chatObj)
            if (NSUserDefaults.standardUserDefaults().stringForKey("friendId") != nil) {
                if dict["sender"] as! String == ChatHelper .userDefaultForAny("friendId") as! String {
                    NSNotificationCenter.defaultCenter().postNotificationName("receiveMsgObserver", object: chatObj, userInfo: nil)
                }
            }
        }
    }
    
    func checkDateIsDifferentAppGrp(dic : NSDictionary){
        let instance = DataBaseController.sharedInstance
        var dict = Dictionary<String, AnyObject>()
        dict["date"] = dic["date"]
        dict["time"] = dic["time"]
        dict["message"] = ""
        dict["type"] = "notification"
        dict["sender"] = dic["sender"]
        dict["groupid"] = dic["groupid"]
        dict["sendername"] = ""
        dict["localmsgid"] = ""
        let str1:String = dic["groupid"] as! String
        let strPred1:String = "groupId LIKE \"\(str1)\""
        let recentObj=instance.fetchDataRecentChatObject("RecentChatList", predicate: strPred1) as RecentChatList?
        if recentObj != nil && recentObj?.lastMessageTime != "" {
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
            dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
            dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            let str = recentObj?.lastMessageTime as String?
            let date1 = dateFormatter.dateFromString(str!)
            dateFormatter.dateFormat = "YYYY-MM-dd"
            let dateStr = dateFormatter.stringFromDate(date1!)
            
            let date = NSDate()
            let dateStr1 = dateFormatter.stringFromDate(date)
            dict["date"] = dateStr1
            dict["sortDate"] = dateStr1
            if dateStr != dateStr1 || recentObj?.lastMessage ==  "New Group"  {
                let chatObj = instance.insertGroupChatMessageInDb1("GroupChat", params: dict) as GroupChat!
                if (NSUserDefaults.standardUserDefaults().stringForKey("friendId") != nil) {
                    if dict["groupid"] as! String == ChatHelper .userDefaultForAny("friendId") as! String {
                        NSNotificationCenter.defaultCenter().postNotificationName("receiveMsgObserver", object: chatObj, userInfo: nil)
                    }
                }
            }
        }
    }
    /*!
    call when message is delivered to socket
    :param: dic <#dic description#>
    */
    func hitDeliveredMsg(dic : NSDictionary) {
        if playSoundBool == true {
            let str:String = ChatHelper .userDefaultForKey("chatId") as String
            if str.characters.count == 0 {
                AudioServicesPlaySystemSound(1002);
            }
        }
        
        var dict = Dictionary<String, AnyObject>()
        dict["senderid"] = dic["sender"] as! String
        dict["userid"] = ChatHelper .userDefaultForAny("userId") as! String
        dict["id"] = dic["messageId"] as! String
        dict["msgStatus"] = "1" //change by Mohammad Asim

       ChatListner .getChatListnerObj().socket.emit("messageSeened", dict)
    }
    
    /*!
    call when message is delivered to the receiver from socket
    
    :param: dic <#dic description#>
    */
    func hitCompleteMsg(dic : NSDictionary) {
        var dict = Dictionary<String, AnyObject>()
        dict["userid"] = ChatHelper .userDefaultForAny("userId") as! String
        dict["id"] = dic["messageId"] as! String
       ChatListner .getChatListnerObj().socket.emit("messageComplete", dict)
    }
    
    func addUserInRecentChat(dic : NSDictionary) {
        print(dic);
        print("addUserInRecentChat");

        let str:String = dic["sender"] as! String
        let strPred:String = "userId contains[cd] \"\(str)\""
        let instance = DataBaseController.sharedInstance
        let appContObj=instance.fetchDataAppContObject("AppContactList", predicate: strPred) as AppContactList?
          pushDict = Dictionary<String, AnyObject>()
        
        if appContObj != nil {
            var dict = Dictionary<String, AnyObject>()
            if appContObj?.name == "Anonymous" {
                dict["name"] = dic["user_firstName"] as! String
            } else {
                dict["name"] = appContObj?.name
            }
            
            dict["friendId"] = appContObj?.userId
            dict["imageStr"] = appContObj?.userImgString
            
            dict["message"] = dic["message"]
            dict["messageTime"] = dic["date"]
            dict["isNameAvail"] = "1"
            let instance = DataBaseController.sharedInstance
            instance.insertRecentChatData1("RecentChatList", params: dict)
            
            var alertStr : String!
            alertStr = dict["name"] as! String + ": "
            let alertStr1 : String =  dict["message"] as! String
            pushDict["alert"] = alertStr + alertStr1
            pushDict["senderid"] = dic["sender"] as! String
            
        } else {
            var dict = Dictionary<String, AnyObject>()
            
            dict["friendId"] = dic["sender"] as! String
            dict["imageStr"] = dic["profile_image"]
            
          //  print(<#object: T#>)
            //pk 23 oct
            //below new code by prabodh on 
        
            if ((dic["user_firstName"] as? String) != nil) {
                dict["user_firstName"]  = dic["user_firstName"] as! String
                dict["name"] = dic["user_firstName"] as! String
            }
            
            if (dic["profile_image"] as? String) != nil {
                dict["profile_image"]  = dic["profile_image"] as! String
            }
//            dict["user_firstName"] = dic["user_firstName"] as String
//            dict["profile_image"] = dic["profile_image"] as String

            dict["message"] = dic["message"] as! String
            dict["messageTime"] = dic["date"] as! String
            dict["isNameAvail"] = "0"
            let instance = DataBaseController.sharedInstance
            instance.insertRecentChatData1("RecentChatList", params: dict)
            
            
            print(dict)
            var alertStr : String!
            alertStr = dict["name"] as! String + ": "
            let alertStr1 : String =  dict["message"] as! String
            pushDict["alert"] = alertStr + alertStr1
            pushDict["senderid"] = dic["sender"] as! String
        }
        self.showForgroundChatNotification(pushDict)
    }
    
    func addOffLineReceiveMsgHandlers() {
        
       ChatListner .getChatListnerObj().socket.on("recieveMessageAll") {[weak self] data, ack in
        
        self?.playSoundBool = false
        var receiveMsgDict = Dictionary<String,AnyObject>()
            receiveMsgDict = data[0] as! Dictionary
            print(receiveMsgDict)
           print_debug("addOffLineReceiveMsgHandlers")
            let lastHitDate = receiveMsgDict["lastHitDate"] as! String
            ChatHelper .saveToUserDefault(lastHitDate, key: "lastHitDate");
            
            let arr = receiveMsgDict["result"] as! NSArray
            var playSoundLocalBool = false
            for receiveMsgDic in arr {
                var tempDateStr : String
                var tempDate : NSDate!
                
                var dateStr : String
                var timeStr : String
                
                tempDateStr = receiveMsgDic["createdDate"] as! String
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                tempDate = dateFormatter.dateFromString(tempDateStr) as NSDate!

                dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
                dateStr = dateFormatter.stringFromDate(tempDate)
               
                dateFormatter.dateFormat = "HH:mm:ss.sss"
                dateFormatter.timeZone = NSTimeZone()
                timeStr = dateFormatter.stringFromDate(tempDate)
            
                if receiveMsgDic["chatType"] as! String == "group" {
                   // print(receiveMsgDic)
                   // print("receiveMsgDic in group chat string recieveMessage")
                    
                    let strId = receiveMsgDic["_id"] as! String
                    let groupId = receiveMsgDic["groupid"] as! String
                    var dict = Dictionary<String, AnyObject>()
                    dict["date"] = dateStr
                    dict["time"] = timeStr
                    dict["message"] = receiveMsgDic["messageChat"] as! String
                    dict["groupid"] = "\(groupId)"
                    
                    if receiveMsgDic["type"] as! String == "text" {
                        dict["type"] = "text"
                    } else if receiveMsgDic["type"] as! String == "image" {
                        dict["type"] = "image"
                    } else if receiveMsgDic["type"] as! String == "video" {
                        dict["type"] = "video"
                    } else {
                        dict["type"] = "audio"
                    }
                    
                    dict["sender"] = receiveMsgDic["senderid"] as! String
                    //dict["receiver"] = receiveMsgDic["recieverid"] as! String
                    dict["receiver"] = ""
                    dict["messageId"] = "\(strId)"
                    dict["modifiedDate"] = receiveMsgDic["modifiedDate"] as! String
                    let status = receiveMsgDic["status"] as! Int
                    dict["status"] = "\(status)"
                    let instance = DataBaseController.sharedInstance
                    let str:String = dict["sender"] as! String
                    let strPred:String = "userId contains[cd] \"\(str)\""
                    let fetchResult=instance.fetchData("GroupUserList", predicate: strPred, sort: ("userName",true))! as NSArray
                    
                    for myobject : AnyObject in fetchResult {
                        let contObj = myobject as! GroupUserList
                        dict["sendername"] = contObj.userName
                    }
                    
                    var exist:GroupChat?
                    var chatObj : GroupChat!
                    var passDic = Dictionary<String,AnyObject>()
                    
                    if dict["sender"] as! String != ChatHelper .userDefaultForAny("userId") as! String {
                        self?.checkDateIsDifferentAppGrp(dict)
                        exist = instance.checkIfGroupChatMsgAlreadyExist("GroupChat", params: dict)
                        if exist != nil {
                            passDic["bfr"] = exist as GroupChat!
                        }
                        chatObj =  instance.insertGroupChatMessageInDb("GroupChat", params: dict) as GroupChat
                        passDic["updated"] = chatObj
                    } else {
                        dict["locMessageId"] = receiveMsgDic["localmsgid"] as! String
                        exist = instance.checkIfSenderGroupChatMsgAlreadyExist("GroupChat", params: dict)
                        if exist != nil {
                            passDic["bfr"] = exist as GroupChat!
                            chatObj =  instance.updateSenderGroupChatMessageInDb("GroupChat", params: dict) as GroupChat
                        }
                        passDic["updated"] = chatObj
                    }
                    
                    if receiveMsgDic["type"] as! String != "text" && receiveMsgDic["type"] as! String != "audio" {
                        if dict["sender"] as! String != ChatHelper .userDefaultForAny("userId") as! String {
                            let mediaStr = receiveMsgDic["mediaThumb"] as! String
                            let trimmedString = mediaStr.stringByReplacingOccurrencesOfString("\n", withString: "")
                            let mediaThumbStr = receiveMsgDic["mediaUrl"] as! String
                            var saveThumbImagePath = "Thumb"+mediaThumbStr
                            saveThumbImagePath = saveThumbImagePath.stringByReplacingOccurrencesOfString(".mp4", withString: ".jpg")
                            dict["localThumbPath"] = trimmedString
                            dict["localFullPath"] = ""
                            dict["mediaUrl"] = receiveMsgDic["mediaUrl"] as! String
                            dict["mediaThumbUrl"] = trimmedString
                            let fileObj =  instance.insertGroupChatFileInDb1("GroupChatFile", params: dict) as GroupChatFile
                            chatObj.groupChatFile = fileObj
                            let locId = CommonMethodFunctions.nextIdentifies()
                            chatObj.locMessageId = "\(locId)"
                            
                            self!.homeCoreData.saveContext()
                        }
                    } else if receiveMsgDic["type"] as! String == "audio" {
                        if dict["sender"] as! String != ChatHelper .userDefaultForAny("userId") as! String {
                            dict["localThumbPath"] = ""
                            dict["localFullPath"] = ""
                            dict["mediaUrl"] = receiveMsgDic["mediaUrl"] as! String
                            dict["mediaThumbUrl"] = ""
                            let fileObj =  instance.insertGroupChatFileInDb1("GroupChatFile", params: dict) as GroupChatFile
                            chatObj.groupChatFile = fileObj
                            let locId = CommonMethodFunctions.nextIdentifies()
                            chatObj.locMessageId = "\(locId)"
                            
                            self!.homeCoreData.saveContext()
                        }
                    }
                    
                    if exist != nil {
                        if (NSUserDefaults.standardUserDefaults().stringForKey("friendId") != nil)  {
                            if dict["sender"] as! String == ChatHelper .userDefaultForAny("userId") as! String && dict["groupid"] as! String == ChatHelper .userDefaultForAny("friendId") as! String {
                                passDic["group"] = "1"
                                NSNotificationCenter.defaultCenter().postNotificationName("receiveMsgObserverUpdate", object: chatObj, userInfo: passDic)
                            }
                        }
                    } else {
                        if (NSUserDefaults.standardUserDefaults().stringForKey("friendId") != nil)  {
                            if dict["groupid"] as! String == ChatHelper .userDefaultForAny("friendId") as! String {
                                NSNotificationCenter.defaultCenter().postNotificationName("receiveMsgObserver", object: chatObj, userInfo: nil)
                            }
                        }
                    }
                    
                    if dict["sender"] as! String != ChatHelper .userDefaultForAny("userId") as! String {
                        self?.updateMessageInRecentChatFromGroup(dict)
                    }
                    
                    if dict["sender"] as! String != ChatHelper .userDefaultForAny("userId") as! String {
                        self?.hitDeliveredMsg(dict)
                        playSoundLocalBool = true
                    } else if dict["sender"] as! String == ChatHelper .userDefaultForAny("userId") as! String && dict["status"] as! String == "2" {
                        self?.hitCompleteMsg(dict)
                    }
                } else {
                   //   print("receiveMsgDic in one to one chat string recieveMessage")
                   //   print(receiveMsgDic)
                    
                    let strId       = receiveMsgDic["_id"] as! String
                    var dict        = Dictionary<String, AnyObject>()
                    dict["date"]    = dateStr
                    dict["time"]    = timeStr
                    dict["message"] = receiveMsgDic["messageChat"] as! String
                    
                    if receiveMsgDic["type"] as! String == "text" {
                          dict["type"]    = "text"
                    } else if receiveMsgDic["type"] as! String == "image" {
                         dict["type"]    = "image"
                    } else if receiveMsgDic["type"] as! String == "video" {
                         dict["type"]    = "video"
                    } else {
                         dict["type"]    = "audio"
                    }
                    
                    dict["sender"] = receiveMsgDic["senderid"] as! String
                    dict["receiver"] = receiveMsgDic["recieverid"] as! String
                    dict["messageId"] = "\(strId)"
                    dict["modifiedDate"] = receiveMsgDic["modifiedDate"] as! String
                    dict["phoneNumber"] = receiveMsgDic["phoneNumber"] as! String
                    
                  //  print(receiveMsgDic)
                    
                    if ((receiveMsgDic["user_firstName"] as? String) != nil) {
                        dict["user_firstName"]  = receiveMsgDic["user_firstName"] as! String
                    }
                    
                    if ((receiveMsgDic["profile_image"] as? String) != nil) {
                        dict["profile_image"]  = receiveMsgDic["profile_image"] as! String
                    }
                    
                  //  dict["user_firstName"] = receiveMsgDic["user_firstName"] as String
                  //  dict["profile_image"] = receiveMsgDic["profile_image"] as String
                    
                 // print("receiveMsgDic in one to one 2 chat string recieveMessage")
                    
                    let status =  receiveMsgDic["status"] as! Int
                    dict["status"] = "\(status)"
                    let instance = DataBaseController.sharedInstance
                    var exist:UserChat?
                    var chatObj : UserChat!
                    var passDic = Dictionary<String,AnyObject>()
                    
                    if dict["sender"] as! String != ChatHelper .userDefaultForAny("userId") as! String {
                        self?.checkDateIsDifferentApp(dict)
                        exist = instance.checkIfChatMsgAlreadyExist("UserChat", params: dict)
                        print(exist)
                        if exist != nil {
                            passDic["bfr"] = exist as UserChat!
                        }
                        
                        chatObj =  instance.insertChatMessageInDb("UserChat", params: dict) as UserChat
                        passDic["updated"] = chatObj
                    } else {
                        dict["locMessageId"] = receiveMsgDic["localmsgid"] as! String
                        exist = instance.checkIfSenderChatMsgAlreadyExist("UserChat", params: dict)
                        print(exist)
                        if exist != nil {
                            passDic["bfr"] = exist as UserChat!
                            chatObj =  instance.updateSenderChatMessageInDb("UserChat", params: dict) as UserChat
                        }
                        
                        
                        passDic["updated"] = chatObj
                    }
                
                    if receiveMsgDic["type"] as! String != "text" && receiveMsgDic["type"] as! String != "audio" {
                        if dict["sender"] as! String != ChatHelper .userDefaultForAny("userId") as! String {
                            
                            let mediaStr = receiveMsgDic["mediaThumb"] as! String
                            let trimmedString = mediaStr.stringByReplacingOccurrencesOfString("\n", withString: "")
                            let mediaThumbStr = receiveMsgDic["mediaUrl"] as! String
                            var saveThumbImagePath = "Thumb"+mediaThumbStr
                            saveThumbImagePath = saveThumbImagePath.stringByReplacingOccurrencesOfString(".mp4", withString: ".jpg")
                            dict["localThumbPath"] = trimmedString
                            dict["localFullPath"] = ""
                            dict["mediaUrl"] = receiveMsgDic["mediaUrl"] as! String
                            dict["mediaThumbUrl"] = trimmedString
                            let fileObj =  instance.insertChatFileInDb1("UserChatFile", params: dict) as UserChatFile
                            chatObj.chatFile = fileObj
                            let locId = CommonMethodFunctions.nextIdentifies()
                            chatObj.locMessageId = "\(locId)"
                            
                            self!.homeCoreData.saveContext()
                        }
                        
                    } else if receiveMsgDic["type"] as! String == "audio" {
                        if dict["sender"] as! String != ChatHelper .userDefaultForAny("userId") as! String {
                            dict["localThumbPath"] = ""
                            dict["localFullPath"] = ""
                            dict["mediaUrl"] = receiveMsgDic["mediaUrl"] as! String
                            dict["mediaThumbUrl"] = ""
                            let fileObj =  instance.insertChatFileInDb1("UserChatFile", params: dict) as UserChatFile
                            chatObj.chatFile = fileObj
                            let locId = CommonMethodFunctions.nextIdentifies()
                            chatObj.locMessageId = "\(locId)"
                            
                            self!.homeCoreData.saveContext()
                        }
                    }
                    
                    if exist != nil {
                        if (NSUserDefaults.standardUserDefaults().stringForKey("friendId") != nil) {
                            if dict["sender"] as! String == ChatHelper .userDefaultForAny("userId") as! String && dict["receiver"] as! String == ChatHelper .userDefaultForAny("friendId") as! String {
                                passDic["group"] = "0"
                                NSNotificationCenter.defaultCenter().postNotificationName("receiveMsgObserverUpdate", object: chatObj, userInfo: passDic)
                            }
                        }
                        
                    } else {
                        if (NSUserDefaults.standardUserDefaults().stringForKey("friendId") != nil) {
                            if dict["sender"] as! String == ChatHelper .userDefaultForAny("friendId") as! String {
                                NSNotificationCenter.defaultCenter().postNotificationName("receiveMsgObserver", object: chatObj, userInfo: nil)
                            }
                        }
                    }
                    
                    if dict["sender"] as! String != ChatHelper.userDefaultForAny("userId") as! String {
                        self?.addUserInRecentChat(dict)
                    }
                    
                    if dict["receiver"] as! String == ChatHelper .userDefaultForAny("userId") as! String {
                        self?.hitDeliveredMsg(dict)
                    } else if dict["sender"] as! String == ChatHelper .userDefaultForAny("userId") as! String && dict["status"] as! String == "2" {
                        self?.hitCompleteMsg(dict)
                    }
                }
            }
        
            if playSoundLocalBool == true {
                let str:String = ChatHelper .userDefaultForKey("chatId") as String
                if str.characters.count == 0 {
                    AudioServicesPlaySystemSound(1002);
                    
                    
                    // Update Msg Badge
                    if DataBaseController.sharedInstance.fetchUnreadCount() > 0{
                        AppDelegate.getAppDelegate().tabbarController.tabBar.items![1].badgeValue = String(DataBaseController.sharedInstance.fetchUnreadCount())
                    }else{
                        AppDelegate.getAppDelegate().tabbarController.tabBar.items![1].badgeValue = nil
                    }
                }
            }
        }
    }
    
    
    func msgStatusListener() {
       ChatListner .getChatListnerObj().socket.on("messageStatus") {data, ack in
            let instance = DataBaseController.sharedInstance
            var receiveMsgDic = Dictionary<String,AnyObject>()
            receiveMsgDic = data[0] as! Dictionary
            print(receiveMsgDic);
            let lastHitDate = receiveMsgDic["lastHitDate"] as! String
            ChatHelper .saveToUserDefault(lastHitDate, key: "lastHitDate");
            
            var params = Dictionary<String, AnyObject>()
            
            params["localmsgid"] = receiveMsgDic["localmsgid"] as? String
            
            if receiveMsgDic["chatType"] as! String == "group" {
                let exist:GroupChat? = instance.checkIfGroupChatMsgAlreadyExistWithLocId("GroupChat", params: params)
                var passDic = Dictionary<String,AnyObject>()
                passDic["bfr"] = exist as GroupChat!
                passDic["group"] = "1"
                
                if (exist != nil) {
                    var tempDateStr : String
                    var tempDate : NSDate!
                    var dateStr : String
                    var timeStr : String
                    tempDateStr = receiveMsgDic["createdDate"] as! String
                    
//                    let dateFormatter = NSDateFormatter()
//                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
//                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                    
//                    dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
//                    tempDate = dateFormatter.dateFromString(tempDateStr) as NSDate!
          
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                    tempDate = dateFormatter.dateFromString(tempDateStr) as NSDate!
                    
                    dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
                    dateStr = dateFormatter.stringFromDate(tempDate)
                    
                    dateFormatter.dateFormat = "HH:mm:ss.sss"
                    dateFormatter.timeZone = NSTimeZone()

                    timeStr = dateFormatter.stringFromDate(tempDate)
                    
                    let strId = receiveMsgDic["_id"] as! String
                    let strStatus = receiveMsgDic["status"] as! Int
                    let groupid = receiveMsgDic["groupid"] as! String
                    
                    exist?.messageId = "\(strId)"
                    exist?.messageStatus =  "\(strStatus)"
                    exist?.modifiedDate = receiveMsgDic["modifiedDate"] as? String
                    exist?.messageDate = dateStr
                    exist?.messageTime = timeStr
                    exist?.groupId = "\(groupid)"
                    
                    self.homeCoreData.saveContext()
                    NSNotificationCenter.defaultCenter().postNotificationName("receiveMsgObserverUpdate", object: nil, userInfo: passDic)
                }
                
            } else {
                let exist:UserChat? = instance.checkIfChatMsgAlreadyExistWithLocId("UserChat", params: params)
                var passDic = Dictionary<String,AnyObject>()
                passDic["bfr"] = exist as UserChat!
                passDic["group"] = "0"
                
                if (exist != nil) {
                    var tempDateStr : String
                    var tempDate : NSDate!
                    var dateStr : String
                   
                    tempDateStr = receiveMsgDic["createdDate"] as! String
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                    tempDate = dateFormatter.dateFromString(tempDateStr) as NSDate!
                    

                    dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
                    dateStr = dateFormatter.stringFromDate(tempDate)
                    dateFormatter.dateFormat = "HH:mm:ss.sss"
                    dateFormatter.timeZone = NSTimeZone()
                    
                    dateFormatter.stringFromDate(tempDate)
                    
                    let strId = receiveMsgDic["_id"] as! String
                    let strStatus = receiveMsgDic["status"] as! Int
                    exist?.messageId = "\(strId)"
                    exist?.messageStatus =  "\(strStatus)"
                    exist?.modifiedDate = receiveMsgDic["modifiedDate"] as? String
                    exist?.messageDate = dateStr
                    
                    
                    self.homeCoreData.saveContext()
                    NSNotificationCenter.defaultCenter().postNotificationName("receiveMsgObserverUpdate", object: nil, userInfo: passDic)
                    
                }
            }
        }
    }
    
    /*!
    called when any other user stop typing
    
    :param: senderid Id of sender user who is typing
    */
    func isTypingStopListner(senderid : String) -> Void {
        let str:String = ChatHelper .userDefaultForAny("userId") as! String
        let strPred:String = "loginUserId contains[cd] \"\(str)\""
        let instance = DataBaseController.sharedInstance
        let fetchResult=instance.fetchData("RecentChatList", predicate: strPred, sort: ("friendName",true))!
        
        if fetchResult.count > 0 {
            for myobject : AnyObject in fetchResult {
                let anObject = myobject as! RecentChatList
                anObject.isTyping = "0"
                self.homeCoreData.saveContext()
            }
        }
    }
    /*!
    call when any other user is typing
    
    :param: senderid Id of sender user who is typing
    */
    func isTypingChatListener() -> Void {
       ChatListner .getChatListnerObj().socket.on("isUserTyping") {data, ack in
            var receiveMsgDic = Dictionary<String,AnyObject>()
            receiveMsgDic = data[0] as! Dictionary
        print(receiveMsgDic);
            let lastHitDate = receiveMsgDic["lastHitDate"] as! String
            ChatHelper .saveToUserDefault(lastHitDate, key: "lastHitDate");
           // var status = receiveMsgDic["istyping"] as String
        
            let value: AnyObject! = receiveMsgDic["istyping"]
            let status = "\(value)"
        
            if receiveMsgDic["chatType"] as! String == "group" {
                let str:String = ChatHelper .userDefaultForAny("userId") as! String
                let str2:String = receiveMsgDic["groupid"] as! String
                let str1:String = receiveMsgDic["senderid"] as! String
                
                let strPred:String = "loginUserId contains[cd] \"\(str)\" AND  groupId LIKE \"\(str2)\" AND  userId contains[cd] \"\(str1)\""
                let strPred1:String = "loginUserId contains[cd] \"\(str)\" AND  groupId LIKE \"\(str2)\""
                
                let instance = DataBaseController.sharedInstance
                let fetchResult=instance.fetchData("GroupUserList", predicate: strPred, sort: ("groupId",false))! as NSArray
                for myobject : AnyObject in fetchResult {
                    let groupObj = myobject as! GroupUserList
                    let recentObj=instance.fetchDataRecentChatObject("RecentChatList", predicate: strPred1) as RecentChatList?
                    
                    if recentObj != nil {
                        
                        if status == "1" {
                            recentObj?.isTyping = groupObj.userName! + " typing"
                        } else {
                            recentObj?.isTyping = "0"
                        }
                        self.homeCoreData.saveContext()
                    }
                }
                
                if (NSUserDefaults.standardUserDefaults().stringForKey("friendId") != nil)  {
                    if receiveMsgDic["groupid"] as! String == ChatHelper .userDefaultForAny("friendId") as! String {
                        var params = Dictionary<String, AnyObject>()
                        params["senderid"] = receiveMsgDic["senderid"] as? String
                        params["isTyping"] = receiveMsgDic["istyping"] as? String
                        params["chatType"] = receiveMsgDic["chatType"] as? String
                        NSNotificationCenter.defaultCenter().postNotificationName("TypeMsgObserver", object: nil, userInfo: params)
                    }
                }
            } else {
                let str:String = ChatHelper .userDefaultForAny("userId") as! String
                let str2:String = receiveMsgDic["senderid"] as! String
                let strPred:String = "loginUserId contains[cd] \"\(str)\" AND  friendId contains[cd] \"\(str2)\""
                
                let instance = DataBaseController.sharedInstance
                let fetchResult=instance.fetchData("RecentChatList", predicate: strPred, sort: ("friendName",true))!
                
                if fetchResult.count > 0 {
                    for myobject : AnyObject in fetchResult {
                        let anObject = myobject as! RecentChatList
                        if status == "1" {
                            anObject.isTyping = "Typing..."
                        } else {
                            anObject.isTyping = "0"
                        }
                        
                        self.homeCoreData.saveContext()
                    }
                }
                
                if (NSUserDefaults.standardUserDefaults().stringForKey("friendId") != nil) {
                    if receiveMsgDic["senderid"] as! String == ChatHelper .userDefaultForAny("friendId") as! String {
                        var params = Dictionary<String, AnyObject>()
                        params["senderid"] = receiveMsgDic["senderid"] as? String
                        params["isTyping"] = receiveMsgDic["istyping"] as? String
                        params["chatType"] = receiveMsgDic["chatType"] as? String
                        NSNotificationCenter.defaultCenter().postNotificationName("TypeMsgObserver", object: nil, userInfo: params)
                    }
                }
            }
        }
    }
    
    func sendOffLineMessage() {
        
        let strLogin:String = ChatHelper .userDefaultForAny("userId") as! String
        let strSender:String = ChatHelper .userDefaultForAny("userId") as! String
        let strStatus:String = "3"
        let strPred:String = "loginUserId contains[cd] \"\(strLogin)\" AND senderId contains[cd] \"\(strSender)\"  AND messageStatus contains[cd] \"\(strStatus)\""
        
        let instance = DataBaseController.sharedInstance
        let fetchResult = instance.fetchData("UserChat", predicate: strPred, sort: ("localSortID",true))! as NSArray
        //print(fetchResult)
        
        for myobject : AnyObject in fetchResult {
            let anObject = myobject as! UserChat
            
            if anObject.messageType == "text" {
                var sendMsgD = Dictionary<String,String>()
                sendMsgD["recieverid"]=anObject.receiverId
                sendMsgD["userid"]=ChatHelper.userDefaultForKey("userId")
                sendMsgD["message"]=anObject.message
                sendMsgD["localmsgid"] = anObject.locMessageId
                sendMsgD["chatType"] = "oneToOne"
                sendMsgD["type"] = "text"
                sendMsgD["user_firstName"] = AppHelper.userDefaultsForKey("user_firstName") as? String
                sendMsgD["profile_image"] = AppHelper.userDefaultsForKey("user_imageUrl") as? String
                
               ChatListner .getChatListnerObj().socket.emit("sendMessage", sendMsgD)
            }
        }
        
        self.sendOffLineGroupMsg()
    }
    
    func sendOffLineGroupMsg()
    {
        let strLogin:String = ChatHelper .userDefaultForAny("userId") as! NSString as String
        let strSender:String = ChatHelper .userDefaultForAny("userId") as! NSString as String
        let strStatus:String = "3"
        let strPred:String = "loginUserId contains[cd] \"\(strLogin)\" AND senderId contains[cd] \"\(strSender)\"  AND messageStatus contains[cd] \"\(strStatus)\""
        let instance = DataBaseController.sharedInstance
        var fetchResult = instance.fetchData("GroupChat", predicate: strPred, sort: ("localSortID",true))! as NSArray
        for myobject : AnyObject in fetchResult
        {
            var anObject = myobject as! GroupChat
            if anObject.messageType == "text"
            {
                var sendMsgD = Dictionary<String,String>()
                // sendMsgD["recieverid"]=anObject.receiverId
                sendMsgD["userid"]=ChatHelper.userDefaultForKey("userId")
                sendMsgD["message"]=anObject.message
                sendMsgD["localmsgid"] = anObject.locMessageId
                sendMsgD["groupid"] = anObject.groupId
                sendMsgD["chatType"] = "groupChat"
                sendMsgD["type"] = "text"
                
                // print("send group msg\(sendMsgD)")
                
                ChatListner .getChatListnerObj().socket.emit("sendMessage", sendMsgD)
            }
            
        }
        
    }
    
    func showForgroundChatNotification(dict: NSDictionary) {
      //  print(" showForgroundChatNotification: ")
        
        let chatMsg = dict["alert"] as! String
        let senderid  = dict["senderid"] as! String
       
        if (NSUserDefaults.standardUserDefaults().stringForKey("friendId") != nil) {
            if senderid != ChatHelper .userDefaultForAny("friendId") as! String {
                self.showSucessswithString("\(chatMsg)", alertType:"notification",  width: screenWidth)
            }
        } else {
            self.showSucessswithString("\(chatMsg)", alertType:"notification",  width: screenWidth)
        }
    }
    
    func showSucessswithString(alertStr:String, alertType:String, width:CGFloat) {
       // print(" showSucessswithString: ")
        
        if (pushNotificationView != nil) {
            pushNotificationView.removeFromSuperview()
        }
        
        pushNotificationView=UIView(frame: CGRectMake(0, -70, UIScreen.mainScreen().bounds.size.width, 70))
        pushNotificationView.backgroundColor=UIColor(red: 255.0/255.0, green: 93.0/255.0, blue: 93.0/255.0, alpha: 1.0)
        
        pushNotificationView.userInteractionEnabled = true
        let tapGestureOnView = UITapGestureRecognizer(target:self, action:#selector(ChatListner.performActionForNotification))
        pushNotificationView.addGestureRecognizer(tapGestureOnView)
        
        let label=UILabel(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width-width)/2, 15, width, 50))
        label.textColor=UIColor.whiteColor()
        label.font=UIFont(name: "HelveticaNeue-Medium", size: 13.0)
        
        label.backgroundColor=UIColor.clearColor()
        label.numberOfLines=5
        label.lineBreakMode=NSLineBreakMode.ByWordWrapping
        label.textAlignment=NSTextAlignment.Center
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment=NSTextAlignment.Center
        
        let attrString = NSMutableAttributedString(string:alertStr)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        label.attributedText = attrString
        
        pushNotificationView.addSubview(label)
        
        
       
        
        if alertType == "notification" {
            
            AppDelegate.getAppDelegate().window?.addSubview(pushNotificationView)
            AppDelegate.getAppDelegate().window?.bringSubviewToFront(pushNotificationView)
            
            NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector:  #selector(ChatListner.hideAlert), userInfo: nil, repeats: false)
            
            //BAdru
            
            //  print("Unread Msg = ", String(DataBaseController.sharedInstance.fetchUnreadCount()))
            
            // Update Msg Badge
            if DataBaseController.sharedInstance.fetchUnreadCount() > 0{
                AppDelegate.getAppDelegate().tabbarController.tabBar.items![1].badgeValue = String(DataBaseController.sharedInstance.fetchUnreadCount())
            }else{
                AppDelegate.getAppDelegate().tabbarController.tabBar.items![1].badgeValue = nil
            }
        }
        else{
            // Connectiong to Socket IO
            
            //Add a View On Screen to disable user Interaction
            if (userInteractionDisableView != nil) {
                userInteractionDisableView.removeFromSuperview()
            }
            
            userInteractionDisableView = UIView(frame: CGRectMake(0,0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
            
            userInteractionDisableView.addSubview(pushNotificationView)
            
            AppDelegate.getAppDelegate().window?.addSubview(userInteractionDisableView)
            AppDelegate.getAppDelegate().window?.bringSubviewToFront(userInteractionDisableView)
            
            
            userInteractionDisableView.backgroundColor = UIColor.clearColor()
            
            timerConnectingStatus = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:  #selector(ChatListner.hideAlertConnectingToServer), userInfo: nil, repeats: true)
            
        }
        
        UIView.animateWithDuration(0.5, animations:
            {
                self.pushNotificationView.frame=CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 70)
        })
       
 
    }
    
    
    
    func updateMessageInRecentChatFromGroup(dic : NSDictionary) {
        let instance = DataBaseController.sharedInstance
        
        var dict = Dictionary<String, AnyObject>()
        dict["message"] = dic["message"]
        dict["messageTime"] = dic["date"]
        dict["groupid"] = dic["groupid"]
        instance.insertRecentChatFromGroup("RecentChatList", params: dict)
    }
    
    
    func notificationDictReceived1(dict:NSDictionary) {
      //  print_debug("\n\n\nNotification Dict : \(dict)\n\n\n")
        
        let value  = dict["push_type"] as! NSInteger
        if (value == 10) {
            let senderid  = dict["senderid"] as! String
            ChatHelper .saveToUserDefault(senderid, key: "chatId")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let chatHomeObj: ChatHomeVC = storyBoard.instantiateViewControllerWithIdentifier("ChatHomeVC") as! ChatHomeVC
            print(chatHomeObj)
            
           let tabBarObj = AppDelegate.getAppDelegate().window?.rootViewController as! UITabBarController
            
            tabBarObj.selectedIndex = 2
            delay(0.1, closure: {
                
                let navobj : UINavigationController = tabBarObj.selectedViewController as! UINavigationController
               // print_debug(navobj.viewControllers)
                if(navobj.viewControllers.count>1) {
                    navobj.popToRootViewControllerAnimated(false)
                }
                NSNotificationCenter.defaultCenter().postNotificationName("PushNotificationForChat", object: nil, userInfo: nil)
            })
        }
    }
    
    // MARK: - Node.js Methods for Group chat
    
    func getGroupInfoListner() {

        ChatListner .getChatListnerObj().socket.on("getGroupInfo") {[weak self] data, ack in
          
            var receiveMsgDict = Dictionary<String,AnyObject>()
            receiveMsgDict = data[0] as! Dictionary
            print(receiveMsgDict)
            
            let lastHitDate = receiveMsgDict["lastHitDate"] as! String
            ChatHelper .saveToUserDefault(lastHitDate, key: "lastHitDate");

            let arr = receiveMsgDict["allGroup"] as! NSArray
            
            for receiveMsgDic in arr {
                var tempDateStr : String
                var tempDate : NSDate!
                
                var dateStr : String
                
                //tempDateStr = receiveMsgDic["createdDate"] as! String
                tempDateStr = (receiveMsgDic["createdDate"] as? String)!   // changed on 5/04/17
 
                let dateFormatter = NSDateFormatter()
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                tempDate = dateFormatter.dateFromString(tempDateStr) as NSDate!
                dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
                dateStr = dateFormatter.stringFromDate(tempDate)
              //  let strUrl = ""//receiveMsgDic["imgUrl"] as String!
              //  print(receiveMsgDic)
                
               let strUrl = receiveMsgDic["imgUrl"] as! String //this code is added by mee 30 nov write below code
               // print(strUrl)
                
                var localStr : String! = ""
               
                if (strUrl.lowercaseString.rangeOfString("http") != nil) {
                    localStr = strUrl
                } else if (strUrl.lowercaseString.rangeOfString(".jpg") != nil) {
                   // localStr = IMG_Url + "/" + strUrl  //HIDE
                } else {
                    //localStr = chatCDNbaseUrl + "/" + strUrl  //HIDE
                }
                   // localStr = strUrl
                
                var dict = Dictionary<String, AnyObject>()
                /*
                 if let latestValue = receiveMsgDic["meldDate"] as? String {
                 dict["meldDate"] = latestValue
                 }
                 
                 if let latestValue1 = receiveMsgDict["servertime"] as? String {
                 dict["servertime"] = latestValue1
                 }*/
                
                let groupId = receiveMsgDic["groupid"] as! String
                let userCount = receiveMsgDic["userCount"] as! Int
                //deletedUserInGroup
                
                dict["createdBy"] = receiveMsgDic["createdBy"] as! String
                dict["createdDate"] = dateStr as String!
                dict["groupname"] = receiveMsgDic["groupname"] as! String
                
                dict["groupid"] = "\(groupId)"
                dict["imgUrl"] = localStr as String
                dict["message"] = "New Group"
                dict["usercount"] = "\(userCount)"
        
             //   print("getgroupinfo ====> \(dict)")
                
                let instance = DataBaseController.sharedInstance
                let arr:NSArray=receiveMsgDic["groupUser"] as! NSArray
               
                var IsChange :Bool = false
                let exist:GroupList? = instance.checkIfGroupAlreadyExist("GroupList", params: dict)
                
                if (exist != nil) {
                    if (!(exist!.groupName == receiveMsgDic["groupname"] as? String)) {
                        IsChange = true;
                    }
                    
                    if (!(exist!.groupImage == dict["imgUrl"] as? String)) {
                        IsChange = true;
                    }
                    
                } else {
                    instance.insertRecentChatFromGroup("RecentChatList", params: dict)
                }
                
                if IsChange {
                    instance.insertRecentChatFromGroup("RecentChatList", params: dict)
                }
                
               // instance.insertGroupInfoData("GroupList", params: dict)
                instance.insertGroupInfoDataWithAdminRole("GroupList", params: dict, memberArr: arr)
                self?.addUserFromGroupInGroupUserList(arr)
            }
            
            let arr1 = receiveMsgDict["deletedUserInGroup"] as! NSArray
            
            for receiveMsgDic in arr1 {
                
                let groupId = receiveMsgDic["groupid"] as! String
                let instance = DataBaseController.sharedInstance
                let str:String = ChatHelper.userDefaultForKey("userId") 
                let str1:String = "\(groupId)"
                let str2:String = receiveMsgDic["userid"] as! String
                let strPred:String = "loginUserId contains[cd] \"\(str)\" AND groupId LIKE \"\(str1)\" AND userId contains[cd] \"\(str2)\""
                
                if str2 != ChatHelper.userDefaultForKey("userId") as String {
                    instance.deleteData("GroupUserList", predicate: strPred)
                } else {
                    let fetchResult=instance.fetchData("GroupUserList", predicate: strPred, sort: ("groupId",false))! as NSArray
                    
                    for myobject : AnyObject in fetchResult {
                        let groupObj = myobject as! GroupUserList
                        groupObj.isDeletedGroup = "1"
                    }
                }
            }
            
            if arr.count == 0 {
                var dict = Dictionary<String, AnyObject>()
                dict["isUpdate"] = "1"
                NSNotificationCenter.defaultCenter().postNotificationName("groupCreateNotification", object: nil, userInfo: dict)
            }
            
            if arr1.count > 0 {
                var dict = Dictionary<String, AnyObject>()
                dict["isUpdate"] = "0"
                NSNotificationCenter.defaultCenter().postNotificationName("groupCreateNotification", object: nil, userInfo: dict)
            }
        }
    }
    
    func addUserFromGroupInGroupUserList(arr : NSArray) {
        var dictChange = Dictionary<String, AnyObject>()

        print(arr)
        for dic in arr {
            // print(dic)
            let groupId = dic["groupid"] as! NSString
            
            var dict = Dictionary<String, AnyObject>()
            dict["groupid"] = "\(groupId)"
            dict["userid"] = dic["userid"] as! String
            dict["role"] = dic["role"] as! String
            
            let str:String = dict["userid"] as! String
            let strPred:String = "userId contains[cd] \"\(str)\""
            let instance = DataBaseController.sharedInstance
            
            let appContObj=instance.fetchDataAppContObject("AppContactList", predicate: strPred) as AppContactList?
            
            if appContObj != nil {
                dict["username"] = appContObj?.name as String!
                dict["imgUrl"] = appContObj?.userImgString as String!
                dict["isNameAvail"] = "1"
                dict["isDeleted"] = "0"
            } else {
              //  dict["username"] = dic["phoneNumber"] as String!
                var grpMembrName = "notvalue"
                if ((dic["user_firstName"] as? String) != nil) {
                      grpMembrName  = dic["user_firstName"] as! String!
                }
               // print(dic)

                /* changed by Badru
                 if  dic["userid"] as? String != ChatHelper.userDefaultForKey("userId") as String! && grpMembrName != "notvalue"{
                    dict["username"]  = dic["user_firstName"] as! String
                } else {
                    dict["username"] = dic["phoneNumber"] as! String
                }
 */
                //added by Badru
                if let name = dic["user_firstName"] as? String {
                    
                    dict["username"] = name
                }else{
                    
                    dict["username"] = "Dummy Name"
                }
                
             
                dict["imgUrl"] = "" as String!
                dict["isNameAvail"] = "0"
                dict["isDeleted"] = "0"
            }
            
            instance.insertGroupUsersInfoData("GroupUserList", params: dict)
            dictChange["isUpdate"] = "0"
        }
        
        if(arr.count > 0) {
            dictChange["isUpdate"] = "0"
        } else {
            dictChange["isUpdate"] = "1"
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("groupCreateNotification", object: nil, userInfo: dictChange)
    }
    
    func deleteUserFromGroupListner() {
       ChatListner .getChatListnerObj().socket.on("delUserInGroup") {data, ack in
            var receiveMsgDic = Dictionary<String,AnyObject>()
            receiveMsgDic = data[0] as! Dictionary
        print(receiveMsgDic);
        
            let instance = DataBaseController.sharedInstance
            let str:String = ChatHelper.userDefaultForKey("userId") as String
            let str1:String = receiveMsgDic["groupid"] as! String
            let str2:String = receiveMsgDic["userid"] as! String
            let strPred:String = "loginUserId contains[cd] \"\(str)\" AND groupId LIKE \"\(str1)\" AND userId contains[cd] \"\(str2)\""
            
            if str2 != ChatHelper.userDefaultForKey("userId") as String! {
                instance.deleteData("GroupUserList", predicate: strPred)
            } else {
                let fetchResult=instance.fetchData("GroupUserList", predicate: strPred, sort: ("groupId",false))! as NSArray
                
                for myobject : AnyObject in fetchResult {
                    let groupObj = myobject as! GroupUserList
                    groupObj.isDeletedGroup = "1"
                }
            }
        
            let strPred1:String = "loginUserId contains[cd] \"\(str)\" AND groupId LIKE \"\(str1)\""
            let grpObj=instance.fetchDataGroupObject("GroupList", predicate: strPred1) as GroupList?
            let userCount = receiveMsgDic["userCount"] as! Int
            grpObj?.userCount = "\(userCount)"
        
               if receiveMsgDic["newadminid"] != nil {
                let groupAdminId      = receiveMsgDic["newadminid"] as! String
                grpObj?.adminUserId   = "\(groupAdminId)"
               }
        

            self.homeCoreData.saveContext()
            
            var dict = Dictionary<String, AnyObject>()
            dict["isUpdate"] = "0"
            NSNotificationCenter.defaultCenter().postNotificationName("groupCreateNotification", object: nil, userInfo: dict)
        }
    }
    
    /*
    Update Name from db.
    */
    
    func updateFriendNameFromDb()-> Void {
        let str:String = "0"
        let strPred:String = "isNameAvail contains[cd] \"\(str)\""
        let instance = DataBaseController.sharedInstance
        
        let fetchResult=instance.fetchData("RecentChatList", predicate: strPred, sort: ("friendId",true))!
        
        for myobject : AnyObject in fetchResult {
            let anObject = myobject as! RecentChatList
            let str1:String = anObject.friendId as String!
            let strPred1:String = "userId contains[cd] \"\(str1)\""
            let appContObj=instance.fetchDataAppContObject("AppContactList", predicate: strPred1) as AppContactList?
            
            if appContObj != nil {
                anObject.friendName = appContObj?.name as String!
                anObject.friendImageUrl = appContObj?.userImgString as String!
                anObject.isNameAvail = "1"
            }
        }
        self.homeCoreData.saveContext()
        NSNotificationCenter.defaultCenter().postNotificationName("updateNameObserver", object: nil, userInfo: nil)
    }
    
    func hideAlert() {
        UIView.animateWithDuration(0.5, animations:
            {
                self.pushNotificationView.frame=CGRectMake(0, -70, UIScreen.mainScreen().bounds.size.width, 70)
        })
    }
    
    func hideAlertConnectingToServer() {
        
        if socket != nil{
            if socket.status == .Connected  {
                
                if let time = timerConnectingStatus{
                time.invalidate()
                timerConnectingStatus = nil
                }
                
                UIView.animateWithDuration(0.5, animations:
                    {
                        self.pushNotificationView.frame = CGRectMake(0, -70, UIScreen.mainScreen().bounds.size.width, 70)
                        self.userInteractionDisableView.frame = CGRectMake(0, -UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
                })
            }
        }
        
    }
    
    
    func performActionForNotification() {
       // print("navigation")
        
      if let nav = AppDelegate.getAppDelegate().window?.rootViewController as? UINavigationController {
        // print(" performActionForNotification %@",nav)
        let vcArray=nav.viewControllers as Array;
        
        for i in 0 ..< vcArray.count {
            let controller = vcArray[i] as UIViewController;
            
            if(controller.isKindOfClass(UITabBarController)) {
                let tabBarObj = controller as! UITabBarController;
                let navobj : UINavigationController = tabBarObj.selectedViewController as! UINavigationController
                let eventViewObj = navobj.viewControllers[navobj.viewControllers.count - 1] as UIViewController
                
                if eventViewObj.isKindOfClass(FullScreenImageVC) {
                    return
                }
            }
        }
       // print(vcArray)
        
        if self.pushDict != nil {
            let str:String = ChatHelper .userDefaultForAny("userId") as! String
            let str1:String = pushDict["senderid"] as! String
            let strPred:String = "loginUserId contains[cd] \"\(str)\" AND friendId contains[cd] \"\(str1)\""
            let instance = DataBaseController.sharedInstance
            let recentObj=instance.fetchDataRecentChatObject("RecentChatList", predicate: strPred) as RecentChatList?
   
            ChatHelper .removeFromUserDefaultForKey("chatId")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let chattingVc : ChattingMainVC = storyBoard.instantiateViewControllerWithIdentifier("ChattingMainVC") as! ChattingMainVC
            chattingVc.isFromClass="Recent"
            chattingVc.isFromDeatilScreen = "0"
            chattingVc.recentChatObj=recentObj
            
            if recentObj?.groupId == "0" {
                chattingVc.isGroup="0"
            } else {
                chattingVc.isGroup="1"
            }
            
            let nav = AppDelegate.getAppDelegate().window?.rootViewController as! UINavigationController
           let vcArray=nav.viewControllers as Array;
           // print(vcArray)
        
            for i in 0 ..< vcArray.count {
                let controller = vcArray[i] as UIViewController;
                
                if(controller.isKindOfClass(UITabBarController)) {
                   let tabBarObj = controller as! UITabBarController;
                    chattingVc.recentChatObj = recentObj;
                    tabBarObj.selectedIndex = 3
                    
                    delay(0.1, closure: {
                        let navobj : UINavigationController = tabBarObj.selectedViewController as! UINavigationController
                       // print_debug("Gaurav")
                      //  print_debug(navobj.viewControllers)
                        
                        if(navobj.viewControllers.count>1) {
                            navobj.popToRootViewControllerAnimated(false)
                        }
                        
                        let eventViewObj = navobj.viewControllers[0] as UIViewController
                        eventViewObj.navigationController?.pushViewController(chattingVc, animated: true)
                    })
                    break;
                }
            }
        }
    } else {
        return
        }
    }
    
    //Call to make Socket connection
    func createConnection() {
        
        if (AppHelper.userDefaultsForKey("userId")) != nil {
            
            if socket == nil {
              socket = SocketIOClient(socketURL: NSURL(string: socketIO_BaseURL)!, options: [.Log(true), .ForcePolling(true)])
                
            }
            //self.closeConnection();
            if socket.status != .Connected {
                ChatHelper.saveToUserDefault(AppHelper.userDefaultsForKey("userId"), key: "userId")
                ChatListner.getChatListnerObj().connectToSocket()
            }
        }
        else {
            ChatHelper.removeFromUserDefaultForKey("userId")
        }
        ChatHelper.removeFromUserDefaultForKey("oneTime")
        ChatHelper.removeFromUserDefaultForKey("friendId")
    }
    
    func closeConnection() {
        
        if (AppHelper.userDefaultsForKey("userId")) != nil {
            
          //  ChatListner.getChatListnerObj().isConnectionStable = false
            
            ChatHelper.saveToUserDefault(AppHelper.userDefaultsForKey("userId"), key: "userId")
            if socket != nil{
                if socket.status == .Connected  {
                    
                    ChatListner.getChatListnerObj().socket.disconnect()
                    
                  //  socket = nil
                    isConnectionStable = false
                    
                }
            }
         
           

        }
    }
}






