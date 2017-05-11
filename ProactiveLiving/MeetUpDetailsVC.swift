//
//  MeetUpDetailsVC.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 05/09/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit

class MeetUpDetailsVC: UIViewController, UIActionSheetDelegate {
    
    
    //MARK:-Properties
    
    var arrayForBool = [Int]()
    lazy var dataDict = [String : AnyObject]()
    var selectedRowsArray=[String]()
    var screenName: String!
    var meetUpID: String!
    var fwBy: String!
    var meetUpGroupID: String!
    
    //MARK:-Outlets
    
    @IBOutlet weak var imgMeetUp: UIImageView!
    @IBOutlet weak var imgLike: UIImageView!
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var btnForward: UIButton!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var tableMeetUpDetails: UITableView!
    @IBOutlet weak var btnLink: UIButton!
    @IBOutlet weak var btnDialUp: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var dialUpView: UIView!
    @IBOutlet weak var HConstDialUpView: NSLayoutConstraint!
    @IBOutlet weak var btnSure: UIButton!
    @IBOutlet weak var btnSorry: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var imgSure: UIImageView!
    @IBOutlet weak var imgSorry: UIImageView!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var layout_forwartBtnWidth: NSLayoutConstraint!
    
    
    //MARK:-View Life Cycle
    
    override func viewDidLoad() {
        
        for _ in 0..<4 {
            arrayForBool.append(Int(false))
        }
        //Section 1 always remain not-collepsable (BMI Only, BMI & BFP)
        arrayForBool[0] = Int(true)
        arrayForBool[1] = Int(true)
        arrayForBool[2] = Int(true)
        arrayForBool[3] = Int(true)

        imgMeetUp.contentMode = .ScaleAspectFill
        imgMeetUp.clipsToBounds = true
        
        btnForward.layer.borderWidth = 2.0;
        btnForward.layer.cornerRadius = 3.0
        btnForward.layer.borderColor=UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0).CGColor
        btnForward.addTarget(self, action: #selector(btnForwardClick(_:)), forControlEvents: .TouchUpInside)

        //tableMeetUpDetails.estimatedRowHeight = 80.0
        //tableMeetUpDetails.rowHeight = UITableViewAutomaticDimension
        
        btnSure.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btnSorry.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        btnSure.setTitleColor(UIColor(red: 1/255.0, green: 174/255.0, blue: 240/255.0, alpha: 1.0), forState: UIControlState.Selected)
        btnSorry.setTitleColor(UIColor(red: 1/255.0, green: 174/255.0, blue: 240/255.0, alpha: 1.0), forState: UIControlState.Selected)
        
        
    
        imgSure.hidden=true
        imgSorry.hidden=true
        btnSure.layer.borderWidth=1.0;
        btnSorry.layer.borderWidth=1.0;
        btnSure.layer.borderColor=UIColor.clearColor().CGColor
        btnSorry.layer.borderColor=UIColor.clearColor().CGColor

        btnSure.addTarget(self, action: #selector(btnAcceptClick(_:)), forControlEvents: .TouchUpInside)
        btnSorry.addTarget(self, action: #selector(btnDeclineClick(_:)), forControlEvents: .TouchUpInside)
        
        btnLike.addTarget(self, action: #selector(btnLikeClick(_:)), forControlEvents: .TouchUpInside)
        btnLike.setImage(UIImage(named: "like_empty"), forState: .Normal)
        btnLike.setImage(UIImage(named: "like_filled"), forState: .Selected)

        btnLink.addTarget(self, action: #selector(btnLinkClick(_:)), forControlEvents: .TouchUpInside)
        btnDialUp.addTarget(self, action: #selector(btnDialUpClick(_:)), forControlEvents: .TouchUpInside)
        
        if(self.screenName == "WEB INVITES") {
            self.layout_forwartBtnWidth.constant = 125
        }

        self.listenerUpdateMeetUpOrWebInvite()
        
        
       
        print_debug("LATLONG App\(AppHelper.userDefaultsForKey("location"))")
        

    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = true
        
        //self.fetchDataMeetUpOrWebInviye()
        self.updateCurrentView()

        if(self.screenName ==  "MEET UPS") {
            self.HConstDialUpView.constant=0;
        }
        else {
            self.HConstDialUpView.constant=40;
            
        }

    }
   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //return self.dataArray.count
        if(self.dataDict.count>0)
        {
        return 4
        }
        else
        {
        return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, screenWidth, 50))
        headerView.tag = section
        headerView.backgroundColor = UIColor.whiteColor()
        let headerString = UILabel(frame: CGRectMake(10, 0, 200, 50))
        headerString.font = UIFont(name: FONT_REGULAR, size: 17)
        headerString.textAlignment = .Left
        headerString.textColor = UIColor.darkGrayColor()
        headerView.addSubview(headerString)
        let manyCells = Bool(arrayForBool[section] as NSNumber)
        switch section {
        case 0:
            headerString.text = ""
        case 1:
            headerString.text = "Description"
        case 2:
            headerString.text = "Additional Information"
        case 3:
                let dataArr = self.dataDict["members"] as! [AnyObject]
                var counter : Int = 0
                for item in dataArr {
                    let dataDict = item as! [String : AnyObject]
                    
                    if ((dataDict["status"] as! String) == "1") {
                        counter = counter+1
                    }

                    
                }
                
                headerString.text = "Invited Friends ( \(counter) Of  \(dataArr.count))"
        default:
            break
        }
        
        //Section 1 always remain not-collepsable (Additional Information)
        if (section == 0 || section == 1 || section == 2 || section == 3 ) {
            let headerTapped = UITapGestureRecognizer(target: self, action: #selector(self.sectionHeaderTapped))
            headerView.addGestureRecognizer(headerTapped)
            //up or down arrow depending on the bool
            let upDownArrow = UIImageView(image: UIImage(named: "ic_filterservice_arrow")!)
            upDownArrow.autoresizingMask = .FlexibleLeftMargin
            upDownArrow.frame = CGRectMake(screenWidth - 27, 19, 7, 12)
            headerView.addSubview(upDownArrow)
            UIView.animateWithDuration(0.3, animations: {() -> Void in
                if manyCells {
                    upDownArrow.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
                }
                else {
                    upDownArrow.transform = CGAffineTransformMakeRotation(CGFloat(0))
                }
            })
        }
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 50
        case 2:
            return 50
        case 3:
            return 50
        default:
            break
        }
        
        return 0.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if Bool(arrayForBool[indexPath.section] as NSNumber) {
            switch indexPath.section {
            case 0:
                return 84
                
            case 1:
                return ((self.dataDict["desc"] as! String?)?.sizeWithFont(UIFont(name: FONT_LIGHT, size: 13.0)!, constrainedToWidth: screenWidth-16, lineBreakMode: .ByWordWrapping).height)!+10
            case 2:
                return 30
            case 3:
                return 116
            default:
                break
            }
            }
            else
            {
                return 0
            }
         return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if Bool(arrayForBool[section] as NSNumber) {
            switch section {
            case 0,1,3:
                return 1
            case 2:
                return (self.dataDict["links"] as! [AnyObject]).count
            default:
                break
            }
        }
        else
        {
            return 0
        }
         return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableMeetUpDetails.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
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
        
        let kCustomCellID0 = "MeetUpProfileCell"
        let kCustomCellID1 = "DescriptionCell"
        let kCustomCellID2 = "AdditionalInfoCell"
        let kCustomCellID3 = "AllMembersCell"
        
        let df = NSDateFormatter.init()
        df.dateFormat = "dd/MM/yyyy"
        
        

        switch (indexPath.section) {
        case (0):
            let cell = tableView.dequeueReusableCellWithIdentifier(kCustomCellID0, forIndexPath: indexPath) as! MeetUpProfileCell
            cell.selectionStyle = .None
            cell.lblName.text=self.dataDict["for"] as? String
            
           

            
            let dict = self.dataDict["createdBy"] as! [String:AnyObject]
            if let imageUrlStr = dict["imgUrl"] as? String {
                let image_url = NSURL(string: imageUrlStr)
                if (image_url != nil) {
                    let placeholder = UIImage(named: "no_photo")
                    cell.imgProfile.sd_setImageWithURL(image_url, placeholderImage: placeholder)
                }
            }

            
            cell.lblCreatedBy.text="by \(self.dataDict["createdBy"]!["firstName"] as! String)" + "  \(self.dataDict["createdBy"]!["lastName"] as! String)"
            
            if(!(self.fwBy == ""))
            {
                cell.lblForwardBy.hidden=false
                cell.lblForwardBy.text="FW: by \(self.fwBy)"
            }
            else
            {
                cell.lblForwardBy.hidden=true
            }
            
            if let dateStr =  self.dataDict["eventDate"] as? String {
                
                let dayTH = HelpingClass.convertDateFormat("dd/MM/yyyy", desireFormat: "EEE d",  dateStr: dateStr)
                
                let date = HelpingClass.convertDateFormat("dd/MM/yyyy", desireFormat: " MMM yy",  dateStr: dateStr)
                
                let eventDate = dayTH + self.daySuffix(from:df.dateFromString(dateStr)! ) + date
                
                cell.lblDate.text = eventDate
                
                if let eventStartTime =  self.dataDict["eventStartTime"] as? String {
                    cell.lblDate.text = eventDate + "  " + eventStartTime
                }
            }
            
            if   self.dataDict["isrecur"] as? Bool == true {
                
                cell.img_recurance.hidden = false
            }else{
                cell.img_recurance.hidden = true
            }
            
           // cell.lblTime.text=self.dataDict["eventTime"] as? String
            /* ... */
            return cell
        case (1):
            let cell = tableView.dequeueReusableCellWithIdentifier(kCustomCellID1, forIndexPath: indexPath) as UITableViewCell
            cell.selectionStyle = .None

            let lblDesc = cell.contentView.viewWithTag(111) as! UILabel
            lblDesc.text = self.dataDict["desc"] as? String
            /* ... */
            return cell
        case (2):
            let cell = tableView.dequeueReusableCellWithIdentifier(kCustomCellID2, forIndexPath: indexPath) as UITableViewCell
            cell.selectionStyle = .None

            let btnAttachment = cell.contentView.viewWithTag(111) as! UIButton
            AppHelper.setBorderOnView(btnAttachment)
            btnAttachment.addTarget(self, action: #selector(btnAttachmentClick(_:)), forControlEvents: .TouchUpInside)

            let dataArr = self.dataDict["links"] as! [AnyObject]
            btnAttachment.setTitle(dataArr[indexPath.row]["title"] as? String, forState: UIControlState.Normal)
            /* ... */
            return cell
        default: //case (2)
            let cell = tableView.dequeueReusableCellWithIdentifier(kCustomCellID3, forIndexPath: indexPath) as! MembersCollectionCell
            cell.selectionStyle = .None
            let seeAll = cell.contentView.viewWithTag(555) as! UIButton
            seeAll.addTarget(self, action: #selector(seeAllContacts(_:)), forControlEvents: .TouchUpInside)
            cell.backgroundColor = UIColor.clearColor()
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            /* ... */
            return cell
        }
    }
    
//MARK:- Button action
    func seeAllContacts(sender : UIButton){
        
        let dataArr = self.arrangeMembers()
        let memberContactListVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("MemberContactListVC") as! MemberContactListVC
        
        memberContactListVC.isFromMeetUp = true
        memberContactListVC.membersArr = dataArr
        self.navigationController?.pushViewController(memberContactListVC, animated: true)
        
        
    }
    
    
    func btnAttachmentClick(sender: UIButton)  {
        print_debug(sender)
        //sender.selected = !sender.selected
        let point = self.tableMeetUpDetails.convertPoint(CGPoint.zero, fromView: sender)
        guard let indexPath = self.tableMeetUpDetails.indexPathForRowAtPoint(point) else {
            fatalError("can't find point in tableView")
        }
        
        let dataArr = self.dataDict["links"] as! [AnyObject]
        
//        var url : String!
//        
//        if((dataArr[indexPath.row]["url"] as! String).hasPrefix("http://") || (dataArr[indexPath.row]["url"] as! String).hasPrefix("https://")){
//            
//            url = dataArr[indexPath.row]["url"] as! String
//        }
//        else
//        {
//            url = "http://" + (dataArr[indexPath.row]["url"] as! String)
//        }
//        
//        UIApplication.sharedApplication().openURL(NSURL(string: url)!)

        
        var url : String!
        
        let WebVC:WebViewVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("WebViewVC") as! WebViewVC
        WebVC.title =  self.dataDict["title"] as? String
        url = dataArr[indexPath.row]["url"] as! String
        if url != nil {
            WebVC.urlStr = url!
            self.navigationController?.pushViewController(WebVC, animated: true)
        }
        
        
    }
    
    func canOpenURL(string: String?) -> Bool {
        guard let urlString = string else {return false}
        guard let url = NSURL(string: urlString) else {return false}
        if !UIApplication.sharedApplication().canOpenURL(url) {return false}
        
        //otherwise regex will validate
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluateWithObject(string)
    }
    
    func btnLikeClick(sender: UIButton)  {
        print_debug(sender)
        
        if let groupID = self.dataDict["_id"] as? String {
            
            sender.selected = !sender.selected
            var dict = Dictionary<String,AnyObject>()
            if(self.screenName == "MEET UPS") {
                dict["type"]="meetup"
            }
            else {
                dict["type"]="webinvite"
            }
            dict["typeId"] = groupID
            dict["likeStatus"] = sender.selected
            dict["userId"] = ChatHelper.userDefaultForKey("userId")
            ChatListner .getChatListnerObj().socket.emit("likeMeetup_Invite", dict)
            //self.listenerUpdateMeetUpOrWebInvite()
        }
    }
    
    func btnForwardClick(sender: UIButton)  {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:NOTIFICATION_GET_CONTACT_CLICKED, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(forwardMeetUpOrInvite(_:)), name:NOTIFICATION_GET_CONTACT_CLICKED, object: nil)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let friendListObj: AllContactsVC = storyBoard.instantiateViewControllerWithIdentifier("AllContactsVC") as! AllContactsVC
        self.navigationController?.pushViewController(friendListObj, animated: true)
        
    }
    
    func forwardMeetUpOrInvite(notification: NSNotification) {
        
        if let memberID = notification.userInfo?["_id"] as? String {
            if let groupID = self.dataDict["_id"] as? String {
                var dict = Dictionary<String,AnyObject>()
                if(self.screenName == "MEET UPS") {
                    dict["type"]="meetup"
                }
                else {
                    dict["type"]="webinvite"
                }
                dict["typeId"] = groupID
                dict["forwadedBy"] = ChatHelper.userDefaultForKey("userId")
                dict["userId"] = memberID
                ChatListner .getChatListnerObj().socket.emit("forwardMeetup_Invite", dict)
                
                //self.listenerUpdateMeetUpOrWebInvite()
            }
        }
    }
    
    func btnLinkClick(sender: UIButton)  {
        print_debug(sender)
        
        if let webLink = self.dataDict["webLink"] as? String {
            let WebVC:WebViewVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("WebViewVC") as! WebViewVC
            WebVC.title =  self.dataDict["title"] as? String
            WebVC.urlStr = webLink
            self.navigationController?.pushViewController(WebVC, animated: true)
        }
    }
    
    func btnDialUpClick(sender: UIButton)  {
        print_debug(sender)

        if let mobilePhone = self.dataDict["dialInNumber"] as? String {
            if let phoneCallURL:NSURL = NSURL(string: "tel://\(mobilePhone)") {
                let application:UIApplication = UIApplication.sharedApplication()
                if (application.canOpenURL(phoneCallURL)) {
                    application.openURL(phoneCallURL)
                }
            }
        }
        
    }
    
    func fetchDataMeetUpOrWebInviye() {
        if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {
            var dict = Dictionary<String,AnyObject>()
            if(self.screenName == "MEET UPS") {
                dict["type"]="meetup"
            }
            else {
                dict["type"]="webinvite"
            }
            dict["typeId"] = meetUpID
            dict["userId"] = ChatHelper.userDefaultForKey("userId")
            ChatListner .getChatListnerObj().socket.emit("detailMeetup_Invite", dict)
        }
        else
        {
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Internet Connection not available.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
        }
    }
    
    //Mark- update Meetups/Invites
    func listenerUpdateMeetUpOrWebInvite() {
        
        if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {
            
            ChatListner .getChatListnerObj().socket.off("getDetail_Meetup_Invite")
            ChatListner .getChatListnerObj().socket.on("getDetail_Meetup_Invite") {data, ack in
                
                print_debug("value error_code\(data[0]["status"] as! String))")
                
                let errorCode = (data[0]["status"] as? String) ?? "1"
                
                if errorCode == "0"
                {
                    guard let dictData = data[0] as? Dictionary<String, AnyObject> else
                    {
                        return
                    }
                    
                    self.dataDict=dictData["result"] as! Dictionary<String, AnyObject>
                    print_debug("arrayList \(self.dataDict)")
                    self.updateCurrentView()
                }
                else
                {
                    AppHelper.showAlertWithTitle(data[0]["error"] as! String, message: "", tag: 0, delegate: nil, cancelButton: "Ok", otherButton: nil)
                    
                }
            }
            
        }else
        {
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Internet Connection not available.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
        }
    }
    
    func updateCurrentView() {
        
        self.screenTitle.text = self.dataDict["title"] as? String
       // self.btnLink.setTitle((self.dataDict["webLink"] as! String), forState: .Normal)
        //self.btnDialUp.setTitle((self.dataDict["dialInNumber"] as! String), forState: .Normal)
        //let dict = self.dataDict["createdBy"] as! [String:]
        if let imageUrlStr = self.dataDict["imgUrl"] as? String {
            let image_url = NSURL(string: imageUrlStr)
            if (image_url != nil) {
                let placeholder = UIImage(named: "no_photo")
                self.imgMeetUp.sd_setImageWithURL(image_url, placeholderImage: placeholder)
            }
        }
        
        if let groupIdStr = self.dataDict["groupId"] as? String {
            if (!(groupIdStr == "")) {
                self.meetUpGroupID = groupIdStr
            }
        }
        
        if(self.screenName ==  "MEET UPS")
        {
            self.lblLike.text = self.dataDict["address"] as? String
            self.imgLike.image = UIImage(named: "location_pin_white")
            self.btnForward.setTitle("Forward", forState: .Normal)
            self.headerView.frame.size.height = 260-40
            self.dialUpView.hidden = true
            
            self.btnSure.setTitle("Sure!", forState: UIControlState.Normal)
            self.btnSorry.setTitle("Sorry!", forState: UIControlState.Normal)
            self.btnLike.hidden=true
            let addressGesture =  UITapGestureRecognizer(target: self, action: #selector(MeetUpDetailsVC.addressGesture(_:)))
            self.lblLike.addGestureRecognizer(addressGesture)
            self.lblLike.userInteractionEnabled = true
            
        }
        else
        {
            //"\(memberArr.count) Going"
            self.lblLike.text="\((self.dataDict["likes"] as! [AnyObject]).count) Likes"
            self.imgLike.image = UIImage(named: "like")
            self.btnForward.setTitle("Forward", forState: .Normal)
            self.headerView.frame.size.height = 260
            
            self.btnSure.setTitle("Accept", forState: UIControlState.Normal)
            self.btnSorry.setTitle("Decline", forState: UIControlState.Normal)
            self.btnLike.hidden=false
            
            if let arrLikes = self.dataDict["likes"] as? [String] {
                if(arrLikes.contains(ChatHelper.userDefaultForKey(_ID))) {
                    self.btnLike.selected = true
                }
            }
            
        }
        
        
        let arrMembers = self.dataDict["members"] as! [AnyObject]
        
        //Check status if member accepted or rejacted--
        for item in arrMembers {
            
            var membDict = item as! [String : AnyObject]
            let status = membDict["status"] as! String
            
            
            if(membDict["memberId"] as! String == ChatHelper.userDefaultForKey("userId"))
            {
                
                if(status == "1")
                {
                    self.btnSure.selected=true
                    self.imgSure.hidden=false
                    self.btnSure.layer.borderColor=UIColor(red: 1/255.0, green: 174/255.0, blue: 240/255.0, alpha: 1.0).CGColor
                    
                    //cell.btnDecline.hidden=true
                }
                else if(status == "2")
                {
                    self.btnSorry.selected=true
                    self.imgSorry.hidden=false
                    self.btnSorry.layer.borderColor=UIColor(red: 1/255.0, green: 174/255.0, blue: 240/255.0, alpha: 1.0).CGColor
                    
                    //cell.btnAccept.hidden=true
                }
                
                if(!(membDict["forwardedBy"] as! String == ""))
                {
                    self.fwBy = membDict["forwardedBy"] as! String
                }
                else
                {
                    self.fwBy=""
                }
                
                
            }
            
        }
        
        
        if((self.dataDict["createdBy"]!["_id"] as! String) == ChatHelper.userDefaultForKey("userId"))
        {
            self.btnSure.enabled=false
            //self.imgSure.hidden=true
            self.btnSorry.enabled=false
            //self.imgSorry.hidden=true
            self.btnForward.hidden=true
            
            self.btnSure.setTitleColor(.lightGrayColor(), forState: .Normal)
            self.btnSorry.setTitleColor(.lightGrayColor(), forState: .Normal)
        }
        
        if(!(self.dataDict["isAllow"] as! Bool))
        {
            self.btnForward.hidden=true
            self.layout_forwartBtnWidth.constant = 0
        }
        self.showHideChatBtn()

        self.tableMeetUpDetails.reloadData()
        
    }

    // MARK: - gesture tapped
    
    func addressGesture(gestureRecognizer: UITapGestureRecognizer) -> Void {
        print_debug("Address Gesture.....")
        let VC = AppHelper.getSecondStoryBoard().instantiateViewControllerWithIdentifier("MapVC") as! MapVC
        VC.address = self.lblLike.text
        
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func sectionHeaderTapped(gestureRecognizer: UITapGestureRecognizer) {
        
        let indexPath = NSIndexPath(forRow: 0, inSection: gestureRecognizer.view!.tag)
        if indexPath.section != 0 {
            var collapsed = Bool(arrayForBool[indexPath.section] as NSNumber)
            collapsed = !collapsed
            arrayForBool.insert(Int(collapsed), atIndex: indexPath.section)
            arrayForBool.removeLast()
            //reload specific section animated
            let range = NSMakeRange(indexPath.section, 1)
            let sectionToReload = NSIndexSet(indexesInRange: range)
            
            let indexToReload = NSIndexPath(forRow: 0, inSection: indexPath.section)
            //self.tableMeetUpDetails.reloadRowsAtIndexPaths([indexToReload], withRowAnimation: .Automatic)
            //self.tableMeetUpDetails.reloadSections(sectionToReload, withRowAnimation: .Fade)
            self.tableMeetUpDetails.reloadData()
        }
    }
    
    @IBAction func btnSorryClick(sender: AnyObject) {
       
        btnSure.selected=false
        btnSure.layer.borderColor=UIColor.clearColor().CGColor
       
        imgSure.hidden=true
        imgSorry.hidden=false
       
        btnSorry.selected=true
        btnSorry.layer.borderColor=UIColor(red: 1/255.0, green: 174/255.0, blue: 240/255.0, alpha: 1.0).CGColor
    }
    
    @IBAction func btnSureClick(sender: AnyObject) {
        
        btnSorry.selected=false
        btnSorry.layer.borderColor=UIColor.clearColor().CGColor
       
        imgSure.hidden=false
        imgSorry.hidden=true
      
        btnSure.selected=true
        btnSure.layer.borderColor=UIColor(red: 1/255.0, green: 174/255.0, blue: 240/255.0, alpha: 1.0).CGColor
    }
    
    func btnAcceptClick(sender: UIButton)  {
        
        if let groupID = self.dataDict["_id"] as? String {

            self.btnChat.hidden = false
            var dict = Dictionary<String,AnyObject>()
            
            if(self.screenName == "MEET UPS") {
                dict["type"]="meetup"
            }
            else {
                dict["type"]="webinvite"
            }
            dict["typeId"] = groupID
            dict["status"] = "1"
            dict["userId"] = ChatHelper.userDefaultForKey("userId")
            
            //group info
            var groupDict = Dictionary<String,AnyObject>()
            groupDict["userid"] = self.dataDict["createdBy"]!["_id"] as! String
            groupDict["groupid"] = self.dataDict["groupId"] as! String
            groupDict["groupuserid"] = ChatHelper.userDefaultForKey(_ID)
            groupDict["phoneNumber"] = ChatHelper.userDefaultForKey(cellNum)
            
            dict["groupInfo"] = groupDict
            ChatListner .getChatListnerObj().socket.emit("acceptMeetup_Invite", dict)
        }
    }
    
    func btnDeclineClick(sender: UIButton)  {
        
        if let groupID = self.dataDict["_id"] as? String {
            
            self.btnChat.hidden = true
            var dict = Dictionary<String,AnyObject>()
            
            if(self.screenName == "MEET UPS") {
                dict["type"]="meetup"
            }
            else {
                dict["type"]="webinvite"
            }
            dict["typeId"] = groupID
            dict["status"] = "2"
            dict["userId"] = ChatHelper.userDefaultForKey("userId")
            
            //group info
            var groupDict = Dictionary<String,AnyObject>()
            groupDict["userid"] = self.dataDict["createdBy"]!["_id"] as! String
            groupDict["groupid"] = self.dataDict["groupId"] as! String
            groupDict["groupuserid"] = ChatHelper.userDefaultForKey(_ID)
            groupDict["phoneNumber"] = ChatHelper.userDefaultForKey(cellNum)
            
            dict["groupInfo"] = groupDict
            ChatListner .getChatListnerObj().socket.emit("acceptMeetup_Invite", dict)
        }
        
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        if actionSheet.tag==200
        {
            switch buttonIndex{
            case 0:
                self.goToLinkOrDirectionClick()
                break;
            case 1:
                self.editMeetUpOrInviteClick()
                break;
            case 2:
                self.deleteMeetUpOrInvite()
                break;
            default:
                break;
            }
        }
    }
    
    @IBAction func handleDrag( sender: UIButton, for event: UIEvent) {

        var point = event.allTouches()!.first!.locationInView(self.view)
        if point.y >= 84 && point.y <= (screenHeight - 68) {
            point.x = sender.center.x
            //Always stick to the same x value
            sender.center = point
        }
    }

    @IBAction func btnChatClick(sender: UIButton) {
        
        if(self.meetUpGroupID != nil) {
            
            let strPred:String = "groupId contains[cd] \"\(self.meetUpGroupID)\""
            let instance = DataBaseController.sharedInstance
            let recentObj=instance.fetchDataRecentChatObject("RecentChatList", predicate: strPred) as RecentChatList?
            
            if (recentObj != nil) {
                
                let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let mesagesVC = storyboard.instantiateViewControllerWithIdentifier("ChattingMainVC") as! ChattingMainVC
                
                mesagesVC.isFromClass="df"
                mesagesVC.isFromDeatilScreen = "0"
                mesagesVC.recentChatObj=recentObj
                mesagesVC.manageChatTableH="0"
                mesagesVC.isGroup = "1"
                
                self.navigationController?.pushViewController(mesagesVC, animated: true)
            }
            
        }
    }
    
    func editMeetUpOrInviteClick()
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let createMeetUpVC: CreateMeetUpVC = storyBoard.instantiateViewControllerWithIdentifier("CreateMeetUpVC") as! CreateMeetUpVC
        createMeetUpVC.dataDict = self.dataDict
        
        if(self.screenName == "MEET UPS")
        {
            createMeetUpVC.pushedFrom = "EDITMEETUPS"
        }
        else
        {
            createMeetUpVC.pushedFrom = "EDITWEBINVITES"
        }
        self.navigationController?.pushViewController(createMeetUpVC, animated: true)
        
    }
    
    func editMeetUpOrInvite(notification: NSNotification) {
        
        if let memberID = notification.userInfo?["_id"] as? String {
            
            var dict = Dictionary<String,AnyObject>()
            if(self.screenName == "MEET UPS") {
                dict["type"]="meetup"
            }
            else {
                dict["type"]="webinvite"
            }
            dict["typeId"] = self.dataDict["_id"] as! String
            dict["forwadedBy"] = ChatHelper.userDefaultForKey("userId")
            dict["userId"] = memberID
            ChatListner .getChatListnerObj().socket.emit("forwardMeetup_Invite", dict)
            
            //self.listenerUpdateMeetUpOrWebInvite()
        }
    }
    
    func deleteMeetUpOrInvite() {
      
        let msgTitle: String!
        
        if(self.screenName == "MEET UPS") {
            msgTitle = "You are about to delete the Meet Up you created."
        }
        else {
            msgTitle = "You are about to delete the Web Invite you created."
        }
        
        let alertController = UIAlertController(title: msgTitle, message: "Are you sure you want to go ahead with this action? This cannot be undone. All members will be notified.", preferredStyle: UIAlertControllerStyle.Alert)
        
        let saveAction = UIAlertAction(title: "Yes, Confirm", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            
            var dict = Dictionary<String,AnyObject>()
            if(self.screenName == "MEET UPS") {
                dict["type"]="meetup"
            }
            else {
                dict["type"]="webinvite"
            }
            dict["typeId"] = self.dataDict["_id"] as! String
            dict["userId"] = ChatHelper.userDefaultForKey("userId")
            ChatListner .getChatListnerObj().socket.emit("deleteMeetup_Invite", dict)
            
            self.navigationController?.popViewControllerAnimated(true)

        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func goToLinkOrDirectionClick() {
        
        if(self.screenName == "MEET UPS") {
            //http://www.google.com/maps/place/49.46800006494457,17.11514008755796/@49.46800006494457,17.11514008755796,17z
            
            //https://www.google.com/maps/preview/@<latitude>,<longitude>,<zoom level>z
            //https://www.google.com/maps/preview/@-15.623037,18.388672,8z
            
            
           // let userDefaultLoc = AppHelper.userDefaultsForKey("location") as! [Double]
            let userDefaultLoc = AppHelper.userDefaultsForKey("location") as! [Double]
            let lat = userDefaultLoc[1]
            let long = userDefaultLoc[0]
            
            
            
            let latlong = self.dataDict["latlong"] as! String
            
            let arrLatLong = latlong.componentsSeparatedByString(",") 
            //let start = CLLocationCoordinate2D(latitude: 34.621654, longitude: -118.41397)
            let start = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let end = CLLocationCoordinate2D(latitude: Double(arrLatLong[0])!, longitude: Double(arrLatLong[1])!)
            
            let googleMapsURLString = "http://maps.google.com/?saddr=\(start.latitude),\(start.longitude)&daddr=\(end.latitude),\(end.longitude)"
            
            let WebVC:WebViewVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("WebViewVC") as! WebViewVC
            WebVC.title =  self.dataDict["title"] as? String
            
            if googleMapsURLString != "" {
                WebVC.urlStr = googleMapsURLString
                self.navigationController?.pushViewController(WebVC, animated: true)
            }
            
           // UIApplication.sharedApplication().openURL(NSURL(string: googleMapsURLString)!)
            
        }
            
            
            
        else {
            
            var url : String!
            
            if((self.dataDict["webLink"] as! String).hasPrefix("http://") || (self.dataDict["webLink"] as! String).hasPrefix("https://")){
                
                url = self.dataDict["webLink"] as! String
            }
            else
            {
                url = "http://" + (self.dataDict["webLink"] as! String)
            }
            
            
            
            let WebVC:WebViewVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("WebViewVC") as! WebViewVC
            WebVC.title =  self.dataDict["title"] as? String
           
            if url != nil {
                WebVC.urlStr = url!
                self.navigationController?.pushViewController(WebVC, animated: true)
            }
            
            
           // UIApplication.sharedApplication().openURL(NSURL(string: url)!)

        }
        
    }
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnMoreClick(sender: AnyObject) {
        
        if let createdBy = self.dataDict["createdBy"] as? [String : String] {
            
            let buttonOneTitle : String!
            let buttonTwoTitle : String!
            let buttonThreeTitle : String!
            
            if(self.screenName == "MEET UPS") {
                buttonOneTitle = "Get Directions"
                buttonTwoTitle = "Edit Meet Up"
                buttonThreeTitle = "Cancel Meet Up"
            } else {
                buttonOneTitle = "Go To Link"
                buttonTwoTitle = "Edit Web Invite"
                buttonThreeTitle = "Cancel Web Invite"
            }
            
            if(IS_IOS_7)
            {
                
                let actionSheet : UIActionSheet!
                
                if(createdBy["_id"] == ChatHelper.userDefaultForKey("userId"))
                {
                    actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle:"Cancel", otherButtonTitles: buttonOneTitle,buttonTwoTitle,buttonThreeTitle)
                }
                else
                {
                    actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle:"Cancel", otherButtonTitles: buttonOneTitle)
                }
                
                actionSheet.tag=300
                actionSheet.showFromTabBar((self.navigationController?.tabBarController?.tabBar)!)
            }
            else
            {
                let actionSheet =  UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
                actionSheet.addAction(UIAlertAction(title: buttonOneTitle, style: UIAlertActionStyle.Default, handler:
                    {(ACTION :UIAlertAction!)in
                        self.goToLinkOrDirectionClick()
                }))
                
                
                if(createdBy["_id"] == ChatHelper.userDefaultForKey("userId"))
                {
                    actionSheet.addAction(UIAlertAction(title: buttonTwoTitle, style: UIAlertActionStyle.Default, handler:
                        { (ACTION :UIAlertAction!)in
                            
                            self.editMeetUpOrInviteClick()
                    }))
                    
                    actionSheet.addAction(UIAlertAction(title: buttonThreeTitle, style: UIAlertActionStyle.Default, handler:
                        { (ACTION :UIAlertAction!)in
                            
                            self.deleteMeetUpOrInvite()
                    }))
                    
                }
                
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(actionSheet, animated: true, completion: nil)
            }
        }
    }

}

extension MeetUpDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let dataArr = self.dataDict["members"] as! [AnyObject]
        return dataArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemberCell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.clearColor()

        
        let imgProfile = cell.contentView.viewWithTag(111) as! UIImageView
        let imgStatus = cell.contentView.viewWithTag(222) as! UIImageView
        let lblName = cell.contentView.viewWithTag(333) as! UILabel
        
        imgProfile.layer.borderWidth = 1.0
        imgProfile.contentMode = .ScaleAspectFill
        imgProfile.backgroundColor = UIColor.whiteColor()
        imgProfile.layer.masksToBounds = false
        imgProfile.layer.borderColor = UIColor.lightGrayColor().CGColor
        imgProfile.layer.cornerRadius = 23
        imgProfile.clipsToBounds = true

        
        let dataArr = self.arrangeMembers()
        
        let dataDict = dataArr[indexPath.row] as! [String : AnyObject]


        if let imageUrlStr = dataDict["imgUrl"] as? String {
            let image_url = NSURL(string: imageUrlStr )
            if (image_url != nil) {
                let placeholder = UIImage(named: "no_photo")
                imgProfile.sd_setImageWithURL(image_url, placeholderImage: placeholder)
                lblName.text = dataDict["name"] as? String

            }
        }
        
        if ((dataDict["status"] as! String) == "1") {
            imgStatus.image=UIImage(named: "invite_accepted_check")
        }
        else
        {
            imgStatus.image=UIImage(named: "invite_unaccepted_uncheck")

        }
        
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print_debug("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        
        let dataArr = self.arrangeMembers()
        
        let dataDict = dataArr[indexPath.row] as! [String : AnyObject]
        
        
        //goto profile
        let vc = AppHelper.getProfileStoryBoard().instantiateViewControllerWithIdentifier("ProfileContainerVC") as! ProfileContainerVC
        
         vc.viewerUserID = dataDict["memberId"] as? String
        
        
        
        self.navigationController?.pushViewController(vc , animated: true)
        self.navigationController?.navigationBarHidden = true
        
    }
     // show or hide chat icon by badru
    func showHideChatBtn() -> Void {
        //meetup is canceled
        if  self.dataDict["isDeleted"] as! Bool  {
            btnChat.hidden = true
            return
        }
        
        let dataArr = self.dataDict["members"] as! [AnyObject]
        
        
        for dict in dataArr {
            
            if ((dict["memberId"] as! String) == ChatHelper.userDefaultForKey("userId") &&  ((dict["status"] as! String) == "1")) {
                
                btnChat.hidden = false
                break
            }
            else
            {
                btnChat.hidden = true
                
            }
            
        }
        
    }
    
    func arrangeMembers() -> [AnyObject] {
        
        let adminId = self.dataDict["createdBy"]!["_id"] as! String
        
        let arr = self.dataDict["members"] as! [AnyObject]
        
        var  acceptedArr:[AnyObject] = [AnyObject]()
        var  notAcceptedArr:[AnyObject] = [AnyObject]()
        
        for dict in arr {
            
            if adminId == dict["memberId"] as! String {
                acceptedArr.insert(dict, atIndex: 0)
            }else if ((dict["status"] as! String) == "1") {
                acceptedArr.append(dict)
            }else{
                notAcceptedArr.append(dict)
            }
        }
        
        let finalArr = acceptedArr + notAcceptedArr        
        return finalArr
    }
}

