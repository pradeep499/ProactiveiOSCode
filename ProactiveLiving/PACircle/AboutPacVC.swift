//
//  AboutPacVC.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 21/02/17.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit

class AboutPacVC: UIViewController, UIAlertViewDelegate {

    var collapsed = true
    var dataDict = [String : AnyObject]()
    var pacID = String()
    var memberStatus = Bool()
    var adminStatus = Bool()
    var creatorStatus = Bool()
    var privateStatus = Bool()
    var requestStatus = Bool()
    var responseDict = [NSObject : AnyObject]()
    var arrPACMembers = [[String : AnyObject]]()
    var isFromMoreDetail = false
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var btnInvite: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageHeader: UIImageView!
    
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName:"PACMenbersCell", bundle: nil), forCellReuseIdentifier: "PACMenbersCell")
        tableView.separatorStyle = .None
        // Do any additional setup after loading the view.
        btnLike.addTarget(self, action: #selector(btnLikeClick(_:)), forControlEvents: .TouchUpInside)
        btnLike.setImage(UIImage(named: "like_empty"), forState: .Normal)
        btnLike.setImage(UIImage(named: "like_filled"), forState: .Selected)
        
        btnInvite.addTarget(self, action: #selector(btnInviteClick(_:)), forControlEvents: .TouchUpInside)
        btnInvite.setCornerRadiusWithBorderWidthAndColor(3.0, borderWidth: 2.0, borderColor: UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0))
        btnInvite.hidden = true

        self.fetchDataForAboutSection()
        
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:NOTIFICATION_FROM_MOREDETAILVC , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AboutPacVC.isFromMoredetailVC), name: NOTIFICATION_FROM_MOREDETAILVC, object: nil)
        
        

        
    }

    override func viewWillAppear(animated: Bool) {
        if isFromMoreDetail == false {
            self.fetchDataForAboutSection()
            // NSNotificationCenter.defaultCenter().removeObserver(self, name: NOTIFICATION_FROM_MOREDETAILVC, object: nil)
        }

        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Method to check if redirected from MoreDetailVC
    func isFromMoredetailVC(){
        
        self.isFromMoreDetail = true
        
        
    }
    
    //MARK:- fetchDataForAboutSection
    
    func fetchDataForAboutSection() {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            parameters["pacId"] = self.pacID

            //call global web service class latest
            Services.postRequest(ServiceGetPACDetails, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    //dissmiss indicator
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        print("ABOUT### \(responseDict)")
                        
                        self.responseDict = responseDict
                        
                        self.dataDict = (responseDict["result"]!["pac"] as! [String : AnyObject])
                        self.btnLike.selected = responseDict["result"]!["likeStatus"] as! Bool
                        self.memberStatus = responseDict["result"]!["memberStatus"] as! Bool
                        self.adminStatus = responseDict["result"]!["adminStatus"] as! Bool
                        self.creatorStatus = responseDict["result"]!["creatorStatus"] as! Bool
                        self.requestStatus = responseDict["result"]!["requestStatus"] as! Bool

                        if let settingsDict = self.dataDict["settings"] {
                            self.privateStatus = settingsDict["private"] as! Bool
                        }

                        self.imageHeader.sd_setImageWithURL(NSURL.init(string:self.dataDict["imgUrl"] as! String), placeholderImage: UIImage(named: "pac_listing_no_preview"))
                        
                        if((self.dataDict["likes"] as! [String]).count == 1) {
                            self.lblLikes.text = "\((self.dataDict["likes"] as! [String]).count) Like"
                        }
                        else {
                            self.lblLikes.text = "\((self.dataDict["likes"] as! [String]).count) Likes"
                        }
                        
                        if(responseDict["result"]!["memberStatus"] as! Bool == false) {
                            
                            if(self.privateStatus == true) {
                                if(self.requestStatus == true) {
                                    self.btnInvite.hidden = false
                                    self.btnInvite.enabled = false
                                    self.btnInvite.setTitle("Pending", forState: .Normal)
                                }
                                else {
                                    self.btnInvite.hidden = false
                                    self.btnInvite.enabled = true
                                    self.btnInvite.setTitle("Join", forState: .Normal)
                                }
                            }
                            else {
                                self.btnInvite.hidden = false
                                self.btnInvite.enabled = true
                                self.btnInvite.setTitle("Join", forState: .Normal)
                            }
                        }
                        else {
                            
                            self.btnInvite.hidden = true
                            if(responseDict["result"]!["adminStatus"] as! Bool == true || responseDict["result"]!["creatorStatus"] as! Bool == true) {
                                self.btnInvite.hidden = false
                                self.btnInvite.setTitle("Invite", forState: .Normal)
                            }
                        }
                        
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
    
    //MARK: - UIScrollView delegate to Animate Table Header
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let y: CGFloat = -scrollView.contentOffset.y
        if y > 0 {
            self.imageHeader.frame = CGRectMake(0, scrollView.contentOffset.y, screenWidth + y, 220 + y)
            self.imageHeader.center = CGPointMake(self.tableView.center.x, self.imageHeader.center.y)
        }
    }

    
    //MARK:- Actions
    
    func btnLikeClick(sender: UIButton) {
        sender.selected = !sender.selected
        self.likePACServiceCall()
    }
    
    func btnInviteClick(sender: UIButton)  {
        
        if(sender.titleLabel?.text == "Invite") {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:NOTIFICATION_INVITE_CONTACT_PAC, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(inviteFriendCall(_:)), name:NOTIFICATION_INVITE_CONTACT_PAC, object: nil)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let friendListObj: AllContactsVC = storyBoard.instantiateViewControllerWithIdentifier("AllContactsVC") as! AllContactsVC
        self.navigationController?.pushViewController(friendListObj, animated: true)
        }
        else if(sender.titleLabel?.text == "Join"){
            let arrIDs = [AppHelper.userDefaultsForKey(_ID) as! String]
            self.inviteOrJoinServiceCall(arrIDs, callType: "Join")
        }
        
    }
    
    func inviteFriendCall(notification: NSNotification) {
        
        print(notification.userInfo)

        if let arrIDs = notification.userInfo?["userIDs"] as? [String] {
            self.inviteOrJoinServiceCall(arrIDs, callType: "Invite")
        }
    }

    // MARK:- Join/Invite Service Call
    func inviteOrJoinServiceCall(arrIDs : [String], callType : String) {
        
        if AppDelegate.checkInternetConnection() {
            
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            parameters["pacId"] = self.pacID
            parameters["users"] = arrIDs
            parameters["status"] = self.privateStatus
            
            //call global web service
            Services.postRequest(ServiceAddMemberToPac, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        print(responseDict)
                        if(callType == "Invite") {
                            AppHelper.showAlertWithTitle(AppName, message: responseDict["result"] as! String, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                        }
                        else if(callType == "Join"){
                            if(self.privateStatus == true) {
                                let title = "Your request to join has been sent."
                                let detail = "If approved, show your membership in this PAC on your Profile screen?"
                                AppHelper.showAlertWithTitle(title, message: detail, tag: 100, delegate: self, cancelButton: yes, otherButton: no)
                            }
                            else {
                                let title = "Congrats on Joining!"
                                let detail = "Show your membership in this PAC on your Profile screen?"
                                AppHelper.showAlertWithTitle(title, message: detail, tag: 100, delegate: self, cancelButton: yes, otherButton: no)
                            }

                        }
                        self.fetchDataForAboutSection()
                    } else {
                        
                        AppHelper.showAlertWithTitle(AppName, message: responseDict["errorMsg"] as! String, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    }
                    
                } else if (status == "Error"){
                    
                    AppHelper.showAlertWithTitle(AppName, message: serviceError, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    
                }
            })
            
        }
        else {
            //show internet not available
            AppHelper.showAlertWithTitle(netError, message: netErrorMessage, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
        }
        
    }
    
    //MARK:- UIAlert delegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){

        if(alertView.tag == 100)
        {
            switch buttonIndex{
                
            case 0:
                self.ServiceCallPacActionProfile(true)
                break;
            case 1:
                break;
            default:
                break;
            }
        }
        
    }
    
    //MARK:- servce call for PAC action Profile
    func ServiceCallPacActionProfile(status : Bool) {
        
        if AppDelegate.checkInternetConnection() {
            
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            parameters["pacId"] = self.pacID
            parameters["status"] = status
            
            //call global web service
            Services.postRequest(ServicePACActionProfile, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        print(responseDict)
                        NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_REFRESH_PAC_CONTAINER, object: self)
                    } else {
                        AppHelper.showAlertWithTitle(AppName, message: responseDict["errorMsg"] as! String, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    }
                    
                } else if (status == "Error"){
                    
                    AppHelper.showAlertWithTitle(AppName, message: serviceError, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    
                }
            })
        }
        else {
            //show internet not available
            AppHelper.showAlertWithTitle(netError, message: netErrorMessage, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
        }
        
    }

    
    //MARK:- Service call for Like/Unlike PAC
    func likePACServiceCall() {
        
        if AppDelegate.checkInternetConnection() {
            
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            parameters["pacId"] = self.pacID
            parameters["likeStatus"] = self.btnLike.selected
            
            //call global web service
            Services.postRequest(ServiceLikePAC, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        print(responseDict)
                        var resultDict = responseDict["result"] as! [String : AnyObject]
                        if((resultDict["likes"] as! [String]).count == 1) {
                            self.lblLikes.text = "\((resultDict["likes"] as! [String]).count) Like"
                        }
                        else {
                            self.lblLikes.text = "\((resultDict["likes"] as! [String]).count) Likes"
                        }
                    } else {
                        
                        AppHelper.showAlertWithTitle(AppName, message: responseDict["errorMsg"] as! String, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    }
                    
                } else if (status == "Error"){
                    
                    AppHelper.showAlertWithTitle(AppName, message: serviceError, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    
                }
            })
            
        }
        else {
            //show internet not available
            AppHelper.showAlertWithTitle(netError, message: netErrorMessage, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
        }
        
    }
    
    
    //MARK:- See All Button Action
    func  seeAllContacts(sender : AnyObject) {
        
    
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath =  self.tableView.indexPathForRowAtPoint(buttonPosition)
       
        if indexPath?.row == 1 { // Admins
          
            
            let dataArr = self.dataDict["admins"] as! [[String : AnyObject]]
            let memberContactListVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("MemberContactListVC") as! MemberContactListVC
            memberContactListVC.contactArr = dataArr
            self.navigationController?.pushViewController(memberContactListVC, animated: true)
            
        }
        else {  // Members
            
            let dataArr = self.dataDict["members"] as! [[String : AnyObject]]
            let memberContactListVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("MemberContactListVC") as! MemberContactListVC
            memberContactListVC.contactArr = dataArr
            self.navigationController?.pushViewController(memberContactListVC, animated: true)
 
            
        }
      
    }
    
}

