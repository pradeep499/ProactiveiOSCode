//
//  AboutPacVC.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 21/02/17.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit

class AboutPacVC: UIViewController {

    var collapsed = true
    var dataDict = [String : AnyObject]()
    var pacID = String()
    var memberStatus = Bool()
    
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var btnInvite: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageHeader: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName:"PACMenbersCell", bundle: nil), forCellReuseIdentifier: "PACMenbersCell")
        tableView.allowsSelection = false;
        tableView.separatorStyle = .None
        // Do any additional setup after loading the view.
        btnLike.addTarget(self, action: #selector(btnLikeClick(_:)), forControlEvents: .TouchUpInside)
        btnLike.setImage(UIImage(named: "like_empty"), forState: .Normal)
        btnLike.setImage(UIImage(named: "like_filled"), forState: .Selected)

        self.fetchDataForAboutSection()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
                        print(responseDict)
                        self.dataDict = (responseDict["result"]!["pac"] as! [String : AnyObject])
                        self.btnLike.selected = responseDict["result"]!["likeStatus"] as! Bool
                        self.memberStatus = responseDict["result"]!["memberStatus"] as! Bool
                        self.imageHeader.sd_setImageWithURL(NSURL.init(string:self.dataDict["imgUrl"] as! String))
                        
                        if((self.dataDict["likes"] as! [String]).count == 1) {
                            self.lblLikes.text = "\((self.dataDict["likes"] as! [String]).count) Like"
                        }
                        else {
                            self.lblLikes.text = "\((self.dataDict["likes"] as! [String]).count) Likes"
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
    
    func btnInviteClick(sender: UIButton) {
        
    }
    
    // To Like/Unlike PAC
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
    
}

extension AboutPacVC: UITableViewDataSource{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat    {
        
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
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        var numOfRows: Int = 0
        
       
        if self.memberStatus == false {
            
            if let settingsDict = self.dataDict["settings"] {
                
                let isPrivate = settingsDict["private"] as! Bool
                
                if(!isPrivate) {
                    
                    numOfRows = 7
                    //tableView.backgroundView = nil
                }
                else
                {
                    numOfRows = 1
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
            numOfRows = 7
            //tableView.backgroundView = nil
        }
        return numOfRows
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.setUpTableCell(tableView, indexPath: indexPath)
        cell.backgroundColor = UIColor.whiteColor()
        return cell
    }
    
    func setUpTableCell(tv: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        
        switch indexPath.row {
        case 0:
            let cell =  tv.dequeueReusableCellWithIdentifier("PACDescCell", forIndexPath: indexPath)
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
        case 1:
            let cell =  tv.dequeueReusableCellWithIdentifier("PACLinkCell", forIndexPath: indexPath)
            let iv_image = cell.viewWithTag(111) as! UIImageView
            let lbl_title = cell.viewWithTag(222) as! UILabel
            iv_image.image = UIImage(named: "file_attachment")
            lbl_title.text = "sfsfdsf"
            return cell
        case 2:
            let cell =  tv.dequeueReusableCellWithIdentifier("PACLinkCell", forIndexPath: indexPath)
            let iv_image = cell.viewWithTag(111) as! UIImageView
            let lbl_title = cell.viewWithTag(222) as! UILabel
            iv_image.image = UIImage(named: "link_attachment")
            lbl_title.text = "sfsfdsf"
            return cell
        case 3:
            let cell =  tv.dequeueReusableCellWithIdentifier("PACMenbersCell", forIndexPath: indexPath) as! PACMenbersCell
            let lbl_title = cell.viewWithTag(444) as! UILabel
            lbl_title.text = "Created By"
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            return cell
        case 4:
            let cell =  tv.dequeueReusableCellWithIdentifier("PACMenbersCell", forIndexPath: indexPath) as! PACMenbersCell
            let lbl_title = cell.viewWithTag(444) as! UILabel
            lbl_title.text = "Admins"
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            return cell
        case 5:
            let cell =  tv.dequeueReusableCellWithIdentifier("PACMenbersCell", forIndexPath: indexPath) as! PACMenbersCell
            let lbl_title = cell.viewWithTag(444) as! UILabel
            lbl_title.text = "Members"
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            return cell
        case 6:
            let cell =  tv.dequeueReusableCellWithIdentifier("PACAddresCell", forIndexPath: indexPath)
            let lbl_title = cell.viewWithTag(222) as! UILabel
            let addressDict = self.dataDict["location"]
            lbl_title.text = "\(addressDict!["address"] as! String), \(addressDict!["zipcode"] as! String)"
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func seeMoreButtonClick(sender:UIButton!) {
        
        collapsed = !collapsed
        self.tableView.beginUpdates()
        self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
        self.tableView.endUpdates()
    }
    
    
    
}

extension AboutPacVC:  UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //let containerObj = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("PACGroupsContainerVC") as! PACGroupsContainerVC
        //containerObj.title = "TTDSD"
        //self.navigationController?.pushViewController(containerObj, animated: true)
    
    }
    
}


extension AboutPacVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return  1
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView.tag {
        case 3:
            return 1
        case 4:
            let arrAdmins = self.dataDict["admins"] as! [[String : AnyObject]]
            return arrAdmins.count
        case 5:
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
        case 3:
            namePerson.text = dataDict["createdBy"] as? String
            imagePerson.sd_setImageWithURL(NSURL.init(string: (dataDict["imgUrl"] as! String)), placeholderImage: UIImage.init(named: "ic_booking_profilepic"))
        case 4:
            let dataArr = self.dataDict["admins"] as! [[String : AnyObject]]
            let adminDict = dataArr[indexPath.row]
            namePerson.text  = adminDict["firstName"] as? String
            imagePerson.sd_setImageWithURL(NSURL.init(string: (adminDict["imgUrl"] as! String)), placeholderImage: UIImage.init(named: "ic_booking_profilepic"))

        case 5:
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
        
        print("get selected collectionview itemindex \(indexPath.row)")
        
    }
}

