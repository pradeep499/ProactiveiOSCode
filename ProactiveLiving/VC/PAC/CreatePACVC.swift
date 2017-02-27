//
//  CreatePACVC.swift
//  ProactiveLiving
//
//  Created by Affle on 15/02/2017.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit

class CreatePACVC: UIViewController, TLTagsControlDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GooglePlacesAutocompleteDelegate, UIDocumentMenuDelegate, UIDocumentPickerDelegate  {

    
    @IBOutlet weak var tf_ProActiveName: CustomTextField!
    
    @IBOutlet weak var tv_desc: UITextView!//UIPlaceHolderTextView!
    
    @IBOutlet weak var iv_coverPic: UIImageView!
    
    @IBOutlet weak var tf_location: CustomTextField!
    
    @IBOutlet weak var tf_zip: CustomTextField!
    
    @IBOutlet weak var tokenF_inviteAdmin: TLTagsControl!
    
    @IBOutlet weak var tokenF_inviteMember: TLTagsControl!
    
    
    @IBOutlet weak var tv_CreatePac: UITableView!
    
    
    @IBOutlet weak var switch_settting_private: UISwitch!
    
    @IBOutlet weak var switch_settting_createMeetUp: UISwitch!
    
    @IBOutlet weak var switch_settting_CreateWebInvite: UISwitch!
    
    @IBOutlet weak var switch_settting_uploadPic: UISwitch!
    
    @IBOutlet weak var switch_visible_every: UISwitch!
    
    @IBOutlet weak var switch_visible_Friend: UISwitch!
    
    @IBOutlet weak var switch_visible_colleagues: UISwitch!
    
    @IBOutlet weak var switch_visible_healthClub: UISwitch!
    
    
    @IBOutlet weak var switch_visible_male: UISwitch!
    
    @IBOutlet weak var switch_visible_female: UISwitch!
    
    
    @IBOutlet weak var btnIAgree: UIButton!
    
    var gpaViewController : GooglePlacesAutocomplete!
    var arrAttachments = [AnyObject]()
  
    var switchStatus = [1,1,1,1,1,1,1,1,1,1];
    var parameters = [String: AnyObject]()
    
    var adminArr = [AnyObject]()
    var memberArr = [AnyObject]()
    var tagIDMember = [AnyObject]()
    var tagIDAdmin = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreatePACVC.NotifyCreatePacInvite(_:)),name:"NotifyCreatePacInvite", object:nil)
        self.tv_CreatePac.dataSource = self
        
        // self.tokenField.tapDelegate=self
