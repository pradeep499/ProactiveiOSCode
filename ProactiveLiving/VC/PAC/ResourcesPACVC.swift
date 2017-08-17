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
    var isFromMoreDetail = false
    var pacID = ""
    var dictValuePacRole = [String:AnyObject]()

    var indexToDelete = Int()
    var currentIndexPath = NSIndexPath()
    
// MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // api Hit
        tableViewResource.tableFooterView = UIView()
        fetchPostDataFromServer()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NOTIFICATION_FROM_MOREDETAILVC, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ResourcesPACVC.isFromMoredetailVC), name: NOTIFICATION_FROM_MOREDETAILVC, object: nil)
        
        


    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
       
              // api Hit
        if isFromMoreDetail == false {
            fetchPostDataFromServer()
            // NSNotificationCenter.defaultCenter().removeObserver(self, name: NOTIFICATION_FROM_MOREDETAILVC, object: nil)
            self.fetchDataForPACRole()
        }
        
      
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    
    //MARK:- Button action 
    
    // Method to check if redirected from MoreDetailVC
    
      func isFromMoredetailVC(){

        self.isFromMoreDetail = true
        
        
      }

    // See More Button Action
    
    func seeMoreAction(sender: AnyObject) {
        /*
         let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableViewResource)
         let indexPath =  self.tableViewResource.indexPathForRowAtPoint(buttonPosition)
         
         self.resourceDetailArr.removeAtIndex((indexPath?.section)!)
         let indexs = NSIndexSet.init(index: (indexPath?.section)!)
         dispatch_async(dispatch_get_main_queue(), { () -> Void in
         
         let cell = self.tableViewResource.cellForRowAtIndexPath(indexPath!)
         cell?.hidden = true
         //for view1 in (cell?.contentView.subviews)!{
         //  view1.removeFromSuperview()
         // view1.hidden = true
         //  }
         
         //cell?.contentView = UIView.init(frame: CGRect.zero)
         
         self.tableViewResource.beginUpdates()
         self.tableViewResource.deleteSections(indexs, withRowAnimation: .Fade)
         self.tableViewResource.endUpdates()
         self.tableViewResource.backgroundColor = UIColor.redColor()
         self.tableViewResource.reloadData()
         // self.tableViewResource.setNeedsDisplay()
         // self.tableViewResource.contentSize = CGSize(width: screenWidth, height: 200)
         
         });
         
         // [self.tableView beginUpdates];
         //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
         //  [self.tableView endUpdates];*/

        
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableViewResource)
         let indexPath =  self.tableViewResource.indexPathForRowAtPoint(buttonPosition)
         let seeMoreVC = AppHelper.getPacStoryBoard().instantiateViewControllerWithIdentifier("MoreDetailVC") as! MoreDetailVC
         
         let desc = resourceDetailArr[indexPath!.section].valueForKey("description") as? String // Description
         let title = resourceDetailArr[indexPath!.section].valueForKey("title") as! String  //  Title
         
         seeMoreVC.titleStr = title
         seeMoreVC.detailStr = desc!
         self.navigationController?.pushViewController(seeMoreVC, animated: true)
        
        print_debug("See More : MoreDetailVC")
        
    }
    
    
    
    // Delete resource entry
    @IBAction func  btnActionDelete(sender: AnyObject) {
        
 
       // ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Are you sure you want to delete resource.", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitle: "Ok")
        
        HelpingClass.showAlertControllerWithType(.Alert, fromController: self, title: AppName, message: "Are you sure you want to delete resource. ?", cancelButtonTitle: "No", otherButtonTitle: ["Yes"]) { (str) in
            
            if str == "Yes"{
             
                let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableViewResource)
                
                let indexPath =  self.tableViewResource.indexPathForRowAtPoint(buttonPosition)
                
                
                print_debug("Button Pressed Delete: \(indexPath!.section)")
                
                let resourceId = (self.resourceDetailArr[indexPath!.section].valueForKey("_id") as? String)!
                
                print_debug("RESOURCE ID : \(resourceId)")
                
                
                var parameters = [String: AnyObject]()
                
                parameters =   ["userId" : AppHelper.userDefaultsForKey(_ID),
                                "pacId" : (AppHelper.userDefaultsForKey("pacId") as? String)!,
                                "resourceId" : resourceId    ]
                
                
                print_debug("PARAM DELETE \(parameters)")
                
                self.indexToDelete = indexPath!.section
                self.currentIndexPath = indexPath!
                self.deleteResourceAPI(parameters)
                
                //self.resourceDetailArr.removeAtIndex(self.currentIndexPath.section)

               // let indexSet = NSIndexSet(index: self.currentIndexPath.section)
               // self.tableViewResource.deleteSections(indexSet, withRowAnimation: .Fade)
               // let cell1 = self.tableViewResource.numberOfRowsInSection(self.currentIndexPath.section)
                
                
                //var arrIndexp = [NSIndexPath]()
                //for index in 0..<cell1{
                    //let indexPath1 = NSIndexPath(forItem: index, inSection: self.currentIndexPath.section)
                    //arrIndexp.append(indexPath1)
                    //self.tableViewResource.deleteRowsAtIndexPaths([indexPath1], withRowAnimation: .Fade)
                    
                    //print_debug("indexpath ===\(indexPath1)")
               // }
                
               // self.tableViewResource.deleteSections(NSIndexSet.init(index: self.currentIndexPath.section), withRowAnimation: .Fade)
                //self.tableViewResource.reloadData()
                
              //  self.tableViewResource.deleteRowsAtIndexPaths(arrIndexp, withRowAnimation: .Fade)

                
                
                
                
            }
        }
    
    }
    
    
    // Edit resource entry

    
    @IBAction func  btnActionEdit(sender: AnyObject) {
        
        
       // let button: UIButton = sender as! UIButton
        
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableViewResource)
        
        let indexPath =  self.tableViewResource.indexPathForRowAtPoint(buttonPosition)
        
        print_debug("Button Pressed Edit: \(indexPath!.section)")
        
        print_debug("Resource Detail Array \((resourceDetailArr[indexPath!.section]))")
        
        
        
        //let resourceData = (resourceDetailArr[indexPath!.section])
        let profileStoryboard = AppHelper.getPacStoryBoard()
        let createEditResourcePACVC = profileStoryboard.instantiateViewControllerWithIdentifier("CreateEditResourcePACVC") as! CreateEditResourcePACVC
        createEditResourcePACVC.pageTitle = "Edit Resource"
        createEditResourcePACVC.isEdit = true
        createEditResourcePACVC.resourceDict = (resourceDetailArr[indexPath!.section] as? Dictionary<String, AnyObject>)! //resourceData as! Dictionary<String, String>   //resourceDetailArr[indexPath!.section] as! [AnyObject]
        self.navigationController?.pushViewController(createEditResourcePACVC, animated: true)
        
      
       // deleteResourceAPI()
        
    }
    
 
    //MARK:- Service Hit
    
    
    
    func fetchDataForPACRole() {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            parameters["pacId"] = self.pacID
            
            //call global web service class latest
            Services.postRequest(ServiceGetPACRole, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    //dissmiss indicator
                    if ((responseDict["error"] as! Int) == 0) {
                        print_debug(responseDict)
                        
                        let  memberStatus = responseDict["result"]!["memberStatus"] as! Bool
                       
                       
                        let settingsDict = responseDict["result"]!["settings"] as! [String : AnyObject]
                        
                        
                        let isPrivate = settingsDict["private"] as! Bool
                        
                        if(memberStatus == false) {
                           
                        if(isPrivate == true) {
                            
                            var noDataImage : UIImageView
                            noDataImage  = UIImageView(frame: CGRect(x: (screenWidth/2)-160, y: screenHeight-500, width: 320, height: 153))
                            noDataImage.image = UIImage(named:"private_user_texticon")
                            self.view.addSubview(noDataImage)
                            self.tableViewResource.hidden = true

                            }
                         
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
    
    
    
    
    func deleteResourceAPI(param: [String: AnyObject] ){
        
        if AppDelegate.checkInternetConnection() {
            isPostServiceCalled = true
            
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            
            //call global web service class latest
            Services.postRequest(ServiceDeleteResource, parameters: param, completionHandler:{
                (status,responseDict) in
                
                isPostServiceCalled = false
                
                      print_debug("Response = \(responseDict)")
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        print_debug("TESTING  Dict \(responseDict)")
                        if let resultArr = responseDict["result"]?.valueForKey("resources") {
                            
                            print_debug("TESTING Arr \(resultArr)")
                            
                            
                            self.resourceDetailArr = resultArr as! [AnyObject]
                            //self.resourceDetailArr.removeAtIndex(self.currentIndexPath.section)
                            let indexSet = NSIndexSet(index: self.currentIndexPath.section)
                            self.tableViewResource.deleteSections(indexSet, withRowAnimation: .Fade)
                            //self.tableViewResource.deleteRowsAtIndexPaths([self.currentIndexPath], withRowAnimation: .Fade)

                           // self.tableViewResource.reloadData()
                           //// let cells = self.tableViewResource.visibleCells
                          //  var indexpaths = [NSIndexPath]()
                           // for cell in cells{
                                //let indexPath = self.tableViewResource.indexPathForCell(cell)
                                 //indexpaths.append(indexPath!)
                               // print_debug(indexPath)
                           // }
                            
                            //self.tableViewResource.reloadRowsAtIndexPaths(indexpaths, withRowAnimation: .Fade)
                           // print_debug(cells)
                           //
                            
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
                
                //      print_debug("Response = \(responseDict)")
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        print_debug("TESTING  Dict \(responseDict)")
                        if let resultArr = responseDict["result"]?.valueForKey("resources") {
                            
                            print_debug("TESTING Arr \(resultArr)")
                            
                            
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
    
    // numberOfSectionsInTableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if resourceDetailArr.count == 0{
            HelpingClass.toSetEmptyViewInTableViewNoDataAvaiable(tableView, message: "No resources currently available.")
        }else{
            tableView.backgroundView = nil
        }

        return resourceDetailArr.count
        
        
    }
   
    //func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      //  return "section"
    //}
    
    //func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      //  return 50.0
    //}
    
    
    // numberOfRowsInSection
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        
       let  attachmentArr2 = (resourceDetailArr[section].valueForKey("attachments") as? NSArray)!
      
               
        return  (attachmentArr2.count) + 1//2//((resourceDetailArr[section].valueForKey("attachments") as? [AnyObject])!.count + 1)
        
        
    }
    
    
    //  heightForRowAtIndexPath
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let  attachmentArr2 = (resourceDetailArr[indexPath.section].valueForKey("attachments") as? NSArray)!

        if indexPath.row == 0{
            return 120
        }
        else {
            
            // Making height dynamic
            var processedIndexPath = indexPath.row
            processedIndexPath = processedIndexPath-1

            if (attachmentArr2.objectAtIndex(processedIndexPath).objectForKey("type"))! as! String == "link" || attachmentArr2.objectAtIndex(processedIndexPath).objectForKey("type") as? String == "attachment"
            {
                return 54
            }
            else {
                return 120
            }
            
        }
    
    }
    
    //  cellForRowAtIndexPath
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       
       
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("titleCell", forIndexPath: indexPath) as UITableViewCell
            
            
           // cell.selectionStyle = .None
            
            let lblTitle = cell.viewWithTag(10) as! UILabel
            lblTitle.text = resourceDetailArr[indexPath.section].valueForKey("title") as? String
            let txtViewDetail = cell.viewWithTag(11) as! UITextView
            txtViewDetail.text = resourceDetailArr[indexPath.section].valueForKey("description") as? String
            
            let seeMoreBtn = cell.viewWithTag(444) as! UIButton
            seeMoreBtn.addTarget(self, action: #selector(ResourcesPACVC.seeMoreAction(_:)), forControlEvents: .TouchUpInside)
            
            let deleteBtn = cell.viewWithTag(99) as! UIButton
            let editBtn = cell.viewWithTag(98) as! UIButton
            
           // to show or hide the edit and delete button
            if !isHidden {
                
                deleteBtn.hidden = false
                editBtn.hidden = false
                
                deleteBtn.addTarget(self, action: #selector(ResourcesPACVC.btnActionDelete(_:)), forControlEvents: .TouchUpInside)
                editBtn.addTarget(self, action: #selector(ResourcesPACVC.btnActionEdit(_:)), forControlEvents: .TouchUpInside)

            }
            else {
                deleteBtn.hidden = true
                editBtn.hidden = true

                
            }
            
            return cell
            
            
        }else {
            
            // check the Attachment folder
           setUpAttachmentCell(tableViewResource, indexPath: indexPath)
            
         /*  let  attachmentArr1 = (resourceDetailArr[indexPath.section].valueForKey("attachments") as? NSArray)!
            
            if attachmentArr1.count == 0{
                
                return UITableViewCell()
                
            }
            else {
                
                
                // we are modifying the index because we are taking "numberOfRowsInSection" on the basis of attachmentArr which is one less in total cell count
                var processedIndexPath = indexPath.row
                processedIndexPath = processedIndexPath-1
            
            let cellVideo = tableView.dequeueReusableCellWithIdentifier("videoCell", forIndexPath: indexPath) as UITableViewCell
            
            // cellVideo.selectionStyle = .None
            
            let videoLinkImage = cellVideo.viewWithTag(16) as! UIImageView
                videoLinkImage.hidden = false
                
            print_debug("Image URL\((attachmentArr1.objectAtIndex(processedIndexPath).objectForKey("url") as? String)!))")
                
            videoLinkImage.sd_setImageWithURL(NSURL.init(string: (attachmentArr1.objectAtIndex(processedIndexPath).objectForKey("url") as? String)!), placeholderImage: UIImage.init(named: "ic_instruction_video"))
        }*/
  
        }
        return UITableViewCell()
        
    }
    
    // MARK:-    Method to set up cells for attachment
    
    func setUpAttachmentCell(tv: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        attachmentArr = (resourceDetailArr[indexPath.section].valueForKey("attachments") as? NSArray)!

        if attachmentArr!.count == 0{
       
            return UITableViewCell()
            
        }
        else {
        
        
        // we are modifying the index because we are taking "numberOfRowsInSection" on the basis of attachmentArr which is one less in total cell count
        var processedIndexPath = indexPath.row
        processedIndexPath = processedIndexPath-1
        
        print_debug("Processed index path:\(processedIndexPath) Item type:\(self.attachmentArr?.objectAtIndex(processedIndexPath).objectForKey("type")) --- \(self.attachmentArr?.objectAtIndex(processedIndexPath).objectForKey("type"))")
            
        
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
            
            videoLinkImage.hidden = false
            
            print_debug("Image URL\((self.attachmentArr?.objectAtIndex(processedIndexPath).objectForKey("url") as? String)!))")
            videoLinkImage.sd_setImageWithURL(NSURL.init(string: (self.attachmentArr?.objectAtIndex(processedIndexPath).objectForKey("url") as? String)!), placeholderImage: UIImage.init(named: "ic_instruction_video"))
            
            
            // 8 th March
            
            if let imageUrlStr = self.attachmentArr?.objectAtIndex(processedIndexPath).objectForKey("url") as? String //datDict!["link"]
            {
                let customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
                let image_url = NSURL(string: (imageUrlStr.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet))! )
                if (image_url != nil) {
                    
                    let qualityOfServiceClass = QOS_CLASS_BACKGROUND
                    let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
                    dispatch_async(backgroundQueue, {
                        
                        let grabTime = 0.5
                        if let image = self.generateThumnail(image_url!, fromTime: Float64(grabTime))
                        {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                //thumbVideo.setImage(image, forState: .Normal)
                                videoLinkImage.image = image//self.addGradientOnImage(image)
                            })
                        }
                        else
                        {
                            print_debug("No image")
                        }
                    })
                    
                }
            }
            return cellVideo
         
         }
         
        }
        
        return UITableViewCell()
    }
    
    
    
    //MARK: - addGradientOnImage
    
    
    func addGradientOnImage(image: UIImage) -> UIImage
    {
        
        UIGraphicsBeginImageContext(image.size)
        let context = UIGraphicsGetCurrentContext()
        
        image.drawAtPoint(CGPointMake(0, 0))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations:[CGFloat] = [0.0, 1.0]
        let top = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0).CGColor
        let bottom = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).CGColor
        let gradient = CGGradientCreateWithColors(colorSpace,
                                                  [top, bottom], locations)
        
        let startPoint = CGPointMake(image.size.width / 2, image.size.height / 2)
        let endPoint = CGPointMake(image.size.width / 2, image.size.height)
        CGContextDrawLinearGradient(context!, gradient!, startPoint, endPoint,CGGradientDrawingOptions(rawValue: 0))
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return finalImage
        
    }
    
    
    
    
    // MARK:- Thumbnail 
    func generateThumnail(url : NSURL, fromTime:Float64) -> UIImage? {
        
        let asset : AVAsset = AVAsset(URL: url )
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(0.5, 1000)
        var actualTime = kCMTimeZero
        var thumbnail : CGImageRef?
        do {
            thumbnail = try imageGenerator.copyCGImageAtTime(time, actualTime: &actualTime)
            return UIImage(CGImage: thumbnail!)
        }
        catch let error as NSError {
            print_debug(error.localizedDescription)
            return UIImage(named: "ic_instruction_video")!
        }
        
    }
    
    
    
    
    //MARK: - play Video On Cell Tap
    func playVideoOnCellTap(link : String ) -> Void {//func playVideoOnCellTap(indexPath: NSIndexPath ) -> Void {
        
        var urlStr = String?()
        
           // let dataDict = self.dataArra![indexPath.row] as? [String:String]
        urlStr = link
        
        
        if  urlStr != nil {
            
            let WebVC:WebViewVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("WebViewVC") as! WebViewVC
            WebVC.title = "Video"
            WebVC.urlStr = urlStr!
            self.navigationController?.pushViewController(WebVC, animated: true)
            
//            self.moviePlayer = MPMoviePlayerViewController(contentURL: NSURL(string:urlStr!)!)
//            self.moviePlayer.moviePlayer.movieSourceType = .Unknown
//            self.moviePlayer.moviePlayer.prepareToPlay()
//            self.moviePlayer.moviePlayer.shouldAutoplay = true
//            //[[self.moviePlayer moviePlayer] setControlStyle:MPMovieControlStyleNone];
//            //[[self.moviePlayer moviePlayer] setFullscreen:YES animated:YES];
//            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.mpMoviePlayerLoadStateDidChange(_:)), name: MPMoviePlayerLoadStateDidChangeNotification, object: nil)
//            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.moviePlaybackDidFinish), name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
//            self.presentMoviePlayerViewControllerAnimated(self.moviePlayer)
//            self.moviePlayer.moviePlayer.play()
            
            
        }
        
    }
    
    //MARK: - Player event notifications
    func mpMoviePlayerLoadStateDidChange(notification: NSNotification) {
        
        
        //    //NSLog(@"loadstate change: %lu", (unsigned long)[self.moviePlayer moviePlayer].loadState);
        //
        //    if (([self.moviePlayer moviePlayer].loadState & MPMovieLoadStatePlayable) == MPMovieLoadStatePlayable)
        //    {
        //        //NSLog(@"yay, it became playable");
        //    }
        
        
    }
    
    func moviePlaybackDidFinish() {
        
        print_debug("Movie finished!!!")
        
    }
    
    
  //MARK:- Did select
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.layoutSubviews()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        print_debug(indexPath.row)
        
        if(indexPath.row != 0)
        {
        var processedIndexPath = indexPath.row
        processedIndexPath = processedIndexPath-1
        attachmentArr = (resourceDetailArr[indexPath.section].valueForKey("attachments") as? NSArray)!
            
        if self.attachmentArr?.objectAtIndex(processedIndexPath).objectForKey("type") as? String == "video" {
        
        playVideoOnCellTap((self.attachmentArr?.objectAtIndex(processedIndexPath).objectForKey("url") as? String)!)
        }
        else  {
            
        // redirection to next VC for WebView
        let WebVC:WebViewVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("WebViewVC") as! WebViewVC
        
        let dict = self.attachmentArr?.objectAtIndex(processedIndexPath) as! [String:String]     //self.attachmentArr![indexPath.row] as! [String:String]
        
        WebVC.title = "Resource"
       
        if dict["url"] != nil {
         
            print_debug("Dict \(dict)")
            print_debug("URL TEST: \(dict["url"]!)")
            WebVC.urlStr = dict["url"]!
            self.navigationController?.pushViewController(WebVC, animated: true)
            
            if dict["type"] == "video" {
                print_debug("VIDEO DICT")
            }
            
            
        }
        
        }
        }
        
        
       
    }
    
}

