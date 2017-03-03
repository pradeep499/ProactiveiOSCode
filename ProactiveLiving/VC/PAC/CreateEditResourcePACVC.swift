//
//  CreateEditResourcePACVC.swift
//  ProactiveLiving
//
//  Created by Aseem Akarshan on 2/27/17.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit

class CreateEditResourcePACVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentMenuDelegate, UIDocumentPickerDelegate {

    
    var pageTitle = ""
    @IBOutlet weak var lblTitle: UILabel!
   
    @IBOutlet weak var txtFieldTitle: CustomTextField!
    
    @IBOutlet weak var txtViewDescription: UIPlaceHolderTextView!
    
    @IBOutlet weak var tableViewResource: UITableView!
    
    var arrAttachments = [AnyObject]()
    var isEdit : Bool?
    var resourceArr = [AnyObject]()
    var resourceDict = Dictionary<String, String>()
    
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblTitle.text = pageTitle
        
        self.tableViewResource.dataSource = self
        self.tableViewResource.separatorStyle = .None
        
        
        // setting textView BorderOn
         self.txtViewDescription.setCornerRadiusWithBorderWidthAndColor(3, borderWidth: 1, borderColor: UIColor(red: 145.0/255.0, green: 145.0/255.0, blue: 145.0/255.0, alpha: 0.2))
        
        // from Edit
        
