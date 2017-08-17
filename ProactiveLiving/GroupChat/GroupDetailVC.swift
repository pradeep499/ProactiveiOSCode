//
//  GroupDetailVC.swift
//  Whatsumm
//
//  Created by mawoon on 06/05/15.
//  Copyright (c) 2015 AppStudioz. All rights reserved.
//

import UIKit
import MobileCoreServices

class GroupDetailVC: UIViewController,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate {

    var groupObj : GroupList!
    var groupUserList : NSMutableArray!
    var groupUserPassArr : NSMutableArray!
    var groupMediaArr : NSMutableArray!
    var meRemoved : String!
    var imageChanged : Bool!
    var deletedGroup : Bool!
    
    @IBOutlet weak var editBtnOutlet: UIButton!
    @IBOutlet weak var exitBtnHeightConst: NSLayoutConstraint!
    @IBOutlet weak var mediTextLabel: UILabel!
    @IBOutlet weak var mediaBgImage: UIImageView!
    @IBOutlet weak var mediaViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var exitBtnOutlet: UIButton!
    @IBOutlet weak var addBtnOutlet: UIButton!
    @IBOutlet weak var frndTableView: UITableView!
    @IBOutlet weak var mediaCollectionView: UICollectionView!
    @IBOutlet weak var grpImgV: UIImageView!
    @IBOutlet weak var grpNameTxtF: UITextField!
    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var txtGroupName: UITextField!
    @IBOutlet weak var lblParticipants: UILabel!
    @IBOutlet weak var imgGroup: UIImageView!
    
    var deleteIndexPath:NSIndexPath!
    
//    func hideMediaView() -> Void
//    {
//        mediaViewHeightConst.constant = 0
//        mediTextLabel.hidden = true
//        mediaBgImage.hidden = true
//        mediaCollectionView.hidden = true
//    }
    
