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
    var genericType:PacGenericType!

    @IBOutlet weak var tv_generic: UITableView!
    
    var pacDetailArr = [AnyObject]()
   
// MARK :- view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPostDataFromServer()  // service call
       
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.tv_generic.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Service Hit
    func fetchPostDataFromServer() {
        
        if AppDelegate.checkInternetConnection() {
            isPostServiceCalled = true
            
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
        
            //call global web service class latest
            Services.postRequest(ServiceGetFindPAC, parameters: parameters, completionHandler:{
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
      //  let lbl_members = cell.viewWithTag(5) as! UILabel
     //   let lbl_activateTime = cell.viewWithTag(6) as! UILabel
      //  let lbl_privacy = cell.viewWithTag(7) as! UILabel
        let lbl_desc = cell.viewWithTag(8) as! UILabel
        let lbl_createdAt = cell.viewWithTag(9) as! UILabel
      //  let lbl_distance = cell.viewWithTag(10) as! UILabel
        
        
        
        iv_item.sd_setImageWithURL(NSURL.init(string: (self.pacDetailArr[indexPath.row]["imgUrl"] as? String)!), placeholderImage: UIImage.init(named: "ic_certifications_sustainable"))

        
        let firstName = self.pacDetailArr[indexPath.row].valueForKey("createdBy")!["firstName"] as? String
        let lastName =  self.pacDetailArr[indexPath.row].valueForKey("createdBy")!["lastName"] as? String

        let fullName = firstName! + " " + lastName!
        
        
        lbl_title.text = self.pacDetailArr[indexPath.row]["name"] as? String
        lbl_desc.text = self.pacDetailArr[indexPath.row]["description"] as? String
        lbl_createdAt.text = self.pacDetailArr[indexPath.row]["createdDate"] as? String
        lbl_by.text = fullName  //self.pacDetailArr[indexPath.row].valueForKey("createdBy")!["firstName"] as? String
        
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
        containerObj.title = "TTDSD"
        AppHelper.saveToUserDefaults(pacDetailArr[indexPath.row]["_id"], withKey:"pacId")
        containerObj.pacID = self.pacDetailArr[indexPath.row]["_id"] as! String
        self.navigationController?.pushViewController(containerObj, animated: true)
    
    }
    
}
