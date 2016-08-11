//
//  CreateChatGroupVC.swift
//  Whatsumm
//
//  Created by mawoon on 06/05/15.
//  Copyright (c) 2015 AppStudioz. All rights reserved.
//

import UIKit
import MobileCoreServices

class CreateChatGroupVC: UIViewController,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate {

    @IBOutlet weak var friendTable: UITableView!
    @IBOutlet weak var segmentOutletCheck: UISegmentedControl!
    @IBOutlet weak var grpNameTextField: UITextField!
    @IBOutlet weak var groupImage: UIImageView!
    
    @IBOutlet weak var noContactAvailable_Label: UILabel!
    
    var appListIndexDic : NSMutableDictionary!
    var fbListIndexDic : NSMutableDictionary!
    var favListIndexDic : NSMutableDictionary!
    
    var selectedFriendArray : NSMutableArray!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        grpNameTextField.addTarget(self, action: #selector(CreateChatGroupVC.textFieldDidChange), forControlEvents: UIControlEvents.EditingChanged)
        
        let recognizer = UITapGestureRecognizer(target: self, action:#selector(CreateChatGroupVC.clickUserImage(_:)))
        recognizer.delegate = self
        groupImage.addGestureRecognizer(recognizer)
        groupImage.userInteractionEnabled = true
        groupImage.layer.cornerRadius = 50
        groupImage.layer.masksToBounds = true
         selectedFriendArray = NSMutableArray()
        self.noContactAvailable_Label.hidden = true
        self.fetchContactFromDb();
        
        
        
        dispatch_async(dispatch_get_main_queue(), {
            self.fetchFBFriendFromDb()
        });
        dispatch_async(dispatch_get_main_queue(), {
            self.fetchFavFromDb()
        });
        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentClick(sender: AnyObject) {
        switch sender.selectedSegmentIndex {
        case 0:
            friendTable.reloadData()
        case 1:
            friendTable.reloadData()
        case 2:
            friendTable.reloadData()
        default:
            break;
        }
    }
    
    // MARK: - FetchData from Models
    
    func fetchContactFromDb()-> Void
    {
        var whatsummListArray : NSMutableArray!
        whatsummListArray = NSMutableArray()
        let str:String = "1"
        let strPred:String = "isFromCont contains[cd] \"\(str)\""
        let instance = DataBaseController.sharedInstance
        let fetchResult1=instance.fetchData("AppContactList", predicate: strPred, sort: ("name",true))!
        if fetchResult1.count > 0
        {
            
            for myobject : AnyObject in fetchResult1
            {
                let anObject = myobject as! AppContactList
                whatsummListArray.addObject(anObject);
            }
        }
        let commonMthdObj: StrorePhoneContact = StrorePhoneContact()
        appListIndexDic = commonMthdObj.createDictionaryForSectionIndex(whatsummListArray)
        dispatch_after(0, dispatch_get_main_queue(), {
            self.friendTable.reloadData()
        })
        
    }
    
    func fetchFBFriendFromDb()-> Void
    {
        var fbFriendArray : NSMutableArray!
        fbFriendArray = NSMutableArray()
        let str:String = "1"
        let str2:String = ChatHelper .userDefaultForAny("userId") as! NSString as String
        let strPred:String = "isFromFB contains[cd] \"\(str)\" AND  loginUserId contains[cd] \"\(str2)\""
        let instance = DataBaseController.sharedInstance
        let fetchResult1=instance.fetchData("AppContactList", predicate: strPred, sort: ("name",true))!
        if fetchResult1.count > 0
        {
            for myobject : AnyObject in fetchResult1
            {
                let anObject = myobject as! AppContactList
                
                fbFriendArray.addObject(anObject);
            }
        }
        let commonMthdObj: StrorePhoneContact = StrorePhoneContact()
        fbListIndexDic = commonMthdObj.createDictionaryFbForSectionIndex(fbFriendArray)
        
    }
    
    func fetchFavFromDb() -> Void
    {
        var favListArray : NSMutableArray!
        favListArray = NSMutableArray()
        let instance = DataBaseController.sharedInstance
        let str="isFav == 1"
        let fetchResult2=instance.fetchData("AppContactList", predicate: str, sort: ("name",true))!
        if fetchResult2.count > 0
        {
            for myobject : AnyObject in fetchResult2
            {
                let anObject = myobject as! AppContactList
                
                
                favListArray.addObject(anObject);
            }
        }
        let commonMthdObj: StrorePhoneContact = StrorePhoneContact()
        favListIndexDic = commonMthdObj.createDictionaryFavForSectionIndex(favListArray)
    }
    
    
    // MARK: - UITableView Delegate Methods
    
    func tableView(tableView:UITableView!, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 55
    }
    
    func numberOfSectionsInTableView(tableView: UITableView)-> Int
    {
            if segmentOutletCheck.selectedSegmentIndex == 0
            {
                return self.appListIndexDic.count
            }
            else if segmentOutletCheck.selectedSegmentIndex == 1
            {
                return self.fbListIndexDic.count
            }
            else
            {
                return self.favListIndexDic.count
            }
    }
    
    func tableView(tableView: UITableView!, titleForHeaderInSection  section: Int) -> String
    {
            if segmentOutletCheck.selectedSegmentIndex == 0
            {
                var airportCodes = appListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                let key = airportCodes[section] as String
                //println(key)
                return key;
            }
            else if segmentOutletCheck.selectedSegmentIndex == 1
            {
                var airportCodes = fbListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                let key = airportCodes[section] as String
                //println(key)
                return key;
            }
            else
            {
                var airportCodes = favListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                let key = airportCodes[section] as String
                //println(key)
                return key;
            }
        
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView)-> [AnyObject]
    {
         if segmentOutletCheck.selectedSegmentIndex == 0
            {
                var airportCodes = appListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                return airportCodes
            }
            else if segmentOutletCheck.selectedSegmentIndex == 1
            {
                var airportCodes = fbListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                return airportCodes
            }
            else
            {
                var airportCodes = favListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                return airportCodes
            }
    }
    
    func tableView(tableView: UITableView,sectionForSectionIndexTitle title: String,atIndex index: Int)-> Int {
            return index
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
            if segmentOutletCheck.selectedSegmentIndex == 0
            {
                var airportCodes = appListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                var array=[]
                array = appListIndexDic[airportCodes[section]] as! [AppContactList];
                return array.count;
            }
            else if segmentOutletCheck.selectedSegmentIndex == 1
            {
                var airportCodes = fbListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                var array=[]
                array = fbListIndexDic[airportCodes[section]] as! [AppContactList];
                return array.count;
            }
            else if segmentOutletCheck.selectedSegmentIndex == 2
            {
                var airportCodes = favListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                var array=[]
                array = favListIndexDic[airportCodes[section]] as! [AppContactList];
                return array.count;
            }
            else
            {
                return 0;
            }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell!
    {
        
            let cell: UITableViewCell = friendTable.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
            cell.selectionStyle = .None
            let userName = cell.contentView.viewWithTag(2) as! UILabel
            let userImage = cell.contentView.viewWithTag(1) as! UIImageView
            let selectBtn = cell.contentView.viewWithTag(3) as! UIButton
        
        
            userImage.image=nil;
            if segmentOutletCheck.selectedSegmentIndex==0
            {
                
                var airportCodes = appListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                var array=[]
                array = appListIndexDic[airportCodes[indexPath.section]] as! [AppContactList];
                
                let anObject = array[indexPath.row] as! AppContactList
                let imageString = NSString(format:"%@%@", Base_imgurl,anObject.userImgString!) as String
                userName.text=anObject.name
                if (anObject.userImgString!.characters.count > 2)
                {
                    userImage.setImageWithURL(NSURL(string:imageString), placeholderImage: UIImage(named:"placeholder"))
                }else
                {
                    userImage.image=UIImage(named:"default_userImage")
                }
                
                
                if self.selectedFriendArray.containsObject(anObject)
                {
                    let image = UIImage(named: "filter_check_selected") as UIImage!
                    selectBtn.setImage(image, forState: .Normal)
                }else
                {
                    let image = UIImage(named: "filter_check_unselected") as UIImage!
                    selectBtn.setImage(image, forState: .Normal)
                }
                
            }
            else if segmentOutletCheck.selectedSegmentIndex==1
            {
                var airportCodes = fbListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                var array=[]
                array = fbListIndexDic[airportCodes[indexPath.section]] as! [AppContactList];
                
                let anObject = array[indexPath.row] as! AppContactList
                let imageString = NSString(format:"%@%@", Base_imgurl,anObject.userImgString!) as String
                userName.text=anObject.phoneName
                if (anObject.userImgString!.characters.count > 2)
                {
                    userImage.setImageWithURL(NSURL(string:imageString), placeholderImage: UIImage(named:"placeholder"))
                }else
                {
                    userImage.image=UIImage(named:"default_userImage")
                }
                
                if self.selectedFriendArray.containsObject(anObject)
                {
                    let image = UIImage(named: "filter_check_selected") as UIImage!
                    selectBtn.setImage(image, forState: .Normal)
                }else
                {
                    let image = UIImage(named: "filter_check_unselected") as UIImage!
                    selectBtn.setImage(image, forState: .Normal)
                }
               
            }
            else if segmentOutletCheck.selectedSegmentIndex==2
            {
                var airportCodes = favListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                var array=[]
                array = favListIndexDic[airportCodes[indexPath.section]] as! [AppContactList];
                
                let anObject = array[indexPath.row] as! AppContactList
                let imageString = NSString(format:"%@%@", Base_imgurl,anObject.userImgString!) as String

                if anObject.isFromFB == "1"
                {
                    userName.text=anObject.phoneName
                }else
                {
                    userName.text=anObject.name
                }
                if (anObject.userImgString!.characters.count > 2)
                {
                    userImage.setImageWithURL(NSURL(string:imageString), placeholderImage: UIImage(named:"placeholder"))
                }else
                {
                    userImage.image=UIImage(named:"default_userImage")
                }
                if self.selectedFriendArray.containsObject(anObject)
                {
                    let image = UIImage(named: "filter_check_selected") as UIImage!
                    selectBtn.setImage(image, forState: .Normal)
                }else
                {
                    let image = UIImage(named: "filter_check_unselected") as UIImage!
                    selectBtn.setImage(image, forState: .Normal)
                }
            }
            userImage.layer.masksToBounds = true
            userImage.layer.cornerRadius = 22.5
            userName.adjustsFontSizeToFitWidth = true
            return cell
        
        
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        var anObject : AppContactList!
        
            if segmentOutletCheck.selectedSegmentIndex==0
            {
                var airportCodes = appListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                var array=[]
                array = appListIndexDic[airportCodes[indexPath.section]] as! [AppContactList];
                
                anObject = array[indexPath.row] as! AppContactList
            }else if segmentOutletCheck.selectedSegmentIndex==1
            {
                var airportCodes = fbListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                var array=[]
                array = fbListIndexDic[airportCodes[indexPath.section]] as! [AppContactList];
                anObject = array[indexPath.row] as! AppContactList
            }else
            {
                var airportCodes = favListIndexDic.allKeys as! [String]
                airportCodes = airportCodes.sort(<)
                var array=[]
                array = favListIndexDic[airportCodes[indexPath.section]] as! [AppContactList];
                anObject = array[indexPath.row] as! AppContactList
            }
        if self.selectedFriendArray.containsObject(anObject)
        {
            self.selectedFriendArray.removeObject(anObject)
        }else
        {
            self.selectedFriendArray.addObject(anObject)
        }
         self.friendTable.reloadData()
        
    }
    
    //MARK:- Image Picker Delegates
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let tempImage = info[UIImagePickerControllerEditedImage] as! UIImage
        groupImage.image = tempImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func clickUserImage(recognizer:UITapGestureRecognizer)
    {
        if(IS_IOS_7)
        {
            let actionSheet = UIActionSheet(title: "Add Photo Through", delegate: self, cancelButtonTitle: nil, destructiveButtonTitle:nil, otherButtonTitles: "Camera","Gallery","Cancel")
            actionSheet.showInView( UIApplication.sharedApplication().keyWindow!)

        }
        else
        {
            let actionSheet =  UIAlertController(title: "Add Photo Through", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
            actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler:
                {(ACTION :UIAlertAction!)in
                    
                    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
                    {
                        let imagePicker = UIImagePickerController()
                        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                        imagePicker.mediaTypes = [String(kUTTypeImage)]
                        imagePicker.allowsEditing = true
                        imagePicker.delegate = self
                        self.presentViewController(imagePicker, animated: true, completion: nil)
                    }
                    
                    
            }))
            actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default, handler:
                { (ACTION :UIAlertAction!)in
                    
                    let imagePicker = UIImagePickerController()
                    imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                    imagePicker.mediaTypes = [String(kUTTypeImage)]
                    imagePicker.allowsEditing = true
                    imagePicker.delegate = self
                    
                    self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
          
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
    }
    
    //MARK:- UIActionSheet Delegates
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        switch buttonIndex{
            
        case 0:
                     //To check if camera is available
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
            {
                let imagePicker = UIImagePickerController()
                
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                imagePicker.mediaTypes = [String(kUTTypeImage)]
                imagePicker.allowsEditing = true
                imagePicker.delegate = self
           
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
            
            break;
        case 1:
            //Gallery
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.mediaTypes = [String(kUTTypeImage)]
            imagePicker.allowsEditing = true
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            break;
        default:
            self.dismissViewControllerAnimated(false, completion: nil)
            break;
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backBtnClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func doneBtnClick(sender: AnyObject)
    {
        
        let btn = sender as! UIButton
        
        if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {
            
            grpNameTextField.text!.characters.count
            if grpNameTextField.text!.characters.count == 0
            {
                if(IS_IOS_7)
                {
                    ChatHelper.showALertWithTag(121, title: APP_NAME, message: "Please enter group name.", delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                }
                else
                {
                    let alertController = UIAlertController(title:APP_NAME, message:"Please enter group name.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
            }
//            else if(selectedFriendArray.count == 0)
//            {
//                if(IS_IOS_7)
//                {
//                    ChatHelper.showALertWithTag(121, title: APP_NAME, message: "Please select at least one friend.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
//                }
//                else
//                {
//                    let alertController = UIAlertController(title:APP_NAME, message:"Please select at least one friend.", preferredStyle: UIAlertControllerStyle.Alert)
//                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//                    self.presentViewController(alertController, animated: true, completion: nil)
//                }
//                
//            }
            else
            {
                // Gaurav
                btn.userInteractionEnabled=false
                
                showActivityIndicator(self.view)
                var dict = Dictionary<String,AnyObject>()
                dict["userid"]=ChatHelper.userDefaultForKey("userId") as String
                dict["groupname"]=grpNameTextField.text! as String
                
                var userIdArray : NSMutableArray!
                userIdArray = NSMutableArray()
                
                var tempDict = Dictionary<String,AnyObject>()
                
                for myobject : AnyObject in selectedFriendArray
                {
                    let anObject = myobject as! AppContactList
                    
                    tempDict["userid"]=anObject.userId! as String
                    tempDict["phoneNumber"]=anObject.phoneNumber! as String
                    
                    userIdArray.addObject(tempDict);
                }
                
                tempDict["userid"]=dict["userid"] as! String
                tempDict["phoneNumber"]=ChatHelper.userDefaultForKey("PhoneNumber") as String
                
                userIdArray.addObject(tempDict)
                dict["users"] = userIdArray
      
                if groupImage.image != nil
                {
                    let imageData = UIImageJPEGRepresentation(groupImage.image!, 1.0)

                    let baseUrlString = ChatBaseMediaUrl+ChatMediaPath
                    let url = NSURL(string: baseUrlString)?.absoluteString
                    let manager=AFHTTPRequestOperationManager()
                    
                    manager.POST(url, parameters: nil, constructingBodyWithBlock: {
                        (formdata:AFMultipartFormData!)-> Void  in
                        
                        if(imageData != nil)
                        {
                            formdata.appendPartWithFileData(imageData, name: "files", fileName: "image.jpg" as String, mimeType: "image/jpeg")
                        }
                        
                        
                        },
                        success:
                        {
                            operation, response -> Void in
                            
                            //Parsing JSON
                            var parsedData = JSON(response)
                          //  println_debug(parsedData)
                            dict["imgUrl"] = parsedData["filesUrl"].string
              
                            btn.userInteractionEnabled=true
                            
                            ChatListner .getChatListnerObj().socket.emit("createGroup", dict)
                            dispatch_after(5, dispatch_get_main_queue(), {
                                stopActivityIndicator(self.view)
                                self.navigationController?.popToRootViewControllerAnimated(true)
                            })
                            
                        }, failure:
                        {
                            operation, response -> Void in
                           // println_debug(response)
                            //Gaurav
                            btn.userInteractionEnabled=true
                            stopActivityIndicator(self.view)
                            
                        }
                    )
                }else
                {
                    dict["imgUrl"] = ""
                        ChatListner .getChatListnerObj().socket.emit("createGroup", dict)
                    dispatch_after(5, dispatch_get_main_queue(), {
                        stopActivityIndicator(self.view)
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    })
                }
                
                
            }
        
        }else
        {
            if(IS_IOS_7)
            {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Internet Connection not available.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
            else
            {
                let alertController = UIAlertController(title:APP_NAME, message:"Internet Connection not available.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
    
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    //    MARK:- UITextField Delegates
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        grpNameTextField.resignFirstResponder()
       
        return true
    }
    
    func textFieldDidChange() -> Void
    {
        if (grpNameTextField.text!.characters.count==1 && grpNameTextField.text == " ")
        {
            let substringIndex = grpNameTextField.text!.characters.count-1
            grpNameTextField.text = grpNameTextField.text!.substringToIndex(grpNameTextField.text!.startIndex.advancedBy(substringIndex))
        }
        
        // Gaurav
        
        if(grpNameTextField.text!.characters.count>25)
        {
            grpNameTextField.deleteBackward()
        }
        
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
         grpNameTextField.resignFirstResponder()
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
