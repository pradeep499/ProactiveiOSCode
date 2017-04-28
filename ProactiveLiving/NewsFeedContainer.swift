//
//  NewsFeedContainer.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 22/09/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit

var currentIndex = 0
var isPostServiceCalled = false
var viewWillAppaerCount:Int!

class NewsFeedContainer: UIViewController, YSLContainerViewControllerDelegate {
    
    var arrData = [AnyObject]()
    var dataDict = [String : AnyObject]()
    var arrViewControllers = [AnyObject]()
    
    var firstVC: NewsFeedsAllVC!
    var secondVC: ExploreVC!
    var thirdVC: NewsFeedsAllVC!
    var fourthVC: NewsFeedsAllVC!
    var fifthVC: NewsFeedsAllVC!
    var sixthVC: NewsFeedsAllVC!

    var containerVC : YSLContainerViewController!

    
    
    
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var btnContacts: UIButton!
    
    
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
    //MARK:- Button action
    @IBAction func infoButtonAction(sender: AnyObject) {
        
      
        let aboutVC: AboutPASInstVC = self.storyboard!.instantiateViewControllerWithIdentifier("AboutPASInstVC") as! AboutPASInstVC
        aboutVC.strType = "home"
        aboutVC.strTitle = "HOME"
        self.navigationController?.pushViewController(aboutVC, animated: true)

        
    }
    func setUpViewControllers() {
        
        // SetUp ViewControllers
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        firstVC = storyboard.instantiateViewControllerWithIdentifier("NewsFeedsAllVC") as! NewsFeedsAllVC
        firstVC.title = "ALL"
        firstVC.view.tag = 0
        secondVC = storyboard.instantiateViewControllerWithIdentifier("ExploreVC") as! ExploreVC
        secondVC.title = "EXPLORE"
        secondVC.view.tag = 1
        thirdVC = storyboard.instantiateViewControllerWithIdentifier("NewsFeedsAllVC") as! NewsFeedsAllVC
        thirdVC.title = "FRIENDS"
        thirdVC.view.tag = 2

        fourthVC = storyboard.instantiateViewControllerWithIdentifier("NewsFeedsAllVC") as! NewsFeedsAllVC
        fourthVC.title = "COLLEAGUES"
        fourthVC.view.tag = 3

        fifthVC = storyboard.instantiateViewControllerWithIdentifier("NewsFeedsAllVC") as! NewsFeedsAllVC
        fifthVC.title = "HEALTH CLUBS"
        fifthVC.view.tag = 4
        
        sixthVC = storyboard.instantiateViewControllerWithIdentifier("NewsFeedsAllVC") as! NewsFeedsAllVC
        sixthVC.title = "PACs"   //"PAC CIRCLES" changed as per client req 27th apr
        sixthVC.view.tag = 5

        arrViewControllers = [firstVC, secondVC, thirdVC, fourthVC, fifthVC, sixthVC]
        
        
        containerVC = YSLContainerViewController.init(controllers: arrViewControllers, topBarHeight: 0, parentViewController: self)
        
        containerVC.delegate = self
        containerVC.menuItemFont = UIFont(name: "Roboto-Regular", size: 11)
        containerVC.menuItemSelectedFont = UIFont(name: "Roboto-Bold", size: 11.5)
        containerVC.menuBackGroudColor = UIColor(red: 1.0 / 255, green: 174.0 / 255, blue: 240.0 / 255, alpha: 1.0)
        containerVC.menuItemTitleColor = UIColor.whiteColor()
        containerVC.menuItemSelectedTitleColor = UIColor.whiteColor()
        containerVC.scrollMenuViewWidth = screenWidth/CGFloat(arrViewControllers.count)
        containerVC.view.frame = CGRectMake(0, 64, containerVC.view.frame.size.width, containerVC.view.frame.size.height - 64)
        self.view.addSubview(containerVC.view)
    }
    
    // MARK: -- YSLContainerViewControllerDelegate
    func containerViewItemIndex(index: Int, currentController controller: UIViewController) {
        self.view.endEditing(true)
        print("current Index : \(Int(index))")
        print("current controller : \(controller)")
        currentIndex = index
        intValue = index
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

