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
    
    public var photoListArr = [AnyObject]()
    var moviePlayerController = MPMoviePlayerController()
    var pageFrom:String?
    var delegate:GenericProfileCollectionVCDelegate?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpPage()
        self.setUpCollectionView()
        
        let attachments = AttachmentsVC()
        attachments.delegate = self
        
        self.getPhotosList()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpPage() -> Void {
        
        self.btnRight.hidden = true
        
        if genericType == .Friends {
            self.lbl_title.text = "Friends"
        }else if genericType == .Followers {
            self.lbl_title.text = "Followers"
        }else if genericType == .Photos {
            
            self.lbl_title.text = "Photos"
            self.btnRight.hidden = false
            self.btnRight.setImage(UIImage(named: "pf_add"), forState: .Normal)
            
        }
        
        self.cv.reloadData()
        self.layOut_attachmetBottom.constant = -350;
        
    }
    
    func setUpCollectionView() -> Void {
        
        let w = self.cv.bounds.size.width - 30
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        
        layout.itemSize = CGSize(width: w/3 - 5, height: w/3)
        layout.minimumInteritemSpacing = 6
        layout.minimumLineSpacing = 10
        self.cv!.collectionViewLayout = layout
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
      
        self.showAttachmentView()
        
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
        
        self.hideAttachmentView()
    }
    
    func didFinishUpload(dict: [String:String]) {
        self.photoListArr.append(dict)
        self.cv.reloadData()
    }
    //MARK: API
    
    func getPhotosList() -> Void {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            parameters["category"] = "photos"
            
            
            //call global web service class latest
            Services.postRequest(ServiceGetProfileDataByCategory, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        print(responseDict["result"])
                        
                        if let content = responseDict["result"]!["content"]{
                        
                            self.photoListArr = content as! [AnyObject]
                            self.cv.reloadData()
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

extension GenericProfileCollectionVC:UICollectionViewDataSource{
    
   
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
        let w = collectionView.bounds.size.width - 30
        
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
            return 15
        }else if genericType == .Followers {
            return 15
        }else if genericType == .Photos {
            return self.photoListArr.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if genericType == .Friends {
           
            
            
        }else if genericType == .Followers {
            
            let cell = FollowerCell.setUpCell(collectionView, indexPath: indexPath)
            return cell
            
        }else if genericType == .Photos {
            
            let dict = self.photoListArr[indexPath.row] as! [String : String]
            
            let cell = self.setUpCell(collectionView, indexPath: indexPath, dict:dict )
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
            
        }else{
            
            HelpingClass.showAlertControllerWithType(.Alert, fromController: self, title: AppName, message: "You cann't select video.", cancelButtonTitle: "OK", otherButtonTitle: nil, completion: { (str) in
                
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
                
            })
            
            
            
            self.navigationController?.pushViewController(fullImageVC, animated: true)
            
            
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
    
     func setUpCell(collectionView: UICollectionView, indexPath: NSIndexPath, dict:[String:String]!) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath)
        
        
        
        let thumbIV = cell.viewWithTag(1) as! UIImageView
        let iv_videoIcon = cell.viewWithTag(2) as! UIImageView
        let indicator = cell.viewWithTag(3) as! UIActivityIndicatorView
        
        let thumbNailName = dict["thumNailName"]!
        let imgUrl = dict["url"]
        
        
        //check the thumbNail name is exist ? or generate from video url and save to db
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
                    let imgData = UIImagePNGRepresentation(img) as NSData?
                    
                    HelpingClass.writeToPath(directory: "/ChatFile", fileName: thumbNailName, dataToWrite: imgData!, completion: {(isWritten:Bool, err:NSError?) -> Void in
                        indicator.hidden = true
                        
                        if isWritten{
                            
                        }
                    })
                }
                indicator.stopAnimating()
                
            }
            
            
        })
        
        
        
        
        
        
        return cell
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

