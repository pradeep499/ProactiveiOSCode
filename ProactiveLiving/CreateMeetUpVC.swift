//
//  CreateMeetUpVC.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 16/08/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import Foundation
class CreateMeetUpVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, TLTagsControlDelegate, GooglePlacesAutocompleteDelegate, UIDocumentMenuDelegate, UIDocumentPickerDelegate  {
    
    @IBOutlet weak var txtFieldFor: CustomTextField!
    @IBOutlet weak var txtFieldOn: CustomTextField!
    @IBOutlet weak var txtFiledAt: CustomTextField!
    @IBOutlet weak var txtFieldWhereFirst: CustomTextField!
    @IBOutlet weak var txtFieldWhereSecond: CustomTextField!
    @IBOutlet weak var txtFieldTitle: CustomTextField!
    @IBOutlet weak var contactsView: JCTagListView!
    @IBOutlet weak var imgCoverPic: UIImageView!
    @IBOutlet weak var txtViewDesc: UIPlaceHolderTextView!
    @IBOutlet weak var switchAllowInvite: UISwitch!
    @IBOutlet weak var tokenField: TLTagsControl!
    @IBOutlet weak var containerViewTF: UIView!
    @IBOutlet weak var tableAttachments: UITableView!
    @IBOutlet weak var txtDialInNum: CustomTextField!
    @IBOutlet weak var txtPin: CustomTextField!
    @IBOutlet weak var titleBar: UILabel!

