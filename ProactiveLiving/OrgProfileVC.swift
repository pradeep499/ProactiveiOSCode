//
//  OrgProfileVC.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 30/09/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit

class OrgProfileVC: UIViewController,UIScrollViewDelegate {
    @IBOutlet weak var blurImage: UIImageView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblAboutOrg: UILabel!
    @IBOutlet weak var btnPhone: UIButton!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var gridCollectionView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var arrButtonImages : Array<String> = Array()
    var dataDict = [String : AnyObject]()
    var followStatus = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgBack.contentMode = .ScaleAspectFill
        imgBack.clipsToBounds = true

        imgProfile.layer.borderWidth = 1.0
        imgProfile.contentMode = .ScaleAspectFit
        imgProfile.backgroundColor = UIColor.whiteColor()
        imgProfile.layer.masksToBounds = false
        imgProfile.layer.borderColor = UIColor.lightGrayColor().CGColor
        imgProfile.layer.cornerRadius = 5
        imgProfile.clipsToBounds = true
    
        tableViewOutlet.delegate = self
        
        print("DATA DICT\(dataDict)")
        
        if let imageBackUrlStr = dataDict["backgroundImageUrl"] as? String {
            let image_url = NSURL(string: imageBackUrlStr )
            if (image_url != nil) {
                imgBack.setImageWithURL(image_url)
            }
        }
        
        if let imageLogoUrlStr = dataDict["logoUrl"] as? String {
            let image_url = NSURL(string: imageLogoUrlStr )
            if (image_url != nil) {
                imgProfile.setImageWithURL(image_url)
            }
        }
        
        lblAboutOrg.text = dataDict["desc"] as? String
        lblTitle.text = dataDict["name"] as? String
        
        btnEmail.addTarget(self, action: #selector(btnEmailClick(_:)), forControlEvents: .TouchUpInside)
        btnPhone.addTarget(self, action: #selector(btnDialUpClick(_:)), forControlEvents: .TouchUpInside)

        
        // Do any additional setup after loading the view.
        
//        arrButtonImages=[
//        "about",
//        "education",
//        "videos",
//        "promotions",
//        "announcements",
//        "broadcasts",
//        "add_favorite",
//        "follow",
//        "share",
//        "social",
//        "website",
//        "message"]
        
        
        // changed as per client request 28 Apr
        
       // arrButtonImages=["about","broadcasts","follow","videos", "website"]
        
        // changed as per client request 3 May
        
        arrButtonImages=["about","broadcasts","follow","message", "website", "videos"]

        
    }
    
    
    //MARK: - UIScrollView delegate to Animate Table Header
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let y: CGFloat = -scrollView.contentOffset.y
        if y > 0 {
            self.imgBack.frame = CGRectMake(0, scrollView.contentOffset.y, screenWidth + y, 202 + y)
            self.imgBack.center = CGPointMake(self.tableViewOutlet.center.x, self.imgBack.center.y)
            self.blurImage.frame = CGRectMake(0, scrollView.contentOffset.y, screenWidth + y, 202 + y)
            self.blurImage.center = CGPointMake(self.tableViewOutlet.center.x, self.blurImage.center.y)
        }
    }
    
    
    func serviceFollowOrganization(status : Int, organizationId:String) {
        
        
        
        if AppDelegate.checkInternetConnection() {
            isPostServiceCalled = true
            
            
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            parameters["organizationId"] = organizationId
            parameters["status"] = status
         
            //call global web service class latest
            Services.postRequest(ServiceFollowOrganization, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                isPostServiceCalled = false
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        AppHelper.showAlertWithTitle(AppName, message: responseDict["errorMsg"] as! String, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                     
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

    
    
    //MARK:- Collection View
    
    //*** Delegate and Data Source methods of UicollectionView ***//
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrButtonImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GridCell", forIndexPath: indexPath) 
        //cell.layer.borderWidth = 1.0
        //cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        let imgBackgroung = cell.contentView.viewWithTag(111) as! UIImageView
        imgBackgroung.image = UIImage(named: arrButtonImages[indexPath.row])

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        
        if (indexPath.row==0) {  // About
            
            if let aboutUrl = self.dataDict["aboutUs"] {
                
                // redirection to next VC for WebView
                let WebVC:WebViewVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("WebViewVC") as! WebViewVC
                WebVC.title = "About"
                WebVC.urlStr = aboutUrl as! String
                self.navigationController?.pushViewController(WebVC, animated: true)
                
               //  UIApplication.sharedApplication().openURL(NSURL(string: aboutUrl as! String)!)
            }
            
           
        }
        else if (indexPath.row==1){ // Broadcast
            let broadCast: BroadcastVC = self.storyboard!.instantiateViewControllerWithIdentifier("BroadcastVC") as! BroadcastVC
            broadCast.dataDictArr = dataDict["articles"] as? [AnyObject]
            broadCast.subTitle = dataDict["name"] as? String
            self.navigationController?.pushViewController(broadCast, animated: true)
            
        }
        else if (indexPath.row==2){  // Follow  // API hit for follow
            
           
            let alertController = UIAlertController(title:APP_NAME, message: "Do you want to Follow ?" , preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                
            }))
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                
               
                let organizationId = self.dataDict["_id"] as! String
                self.followStatus = 1
                self.serviceFollowOrganization(self.followStatus, organizationId: organizationId)
                
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            
            
        }
       else if(indexPath.row==3) { // Message
            
            let email = self.dataDict["email"] as! String
            UIApplication.sharedApplication().openURL(NSURL(string: "mailto:\(email)")!)
            
            
        }
      else if(indexPath.row==4)  // Website
        {
            let webUrl = self.dataDict["latestArticleLink"] as! String
            //self.btnWebLinkClick(webUrl)
            
            // redirection to next VC for WebView
            let WebVC:WebViewVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("WebViewVC") as! WebViewVC
            WebVC.title = "Website"
            WebVC.urlStr = webUrl as! String
            self.navigationController?.pushViewController(WebVC, animated: true)

            
            
        }
        else if (indexPath.row == 5){ //Videos
            
            let videosContainer: VideosContainer = self.storyboard!.instantiateViewControllerWithIdentifier("VideosContainer") as! VideosContainer
            videosContainer.dataDict=dataDict["videos"] as! [String:AnyObject]
            videosContainer.videoContainerType = .Explore
            self.navigationController?.pushViewController(videosContainer, animated: true)

            
        }
        
        
        else {

        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(screenWidth/3 - 34 , 90)///CGSizeMake(collectionView.frame.size.width/3-34, collectionView.frame.size.height/4-44)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 20
    }
    
    func btnWebLinkClick(urlStr : String){
        
        var url : String!
        
        if(urlStr.hasPrefix("http://") || urlStr.hasPrefix("https://")){
            
            url = urlStr
        }
        else
        {
            url = "http://" + urlStr
        }
        
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        
    }
    
    func btnEmailClick(sender: UIButton)  {
        let email = self.dataDict["email"] as! String
        UIApplication.sharedApplication().openURL(NSURL(string: "mailto:\(email)")!)
    }
    
    func btnDialUpClick(sender: UIButton)  {
        print(sender)
        
        let phoneNumber: String = self.dataDict["mobile"] as! String
        if let url = NSURL(string: "tel://\(phoneNumber)") {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
extension OrgProfileVC : UITableViewDelegate {
    
    
    
    
}


