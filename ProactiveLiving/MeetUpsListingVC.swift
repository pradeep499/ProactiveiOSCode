
//
//  MeetUpsListingVC.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 02/09/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import Foundation
import EventKit

class MeetUpsListingVC: UIViewController {

    var pushedFrom : String!
    var arrData = [AnyObject]()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.arrData = Array()
        
      NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.notificationCall), name: "getState", object: nil)

    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = true

        self.fetchAllMeetupsOrWebInvites()
        self.listenerUpdateMeetupOrWebInvite()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tableView.setNeedsDisplay(); // repaint
        self.tableView.setNeedsLayout(); // re-layout

    }
    
    func notificationCall(){
        print("calling notifiaction")
        print(arrData)

        self.fetchAllMeetupsOrWebInvites()
        self.listenerUpdateMeetupOrWebInvite()

    }
    
    func fetchAllMeetupsOrWebInvites() {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("")
            var parameters = Dictionary<String,AnyObject>()
            if(self.title == "MEET UPS") {
                parameters["type"]="meetup"
           }
            else {
            parameters["type"]="webinvite"
            }
            parameters["userId"]=ChatHelper.userDefaultForKey("userId") as String
            
            print("parameters")
            print(parameters)
            //call global web service class latest
            Services.postRequest(ServiceGetAllMeetupInvite, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                AppDelegate.dismissProgressHUD()
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        print("arrayList \(self.arrData)")

                        guard let dataArr = responseDict["result"] as? [AnyObject] else
                        {
                            return
                        }

                        self.arrData = dataArr
                        
                        
                        self.tableView.reloadData()
                        
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
    
    //mark- Fetch Meetups/Invites listing data
    func fetchMeetUpOrWebInviteData() {
        AppDelegate.showProgressHUDWithStatus("Please wait...")
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
                        AppDelegate.dismissProgressHUD()
                    }
                    else
                    {
                        AppDelegate.dismissProgressHUD()
                        //SharedClass.sharedInstance.showOkAlertViewController(result!["response_string"] as! String, viewController: self)
                        
                    }
            }
           
        }else
        {
            AppDelegate.dismissProgressHUD()
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Internet Connection not available.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
        }
    }
    
    func listenerUpdateMeetupOrWebInvite() {
        
        if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {

            ChatListner .getChatListnerObj().socket.off("getAccept_Meetup_Invite")
            ChatListner .getChatListnerObj().socket.on("getAccept_Meetup_Invite") {data, ack in
                
                print("value error_code\(data[0]["status"] as! String))")
                
                let errorCode = (data[0]["status"] as? String) ?? "1"
                
                if errorCode == "0"
                {
                    guard let dictData = data[0] as? Dictionary<String, AnyObject> else
                    {
                        return
                    }
                    
                    guard let resultDict = dictData["result"] as? Dictionary<String, AnyObject>  else
                    {
                        return
                    }
                    
                    print("arrayList \(resultDict)")
                    
                    let predicate = NSPredicate(format: "(%K == %@)", "_id", resultDict["_id"] as! String)
                    var filteredarray:[AnyObject] = (self.arrData as NSArray).filteredArrayUsingPredicate(predicate)
                    print("ID = \(resultDict["_id"])")
                    
                    print("arrayDATA = \(self.arrData)")

                  
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    if filteredarray.count > 0 {
                        let index = (self.arrData as NSArray).indexOfObject(filteredarray[0])
                        //self.arrData.removeAtIndex(index)
                       // self.arrData.insert(filteredarray[0], atIndex: index)
                        self.arrData[index] = resultDict
                        let indexpath = NSIndexPath(forRow: index, inSection: 0)
                        self.tableView.reloadRowsAtIndexPaths([indexpath], withRowAnimation: .Fade)
                        
                        
                    }
                    
                    
                    
                    //self.tableView.reloadData()
                   //
                    //Add newly created meeup/invite to phone calender
                    if (resultDict["isNewMeetupInvite"] as? String) != nil {
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm a"
                        let startDate = dateFormatter.dateFromString((resultDict["eventDate"] as! String) + " " + (resultDict["eventStartTime"] as! String))
                        let endDate = dateFormatter.dateFromString((resultDict["eventDate"] as! String) + " " + (resultDict["eventEndTime"] as! String))
                        let title = resultDict["title"] as! String
                        let notes = resultDict["desc"] as! String
                        
                        AppHelper.addEventToPhoneCalendarWithStartDate(startDate, endDate: endDate, withTitle: title, withNotes: notes)
                    }
                }
                else
                {
                    //SharedClass.sharedInstance.showOkAlertViewController(result!["response_string"] as! String, viewController: self)
                    
                }
            }
        }
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
        groupDict["userid"] = someDict["createdBy"]!["_id"] as! String
        groupDict["groupid"] = someDict["groupId"] as! String
        groupDict["groupuserid"] = ChatHelper.userDefaultForKey(_ID)
        groupDict["phoneNumber"] = ChatHelper.userDefaultForKey(cellNum)
        
        dict["groupInfo"] = groupDict
        ChatListner .getChatListnerObj().socket.emit("acceptMeetup_Invite", dict)

        //let startDateStr = HelpingClass.convertDateFormat("dd/MM/yyyy HH:mm a", desireFormat: "EEE MMM d HH:mm",  dateStr: (someDict["eventDate"] as! String) + " " + (someDict["eventStartTime"] as! String))
        //let endDateStr = HelpingClass.convertDateFormat("dd/MM/yyyy HH:mm a", desireFormat: "EEE MMM d HH:mm",  dateStr: (someDict["eventDate"] as! String) + " " + (someDict["eventEndTime"] as! String))
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm a"
        let startDate = dateFormatter.dateFromString((someDict["eventDate"] as! String) + " " + (someDict["eventStartTime"] as! String))
        let endDate = dateFormatter.dateFromString((someDict["eventDate"] as! String) + " " + (someDict["eventEndTime"] as! String))
        let title = someDict["title"] as! String
        let notes = someDict["desc"] as! String
        
        AppHelper.addEventToPhoneCalendarWithStartDate(startDate, endDate: endDate, withTitle: title, withNotes: notes)
        
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
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm a"
        let startDate = dateFormatter.dateFromString((someDict["eventDate"] as! String) + " " + (someDict["eventStartTime"] as! String))
        var endDate = dateFormatter.dateFromString((someDict["eventDate"] as! String) + " " + (someDict["eventEndTime"] as! String))
        endDate = endDate?.dateByAddingTimeInterval(86400)
        self.toRemoveOrCheckForExting(startDate, endDate: endDate, title: someDict["title"] as? String)
        

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
        groupDict["userid"] = someDict["createdBy"]!["_id"] as! String
        groupDict["groupid"] = someDict["groupId"] as! String
        groupDict["groupuserid"] = ChatHelper.userDefaultForKey(_ID)
        groupDict["phoneNumber"] = ChatHelper.userDefaultForKey(cellNum)
        
        dict["groupInfo"] = groupDict
        
        ChatListner .getChatListnerObj().socket.emit("acceptMeetup_Invite", dict)

    }
    
    func toRemoveOrCheckForExting(startDate:NSDate? ,endDate:NSDate? ,title:String? ){
        let eventStore = EKEventStore()
        let predicate = eventStore.predicateForEventsWithStartDate(startDate!, endDate: endDate!, calendars: nil)
        let arrEv = eventStore.eventsMatchingPredicate(predicate)
        for ele in arrEv {
            if ele.title == title!{
                do{
                    try eventStore.removeEvent(ele, span: .ThisEvent)
                }catch{
                    print_debug("error on Removing")
                }
            }
        
    }
    }
    
}





