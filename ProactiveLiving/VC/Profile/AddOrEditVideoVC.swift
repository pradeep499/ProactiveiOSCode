//
//  AddOrEditVideoVC.swift
//  ProactiveLiving
//
//  Created by SK MD Badruduja on 1/22/17.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit

class AddOrEditVideoVC: UIViewController {
    
    
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var tf_videoType: CustomTextField!
    @IBOutlet weak var tf_videoTitle: CustomTextField!
    @IBOutlet weak var tf_by: CustomTextField!
    @IBOutlet weak var tf_videoUrl: CustomTextField!
    @IBOutlet weak var tv_desc: UITextView!
    
    @IBOutlet weak var tv_videoType: UITableView!
    @IBOutlet weak var subView: UIView!
    
    var videoType:String?
    var isShowingTableView:Bool?
    var tapGesture:UITapGestureRecognizer?
    
    var videoDict:[String:String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isShowingTableView = false
        self.tv_videoType.hidden = true
        
        tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(AddOrEditVideoVC.subViewTaped(_:)))
        self.subView.addGestureRecognizer(tapGesture!)
        
        self.tv_desc.layer.borderWidth = 0.4
        self.tv_desc.layer.borderColor = UIColor.grayColor().CGColor
        
        if self.videoType == "Edit" {
            
            self.lbl_title.text = "Edit Video"
            self.setUpTf()
        }else{
            
            self.lbl_title.text = "Add Video"
            self.tv_desc.text = ""
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func subViewTaped(gesture:UIGestureRecognizer) -> Void {
        
        if self.isShowingTableView == true {
            
            self.isShowingTableView = false
            self.tv_videoType.hidden = true
        }else{
            
            self.tf_videoTitle.resignFirstResponder()
            self.tf_by.resignFirstResponder()
            self.tf_videoUrl.resignFirstResponder()
            self.tv_desc.resignFirstResponder()
        }
    }
    
    func setUpTf() -> Void {
        
        if videoDict!["category"] == "PERSONAL" {
            self.tf_videoType.text = "Persional"
        }else if videoDict!["category"] == "EDUCATIONAL" {
            self.tf_videoType.text = "Educational"
            
        }else if videoDict!["category"] == "INSPIRATIONAL" {
            self.tf_videoType.text = "Inspirational"
        }
        
        self.tf_videoTitle.text = videoDict!["title"]
        self.tf_by.text = videoDict!["author"]
        self.tf_videoUrl.text = videoDict!["url"]
        self.tv_desc.text = videoDict!["description"]
    }

    @IBAction func onClickBackBtn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onClickDoneBtn(sender: AnyObject) {
        
        self.submitVideoAPI()
    }
    
    @IBAction func onClickAddBtn(sender: AnyObject) {
    }
    
    
    //MARK: - Service Call
    
    func submitVideoAPI() {
        
        if (self.tf_videoType.text?.characters.count < 1 && self.tf_videoTitle.text?.characters.count < 1 && self.tf_by.text?.characters.count < 1 && self.tf_videoUrl.text?.characters.count < 1 && self.tv_desc.text?.characters.count < 1 ) {
        
            AppHelper.showAlertWithTitle(AppName, message: "All fields are mendatory.", tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
            return
        }
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            parameters["category"] = self.tf_videoType.text
            parameters["title"] = self.tf_videoTitle.text
            parameters["author"] = self.tf_by.text
            
            var url = String()
            
            if((self.tf_videoUrl.text! as String).hasPrefix("http://") || (self.tf_videoUrl.text! as! String).hasPrefix("https://")){
                
                url = self.tf_videoUrl.text!
            }
            else
            {
                url = "http://" + self.tf_videoUrl.text!
            }
            
            parameters["url"] = url
            
            parameters["description"] = self.tv_desc.text
            parameters["type"] = "video"
            
            var method:String?
            
            if self.videoType == "Edit" {
                parameters["videoId"] = self.videoDict!["_id"]
                
                method = ServiceEditVideos
                
            }else{
                method  = ServiceUploadVideos
            }
            
            
            
            //call global web service class latest
            Services.postRequest(method, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        print(responseDict["result"])
                        
                        let result = responseDict["result"]
                        
                        if self.videoType == "Edit" {
                        
                        AppHelper.showAlertWithTitle(AppName, message: "Video is Updated", tag: 11, delegate: self, cancelButton: ok, otherButton: nil)
                        }else{
                            AppHelper.showAlertWithTitle(AppName, message: "Video is added", tag: 11, delegate: self, cancelButton: ok, otherButton: nil)
                        }
                        
                        
                    } else {
                        
                        AppHelper.showAlertWithTitle(AppName, message: responseDict["errorMsg"] as! String, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
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
    
    
}

extension AddOrEditVideoVC:UIAlertViewDelegate{
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if alertView.tag == 11 {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}

extension AddOrEditVideoVC:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == self.tf_videoType {
            
            self.tv_videoType.hidden = false
            isShowingTableView = true
            
            if tapGesture != nil {
                self.subView.removeGestureRecognizer(tapGesture!)
                
              /*  if self.tf_videoType.text?.characters.count > 1 {
                    
                    self.subView.addGestureRecognizer(tapGesture!)
                }else{
                    
                    self.subView.removeGestureRecognizer(tapGesture!)
                    
                }*/
            }
                
            
            
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension AddOrEditVideoVC:UITableViewDataSource, UITableViewDelegate{
       
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Personal"
            break;
        case 1:
            cell.textLabel?.text = "Educational"
            break;
        case 2:
            cell.textLabel?.text = "Inspirational"
            break;
        default:
            break
        }
        
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        switch indexPath.row {
        case 0:
            self.tf_videoType.text = "Personal"
            break;
        case 1:
            self.tf_videoType.text = "Educational"
            break;
        case 2:
            self.tf_videoType.text = "Inspirational"
            break;
        default:
            break
        }
        self.tv_videoType.hidden = true
        self.isShowingTableView = false
    }
}