    func addNewFrndIngrp(frndObj:ChatContactModelClass)
    {
        showActivityIndicator(self.view)
        var dict = Dictionary<String,AnyObject>()
        dict["userid"]=ChatHelper.userDefaultForKey("userId") as String
        dict["groupid"]=groupObj.groupId
        dict["groupuserid"]=frndObj.userId
        dict["phoneNumber"]=frndObj.phoneNumber
        dict["user_firstName"] = frndObj.firstName
        dict["user_image"] = frndObj.userImgString
        //println(dict)
        ChatListner .getChatListnerObj().socket.emit("addInGroup", dict)
        dispatch_after(5, dispatch_get_main_queue(), {
            stopActivityIndicator(self.view)
        })
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if deletedGroup == true {
           // exitBtnOutlet.enabled=false
            //addBtnOutlet.enabled=false
           // editBtnOutlet.enabled=false
          exitBtnOutlet.setTitle("Delete group", forState: .Normal)
          
        }else{
            exitBtnOutlet.setTitle("Exit group", forState: .Normal)

        }

        editBtnOutlet.setTitle("Edit", forState: UIControlState.Normal)
        editBtnOutlet.setTitle("Done", forState: UIControlState.Selected)

        exitBtnOutlet.layer.masksToBounds = true
        exitBtnOutlet.layer.cornerRadius = 1.0
        exitBtnOutlet.layer.borderWidth = 1.0
        exitBtnOutlet.layer.borderColor = UIColor(red:48.0/255.0, green:58.0/255.0, blue:166.0/255.0,alpha:0.7).CGColor
        
        imageChanged = false
        grpNameTxtF.userInteractionEnabled = false
        editBtnOutlet.selected = false
        meRemoved = "0"
        if groupObj.adminUserId == ChatHelper.userDefaultForKey("userId") as String
        {
            addBtnOutlet.hidden = false
        }else
        {
            addBtnOutlet.hidden = true
        }
        let recognizer = UITapGestureRecognizer(target: self, action:#selector(GroupDetailVC.clickUserImage(_:)))
        recognizer.delegate = self
        grpImgV.addGestureRecognizer(recognizer)
        grpImgV.userInteractionEnabled = true
        grpImgV.layer.cornerRadius = 22.5
        grpImgV.clipsToBounds = true
        self.imgGroup.contentMode = .ScaleAspectFill
        grpImgV.setImageWithURL(NSURL(string:groupObj.groupImage!), placeholderImage: UIImage(named:"profile.png"))
        self.imgGroup.setImageWithURL(NSURL(string:groupObj.groupImage!), placeholderImage: UIImage(named:"group_img"))

        grpNameTxtF.text=groupObj.groupName
        txtGroupName.text=groupObj.groupName
        
        self.setLblCreatedDate(" ")
        
        groupUserList = NSMutableArray()
        groupUserPassArr = NSMutableArray()
        groupMediaArr = NSMutableArray()
        let str:String = ChatHelper.userDefaultForKey("userId") as String!
        let str1:String = groupObj.groupId as String!
        let str0:String = "0"
        let strPred:String = "loginUserId contains[cd] \"\(str)\" AND groupId LIKE \"\(str1)\" AND isDeletedGroup contains[cd] \"\(str0)\""
        let instance = DataBaseController.sharedInstance
        
        let fetchResult=instance.fetchData("GroupUserList", predicate: strPred, sort: ("groupId",false))! as NSArray
        
        for myobject : AnyObject in fetchResult
        {
            let groupObj = myobject as! GroupUserList
            self.groupUserList.addObject(groupObj);
            self.groupUserPassArr.addObject(groupObj.userId!)
            if groupObj.userId == ChatHelper.userDefaultForKey("userId") as String!
            {
                if groupObj.isDeletedGroup == "1"
                {
                   exitBtnHeightConst.constant = 0
                }
            }
        }

        let strType:String = "image"
        let strType1:String = "video"
        let strPred1:String = "groupId LIKE \"\(str1)\" AND (mediaTypes contains[cd] \"\(strType)\" OR mediaTypes contains[cd] \"\(strType1)\")"
        let fetchResult1=instance.fetchData("GroupChatFile", predicate: strPred1, sort: ("groupId",false))! as NSArray
        for myobject : AnyObject in fetchResult1
        {
            let groupObj = myobject as! GroupChatFile
            self.groupMediaArr.addObject(groupObj);
        }
//        if self.groupMediaArr.count == 0
//        {
//            self.hideMediaView()
//        }
        
        lblParticipants.text = String(format:"Participants %d",self.groupUserList.count)
         grpNameTxtF.addTarget(self, action: #selector(GroupDetailVC.textFieldDidChange), forControlEvents: UIControlEvents.EditingChanged)
        
        // Do any additional setup after loading the view.
        if (self.navigationController!.viewControllers[(self.navigationController!.viewControllers.count - 3)] is MeetUpDetailsVC) {
            
            exitBtnOutlet.hidden=true
            addBtnOutlet.hidden=true
            editBtnOutlet.hidden=true
            grpImgV.removeGestureRecognizer(recognizer)
        }
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = true

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GroupDetailVC.groupCreatedOrUpdatedListener(_:)),name:"groupCreateNotification", object:nil)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "groupCreateNotification", object: nil)
    }
    
    //MARK: -
    
    func setLblCreatedDate( name:String!) -> Void {
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss.sss"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
        let date = dateFormatter.dateFromString(groupObj.createdDate!)
        dateFormatter.dateFormat = "MM/yyyy"
        let dateStr = dateFormatter.stringFromDate(date!)
        createdDate.text = "Created by " + name + ", "+dateStr
    }
    
    func groupCreatedOrUpdatedListener(note:NSNotification)
    {
        stopActivityIndicator(self.view)

        let isUpdate:String = note.valueForKey("userInfo")?.valueForKey("isUpdate") as! String
        if isUpdate == "0"
        {
            stopActivityIndicator(self.view)
            groupUserList = NSMutableArray()
            groupUserPassArr = NSMutableArray()
            let str:String = ChatHelper.userDefaultForKey("userId") as String!
            let str1:String = groupObj.groupId as String!
            let str0:String = "0"
            let strPred:String = "loginUserId contains[cd] \"\(str)\" AND groupId LIKE \"\(str1)\" AND isDeletedGroup contains[cd] \"\(str0)\""
            let instance = DataBaseController.sharedInstance
            
            let fetchResult=instance.fetchData("GroupUserList", predicate: strPred, sort: ("groupId",false))! as NSArray
            
            for myobject : AnyObject in fetchResult
            {
                let groupObj = myobject as! GroupUserList
                if groupObj.userId == ChatHelper.userDefaultForKey("userId") as String!
                {
                    if groupObj.isDeletedGroup == "1"
                    {
                        meRemoved = "1"
                        addBtnOutlet.hidden = true
                        exitBtnHeightConst.constant = 0
                    }else
                    {
                        self.groupUserList.addObject(groupObj);
                        addBtnOutlet.hidden = false
                    }
                }else
                {
                    self.groupUserList.addObject(groupObj);
                    addBtnOutlet.hidden = false
                }
                self.groupUserPassArr.addObject(groupObj.userId!)
            }
            grpImgV.setImageWithURL(NSURL(string:groupObj.groupImage!), placeholderImage: UIImage(named:"profile.png"))
            self.imgGroup.setImageWithURL(NSURL(string:groupObj.groupImage!), placeholderImage: UIImage(named:"group_img"))

            grpNameTxtF.text=groupObj.groupName
            txtGroupName.text=groupObj.groupName
            lblParticipants.text = String(format:"Participants %d",self.groupUserList.count)
            frndTableView.reloadData()
            stopActivityIndicator(self.view)

        }else
        {
            grpImgV.setImageWithURL(NSURL(string:groupObj.groupImage!), placeholderImage: UIImage(named:"profile.png"))
            self.imgGroup.setImageWithURL(NSURL(string:groupObj.groupImage!), placeholderImage: UIImage(named:"group_img"))

            grpNameTxtF.text=groupObj.groupName
            txtGroupName.text=groupObj.groupName
            stopActivityIndicator(self.view)
            [self.navigationController?.popViewControllerAnimated(true)]

        }
        
        stopActivityIndicator(self.view)
    }
      // MARK: - UICollectionViewDelegate Method
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.groupMediaArr.count
    }

    //3
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: mediaCell = collectionView.dequeueReusableCellWithReuseIdentifier("mediaCell", forIndexPath: indexPath) as! mediaCell
        
        cell.backgroundColor = UIColor.redColor()
        
        let chatObj = groupMediaArr[indexPath.row] as! GroupChatFile
        
        let tempStr = chatObj.mediaLocalThumbPath! as String
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let documentsDirectory = (paths as NSString).stringByAppendingPathComponent("/ChatFile")
        let getImagePath = (documentsDirectory as NSString).stringByAppendingPathComponent(tempStr)
        let checkValidation = NSFileManager.defaultManager()
        if (checkValidation.fileExistsAtPath(getImagePath))
        {
            cell.mediImg.image = UIImage(contentsOfFile: getImagePath)
        }
        else
        {
            let decodedData = NSData(base64EncodedString: chatObj.mediaThumbUrl!, options: NSDataBase64DecodingOptions(rawValue: 0))
            if decodedData != nil
            {
                cell.mediImg.image = UIImage(data: decodedData!)
            }else
            {
                cell.mediImg.image=UIImage(named:"profile.png")
            }
        }
        if chatObj.mediaTypes == "video"
        {
            cell.videoIcon.hidden = false
        }else
        {
            cell.videoIcon.hidden = true
        }
        cell.mediImg.layer.borderWidth = 1
        cell.mediImg.layer.borderColor = UIColor(red: 178.0/255.0, green: 226.0/255.0, blue: 255.0/255.0, alpha: 1.0).CGColor
        // Configure the cell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!)
    {
        
    }
    
    //MARK: - UIScrollView delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let y: CGFloat = -scrollView.contentOffset.y
        if y > 0 {
            self.imgGroup.frame = CGRectMake(0, scrollView.contentOffset.y, screenWidth + y, 154 + y)
            self.imgGroup.center = CGPointMake(self.view.center.x, self.imgGroup.center.y)
        }
    }
    
    // MARK: - UITableViewDelegate Method
    
    func tableView(tableView:UITableView!, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 55
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
      return self.groupUserList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell!
    {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.selectionStyle = .None
        
        let userImage = cell.contentView.viewWithTag(1) as! UIImageView
        let userName = cell.contentView.viewWithTag(2) as! UILabel
        let adminLabel = cell.contentView.viewWithTag(4) as! UILabel
        
        let imgRecognizer = UITapGestureRecognizer(target: self, action:#selector(ChattingMainVC.clickFrndImage(_:)))
        imgRecognizer.delegate = self
        userImage.addGestureRecognizer(imgRecognizer)
        userImage.userInteractionEnabled = true
        
        
        let anObject = groupUserList[indexPath.row] as! GroupUserList
        
        userImage.setImageWithURL(NSURL(string:anObject.userImage!), placeholderImage: UIImage(named:"profile.png"))
        
        let nameStr = anObject.userName! as String
        let mb = ChatHelper.userDefaultForKey(cellNum) as String
        
        let trimmedString = nameStr.stringByReplacingOccurrencesOfString("+91", withString: "")
        let trimmedString1 = mb.stringByReplacingOccurrencesOfString("+91", withString: "")
       
//        if nameStr != ChatHelper.userDefaultForAny(userFirstName) as! String
//        {
//            userName.text = anObject.userName
//        }
        
        if anObject.userId! == ChatHelper.userDefaultForAny(_ID) as! String
        {
            userName.text = "You"
            
        }else{
            userName.text = anObject.userName
        }
        
        userImage.layer.masksToBounds = true
        userImage.layer.cornerRadius = 22.5

        if groupObj.adminUserId == ChatHelper.userDefaultForKey("userId") as String
        {
            //deleteBtn.hidden = false
        }else
        {
            //deleteBtn.hidden = true
        }
        
        
        if anObject.userId == groupObj.adminUserId
        {
            adminLabel.hidden = false
            //deleteBtn.hidden = true
            self.setLblCreatedDate(anObject.userName)
        }else
        {
            adminLabel.hidden = true
        }
        if meRemoved == "1"
        {
            //deleteBtn.hidden = true
        }
        return cell;
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        // by Mohammad Asim
        if (self.navigationController!.viewControllers[(self.navigationController!.viewControllers.count - 3)] is MeetUpDetailsVC)
        {
            return false
        }
        
       // by Mohammad Asim
       if groupObj.adminUserId != ChatHelper.userDefaultForKey("userId") as String || (groupUserList[indexPath.row] as! GroupUserList).userId == groupObj.adminUserId || meRemoved == "1"
        {
            return false
        }
        else
        {
            return true
        }
        
        
        

//        if indexPath.row == (self.groupUserList.count-1)
//        {
//        return false
//        }
//        else
//        {
//        return true
//        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            //frndTableView.beginUpdates()
            //Names.removeAtIndex(indexPath!.row)
            //frndTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: nil)
            //frndTableView.endUpdates()
            self.buttonDeleteClicked(indexPath)
        }
    }
    
    //MARK: - 
    
    
    func clickFrndImage(recognizer: UITapGestureRecognizer) {
        
        let location = recognizer.locationInView(frndTableView)
        let indexPath = frndTableView.indexPathForRowAtPoint(location)
        
        let vc = AppHelper.getProfileStoryBoard().instantiateViewControllerWithIdentifier("ProfileContainerVC") as! ProfileContainerVC
        
        let anObject = groupUserList[indexPath!.row] as! GroupUserList
        vc.viewerUserID = anObject.userId
        
         
        
        self.navigationController?.pushViewController(vc , animated: true)
        self.navigationController?.navigationBarHidden = true
    }
    
    func buttonDeleteClicked(index: NSIndexPath)
    {
        if deletedGroup == true
        {
            return
        }
        
        //let pointInTable = sender!.convertPoint(sender!.bounds.origin, toView: frndTableView)
        deleteIndexPath = index
        let anObject = groupUserList[deleteIndexPath.row] as! GroupUserList
        
        let strAlert = "Are you sure, you want to delete " + anObject.userName! + "?"
        if(IS_IOS_7)
        {
            ChatHelper.showALertWithTag(1000, title: APP_NAME, message: strAlert, delegate: self, cancelButtonTitle: "Cancel", otherButtonTitle: "OK")
        }
        else
        {
            let alertController = UIAlertController(title:APP_NAME, message: strAlert , preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
            }))
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                self.deleteFriend(self.deleteIndexPath)
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    func deleteFriend(indexPathD : NSIndexPath) -> Void
    {
         showActivityIndicator(self.view)
        let anObject = groupUserList[indexPathD.row] as! GroupUserList
        var dict = Dictionary<String,AnyObject>()
        dict["userid"]=ChatHelper.userDefaultForKey("userId") as String
        dict["groupdelid"]=anObject.userId
        dict["groupid"]=groupObj.groupId
        //println(dict)
        ChatListner .getChatListnerObj().socket.emit("removeFromGroup", dict)
    }
   
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int)
        {
            switch View.tag
            {
            case 1000:
                if buttonIndex == 1
                {
                    self.deleteFriend(deleteIndexPath)
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
    
    @IBAction func backBtnClick(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
        
    }

    func updateGroupDetails() {
        
        if deletedGroup==true
        {
            [self.navigationController?.popViewControllerAnimated(true)]
        }
        
        grpNameTxtF.userInteractionEnabled = false
        
        if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {
            editBtnOutlet.selected = false
            if imageChanged == true
            {
                showActivityIndicator(self.view)
                let imageData = UIImageJPEGRepresentation(grpImgV.image!, 0.8)
                var dict = Dictionary<String,AnyObject>()
                
                dict["userid"]=ChatHelper.userDefaultForKey("userId") as String
                dict["groupname"]=grpNameTxtF.text! as String
                dict["groupid"]=groupObj.groupId
                
                let baseUrlString = ChatBaseMediaUrl+ChatMediaPath
                let url = NSURL(string: baseUrlString)?.absoluteString
                
                let manager = AFHTTPRequestOperationManager()
                
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
                       // println_debug(parsedData)
                    
                        dict["imgUrl"] = parsedData["filesUrl"].string
               
                        ChatListner .getChatListnerObj().socket.emit("editGroupInfo", dict)
                        dispatch_after(5, dispatch_get_main_queue(), {
                            stopActivityIndicator(self.view)
                        })
                        
                    }, failure:
                    {
                        operation, response -> Void in
                       // println_debug(response)
                        stopActivityIndicator(self.view)
                        
                    }
                )
            }
            else
            {

                if groupObj.groupName != grpNameTxtF.text && grpNameTxtF.text?.characters.count > 0
                {
                    showActivityIndicator(self.view)

                    let myString: String = groupObj.groupImage!;
                    var myStringArr = myString.componentsSeparatedByString("?")
                    showActivityIndicator(self.view)
                    var dict = Dictionary<String,AnyObject>()
                    dict["userid"]=ChatHelper.userDefaultForKey("userId") as String
                    dict["groupname"]=grpNameTxtF.text! as String
                    dict["groupid"]=groupObj.groupId
                    
                    if (myStringArr.count > 1)
                    {
                        dict["imgUrl"] = myStringArr [1] as String
                    }else
                    {
                        dict["imgUrl"] = myStringArr [0] as String
                    }
                    
                    ChatListner .getChatListnerObj().socket.emit("editGroupInfo", dict)
                    dispatch_after(3, dispatch_get_main_queue(), {
                        stopActivityIndicator(self.view)
                    })
                    
                }else if (grpNameTxtF.text?.characters.count == 0)
                {
                    ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please enter group name.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                }
            }
            imageChanged = false
            
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
    
    @IBAction func addMoreFrndBtn(sender: AnyObject)
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let friendListObj: AllContactsVC = storyBoard.instantiateViewControllerWithIdentifier("AllContactsVC") as! AllContactsVC
        //friendListObj.passUserArray = self.groupUserPassArr
        //friendListObj.fromGroupVC="Group"
        //friendListObj.groupName = self.groupObj.groupName
        self.navigationController?.pushViewController(friendListObj, animated: true)
    }
    
    @IBAction func exitGroupBtnClick(sender: AnyObject)
    {        
        self.openDeleteActionSheet()
    }
    
    @IBAction func editBtnClick(sender: AnyObject)
    {
        // Gaurav
        
        if editBtnOutlet.selected == false
        {
            editBtnOutlet.selected = true
            grpNameTxtF.userInteractionEnabled = true
            grpNameTxtF.becomeFirstResponder()
        }else
        {
            editBtnOutlet.selected = false
            grpNameTxtF.userInteractionEnabled = false
            self.updateGroupDetails()
        }
    }
    
    
    //MARK:- Image Picker Delegates
    func imagePickerController(picker:UIImagePickerController, didFinishPickingMediaWithInfo info:[String : AnyObject])
    {
        imageChanged = true
        let tempImage = info[UIImagePickerControllerEditedImage] as! UIImage
        grpImgV.image = tempImage
        self.dismissViewControllerAnimated(true, completion: {
        self.updateGroupDetails()
        })
        
    }
    
    func clickUserImage(recognizer:UITapGestureRecognizer)
    {
        if deletedGroup == true
        {
            return;
        }
        
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
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
                            switch authStatus {
                            case .Authorized:
                              self.presentViewController(imagePicker, animated: true, completion: nil)
                                break
                            case .Denied:
                                AppHelper.showAlertWithTitle(AppName, message:cameraSetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                            case .NotDetermined:
                                AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo,
                                    completionHandler: { (granted:Bool) -> Void in
                                        if granted {
                                          self.presentViewController(imagePicker, animated: true, completion: nil)
                                        }
                                        else {
                                            AppHelper.showAlertWithTitle(AppName, message:cameraSetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                                        }
                                })
                            default:
                                AppHelper.showAlertWithTitle(AppName, message:cameraSetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                                
                            }
                        })
                        
                        //self.presentViewController(imagePicker, animated: true, completion: nil)
                    }
                    
                    
            }))
            actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default, handler:
                { (ACTION :UIAlertAction!)in
                    
                    let imagePicker = UIImagePickerController()
                    imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                    imagePicker.mediaTypes = [String(kUTTypeImage)]
                    imagePicker.allowsEditing = true
                    imagePicker.delegate = self
                   
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)//PHPhotoLibrary.authorizationStatus()
                        switch authStatus {
                        case .Authorized:
                            self.presentViewController(imagePicker, animated: true, completion: nil)
                        break // Do your stuff here i.e. allowScanning()
                        case .Denied:
                            AppHelper.showAlertWithTitle(AppName, message:gallerySetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                        case .NotDetermined:
                            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { granted in
                                if granted {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.presentViewController(imagePicker, animated: true, completion: nil)

                                    }
                                }
                            })
                        default:
                            AppHelper.showAlertWithTitle(AppName, message:gallerySetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                        }
                    })
                    