        if isEdit == true {
        txtFieldTitle.text = resourceDict["title"]
        txtViewDescription.text = resourceDict["description"]
        arrAttachments = (resourceDict["attachments"] as? [AnyObject])!
            
        }
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    //MARK: Button Action
    @IBAction func backBtnAction(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
   
  
    
    @IBAction func rightBtnAction(sender: AnyObject) {
        
        
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
            
            
            // validating url
            var url = String()
            if((linkTextField.text! as String).hasPrefix("http://") || (linkTextField.text! ).hasPrefix("https://")){
                
                url = linkTextField.text!
            }
            else
            {
                url = "http://" + linkTextField.text!
            }
            
            url = url.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            
            
            if !(self.validateUrl(url)){
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please input valid url.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
            else {
            
            if (titleTextField.text?.characters.count > 0 && linkTextField.text?.characters.count > 0)
            {
                dict["title"]=titleTextField.text! as String
                dict["url"] = url //linkTextField.text
                dict["type"]="link"
                
                self.arrAttachments.append(dict)
                self.tableViewResource.reloadData()
            }
            else
            {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please input both title and url.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
            
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
     
    }
    
    @IBAction func onClickAddAttachmentBtn(sender: AnyObject) {
        
        
        let importMenu = UIDocumentMenuViewController(documentTypes: ["public.data","public.text","public.image"], inMode: .Import)
        importMenu.delegate = self
        importMenu.title="Attach a Document"
        
        //importMenu.addOptionWithTitle("Attach from Gallery", image: nil, order: .First, handler: {
        //print("New Doc Requested") } )
        
        presentViewController(importMenu, animated: true, completion: nil)

        
        
    }
    
    
    // add Video URl action 
    
    @IBAction func onClickAddVideo(sender: AnyObject) {
        
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
            
            // validating url
            var url = String()
            if((linkTextField.text! as String).hasPrefix("http://") || (linkTextField.text! ).hasPrefix("https://")){
                
                url = linkTextField.text!
            }
            else
            {
                url = "http://" + linkTextField.text!
            }
            
            url = url.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            

            if !(self.validateUrl(url)){
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please input valid url.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
            else {
            if (titleTextField.text?.characters.count > 0 && linkTextField.text?.characters.count > 0)
            {
                dict["title"]=titleTextField.text! as String
                dict["url"] = url  //linkTextField.text
                dict["type"]="video"
                
                
                self.arrAttachments.append(dict)
                self.tableViewResource.reloadData()
            }
            else
            {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please input both title and url.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)

       
    }
    
    // Save and continue button action
    
    @IBAction func onClickSubmitBtn(sender: AnyObject) {
        
        print("Submit Button pressed!!!")
        serviceHit()
       
    }
    
    //MARK:- Regex
    // Is valid URL
    func validateUrl (stringURL : NSString) -> Bool {
        
        let urlRegEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])
        var urlTest = NSPredicate.predicateWithSubstitutionVariables(predicate)
        
        return predicate.evaluateWithObject(stringURL)
    }
    
    // MARK :- Service Hit
    
    func serviceHit() {
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            
              var parameters = [String: AnyObject]()
            // parameters["AppKey"] = AppKey
           
            parameters = [ "userId" : AppHelper.userDefaultsForKey(_ID),
                           "pacId" : (AppHelper.userDefaultsForKey("pacId") as? String)!,
                                "title" : self.txtFieldTitle.text!,
                          "description" : self.txtViewDescription.text!,
                          "attachments" : arrAttachments
            ]
            
            
            print("PARAMETERS \(parameters)")
            
            //call global web service class latest
            Services.postRequest(ServiceCreateResource, parameters:parameters, completionHandler:{
                (status,responseDict) in
                
                AppDelegate.dismissProgressHUD()
                
                print(responseDict)
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        print(responseDict["result"])
                        
                        let msg = "Resource created."
                        
                        
                        AppHelper.showAlertWithTitle(AppName, message:msg, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                        
                        self.navigationController?.popViewControllerAnimated(true)

                    }
                    
                } else if (status == "Error"){
                    
                    AppHelper.showAlertWithTitle(AppName, message: serviceError, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    
                }
            })
            
            
            
         
        }
        else {
            AppDelegate.dismissProgressHUD()
            //show internet not available
            AppHelper.showAlertWithTitle(netError, message: netErrorMessage, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
        }

    }
    
    
    
    
    // MARK: - UIDocumentPickerDelegate Methods
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        
        if controller.documentPickerMode == .Import {
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.arrAttachments.append(url.lastPathComponent!)
                self.tableViewResource.reloadData()
                
            }
        }
        
    }
    
    func documentPickerWasCancelled(controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    
    // MARK:- UIDocumentMenuDelegate
    func documentMenu(documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        presentViewController(documentPicker, animated: true, completion: nil)
    }
   
}

//MARK:- TableView DataSource n Delegate


extension CreateEditResourcePACVC: UITableViewDataSource{
    
    // TableView heightForRowAtIndexPath
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat    {
        
        
        return 45
    }
    
    // TableView numberOfRowsInSection
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrAttachments.count
        
    }
    
    
    // TableView cellForRowAtIndexPath
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = self.tableViewResource.dequeueReusableCellWithIdentifier("cellAttachments", forIndexPath: indexPath) as UITableViewCell
        
        cell.selectionStyle = .None
        
        let attachmentName = cell.contentView.viewWithTag(111) as! UITextView
        
        let closeButton = cell.contentView.viewWithTag(222) as! UIButton
        
        closeButton.addTarget(self, action: #selector(btnDeleteClick(_:)), forControlEvents: .TouchUpInside)
        
        let backView = cell.contentView.viewWithTag(333)! as UIView
        
        AppHelper.setBorderOnView(backView)
        
        attachmentName.text = self.arrAttachments[indexPath.row]["title"] as! String
        
        return cell
        
        
    }
    
    // Delete button action
   
    func btnDeleteClick(sender: UIButton)  {
        
        print(sender)
        
        let point = self.tableViewResource.convertPoint(CGPoint.zero, fromView: sender)
        
        guard let indexPath = self.tableViewResource.indexPathForRowAtPoint(point) else {
            
            fatalError("can't find point in tableView")
            
        }
        
        self.arrAttachments.removeAtIndex(indexPath.row)
        
        self.tableViewResource.reloadData()
        
    }
    
    
}

