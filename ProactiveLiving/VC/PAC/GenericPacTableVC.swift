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
    

// MARK:- Outlets
    @IBOutlet weak var tv_generic: UITableView!
    
// MARK:- Properties
    var pacDetailArr = [AnyObject]()
    var genericType:PacGenericType!
    var isForMemberProfile = false
    var isFriend = false
    var isviewForID = ""
    var strId = ""
    var spinner = UIActivityIndicatorView()
    var fromIndex = 0
    var isSerrching = false
    var searchText = ""
    var isFromFilter = false
    var filterDic : [NSObject : AnyObject]?
    
    
// MARK:- view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPACsDataFromServer(["data":"empty"], searchStr: "",index:0)  // service call

        NSNotificationCenter.defaultCenter().removeObserver(self, name:NOTIFICATION_PAC_FILTER, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(fetchFilteredPACsData(_:)),name:NOTIFICATION_PAC_FILTER, object:nil)
        
        spinner.stopAnimating()
        spinner.hidesWhenStopped = true
        spinner.frame = CGRectMake(0, 0, 320, 44)
        self.tv_generic.tableFooterView = spinner
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchFilteredPACsData(notifData : NSNotification) {
        if(notifData.userInfo != nil) {
            fetchPACsDataFromServer(notifData.userInfo!, searchStr: "",index:0)// service call
            self.filterDic = notifData.userInfo!
            isFromFilter = true
            
        }
    }
    
    //MARK:- Service Hit
    func fetchPACsDataFromServer(filterDict : [NSObject : AnyObject], searchStr : String, index:Int) {
        
        
        
        if AppDelegate.checkInternetConnection() {
            isPostServiceCalled = true
            
            
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            var serviceURL = ""
            if isFriend{
                parameters["userId"] = isviewForID
            }else{
                parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            }
            parameters["index"] = index
            
            if (index == 0){
                pacDetailArr.removeAll()
            }
            
            // Filter applied when coming from User's Profile
            if isForMemberProfile == true {
                parameters["filter"] = "pac"
                serviceURL = ServiceGetProfileDataByFilter
                
            }
            else {
                
                serviceURL = ServiceGetMyPAC

                if(searchStr.characters.count > 0 && !(searchStr == "cancel")) { // For main search

                    parameters["search"] = searchStr

                }
                else if(filterDict["data"] as! String != "empty") { // For main filter
               
                    parameters["filter"] = filterDict
                   
                }
                else if (searchStr == "cancel") {
                    
                     pacDetailArr.removeAll()
                     parameters["categoryId"] = strId
                  
                    }
                else if (self.isSerrching == true) {
                   
                    parameters["search"] = searchStr
                    
                }
                else { // Main Data API
                    
                    if (self.isSerrching == false){
                    
                    parameters["categoryId"] = strId
                        
                 }
                    
                }

            }
            print_debug("parameters values ")

            print_debug(parameters)

            
            //call global web service class latest
            Services.postRequest(serviceURL, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                isPostServiceCalled = false
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        
                        if let resultArr = responseDict["result"]  as? NSArray{
                            
                            print_debug("TESTING FIND PAC \(resultArr)")
                            
                             if resultArr.count > 0 {
                             
                             //   self.myPACDetailArr.insert(resultArr, atIndex: self.myPACDetailArr.count)
                             self.pacDetailArr.appendContentsOf(resultArr)
                             self.fromIndex = self.pacDetailArr.count
                             self.spinner.stopAnimating()
                             self.tv_generic.reloadData()
                             }else{
                             self.spinner.stopAnimating()
                             }

                          //  self.pacDetailArr = resultArr as [AnyObject]
                          //  self.tv_generic.reloadData()
                            
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


// MARK :- TableView UITableViewDataSource

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
        
        
        iv_item.contentMode = .ScaleToFill
        iv_item.sd_setImageWithURL(NSURL.init(string: (self.pacDetailArr[indexPath.row]["imgUrl"] as? String)!), placeholderImage: UIImage.init(named: "pac_listing_no_preview"))

        
        // Accessing the Name (First n Last)
        
        let createdByArr = self.pacDetailArr[indexPath.row].valueForKey("createdBy")
        let firstNameArr = createdByArr!["firstName"] as? [String]
        let firstName = firstNameArr![0]
        
        let lastNameArr = createdByArr!["lastName"] as? [String]
        let lastName = lastNameArr![0]
        let fullName = "by " + firstName + " " + lastName
        
        
        let dateStr = self.pacDetailArr[indexPath.row]["createdDate"] as? String
        let dateCreated = HelpingClass.convertDateFormat("yyyy-MM-dd HH:mm:ss", desireFormat: "MM/dd/yyyy", dateStr: dateStr!)
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
        print_debug(self.pacDetailArr[indexPath.row].valueForKey("createdBy")!["firstName"] as? String)

      
        return cell
    }
    
    
}

//MARK:- UITableViewDelegate
extension GenericPacTableVC:  UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let containerObj = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("PACGroupsContainerVC") as! PACGroupsContainerVC
        containerObj.title = self.pacDetailArr[indexPath.row]["name"] as? String
        AppHelper.saveToUserDefaults(pacDetailArr[indexPath.row]["_id"], withKey:"pacId")
        containerObj.pacID = self.pacDetailArr[indexPath.row]["_id"] as! String
        self.navigationController?.pushViewController(containerObj, animated: true)
    
    }
    
    
    //MARK:- "ScrollView Did End Dragging" For Pagination
    
    func scrollViewDidEndDragging(aScrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let offset = aScrollView.contentOffset
        let bounds = aScrollView.bounds
        let size = aScrollView.contentSize
        let inset = aScrollView.contentInset
        let y: Float = Float(offset.y) + Float(bounds.size.height) - Float(inset.bottom)
        let h: Float = Float(size.height)
        let reload_distance: Float = 50
        
        if y > h + reload_distance {
            print_debug("load more data")
            tv_generic.tableFooterView!.hidden = false
           // fetchMyPACDataFromServer(self.createJoinStatus)
            
            // Pagination logic
            
            if isSerrching{
                fetchPACsDataFromServer(["data":"empty"], searchStr:self.searchText,index:pacDetailArr.count)
 
            }
            else if isFromFilter {
                fetchPACsDataFromServer(self.filterDic!, searchStr: "",index:pacDetailArr.count)// filter service call
            }
            else {
            fetchPACsDataFromServer(["data":"empty"], searchStr: "",index:pacDetailArr.count)  // search service call
            
            }
            spinner.startAnimating()
        }
        else{
            spinner.stopAnimating()
            tv_generic.tableFooterView!.hidden = true
            
        }
    }
    
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView()
        
        return v
    }

    
}
