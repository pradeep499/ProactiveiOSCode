//
//  AllChatFriendsVC.swift
//  Whatsumm
//
//  Created by mawoon on 07/04/15.
//  Copyright (c) 2015 AppStudioz. All rights reserved.
//

import UIKit
//MARK:- Chat Protocol
protocol ChatProtocol
{
    func addNewFrndIngrp(frndObj:AppContactList)
}
class AllChatFriendsVC: UIViewController {

    @IBOutlet weak var segmentOutletCheck: UISegmentedControl!
    @IBOutlet weak var table_contact: UITableView!
    @IBOutlet weak var search_Ic: UIButton!
    @IBOutlet weak var searchBar1: UISearchBar!
    @IBOutlet weak var navHeightConst: NSLayoutConstraint!
    
    var delegate:ChatProtocol?
    
    var isSearchingOn : Bool!
    
    var passUserArray : NSMutableArray!
    
    var whatsummListArray : NSMutableArray!
    var fbFriendArray : NSMutableArray!
    var favListArray : NSMutableArray!
    
    
    var searchListArray : NSMutableArray!
    var fromGroupVC : NSString!
    var groupName : String!
    
    var appListIndexDic : NSMutableDictionary!
    var fbListIndexDic : NSMutableDictionary!
    var favListIndexDic : NSMutableDictionary!
    
    
    var passObject : AppContactList!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.openSearchBox()
        isSearchingOn = false
        whatsummListArray = NSMutableArray()
        fbFriendArray = NSMutableArray()
        favListArray = NSMutableArray()
        searchListArray = NSMutableArray()
        self.fetchContactFromDb();
        
        dispatch_async(dispatch_get_main_queue(), {
            self.fetchFBFriendFromDb()
            });
        dispatch_async(dispatch_get_main_queue(), {
             self.fetchFavFromDb()
            });
        
