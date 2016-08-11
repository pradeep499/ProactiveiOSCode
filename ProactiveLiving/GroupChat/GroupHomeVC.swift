//
//  GroupHomeVC.swift
//  Whatsumm
//
//  Created by mawoon on 06/05/15.
//  Copyright (c) 2015 AppStudioz. All rights reserved.
//

import UIKit

class GroupHomeVC: UIViewController {

    var groupListArray : NSMutableArray!
    @IBOutlet weak var collection_groupChat: UICollectionView!
    
    var lastMsgTimeDic : NSMutableDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GroupHomeVC.groupCreatedOrUpdatedListener(_:)),name:"groupCreateNotification", object:nil)
        groupListArray = NSMutableArray()
        self.fetchRecentGroupChatFromDb()
        let str:String = ChatHelper.userDefaultForKey("userId") as String!
        let strPred:String = "loginUserId contains[cd] \"\(str)\""
        let instance = DataBaseController.sharedInstance
        
        let fetchResult=instance.fetchData("GroupList", predicate: strPred, sort: ("groupId",false))! as NSArray
        
        for myobject : AnyObject in fetchResult
        {
            let groupObj = myobject as! GroupList
            self.groupListArray.addObject(groupObj);
        }
        collection_groupChat.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "groupCreateNotification", object: nil)
    }
    
    func fetchRecentGroupChatFromDb()-> Void
    {
        let str:String = ChatHelper .userDefaultForAny("userId") as! NSString as String
        let strGroup:String = "0"
        let strPred:String = "loginUserId contains[cd] \"\(str)\" AND NOT (groupId LIKE \"\(strGroup)\")"
        lastMsgTimeDic = NSMutableDictionary()
        let instance = DataBaseController.sharedInstance
        let fetchResult=instance.fetchData("RecentChatList", predicate: strPred, sort:(nil,false))!
        
        for myobject : AnyObject in fetchResult
        {
            let anObject = myobject as! RecentChatList
            lastMsgTimeDic[anObject.groupId!] = calculateTime(anObject.lastMessageTime!)
        }
        collection_groupChat.reloadData()
    }
    
    func groupCreatedOrUpdatedListener(note:NSNotification)
    {
        groupListArray = NSMutableArray()
        self.fetchRecentGroupChatFromDb()
        let str:String = ChatHelper.userDefaultForKey("userId") as String!
        let strPred:String = "loginUserId contains[cd] \"\(str)\""
        let instance = DataBaseController.sharedInstance
        
        let fetchResult=instance.fetchData("GroupList", predicate: strPred, sort: ("groupId",false))! as NSArray
        
        for myobject : AnyObject in fetchResult
        {
            let groupObj = myobject as! GroupList
            self.groupListArray.addObject(groupObj);
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //1
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.groupListArray.count
    }
    
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
            if (IS_IPHONE_5 || IS_IPHONE_4)
            {
                return CGSize(width: 145, height: 165)
            }
            else if (IS_IPHONE_6)
            {
                return CGSize(width: 170, height: 190)
            }else
            {
                return CGSize(width: 190, height: 212)
            }
           
            
    }
    
    //3
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GroupCell", forIndexPath: indexPath) as! GroupHomeCell
        
        var anObject :  GroupList!
        anObject = groupListArray[indexPath.row] as! GroupList
        cell.groupName.text=anObject.groupName
        cell.groupimage.setImageWithURL(NSURL(string:anObject.groupImage!), placeholderImage: UIImage(named:"default_userImage"))
        cell.totalFriend.text = anObject.userCount! +  " Group members"
        
        if let time = lastMsgTimeDic[anObject.groupId!] as? String
        {
            cell.timeAgoLabel.text = lastMsgTimeDic[anObject.groupId!] as? String
        }else
        {
            cell.timeAgoLabel.text = self.calculateTime(anObject.createdDate!)
        }
        cell.groupimage.layer.masksToBounds = true
        cell.groupimage.layer.cornerRadius = 34.5
        // Configure the cell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!)
    {
        let groupObj = groupListArray[indexPath.row] as! GroupList
        let str:String = ChatHelper.userDefaultForKey("userId") as String!
        let str1:String = groupObj.groupId as String!
        let strPred:String = "loginUserId contains[cd] \"\(str)\" AND groupId LIKE \"\(str1)\""
        let instance = DataBaseController.sharedInstance
        let fetchResult=instance.fetchData("RecentChatList", predicate: strPred, sort: ("groupId",false))! as NSArray
        var recentChatObj : RecentChatList!
        for myobject : AnyObject in fetchResult
        {
             recentChatObj = myobject as! RecentChatList
            
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let chatMainObj: ChattingMainVC = storyBoard.instantiateViewControllerWithIdentifier("ChattingMainVC") as! ChattingMainVC
        chatMainObj.isFromClass="Recent"
        chatMainObj.recentChatObj=recentChatObj
        chatMainObj.isGroup="1"
        self.navigationController?.pushViewController(chatMainObj, animated: true)
    }

    @IBAction func backBtnClick(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func addGroupClick(sender: AnyObject)
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let chatMainObj: CreateChatGroupVC = storyBoard.instantiateViewControllerWithIdentifier("CreateChatGroupVC") as! CreateChatGroupVC
        self.navigationController?.pushViewController(chatMainObj, animated: true)
    }
    
    func calculateTime(str : String) -> String!
    {
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd-HH:mm:ss.SSS"
        dateFormatter1.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter1.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        let event_PostTime = dateFormatter1.dateFromString(str) as NSDate!
        var timeStr : String!
        
        timeStr = ""
       /*
        if(event_PostTime != nil)
        {
        if(NSDate().daysFrom(event_PostTime)>=1)
        {
            if(NSDate().daysFrom(event_PostTime)==1)
            {
                timeStr = NSDate().daysFrom(event_PostTime).description + " day ago"
            }
            else
            {
                timeStr = NSDate().daysFrom(event_PostTime).description + " days ago"
            }
        }
        else if(NSDate().hoursFrom(event_PostTime)>=1)
        {
            if(NSDate().hoursFrom(event_PostTime)==1)
            {
                timeStr = NSDate().hoursFrom(event_PostTime).description + " hour ago"
            }
            else
            {
                timeStr = NSDate().hoursFrom(event_PostTime).description + " hours ago"
            }
        }
        else if(NSDate().minutesFrom(event_PostTime)>=1)
        {
            if(NSDate().minutesFrom(event_PostTime)==1)
            {
                timeStr = NSDate().minutesFrom(event_PostTime).description + " min ago"
            }
            else
            {
                timeStr = NSDate().minutesFrom(event_PostTime).description + " mins ago"
            }
        }
        else
        {
            if(NSDate().secondsFrom(event_PostTime)==1)
            {
                timeStr = NSDate().secondsFrom(event_PostTime).description + " sec ago"
            }
            else
            {
                timeStr = NSDate().secondsFrom(event_PostTime).description + " secs ago"
            }
        }
        } */
        return timeStr;
    }

}
