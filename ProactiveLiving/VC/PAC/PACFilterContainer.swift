//
//  PACFilterContainer.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 09/03/17.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit

class PACFilterContainer: UIViewController ,YSLContainerViewControllerDelegate,UISearchBarDelegate {
    
    
    
    
    //MARK:- Outlets
    
    @IBOutlet weak var btnDone: UIButton!
    
    //MARK:- Variables
    
    var firstVC:FilterVC5!
    var secondVC:FilterVC6!
    var thirdVC:FilterVC3!
    var arrViewControllers = [AnyObject]()
    
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViewControllers()
        
    }
    
    //MARK:-  setUpViewControllers method
    
    func setUpViewControllers() {
        
        // SetUp ViewControllers
        
        let profileStoryboard = AppHelper.getStoryBoard()
        
        firstVC = profileStoryboard.instantiateViewControllerWithIdentifier("FilterVC5") as! FilterVC5
        firstVC.title = "TYPE"
        
        secondVC = profileStoryboard.instantiateViewControllerWithIdentifier("FilterVC6") as! FilterVC6
        secondVC.title = "ACTIVITY"
        
        thirdVC = profileStoryboard.instantiateViewControllerWithIdentifier("FilterVC3") as! FilterVC3
        thirdVC.title = "LOCATION"
        
        arrViewControllers = [firstVC,secondVC,thirdVC]
        
        let containerVC = YSLContainerViewController.init(controllers: arrViewControllers, topBarHeight: 0, parentViewController: self)
        
        
        containerVC.delegate = self
        containerVC.menuItemFont = UIFont(name: "Roboto-Regular", size: 11)
        containerVC.menuItemSelectedFont = UIFont(name: "Roboto-Bold", size: 11.5)
        containerVC.menuBackGroudColor = UIColor(red: 1.0 / 255, green: 174.0 / 255, blue: 240.0 / 255, alpha: 1.0)
        containerVC.menuItemTitleColor = UIColor.whiteColor()
        containerVC.menuItemSelectedTitleColor = UIColor.whiteColor()
        containerVC.view.frame = CGRectMake(0, 64, containerVC.view.frame.size.width,   screenHeight - 64 )
        
        self.view.addSubview(containerVC.view)
    }
    
    // MARK:- YSLContainerViewControllerDelegate
    func containerViewItemIndex(index: Int, currentController controller: UIViewController) {
      
        print_debug("current Index : \(Int(index))")
        print_debug("current controller : \(controller)")
        currentIndex = index
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Button Actions
    
    @IBAction func onClickBackBtn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func onClickDoneButton(sender: AnyObject) {
        
        var dataDict = [String : AnyObject]()
        dataDict["data"] = "notEmpty"
        //CreatedBy
        if(firstVC.arrSelectedRow.count > 0) {
            dataDict["createdBy"] = firstVC.arrSelectedRow[0]
        }
        //Type
        if(firstVC.switchPublic.on) {
            dataDict["type"] = "Public"
        }
        else if(firstVC.switchPrivate.on) {
            dataDict["type"] = "Private"
        }
        else if(firstVC.switchAny.on) {
            dataDict["type"] = "Any"
        }
        //Activity
        dataDict["lastActive"] = secondVC.switchLastActive.on
        
        //Location
        if(thirdVC.switch1.on) {
            dataDict["isGpsOn"] = !thirdVC.switch1.on
        }
        else if(thirdVC.switch2.on) {
            dataDict["location"] = thirdVC.searchBar.text
        }
        else if(thirdVC.switch3.on) {
            dataDict["isGpsOn"] = thirdVC.switch3.on
        }
        
        if(CLLocationManager.locationServicesEnabled()){
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            print_debug(appDelegate.currentLocation)
            dataDict["latitude"] = appDelegate.currentLocation.coordinate.latitude
            dataDict["longitude"] = appDelegate.currentLocation.coordinate.longitude
        }
        
        print_debug(dataDict)
        
        NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_PAC_FILTER, object: nil, userInfo: dataDict)

        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
}
