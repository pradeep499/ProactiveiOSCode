
//
//  MeetUpsListingVC.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 02/09/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import Foundation

class MeetUpsListingVC: UIViewController {

    var pushedFrom : String!
    lazy var arrData = [AnyObject]()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.arrData = Array()

    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = true
        self.fetchMeetUpOrWebInviteData()
    }
    
    //mark- Fetch Meetups/Invites listing data
    func fetchMeetUpOrWebInviteData() {
        
        if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {
            
            var dict = Dictionary<String,AnyObject>()
            if(self.title == "MEET UPS") {
                dict["type"]="meetup"
            }
            else {
                dict["type"]="webinvite"
            }
            dict["userId"]=ChatHelper.userDefaultForKey("userId") as String
            ChatListner .getChatListnerObj().socket.emit("getAllMeetup_Invite", dict)
            
            //unowned let weakself = self
            ChatListner .getChatListnerObj().socket.off("getMeetup_Invite_listing")
            ChatListner .getChatListnerObj().socket.on("getMeetup_Invite_listing") {data, ack in
               
                
                print("value error_code\(data[0]["status"] as! String))")
                    
                    let errorCode = (data[0]["status"] as? String) ?? "1"
                
                    if errorCode == "0"
                    {
                        guard let dictData = data[0] as? Dictionary<String, AnyObject> else
                        {
                            return
                        }
                        
                        guard let data = dictData["result"] as? [AnyObject] else
                        {
                            return
                        }
                        
                        self.arrData = data
                        
                        print("arrayList \(self.arrData)")
                        
                        self.tableView.reloadData()
                    }
                    else
                    {
                        //SharedClass.sharedInstance.showOkAlertViewController(result!["response_string"] as! String, viewController: self)
                        
                    }
            }
            
        }else
        {
            AppDelegate.dismissProgressHUD()
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Internet Connection not available.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
        }
    }
    
    //mark- UITableview Delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
        return 200
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("CellMeetUps", forIndexPath: indexPath) as! MeetUpListingCell
        cell.selectionStyle = .None
        let eventImage = cell.contentView.viewWithTag(11) as! UIImageView
        eventImage.layer.cornerRadius = eventImage.frame.height/2
        eventImage.clipsToBounds = true
        let eventName = cell.contentView.viewWithTag(12) as! UILabel
        let statusBG = cell.contentView.viewWithTag(13) as! UIImageView
        let eventTypeBy = cell.contentView.viewWithTag(15) as! UILabel
        let eventDesc = cell.contentView.viewWithTag(16) as! UILabel
        let lblDate = cell.contentView.viewWithTag(18) as! UILabel
        let imglink = cell.contentView.viewWithTag(19) as! UIImageView
        let txtLink = cell.contentView.viewWithTag(20) as! UILabel
        let txtPIN = cell.contentView.viewWithTag(21) as! UILabel
        let imgCall = cell.contentView.viewWithTag(23) as! UIImageView
        let lblCall = cell.contentView.viewWithTag(24) as! UILabel
        let lblMembers = cell.contentView.viewWithTag(27) as! UILabel
        let lblAddress = cell.contentView.viewWithTag(28) as! UITextView
        lblAddress.textContainer.lineFragmentPadding = 0;
        lblAddress.textContainerInset = UIEdgeInsetsZero;
        
        eventName.text = self.arrData[indexPath.row]["title"] as? String
        
        let isUpdated = self.arrData[indexPath.row]["isEdited"] as! Bool
        if (isUpdated) {
            statusBG.hidden = false
            statusBG.image = UIImage(named:"updated_ribbon")
        }
        else
        {
            statusBG.hidden = true
        }
        
        let isDeleted = self.arrData[indexPath.row]["isDeleted"] as! Bool
        if (isDeleted) {
            statusBG.hidden = false
            statusBG.image = UIImage(named:"cancelled_ribbon")
        }
        else
        {
            statusBG.hidden = true
        }
        
        eventTypeBy.text = "\(self.arrData[indexPath.row]["for"] as! String), by \(self.arrData[indexPath.row]["createdBy"] as! String)"
        eventDesc.text = self.arrData[indexPath.row]["desc"] as? String
        lblDate.text = self.arrData[indexPath.row]["eventDate"] as? String
        
        //lblLink.text = (self.arrData[indexPath.row]["links"] as! Array).joinWithSeparator(",")
        //lblPhone.text = self.arrData[indexPath.row]["dialInNumber"] as? String

        if let imageUrlStr = self.arrData[indexPath.row]["imgUrl"] as? String {
            
            let image_url = NSURL(string: imageUrlStr)
            if (image_url != nil) {
                let placeholder = UIImage(named: "ic_booking_profilepic")
                eventImage.setImageWithURL(image_url, placeholderImage: placeholder)
            }
        }
        
        let acceptButton = cell.contentView.viewWithTag(25) as! UIButton
        let declineButton = cell.contentView.viewWithTag(26) as! UIButton
        AppHelper.setBorderOnView(acceptButton)
        AppHelper.setBorderOnView(declineButton)
        
        var dataDict = self.arrData[indexPath.row] as! [String : AnyObject]
        let arrMembers = dataDict["members"] as! [AnyObject]

        //Check status if member accepted or rejacted--
        for item in arrMembers {
            
            var membDict = item as! [String : AnyObject]
            let status = membDict["status"] as! String
            
            
            if(membDict["memberId"] as! String == ChatHelper.userDefaultForKey("userId"))
            {
              
                if(status == "1")
                {
                    cell.btnAccept.selected=true
                    cell.imgAccept.hidden=false
                    cell.btnAccept.layer.borderColor=UIColor(red: 1/255.0, green: 174/255.0, blue: 240/255.0, alpha: 1.0).CGColor
                    
                    cell.btnDecline.selected=false
                    cell.imgDecline.hidden=true
                    cell.btnDecline.layer.borderColor=UIColor.clearColor().CGColor
                }
                else if(status == "2")
                {
                    cell.btnDecline.selected=true
                    cell.imgDecline.hidden=false
                    cell.btnDecline.layer.borderColor=UIColor(red: 1/255.0, green: 174/255.0, blue: 240/255.0, alpha: 1.0).CGColor
                    
                    cell.btnAccept.selected=false
                    cell.imgAccept.hidden=true
                    cell.btnAccept.layer.borderColor=UIColor.clearColor().CGColor
                }
                
            }
            
        }
        
        if((dataDict["createdBy"] as! String) == ChatHelper.userDefaultForKey("userId"))
        {
            cell.btnAccept.enabled=false
            cell.btnDecline.enabled=false
        }
        
        
        if(self.title == "MEET UPS") {
            
            acceptButton.setTitle("Sure!", forState: UIControlState.Normal)
            declineButton.setTitle("Sorry!", forState: UIControlState.Normal)
            
            acceptButton.titleLabel?.text="Sure!"
            declineButton.titleLabel?.text="Sorry!"
            lblAddress.hidden=false
            txtLink.hidden=true
            txtPIN.hidden=true
            lblAddress.text = self.arrData[indexPath.row]["address"] as? String
            imglink.image=UIImage(named:"address")
            imgCall.hidden=true
            lblCall.hidden=true

            var someDict:[String:AnyObject] = self.arrData[indexPath.row] as! [String : AnyObject]
            let memberArr = someDict["members"] as! [AnyObject]
            lblMembers.text = "\(memberArr.count) Going"
        }
        else {
            
            acceptButton.setTitle("Accept", forState: UIControlState.Normal)
            declineButton.setTitle("Decline", forState: UIControlState.Normal)

            acceptButton.titleLabel?.text="Accept"
            declineButton.titleLabel?.text="Decline"
            lblAddress.hidden=true
            txtLink.hidden=false
            txtPIN.hidden=false
            imgCall.hidden=false
            lblCall.hidden=false
            
            txtLink.text = self.arrData[indexPath.row]["webLink"] as? String
            lblCall.text = self.arrData[indexPath.row]["dialInNumber"] as? String
            txtPIN.text = "(PIN: \(self.arrData[indexPath.row]["pin"] as! String))"
            imglink.image=UIImage(named:"web_invite_link")
           
            
            var someDict:[String:AnyObject] = self.arrData[indexPath.row] as! [String : AnyObject]
            let memberArr = someDict["members"] as! [AnyObject]
            lblMembers.text = "\(memberArr.count) Attending"        }
        
        acceptButton.addTarget(self, action: #selector(btnAcceptClick(_:)), forControlEvents: .TouchUpInside)
        declineButton.addTarget(self, action: #selector(btnDeclineClick(_:)), forControlEvents: .TouchUpInside)
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let meetUpDetailVC: MeetUpDetailsVC = storyBoard.instantiateViewControllerWithIdentifier("MeetUpDetailsVC") as! MeetUpDetailsVC
        meetUpDetailVC.meetUpID=self.arrData[indexPath.row]["_id"] as! String
        if(self.title == "MEET UPS")
        {
            meetUpDetailVC.screenName = "MEET UPS"
        }
        else
        {
            meetUpDetailVC.screenName = "WEB INVITES"
        }
        self.navigationController?.pushViewController(meetUpDetailVC, animated: true)
        
    }
    
    //Accept button tapped
    func btnAcceptClick(sender: UIButton)  {
        print(sender)
        //sender.selected = !sender.selected
        let point = self.tableView.convertPoint(CGPoint.zero, fromView: sender)
        
        guard let indexPath = self.tableView.indexPathForRowAtPoint(point) else {
            fatalError("can't find point in tableView")
        }
        
        var someDict:[String:AnyObject] = self.arrData[indexPath.row] as! [String : AnyObject]
        
        var dict = Dictionary<String,AnyObject>()
        
        if(self.title == "MEET UPS") {
            dict["type"]="meetup"
        }
        else {
            dict["type"]="webinvite"
        }
        dict["typeId"] = someDict["_id"] as! String
        dict["status"] = "1"
        dict["userId"] = ChatHelper.userDefaultForKey(_ID)
        
        
        //group info
        var groupDict = Dictionary<String,AnyObject>()
        groupDict["userid"] = someDict["createdBy"] as! String
        groupDict["groupid"] = someDict["groupId"] as! String
        groupDict["groupuserid"] = ChatHelper.userDefaultForKey(_ID)
        groupDict["phoneNumber"] = ChatHelper.userDefaultForKey(cellNum)
        
        dict["groupInfo"] = groupDict

        ChatListner .getChatListnerObj().socket.emit("acceptMeetup_Invite", dict)

        self.fetchMeetUpOrWebInviteData()
    }
    
    
    // Decline button tapped
    func btnDeclineClick(sender: UIButton)  {
        print(sender)
        //sender.selected = !sender.selected
        
        let point = self.tableView.convertPoint(CGPoint.zero, fromView: sender)
        
        guard let indexPath = self.tableView.indexPathForRowAtPoint(point) else {
            fatalError("can't find point in tableView")
        }
        
        var someDict:[String:AnyObject] = self.arrData[indexPath.row] as! [String : AnyObject]
        
        var dict = Dictionary<String,AnyObject>()
        if(self.title == "MEET UPS") {
            dict["type"]="meetup"
        }
        else {
            dict["type"]="webinvite"
        }
        dict["typeId"] = someDict["_id"] as! String
        dict["status"] = "2"
        dict["userId"] = ChatHelper.userDefaultForKey("userId")
        
        //group info
        var groupDict = Dictionary<String,AnyObject>()
        groupDict["userid"] = someDict["createdBy"] as! String
        groupDict["groupid"] = someDict["groupId"] as! String
        groupDict["groupuserid"] = ChatHelper.userDefaultForKey(_ID)
        groupDict["phoneNumber"] = ChatHelper.userDefaultForKey(cellNum)
        
        dict["groupInfo"] = groupDict
        
        ChatListner .getChatListnerObj().socket.emit("acceptMeetup_Invite", dict)

        self.fetchMeetUpOrWebInviteData()

    }

    
}
