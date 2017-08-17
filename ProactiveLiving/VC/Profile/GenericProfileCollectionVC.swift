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
    
    
    //MARK:- Outlets
    
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var cv: UICollectionView!
    
    @IBOutlet weak var btnRight: UIButton!
    
    var genericType:ProfileGenericType?
    
    @IBOutlet weak var layOut_attachmetBottom: NSLayoutConstraint!
    
    
    @IBOutlet weak var attachmentContainerView: UIView!
    
    @IBOutlet weak var imgDeleteBtn: UIButton!
    //MARK:- Properties
    
    var photoListArr = [AnyObject]()
    var socialNetworkListArr = [AnyObject]()
    var friendListArr = [AnyObject]()
    
    var deleteButton:UIButton?  // by me
    var photoIDArr = [String]() // by me
    var isDelete = true
    var isHiddenDeleteBtn = false
    var indexToDelete = NSIndexPath()
    var tempPhotoListArr = [AnyObject]()
    
    // to hide the delete button if coming from Edit Profile Pic
    var isFromProfileEdit = false
    
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
        
        if (genericType == .Gallery && isFromProfileEdit == false && String(AppHelper.userDefaultsForKey(_ID)) == viewerUserID) {  // Delete Button hide and Show
        
        self.imgDeleteBtn.hidden = false
        
        }
        
        self.setUpPage()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBarHidden = true
