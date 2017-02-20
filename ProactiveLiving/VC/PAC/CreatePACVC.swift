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
    
    @IBOutlet weak var tv_desc: UIPlaceHolderTextView!
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreatePACVC.NotifyCreatePacInvite(_:)),name:"NotifyCreatePacInvite", object:nil)
        self.tv_CreatePac.dataSource = self
        
        self.setUpPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpPage() -> Void {
        
        
        
        let recognizer = UITapGestureRecognizer(target: self, action:#selector(GroupDetailVC.clickUserImage(_:)))
        recognizer.delegate = self
        self.iv_coverPic.addGestureRecognizer(recognizer)
        self.iv_coverPic.userInteractionEnabled = true
        self.iv_coverPic.layer.cornerRadius = self.iv_coverPic.frame.height/2
        self.iv_coverPic.clipsToBounds = true
        self.iv_coverPic.setImageWithURL(NSURL(string:""), placeholderImage: UIImage(named:"profile.png"))
        
        
        self.tv_desc.placeholder = "Minimum 50 words"
        
        self.tf_location.addTarget(self, action: #selector(addressTextFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingDidBegin)
        
        
        gpaViewController = GooglePlacesAutocomplete(
            apiKey: "AIzaSyCofV_YsTjl-9lu2m4rOCj1bMmW4PS1Td0",
            placeType: .Address
        )
        
        IQKeyboardManager.sharedManager().enable=true
        IQKeyboardManager.sharedManager().enableAutoToolbar=true
    }
    
    
    
    func reSetInviteTag(contact : [String : AnyObject] ) -> Void {
        
        if inviteStr == "admin" {
            
            
            tokenF_inviteAdmin.tags.addObject(contact["firstName"]!)
            tokenF_inviteAdmin.reloadTagSubviews()
            
        }else if inviteStr == "member" {
            
            tokenF_inviteMember.tags.addObject(contact["firstName"]!)
            tokenF_inviteMember.reloadTagSubviews()
            
        }
        
        
    }
    
    
    func NotifyCreatePacInvite(notification:NSNotification) {
      //  print(notification)
        let dicContact = notification.object as! [String : AnyObject]
        self.reSetInviteTag( dicContact   )
    }
    
     


    
    
    //MARK:- Btn Action
    
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
    
    
    @IBAction func onClickAgree(sender: AnyObject) {
        
        self.btnIAgree.selected = !self.btnIAgree.selected
        
        if self.btnIAgree.selected {
            
            self.btnIAgree.setImage(UIImage.init(named: "ic_bookingpopup_radioselected"), forState: .Normal)
        }else{
            
            self.btnIAgree.setImage(UIImage.init(named: "ic_bookingpopup_radio"), forState: .Normal)
        }
        
        
        
        
        
    }
    
    @IBAction func onClickSubmitBtn(sender: AnyObject) {
    }
    
    //MARK: - Switch
    
    
    @IBAction func onChangeSwitch_settingPrivate(sender: AnyObject) {
    }
    
    @IBAction func onChangeSwitch_settingCreateMeetUp(sender: AnyObject) {
    }
    
    @IBAction func onChangeSwitch_settingCreaeWebInvite(sender: AnyObject) {
    }
    
    
    
    @IBAction func onChangeSwitch_settingUploadPic(sender: AnyObject) {
    }
    
    
    @IBAction func onChangeSwitch_visibleEvery(sender: AnyObject) {
    }
    
    @IBAction func onChangeSwitch_visibleFriends(sender: AnyObject) {
    }
    
    @IBAction func onChangeSwitch_visibleColleagues(sender: AnyObject) {
    }
    
    
    @IBAction func onChangeSwitch_visibleHealthClub(sender: AnyObject) {
    }
    
    
    @IBAction func onChangeSwitch_visibleMale(sender: AnyObject) {
    }
    
    @IBAction func onChangeSwitch_visibleFemale(sender: AnyObject) {
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
    
    
    func submitAPI() -> Void {
        
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
