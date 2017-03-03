//
//  ResourcesPACVC.swift
//  ProactiveLiving
//
//  Created by Aseem Akarshan on 2/27/17.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ResourcesPACVC: UIViewController {
    
    
    @IBOutlet weak var tableViewResource: UITableView!
    
    var resourceDetailArr = [AnyObject]()
    var attachmentArr : NSArray? //  = [AnyObject]()
    
    var moviePlayer = MPMoviePlayerViewController()
    var isHidden = true
    

    
// MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // api Hit
        fetchPostDataFromServer()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        // api Hit
        fetchPostDataFromServer()

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK:- Button action 
    
    // Delete resource entry
    @IBAction func  btnActionDelete(sender: AnyObject) {
        
 
       // ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Are you sure you want to delete resource.", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitle: "Ok")
        
        HelpingClass.showAlertControllerWithType(.Alert, fromController: self, title: AppName, message: "Are you sure you want to delete resource. ?", cancelButtonTitle: "No", otherButtonTitle: ["Yes"]) { (str) in
            
            if str == "Yes"{
             
                let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableViewResource)
                
                let indexPath =  self.tableViewResource.indexPathForRowAtPoint(buttonPosition)
                
                
                print("Button Pressed Delete: \(indexPath!.section)")
                
                let resourceId = (self.resourceDetailArr[indexPath!.section].valueForKey("_id") as? String)!
                
                print("RESOURCE ID : \(resourceId)")
                
                
                var parameters = [String: AnyObject]()
                
                parameters =   ["userId" : AppHelper.userDefaultsForKey(_ID),
                                "pacId" : (AppHelper.userDefaultsForKey("pacId") as? String)!,
                                "resourceId" : resourceId    ]
                
                
                print("PARAM DELETE \(parameters)")
                
                self.deleteResourceAPI(parameters)

                
            }
        }

        
        
        
        
        
        
    }
    
    
    // Edit resource entry

    
    @IBAction func  btnActionEdit(sender: AnyObject) {
        
        
       // let button: UIButton = sender as! UIButton
        
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableViewResource)
        
        let indexPath =  self.tableViewResource.indexPathForRowAtPoint(buttonPosition)
        
        print("Button Pressed Edit: \(indexPath!.section)")
        
        print("Resource Detail Array \((resourceDetailArr[indexPath!.section]))")
        
        //let resourceData = (resourceDetailArr[indexPath!.section])
        let profileStoryboard = AppHelper.getPacStoryBoard()
        let createEditResourcePACVC = profileStoryboard.instantiateViewControllerWithIdentifier("CreateEditResourcePACVC") as! CreateEditResourcePACVC
        createEditResourcePACVC.pageTitle = "Edit Resource"
        createEditResourcePACVC.isEdit = true
        createEditResourcePACVC.resourceDict = (resourceDetailArr[indexPath!.section] as? Dictionary<String, String>)! //resourceData as! Dictionary<String, String>   //resourceDetailArr[indexPath!.section] as! [AnyObject]
        self.navigationController?.pushViewController(createEditResourcePACVC, animated: true)
        
      
       // deleteResourceAPI()
        
    }
    
 
    //MARK:- Service Hit
    
    func deleteResourceAPI(param: [String: AnyObject] ){
        
        if AppDelegate.checkInternetConnection() {
            isPostServiceCalled = true
            
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            
            //call global web service class latest
            Services.postRequest(ServiceDeleteResource, parameters: param, completionHandler:{
                (status,responseDict) in
                
                isPostServiceCalled = false
                
                      print("Response = \(responseDict)")
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        print("TESTING  Dict \(responseDict)")
                        if let resultArr = responseDict["result"]?.valueForKey("resources") {
                            
                            print("TESTING Arr \(resultArr)")
                            
                            
                           // self.resourceDetailArr = resultArr as! [AnyObject]
                          //  self.tableViewResource.reloadData()
                            
                            self.fetchPostDataFromServer()
                            
                            
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
    
    
    
    func fetchPostDataFromServer() {
        
        if AppDelegate.checkInternetConnection() {
            isPostServiceCalled = true
            
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            
            
            
            parameters =   ["userId" : AppHelper.userDefaultsForKey(_ID),
                            "pacId" : (AppHelper.userDefaultsForKey("pacId") as? String)!]
            
            //call global web service class latest
            Services.postRequest(ServiceGetAllResource, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                isPostServiceCalled = false
                
                //      print("Response = \(responseDict)")
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        print("TESTING  Dict \(responseDict)")
                        if let resultArr = responseDict["result"]?.valueForKey("resources") {
                            
                            print("TESTING Arr \(resultArr)")
                            
                            
                            self.resourceDetailArr = resultArr as! [AnyObject]
                            
                            self.tableViewResource.reloadData()
                            
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

//MARK:- TableView DataSource and Delegate

extension ResourcesPACVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return resourceDetailArr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        
        attachmentArr = (resourceDetailArr[section].valueForKey("attachments") as? NSArray)!
        //attachmentArr = (attachmentArr?.objectAtIndex(0) as? NSArray)!

         //print ("ROW COUNT \(attachmentArr.count)")
        
        print("Section item lists:\((resourceDetailArr[section].valueForKey("attachments") as? [AnyObject])!)")
        
        
        print("COUNT ROWS \((resourceDetailArr[section].valueForKey("attachments") as? [AnyObject])!.count + 1)")
        
        return  ((resourceDetailArr[section].valueForKey("attachments") as? [AnyObject])!.count + 1)
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        if indexPath.row == 0{
            return 120
        }
        else {
             return 90
            
        }
    
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
       
        attachmentArr = (resourceDetailArr[indexPath.section].valueForKey("attachments") as? NSArray)!
        print("MIKE attachmentArr\(attachmentArr)")
       
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("titleCell", forIndexPath: indexPath) as UITableViewCell
            
            
           // cell.selectionStyle = .None
            
            let lblTitle = cell.viewWithTag(10) as! UILabel
            lblTitle.text = resourceDetailArr[indexPath.section].valueForKey("title") as? String
            let txtViewDetail = cell.viewWithTag(11) as! UITextView
            txtViewDetail.text = resourceDetailArr[indexPath.section].valueForKey("description") as? String

            let deleteBtn = cell.viewWithTag(99) as! UIButton
            let editBtn = cell.viewWithTag(98) as! UIButton
            
           // to show or hide the edit and delete button
            if !isHidden {
                
                deleteBtn.hidden = false
                editBtn.hidden = false
                
                deleteBtn.addTarget(self, action: #selector(ResourcesPACVC.btnActionDelete(_:)), forControlEvents: .TouchUpInside)
                editBtn.addTarget(self, action: #selector(ResourcesPACVC.btnActionEdit(_:)), forControlEvents: .TouchUpInside)
//                editBtn.addTarget(self, action: #selector(ResourcesPACVC.startEditing(_:)), forControlEvents: .TouchUpInside);
            }
            else {
                deleteBtn.hidden = true
                editBtn.hidden = true

                
            }
            
          //  txtViewDetail.setCornerRadiusWithBorderWidthAndColor(3, borderWidth: 1, borderColor: UIColor(red: 145.0/255.0, green: 145.0/255.0, blue: 145.0/255.0, alpha: 0.2))
            
            
            return cell
            
            
        }else {
            
            // check the Attachment folder
            setUpAttachmentCell(tableViewResource, indexPath: indexPath)
        }
  
        return UITableViewCell()
        
    }
    
    // Method to set up cells for attachment
    
    func setUpAttachmentCell(tv: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        if attachmentArr!.count == 0{
       
            return UITableViewCell()
            
        }
        else {
        
        
        // we are modifying the index because we are taking "numberOfRowsInSection" on the basis of attachmentArr which is one less in total cell count
        var processedIndexPath = indexPath.row
        processedIndexPath = processedIndexPath-1
        
        print("Processed index path:\(processedIndexPath) Item type:\(self.attachmentArr?.objectAtIndex(processedIndexPath).objectForKey("type")) --- \(self.attachmentArr?.objectAtIndex(processedIndexPath).objectForKey("type"))")
            
        
        if (self.attachmentArr?.objectAtIndex(processedIndexPath).objectForKey("type"))! as! String == "link" {
         
         let cellLink = tv.dequeueReusableCellWithIdentifier("linkCell", forIndexPath: indexPath) as UITableViewCell
            
         //cellLink.selectionStyle = .None
            
         let txtViewLink = cellLink.viewWithTag(13) as! UITextView
         
         txtViewLink.text = self.attachmentArr?.objectAtIndex(processedIndexPath).objectForKey("title") as? String
         
         return cellLink
         
         
         }
        else if self.attachmentArr?.objectAtIndex(processedIndexPath).objectForKey("type") as? String == "attachment" {
         
         let cellAttachment = tv.dequeueReusableCellWithIdentifier("attachmentCell", forIndexPath: indexPath) as UITableViewCell
         
         //cellAttachment.selectionStyle = .None
  
         let txtViewLink = cellAttachment.viewWithTag(15) as! UITextView
         
         txtViewLink.text = self.attachmentArr?.objectAtIndex(processedIndexPath).objectForKey("title") as? String
         
         return cellAttachment
         
         }
         
         else if self.attachmentArr?.objectAtIndex(processedIndexPath).objectForKey("type") as? String == "video" {
         
         let cellVideo = tv.dequeueReusableCellWithIdentifier("videoCell", forIndexPath: indexPath) as UITableViewCell
         
        // cellVideo.selectionStyle = .None
   
         let videoLinkImage = cellVideo.viewWithTag(16) as! UIImageView
          print("Image URL\((self.attachmentArr?.objectAtIndex(processedIndexPath).objectForKey("url") as? String)!))")
            
         
         videoLinkImage.sd_setImageWithURL(NSURL.init(string: (self.attachmentArr?.objectAtIndex(processedIndexPath).objectForKey("url") as? String)!), placeholderImage: UIImage.init(named: "ic_certifications_sustainable"))
         
         return cellVideo
         
         }
         
        }
        
        return UITableViewCell()
    }
    
    
    
    //MARK: - play Video On Cell Tap
    func playVideoOnCellTap(link : String ) -> Void {//func playVideoOnCellTap(indexPath: NSIndexPath ) -> Void {
        
        var urlStr = String?()
        
       
            
           // let dataDict = self.dataArra![indexPath.row] as? [String:String]
        urlStr = link
        
        
        if  urlStr != nil {
            
            self.moviePlayer = MPMoviePlayerViewController(contentURL: NSURL(string:urlStr!)!)
            self.moviePlayer.moviePlayer.movieSourceType = .Unknown
            self.moviePlayer.moviePlayer.prepareToPlay()
            self.moviePlayer.moviePlayer.shouldAutoplay = true
            //[[self.moviePlayer moviePlayer] setControlStyle:MPMovieControlStyleNone];
            //[[self.moviePlayer moviePlayer] setFullscreen:YES animated:YES];
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.mpMoviePlayerLoadStateDidChange(_:)), name: MPMoviePlayerLoadStateDidChangeNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.moviePlaybackDidFinish), name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
            self.presentMoviePlayerViewControllerAnimated(self.moviePlayer)
            self.moviePlayer.moviePlayer.play()
            
            
        }
        
    }
    
    //MARK: - Player event notifications
    func mpMoviePlayerLoadStateDidChange(notification: NSNotification) {
        
        
        //    NSLog(@"loadstate change: %lu", (unsigned long)[self.moviePlayer moviePlayer].loadState);
        //
        //    if (([self.moviePlayer moviePlayer].loadState & MPMovieLoadStatePlayable) == MPMovieLoadStatePlayable)
        //    {
        //        NSLog(@"yay, it became playable");
        //    }
        
        
    }
    
    func moviePlaybackDidFinish() {
        
        print("Movie finished!!!")
        
    }
    
    
  //MARK: Did select
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.layoutSubviews()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        print(indexPath.row)
        
        if(indexPath.row != 0)
        {
        print("Did Select Row At index path \(indexPath.row)")
        
       // redirection to next VC for WebView
        let WebVC:WebViewVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("WebViewVC") as! WebViewVC
        
            var processedIndexPath = indexPath.row
        
        processedIndexPath = processedIndexPath-1
        attachmentArr = (resourceDetailArr[indexPath.section].valueForKey("attachments") as? NSArray)!
            
            
        print("ATTACHMENT ARRY1 \((self.attachmentArr?.objectAtIndex(processedIndexPath).objectForKey("type"))! as! String == "video")")
            
        print("ATTACHMENT ARRAY:-\(attachmentArr!.objectAtIndex(processedIndexPath))")
       //  print("ATTACHMENT ARRAY:-\(attachmentArr![processedIndexPath])")
        
            
            
            
      if self.attachmentArr?.objectAtIndex(processedIndexPath).objectForKey("type") as? String == "video" {
        
        
        
        playVideoOnCellTap((self.attachmentArr?.objectAtIndex(processedIndexPath).objectForKey("url") as? String)!)
        
        
        
            }
            
        
        else  {
            
            
            
        let dict = self.attachmentArr?.objectAtIndex(processedIndexPath) as! [String:String]     //self.attachmentArr![indexPath.row] as! [String:String]
        
        WebVC.title = "Resource"
       
        if dict["url"] != nil {
         
        print("Dict \(dict)")
        print("URL TEST: \(dict["url"]!)")
        WebVC.urlStr = dict["url"]!
        self.navigationController?.pushViewController(WebVC, animated: true)
            
            if dict["type"] == "video" {
                print("VIDEO DICT")
            }
            
            
        }
        
        }
        }
        
        
       
    }
    
}

