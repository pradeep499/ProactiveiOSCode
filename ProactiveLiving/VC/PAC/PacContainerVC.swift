//
//  PacContainerVC.swift
//  ProactiveLiving
//
//  Created by Affle on 15/02/2017.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit

var tokensAdmin = [AnyObject]()
var tokensMember = [AnyObject]()
var inviteStr = String()

class PacContainerVC: UIViewController,YSLContainerViewControllerDelegate {

    
    @IBOutlet weak var btnRight: UIButton!
    
    @IBOutlet weak var lbl_title: UILabel!
    
    
    var firstVC:GenericPacTableVC!
    var secondVC:CreatePACVC!
    var arrViewControllers = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lbl_title.text = self.title
        
        tokensAdmin = [AnyObject]()
        tokensMember = [AnyObject]()
        
        self.setUpViewControllers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addCotact(contact : [String : AnyObject] ) -> Void {
        if inviteStr == "admin" {
            
            if (tokensAdmin as NSArray).containsObject(contact) {
                return
            }
            tokensAdmin.append(contact)
            
        }else if inviteStr == "member" {
            
            if (tokensMember as NSArray).containsObject(contact) {
                return
            }
            tokensMember.append(contact)
        }
        

        NSNotificationCenter.defaultCenter().postNotificationName("NotifyCreatePacInvite", object: contact)
        
    }
    
    //MARK:-
    
    @IBAction func onClickBackBtn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func onClickRightBtn(sender: AnyObject) {
        
    }

    func setUpViewControllers() {
        
        // SetUp ViewControllers
        
        let profileStoryboard = AppHelper.getPacStoryBoard()
        
        firstVC = profileStoryboard.instantiateViewControllerWithIdentifier("GenericPacTableVC") as! GenericPacTableVC
        firstVC.title = "        FIND        "
        firstVC.genericType = .Find
        
        let nav = UINavigationController.init(rootViewController: firstVC)
        
        secondVC = profileStoryboard.instantiateViewControllerWithIdentifier("CreatePACVC") as! CreatePACVC
        secondVC.title = "    CREATE A PAC    "
        
        
        
        
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
    
    // MARK: -- YSLContainerViewControllerDelegate
    func containerViewItemIndex(index: Int, currentController controller: UIViewController) {
        //   self.view.endEditing(true)
        print("current Index : \(Int(index))")
        print("current controller : \(controller)")
        //currentIndex = index
        //   controller.viewWillAppear(true)
        
    }

}
