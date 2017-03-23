//
//  MyPACVC.swift
//  ProactiveLiving
//
//  Created by Aseem Akarshan on 3/6/17.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit

class MyPACVC: UIViewController {

    
    // MARK:- Properties
    
    var lblTitle = ""
    var myPACDetailArr = [AnyObject]()
    var createJoinStatus = "0"

    // MARK: - Outlets
    @IBOutlet weak var tableViewMyPAC: UITableView!
    @IBOutlet weak var segmentedCtrl: UISegmentedControl!
    @IBOutlet weak var lblNoRecordFound: UILabel!
    
    // MARK :- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
         fetchMyPACDataFromServer(createJoinStatus)  // service call
     
         lblNoRecordFound.hidden = true  // hide the no rocord found label
        
      
    }

    
    override func viewWillAppear(animated: Bool) {
        
        self.tableViewMyPAC.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK :- Button action
    
    
    
    @IBAction func segmentedCtrlAction(sender: AnyObject) {
    
    print("Segmented Ctrl")
    
        if segmentedCtrl.selectedSegmentIndex == 0 {
            createJoinStatus = "0"
            fetchMyPACDataFromServer(createJoinStatus)  // service hit
            
        }
        else if segmentedCtrl.selectedSegmentIndex == 1{
             createJoinStatus = "1"
            fetchMyPACDataFromServer(createJoinStatus)   // service hit
             lblNoRecordFound.text = "Experts agree that we are influenced by the company we keep.Go to one of the sections to select an area of interest and join a Proactive Circle that helps you live life proactively."
        }
        
        
    
    }
    
    
    
    // MARK:- Service Hit
    func fetchMyPACDataFromServer( JoinStatus:String) {
        
        if AppDelegate.checkInternetConnection() {
            isPostServiceCalled = true
            
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            
           
            
            parameters = ["userId" : AppHelper.userDefaultsForKey(_ID) ,
                          "createJoinStatus" : createJoinStatus
            ]
            
            
            //call global web service class latest
            Services.postRequest(ServiceGetMyPAC, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                isPostServiceCalled = false
                
                //      print("Response = \(responseDict)")
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        
                        if let resultArr = responseDict["result"]  as? NSArray{
                            
                            print("TESTING FIND PAC \(resultArr)")
                            
                            
                            // hide and show the no record found label
                            if resultArr.count == 0 {
                                
                                if self.createJoinStatus == "0" {
                                    
                                     self.lblNoRecordFound.hidden = false
                                     self.lblNoRecordFound.text = "Experts agree that we are influenced by the company we keep.Go to one of the sections to select an area of interest and create a Proactive Circle that helps you live life proactively."
                                    
                                    self.tableViewMyPAC.hidden = true
                                    
                                }
                                else if self.createJoinStatus == "1" {
                                    
                                    self.lblNoRecordFound.hidden = false
                                    self.lblNoRecordFound.text = "Experts agree that we are influenced by the company we keep.Go to one of the sections to select an area of interest and join a Proactive Circle that helps you live life proactively."
                                    self.tableViewMyPAC.hidden = true

                                }
                                
                                
                            }
                            
                            
                            self.myPACDetailArr = resultArr as [AnyObject]  // storing data in array
                            self.tableViewMyPAC.reloadData()  // reload table view after successful service hit
                            
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

extension MyPACVC: UITableViewDataSource{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat    {
       
        return 150
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.myPACDetailArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
       //            self.setUpFindCell(tableView, indexPath: indexPath)
        
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
        
        
        
        iv_item.sd_setImageWithURL(NSURL.init(string: (self.myPACDetailArr[indexPath.row]["imgUrl"] as? String)!), placeholderImage: UIImage.init(named: "pac_listing_no_preview"))
        
        
        // Accessing the Name (First n Last)
        
        let createdByArr = self.myPACDetailArr[indexPath.row].valueForKey("createdBy")
        let firstNameArr = createdByArr!["firstName"] as? [String]
        let firstName = firstNameArr![0]
        
        let lastNameArr = createdByArr!["lastName"] as? [String]
        let lastName = lastNameArr![0]
        let fullName = "by " + firstName + " " + lastName
        
        
        let dateStr = self.myPACDetailArr[indexPath.row]["createdDate"] as? String
        let dateCreated = HelpingClass.convertDateFormat("yyyy-MM-dd HH:mm:ss", desireFormat: "dd/MM/yyyy", dateStr: dateStr!)
        let dateModifiedStr = self.myPACDetailArr[indexPath.row]["modifiedDate"] as? String
        let dateModified = HelpingClass.convertDateFormat("yyyy-MM-dd HH:mm:ss", desireFormat: "MMM d, yyyy", dateStr: dateModifiedStr!)
        
        
        let dataDict = self.myPACDetailArr[indexPath.row]["settings"] as? [String : AnyObject]
        
        if(dataDict!["private"] as! Bool) {
            lbl_privacy.text = "Private"
        }
        else {
            lbl_privacy.text = "Public"
        }
        
        let memberCount = self.myPACDetailArr[indexPath.row]["membercount"] as? Int
        
        lbl_members.text = "\(memberCount!) Members"   //self.pacDetailArr[indexPath.row]["membercount"] as? String
        lbl_title.text = self.myPACDetailArr[indexPath.row]["name"] as? String
        lbl_desc.text = self.myPACDetailArr[indexPath.row]["description"] as? String
        lbl_createdAt.text = "Created \(dateCreated)"
        lbl_by.text = fullName
        lbl_activateTime.text = "Last Active \(dateModified)"
        
        let distance = self.myPACDetailArr[indexPath.row]["dist"] as! Int
        lbl_distance.text = "\(distance) Miles"
        print(self.myPACDetailArr[indexPath.row].valueForKey("createdBy")!["firstName"] as? String)

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

extension MyPACVC:  UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let containerObj = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("PACGroupsContainerVC") as! PACGroupsContainerVC
        containerObj.title = "TTDSD"
        AppHelper.saveToUserDefaults(myPACDetailArr[indexPath.row]["_id"], withKey:"pacId")
        containerObj.pacID = self.myPACDetailArr[indexPath.row]["_id"] as! String
        self.navigationController?.pushViewController(containerObj, animated: true)
        
    }
    
}

