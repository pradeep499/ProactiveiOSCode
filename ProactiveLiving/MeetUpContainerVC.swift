//
//  MeetUpContainerVC.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 08/09/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import Foundation

class MeetUpContainerVC: UIViewController, YSLContainerViewControllerDelegate {
    
    var arrServices = [AnyObject]()
    var dataDict = [String : AnyObject]()
    var meetUpID = String()
    
    var mesagesVC: ChattingMainVC!
    var meetUpDetailVC: MeetUpDetailsVC!
    var currentIndex = 0
    
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var btnContacts: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUpViewControllers()
        self.btnEdit.setImage(UIImage(named: "edit")!, forState: .Normal)
        self.btnEdit.setImage(UIImage(named: "done")!, forState: .Selected)
        self.btnEdit.addTarget(self, action: #selector(btnMoreClick(_:)), forControlEvents: .TouchUpInside)
        //[self.btnEdit setTitle:@"Edit" forState:UIControlStateSelected];
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    // MARK: - preferredStatusBarStyle
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        // to set the light color of status bar
        return .LightContent
    }
    
    func setUpViewControllers() {
        
        // SetUp ViewControllers
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())

        mesagesVC = storyboard.instantiateViewControllerWithIdentifier("ChattingMainVC") as! ChattingMainVC
        mesagesVC.title = "CHAT"

        let strPred:String = "groupId contains[cd] \"57e260617c33f50cada91233\""
        let instance = DataBaseController.sharedInstance
        let recentObj=instance.fetchDataRecentChatObject("RecentChatList", predicate: strPred) as RecentChatList?
        
        if (recentObj != nil) {
            mesagesVC.isFromClass="df"
            mesagesVC.isFromDeatilScreen = "0"
            mesagesVC.recentChatObj=recentObj
            mesagesVC.isGroup="0"
            mesagesVC.manageChatTableH="0"
            mesagesVC.isGroup = "1"
        }
        
        meetUpDetailVC = storyboard.instantiateViewControllerWithIdentifier("MeetUpDetailsVC") as! MeetUpDetailsVC
        meetUpDetailVC.meetUpID=self.meetUpID
        meetUpDetailVC.title = "DETAILS"

        if(self.title == "MEET UPS")
        {
            meetUpDetailVC.screenName = "MEET UPS"
        }
        else
        {
            meetUpDetailVC.screenName = "WEB INVITES"

        }

        // ContainerView
        //float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        //float navigationHeight = self.navigationController.navigationBar.frame.size.height;
        let containerVC = YSLContainerViewController(controllers: [meetUpDetailVC,mesagesVC], topBarHeight: 0, parentViewController: self)
        containerVC.delegate = self
        containerVC.menuItemFont = UIFont(name: "Roboto-Regular", size: 11)
        containerVC.menuItemSelectedFont = UIFont(name: "Roboto-Bold", size: 11.5)
        containerVC.menuBackGroudColor = UIColor(red: 1.0 / 255, green: 174.0 / 255, blue: 240.0 / 255, alpha: 1.0)
        containerVC.menuItemTitleColor = UIColor.whiteColor()
        containerVC.menuItemSelectedTitleColor = UIColor.whiteColor()
        containerVC.view.frame = CGRectMake(0, 64, containerVC.view.frame.size.width, containerVC.view.frame.size.height - 64)
        self.view.addSubview(containerVC.view)
    }
    // MARK: -- YSLContainerViewControllerDelegate
    
    func containerViewItemIndex(index: Int, currentController controller: UIViewController) {
        self.view.endEditing(true)
        print_debug("current Index : \(Int(index))")
        print_debug("current controller : \(controller)")
        currentIndex = index
        if currentIndex == 0 {
            self.btnEdit.hidden = false
        }
        else {
            self.btnEdit.hidden = true
        }
        
        //controller.viewWillAppear(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCancelClick(sender: UIButton) {
        sender.selected = !sender.selected
        let status = (sender.selected) ? true : false
        if status {
            self.btnContacts.hidden = true
        }
        else {
            self.btnContacts.hidden = false
        }
        //mesagesVC.toggleDeleteChats(status)
    }
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func btnMoreClick(sender: AnyObject) {
    }
    
    
    @IBAction func btnCreateNewClick(sender: AnyObject) {
        
        if currentIndex == 0 {
            
        }
        else if currentIndex == 1 {
            
        }
        else  {
            
        }
        
    }
    
}