//        self.hidesBottomBarWhenPushed = false
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
    //MARK:- Button Actions
    
    @IBAction func onClickDeleteBtn(sender: AnyObject) {
        
        print_debug("Delete button clicked!!!")
        
        // Managing the delete button image
        if isDelete == true {
            isDelete = !isDelete
            //self.deleteButton!.hidden = false
            self.isHiddenDeleteBtn = true
            self.imgDeleteBtn.setImage(UIImage(named: "profile_success"), forState: .Normal)
          
       //     self.tempPhotoListArr = self.photoListArr
      //      self.photoListArr.removeAll()
          //  self.photoListArr = self.tempPhotoListArr
          
            
        }
        else {
            isDelete = !isDelete
            //self.deleteButton!.hidden = true
            self.isHiddenDeleteBtn = false
            self.imgDeleteBtn.setImage(UIImage(named: "profile_remove"), forState: .Normal)
           
            //self.tempPhotoListArr = self.photoListArr
            //self.photoListArr.removeAll()
         //     self.photoListArr = self.tempPhotoListArr
        }
        
        
        var  index = 0
        for _ in photoListArr{
            UIView.animateWithDuration(0.5, delay: 0.0, options: .TransitionNone, animations: {
                let indexpath = NSIndexPath(forItem: index, inSection: 0)
                self.cv.reloadItemsAtIndexPaths([indexpath])
                index += 1

                }, completion: nil)
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
    
    //MARK:- Delete Button Action
    
    
    func deleteAction(sender: AnyObject) {
        
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.cv)
        let indexPath =   self.cv.indexPathForItemAtPoint(buttonPosition)
        let photoIDStr = self.photoListArr[(indexPath?.item)!].valueForKey("_id") as? String
        
        // storing photo IDs to hit the delete API
        //photoIDArr.append(photoIDStr!)
        self.indexToDelete = indexPath!
        self.deleteItemFromGallery(photoIDStr!)
        
    }
    
    
    //MARK:- Attachment View
    
    func hideAttachmentView() -> Void {
        
        self.layOut_attachmetBottom.constant = -350
        
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
    
    
    
    
    func removeElementFromArr(item:Int){
        
    self.photoListArr.removeAtIndex(item)

    }
    //MARK:- API
    
    
    
    func deleteItemFromGallery(id:String) -> Void {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            parameters["contentId"] = id
            parameters["type"] = "gallery"
            
            
            //call global web service class latest
            Services.postRequest(ServiceDeleteImages, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                      //  self.photoListArr.removeAtIndex((self.indexToDelete.item))
                        //self.cv.reloadData()
                       self.cv.performBatchUpdates({
                        
                        self.removeElementFromArr(self.indexToDelete.item)
                        self.cv.deleteItemsAtIndexPaths([self.indexToDelete])
                        
                        }, completion: nil)
                        
            
                        
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
                           
                            print_debug("Photo Response = ")
                            print_debug(responseDict["result"]!)
                            
                            if let content = responseDict["result"]!["gallery"]{
                                
                                self.photoListArr = content as! [AnyObject]
                            }
                            
                        }else if type == "socialNetworks"{
                            print_debug("Social Network Response = ")
                            print_debug( responseDict["result"])
                            
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
                        
                        print_debug(responseDict["result"])
                        
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
            if self.friendListArr.count == 0{
                HelpingClass.toSetEmptyViewInCollectioncViewNoDataAvaiable(collectionView, message: "")
            }else{
                collectionView.backgroundView = nil
            }
            return self.friendListArr.count
        }else if genericType == .Followers {
            return 15
        }else if genericType == .Gallery {
            if self.photoListArr.count == 0{
                HelpingClass.toSetEmptyViewInCollectioncViewNoDataAvaiable(collectionView, message: "The Gallery is currently empty.")
            }else{
                collectionView.backgroundView = nil
            }
            return self.photoListArr.count
        }else if genericType == .SocialNetworks{
            if self.socialNetworkListArr.count == 0{
                HelpingClass.toSetEmptyViewInCollectioncViewNoDataAvaiable(collectionView, message: "No Social Networks linked.")
            }else{
                collectionView.backgroundView = nil
            }
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
            iv_frImg.layer.cornerRadius = 40
            iv_frImg.clipsToBounds = true
            
            
            let dict = self.friendListArr[indexPath.row] as! [String:AnyObject]
            
            let placeholder = UIImage(named: "ic_booking_profilepic")
            let imageUrlStr = dict["friendId"]!["imgUrl"] as! String!
            let fName = dict["friendId"]!["firstName"] as? String
            let lName = dict["friendId"]!["lastName"] as? String
            
            if let image = imageUrlStr{
                iv_frImg.sd_setImageWithURL(NSURL(string: image ), placeholderImage: placeholder)
            }else{
                iv_frImg.image = placeholder
            }
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
            
            let imgData = UIImageJPEGRepresentation(thumbIV.image!, 0.2);
            
            //let imge =  thumbIV.image?.resizeWithPercentage(60.0)
            
           // let imgData = UIImagePNGRepresentation(imge!)

            self.delegate!.getSelectedImgData(imgData!, imgName:thumbNailName)
            self.navigationController?.popViewControllerAnimated(true)
            
            return
            
        }else if (postType != "image" && pageFrom == "ProfileContainer"){

            
//            HelpingClass.showAlertControllerWithType(.Alert, fromController: self, title: APP_NAME, message: "You can't select video.", cancelButtonTitle:nil, otherButtonTitle: ["OK"], completion: { (str) in
//                   return
//            })
//            return

            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "You can't select video.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            
            return
            
        }
        
        if postType == "image"{
            
            let fullImageVC: FullScreenImageVC =  AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("FullScreenImageVC") as! FullScreenImageVC
            
//            fullImageVC.hidesBottomBarWhenPushed = true
            
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
        
        
        let cell:ProfileCollectionViewCell  =  collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! ProfileCollectionViewCell
        
        
//        let thumbIV = cell.viewWithTag(1) as! UIImageView
//        let iv_videoIcon = cell.viewWithTag(2) as! UIImageView
//        let indicator = cell.viewWithTag(3) as! UIActivityIndicatorView
//        let deleteBtn = cell.viewWithTag(10) as! UIButton
        self.deleteButton = cell.deleteBtn
        
        if self.isHiddenDeleteBtn == false{
            self.deleteButton?.hidden = true
            
        }
        else{
            self.deleteButton?.hidden = false
        }
        // by me
        self.deleteButton!.addTarget(self, action:#selector(GenericProfileCollectionVC.deleteAction(_:)) , forControlEvents: .TouchUpInside)
        
        let thumbNailName = dict["thumNailName"]!
        let imgUrl = dict["url"]
        
        
        //check the thumbNail name is exist ? or generate from video url and save to db
        /*let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            print_debug("This is run on the background queue")
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                print_debug("This is run on the main queue, after the previous code in outer block")
            })
        })*/
        
        HelpingClass.isFileExistsAtPath(directory: "/ChatFile", fileName: thumbNailName, completion: {(isExistPath, fileUrl) -> Void in
            
            
            let recognizer = UITapGestureRecognizer(target: self, action:#selector(GenericProfileCollectionVC.clickUserImage(_:)))
            recognizer.delegate = self
            cell.thumbIV.addGestureRecognizer(recognizer)
            cell.thumbIV.userInteractionEnabled = true
            
            
            if dict["type"]   == "image"{
                
                
                cell.iv_videoIcon.hidden = true
                cell.indicator.startAnimating()
                cell.indicator.hidden = false
                
                if isExistPath {
                    let img = UIImage(contentsOfFile: fileUrl!)
                    cell.thumbIV.image =  CommonMethodFunctions.imageWithImage(img, scaledToWidth: Float( UIScreen.mainScreen().bounds.size.width) - 30);
                    //cell.thumbIV.sd_setImageWithURL(NSURL(string:fileUrl!), placeholderImage : UIImage(named: "pac_listing_no_preview") )
                    
                    cell.indicator.hidden = true
                    cell.indicator.stopAnimating()
                }else{
                    cell.thumbIV.sd_setImageWithURL(NSURL(string: imgUrl!), placeholderImage: UIImage(named:  "pac_listing_no_preview")) {
                        (img,  err,  cacheType,  imgUrl) -> Void in
                        
                        cell.thumbIV.image = img
                            
                            ///CommonMethodFunctions.imageWithImage(img, scaledToWidth: Float( UIScreen.mainScreen().bounds.size.width) - 30);
                        //cell.thumbIV.sd_setImageWithURL(imgUrl!, placeholderImage : UIImage(named: "pac_listing_no_preview") )

                        cell.indicator.hidden = true
                        cell.indicator.stopAnimating()
                        
                    }
                    
                }
                
                
            }else{
                //for video
                
                cell.iv_videoIcon.hidden = false
                
                cell.indicator.hidden = false
                cell.indicator.startAnimating()
                
                if isExistPath {
                    let img = UIImage(contentsOfFile: fileUrl!)
                   // cell.thumbIV.image = CommonMethodFunctions.imageWithImage(img, scaledToWidth: Float( UIScreen.mainScreen().bounds.size.width) - 30)
                    cell.thumbIV.sd_setImageWithURL(NSURL(string:fileUrl!), placeholderImage:UIImage(named:"pac_listing_no_preview"))
                    
                    cell.indicator.hidden = true
                } else {
                    
                    //generate thumb from video url and display on cell
                    let img =  CommonMethodFunctions.generateThumbImage(NSURL(string: imgUrl!)!) //self.generateThumnail(sourceURL: NSURL(string: imgUrls.first!)!)
                    cell.thumbIV.image = CommonMethodFunctions.imageWithImage(img, scaledToWidth: Float( UIScreen.mainScreen().bounds.size.width) - 30)
                   // cell.thumbIV.sd_setImageWithURL(NSURL(string:imgUrl!), placeholderImage:UIImage(named:"pac_listing_no_preview"))
                    
                    
                    
                    
                    //write to db
                    if img != nil{
                        
                        let imgData = UIImagePNGRepresentation(img) as NSData?
                        
                        HelpingClass.writeToPath(directory: "/ChatFile", fileName: thumbNailName, dataToWrite: imgData!, completion: {(isWritten:Bool, err:NSError?) -> Void in
                            cell.indicator.hidden = true
                            
                            if isWritten{
                                
                            }
                        })
                    }
                    
                }
                cell.indicator.stopAnimating()
                
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
        else if dict["type"] == "pintrest" {
            
            iv_social.image = UIImage(named: "pintrest")
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

//MARK:-UICollectionViewDelegate

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