extension MeetUpsListingVC: UITableViewDataSource,UITableViewDelegate{
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        let w = self.tableView.bounds.size.width - 30
        
        var str:String = String()
        
        if(self.title == "MEET UPS") {
            str = (self.arrData[indexPath.row]["address"] as? String)!
        }else{
            str = (self.arrData[indexPath.row]["webLink"] as? String)!
        }
        str = str.stringByReplacingEmojiCheatCodesWithUnicode()
        
        let size : CGSize =  CommonMethodFunctions.sizeOfCell(str, fontSize: 13 , width: Float(w) , fontName: "Roboto-Regular")
        
        let height = size.height + (185)
        
        return height
    }
    
    // By me 
    func daySuffix(from date: NSDate) -> String {
        let calendar = NSCalendar.currentCalendar()
        let dayOfMonth = calendar.component(.Day, fromDate: date)
        switch dayOfMonth {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("CellMeetUps", forIndexPath: indexPath) as! MeetUpListingCell
        cell.selectionStyle = .None
        let eventImage = cell.contentView.viewWithTag(11) as! UIImageView
        eventImage.layer.cornerRadius = eventImage.frame.height/2
        eventImage.clipsToBounds = true
        print("data reload")
        let eventName = cell.contentView.viewWithTag(12) as! UILabel
        let statusBG = cell.contentView.viewWithTag(13) as! UIImageView
        let eventTypeBy = cell.contentView.viewWithTag(15) as! UILabel
        let eventDesc = cell.contentView.viewWithTag(16) as! UILabel
        let lblMembers = cell.contentView.viewWithTag(18) as! UILabel
        let lbl_createdDate = cell.contentView.viewWithTag(27) as! UILabel
        let lbl_eventDate = cell.contentView.viewWithTag(80) as! UILabel
        let lblAddress = cell.contentView.viewWithTag(20) as! UILabel
        let imgAddress = cell.contentView.viewWithTag(33) as! UIImageView
        
        eventName.text = self.arrData[indexPath.row]["title"] as? String
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
                    cell.btnAccept.userInteractionEnabled = false
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
                else if(status == "0")
                {
                    cell.btnDecline.selected=false
                    cell.btnAccept.selected=false
                    
                    cell.imgDecline.hidden=true
                    cell.imgAccept.hidden=true
                    
                    cell.btnDecline.layer.borderColor=UIColor.clearColor().CGColor
                    cell.btnAccept.layer.borderColor=UIColor.clearColor().CGColor
                }
                
            }
            
        }

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
        
        
        let forr = self.arrData[indexPath.row]["for"] as! String
        let fName =  self.arrData[indexPath.row]["createdBy"]!!["firstName"] as! String
        let lName = self.arrData[indexPath.row]["createdBy"]!!["lastName"] as! String
        
        eventTypeBy.text = forr + ", by " +  fName + " " + lName
        
        eventDesc.text = self.arrData[indexPath.row]["desc"] as? String
        
        
        if let dateStr =  self.arrData[indexPath.row]["createdDate"] as? String {
            
            lbl_createdDate.text = HelpingClass.convertDateFormat("yyyy-MM-dd HH:mm:ss", desireFormat: "dd MMM hh:mm a",  dateStr: dateStr)
        }
        
        
        if let dateStr =  self.arrData[indexPath.row]["eventDate"] as? String {
            

 
            
            
            let df = NSDateFormatter.init()
            df.dateFormat = "dd/MM/yyyy"
            let dayTH = HelpingClass.convertDateFormat("dd/MM/yyyy", desireFormat: "EEE d",  dateStr: dateStr)
            
            let date = HelpingClass.convertDateFormat("dd/MM/yyyy", desireFormat: " MMM",  dateStr: dateStr)
            
            let eventDate = dayTH + self.daySuffix(from:df.dateFromString(dateStr)! ) + date

            
            lbl_eventDate.text = eventDate
            
             if let eventTime =   self.arrData[indexPath.row]["eventStartTime"] as? String{
                 lbl_eventDate.text = eventDate + "  " + eventTime
            }
            
        }

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
        
        cell.btnAccept.userInteractionEnabled = true
        
        
        if((dataDict["createdBy"]!["_id"] as! String) == ChatHelper.userDefaultForKey("userId"))
        {
            cell.btnAccept.enabled=false
            cell.btnDecline.enabled=false
            cell.btnAccept.setTitleColor(.lightGrayColor(), forState: .Normal)
            cell.btnDecline.setTitleColor(.lightGrayColor(), forState: .Normal)
            
        }
        else {
            
            cell.btnAccept.enabled=true
            cell.btnDecline.enabled=true
            cell.btnAccept.setTitleColor(.blackColor(), forState: .Normal)
            cell.btnDecline.setTitleColor(.blackColor(), forState: .Normal)
            
        }
        
        
        if(self.title == "MEET UPS") {
            
            acceptButton.setTitle("Sure!", forState: UIControlState.Normal)
            declineButton.setTitle("Sorry!", forState: UIControlState.Normal)
            
           // acceptButton.titleLabel?.text="Sure!"
           // declineButton.titleLabel?.text="Sorry!"
            
            lblAddress.text = self.arrData[indexPath.row]["address"] as? String
            imgAddress.image=UIImage(named:"address")
            
            
            var someDict:[String:AnyObject] = self.arrData[indexPath.row] as! [String : AnyObject]
            let memberArr = someDict["members"] as! [AnyObject]
            let totalInvited = memberArr.count-1
            lblMembers.text = "\(totalInvited)  Invited"
        }
        else {
            
            acceptButton.setTitle("Accept", forState: UIControlState.Normal)
            declineButton.setTitle("Decline", forState: UIControlState.Normal)
            
            //acceptButton.titleLabel?.text="Accept"
           // declineButton.titleLabel?.text="Decline"
        
            lblAddress.text = self.arrData[indexPath.row]["webLink"] as? String
            imgAddress.image=UIImage(named:"web_invite_link")
            
            var someDict:[String:AnyObject] = self.arrData[indexPath.row] as! [String : AnyObject]
            let memberArr = someDict["members"] as! [AnyObject]
            lblMembers.text = "\(memberArr.count) Attending"
        }
        
        acceptButton.addTarget(self, action: #selector(btnAcceptClick(_:)), forControlEvents: .TouchUpInside)
        declineButton.addTarget(self, action: #selector(btnDeclineClick(_:)), forControlEvents: .TouchUpInside)
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let meetUpDetailVC: MeetUpDetailsVC = storyBoard.instantiateViewControllerWithIdentifier("MeetUpDetailsVC") as! MeetUpDetailsVC
        meetUpDetailVC.meetUpID=self.arrData[indexPath.row]["_id"] as! String
        meetUpDetailVC.dataDict = self.arrData[indexPath.row] as! [String : AnyObject]
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

    
    
}



