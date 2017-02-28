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
    @IBOutlet weak var imgHeader: UIImageView!
    
    var tokensAdmin = [AnyObject]()
    var tokensMember = [AnyObject]()
    var inviteStr = String()
    var pacID = String()
    
    var firstVC:NewsFeedsAllVC!
    var secondVC: NewsFeedsAllVC!
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
        
        firstVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("NewsFeedsAllVC") as! NewsFeedsAllVC
        firstVC.title = "FRIENDS"
        
        thirdVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("AboutPacVC") as! AboutPacVC
        thirdVC.title = "ABOUT"
        thirdVC.pacID = self.pacID
        
        arrViewControllers = [thirdVC, firstVC]
        
        let containerVC = YSLContainerViewController.init(controllers: arrViewControllers, topBarHeight: 0, parentViewController: self)
        containerVC.delegate = self
        containerVC.menuItemFont = UIFont(name: "Roboto-Regular", size: 11)
        containerVC.menuItemSelectedFont = UIFont(name: "Roboto-Bold", size: 11.5)
        containerVC.menuBackGroudColor = UIColor(red: 1.0 / 255, green: 174.0 / 255, blue: 240.0 / 255, alpha: 1.0)
        containerVC.menuItemTitleColor = UIColor.whiteColor()
        containerVC.menuItemSelectedTitleColor = UIColor.whiteColor()
        //   containerVC.view.frame = CGRectMake(0, self.layOutConstrain_ivBg_height.constant, containerVC.view.frame.size.width, containerVC.view.frame.size.height - self.layOutConstrain_ivBg_height.constant)
        
        containerVC.view.frame = CGRectMake(0, 64+220, containerVC.view.frame.size.width,   screenHeight - 64 )
        
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
        self.likePACServiceCall()
    }
    
    func btnInviteClick(sender: UIButton) {
        
    }
    
    // To Like/Unlike PAC
    func likePACServiceCall() {
        
        if AppDelegate.checkInternetConnection() {

            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            parameters["pacId"] = self.pacID
            parameters["likeStatus"] = self.btnLike.selected
            
            //call global web service
            Services.postRequest(ServiceLikePAC, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        print(responseDict)
                        var resultDict = responseDict["result"] as! [String : AnyObject]
                        if((resultDict["likes"] as! [String]).count == 1) {
                            self.lblLikes.text = "\((resultDict["likes"] as! [String]).count) Like"
                        }
                        else {
                            self.lblLikes.text = "\((resultDict["likes"] as! [String]).count) Likes"
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
            //show internet not available
            AppHelper.showAlertWithTitle(netError, message: netErrorMessage, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
        }
        
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