extension AboutPacVC: UITableViewDataSource{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat    {
        
        if(indexPath.section == 0) {
            if(collapsed) {
                return 123
            }
            else {
                return 350
            }
        }
        else if(indexPath.section == 1) {
            return 55
        }
        else if(indexPath.section == 2) {
            //return 55
            return 0
        }
        else if(indexPath.section == 3) {
            switch indexPath.row {
            
            case 0:
                return 110
            case 1:
                let arrAdmins = self.dataDict["admins"] as! [[String : AnyObject]]
                if(arrAdmins.count>0) {
                    return 110
                }
                else {
                    return 0
                }
            case 2:
                    return 110
            case 3:
                return 91
            default:
                return 0
            }
        }
        else {
            return 0
        }
        /*
        switch indexPath.row {
        case 0:
            if(collapsed) {
                return 123
            }
            else {
                return 350
            }
        case 1,2:
            return 55
        case 3,4,5:
            return 110
        case 6:
            return 91
        default:
            return 0
        } */
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if(self.dataDict.count > 0) {
            return 4
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        var numOfRows: Int = 0
        
        if(section == 0) {
            
            numOfRows = 1

        }
        else if(section == 1) {
            
            if self.memberStatus == false {
                
                if let settingsDict = self.dataDict["settings"] {
                    
                    let isPrivate = settingsDict["private"] as! Bool
                    
                    if(!isPrivate) {
                        
                        let attachmentDict = self.dataDict["attachements"]
                        let dictLinks = attachmentDict!["links"] as! [[String : AnyObject]]
                        numOfRows = dictLinks.count
                    }
                    else
                    {
                        numOfRows = 0
                        
                    }
                }
            }
            else {
                let attachmentDict = self.dataDict["attachements"]
                let dictLinks = attachmentDict!["links"] as! [[String : AnyObject]]
                numOfRows = dictLinks.count
            }


        }
        else if(section == 2) {
            
            //let attachmentDict = self.dataDict["attachements"]
            //let dictLinks = attachmentDict!["files"] as! [String : AnyObject]
            numOfRows = 0
            
        }
        else if(section == 3) {
            
            if self.memberStatus == false {
                
                if let settingsDict = self.dataDict["settings"] {
                    
                    let isPrivate = settingsDict["private"] as! Bool
                    
                    if(!isPrivate) {
                        
                        numOfRows = 4
                        //tableView.backgroundView = nil
                    }
                    else
                    {
                        numOfRows = 0
                        let noDataLabel: UIImageView     = UIImageView(frame: CGRect(x: (screenWidth/2)-160, y: screenHeight-320, width: 320, height: 153))
                        noDataLabel.image = UIImage(named: "private_user_texticon")
                        self.tableView.backgroundColor = UIColor.clearColor()
                        self.view.insertSubview(noDataLabel, belowSubview: self.tableView)
                        //noDataLabel.center = tableView.center
                        //let parentVC = self.parentViewController?.parentViewController as! PACGroupsContainerVC
                        //parentVC.btnOpenCalender.hidden = true;
                    }
                }
            }
            else {
                numOfRows = 4
                //tableView.backgroundView = nil
            }

        }
        
        return numOfRows
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.setUpTableCell(tableView, indexPath: indexPath)
        cell.backgroundColor = UIColor.whiteColor()
        return cell
    }
    