//                    self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
    }
    
    //MARK:- UIActionSheet Delegates
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        if actionSheet.tag==200
        {
            if buttonIndex==0
            {
                var dict = Dictionary<String,AnyObject>()
                dict["userid"]=ChatHelper.userDefaultForKey("userId") as String
                dict["groupdelid"]=ChatHelper.userDefaultForKey("userId") as String
                dict["groupid"]=groupObj.groupId
                ChatListner .getChatListnerObj().socket.emit("removeFromGroup", dict)
                

            }
        }else
            
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
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
                    switch authStatus {
                    case .Authorized:
                       self.presentViewController(imagePicker, animated: true, completion: nil)
                        break
                    case .Denied:
                        AppHelper.showAlertWithTitle(AppName, message:cameraSetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    case .NotDetermined:
                        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo,
                            completionHandler: { (granted:Bool) -> Void in
                                if granted {
                                   self.presentViewController(imagePicker, animated: true, completion: nil)
                                }
                                else {
                                    AppHelper.showAlertWithTitle(AppName, message:cameraSetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                                }
                        })
                    default:
                        AppHelper.showAlertWithTitle(AppName, message:cameraSetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                        
                    }
                })
                
                //self.presentViewController(imagePicker, animated: true, completion: nil)
            }
            
            break;
        case 1:
            //Gallery
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.mediaTypes = [String(kUTTypeImage)]
            imagePicker.allowsEditing = true
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)//PHPhotoLibrary.authorizationStatus()
                switch authStatus {
                case .Authorized:
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                break // Do your stuff here i.e. allowScanning()
                case .Denied:
                    AppHelper.showAlertWithTitle(AppName, message:gallerySetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                case .NotDetermined:
                    AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { granted in
                        if granted {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.presentViewController(imagePicker, animated: true, completion: nil)
                            }
                        }
                    })
                default:
                    AppHelper.showAlertWithTitle(AppName, message:gallerySetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                }
            })
            
            
            