    @IBOutlet weak var m_footerView: UIView!
    @IBOutlet weak var lblWithWho: UILabel!
    @IBOutlet weak var lblForTo: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    //weak var pickerView: UIPickerView!
    weak var toolBar: UIToolbar!
    var tokens = [AnyObject]()
    var arrTypes = [String]()
    var activeTextField:UITextField!
    var pickerView:UIPickerView!
    var datePicker : UIDatePicker!
    var timePicker : UIDatePicker!
    var arrAttachments = [String]()
    var gpaViewController : GooglePlacesAutocomplete!
    var pushedFrom : String!
    var isForwardAllowed : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //"AIzaSyCwX2QTq72LeMHwJ8ymH6TGGJP8iqMoFLU"
        gpaViewController = GooglePlacesAutocomplete(
            apiKey: "AIzaSyCofV_YsTjl-9lu2m4rOCj1bMmW4PS1Td0",
            placeType: .Address
        )
        txtFieldWhereSecond.addTarget(self, action: #selector(addressTextFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingDidBegin)

        if(pushedFrom=="MEETUPS")
        {
            self.titleBar.text = "New Meet Up"
            //self.arrTypes = ["We", "Heart", "Potluck"]
            self.txtFieldWhereSecond.hidden=false
            self.txtPin.hidden=true
            self.txtDialInNum.hidden=true
            self.lblWithWho.text="With"
            self.lblForTo.text="For"
            self.lblTitle.text="Meet Up Title"
        }
        else if(pushedFrom=="WEBINVITES")
        {
            self.titleBar.text = "New Web Invite"
            self.txtFieldWhereFirst.placeholder="Web Invite Link"
            //self.arrTypes = ["Conference Call", "Podcast", "Videocast", "Webinar", "Webcast"]
            self.txtFieldWhereSecond.hidden=true
            self.txtPin.hidden=false
            self.txtDialInNum.hidden=false
            self.lblWithWho.text="Who"
            self.lblForTo.text="To"
            self.lblTitle.text="Web Invite Title"
        }

        txtFieldTitle.delegate=self
        self.tokenField.tagPlaceholder = "Add here";
        //self.tokenField.mode = TLTagsControlMode.Edit ;
        self.tokenField.tagsDeleteButtonColor = UIColor.lightGrayColor()
        self.tokenField.tapDelegate=self
        
        AppHelper.setBorderOnView(self.containerViewTF)
        AppHelper.setBorderOnView(self.txtViewDesc)

        pickerView = UIPickerView()
        pickerView.frame=CGRectMake(0, screenHeight-300, screenWidth, 300)
        pickerView.backgroundColor = .whiteColor()
        
        pickerView.showsSelectionIndicator = true
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        //toolBar.tintColor = UIColor(red: 76/255, green: 17/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CreateMeetUpVC.doneTypesPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        //let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker")
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        txtFieldFor.inputView = pickerView
        txtFieldFor.inputAccessoryView = toolBar
        
        
        //Date Picker
        datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.Date
        
        let toolBar1 = UIToolbar()
        toolBar1.barStyle = UIBarStyle.Default
        toolBar1.translucent = true
        //toolBar1.tintColor = UIColor(red: 76/255, green: 17/255, blue: 100/255, alpha: 1)
        toolBar1.sizeToFit()
        
        let doneButton1 = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CreateMeetUpVC.doneDatePicker))
        toolBar1.setItems([spaceButton, doneButton1], animated: false)
        toolBar1.userInteractionEnabled = true
        
        txtFieldOn.inputView=datePicker
        txtFieldOn.inputAccessoryView = toolBar1
        
        //Time Picker
        timePicker = UIDatePicker()
        timePicker.datePickerMode = UIDatePickerMode.Time
        
        let toolBar2 = UIToolbar()
        toolBar2.barStyle = UIBarStyle.Default
        toolBar2.translucent = true
        //toolBar2.tintColor = UIColor(red: 76/255, green: 17/255, blue: 100/255, alpha: 1)
        toolBar2.sizeToFit()
        
        let doneButton2 = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CreateMeetUpVC.doneTimePicker))
        toolBar2.setItems([spaceButton, doneButton2], animated: false)
        toolBar2.userInteractionEnabled = true
        
        txtFiledAt.inputView=timePicker
        txtFiledAt.inputAccessoryView = toolBar2
        

        self.txtFieldFor.rightViewMode = UITextFieldViewMode.Always
        let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        imageView1.image = UIImage(named: "down_arrow")
        self.txtFieldFor.rightView = imageView1
        
        self.txtFieldOn.rightViewMode = UITextFieldViewMode.Always
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        imageView2.image = UIImage(named: "create_meetup_select_date")
        self.txtFieldOn.rightView = imageView2
        
        
        self.txtFiledAt.rightViewMode = UITextFieldViewMode.Always
        let imageView3 = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        imageView3.image = UIImage(named: "create_meetup_select_time")
        self.txtFiledAt.rightView = imageView3
        
        self.txtFieldWhereSecond.rightViewMode = UITextFieldViewMode.Always
        let imageView4 = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        imageView4.image = UIImage(named: "create_meetup_select_location")
        self.txtFieldWhereSecond.rightView = imageView4
        
        self.txtFieldOn.rightViewMode = UITextFieldViewMode.Always
        let imageView5 = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        imageView5.image = UIImage(named: "create_meetup_select_date")
        self.txtFieldOn.rightView = imageView5

        IQKeyboardManager.sharedManager().enableAutoToolbar=false
        IQKeyboardManager.sharedManager().enable=false
        
        let recognizer = UITapGestureRecognizer(target: self, action:#selector(GroupDetailVC.clickUserImage(_:)))
        recognizer.delegate = self
        imgCoverPic.addGestureRecognizer(recognizer)
        imgCoverPic.userInteractionEnabled = true
        imgCoverPic.layer.cornerRadius = imgCoverPic.frame.height/2
        imgCoverPic.clipsToBounds = true
        imgCoverPic.setImageWithURL(NSURL(string:""), placeholderImage: UIImage(named:"profile.png"))
        
        self.tableAttachments.separatorStyle = UITableViewCellSeparatorStyle.None
        self.txtViewDesc.placeholder = "Minimum 50 words"
        
        IQKeyboardManager.sharedManager().enable=true
        IQKeyboardManager.sharedManager().enableAutoToolbar=true

        self.getStaticDataFromServer()
    }
    
    func addCotact(contact : [String : AnyObject] ) -> Void {
        
        if (self.tokens as NSArray).containsObject(contact) {
            return
        }
        self.tokens.append(contact)
        //let lastNames = self.tokens.map({$0["firstName"]! as! String}) as [String]
        self.tokenField.tags.addObject(contact["firstName"]!)
        self.tokenField.reloadTagSubviews()
    }
    
    //MARK:- TLTagsControlDelegate
    func tagsControl(tagsControl: TLTagsControl!, tappedAtIndex index: Int) {
        print("Tag was tapped ", tagsControl.tags[index]);
    }
    func tagsControl(tagsControl: TLTagsControl!, deletedAtIndex index: Int) {
        print("Tag was deleted ", tagsControl.tags[index]);
       
        self.tokens.removeAtIndex(index)
        tagsControl.tags.removeObjectAtIndex(index)
        self.tokenField.reloadTagSubviews()
        
    }
    
    //MARK:- PICKERVIEW DELEGATE METHODS
    func pickerView(_pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrTypes.count
    }
    func numberOfComponentsInPickerView(_pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.arrTypes[row]
    }
    
    func doneTypesPicker() {
        
        if(arrTypes.count>0)
        {
        self.txtFieldFor.text = self.arrTypes[pickerView.selectedRowInComponent(0)]
        self.txtFieldFor.resignFirstResponder()
        print("done!")
        }
    }
    
    func doneDatePicker() {
        
        
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateFormat = "dd/MM/yyyy"
        let selectedDate = dateFormatter1.stringFromDate(datePicker.date)
      
        self.txtFieldOn.text = selectedDate
        self.txtFieldOn.resignFirstResponder()
        print("done!")
    }
    
    func doneTimePicker() {
        
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateFormat = "hh:mm a"
        let selectedDate = dateFormatter1.stringFromDate(timePicker.date)
        
        self.txtFiledAt.text = selectedDate
        self.txtFiledAt.resignFirstResponder()
        print("done!")
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
    }
    
    
    //mark- UITableview Delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAttachments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableAttachments.dequeueReusableCellWithIdentifier("cellAttachments", forIndexPath: indexPath) as UITableViewCell
        cell.selectionStyle = .None
        let attachmentName = cell.contentView.viewWithTag(111) as! UITextView
        let closeButton = cell.contentView.viewWithTag(222) as! UIButton
        closeButton.addTarget(self, action: #selector(btnDeleteClick(_:)), forControlEvents: .TouchUpInside)
        let backView = cell.contentView.viewWithTag(333)! as UIView
        AppHelper.setBorderOnView(backView)
        attachmentName.text=arrAttachments[indexPath.row]
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func btnDeleteClick(sender: AnyObject)  {
        print(sender)
    }
    
    @IBAction func btnDoneClick(sender: AnyObject) {
        
        if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {
            let button = sender as! UIButton

            if (self.tokens.count == 0) {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please select at least one contact.", delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                
            }
            else if (self.txtFieldFor.text!.characters.count == 0)
            {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please select type.", delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
            else if (self.txtFieldOn.text!.characters.count == 0)
            {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please select date.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                
            }
            else if (self.txtFiledAt.text!.characters.count == 0)
            {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please select time.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                
            }
            else if (self.txtFieldWhereFirst.text!.characters.count == 0)
            {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please enter address.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
            else if (self.txtFieldTitle.text!.characters.count == 0)
            {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please enter title.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                
            }
            else if (self.txtViewDesc.text!.characters.count == 0)
            {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please enter description.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                
            }
            else
            {
                
                var linksArray : NSMutableArray!
                linksArray = NSMutableArray()
                
                button.userInteractionEnabled=false
                showActivityIndicator(self.view)
                var dict = Dictionary<String,AnyObject>()
                dict["title"]=self.txtFieldTitle.text! as String
                dict["desc"]=txtViewDesc.text
                
                if(pushedFrom=="MEETUPS") {
                    dict["type"]="meetup"
                    dict["venue"]=self.txtFieldWhereFirst.text
                    dict["address"]=self.txtFieldWhereSecond.text
                }
                else {
                    dict["type"]="webinvite"
                    dict["dialInNumber"] = txtDialInNum.text ?? ""
                    dict["pin"] = txtPin.text ?? ""
                    dict["webLink"]=self.txtFieldWhereFirst.text

                }
                dict["for"]=txtFieldFor.text
                
                var dicLinks = Dictionary<String,AnyObject>()
                dicLinks["title"] = "Google"
                dicLinks["url"] = "www.google.com"
                linksArray.addObject(dicLinks)
                
                dict["links"]=linksArray
                
                dict["attachments"]="abc.png"
                dict["createdBy"]=ChatHelper.userDefaultForKey("userId") as String
                dict["eventDate"]=txtFieldOn.text
                dict["eventTime"]=txtFiledAt.text
                dict["isAllow"]=isForwardAllowed

                var userIdArray : NSMutableArray!
                userIdArray = NSMutableArray()
                
                var tempDict = Dictionary<String,AnyObject>()
                
                for myobject : AnyObject in self.tokens
                {
                    let anObject = myobject["_id"] as! String
                    tempDict["userId"]=anObject
                    //tempDict["phoneNumber"]=anObject.phoneNumber! as String
                    
                    userIdArray.addObject(tempDict);
                }
                
                tempDict["userId"]=ChatHelper.userDefaultForKey("userId") as String
                //tempDict["phoneNumber"]=ChatHelper.userDefaultForKey("PhoneNumber") as String
                
                userIdArray.addObject(tempDict)
                dict["members"] = userIdArray
                
                //group create data
                var groupDict = [String: AnyObject]()
                groupDict["userid"] = AppHelper.userDefaultsForKey(_ID)
                groupDict["groupname"] = self.txtFieldTitle.text! as String
                var userArray = [AnyObject]()
                for myobject: AnyObject in self.tokens {
                    var dataDict = [String: AnyObject]()
                    dataDict["userid"] = myobject["_id"] as! String
                    dataDict["phoneNumber"] = (myobject["mobilePhone"] as! String)
                    dataDict["user_firstName"] = (myobject["firstName"] as! String)
                    userArray.append(dataDict)
                }
                var userDict = [String: AnyObject]()
                userDict["userid"] = ChatHelper.userDefaultForKey(_ID)
                userDict["phoneNumber"] = AppHelper.userDefaultsForKey(cellNum)
                userDict["user_firstName"] = AppHelper.userDefaultsForKey(userFirstName)
                userArray.append(userDict)
                groupDict["users"] = userArray
                dict["groupDetail"] = groupDict
                
                if self.imgCoverPic.image != nil
                {
                    let imageData = UIImageJPEGRepresentation(self.imgCoverPic.image!, 1.0)
                    
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
                            
                            button.userInteractionEnabled=true
                            
                            ChatListner .getChatListnerObj().socket.emit("createMeetup_Invite", dict)
                            dispatch_after(1, dispatch_get_main_queue(), {
                                stopActivityIndicator(self.view)
                                //self.createMeetUpWithGroupChat()

                                self.navigationController?.popToRootViewControllerAnimated(true)
                            })
                            
                        }, failure:
                        {
                            operation, response -> Void in
                            // println_debug(response)
                            button.userInteractionEnabled=true
                            stopActivityIndicator(self.view)
                            
                        }
                    )
                }else
                {
                    dict["imgUrl"] = ""
                    ChatListner .getChatListnerObj().socket.emit("createMeetup_Invite", dict)
                    dispatch_after(0, dispatch_get_main_queue(), {
                        stopActivityIndicator(self.view)
                        //self.createMeetUpWithGroupChat()
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    })
                }
                
                
            }
            
        }else
        {
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Internet Connection not available.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
        }
    }
    
    func createMeetUpWithGroupChat() {
        //check internet before hitting web service
        if AppDelegate.checkInternetConnection() {
            
            var dict = [String: AnyObject]()
            dict["userid"] = AppHelper.userDefaultsForKey(_ID)
            dict["groupname"] = "MyMeetUp"
            var userIdArray = [AnyObject]()
            for myobject: AnyObject in self.tokens {
                
                var tempDict = [String: AnyObject]()
                tempDict["userid"] = myobject["_id"] as! String
                tempDict["phoneNumber"] = (myobject["mobilePhone"] as! String)
                tempDict["user_firstName"] = (myobject["firstName"] as! String)
                userIdArray.append(tempDict)
            }
            var tempDict = [String: AnyObject]()
            tempDict["userid"] = ChatHelper.userDefaultForKey(_ID)
            tempDict["phoneNumber"] = AppHelper.userDefaultsForKey(cellNum)
            tempDict["user_firstName"] = AppHelper.userDefaultsForKey(userFirstName)
            userIdArray.append(tempDict)
            dict["users"] = userIdArray
            let groupImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
            groupImage.image = self.imgCoverPic.image!
            dict["imgUrl"] = ""
            ChatListner.getChatListnerObj().socket.emit("createGroup", withItems: [dict])
           
            dispatch_after(5, dispatch_get_main_queue(), {
                stopActivityIndicator(self.view)
                
                /*
                 
                 let str:String = ChatHelper.userDefaultForKey("userId") as String!
                 let str1:String = recentChatObj.groupId as String!
                 let strPred:String = "loginUserId contains[cd] \"\(str)\" AND groupId LIKE \"\(str1)\""
                 let instance = DataBaseController.sharedInstance
                 let fetchResult=instance.fetchData("GroupList", predicate: strPred, sort: ("groupId",false))! as NSArray
                 var groupObj : GroupList!
                 for myobject : AnyObject in fetchResult
                 {
                 groupObj = myobject as! GroupList
                 
                 }
                 */
                self.navigationController?.popToRootViewControllerAnimated(true)
            })
            
        }
        else {
            AppHelper.showAlertWithTitle( "", message: serviceError, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
        }
    }
    
    @IBAction func btnAddContactClick(sender: AnyObject) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let friendListObj: AllContactsVC = storyBoard.instantiateViewControllerWithIdentifier("AllContactsVC") as! AllContactsVC
        friendListObj.fromVC="MeetUp"
        self.navigationController?.pushViewController(friendListObj, animated: true)
        
    }
    
    func getStaticDataFromServer(){
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["UserID"] = AppHelper.userDefaultsForKey(uId)
            
            //call global web service class
            Services.serviceCallWithPath(ServiceMeetUpInviteStaticData, withParam: parameters, success: { (responseDict) in
                
                print(responseDict)
                
                AppDelegate.dismissProgressHUD()
                //dissmiss indicator
                if ((responseDict["error"] as! Int) == 0) {
                    let items = responseDict["result"] as! [AnyObject]
                    self.arrTypes = items.map({$0["type"]! as! String}) as [String]
                    self.pickerView.reloadAllComponents()
                }
                else {
                    AppHelper.showAlertWithTitle(responseDict["errorMsg"] as! String, message: "", tag: 0, delegate: nil, cancelButton: "Ok", otherButton: nil)
                }
                
                }, failure: { (error) in
                    
                    AppDelegate.dismissProgressHUD()
                    //dissmiss indicator
                    AppHelper.showAlertWithTitle("", message: serviceError, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
            })
        }
        else {
            //show internet not available
            AppHelper.showAlertWithTitle(netError, message: netErrorMessage, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
        }
        
    }
    
    
    //MARK:- Image Picker Delegates
    func imagePickerController(picker:UIImagePickerController, didFinishPickingMediaWithInfo info:[String : AnyObject])
    {
        let tempImage = info[UIImagePickerControllerEditedImage] as! UIImage
        imgCoverPic.image = tempImage
        self.dismissViewControllerAnimated(true, completion: {
            //self.updateGroupDetails()
        })
        
    }
    
    func clickUserImage(recognizer:UITapGestureRecognizer)
    {
        
        if(IS_IOS_7)
        {
            let actionSheet = UIActionSheet(title: "Add Photo Through", delegate:self, cancelButtonTitle: nil, destructiveButtonTitle:nil, otherButtonTitles: "Camera","Gallery","Cancel")
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
                //Some code here..
            }
    }


    @IBAction func btnAddLinkClick(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Add Attachment", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "Add link here"
        }
        
        
        let saveAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            
            let linkTextField = alertController.textFields![0] as UITextField
            
            if (linkTextField.text?.characters.count > 0)
            {
            self.arrAttachments.append(linkTextField.text!)
            self.tableAttachments.reloadData()
            }
            print(linkTextField.text)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
       
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
       
    }
    
    @IBAction func btnAddAttachClick(sender: AnyObject) {
        
        let importMenu = UIDocumentMenuViewController(documentTypes: ["public.data","public.text","public.image"], inMode: .Import)
        importMenu.delegate = self
        importMenu.title="Attach a Document"
       
        //importMenu.addOptionWithTitle("Attach from Gallery", image: nil, order: .First, handler: {
        //print("New Doc Requested") } )
        
        presentViewController(importMenu, animated: true, completion: nil)


    }
    
    // MARK:- UIDocumentMenuDelegate
    func documentMenu(documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        presentViewController(documentPicker, animated: true, completion: nil)
    }
    
    // MARK: - UIDocumentPickerDelegate Methods
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
       
        if controller.documentPickerMode == .Import {
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.arrAttachments.append(url.lastPathComponent!)
                self.tableAttachments.reloadData()
                
            }
        }

    }
    
    func documentPickerWasCancelled(controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    @IBAction func switchAllowInviteClick(mySwitch: UISwitch) {
        
        isForwardAllowed=mySwitch.on

    }
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func addressTextFieldDidChange(textField: UITextField) {
        gpaViewController.placeDelegate = self
        presentViewController(gpaViewController, animated: true, completion: nil)
    }
    
    func placeSelected(place: Place) {
        print(place.description)
        self.txtFieldWhereSecond.text=place.description
        dismissViewControllerAnimated(true, completion: nil)
        place.getDetails { details in
            print(details.description)
        }
    }
    
    func placeViewClosed() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