        // Do any additional setup after loading the view.
    }
    
    func openSearchBox() -> Void {
        search_Ic.selected=true
        searchBar1.hidden=false
    }
    
    override func viewWillAppear(animated: Bool) {
         super.viewWillAppear(false)
    }
    
    override func viewWillDisappear(animated: Bool) {
         super.viewWillDisappear(true)
    }
    // MARK: - UISegment Methods
    
    @IBAction func segmentControllerClick(sender: AnyObject) {
        switch sender.selectedSegmentIndex {
        case 0:
            table_contact.reloadData()
            break;
        case 1:
            table_contact.reloadData()
            break;
        case 2:
            table_contact.reloadData()
            break;
        default:
            break;
        }
    }
    
    // MARK: - FetchData from Models
    
    func fetchContactFromDb()-> Void {
        let str:String = "1"
        let strPred:String = "isFromCont contains[cd] \"\(str)\""
        self.whatsummListArray.removeAllObjects()
        let instance = DataBaseController.sharedInstance
        let fetchResult1=instance.fetchData("AppContactList", predicate: strPred, sort: ("name",true))!
        if fetchResult1.count > 0 {
            for myobject : AnyObject in fetchResult1 {
                let anObject = myobject as! AppContactList
                if fromGroupVC == "Group" {
                    if !self.passUserArray.containsObject(anObject.userId!) {
                        self.whatsummListArray.addObject(anObject);
                    }
                } else {
                    self.whatsummListArray.addObject(anObject);
                }
            }
        }
        
        let commonMthdObj: StrorePhoneContact = StrorePhoneContact()
        appListIndexDic = commonMthdObj.createDictionaryForSectionIndex(self.whatsummListArray)
        dispatch_after(0, dispatch_get_main_queue(), {
            self.table_contact.reloadData()
        })
    }
    
    func fetchFBFriendFromDb()-> Void {
        let str:String = "1"
        let str2:String = ChatHelper .userDefaultForAny("userId") as! String
        let strPred:String = "isFromFB contains[cd] \"\(str)\" AND  loginUserId contains[cd] \"\(str2)\""
        self.fbFriendArray.removeAllObjects()
        let instance = DataBaseController.sharedInstance
        let fetchResult1=instance.fetchData("AppContactList", predicate: strPred, sort: ("name",true))!
        if fetchResult1.count > 0 {
            for myobject : AnyObject in fetchResult1 {
                let anObject = myobject as! AppContactList
                if fromGroupVC == "Group" {
                    if !self.passUserArray.containsObject(anObject.userId!) {
                        self.fbFriendArray.addObject(anObject);
                    }
                } else {
                    self.fbFriendArray.addObject(anObject);
                }
            }
        }
        let commonMthdObj: StrorePhoneContact = StrorePhoneContact()
        fbListIndexDic = commonMthdObj.createDictionaryFbForSectionIndex(self.fbFriendArray)
    }
    
    func fetchFavFromDb() -> Void {
        self.favListArray.removeAllObjects()
        let instance = DataBaseController.sharedInstance
        let str="isFav == 1"
        let fetchResult2=instance.fetchData("AppContactList", predicate: str, sort: ("name",true))!
        if fetchResult2.count > 0 {
            for myobject : AnyObject in fetchResult2 {
                let anObject = myobject as! AppContactList
                if fromGroupVC == "Group" {
                    if !self.passUserArray.containsObject(anObject.userId!) {
                        self.favListArray.addObject(anObject);
                    }
                } else {
                    self.favListArray.addObject(anObject);
                }
            }
        }
        
        let commonMthdObj: StrorePhoneContact = StrorePhoneContact()
        favListIndexDic = commonMthdObj.createDictionaryFavForSectionIndex(self.favListArray)
    }
    
     // MARK: - UITableView Delegate Methods
    func tableView(tableView:UITableView!, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat {
        return 55
    }
    
    func numberOfSectionsInTableView(tableView: UITableView)-> Int {
        if tableView != self.searchDisplayController!.searchResultsTableView {
            if segmentOutletCheck.selectedSegmentIndex == 0 {
                return self.appListIndexDic.count
            } else if segmentOutletCheck.selectedSegmentIndex == 1 {
                return self.fbListIndexDic.count
            } else {
                return self.favListIndexDic.count
            }
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView!, titleForHeaderInSection  section: Int) -> String {
        if tableView != self.searchDisplayController!.searchResultsTableView {
            if segmentOutletCheck.selectedSegmentIndex == 0 {
                var airportCodes = appListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                let key = airportCodes[section] as String
                return key;
            } else if segmentOutletCheck.selectedSegmentIndex == 1 {
                var airportCodes = fbListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                let key = airportCodes[section] as String
                return key;
            } else {
                var airportCodes = favListIndexDic.allKeys as? [String]
                airportCodes = airportCodes!.sort(<)
                let key = airportCodes![section] as String
                return key;
            }
        } else {
            return " "
        }
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView)-> [AnyObject] {
        if tableView != self.searchDisplayController!.searchResultsTableView {
            if segmentOutletCheck.selectedSegmentIndex == 0 {
                var airportCodes = appListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                return airportCodes
            } else if segmentOutletCheck.selectedSegmentIndex == 1 {
                var airportCodes = fbListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                return airportCodes
            } else {
                var airportCodes = favListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                return airportCodes
            }
        } else {
            return []
        }
    }
    
    func tableView(tableView: UITableView,sectionForSectionIndexTitle title: String,atIndex index: Int)-> Int {
        if tableView != self.searchDisplayController!.searchResultsTableView {
            return index
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return searchListArray.count
        } else {
            if segmentOutletCheck.selectedSegmentIndex == 0 {
                var airportCodes = appListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                var array=[]
                array = appListIndexDic[airportCodes[section]] as! [AppContactList];
                return array.count;
            } else if segmentOutletCheck.selectedSegmentIndex == 1 {
                var airportCodes = fbListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                var array=[]
                array = fbListIndexDic[airportCodes[section]] as! [AppContactList];
                return array.count;
            } else if segmentOutletCheck.selectedSegmentIndex == 2 {
                var airportCodes = favListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                var array=[]
                array = favListIndexDic[airportCodes[section]] as! [AppContactList];
                return array.count;
            } else {
                return 0;
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell! {
        if (tableView == self.searchDisplayController!.searchResultsTableView) {
            var cell: AllChatFriendCell = self.table_contact.dequeueReusableCellWithIdentifier("Cell") as! AllChatFriendCell
            
            cell.selectionStyle = .None
            var userName = cell.userName as UILabel
            var userImage = cell.userImage as UIImageView
            userImage.image=nil;
            var anObject : AppContactList!
            if segmentOutletCheck.selectedSegmentIndex==0 {
                anObject = searchListArray[indexPath.row] as! AppContactList
                var imageString = "" //NSString(format:"%@%@", Base_imgurl,anObject.userImgString) as String
                userName.text=anObject.name
                
                if (anObject.userImgString!.characters.count > 2) {
                     userImage.setImageWithURL(NSURL(string:imageString), placeholderImage: UIImage(named:"ic_booking_profilepic"))
                } else {
                    userImage.image=UIImage(named:"ic_booking_profilepic")
                }
            } else if segmentOutletCheck.selectedSegmentIndex==1 {
                anObject = searchListArray[indexPath.row] as! AppContactList
                var imageString = "" //NSString(format:"%@%@", Base_imgurl,anObject.userImgString) as String
                userName.text=anObject.phoneName
                if (anObject.userImgString!.characters.count > 2) {
                    userImage.setImageWithURL(NSURL(string:imageString), placeholderImage: UIImage(named:"ic_booking_profilepic"))
                } else {
                    userImage.image=UIImage(named:"ic_booking_profilepic")
                }
            } else if segmentOutletCheck.selectedSegmentIndex==2 {
                anObject = searchListArray[indexPath.row] as! AppContactList
                var imageString = "" //NSString(format:"%@%@", Base_imgurl,anObject.userImgString) as String
                if anObject.isFromFB == "1" {
                    userName.text=anObject.phoneName
                } else {
                    userName.text=anObject.name
                }
                
                if (anObject.userImgString!.characters.count > 2) {
                    userImage.setImageWithURL(NSURL(string:imageString), placeholderImage: UIImage(named:"ic_booking_profilepic"))
                } else {
                    userImage.image=UIImage(named:"ic_booking_profilepic")
                }
            }
            userImage.layer.masksToBounds = true
            userImage.layer.cornerRadius = 22.5
            userName.adjustsFontSizeToFitWidth = true
            return cell
        } else {
            var cell: UITableViewCell = table_contact.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
            cell.selectionStyle = .None
            var userName = cell.contentView.viewWithTag(2) as! UILabel
            var userImage = cell.contentView.viewWithTag(1) as! UIImageView
            userImage.image=nil;
            var temp : NSDictionary!
            if segmentOutletCheck.selectedSegmentIndex==0 {
                
                var airportCodes = appListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                var array=[]
                array = appListIndexDic[airportCodes[indexPath.section]] as! [AppContactList];
                
                var anObject = array[indexPath.row] as! AppContactList
                var imageString = ""//NSString(format:"%@%@", Base_imgurl,anObject.userImgString) as String
                userName.text=anObject.name
                if (anObject.userImgString!.characters.count > 2) {
                    userImage.setImageWithURL(NSURL(string:imageString), placeholderImage: UIImage(named:"ic_booking_profilepic"))
                } else {
                    userImage.image=UIImage(named:"ic_booking_profilepic")
                }
            } else if segmentOutletCheck.selectedSegmentIndex==1 {
                var airportCodes = fbListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                var array=[]
                array = fbListIndexDic[airportCodes[indexPath.section]] as! [AppContactList];
                
                var anObject = array[indexPath.row] as! AppContactList
                var imageString = "" //NSString(format:"%@%@", Base_imgurl,anObject.userImgString) as String
                userName.text=anObject.phoneName
                if (anObject.userImgString!.characters.count > 2) {
                    userImage.setImageWithURL(NSURL(string:imageString), placeholderImage: UIImage(named:"profile.png"))
                 } else {
                    userImage.image=UIImage(named:"ic_booking_profilepic")
                }
            } else if segmentOutletCheck.selectedSegmentIndex==2 {
                var airportCodes = favListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                var array=[]
                array = favListIndexDic[airportCodes[indexPath.section]] as! [AppContactList];
                
                var anObject = array[indexPath.row] as! AppContactList
                var imageString = "" //NSString(format:"%@%@", Base_imgurl,anObject.userImgString) as String
                if anObject.isFromFB == "1" {
                    userName.text=anObject.phoneName
                } else {
                    userName.text=anObject.name
                }
                
                if (anObject.userImgString!.characters.count > 2) {
                    userImage.setImageWithURL(NSURL(string:imageString), placeholderImage: UIImage(named:"ic_booking_profilepic"))
                } else {
                    userImage.image=UIImage(named:"ic_booking_profilepic")
                }
            }
            userImage.layer.masksToBounds = true
            userImage.layer.cornerRadius = 22.5
            userName.adjustsFontSizeToFitWidth = true
            return cell
        }
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var anObject : AppContactList!
        if (tableView == self.searchDisplayController!.searchResultsTableView) {
            anObject = searchListArray[indexPath.row] as! AppContactList
            
        } else {
            if segmentOutletCheck.selectedSegmentIndex==0 {
                var airportCodes = appListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                var array=[]
                array = appListIndexDic[airportCodes[indexPath.section]] as! [AppContactList];
                
                anObject = array[indexPath.row] as! AppContactList
            } else if segmentOutletCheck.selectedSegmentIndex==1 {
                var airportCodes = fbListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                var array=[]
                array = fbListIndexDic[airportCodes[indexPath.section]] as! [AppContactList];
                anObject = array[indexPath.row] as! AppContactList
            } else {
                var airportCodes = favListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                var array=[]
                array = favListIndexDic[airportCodes[indexPath.section]] as! [AppContactList];
                anObject = array[indexPath.row] as! AppContactList
            }
        }
        
        if fromGroupVC == "Group" {
            passObject = anObject
            var alertStr : String!
            alertStr = "Add " + anObject.name! + " to " + groupName + " group?"
            if(IS_IOS_7) {
                ChatHelper.showALertWithTag(20, title: AppName, message: alertStr, delegate: self, cancelButtonTitle: "Cancel", otherButtonTitle: "OK")
            } else {
                let alertController = UIAlertController(title:AppName, message:alertStr, preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                    self.delegate?.addNewFrndIngrp(anObject)
                    self.navigationController?.popViewControllerAnimated(true)
                }))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        } else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let chatMainObj: ChattingMainVC = storyBoard.instantiateViewControllerWithIdentifier("ChattingMainVC") as! ChattingMainVC
          //   chatMainObj.contObj = anObject
            chatMainObj.isFromClass="ChatF"
             chatMainObj.isGroup="0"
            self.navigationController?.pushViewController(chatMainObj, animated: true)
        }
    }
    
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        switch View.tag {
        case 20:
         if buttonIndex == 1 {
            delegate?.addNewFrndIngrp(passObject)
            self.navigationController?.popViewControllerAnimated(true)
         }
        break;
        default:
            break;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - Search button click Method
    
    @IBAction func searchBtnClick(sender: AnyObject) {
        if navHeightConst.constant==170.0 {
            self.searchDisplayController!.active = false
            isSearchingOn = false
            search_Ic.selected=false
            searchBar1.hidden=true
            navHeightConst.constant=127.0
            self.view.layoutIfNeeded()
        } else {
            search_Ic.selected=true
            searchBar1.hidden=false
            navHeightConst.constant=170.0
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - back button click Method
    
    @IBAction func backBtnClick(sender: AnyObject) {
         self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - UISearchController Delegate Methods
    
    func filterContentForSearchText(searchText: String) {
        dispatch_async(dispatch_get_main_queue(), {
        });
        isSearchingOn=true
        if(!searchText.isEmpty) {
            if (searchListArray.count > 0) {
                searchListArray.removeAllObjects()
            }
            
            if segmentOutletCheck.selectedSegmentIndex==0 {
                let searchPredicate = NSPredicate(format: "(name BEGINSWITH[cd] %@) OR (name CONTAINS[cd] %@)",searchText," "+searchText)
                let filteredArray = whatsummListArray.filteredArrayUsingPredicate(searchPredicate)
                searchListArray.addObjectsFromArray(filteredArray)
            } else if segmentOutletCheck.selectedSegmentIndex==1 {
                let searchPredicate = NSPredicate(format: "(phoneName BEGINSWITH[cd] %@) OR (phoneName CONTAINS[cd] %@)",searchText," "+searchText)
                
                let filteredArray = fbFriendArray.filteredArrayUsingPredicate(searchPredicate)
                searchListArray.addObjectsFromArray(filteredArray)
            } else if segmentOutletCheck.selectedSegmentIndex==2 {
                let searchPredicate = NSPredicate(format: "(phoneName BEGINSWITH[cd] %@) OR (phoneName CONTAINS[cd] %@) OR (name BEGINSWITH[cd] %@) OR (name CONTAINS[cd] %@)",searchText," "+searchText,searchText," "+searchText)
                let filteredArray = favListArray.filteredArrayUsingPredicate(searchPredicate)
                searchListArray.addObjectsFromArray(filteredArray)
            }
        }
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        isSearchingOn=true
            self.filterContentForSearchText(searchString)
        
        return true
    }
    
    func searchDisplayControllerDidEndSearch(controller: UISearchDisplayController) {
        isSearchingOn = false
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
