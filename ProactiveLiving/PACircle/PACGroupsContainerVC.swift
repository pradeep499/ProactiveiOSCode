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
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var btnInvite: UIButton!
    @IBOutlet weak var btnOpenCalender: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
    
    var tokensAdmin = [AnyObject]()
    var tokensMember = [AnyObject]()
    var inviteStr = String()
    var firstVC:GenericPacTableVC!
    var secondVC:CreatePACVC!
    var thirdVC : AboutPacVC!
    var arrViewControllers = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.lbl_title.text = self.title
        btnLike.addTarget(self, action: #selector(btnLikeClick(_:)), forControlEvents: .TouchUpInside)
        btnLike.setImage(UIImage(named: "like_empty"), forState: .Normal)
        btnLike.setImage(UIImage(named: "like_filled"), forState: .Selected)
        
        tokensAdmin = [AnyObject]()
        tokensMember = [AnyObject]()
        self.setUpViewControllers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpViewControllers() {
        
        // SetUp ViewControllers
        
        let profileStoryboard = AppHelper.getPacStoryBoard()
        
        firstVC = profileStoryboard.instantiateViewControllerWithIdentifier("GenericPacTableVC") as! GenericPacTableVC
        firstVC.title = "        FIND        "
        firstVC.genericType = .Find
        
        secondVC = profileStoryboard.instantiateViewControllerWithIdentifier("CreatePACVC") as! CreatePACVC
        secondVC.title = "    CREATE A PAC    "
        
        thirdVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("AboutPacVC") as! AboutPacVC
        thirdVC.title = "About"
        
        
        arrViewControllers = [thirdVC]
        
        let containerVC = YSLContainerViewController.init(controllers: arrViewControllers, topBarHeight: 0, parentViewController: self)
        containerVC.delegate = self
        containerVC.menuItemFont = UIFont(name: "Roboto-Regular", size: 11)
        containerVC.menuItemSelectedFont = UIFont(name: "Roboto-Bold", size: 11.5)
        containerVC.menuBackGroudColor = UIColor(red: 1.0 / 255, green: 174.0 / 255, blue: 240.0 / 255, alpha: 1.0)
        containerVC.menuItemTitleColor = UIColor.whiteColor()
        containerVC.menuItemSelectedTitleColor = UIColor.whiteColor()
        //   containerVC.view.frame = CGRectMake(0, self.layOutConstrain_ivBg_height.constant, containerVC.view.frame.size.width, containerVC.view.frame.size.height - self.layOutConstrain_ivBg_height.constant)
        
        containerVC.view.frame = CGRectMake(0, 64+160, containerVC.view.frame.size.width,   screenHeight - 64 )
        
        self.view.addSubview(containerVC.view)
    }
    
    // MARK: -- YSLContainerViewControllerDelegate
    func containerViewItemIndex(index: Int, currentController controller: UIViewController) {
        //   self.view.endEditing(true)
        print("current Index : \(Int(index))")
        print("current controller : \(controller)")
        //currentIndex = index
        //   controller.viewWillAppear(true)
        
    }
    
    //MARK:- Actions
    
    func btnLikeClick(sender: UIButton) {
        sender.selected = !sender.selected
        
    }
    
    func btnInviteClick(sender: UIButton) {
        
    }
    
    @IBAction func btnOpenCalenderClick(sender: AnyObject) {
        
        let objCalendarVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("CalendarVC") as! RSDFDatePickerViewController
        objCalendarVC.fromScreen = "AboutPacVC"
        self.navigationController?.pushViewController(objCalendarVC, animated: true)
    }
    
    @IBAction func onClickBackBtn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func onClickRightBtn(sender: AnyObject) {
        
    }
    
    
}
