

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

class PacContainerVC: UIViewController,YSLContainerViewControllerDelegate,UISearchBarDelegate {

      // MARK:- Outlets
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var lbl_title: UILabel!
    
    
     // MARK:- Properties
    var firstVC:GenericPacTableVC!
    var secondVC:CreatePACVC!
    var arrViewControllers = [AnyObject]()
    var isFromMemberProfile = false
    var isFromMemberProfileForEditPAC = false
    var responseDictFromMemberProfile = [NSObject : AnyObject]()
    var arrPACMembers = [[String : AnyObject]]()
    var strActivityName = ""
    var strActivityID = ""
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.alpha = 0.0
        
        self.lbl_title.text =  strActivityName  //self.title
        
        tokensAdmin = [AnyObject]()
        tokensMember = [AnyObject]()
       // btnRight.hidden = false
        
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
    @IBAction func onClickButtonFilter(sender: AnyObject) {
        
        let filterVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("PACFilterContainer") as! PACFilterContainer
        self.navigationController?.pushViewController(filterVC, animated:true)
        
    }
    @IBAction func onClickSearchButton(sender: AnyObject) {
        
        UIView.animateWithDuration(0.1, animations: { 
            
            }) { (finished) in
                // remove the search button
                self.searchBar.alpha = 0.0;

                UIView.animateWithDuration(0.1, animations: {
                    // remove the search button
                    self.searchBar.alpha = 1.0;

                }) { (finished) in
                    
                    self.searchBar.becomeFirstResponder()
                }
        }
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.alpha = 0.0;
        self.searchBar.resignFirstResponder()
        self.firstVC.fetchPACsDataFromServer(["data" : "empty"], searchStr: "")
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.searchBar.resignFirstResponder()
        print(searchBar.text)
        self.firstVC.fetchPACsDataFromServer(["data" : "empty"], searchStr: searchBar.text!)

    }
    
    
   // MARK:- setUpViewControllers
    
    func setUpViewControllers() {
        
        // SetUp ViewControllers
        
        let profileStoryboard = AppHelper.getPacStoryBoard()
        
       if isFromMemberProfileForEditPAC == true {
           
            secondVC = profileStoryboard.instantiateViewControllerWithIdentifier("CreatePACVC") as! CreatePACVC
            secondVC.title = "EDIT PAC"
            secondVC.isFromEditPAC = true
            secondVC.responseDictPACEdit = self.responseDictFromMemberProfile
            secondVC.arrPACmembersFromMemberProfile = self.arrPACMembers
            secondVC.categoryId = strActivityID
            arrViewControllers = [secondVC]
            
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
            
        else if isFromMemberProfile == true {
            
            
            firstVC = profileStoryboard.instantiateViewControllerWithIdentifier("GenericPacTableVC") as! GenericPacTableVC
            firstVC.title = "FIND"
            firstVC.genericType = .Find
            firstVC.isForMemberProfile = true
            arrViewControllers = [firstVC]
            
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
       else {
        
        firstVC = profileStoryboard.instantiateViewControllerWithIdentifier("GenericPacTableVC") as! GenericPacTableVC
        firstVC.title = "FIND"
        firstVC.genericType = .Find
        firstVC.strId = strActivityID
        
        
        let nav = UINavigationController.init(rootViewController: firstVC)
        
        secondVC = profileStoryboard.instantiateViewControllerWithIdentifier("CreatePACVC") as! CreatePACVC
        secondVC.title = "CREATE A PAC"
        secondVC.categoryId = strActivityID
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
        
    }
    
    // MARK: -- YSLContainerViewControllerDelegate
    func containerViewItemIndex(index: Int, currentController controller: UIViewController) {
        //   self.view.endEditing(true)
        print("current Index : \(Int(index))")
        print("current controller : \(controller)")
        currentIndex = index
        controller.viewWillAppear(true)
        
        if(currentIndex == 0) {
            btnFilter.hidden = false
            btnSearch.hidden = false
        }
        else {
            btnFilter.hidden = true
            btnSearch.hidden = true
        }
        
    }

}
