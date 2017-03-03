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
    var inviteStr = String()
    var firstVC:WallPACVC!
    var secondVC:ResourcesPACVC!
    var pacID = String()
    
    var firstVC:NewsFeedsAllVC!
    var secondVC: RSDFDatePickerViewController!
    var thirdVC : AboutPacVC!
    var arrViewControllers = [AnyObject]()
    
    // Right button DXPopOver
    var popOverTableView:UITableView?
    var popover:DXPopover = DXPopover()
    var popoverHeight:CGFloat = 90
    var popOverCellData = [ "Edit",  "Create New"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.lbl_title.text = self.title
         
        tokensAdmin = [AnyObject]()
        tokensMember = [AnyObject]()
        self.setUpViewControllers()
        
        //popover table
        popOverTableView = UITableView()
        popOverTableView?.frame = CGRectMake(0, 0, 150, popoverHeight)
        popOverTableView?.dataSource = self
        popOverTableView?.delegate = self
        popOverTableView?.separatorStyle = .None
 
        // hide the top right button
        self.btnRight.hidden = true
        // To take button on front most
        self.view.addSubview(self.btnOpenCalender)
        self.view.bringSubviewToFront(self.btnOpenCalender)
        
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

        secondVC = profileStoryboard.instantiateViewControllerWithIdentifier("ResourcesPACVC") as! ResourcesPACVC
        secondVC.title = "    RESOURCES    "
        
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
        
        if index == 0 {
            
            self.btnRight.hidden = true
            
        }
        else if index == 1 {
            self.btnRight.hidden = false
            
        }
        else {
            self.btnRight.hidden = true

        }
    }
    
    //MARK:- Actions
    
    func btnLikeClick(sender: UIButton) {
        sender.selected = !sender.selected
        
    }
    
    func btnInviteClick(sender: UIButton) {

        
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
        
          let profileStoryboard = AppHelper.getPacStoryBoard()
        
       // if tableView == popOverTableView{
            self.popover.dismiss()
            if indexPath.row == 0 {
                
                
                
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
            else{
                
                let createEditResourcePACVC = profileStoryboard.instantiateViewControllerWithIdentifier("CreateEditResourcePACVC") as! CreateEditResourcePACVC
                 createEditResourcePACVC.pageTitle = "Create Resource"
                self.navigationController?.pushViewController(createEditResourcePACVC, animated: true)
                
        }
        
        
    
    }
    
    
}



