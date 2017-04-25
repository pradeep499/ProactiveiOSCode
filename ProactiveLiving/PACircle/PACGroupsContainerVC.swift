//
//  PACGroupsContainerVC.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 21/02/17.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit

class PACGroupsContainerVC: UIViewController,YSLContainerViewControllerDelegate {
    
    
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var btnOpenCalender: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
    
    var tokensAdmin = [AnyObject]()
    var tokensMember = [AnyObject]()
    var firstVC:NewsFeedsAllVC!
    var secondVC:ResourcesPACVC!
    var pacID = String()
    var arrPACMembers1 = [[String : AnyObject]]()
    var thirdVC : AboutPacVC!
    var arrViewControllers = [AnyObject]()
    var memberStatus = Bool()
    var adminStatus = Bool()
    var listPacStatus = Bool()
    var creatorStatus = Bool()
    var allowToCreateMeetup = Bool()
    var allowToCreateWebinvite = Bool()
    var allowToUpload = Bool()
    var isPrivate = Bool()
    // Right button DXPopOver
    var popOverTableView:UITableView?
    var popover:DXPopover = DXPopover()
    var popoverWidth:CGFloat = 150
    var popoverHeight:CGFloat = 200
    var popOverCellData = [String]()
    var packRole = [String:AnyObject]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.lbl_title.text = self.title
        self.btnRight.hidden = true

        tokensAdmin = [AnyObject]()
        tokensMember = [AnyObject]()
        self.setUpViewControllers()
        
        // To take button on front most
        self.view.addSubview(self.btnOpenCalender)
        self.view.bringSubviewToFront(self.btnOpenCalender)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NOTIFICATION_REFRESH_PAC_CONTAINER, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PACGroupsContainerVC.fetchDataForPACRole), name: NOTIFICATION_REFRESH_PAC_CONTAINER, object: nil)
        
    }
    
