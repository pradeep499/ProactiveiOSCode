//
//  PACContainerViewController.swift
//  ProactiveLiving
//
//  Created by Aseem Akarshan on 3/7/17.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit

class PACContainerViewController: UIViewController, YSLContainerViewControllerDelegate {
 
    
    //MARK:-  Properties
    var firstVC:ActivitiesVC!
    var secondVC:MyPACVC!
    var arrViewControllers = [AnyObject]()
// var dataDict = [String:AnyObject]()
    var menuArr = [AnyObject]()
    var strActivityName = ""
    
    
    
    // MARK:- Outlets
    @IBOutlet weak var lblTitle: UILabel!
    
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblTitle.text = strActivityName
        self.setUpViewControllers()
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.secondVC.fetchMyPACDataFromServer("0")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK:- Button Actions
    
    @IBAction func backButtonAction(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func rightButtonAction(sender: AnyObject) {
        
        print_debug("rightButtonAction PACContainerViewController")
    }
    
    // MARK:- Set up the Child View Controller
    
    func setUpViewControllers() {
        
        // SetUp ViewControllers
        
        let pacStoryboard = AppHelper.getPacStoryBoard()
        let mainStoryboard = AppHelper.getStoryBoard()
        
        
        firstVC = mainStoryboard.instantiateViewControllerWithIdentifier("ActivitiesVC") as! ActivitiesVC
        firstVC.title = "FIND"
        firstVC.menuTitle=""
        firstVC.arrMenueImages = menuArr
        
       // let nav = UINavigationController.init(rootViewController: firstVC)
        
        secondVC = pacStoryboard.instantiateViewControllerWithIdentifier("MyPACVC") as! MyPACVC
        secondVC.title = "MY PAC"
        
        arrViewControllers = [firstVC,secondVC]
        
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
    
    
    // MARK:- YSLContainerViewControllerDelegate
    func containerViewItemIndex(index: Int, currentController controller: UIViewController) {
        //   self.view.endEditing(true)
        print_debug("current Index : \(Int(index))")
        print_debug("current controller : \(controller)")
        //   controller.viewWillAppear(true)
        
    }
   
}
