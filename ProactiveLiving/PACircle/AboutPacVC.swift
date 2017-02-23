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
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var imageHeader: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.registerClass(PacCollectionCell.self, forCellReuseIdentifier: "PacCollectionCell")
        self.tableView.registerNib(UINib(nibName:"PACMenbersCell", bundle: nil), forCellReuseIdentifier: "PACMenbersCell")
        tableView.allowsSelection = false;
        tableView.separatorStyle = .None
        // Do any additional setup after loading the view.
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
            parameters["pacId"] = "58a6984ffed5d155e3251c10"

            //call global web service class latest
            Services.postRequest(ServiceGetPACDetails, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    //dissmiss indicator
                    if ((responseDict["error"] as! Int) == 0) {
                        print(responseDict)
                        self.dataDict = responseDict["result"] as! [String : AnyObject]
                        //self.dataArr = items.map({$0["latestArticleLogoUrl"]! as! String}) as [String]
                        //self.imageHeader.sd_setImageWithURL(NSURL.init(string:self.dataDict["imgUrl"] as! String))
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
        //let y: CGFloat = -scrollView.contentOffset.y
        //if y > 0 {
            //self.imageHeader.frame = CGRectMake(0, scrollView.contentOffset.y, screenWidth + y, 180 + y)
            //self.imageHeader.center = CGPointMake(self.tableView.center.x, self.imageHeader.center.y)
        //}
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
                return 340
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
        
       
        if let settingsDict = self.dataDict["settings"] {

        let isPrivate = settingsDict["private"] as! Bool

        if(!isPrivate) {

            numOfRows = 7
            tableView.backgroundView = nil
        }
        else
        {
            numOfRows = 1
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "Membership is Private"
            noDataLabel.textColor     = UIColor.blackColor()
            noDataLabel.textAlignment = .Center
            tableView.backgroundView  = noDataLabel
        }
        }
        return numOfRows
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.setUpTableCell(tableView, indexPath: indexPath)
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
            imagePerson.sd_setImageWithURL(NSURL.init(string: (dataDict["imgUrl"] as! String)), placeholderImage: UIImage.init(named: ""))
        case 4:
            let dataArr = self.dataDict["admins"] as! [[String : AnyObject]]
            let adminDict = dataArr[indexPath.row]
            namePerson.text  = adminDict["firstName"] as? String
            imagePerson.sd_setImageWithURL(NSURL.init(string: (adminDict["imgUrl"] as! String)), placeholderImage: UIImage.init(named: ""))

        case 5:
            let dataArr = self.dataDict["admins"] as! [[String : AnyObject]]
            let memberDict = dataArr[indexPath.row]
            namePerson.text  = memberDict["firstName"] as? String
            imagePerson.sd_setImageWithURL(NSURL.init(string: (memberDict["imgUrl"] as! String)), placeholderImage: UIImage.init(named: ""))
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

