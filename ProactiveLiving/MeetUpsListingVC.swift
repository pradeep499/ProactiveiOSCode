
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Internet Connection not available.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
        }
    }
    
    //mark- UITableview Delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("CellMeetUps", forIndexPath: indexPath) as UITableViewCell
        cell.selectionStyle = .None
        
        let eventImage = cell.contentView.viewWithTag(11) as! UIImageView
        let eventName = cell.contentView.viewWithTag(12) as! UILabel
        let statusBG = cell.contentView.viewWithTag(13) as! UIImageView
        let eventStatus = cell.contentView.viewWithTag(14) as! UILabel
        let eventTypeBy = cell.contentView.viewWithTag(15) as! UILabel
        let eventDesc = cell.contentView.viewWithTag(16) as! UILabel
        let imgDate = cell.contentView.viewWithTag(17) as! UIImageView
        let lblDate = cell.contentView.viewWithTag(18) as! UILabel
        let imglink = cell.contentView.viewWithTag(19) as! UIImageView
        let lblLink = cell.contentView.viewWithTag(20) as! UILabel
        let imgAddress = cell.contentView.viewWithTag(21) as! UIImageView
        let lblAddress = cell.contentView.viewWithTag(22) as! UILabel
        let imgPhone = cell.contentView.viewWithTag(23) as! UIImageView
        let lblPhone = cell.contentView.viewWithTag(24) as! UILabel

        eventName.text = self.arrData[indexPath.row]["title"] as? String
        statusBG.image = UIImage(named:"")
        eventStatus.text = self.arrData[indexPath.row]["isEdited"] as? String
        eventTypeBy.text = self.arrData[indexPath.row]["for"] as? String
        eventDesc.text = self.arrData[indexPath.row]["desc"] as? String
        lblDate.text = self.arrData[indexPath.row]["createdDate"] as? String
        
        lblLink.text = (self.arrData[indexPath.row]["links"] as! Array).joinWithSeparator(",")
        lblAddress.text = self.arrData[indexPath.row]["address"] as? String
        lblPhone.text = self.arrData[indexPath.row]["dialInNumber"] as? String

        if let imageUrlStr = self.arrData[indexPath.row]["imgUrl"] as? String {
            
            let image_url = NSURL(string: imageUrlStr)
            if (image_url != nil) {
                let url_request = NSURLRequest(URL: image_url!)
                let placeholder = UIImage(named: "no_photo")
                eventImage.setImageWithURLRequest(url_request, placeholderImage: placeholder, success: { [weak cell] (request:NSURLRequest!,response:NSHTTPURLResponse!, image:UIImage!) -> Void in
                    print(cell)
                    }, failure: { [weak cell]
                        (request:NSURLRequest!,response:NSHTTPURLResponse!, error:NSError!) -> Void in
                        print(cell)
                    })
            }
        }
        
        let acceptButton = cell.contentView.viewWithTag(25) as! UIButton
        let declineButton = cell.contentView.viewWithTag(26) as! UIButton
        
        acceptButton.addTarget(self, action: #selector(btnAcceptClick(_:)), forControlEvents: .TouchUpInside)
        declineButton.addTarget(self, action: #selector(btnDeclineClick(_:)), forControlEvents: .TouchUpInside)
        AppHelper.setBorderOnView(acceptButton)
        AppHelper.setBorderOnView(declineButton)

        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func btnAcceptClick(sender: AnyObject)  {
        print(sender)
    }
    
    func btnDeclineClick(sender: AnyObject)  {
        print(sender)
    }

    
}
