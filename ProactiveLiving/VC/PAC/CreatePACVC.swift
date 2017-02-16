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

        // Do any additional setup after loading the view.
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

    
    
    //MARK:- Btn Action
    
    func goToContact(type:String) -> Void {
        
        
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