//        self.tokenF_inviteAdmin.delegate = self
//        self.tokenF_inviteMember.delegate = self
        
        self.tokenF_inviteAdmin.tapDelegate = self
        self.tokenF_inviteMember.tapDelegate = self

        
        
        
        self.tokenF_inviteAdmin.tagPlaceholder = "Add here"
        self.tokenF_inviteMember.tagPlaceholder = "Add here"
        
        
        self.setUpPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpPage() -> Void {
        
       
        let recognizer = UITapGestureRecognizer(target: self, action:#selector(GroupDetailVC.clickUserImage(_:)))  // need to change
        recognizer.delegate = self
        self.iv_coverPic.addGestureRecognizer(recognizer)
        self.iv_coverPic.userInteractionEnabled = true
        self.iv_coverPic.layer.cornerRadius = self.iv_coverPic.frame.height/2
        self.iv_coverPic.clipsToBounds = true
        self.iv_coverPic.setImageWithURL(NSURL(string:""), placeholderImage: UIImage(named:"profile.png"))
        
        
       // self.tv_desc.placeholder = "Minimum 50 words"
        // by me
        self.tv_desc.setCornerRadiusWithBorderWidthAndColor(3, borderWidth: 1, borderColor: UIColor(red: 145.0/255.0, green: 145.0/255.0, blue: 145.0/255.0, alpha: 0.2))
        
        
        self.tf_location.addTarget(self, action: #selector(addressTextFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingDidBegin)
        
        
        gpaViewController = GooglePlacesAutocomplete(
            apiKey: "AIzaSyCofV_YsTjl-9lu2m4rOCj1bMmW4PS1Td0",
            placeType: .Address
        )
        
        IQKeyboardManager.sharedManager().enable=true
        IQKeyboardManager.sharedManager().enableAutoToolbar=true
    }
    
    
  // MARK: Token add
    
    
    func reSetInviteTag(contact : [String : AnyObject] ) -> Void {
        
        if inviteStr == "admin" {
            
            
//            tokenF_inviteAdmin.tags.addObject(contact["firstName"]!)
//            tokenF_inviteAdmin.reloadTagSubviews()
            tokenF_inviteAdmin.addTag(contact["firstName"]! as! String)
        //    tokenF_inviteAdmin.tags.addObject(contact["firstName"]!)
            
            // tokenF_inviteAdmin.addTag(contact["firstName"]! as! String)
            
            // self.adminDict = contact
            
              self.adminArr.append(contact)
            
            
            
        }else if inviteStr == "member" {
            
//            tokenF_inviteMember.tags.addObject(contact["firstName"]!)
//            tokenF_inviteMember.reloadTagSubviews()
           
            tokenF_inviteMember.addTag(contact["firstName"]! as! String)
          //  tokenF_inviteMember.tags.addObject(contact["firstName"]!)
          //  tokenF_inviteMember.addTag(contact["firstName"]! as! String)
            
          //  self.memberDict = contact
            
            self.memberArr.append(contact)
            
            
        }
        
        
    }
    
    
    func NotifyCreatePacInvite(notification:NSNotification) {
      //  print(notification)
        let dicContact = notification.object as! [String : AnyObject]
        self.reSetInviteTag( dicContact )
    }
    
     

 
    //MARK:- Btn Action
    
    // UISwitch  action to change status
    @IBAction func onSwitchValueChanged(sender: AnyObject) {
        
        var value = 1
        if (sender as! UISwitch).on {
            value = 1
        } else {
            value = 0
        }
        
        switch(sender.tag) {
        case 101:
            switchStatus[0] = value
        case 102:
            switchStatus[1] = value
        case 103:
            switchStatus[2] = value
        case 104:
            switchStatus[3] = value
        case 105:
            switchStatus[4] = value
        case 106:
            switchStatus[5] = value
        case 107:
            switchStatus[6] = value
        case 108:
            switchStatus[7] = value
        case 109:
            switchStatus[8] = value
        case 110:
            switchStatus[9] = value
        default :
            break
        }
        print(switchStatus)
    }
    
    func goToContact(type:String) -> Void {
        
        inviteStr = type
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let friendListObj: AllContactsVC = storyBoard.instantiateViewControllerWithIdentifier("AllContactsVC") as! AllContactsVC
        friendListObj.fromVC="CREATEPAC"
        self.navigationController?.pushViewController(friendListObj, animated: true)
        
    }
    
    
    @IBAction func onClickInviteAdminBtn(sender: AnyObject) {
        
        self.goToContact("admin")
        
    }
    
    
    @IBAction func onClickInviteMemberBtn(sender: AnyObject) {
        
        self.goToContact("member")
        
    }
    
    @IBAction func onClickAddLinkBtn(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Add Link", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "Add title here"
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "Add link here"
        }
        
        let saveAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            
            let titleTextField = alertController.textFields![0] as UITextField
            
            let linkTextField = alertController.textFields![1] as UITextField
            
            var dict = Dictionary<String,AnyObject>()
            
            if (titleTextField.text?.characters.count > 0 && linkTextField.text?.characters.count > 0)
            {
                dict["title"]=titleTextField.text! as String
                dict["url"]=linkTextField.text
                
                self.arrAttachments.append(dict)
                self.tv_CreatePac.reloadData()
            }
            else
            {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please input both title and url.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
            
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func onClickAttachmentBtn(sender: AnyObject) {
        
        let importMenu = UIDocumentMenuViewController(documentTypes: ["public.data","public.text","public.image"], inMode: .Import)
        importMenu.delegate = self
        importMenu.title="Attach a Document"
        
        //importMenu.addOptionWithTitle("Attach from Gallery", image: nil, order: .First, handler: {
        //print("New Doc Requested") } )
        
        presentViewController(importMenu, animated: true, completion: nil)
        
        
    }
    
    // Terms and condition
    @IBAction func onClickAgree(sender: AnyObject) {
        
        self.btnIAgree.selected = !self.btnIAgree.selected
        
        if self.btnIAgree.selected {
            
            self.btnIAgree.setImage(UIImage.init(named: "ic_bookingpopup_radioselect"), forState: .Normal)
            
            self.btnIAgree.tag = 10
            
            
        }else{
            
            self.btnIAgree.setImage(UIImage.init(named: "ic_bookingpopup_radio"), forState: .Normal)
            
            self.btnIAgree.tag = 11
            
        }
       
    }
    
    
    // MARK: Submit button for API hit
    
    @IBAction func onClickSubmitBtn(sender: AnyObject) {
        
        print("Submit btn pressed")
       
        if(isEmpty()){
            
             submitAPI()
            
        }
        
    }
    
    //MARK: - Switch
    
    
//    @IBAction func onChangeSwitch_settingPrivate(sender: AnyObject) {
//    
//    }
//    
//    @IBAction func onChangeSwitch_settingCreateMeetUp(sender: AnyObject) {
//    
//    }
//    
//    @IBAction func onChangeSwitch_settingCreaeWebInvite(sender: AnyObject) {
//    
//    }
//    
//    
//    
//    @IBAction func onChangeSwitch_settingUploadPic(sender: AnyObject) {
//    }
//    
//    
//    @IBAction func onChangeSwitch_visibleEvery(sender: AnyObject) {
//    }
//    
//    @IBAction func onChangeSwitch_visibleFriends(sender: AnyObject) {
//    }
//    
//    @IBAction func onChangeSwitch_visibleColleagues(sender: AnyObject) {
//    }
//    
//    
//    @IBAction func onChangeSwitch_visibleHealthClub(sender: AnyObject) {
//    }
//    
//    
//    @IBAction func onChangeSwitch_visibleMale(sender: AnyObject) {
//    }
//    
//    @IBAction func onChangeSwitch_visibleFemale(sender: AnyObject) {
//    }
//    
    
    //MARK:- Is Empty Validation
    
    func isEmpty() -> Bool {
        
        
        let descriptionStr = tv_desc.text
        
        if ((tf_ProActiveName.text?.isEmpty) == true){
        
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Title Field can't be left blank!", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)

            return false
            
        }
        
        else if descriptionStr.characters.count <= 50 {
            
             ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Description Field should have minimum 50 words!", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            
            return false
            
        }
        else if((tf_location.text?.isEmpty) == true){
            
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Location Field can't be left blank!", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            
            return false

           
        }
        else if((tf_zip.text?.isEmpty) == true){
            
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Zip Field can't be left blank!", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            
            return false
            
        }
        else if( tokenF_inviteMember.tags.count == 0){
            
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please add at least one member!", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            
            return false
        }
        else if( self.btnIAgree.tag == 11){
           
            
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please select the Terms & condition!", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            
            return false
     
        }
  
        return true
    }
    
    
    
    
    
    //MARK:- Image Picker Delegates
    func imagePickerController(picker:UIImagePickerController, didFinishPickingMediaWithInfo info:[String : AnyObject])
    {
        let tempImage = info[UIImagePickerControllerEditedImage] as! UIImage
        self.iv_coverPic.image = tempImage
        self.dismissViewControllerAnimated(true, completion: {
            //self.updateGroupDetails()
        })
        
    }
    
    // Action for Upload Cover Picture
    func clickUserImage(recognizer:UITapGestureRecognizer)
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
    
    
    func addressTextFieldDidChange(textField: UITextField) {
        gpaViewController.placeDelegate = self
        presentViewController(gpaViewController, animated: true, completion: nil)
    }
    
    func placeSelected(place: Place) {
        print(place.description)
        self.tf_location.text=place.description
        dismissViewControllerAnimated(true, completion: nil)
        place.getDetails { details in
           // self.strLatLong = "\(details.latitude),\(details.longitude)"
            print(details.description)
        }
    }
    
    func placeViewClosed() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK:- UIDocumentMenuDelegate
    func documentMenu(documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        presentViewController(documentPicker, animated: true, completion: nil)
    }
    
    
    
    //MARK:- TLTagsControlDelegate
    func tagsControl(tagsControl: TLTagsControl!, tappedAtIndex index: Int) {
        print("Tag was tapped ", tagsControl.tags[index]);
    }
    
    
    
    func tagsControl(tagsControl: TLTagsControl!, deletedAtIndex index: Int) {
        print("Tag was deleted ", tagsControl.tags[index]);
      
     // self.tokens.removeAtIndex(index)
        tagsControl.tags.removeObjectAtIndex(index)
        self.tokenF_inviteMember.reloadTagSubviews()
        
    }
    
    
    
    // MARK: - UIDocumentPickerDelegate Methods
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        
        if controller.documentPickerMode == .Import {
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.arrAttachments.append(url.lastPathComponent!)
                self.tv_CreatePac.reloadData()
                
            }
        }
        
    }
    
    func documentPickerWasCancelled(controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    
    //MARK : API hit
    
    func submitAPI() -> Void {
        
       // print("ADMIN TAG ### \(self.adminDict["_id"])")
        
        // self.tokenField.tags.addObject(contact["firstName"]!)
       
        print("MEMBER TAG ### \(self.memberArr)")
        
       
        
        for i in 0  ..< memberArr.count  {
        
            let str = memberArr[i]["_id"] as! String
            self.tagIDMember.append(str)
            
        }
        
        for i in 0  ..< adminArr.count  {
            
            let str = adminArr[i]["_id"] as! String
            self.tagIDAdmin.append(str)
            
        }

        
        
        print("TEST hahah \(self.tagIDAdmin)")

        
        print("TEST hahah \(self.tagIDMember)")
     
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
           
            //  var parameters = [String: AnyObject]()
            // parameters["AppKey"] = AppKey
           // parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
           
             parameters = ["name" : self.tf_ProActiveName.text!,
                           "description" : self.tv_desc.text,
                           "createdBy"   : AppHelper.userDefaultsForKey(_ID),
                           "address"     : self.tf_location.text!,
                           "zipcode"     : self.tf_zip.text!,
                          "admins"       : self.tagIDAdmin,
                         "members"       : self.tagIDMember,
                         "attachements"  : self.arrAttachments,
                         "private"       : self.switchStatus[0],
                "allowToCreateMeetup"    : self.switchStatus[1],
                "allowToCreateWebinvite"  : self.switchStatus[2],
                "allowToUpload"           : self.switchStatus[3],
                "everyone"                 : self.switchStatus[4],
                "friends"                   : self.switchStatus[5],
                "colleagues"               : self.switchStatus[6],
                "healthClub"                : self.switchStatus[7],
                "males"                     : self.switchStatus[8],
                "females"                   : self.switchStatus[9],
                "categoryId"                :["123sdfsd"]
            
  ]
       
            
            print("Parameters before : \(parameters)")
            
            
            if self.iv_coverPic.image != nil
            {
                let imageData = UIImageJPEGRepresentation(self.iv_coverPic.image!, 1.0)
                
                let baseUrlString = ChatBaseMediaUrl+ChatMediaPath
                let url = NSURL(string: baseUrlString)?.absoluteString
                let manager=AFHTTPRequestOperationManager()
                
                manager.POST(url, parameters: nil, constructingBodyWithBlock: {
                    (formdata:AFMultipartFormData!)-> Void  in
                    
                    if(imageData != nil)
                    {
                        formdata.appendPartWithFileData(imageData, name: "files", fileName: "image.jpg" as String, mimeType: "image/jpeg")
                    }
                    
                    
                    }, success:
                    {
                        operation, response -> Void in
                        
                        //Parsing JSON
                        var parsedData = JSON(response)
                        self.parameters["imgUrl"] = parsedData["filesUrl"].string
                        print("URL \(parsedData["filesUrl"].string)")
                        //call global web service class latest
                        Services.postRequest(ServiceCreatePAC, parameters: self.parameters, completionHandler:{
                            (status,responseDict) in
                            
                            AppDelegate.dismissProgressHUD()
                            
                            if (status == "Success") {
                                
                                if ((responseDict["error"] as! Int) == 0) {
                                    
                                    print(responseDict["result"])
                                    
                                    let msg = "PAC created."
                                    
                                    
                                    AppHelper.showAlertWithTitle(AppName, message:msg, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                                    
                                }
                                
                            } else if (status == "Error"){
                                
                                AppHelper.showAlertWithTitle(AppName, message: serviceError, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                                
                            }
                        })
              
                    }, failure:
                    {
                        operation, response -> Void in
                         print(response)
                   
                        stopActivityIndicator(self.view)
                        
                    }
                )
            }
            
        }
        else {
            AppDelegate.dismissProgressHUD()
            //show internet not available
            AppHelper.showAlertWithTitle(netError, message: netErrorMessage, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
        }

        
        
        
      /*  if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {
        //    let button = sender as! UIButton
            
            if (tokenF_inviteAdmin.count == 0) {
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
            else if (self.txtFieldAt.text!.characters.count == 0)
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
                dict["title"] = self.tf_ProActiveName.text! as String
                dict["desc"] = tv_desc.text
                
                for link in self.arrAttachments {
                    var dicLinks = Dictionary<String,AnyObject>()
                    dicLinks["title"] = link ["title"]
                    dicLinks["url"] = link ["url"]
                    linksArray.addObject(dicLinks)
                }
                
                dict["links"]=linksArray as [AnyObject]
                dict["attachments"]="abc.png"
                dict["createdBy"]=ChatHelper.userDefaultForKey("userId") as String
             //   dict["eventDate"] =   HelpingClass.convertDateFormat("MM/dd/YYYY", desireFormat:"dd/MM/YYYY", dateStr: txtFieldOn.text!)
               
                
                var userIdAdminArr : NSMutableArray!
                userIdAdminArr = NSMutableArray()
                
                for myobject : AnyObject in tokensAdmin
                {
                    var tempDict = Dictionary<String,AnyObject>()
                //    tempDict["userId"]=myobject["_id"] as! String
                    let userId = myobject["_id"] as! String
                    
                    userIdAdminArr.addObject(userId);
                }
                dict["admins"] = userIdAdminArr as [AnyObject]
                
                var userIdMemberArr : NSMutableArray!
                userIdMemberArr = NSMutableArray()
                
                for myobject : AnyObject in tokensMember
                {
                    var tempDict = Dictionary<String,AnyObject>()
                    //    tempDict["userId"]=myobject["_id"] as! String
                    let userId = myobject["_id"] as! String
                    
                    userIdMemberArr.addObject(userId);
                }
                dict["members"] = userIdMemberArr as [AnyObject]
                
                
                
                print(dict)
                
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
                        
                        
                        }, success:
                        {
                            operation, response -> Void in
                            
                            //Parsing JSON
                            var parsedData = JSON(response)
                            //  println_debug(parsedData)
                            dict["imgUrl"] = parsedData["filesUrl"].string
                            
                            button.userInteractionEnabled=true
                            
                            if(self.pushedFrom == "EDITMEETUPS" || self.pushedFrom == "EDITWEBINVITES")
                            {
                                ChatListner .getChatListnerObj().socket.emit("editMeetup_Invite", dict)
                                dispatch_after(3, dispatch_get_main_queue(), {
                                    stopActivityIndicator(self.view)
                                    
                                    self.navigationController?.popToRootViewControllerAnimated(true)
                                })
                            }
                            else
                            {
                                ChatListner .getChatListnerObj().socket.emit("createMeetup_Invite", dict)
                                dispatch_after(3, dispatch_get_main_queue(), {
                                    stopActivityIndicator(self.view)
                                    
                                    self.navigationController?.popToRootViewControllerAnimated(true)
                                })
                            }
                            
                            
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
                    if(self.pushedFrom == "EDITMEETUPS" || self.pushedFrom == "EDITWEBINVITES")
                    {
                        ChatListner .getChatListnerObj().socket.emit("editMeetup_Invite", dict)
                        dispatch_after(3, dispatch_get_main_queue(), {
                            stopActivityIndicator(self.view)
                            self.navigationController?.popToRootViewControllerAnimated(true)
                        })
                    }
                    else
                    {
                        ChatListner .getChatListnerObj().socket.emit("createMeetup_Invite", dict)
                        dispatch_after(3, dispatch_get_main_queue(), {
                            stopActivityIndicator(self.view)
                            self.navigationController?.popToRootViewControllerAnimated(true)
                        })
                    }
                    
                    
                }
                
                
            }
            
        }else
        {
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Internet Connection not available.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
        }*/
    }
   

}

//MARK:- TextView Delegate

extension CreatePACVC : UITextViewDelegate{
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        
        tv_desc.textColor = UIColor.blackColor()
        
        
        if tv_desc.text == "Minimum 50 words" {
            
            tv_desc.text = "" // clear the place holder text

        }
        

    }
    
    
    func textViewDidEndEditing(textView: UITextView) {
        
        if tv_desc.text == "" {
            tv_desc.textColor = UIColor.grayColor()
            tv_desc.text = "Minimum 50 words"
        }
        
    }
    
    
    
    
}



//MARK:- TableView DataSource n Delegate


extension CreatePACVC: UITableViewDataSource{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat    {
        
        
        return 45
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrAttachments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = self.tv_CreatePac.dequeueReusableCellWithIdentifier("cellAttachments", forIndexPath: indexPath) as UITableViewCell
        cell.selectionStyle = .None
        let attachmentName = cell.contentView.viewWithTag(111) as! UITextView
        let closeButton = cell.contentView.viewWithTag(222) as! UIButton
        closeButton.addTarget(self, action: #selector(btnDeleteClick(_:)), forControlEvents: .TouchUpInside)
        let backView = cell.contentView.viewWithTag(333)! as UIView
        AppHelper.setBorderOnView(backView)
        attachmentName.text = self.arrAttachments[indexPath.row]["title"] as! String
        return cell;
    }
    
    
    
    func btnDeleteClick(sender: UIButton)  {
        print(sender)
        
        let point = self.tv_CreatePac.convertPoint(CGPoint.zero, fromView: sender)
        guard let indexPath = self.tv_CreatePac.indexPathForRowAtPoint(point) else {
            fatalError("can't find point in tableView")
        }
        self.arrAttachments.removeAtIndex(indexPath.row)
        self.tv_CreatePac.reloadData()
    }
    
    
}

extension CreatePACVC:  UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}