//            self.presentViewController(imagePicker, animated: true, completion: nil)
       
            break;
        default:
            self.dismissViewControllerAnimated(false, completion: nil)
            break;
            //Some code here..
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChange() -> Void
    {
        if(grpNameTxtF.text!.characters.count==1 && grpNameTxtF.text == " ")
        {
            let substringIndex = grpNameTxtF.text!.characters.count-1
            grpNameTxtF.text = grpNameTxtF.text!.substringToIndex(grpNameTxtF.text!.startIndex.advancedBy(substringIndex))
        }
        
        // Gaurav
        
        if(grpNameTxtF.text!.characters.count>25)
        {
            grpNameTxtF.deleteBackward()
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        editBtnOutlet.selected = false
        grpNameTxtF.userInteractionEnabled = false
        grpNameTxtF.resignFirstResponder()
    }
    
    
    func openDeleteActionSheet() -> Void
    {
      
        var str = ""
        
        if  deletedGroup == true {
             str = "Delete group"
        }else{
            str  = "Exit group"
            
        }
        
        if(IS_IOS_7)
        {
            let actionSheet = UIActionSheet(title: groupObj.groupName, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle:nil, otherButtonTitles: str,"Cancel")
            actionSheet.tag=200
            actionSheet.showFromTabBar((self.tabBarController?.tabBar)!)
        }
        else
        {
            let actionSheet =  UIAlertController(title: groupObj.groupName, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            actionSheet.addAction(UIAlertAction(title: str, style: UIAlertActionStyle.Default, handler:
                { (ACTION :UIAlertAction!)in
                    
                    if self.deletedGroup == true {  // delete action
                        let strLogin:String = ChatHelper .userDefaultForAny("userId") as! String
                        let strGroupId:String = self.groupObj.groupId! as String
                        let strPred:String = "loginUserId contains[cd] \"\(strLogin)\" AND groupId LIKE \"\(strGroupId)\""
                        
                        let instance = DataBaseController.sharedInstance
                        
                        instance.deleteData("GroupChat", predicate: strPred)
                        instance.deleteData("RecentChatList", predicate: strPred)
                        instance.deleteData("GroupList", predicate: strPred)
                        instance.deleteData("GroupUserList", predicate: strPred)
                        self.navigationController?.popToRootViewControllerAnimated(true)

                        
                    }else{ // exit group
                        var dict = Dictionary<String,AnyObject>()
                        dict["userid"]=ChatHelper.userDefaultForKey("userId") as String
                        dict["groupdelid"]=ChatHelper.userDefaultForKey("userId") as String
                        dict["groupid"]=self.groupObj.groupId
                        
                        ChatListner .getChatListnerObj().socket.emit("removeFromGroup", dict)
                        self.navigationController?.popViewControllerAnimated(true)

                    }
                    
                   
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (ACTION :UIAlertAction!)in
               
            }))
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
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
