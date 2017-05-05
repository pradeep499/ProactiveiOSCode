//
//  VideosContainer.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 05/10/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit

var dataArr = Array<AnyObject>()
var dataArrForHeader = Array<AnyObject>()



enum VideoContainerType {
    case Profile
    case Explore
}

class VideosContainer: UIViewController, YSLContainerViewControllerDelegate {
    
    var arrServices = [AnyObject]()
    var dataDict = [String : AnyObject]?()
    var meetUpID = String()
    var arrViewControllers = [AnyObject]()
    
    var firstVC: VideosVC!
    var secondVC: VideosVC!
    var thirdVC: VideosVC!
    
    
    
    
    var currentIndex = 0
    var videoContainerType:VideoContainerType?
    //to check owner or friend not nill all time
    var viewerUserID:String!
    
    
    @IBOutlet weak var screenTitle: UILabel!
    
    
    @IBOutlet weak var btnRight: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUpViewControllers()
        
       
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
    
    
    // MARK: - setUpViewControllers
    func setUpViewControllers() {
        
        // SetUp ViewControllers
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        firstVC = storyboard.instantiateViewControllerWithIdentifier("VideosVC") as! VideosVC
        
        firstVC.videoContainerType = videoContainerType
        
        if videoContainerType == .Explore {
            
            if let val = dataDict!["Promotional"] as? [AnyObject]   {
                firstVC.dataArra = val
            }
            firstVC.title = "PROMOTIONAL"
        }else{
            firstVC.title = "PERSONAL"
            firstVC.viewerUserID = viewerUserID
        }
        
        
        secondVC = storyboard.instantiateViewControllerWithIdentifier("VideosVC") as! VideosVC
        secondVC.title = "EDUCATIONAL"
        secondVC.videoContainerType = videoContainerType
        
        
        if videoContainerType == .Explore {
            if let val = dataDict!["Educational"] as? [AnyObject] {
                secondVC.dataArra = val
            }
        }else{
            secondVC.viewerUserID = viewerUserID
        }
        
        
        
        thirdVC = storyboard.instantiateViewControllerWithIdentifier("VideosVC") as! VideosVC
        thirdVC.videoContainerType = videoContainerType
        
        if videoContainerType == .Explore {
            if let val = dataDict!["External"]  as? [AnyObject]  {
                thirdVC.dataArra =  val
            }
            thirdVC.title = "EXTERNAL"
        }else{
            
            thirdVC.title = "INSPIRATIONAL"
            thirdVC.viewerUserID = viewerUserID
        }
        
        

        let containerVC = YSLContainerViewController(controllers: [firstVC,secondVC, thirdVC], topBarHeight: 0, parentViewController: self)
        containerVC.delegate = self
        containerVC.menuItemFont = UIFont(name: "Roboto-Regular", size: 11)
        containerVC.menuItemSelectedFont = UIFont(name: "Roboto-Bold", size: 11.5)
        containerVC.menuBackGroudColor = UIColor(red: 1.0 / 255, green: 174.0 / 255, blue: 240.0 / 255, alpha: 1.0)
        containerVC.menuItemTitleColor = UIColor.whiteColor()
        containerVC.menuItemSelectedTitleColor = UIColor.whiteColor()
        containerVC.view.frame = CGRectMake(0, 64, containerVC.view.frame.size.width, containerVC.view.frame.size.height - 64)
        self.view.addSubview(containerVC.view)
        
        
        //hide right btn
        if videoContainerType == .Explore {
            self.btnRight.hidden = true
        }else if videoContainerType == .Profile {
            
            if String(AppHelper.userDefaultsForKey(_ID)) == viewerUserID{
                //Owner
                self.btnRight.hidden = false
            }else{
                //friends
                self.btnRight.hidden = true
            }
        }
    }
    
    // MARK: -- YSLContainerViewControllerDelegate
    func containerViewItemIndex(index: Int, currentController controller: UIViewController) {
        self.view.endEditing(true)
        print_debug("current Index : \(Int(index))")
        print_debug("current controller : \(controller)")
        currentIndex = index
       // controller.viewWillAppear(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -- btnBackClick
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onClickRightBtn(sender: AnyObject) {
    
        
        let vc = AppHelper.getProfileStoryBoard().instantiateViewControllerWithIdentifier("AddOrEditVideoVC") as! AddOrEditVideoVC
        vc.videoType =  "Add"
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    
    }
    
    
    
    
}