    func setUpTableCell(tv: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if(indexPath.section == 0) {
            
            let cell =  tv.dequeueReusableCellWithIdentifier("PACDescCell", forIndexPath: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.None

            let txtViewDesc = cell.viewWithTag(333) as! UITextView
            txtViewDesc.text = self.dataDict["description"] as! String
            let lblMembership = cell.viewWithTag(222) as! UILabel
            
            let settingsDict = self.dataDict["settings"]
            let isPrivate = settingsDict!["private"] as! Bool
            
            if(isPrivate) {
                lblMembership.text = "Membership : Private"
            }
            else {
                lblMembership.text = "Membership : Public"
            }
            let btnSeeMore = cell.viewWithTag(444) as! UIButton
            btnSeeMore.addTarget(self, action: #selector(seeMoreButtonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            if(collapsed) {
                btnSeeMore.setImage(UIImage(named: "ic_profile_seemore"), forState: .Normal)
            }
            else {
                btnSeeMore.setImage(UIImage(named: "ic_profile_seeless"), forState: .Normal)
            }
            
            return cell
        }
        else if(indexPath.section == 1) {
            
            let cell =  tv.dequeueReusableCellWithIdentifier("PACLinkCell", forIndexPath: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.None

            let iv_image = cell.viewWithTag(111) as! UIImageView
            let lbl_title = cell.viewWithTag(222) as! UILabel
            let attachmentDict = self.dataDict["attachements"]
            let arrLinks = attachmentDict!["links"] as! [[String : AnyObject]]
            iv_image.image = UIImage(named: "file_attachment")
            lbl_title.text = arrLinks[indexPath.row]["title"] as? String
            return cell
        }
        else if(indexPath.section == 2) {
            //later
            let cell =  tv.dequeueReusableCellWithIdentifier("PACLinkCell", forIndexPath: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.None

            let iv_image = cell.viewWithTag(111) as! UIImageView
            let lbl_title = cell.viewWithTag(222) as! UILabel
            let attachmentDict = self.dataDict["attachements"]
            let arrLinks = attachmentDict!["links"] as! [[String : AnyObject]]
            iv_image.image = UIImage(named: "file_attachment")
            lbl_title.text = arrLinks[0]["title"] as? String
            return cell
        }
        else if(indexPath.section == 3) {
            
            switch indexPath.row {
            case 0:
                let cell =  tv.dequeueReusableCellWithIdentifier("PACMenbersCell", forIndexPath: indexPath) as! PACMenbersCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None

                let lbl_title = cell.viewWithTag(444) as! UILabel
                let btnSeeAll = cell.viewWithTag(555) as! UIButton
                btnSeeAll.hidden = true
                
                lbl_title.text = "Created By"
                cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
                return cell
            case 1:
                let cell =  tv.dequeueReusableCellWithIdentifier("PACMenbersCell", forIndexPath: indexPath) as! PACMenbersCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None

                let lbl_title = cell.viewWithTag(444) as! UILabel
                let btnSellAll = cell.viewWithTag(555) as! UIButton
                
                btnSellAll.addTarget(self, action: #selector(AboutPacVC.seeAllContacts(_:)), forControlEvents: .TouchUpInside)
                
                //  seeMoreBtn.addTarget(self, action: #selector(ResourcesPACVC.seeMoreAction(_:)), forControlEvents: .TouchUpInside)
                
                let arrAdmins = self.dataDict["admins"] as! [[String : AnyObject]]
                if(arrAdmins.count>0) {
                    lbl_title.text = "Admins"
                }
                else {
                    lbl_title.text = ""
                }
                cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
                return cell
            case 2:
                let cell =  tv.dequeueReusableCellWithIdentifier("PACMenbersCell", forIndexPath: indexPath) as! PACMenbersCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None

                let lbl_title = cell.viewWithTag(444) as! UILabel
                let btnSellAll = cell.viewWithTag(555) as! UIButton
                
                btnSellAll.addTarget(self, action: #selector(AboutPacVC.seeAllContacts(_:)), forControlEvents: .TouchUpInside)
                
                
                //let arrMembers = self.dataDict["members"] as! [[String : AnyObject]]

                lbl_title.text = "Members"
                cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
                return cell
            case 3:
                let cell =  tv.dequeueReusableCellWithIdentifier("PACAddresCell", forIndexPath: indexPath)
                cell.selectionStyle = UITableViewCellSelectionStyle.None

                let lbl_title = cell.viewWithTag(222) as! UILabel
                let addressDict = self.dataDict["location"]
                lbl_title.text = "\(addressDict!["address"] as! String), \(addressDict!["zipcode"] as! String)"
                return cell
            default:
                return UITableViewCell()
            }

        }
        else {
            return UITableViewCell()
        }
        
    }
    
    func seeMoreButtonClick(sender:UIButton!) {
        
       
        //let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableView)
       // let indexPath =  self.tableView.indexPathForRowAtPoint(buttonPosition)
        let seeMoreVC = AppHelper.getPacStoryBoard().instantiateViewControllerWithIdentifier("MoreDetailVC") as! MoreDetailVC
        
        //let desc = resourceDetailArr[indexPath!.section].valueForKey("description") as? String // Description
        seeMoreVC.detailStr = self.dataDict["description"] as! String!
        self.navigationController?.pushViewController(seeMoreVC, animated: true)
        
        print("See More")
        
        
        /* collapsed = !collapsed
        self.tableView.beginUpdates()
        self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
        self.tableView.endUpdates()
        */
    }
    
    
    //MARK:- EditPAC
    
    func editPACSelected() {
        
        let profileStoryboard = AppHelper.getPacStoryBoard()
        let createEditResourcePACVC = profileStoryboard.instantiateViewControllerWithIdentifier("PacContainerVC") as! PacContainerVC
        //createEditResourcePACVC.pageTitle = "Edit Resource"
        createEditResourcePACVC.isFromMemberProfileForEditPAC = true
        createEditResourcePACVC.responseDictFromMemberProfile = self.responseDict
        createEditResourcePACVC.arrPACMembers = self.arrPACMembers
        self.navigationController?.pushViewController(createEditResourcePACVC, animated: true)
        
    }
    
    
    
}

extension AboutPacVC:  UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.section == 1) {
            let attachmentDict = self.dataDict["attachements"]
            let arrLinks = attachmentDict!["links"] as! [[String : AnyObject]]
            let url = arrLinks[indexPath.row]["url"] as? String
            
            let WebVC:WebViewVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("WebViewVC") as! WebViewVC
            WebVC.title = arrLinks[indexPath.row]["title"] as? String
            
            if url != nil {
                WebVC.urlStr = url!
                self.navigationController?.pushViewController(WebVC, animated: true)
            }
        }
        else {
        //let containerObj = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("PACGroupsContainerVC") as! PACGroupsContainerVC
        //containerObj.title = "TTDSD"
        //self.navigationController?.pushViewController(containerObj, animated: true)
    
        }
    }
}


//MARK:- Collection View Data Source and Delegate

extension AboutPacVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return  1
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView.tag {
        case 0:
            return 1
        case 1:
            let arrAdmins = self.dataDict["admins"] as! [[String : AnyObject]]
            return arrAdmins.count
        case 2:
            let arrMembers = self.dataDict["members"] as! [[String : AnyObject]]
            return arrMembers.count
        default:
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(93, 110)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AdminsCollectionCell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.clearColor()
        
        let imagePerson = cell.viewWithTag(111) as! UIImageView
        imagePerson.layer.cornerRadius = imagePerson.frame.size.width/2
        imagePerson.clipsToBounds = true
        let namePerson = cell.viewWithTag(222) as! UILabel
        
        switch collectionView.tag {
        case 0:
            let createdByDict =  dataDict["createdBy"] as? [String : AnyObject]
            namePerson.text = createdByDict!["firstName"] as? String
            imagePerson.sd_setImageWithURL(NSURL.init(string: (createdByDict!["imgUrl"] as! String)), placeholderImage: UIImage.init(named: "ic_booking_profilepic"))
        case 1:
            let dataArr = self.dataDict["admins"] as! [[String : AnyObject]]
            let adminDict = dataArr[indexPath.row]
            namePerson.text  = adminDict["firstName"] as? String
            imagePerson.sd_setImageWithURL(NSURL.init(string: (adminDict["imgUrl"] as! String)), placeholderImage: UIImage.init(named: "ic_booking_profilepic"))

        case 2:
            let dataArr = self.dataDict["members"] as! [[String : AnyObject]]
            let memberDict = dataArr[indexPath.row]
            namePerson.text  = memberDict["firstName"] as? String
            imagePerson.sd_setImageWithURL(NSURL.init(string: (memberDict["imgUrl"] as! String)), placeholderImage: UIImage.init(named: "ic_booking_profilepic"))
        default:
            namePerson.text  = ""
        }
        
        namePerson.backgroundColor = UIColor.clearColor()
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        switch collectionView.tag {
        case 0:  // Created by
           
            let createdByDict =  dataDict["createdBy"] as? [String : AnyObject]
            // var dataArr = [[String : AnyObject]]()
            //dataArr.append((dataDict["createdBy"] as? [String : AnyObject])!)
            
           
             let userId = createdByDict!["_id"] as? String
           
             let profileContainerVC = AppHelper.getProfileStoryBoard().instantiateViewControllerWithIdentifier("ProfileContainerVC") as! ProfileContainerVC
             profileContainerVC.viewerUserID = userId
             self.navigationController?.pushViewController(profileContainerVC, animated: true)
             break
          
        case 1:   // Admin
            
         
            
            let dataArr = self.dataDict["admins"] as! [[String : AnyObject]]
            let memberDict = dataArr[indexPath.row]
            let userId = memberDict["_id"] as? String
            
            let profileContainerVC = AppHelper.getProfileStoryBoard().instantiateViewControllerWithIdentifier("ProfileContainerVC") as! ProfileContainerVC
            profileContainerVC.viewerUserID = userId
            self.navigationController?.pushViewController(profileContainerVC, animated: true)
         
            break
            
            
        case 2:  // Member
            
        
            let dataArr = self.dataDict["members"] as! [[String : AnyObject]]
            let memberDict = dataArr[indexPath.row]
            let userId = memberDict["_id"] as? String

            
            
            let profileContainerVC = AppHelper.getProfileStoryBoard().instantiateViewControllerWithIdentifier("ProfileContainerVC") as! ProfileContainerVC
            profileContainerVC.viewerUserID = userId
            self.navigationController?.pushViewController(profileContainerVC, animated: true)
            
            break
     
        default: break
           
        }
            print("get selected collectionview itemindex \(indexPath.row)")
     
    }
}

