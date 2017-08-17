//
//  VideosVC.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 05/10/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class VideosVC: UIViewController {

    
    //MARK:- Properties
    var dataArra = [AnyObject]?()
    var yourArray = [String]()
    var moviePlayer = MPMoviePlayerViewController()
    
    var profilePersionalArr = [AnyObject]()
    var profileEducationalArr  = [AnyObject]()
    var profileInspirationalArr = [AnyObject]()
    var videoId = String()
    var removeVideoIndex = -1
    

    
    var videoContainerType:VideoContainerType?
    //to check owner or friend not nill all time
    var viewerUserID:String!
    
    //MARK:- Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(reloadTable),
            name: "ProfileVideoNoti",
            object: nil)
        
       
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if videoContainerType == .Profile{
            
            self.getProfileVideosAPI()
            
            self.profilePersionalArr = [AnyObject]()
            self.profileEducationalArr  = [AnyObject]()
            self.profileInspirationalArr  = [AnyObject]()
            
            
            
        }
    }
    
    func reloadTable(notification: NSNotification){
    
        self.tableView.reloadData()
    }
    
   
    //mark- UITableview Delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if videoContainerType == .Explore {
            if dataArra?.count == 0{
                HelpingClass.toSetEmptyViewInTableViewNoDataAvaiable(tableView, message: "No videos available.")
            }else{
                tableView.backgroundView = nil
            }
            return dataArra!.count
            
        }else if videoContainerType == .Profile{
            
            if self.title == "PERSONAL" {
                if profilePersionalArr.count == 0{
                    HelpingClass.toSetEmptyViewInTableViewNoDataAvaiable(tableView, message: "No videos available.")
                }else{
                    tableView.backgroundView = nil
                }
                return profilePersionalArr.count
            }else if self.title == "EDUCATIONAL" {
                if profileEducationalArr.count == 0{
                    HelpingClass.toSetEmptyViewInTableViewNoDataAvaiable(tableView, message: "No videos available.")
                }else{
                    tableView.backgroundView = nil
                }
                return profileEducationalArr.count
            }else if self.title == "INSPIRATIONAL" {
                if profileInspirationalArr.count == 0{
                    HelpingClass.toSetEmptyViewInTableViewNoDataAvaiable(tableView, message: "No videos available.")
                }else{
                    tableView.backgroundView = nil
                }
                return profileInspirationalArr.count
            }
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if videoContainerType == .Explore {
            
            let cell = self.tableView.dequeueReusableCellWithIdentifier("CellVideos", forIndexPath: indexPath)
            cell.selectionStyle = .None
            
            let thumbVideo = cell.contentView.viewWithTag(1) as! UIImageView
            
            let lbl_duration = cell.contentView.viewWithTag(2) as! UILabel
            let lbl_title = cell.contentView.viewWithTag(3) as! UILabel
            let lbl_author = cell.contentView.viewWithTag(4) as! UILabel
            
            let btn_views = cell.contentView.viewWithTag(5) as! UIButton
            let btn_comments = cell.contentView.viewWithTag(6) as! UIButton
            let btn_like = cell.contentView.viewWithTag(7) as! UIButton
            let btn_share = cell.contentView.viewWithTag(8) as! UIButton
            
            self.btnImgInsect(btn_comments)
            self.btnImgInsect(btn_like)
            
            //thumbVideo.addTarget(self, action: #selector(self.btnPlayVideoClick(_:)), forControlEvents: .TouchUpInside)
            //var escapedString = self.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
            
            let datDict = self.dataArra![indexPath.row] as? [String:String]
            
            if let val = datDict!["title"] {
                lbl_title.text = val
            }
            if let val = datDict!["author"] {
                lbl_author.text = "By: " + val
            }
            
            if let imageUrlStr = datDict!["link"]  {
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
                                thumbVideo.image = self.addGradientOnImage(image)
                            })
                        }
                        else
                        {
                            print_debug("No image")
                        }
                    })
                    
                }
            }
            
            return cell
            
        }else if videoContainerType == .Profile{
            
            let cell = self.tableView.dequeueReusableCellWithIdentifier("ProfileVideoCell", forIndexPath: indexPath)
            cell.selectionStyle = .None
            
            let thumbVideo = cell.contentView.viewWithTag(1) as! UIImageView
            
            let lbl_duration = cell.contentView.viewWithTag(2) as! UILabel
            //let lbl_title = cell.contentView.viewWithTag(3) as! UILabel
            let lblDescription = cell.contentView.viewWithTag(3) as! UILabel

            let lbl_author = cell.contentView.viewWithTag(4) as! UILabel
            let lblTitle = cell.contentView.viewWithTag(33) as! UILabel  // be me
            let btnDelete = cell.contentView.viewWithTag(12) as! UIButton
            let btnEdit   = cell.contentView.viewWithTag(11) as! UIButton
            
           
            // to show or hide the Delete and Edit button
            
            if String(AppHelper.userDefaultsForKey(_ID)) == viewerUserID{
                //Owner
                 btnDelete.hidden = false
                 btnEdit.hidden = false
            }
            else {
                 btnDelete.hidden = true
                 btnEdit.hidden = true
            }
            
            var datDict = [String:String]()
            
            if self.title == "PERSONAL" {
                datDict =  (profilePersionalArr[indexPath.row] as? [String:String])!
            }else if self.title == "EDUCATIONAL" {
                let data = profileEducationalArr[indexPath.row]
                print_debug("Educational Data = ", data)
                datDict =  (profileEducationalArr[indexPath.row] as? [String : String])!
                
            }else if self.title == "INSPIRATIONAL" {
                datDict =  (profileInspirationalArr[indexPath.row] as? [String:String])!
            }
            
            
            
            if let val = datDict["title"] {
                lblTitle.text = val
            }
            if let val = datDict["author"] {
                lbl_author.text = "By: " + val
            }
            if let val = datDict["description"]{
                
                lblDescription.text = val
            }
            
            
            
            if let imageUrlStr = datDict["url"]  {
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
                                thumbVideo.image = self.addGradientOnImage(image)
                            })
                        }
                        else
                        {
                            print_debug("No image")
                        }
                    })
                    
                }
            
            }
            return cell
            
        }
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("CellVideos", forIndexPath: indexPath)
        cell.selectionStyle = .None
        
        return cell;
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.playVideoOnCellTap(indexPath)
        
        
        

    }
    
    
    //MARK:- Button Actions
    
    
    @IBAction func seeMoreBtnAction(sender: AnyObject) {
        
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath =  self.tableView.indexPathForRowAtPoint(buttonPosition)
        
        
//        let data = profileEducationalArr[indexPath!.row]
//        print_debug(data)
        
        
        let seeMoreVC = AppHelper.getPacStoryBoard().instantiateViewControllerWithIdentifier("MoreDetailVC") as! MoreDetailVC
        
        var datDict = [String:String]()
        
        if self.title == "PERSONAL" {
            datDict =  (profilePersionalArr[indexPath!.row] as? [String:String])!
        }else if self.title == "EDUCATIONAL" {
            let data = profileEducationalArr[indexPath!.row]
            print_debug("Educational Data = ", data)
            datDict =  (profileEducationalArr[indexPath!.row] as? [String : String])!
            
        }else if self.title == "INSPIRATIONAL" {
            datDict =  (profileInspirationalArr[indexPath!.row] as? [String:String])!
        }
        
        
        if let titleStr = datDict["title"] {
            seeMoreVC.titleStr = titleStr
        }
        seeMoreVC.detailStr = datDict["description"] as String!
                
        self.navigationController?.pushViewController(seeMoreVC, animated: true)
        
        print_debug("See More")
    
    }
    @IBAction func onClickEditCellBtn(sender: AnyObject) {
        
        let button: UIButton = sender as! UIButton
        
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath =  self.tableView.indexPathForRowAtPoint(buttonPosition)
        
        
        let vc = AppHelper.getProfileStoryBoard().instantiateViewControllerWithIdentifier("AddOrEditVideoVC") as! AddOrEditVideoVC
        vc.videoType =  "Edit"
        
        
        if indexPath != nil {
            
             if videoContainerType == .Profile{
                
                var datDict = [String:String]()
                
                if self.title == "PERSONAL" {
                    datDict =  (profilePersionalArr[indexPath!.row] as? [String:String])!
                }else if self.title == "EDUCATIONAL" {
                    datDict =  (profileEducationalArr[indexPath!.row] as? [String : String])!
                }else if self.title == "INSPIRATIONAL" {
                    datDict =  (profileInspirationalArr[indexPath!.row] as? [String:String])!
                }
                vc.videoDict = datDict
            }
            
        }
        
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func onClickRemoveCellBtn(sender: AnyObject) {
        
        let button: UIButton = sender as! UIButton
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath =  self.tableView.indexPathForRowAtPoint(buttonPosition)
        
        if indexPath != nil {
            
            if videoContainerType == .Profile{
                
                var datDict = [String:String]()
                
                if self.title == "PERSONAL" {
                    datDict =  (profilePersionalArr[indexPath!.row] as? [String:String])!
                }else if self.title == "EDUCATIONAL" {
                    datDict =  (profileEducationalArr[indexPath!.row] as? [String : String])!
                }else if self.title == "INSPIRATIONAL" {
                    datDict =  (profileInspirationalArr[indexPath!.row] as? [String:String])!
                }
                
              //  self.removeVideoAPI(datDict["_id"]!, index: indexPath!.row)
                self.videoId = datDict["_id"]!
                self.removeVideoIndex = indexPath!.row
                
            }
        }
        
        AppHelper.showAlertWithTitle(AppName, message: "Do you want to delete video ?", tag: 11, delegate: self, cancelButton: "No", otherButton: "Yes")
        
    }
    
    
    //MARK: - btnImgInsect with btnTitle
    func btnImgInsect(btn:UIButton) -> Void {
        
        let spacing: CGFloat = 8.0
        let labelString = NSString(string: btn.titleLabel!.text!)
         
        btn.titleEdgeInsets = UIEdgeInsetsMake(0.0, -btn.frame.size.width + 15, 0.0, 0.0)
        
        
        let titleSize = labelString.sizeWithAttributes([NSFontAttributeName: btn.titleLabel!.font])
        btn.imageEdgeInsets = UIEdgeInsetsMake( 0.0, (titleSize.width + spacing), 0.0, 0.0)
        
    }
    
    //MARK: - addGradientOnImage
    func addGradientOnImage(image: UIImage) -> UIImage
    {
//        let size = CGSize(width:image.size.width, height:image.size.height)
//        let layer = CAGradientLayer()
//        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//        layer.colors = [UIColor.blackColor().CGColor,
//        UIColor.whiteColor().CGColor] // end color
//        UIGraphicsBeginImageContext(size)
//        layer.renderInContext(UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
//        UIGraphicsEndImageContext()

        
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
    
    //MARK: - Get thumbnail from video url
//    func getPreviewImageForVideoAtURL(videoURL: NSURL, atInterval: Int) -> UIImage? {
//        print_debug("Taking pic at \(atInterval) second")
//        let asset = AVAsset(URL: videoURL)
//        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
//        assetImgGenerate.appliesPreferredTrackTransform = true
//        let time = CMTimeMakeWithSeconds(Float64(atInterval), 100)
//        do {
//            let img = try assetImgGenerate.copyCGImageAtTime(time, actualTime: nil)
//            let frameImg = UIImage(CGImage: img)
//            return frameImg
//        } catch {
//            /* error handling here */
//        }
//        return nil
//    }
    
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
    func playVideoOnCellTap(indexPath: NSIndexPath ) -> Void {
       
        var urlStr = String?()
        
        if videoContainerType == .Explore{
            
            let dataDict = self.dataArra![indexPath.row] as? [String:String]
            urlStr = dataDict!["link"]
            
        }else{
            // ProfileVideo
            
            var dataDict = [String:String]()
            
            if self.title == "PERSONAL" {
                dataDict =  (profilePersionalArr[indexPath.row] as? [String:String])!
            }else if self.title == "EDUCATIONAL" {
               dataDict =  (profileEducationalArr[indexPath.row] as? [String : String])!
            }else if self.title == "INSPIRATIONAL" {
                dataDict =  (profileInspirationalArr[indexPath.row] as? [String:String])!
            }
            
            urlStr = dataDict["url"]
        }
        
        
        
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
    
    //MARK: - play Video On thumbnail Tap
    func btnPlayVideoClick(sender: UIButton) -> Void {
        
        let point = self.tableView.convertPoint(CGPoint.zero, fromView: sender)
        
        guard let indexPath = self.tableView.indexPathForRowAtPoint(point) else {
            fatalError("can't find point in tableView")
        }
        
        if let urlString = self.dataArra![indexPath.row] as? String {
        
        let WebVC:WebViewVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("WebViewVC") as! WebViewVC
        WebVC.title = "Video"
        WebVC.urlStr = urlString
        self.navigationController?.pushViewController(WebVC, animated: true)
        }
        
//        self.moviePlayer = MPMoviePlayerViewController(contentURL: NSURL(string:urlString)!)
//        self.moviePlayer.moviePlayer.movieSourceType = .Unknown
//        self.moviePlayer.moviePlayer.prepareToPlay()
//        self.moviePlayer.moviePlayer.shouldAutoplay = true
//        //[[self.moviePlayer moviePlayer] setControlStyle:MPMovieControlStyleNone];
//        //[[self.moviePlayer moviePlayer] setFullscreen:YES animated:YES];
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.mpMoviePlayerLoadStateDidChange(_:)), name: MPMoviePlayerLoadStateDidChangeNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.moviePlaybackDidFinish), name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
//        self.presentMoviePlayerViewControllerAnimated(self.moviePlayer)
//        self.moviePlayer.moviePlayer.play()
        
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
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- API
    
    
    
    func getProfileVideosAPI() -> Void {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = viewerUserID // AppHelper.userDefaultsForKey(_ID)
            parameters["filter"] = "videos"
            
            
            
            //call global web service class latest
            Services.postRequest(ServiceGetProfileDataByFilter, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        print_debug("Photo Response = ")
                        print_debug( responseDict["result"])
                        
                        
                        if let arr = responseDict["result"]  as? [AnyObject]   {
                            
                            for dict in arr {
                                
                                if (dict["_id"] as! String == "PERSONAL"){
                                    
                                    self.profilePersionalArr = dict["videos"] as! [AnyObject]
                                    
                                    
                                }else if  (dict["_id"] as! String == "EDUCATIONAL"){
                                    self.profileEducationalArr = dict["videos"] as! [AnyObject]
                                    
                                }else if  (dict["_id"] as! String == "INSPIRATIONAL"){
                                    
                                    self.profileInspirationalArr = dict["videos"] as! [AnyObject]
                                    
                                }
                            }
                            self.tableView.reloadData()
                            
                            
                        }
                        
                    } else {
                        
                        AppHelper.showAlertWithTitle(AppName, message: responseDict["errorMsg"] as! String, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    }
                    
                }else if (status == "Error"){
                    
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
    
    func removeVideoAPI(videoID:String, index:Int) -> Void {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)            
            parameters["type"] = "video"
            parameters["contentId"] = videoID
            
            
            //call global web service class latest
            Services.postRequest(ServiceDeleteImages, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        print_debug("VIDEO REMOVED = ")
                        print_debug(responseDict["result"])
                        
                        if (self.title == "PERSONAL"){
                            
                            self.profilePersionalArr.removeAtIndex(index)
                            
                        }else if  (self.title == "EDUCATIONAL"){
                            self.profileEducationalArr.removeAtIndex(index)
                            
                        }else if  (self.title == "INSPIRATIONAL"){
                            
                            self.profileInspirationalArr.removeAtIndex(index)
                            
                        }
                      
                        
                       AppHelper.showAlertWithTitle(AppName, message: "Video is deleted.", tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                        
                        self.tableView.reloadData()
                            
                    
                        
                    } else {
                        
                        AppHelper.showAlertWithTitle(AppName, message: responseDict["errorMsg"] as! String, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    }
                    
                }else if (status == "Error"){
                    
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

extension VideosVC:UIAlertViewDelegate{
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if alertView.tag == 11 && buttonIndex == 1 {
            
            self.removeVideoAPI(self.videoId, index: self.removeVideoIndex)
        }
    }
}
