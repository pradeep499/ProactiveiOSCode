//
//  GenericPacTableVC.swift
//  ProactiveLiving
//
//  Created by Affle on 16/02/2017.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit
enum PacGenericType{
    
    case Find
}

class GenericPacTableVC: UIViewController {
    

// MARK :- Outlets
    @IBOutlet weak var tv_generic: UITableView!
    
// MARK :- Properties
    var pacDetailArr = [AnyObject]()
    var genericType:PacGenericType!
    var isForMemberProfile = false
    var strId = ""
// MARK :- view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPACsDataFromServer(["data":"empty"], searchStr: "")  // service call
       
        NSNotificationCenter.defaultCenter().removeObserver(self, name:NOTIFICATION_PAC_FILTER, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(fetchFilteredPACsData(_:)),name:NOTIFICATION_PAC_FILTER, object:nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.tv_generic.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchFilteredPACsData(notifData : NSNotification) {
        if(notifData.userInfo != nil) {
        fetchPACsDataFromServer(notifData.userInfo!, searchStr: "")  // service call
        }
    }
    
    //MARK:- Service Hit
    func fetchPACsDataFromServer(filterDict : [NSObject : AnyObject], searchStr : String) {
        
        if AppDelegate.checkInternetConnection() {
            isPostServiceCalled = true
            
            
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            var serviceURL = ""
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            if(searchStr.characters.count > 0) {
                parameters["search"] = searchStr
            }
            if(filterDict["data"] as! String != "empty")
            {
                parameters["filter"] = filterDict
            }

            if isForMemberProfile == true {
                parameters = [
                    "userId" : AppHelper.userDefaultsForKey(_ID),
                    "filter" : "pac"
                ]
                serviceURL = ServiceGetProfileDataByFilter
                
            }
            else {
             //   parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
                
                parameters = [
                    "userId" : AppHelper.userDefaultsForKey(_ID),
                    "categoryId" : strId
                ]
                
                serviceURL = ServiceGetMyPAC
                
            }

            
            
            
            
            //call global web service class latest
            Services.postRequest(serviceURL, parameters: parameters, completionHandler:{  //  ServiceGetFindPAC (Changed)
                (status,responseDict) in
                
                isPostServiceCalled = false
                
                //      print("Response = \(responseDict)")
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        
                        if let resultArr = responseDict["result"]  as? NSArray{
                            
                            print("TESTING FIND PAC \(resultArr)")
                            
                         
                            self.pacDetailArr = resultArr as [AnyObject]
                            self.tv_generic.reloadData()
                            
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
            AppDelegate.dismissProgressHUD()
            //show internet not available
            AppHelper.showAlertWithTitle(netError, message: netErrorMessage, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
        }
        
    }
}


// MARK :- tableView UITableViewDataSource

extension GenericPacTableVC: UITableViewDataSource{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat    {
        
        if genericType == .Find{
            
           // return  self.setAboutMeCellHeight(tableView, indexPath: indexPath)
        }
        return 150
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pacDetailArr.count  //return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        if self.genericType == .Find {
//            self.setUpFindCell(tableView, indexPath: indexPath)
//        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FindCell", forIndexPath: indexPath)
        
        cell.selectionStyle = .None
        
        let iv_item = cell.viewWithTag(1) as! UIImageView
    //    let iv_itemDec = cell.viewWithTag(2) as! UIImageView
        let lbl_title = cell.viewWithTag(3) as! UILabel
        let lbl_by = cell.viewWithTag(4) as! UILabel
        let lbl_members = cell.viewWithTag(5) as! UILabel
        let lbl_activateTime = cell.viewWithTag(6) as! UILabel
        let lbl_privacy = cell.viewWithTag(7) as! UILabel
        let lbl_desc = cell.viewWithTag(8) as! UILabel
        let lbl_createdAt = cell.viewWithTag(9) as! UILabel
        let lbl_distance = cell.viewWithTag(10) as! UILabel
        
        
        
        iv_item.sd_setImageWithURL(NSURL.init(string: (self.pacDetailArr[indexPath.row]["imgUrl"] as? String)!), placeholderImage: UIImage.init(named: "pac_listing_no_preview"))

        
        // Accessing the Name (First n Last)
        
        let createdByArr = self.pacDetailArr[indexPath.row].valueForKey("createdBy")
        let firstNameArr = createdByArr!["firstName"] as? [String]
        let firstName = firstNameArr![0]
        
        let lastNameArr = createdByArr!["lastName"] as? [String]
        let lastName = lastNameArr![0]
        let fullName = "by " + firstName + " " + lastName
        
        
        let dateStr = self.pacDetailArr[indexPath.row]["createdDate"] as? String
        let dateCreated = HelpingClass.convertDateFormat("yyyy-MM-dd HH:mm:ss", desireFormat: "dd/MM/yyyy", dateStr: dateStr!)
        let dateModifiedStr = self.pacDetailArr[indexPath.row]["modifiedDate"] as? String
        let dateModified = HelpingClass.convertDateFormat("yyyy-MM-dd HH:mm:ss", desireFormat: "MMM d, yyyy", dateStr: dateModifiedStr!)

        
        let dataDict = self.pacDetailArr[indexPath.row]["settings"] as? [String : AnyObject]
        
        if(dataDict!["private"] as! Bool) {
            lbl_privacy.text = "Private"
        }
        else {
            lbl_privacy.text = "Public"
        }
        
        let memberCount = self.pacDetailArr[indexPath.row]["membercount"] as? Int
        
        lbl_members.text = "\(memberCount!) Members"   //self.pacDetailArr[indexPath.row]["membercount"] as? String
        lbl_title.text = self.pacDetailArr[indexPath.row]["name"] as? String
        lbl_desc.text = self.pacDetailArr[indexPath.row]["description"] as? String
        lbl_createdAt.text = "Created \(dateCreated)"
        lbl_by.text = fullName
        lbl_activateTime.text = "Last Active \(dateModified)"

        let distance = self.pacDetailArr[indexPath.row]["dist"] as! Int
        lbl_distance.text = "\(distance) Miles"
        print(self.pacDetailArr[indexPath.row].valueForKey("createdBy")!["firstName"] as? String)

      
        return cell
    }
    
   
    
    
    
    
//    func setUpFindCell(tv: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
//        
//        let cell =  tv.dequeueReusableCellWithIdentifier("FindCell", forIndexPath: indexPath)
//        
//        
//        
//        let iv_item = cell.viewWithTag(1) as! UIImageView
//        let iv_itemDec = cell.viewWithTag(2) as! UIImageView
//        let lbl_title = cell.viewWithTag(3) as! UILabel
//        let lbl_by = cell.viewWithTag(4) as! UILabel
//        let lbl_members = cell.viewWithTag(5) as! UILabel
//        let lbl_activateTime = cell.viewWithTag(6) as! UILabel
//        let lbl_privacy = cell.viewWithTag(7) as! UILabel
//        let lbl_desc = cell.viewWithTag(8) as! UILabel
//        let lbl_createdAt = cell.viewWithTag(9) as! UILabel
//        let lbl_distance = cell.viewWithTag(10) as! UILabel
//        
//        
//        
//        iv_item.sd_setImageWithURL(NSURL.init(string: (self.pacDetailArr[indexPath.row]["imgUrl"] as? String)!), placeholderImage: UIImage.init(named: ""))
//        
//        lbl_title.text = self.pacDetailArr[indexPath.row]["name"] as? String
//        lbl_desc.text = self.pacDetailArr[indexPath.row]["description"] as? String
//        lbl_createdAt.text = self.pacDetailArr[indexPath.row]["createdDate"] as? String
//        
//        
//        return cell
//    }
    
    
}

extension GenericPacTableVC:  UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let containerObj = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("PACGroupsContainerVC") as! PACGroupsContainerVC
        containerObj.title = self.pacDetailArr[indexPath.row]["name"] as? String
        AppHelper.saveToUserDefaults(pacDetailArr[indexPath.row]["_id"], withKey:"pacId")
        containerObj.pacID = self.pacDetailArr[indexPath.row]["_id"] as! String
        self.navigationController?.pushViewController(containerObj, animated: true)
    
    }
    
}