//    override func viewWillAppear(animated: Bool) {
//        fetchDataForPACRole()
//    }
    
    func fetchDataForPACRole() {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            parameters["pacId"] = self.pacID
            
            //call global web service class latest
            Services.postRequest(ServiceGetPACRole, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    //dissmiss indicator
                    if ((responseDict["error"] as! Int) == 0) {
                        print(responseDict)
                        self.packRole = responseDict as! [String:AnyObject]
                        self.firstVC.dictValuePacRole = self.packRole;
                        self.secondVC.dictValuePacRole = self.packRole;
                        self.thirdVC.dictValuePacRole = self.packRole;


                        self.creatorStatus = responseDict["result"]!["creatorStatus"] as! Bool
                        self.memberStatus = responseDict["result"]!["memberStatus"] as! Bool
                        self.adminStatus = responseDict["result"]!["adminStatus"] as! Bool
                        self.listPacStatus = responseDict["result"]!["listPacStatus"] as! Bool
                        self.arrPACMembers1 = responseDict["result"]!["members"] as! [[String : AnyObject]]
                        let settingsDict = responseDict["result"]!["settings"] as! [String : AnyObject]
                        
                        self.allowToCreateMeetup = settingsDict["allowToCreateMeetup"] as! Bool
                        self.allowToCreateWebinvite = settingsDict["allowToCreateWebinvite"] as! Bool
                        self.allowToUpload = settingsDict["allowToUpload"] as! Bool
                        self.isPrivate = settingsDict["private"] as! Bool
                        
                        if(self.memberStatus == false) {
                            self.btnRight.hidden = true
                                self.btnOpenCalender.hidden = true
                            }
                        else {
                            self.btnRight.hidden = false
                            
                            if(currentIndex == 0) {
                                
                                if(self.adminStatus == true) {
                                    // five options
                                    if(self.listPacStatus == true) {
                                    self.popOverCellData = ["Don't list on my Profile", "Exit PAC", "Report PAC", "Delete PAC", "Edit PAC"]
                                    }
                                    else {
                                        self.popOverCellData = ["List on my Profile", "Exit PAC", "Report PAC", "Delete PAC", "Edit PAC"]
                                    }
                                    self.popOverTableView?.frame = CGRectMake(0, 0, 220, 45*5)
                                    
                                }
                                else if(self.creatorStatus == true) {
                                    //three options
                                    if(self.listPacStatus == true) {
                                        self.popOverCellData = ["Don't list on my Profile", "Report PAC", "Delete PAC", "Edit PAC"]
                                    }
                                    else {
                                        self.popOverCellData = ["List on my Profile", "Report PAC", "Delete PAC", "Edit PAC"]

                                    }
                                    self.popOverTableView?.frame = CGRectMake(0, 0, 220, 45*4)
                                }
                                else {
                                    
                                    if(self.listPacStatus == true) {
                                        self.popOverCellData = ["Don't list on my Profile", "Report PAC", "Exit PAC"]
                                    }
                                    else {
                                        self.popOverCellData = ["List on my Profile", "Report PAC", "Exit PAC"]

                                    }
                                    self.popOverTableView?.frame = CGRectMake(0, 0, 220, 45*3)
                                }
                                
                            }
                            else if(currentIndex == 1) {
                                if(self.memberStatus == true) {
                                    self.btnRight.hidden = false
                                    if(self.adminStatus == true || self.creatorStatus == true) {
                                        self.popOverCellData = [ "Edit",  "Create New"]
                                        self.popOverTableView?.frame = CGRectMake(0, 0, 150, 45*2)
                                    }
                                    else {
                                        if(self.allowToUpload == true) {
                                            self.popOverCellData = ["Create New"]
                                            self.popOverTableView?.frame = CGRectMake(0, 0, 150, 45*1)
                                        }
                                        else {
                                            self.btnRight.hidden = true
                                        }
                                    }
                                    

                                }
                                else {
                                    self.btnRight.hidden = true
                                }
                            
                            }
                            else if(currentIndex == 2) {
                                
                                self.popOverCellData = [ "",  ""]
                                self.popOverTableView?.frame = CGRectMake(0, 0, 150, 45*2)
                            }


                            self.popOverTableView?.reloadData()

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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpViewControllers() {
        
        // SetUp ViewControllers
        
        firstVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("NewsFeedsAllVC") as! NewsFeedsAllVC
        firstVC.pacID = self.pacID
        firstVC.title = "WALL"

        secondVC = AppHelper.getPacStoryBoard().instantiateViewControllerWithIdentifier("ResourcesPACVC") as! ResourcesPACVC
        secondVC.title = "RESOURCES"
        secondVC.pacID = self.pacID

        thirdVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("AboutPacVC") as! AboutPacVC
        thirdVC.title = "ABOUT"
        thirdVC.pacID = self.pacID
        
        arrViewControllers = [thirdVC,secondVC,firstVC]
        
        let containerVC = YSLContainerViewController.init(controllers: arrViewControllers, topBarHeight: 0, parentViewController: self)
        containerVC.delegate = self
        containerVC.menuItemFont = UIFont(name: "Roboto-Regular", size: 11)
        containerVC.menuItemSelectedFont = UIFont(name: "Roboto-Bold", size: 11.5)
        containerVC.menuBackGroudColor = UIColor(red: 1.0 / 255, green: 174.0 / 255, blue: 240.0 / 255, alpha: 1.0)
        containerVC.menuItemTitleColor = UIColor.whiteColor()
        containerVC.menuItemSelectedTitleColor = UIColor.whiteColor()
        //   containerVC.view.frame = CGRectMake(0, self.layOutConstrain_ivBg_height.constant, containerVC.view.frame.size.width, containerVC.view.frame.size.height - self.layOutConstrain_ivBg_height.constant)
        
        containerVC.view.frame = CGRectMake(0, 64, containerVC.view.frame.size.width,   screenHeight - 64 )
    
        self.view.addSubview(containerVC.view)
        
    }
    
    
    
    // MARK: -- YSLContainerViewControllerDelegate
    func containerViewItemIndex(index: Int, currentController controller: UIViewController) {
        self.view.endEditing(true)
        print("current Index : \(Int(index))")
        print("current controller : \(controller)")
        currentIndex = index
       // controller.viewWillAppear(true)
        
        //popover table
        if(popOverTableView == nil) {
        popOverTableView = UITableView()
        }
        popOverTableView?.dataSource = self
        popOverTableView?.delegate = self
        popOverTableView?.separatorStyle = .None
        
        if index == 0 {
            
            self.fetchDataForPACRole()
            self.btnRight.hidden = false
            //self.btnRight.setImage(UIImage(named: ""), forState: .Normal)
            //self.thirdVC.dictValuePacRole = self.packRole;
            
        }
        else if index == 1 {
            self.fetchDataForPACRole()
            self.btnRight.hidden = false
            //self.btnRight.setImage(UIImage(named: ""), forState: .Normal)
            //self.secondVC.dictValuePacRole = self.packRole;
            
        }
        else if index == 2 {
            //self.fetchDataForPACRole()
            self.btnRight.hidden = true
            self.firstVC.dictValuePacRole = packRole;
            //self.btnRight.setImage(UIImage(named: ""), forState: .Normal)

        }
    }
    
    //MARK:- Actions
    
    func btnLikeClick(sender: UIButton) {
        sender.selected = !sender.selected
        
    }
    
    // MARK: --Actions
    @IBAction func btnOpenCalenderClick(sender: AnyObject) {
        
        let objCalendarVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("CalendarVC") as! RSDFDatePickerViewController
        objCalendarVC.fromScreen = "AboutPacVC"
        objCalendarVC.allowToCreateMeetup = self.allowToCreateMeetup
        objCalendarVC.allowToCreateWebinvite = self.allowToCreateWebinvite
        objCalendarVC.pacID = self.pacID
        objCalendarVC.arrPACMembers = self.arrPACMembers1
        print_debug(objCalendarVC.arrPACMembers)
        self.navigationController?.pushViewController(objCalendarVC, animated: true)
    }
    
    @IBAction func onClickBackBtn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func onClickRightBtn(sender: AnyObject) {
        
        let windowHeight = self.view.frame.size.height
        let button = sender as? UIButton
        //        NSLog("button tag \(button!.tag)")
        let frameInWindow = button!.convertRect(button!.bounds, toView: self.view)
        let popoverY = frameInWindow.origin.y
        var startPoint = CGPointMake(frameInWindow.midX, frameInWindow.maxY)
        var popoverPosition:DXPopoverPosition = .Down
        if (windowHeight-popoverY<160){
            startPoint = CGPointMake(frameInWindow.midX, frameInWindow.minY)
            popoverPosition = .Up
        }
        self.popover.showAtPoint(startPoint, popoverPostion: popoverPosition, withContentView: self.popOverTableView, inView: self.view)
   
     
    }
    
    //MARK:- Service Call For Popover actions
    func serviceCallForActions(service : String, parameters : [String : AnyObject]) {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
 
            //call global web service class latest
            Services.postRequest(service, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    //dissmiss indicator
                    if ((responseDict["error"] as! Int) == 0) {
                        print(responseDict)
                        self.fetchDataForPACRole()
                        self.navigationController?.popViewControllerAnimated(true)
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

// MARK:- Extension

extension PACGroupsContainerVC : UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       // return popOverCellData.count
        
        if tableView == popOverTableView{
            return popOverCellData.count
        }
        return 0
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
       // if tableView == popOverTableView{
            let cell = UITableViewCell.init(style: .Default, reuseIdentifier: "cell")
            cell.textLabel?.text = popOverCellData[indexPath.row]
            //            cell.textLabel?.textAlignment = .Center
            cell.selectionStyle = .None
            return cell
      //  }
        
        
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.popover.dismiss()

        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        print(currentCell.textLabel?.text)
        
        if(currentCell.textLabel?.text == "Edit" || currentCell.textLabel?.text == "Done") {
            
            if self.secondVC.isHidden  {
                
                self.secondVC.isHidden = false
                self.secondVC.tableViewResource.reloadData()
                
                popOverCellData[0] = "Done"
                popOverTableView?.reloadData()
                
            }
            else {
                
                self.secondVC.isHidden = true
                self.secondVC.tableViewResource.reloadData()
                
                popOverCellData[0] = "Edit"
                popOverTableView?.reloadData()
                
            }
        }
        else if(currentCell.textLabel?.text == "Create New") {
            
            let profileStoryboard = AppHelper.getPacStoryBoard()
            let createEditResourcePACVC = profileStoryboard.instantiateViewControllerWithIdentifier("CreateEditResourcePACVC") as! CreateEditResourcePACVC
            createEditResourcePACVC.pageTitle = "Create Resource"
            self.navigationController?.pushViewController(createEditResourcePACVC, animated: true)
            
        }
        else if(currentCell.textLabel?.text == "Don't list on my Profile") {
            
            self.thirdVC.ServiceCallPacActionProfile(false)
        }
        else if(currentCell.textLabel?.text == "List on my Profile") {
            
            self.thirdVC.ServiceCallPacActionProfile(true)
        }
        else if(currentCell.textLabel?.text == "Exit PAC") {
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            parameters["pacId"] = self.pacID
            if(self.adminStatus == true) {
                parameters["role"] = "admin"
            }
            else {
                parameters["role"] = "member"
            }
            
            let alertController = UIAlertController(title:APP_NAME, message: "Do you want to Exit PAC?" , preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
            }))
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                
                
                self.serviceCallForActions(ServiceExitPAC, parameters: parameters)
     
            }))
             self.presentViewController(alertController, animated: true, completion: nil)
           // self.serviceCallForActions(ServiceExitPAC, parameters: parameters)
        }
        else if(currentCell.textLabel?.text == "Report PAC") {
            self.sendMail()
        }
        else if(currentCell.textLabel?.text == "Delete PAC") {
            
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            parameters["pacId"] = self.pacID
            
            let alertController = UIAlertController(title: APP_NAME, message: "Do you want to Delete PAC?", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel" ,style: UIAlertActionStyle.Default, handler: {(ACTION : UIAlertAction!)in}))
            alertController.addAction(UIAlertAction(title: "OK" ,style: UIAlertActionStyle.Default, handler: {(ACTION:UIAlertAction!)in
            
            
            self.serviceCallForActions(ServiceDeletePAC, parameters: parameters)
            
            }))
             self.presentViewController(alertController, animated: true, completion: nil)
           // self.serviceCallForActions(ServiceDeletePAC, parameters: parameters)
            
        }
        else if(currentCell.textLabel?.text == "Edit PAC") {
            
            self.thirdVC.arrPACMembers = self.arrPACMembers1
            self.thirdVC.editPACSelected()
            
            
        }
        else {
            
        }
    
    }
    
    
}

extension PACGroupsContainerVC:MFMailComposeViewControllerDelegate{
    
    
    func sendMail() -> Void {
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients(["support@proactively.com"])
        composeVC.setSubject("Report PAC")
        
        let body = "PAC Name: " + self.title!
        
        composeVC.setMessageBody(body , isHTML: true)
        
        // Present the view controller modally.
        self.presentViewController(composeVC, animated: true, completion: nil)
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        // Dismiss the mail compose view controller.
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}




