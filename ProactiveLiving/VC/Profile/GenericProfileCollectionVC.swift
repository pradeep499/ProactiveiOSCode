//
//  GenericProfileCollectionVC.swift
//  ProactiveLiving
//
//  Created by Affle on 10/01/2017.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit
import Social
import MediaPlayer
import AVKit

protocol GenericProfileCollectionVCDelegate {
    func getSelectedImgData(imgData:NSData, imgName:String) ;
}


class GenericProfileCollectionVC: UIViewController, AttachMentsVCDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var lbl_title: UILabel!

    @IBOutlet weak var cv: UICollectionView!
    
    @IBOutlet weak var btnRight: UIButton!
    
    var genericType:ProfileGenericType?
    
    @IBOutlet weak var layOut_attachmetBottom: NSLayoutConstraint!
    
    
    @IBOutlet weak var attachmentContainerView: UIView!
    
    var photoListArr = [AnyObject]()
    var socialNetworkListArr = [AnyObject]()
    var friendListArr = [AnyObject]()
    
    var moviePlayerController = MPMoviePlayerController()
    var pageFrom:String?
    var delegate:GenericProfileCollectionVCDelegate?
    
    //if this page is back from attachment vc then don't call API
    var willCallGetPhotosOrSocialNetworkList:Bool?
    //to check owner or friend not nill all time
    var viewerUserID:String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.setUpCollectionView()
        willCallGetPhotosOrSocialNetworkList = true
        
        self.setUpPage()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBarHidden = true
        
        if genericType == .SocialNetworks {
            
            self.setUpPage()
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpPage() -> Void {
        
        self.btnRight.hidden = true
        
        if genericType == .Friends {
            self.lbl_title.text = "Friends"
            self.getFriendListAPI()
            
        }else if genericType == .Followers {
            self.lbl_title.text = "Followers"
        }else if genericType == .Gallery {
            
            self.lbl_title.text = "Gallery"
            self.btnRight.hidden = false
            self.btnRight.setImage(UIImage(named: "pf_add"), forState: .Normal)
            
            
            
            let attachments = AttachmentsVC()
            attachments.delegate = self
            
            
            if willCallGetPhotosOrSocialNetworkList == true {
                self.getPhotosOrSocialNetworkList("photos")
            }
            
            
            
        }else if genericType == .SocialNetworks {
            
            self.lbl_title.text = "Social Networks"
            self.btnRight.hidden = false
            self.btnRight.setImage(UIImage(named: ""), forState: .Normal)
            self.btnRight.setTitle("Add", forState: .Normal)
            
            self.getPhotosOrSocialNetworkList("socialNetworks")
            
        }
        
        //hide Attachment VC
        
        self.layOut_attachmetBottom.constant = -350;
        self.cv.reloadData()
        
        //check logged in user or friend
        if String(AppHelper.userDefaultsForKey(_ID)) != viewerUserID{
            //Friend
            self.btnRight.hidden = true
        }
        
        
        
    }
    
    func setUpCollectionView() -> Void {
        
        let w = self.cv.bounds.size.width - 30
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        
        layout.itemSize = CGSize(width: w/3 - 5, height: w/3)
        layout.minimumInteritemSpacing = 6
        layout.minimumLineSpacing = 10
        
        
        
       if genericType == .SocialNetworks {
            
            layout.itemSize = CGSize(width: w/4 - 5, height: w/4)
            
       }else if genericType == .Friends {
        
        layout.itemSize = CGSize(width: w/4 - 5, height: 150)
        
        }
        self.cv!.collectionViewLayout = layout
        
        //check logged in user or friend
        if String(AppHelper.userDefaultsForKey(_ID)) == viewerUserID{
            //Owner
        }else{
            //Friend
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "attachmentsSegue" {
            
            let attachmetsVC = segue.destinationViewController as! AttachmentsVC
            attachmetsVC.delegate = self
        }
    }
    
    @IBAction func onClickBackBtn(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
 
    @IBAction func onClickRightBtn(sender: AnyObject) {
      
        
        if genericType == .Gallery {
            
            willCallGetPhotosOrSocialNetworkList = false
            self.showAttachmentView()
            
        }else if genericType == .SocialNetworks {
            
            //go to Generic Table VC
            
            let vc = AppHelper.getProfileStoryBoard().instantiateViewControllerWithIdentifier("GenericProfileTableVC") as! GenericProfileTableVC
            vc.genericType = .SocialNetworks
            vc.socialNetworkArr = self.socialNetworkListArr
            vc.viewerUserID = AppHelper.userDefaultsForKey(_ID) as! String
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
    
    
    
    //MARK:- Attachment View
    
    func hideAttachmentView() -> Void {
        
        self.layOut_attachmetBottom.constant = -350;
        
        UIView.animateWithDuration(0.5, animations:
            {
                self.view.layoutIfNeeded()
        })
    }
    
    func showAttachmentView() -> Void {
        
        self.layOut_attachmetBottom.constant = 0;
        
        UIView.animateWithDuration(0.5, animations:
            {
                self.view.layoutIfNeeded()
        })
    }
    

    //MARK: AttachmentsDelegates 
    
    func didCancelBtnPressed() {
        
        willCallGetPhotosOrSocialNetworkList = true
        self.hideAttachmentView()
    }
    
    func didFinishUpload(dict: [String:String]) {
        
        willCallGetPhotosOrSocialNetworkList = true
        self.photoListArr.append(dict)
        self.cv.reloadData()
    }
    //MARK: API
    
    func getPhotosOrSocialNetworkList(type:String) -> Void {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = viewerUserID // AppHelper.userDefaultsForKey(_ID)
            
            
            
            parameters["filter"] = type
            
            
            //call global web service class latest
            Services.postRequest(ServiceGetProfileDataByFilter, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        
                        
                       
                            
                            if type == "photos" {
                                
                                print("Photo Response = ", responseDict["result"])
                                
                                 if let content = responseDict["result"]!["gallery"]{
                                
                                self.photoListArr = content as! [AnyObject]
                                }
                                
                            }else if type == "socialNetworks"{
                                
                                print("Social Network Response = ", responseDict["result"])
                                
                                 if let socialNetwork = responseDict["result"]!["socialNetwork"]{
                                self.socialNetworkListArr = socialNetwork as! [AnyObject]
                            }
                        }
                        
                            
                            self.cv.reloadData()
                        
                        
                        
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
    
    
    
    func getFriendListAPI() -> Void {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = viewerUserID // AppHelper.userDefaultsForKey(_ID)
            
            
            
            //call global web service class latest
            Services.postRequest(ServiceGetUserFriendList, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        print("Friends Response = ", responseDict["result"])
                        
                        if let content = responseDict["result"]{
                            
                            self.friendListArr = content as! [AnyObject]
                        }
                        self.cv.reloadData()
                        
                        
                        
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

extension GenericProfileCollectionVC:UICollectionViewDataSource{
    
   
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
        let w = collectionView.bounds.size.width - 30
        
        if genericType == .SocialNetworks {
            
            return CGSize(width: w/4 - 5 , height: w/4 - 5)
            
        }else  if genericType == .Friends {
            
            return CGSize(width: w/3 - 5 , height:150  )
        }
        
        
        return CGSize(width: w/3 - 5 , height: w/3)
        
    }
   /*
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom:5, right: 10)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 3
    }
    
    */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom:5, right: 10)
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if genericType == .Friends {
            return self.friendListArr.count
        }else if genericType == .Followers {
            return 15
        }else if genericType == .Gallery {
            return self.photoListArr.count
        }else if genericType == .SocialNetworks{
            return self.socialNetworkListArr.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if genericType == .Friends {
           
            let cell =  collectionView.dequeueReusableCellWithReuseIdentifier("FollowerCell", forIndexPath: indexPath)
            
            let iv_frImg = cell.viewWithTag(1) as! UIImageView
            let lbl_name = cell.viewWithTag(2) as! UILabel
            
            iv_frImg.layer.borderWidth = 1.0
            iv_frImg.contentMode = .ScaleAspectFill
            iv_frImg.backgroundColor = UIColor.whiteColor()
            iv_frImg.layer.masksToBounds = false
            iv_frImg.layer.borderColor = UIColor.lightGrayColor().CGColor
            iv_frImg.layer.cornerRadius = iv_frImg.frame.size.height/2
            iv_frImg.clipsToBounds = true
            
            
            let dict = self.friendListArr[indexPath.row] as! [String:AnyObject]
            
            let placeholder = UIImage(named: "ic_booking_profilepic")
            let imageUrlStr = dict["friendId"]!["imgUrl"] as! String!
            let fName = dict["friendId"]!["firstName"] as? String
            let lName = dict["friendId"]!["lastName"] as? String
            
            iv_frImg.sd_setImageWithURL(NSURL(string: imageUrlStr ), placeholderImage: placeholder)
            lbl_name.text = fName! + " " + lName!
            
            return cell
        }/*else if genericType == .Followers {
            
            let cell = FollowerCell.setUpCell(collectionView, indexPath: indexPath)
            return cell
            
        } */else if genericType == .Gallery {
            
            let dict = self.photoListArr[indexPath.row] as! [String : String]
            
            let cell = self.setUpPhotoCell(collectionView, indexPath: indexPath, dict:dict )
            return cell
        }else if genericType == .SocialNetworks {
            
            let cell = self.setUpSocialNetworkCell(collectionView, indexPath: indexPath)
            return cell
            
        }
        
        
        
        
        
        let cell =  collectionView.dequeueReusableCellWithReuseIdentifier("FollowerCell", forIndexPath: indexPath)
        return cell
    }
//}



    

//class PhotoCell: GenericProfileCollectionVC, UIGestureRecognizerDelegate {

    
    func clickUserImage(recognizer: UITapGestureRecognizer )
    {
        
        let pointInTable = recognizer.locationInView(self.cv)
        let indexPath:NSIndexPath = self.cv.indexPathForItemAtPoint(pointInTable)!
        
        let dict = self.photoListArr[indexPath.row]
        
        
        
        let imgUrl = dict["url"] as! String
        let thumbNailName = dict["thumNailName"] as! String
        let postType = dict["type"] as! String
        
        //return to ProfileContainer page
        if (postType == "image" && pageFrom == "ProfileContainer") {
            
            let cell = self.cv.cellForItemAtIndexPath(indexPath)
            cell!.layer.borderWidth = 2.0
            cell!.layer.borderColor = UIColor.grayColor().CGColor

            let thumbIV = cell!.viewWithTag(1) as! UIImageView
            
            let imgData = UIImagePNGRepresentation(thumbIV.image!)
            
            self.delegate!.getSelectedImgData(imgData!, imgName:thumbNailName)
             self.navigationController?.popViewControllerAnimated(true)
            
            return
            
        }else if (postType != "image" && pageFrom == "ProfileContainer"){
            
            HelpingClass.showAlertControllerWithType(.Alert, fromController: self, title: AppName, message: "You cann't select video.", cancelButtonTitle:nil, otherButtonTitle: ["OK"], completion: { (str) in
                
            })
            return
        }
        
        
        
        if postType == "image"{
            
            let fullImageVC: FullScreenImageVC =  AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("FullScreenImageVC") as! FullScreenImageVC
            
            fullImageVC.hidesBottomBarWhenPushed = true
            
            
            
            
            
            //check the thumbNail name is exist ? or generate from video url and save to db
            HelpingClass.isFileExistsAtPath(directory: "/ChatFile", fileName: thumbNailName, completion: {(isExistPath, fileUrl) -> Void in
                
                if isExistPath {
                    fullImageVC.imagePath = fileUrl
                    fullImageVC.downLoadPath = "4"
                }else{
                    fullImageVC.imagePath = imgUrl
                    fullImageVC.downLoadPath = "3"
                }
                self.navigationController?.pushViewController(fullImageVC, animated: true)
            })
            
            
            
            
            
            
        }else if(postType == "video"){
            
            
            var videoName = thumbNailName.stringByReplacingOccurrencesOfString("Thumb", withString: "Video")
            videoName = videoName.stringByReplacingOccurrencesOfString(".jpg", withString: ".mp4")
            
            
            HelpingClass.isFileExistsAtPath(directory: "/ChatFile", fileName: videoName, completion: {(isExistPath, fileUrl) -> Void in
                
                if isExistPath{
                    
                    self.moviePlayerController = MPMoviePlayerController(contentURL:NSURL.fileURLWithPath(fileUrl!))
                    
                }else{
                    
                    self.moviePlayerController = MPMoviePlayerController(contentURL:NSURL(string: imgUrl))
                }
                
                //moviePlayerController.movieSourceType = MPMovieSourceType.Streaming
                self.view.addSubview(self.moviePlayerController.view)
                self.moviePlayerController.fullscreen = true
                self.moviePlayerController.play()
            })
            
            
            
        }
    }
    
     func setUpPhotoCell(collectionView: UICollectionView, indexPath: NSIndexPath, dict:[String:String]!) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath)
        
        
        
        let thumbIV = cell.viewWithTag(1) as! UIImageView
        let iv_videoIcon = cell.viewWithTag(2) as! UIImageView
        let indicator = cell.viewWithTag(3) as! UIActivityIndicatorView
        
        let thumbNailName = dict["thumNailName"]!
        let imgUrl = dict["url"]
        
        
        //check the thumbNail name is exist ? or generate from video url and save to db
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            print("This is run on the background queue")
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                print("This is run on the main queue, after the previous code in outer block")
            })
        })
        
        HelpingClass.isFileExistsAtPath(directory: "/ChatFile", fileName: thumbNailName, completion: {(isExistPath, fileUrl) -> Void in
            
            
            let recognizer = UITapGestureRecognizer(target: self, action:#selector(GenericProfileCollectionVC.clickUserImage(_:)))
            recognizer.delegate = self
            thumbIV.addGestureRecognizer(recognizer)
            thumbIV.userInteractionEnabled = true
            
            
            if dict["type"]   == "image"{
                
                
                iv_videoIcon.hidden = true
                indicator.startAnimating()
                
                indicator.hidden = false
                
                if isExistPath {
                    let img = UIImage(contentsOfFile: fileUrl!)
                    thumbIV.image =  CommonMethodFunctions.imageWithImage(img, scaledToWidth: Float( UIScreen.mainScreen().bounds.size.width) - 30);
                    indicator.hidden = true
                    indicator.stopAnimating()
                }else{
                    thumbIV.sd_setImageWithURL(NSURL(string: imgUrl!), placeholderImage: UIImage(named:  "cell_blured_heigh")) {
                        (img,  err,  cacheType,  imgUrl) -> Void in
                        
                        thumbIV.image =  CommonMethodFunctions.imageWithImage(img, scaledToWidth: Float( UIScreen.mainScreen().bounds.size.width) - 30);
                        indicator.hidden = true
                        indicator.stopAnimating()
                        
                    }
                    
                    
                    
                }
                
                
            }else{
                //for video
                
                iv_videoIcon.hidden = false
                
                indicator.hidden = false
                indicator.startAnimating()
                
                if isExistPath {
                    let img = UIImage(contentsOfFile: fileUrl!)
                    thumbIV.image = CommonMethodFunctions.imageWithImage(img, scaledToWidth: Float( UIScreen.mainScreen().bounds.size.width) - 30);
                    indicator.hidden = true
                } else {
                    
                    //generate thumb from video url    and display on cell
                    let img =  CommonMethodFunctions.generateThumbImage(NSURL(string: imgUrl!)!) //self.generateThumnail(sourceURL: NSURL(string: imgUrls.first!)!)
                    thumbIV.image = CommonMethodFunctions.imageWithImage(img, scaledToWidth: Float( UIScreen.mainScreen().bounds.size.width) - 30);
                    
                    //write to db
                    if img != nil{
                        
                        let imgData = UIImagePNGRepresentation(img) as NSData?
                        
                        HelpingClass.writeToPath(directory: "/ChatFile", fileName: thumbNailName, dataToWrite: imgData!, completion: {(isWritten:Bool, err:NSError?) -> Void in
                            indicator.hidden = true
                            
                            if isWritten{
                                
                            }
                        })
                    }
                    
                }
                indicator.stopAnimating()
                
            }
            
            
        })
        
        
        
        
        
        
        return cell
    }
    
    
    func setUpSocialNetworkCell(collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCellWithReuseIdentifier("SocialNetworkCell", forIndexPath: indexPath)
        
        let iv_social = cell.viewWithTag(1) as! UIImageView
        
        let dict = self.socialNetworkListArr[indexPath.row] as! [String:String]
        
        if dict["type"] == "fb" {
            
            iv_social.image = UIImage(named: "facebook")
        }else if dict["type"] == "google" {
            
            iv_social.image = UIImage(named: "google")
        }else if dict["type"] == "linkedIn" {
            
            iv_social.image = UIImage(named: "linkden")
        }else if dict["type"] == "twitter" {
            
            iv_social.image = UIImage(named: "twitter")
        }else if dict["type"] == "inst" {
            
            iv_social.image = UIImage(named: "insta")
        }
        
    /*    switch indexPath.row {
        case 0:
            
            break
        case 1:
            
            break
        case 2:
            iv_social.image = UIImage(named: "")
            break
        case 3:
            iv_social.image = UIImage(named: "")
            break
        case 4:
            iv_social.image = UIImage(named: "")
            break
        
            
        default:
            break
        }*/
        
        
        
        
        
        
        return cell
    }
    
    
    
    
    
}

extension GenericProfileCollectionVC:UICollectionViewDelegate{
        
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
       
        
        
        if genericType == .SocialNetworks {
            
            // socialNetwork             {type:"facebook",url:"asdfdfsd"}
            
            let WebVC:WebViewVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("WebViewVC") as! WebViewVC
            
            let dict = self.socialNetworkListArr[indexPath.row] as! [String:String]
            WebVC.title = "Social Network"
            WebVC.urlStr = dict["url"]!
            self.navigationController?.pushViewController(WebVC, animated: true)
        }else if( genericType == .Friends ){
            
            let vc = AppHelper.getProfileStoryBoard().instantiateViewControllerWithIdentifier("ProfileContainerVC") as! ProfileContainerVC
            
            let dict = self.friendListArr[indexPath.row] as! [String:AnyObject]
            
            vc.viewerUserID = dict["friendId"]!["_id"] as! String!
            self.navigationController?.pushViewController(vc , animated: true)
            
        }
    }
    }



class FollowerCell: GenericProfileCollectionVC {
    
    class func setUpCell(collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCellWithReuseIdentifier("FollowerCell", forIndexPath: indexPath)
        
        let iv_profile = cell.viewWithTag(1) as! UIImageView
        let lbl_name = cell.viewWithTag(2) as! UILabel
        
        iv_profile.layer.borderWidth = 1.0
        iv_profile.contentMode = .ScaleAspectFill
        iv_profile.backgroundColor = UIColor.whiteColor()
        iv_profile.layer.masksToBounds = false
        iv_profile.layer.borderColor = UIColor.lightGrayColor().CGColor
        iv_profile.layer.cornerRadius = iv_profile.frame.size.height/2
        iv_profile.clipsToBounds = true
        
        lbl_name.text = ""
        
        
        return cell
}
}

