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
    var thirdVC : AboutPacVC!
    var arrViewControllers = [AnyObject]()
    var memberStatus = Bool()
    var adminStatus = Bool()
    var creatorStatus = Bool()

    // Right button DXPopOver
    var popOverTableView:UITableView?
    var popover:DXPopover = DXPopover()
    var popoverWidth:CGFloat = 150
    var popoverHeight:CGFloat = 200
    var popOverCellData = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let alert = UIAlertView()
        alert.show()
        
        self.lbl_title.text = self.title
        self.btnRight.hidden = true

        tokensAdmin = [AnyObject]()
        tokensMember = [AnyObject]()
        self.setUpViewControllers()
        
        // To take button on front most
        self.view.addSubview(self.btnOpenCalender)
        self.view.bringSubviewToFront(self.btnOpenCalender)
        
    }
    
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
                        self.creatorStatus = responseDict["result"]!["creatorStatus"] as! Bool
                        self.memberStatus = responseDict["result"]!["memberStatus"] as! Bool
                        self.adminStatus = responseDict["result"]!["adminStatus"] as! Bool
    
                        if(self.memberStatus == false) {
                            self.btnRight.hidden = true
                        }
                        else {
                            self.btnRight.hidden = false
                            
                            if(currentIndex == 0) {
                                self.popOverCellData = [ "Edit",  "Create New"]
                                self.popOverTableView?.frame = CGRectMake(0, 0, 150, 45*2)
                            }
                            else if(currentIndex == 1) {
                                
                                self.popOverCellData = [ "Edit",  "Create New"]
                                self.popOverTableView?.frame = CGRectMake(0, 0, 150, 45*2)
                            
                            }
                            else if(currentIndex == 2) {
                                
                                if(self.adminStatus == true) {
                                    // five options
                                    self.popOverCellData = ["Don't list on my Profile", "Exit PAC", "Report PAC", "Delete PAC", "Edit PAC"]
                                    self.popOverTableView?.frame = CGRectMake(0, 0, 220, 45*5)
                                    
                                }
                                else {
                                    //three options
                                    self.popOverCellData = ["Don't list on my Profile", "Exit PAC", "Report PAC"]
                                    self.popOverTableView?.frame = CGRectMake(0, 0, 220, 45*3)
                                }

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
        
        thirdVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("AboutPacVC") as! AboutPacVC
        thirdVC.title = "ABOUT"
        thirdVC.pacID = self.pacID
        
        arrViewControllers = [firstVC,secondVC,thirdVC]
        
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
        controller.viewWillAppear(true)
        
        //popover table
        if(popOverTableView == nil) {
        popOverTableView = UITableView()
        }
        popOverTableView?.dataSource = self
        popOverTableView?.delegate = self
        popOverTableView?.separatorStyle = .None
        
        if index == 0 {
            
            popOverTableView?.frame = CGRectMake(0, 0, 220, 45*0)
            popOverCellData = ["", ""]
            popOverTableView?.reloadData()
            //self.btnRight.setImage(UIImage(named: ""), forState: .Normal)
            
        }
        else if index == 1 {
            self.fetchDataForPACRole()
            //self.btnRight.setImage(UIImage(named: ""), forState: .Normal)
            
        }
        else {
            self.fetchDataForPACRole()
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
        objCalendarVC.pacID = self.pacID
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
        
        if(currentCell.textLabel?.text == "Edit") {
            
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
            
        }
        else if(currentCell.textLabel?.text == "Exit PAC") {
            
        }
        else if(currentCell.textLabel?.text == "Report PAC") {
            
        }
        else if(currentCell.textLabel?.text == "Delete PAC") {
            
        }
        else if(currentCell.textLabel?.text == "Edit PAC") {
            
        }
        else {
            
        }
        
    
    }
    
    
}



