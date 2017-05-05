//
//  AttachmentsVC.swift
//  ProactiveLiving
//
//  Created by Affle on 16/01/2017.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit

protocol AttachMentsVCDelegate {
    
    
    func didFinishUpload(dict:[String:String])
    func didCancelBtnPressed();

}

class AttachmentsVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,  UIActionSheetDelegate, DKImagePickerControllerDelegate {
    
    var delegate:AttachMentsVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Attachment View
    
    @IBAction func cancelAttachviewClick(sender: AnyObject) {
        self.cancelAttchView()
        
    }
    
    func cancelAttchView()-> Void
    {
      delegate?.didCancelBtnPressed()
        
        UIView.animateWithDuration(0.5, animations:
            {
                self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func takePicFromCameraClick(sender: AnyObject) {
        self.cancelAttchView()
        if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {
            UIApplication.sharedApplication().statusBarHidden=true
            let imagePicker = UIImagePickerController()
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
            {
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                imagePicker.mediaTypes = [String(kUTTypeImage)]
                //imagePicker.allowsEditing = true
                imagePicker.delegate = self
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
                    switch authStatus {
                    case .Authorized:
                        self.presentViewController(imagePicker, animated: true, completion: nil)
                        break
                    case .Denied:
                        AppHelper.showAlertWithTitle(AppName, message:cameraSetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    case .NotDetermined:
                        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo,
                            completionHandler: { (granted:Bool) -> Void in
                                if granted {
                                    self.presentViewController(imagePicker, animated: true, completion: nil)
                                }
                                else {
                                    AppHelper.showAlertWithTitle(AppName, message:cameraSetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                                }
                        })
                    default:
                        AppHelper.showAlertWithTitle(AppName, message:cameraSetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                        
                    }
                });
                
               // self.presentViewController(imagePicker, animated: true, completion: nil)
            }else
            {
                if(IS_IOS_7)
                {
                    ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Camera not available.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                }
                else
                {
                    let alertController = UIAlertController(title:APP_NAME, message:"Camera not available.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                        
                    }))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }else
        {
            if(IS_IOS_7)
            {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Internet Connection not available.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
            else
            {
                let alertController = UIAlertController(title:APP_NAME, message:"Internet Connection not available.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                    
                }))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func takeVideoFromCameraClick(sender: AnyObject) {
        self.cancelAttchView()
        if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {
            UIApplication.sharedApplication().statusBarHidden=true;
            let imagePicker = UIImagePickerController()
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
            {
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                imagePicker.mediaTypes = [String(kUTTypeMovie)]
                imagePicker.delegate = self
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
                    switch authStatus {
                    case .Authorized:
                        self.presentViewController(imagePicker, animated: true, completion: nil)
                        break
                    case .Denied:
                        AppHelper.showAlertWithTitle(AppName, message:cameraSetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    case .NotDetermined:
                        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo,
                            completionHandler: { (granted:Bool) -> Void in
                                if granted {
                                    self.presentViewController(imagePicker, animated: true, completion: nil)
                                }
                                else {
                                    AppHelper.showAlertWithTitle(AppName, message:cameraSetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                                }
                        })
                    default:
                        AppHelper.showAlertWithTitle(AppName, message:cameraSetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                        
                    }
                });
                
               // self.presentViewController(imagePicker, animated: true, completion: nil)
            }else
            {
                if(IS_IOS_7)
                {
                    ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Camera not available.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                }
                else
                {
                    let alertController = UIAlertController(title:APP_NAME, message:"Camera not available.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                        
                    }))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }else
        {
            if(IS_IOS_7)
            {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Internet Connection not available.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
            else
            {
                let alertController = UIAlertController(title:APP_NAME, message:"Internet Connection not available.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                    
                }))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func choosePicfromGalleryClick(sender: AnyObject)
    {
        self.cancelAttchView()
        
        
        if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {
            self.openActionSheet()
        }else
        {
            if(IS_IOS_7)
            {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Internet Connection not available.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
            else
            {
                let alertController = UIAlertController(title:APP_NAME, message:"Internet Connection not available.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
                    
                }))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    
    /*  @IBAction func takeVideoFromGalleryClick(sender: AnyObject)
     {
     self.cancelAttchView()
     if ServiceClass.checkNetworkReachabilityWithoutAlert()
     {
     UIApplication.sharedApplication().statusBarHidden=true;
     let imagePicker = UIImagePickerController()
     imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
     imagePicker.mediaTypes = [String(kUTTypeMovie)]
     imagePicker.delegate = self
     self.presentViewController(imagePicker, animated: true, completion: nil)
     
     }else
     {
     if(IS_IOS_7)
     {
     ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Internet Connection not available.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
     }
     else
     {
     let alertController = UIAlertController(title:APP_NAME, message:"Internet Connection not available.", preferredStyle: UIAlertControllerStyle.Alert)
     alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(ACTION :UIAlertAction!)in
     
     }))
     
     self.presentViewController(alertController, animated: true, completion: nil)
     }
     }
     
     }*/
    //MARK:-
    func uniqueName(fileName: String) -> String {
        
        let uniqueImageName = NSString(format: "%@%f", fileName , NSDate().timeIntervalSince1970 * 1000)
        // print_debug(uniqueImageName)
        return uniqueImageName as String
    }
    
    func openActionSheet() -> Void
    {
        
        if(IS_IOS_7)
        {
            let actionSheet = UIActionSheet(title:"", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle:nil, otherButtonTitles: "Select images","Send Video")
            actionSheet.tag=10001
            //   actionSheet.showFromTabBar((bottomTabBar?.tabBar)!)
        }
        else
        {
            let actionSheet =  UIAlertController(title:"", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Select images", style: UIAlertActionStyle.Default, handler:
                { (ACTION :UIAlertAction!)in
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)//PHPhotoLibrary.authorizationStatus()
                        switch authStatus {
                        case .Authorized:
                            self.showCustomController()
                        break // Do your stuff here i.e. allowScanning()
                        case .Denied:
                            AppHelper.showAlertWithTitle(AppName, message:gallerySetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                        case .NotDetermined:
                            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { granted in
                                if granted {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.showCustomController()                                    }
                                }
                            })
                        default:
                            AppHelper.showAlertWithTitle(AppName, message:gallerySetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                        }
                    })

                  //  self.showCustomController()
                    
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Send Video", style: UIAlertActionStyle.Default, handler: { (ACTION :UIAlertAction!)in
                UIApplication.sharedApplication().statusBarHidden=true;
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imagePicker.mediaTypes = [String(kUTTypeMovie)]
                imagePicker.delegate = self
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)//PHPhotoLibrary.authorizationStatus()
                    switch authStatus {
                    case .Authorized:
                        self.presentViewController(imagePicker, animated: true, completion: nil)
                    break // Do your stuff here i.e. allowScanning()
                    case .Denied:
                        AppHelper.showAlertWithTitle(AppName, message:gallerySetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    case .NotDetermined:
                        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { granted in
                            if granted {
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.presentViewController(imagePicker, animated: true, completion: nil)
                                }
                            }
                        })
                    default:
                        AppHelper.showAlertWithTitle(AppName, message:gallerySetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    }
                })
                
              //  self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (ACTION :UIAlertAction!)in
                
            }))
            
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
    }
    
    func showCustomController() {
        let pickerController = DKImagePickerController()
        pickerController.pickerDelegate = self
        self.presentViewController(pickerController, animated: true) {}
    }
    
    
    //MARK:- DKImagePickerController  Delegates
    
    func imagePickerControllerCancelled() {
        
        //   isFromGallery = true
        viewWillAppaerCount = 1
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidSelectedAssets(assets: [DKAsset]!)
    {
        //    isFromGallery = true
        
        self.dismissViewControllerAnimated(true, completion: nil)
        delay(0.1,
              closure: {
                UIApplication.sharedApplication().statusBarHidden = false;
                UIApplication.sharedApplication().statusBarStyle = .LightContent
        })
        //  self.globalAssets = assets
        //   self.addCaptionOnPost(assets, cameraImage: nil, videoUrl: nil)
        
        // self.handleMultipleImages(self.globalAssets!, captionText: "")
        
        //handle muliple image
        
        var count = 0
        var thumbArr: NSMutableArray = NSMutableArray()
        
        for (index, asset) in assets.enumerate(){
            
            count = index
            
            let locId = CommonMethodFunctions.nextIdentifies()
            let strId = String(locId)
            
            let timeStamp = HelpingClass.generateTimeStamp() + String("-") + String(index)
            
            
            let tempImage = UIImageView(image: asset.fullScreenImage)
            //     let thumbImg = UIImageView(image: asset.thumbnailImage)
            
            let imgData = UIImageJPEGRepresentation(tempImage.image!, 0.8)
            let thumbNailName = "Thumb" + timeStamp + ".jpg"
            
            thumbArr.insertObject(thumbNailName, atIndex: 0)
            
            HelpingClass.writeToPath(directory: "/ChatFile", fileName: thumbNailName, dataToWrite: imgData!, completion: {(isWritten:Bool, err:NSError?) -> Void in
                
                if isWritten{
                    
                }
            })
            
            
            var dict = Dictionary<String, AnyObject>()
            
            
            dict["message"] = ""
            dict["type"] = "image"
            dict["mediaUrl"] = ""
            dict["mediaThumbUrl"] = ""
            dict["localmsgid"] = strId
            
            NSOperationQueue.mainQueue().addOperationWithBlock() { () in
                
                AppDelegate.showProgressHUDWithStatus("Please wait..")
                
                let name = self.uniqueName("")   + String("-") + String(index)
                
                
                
                
                UploadInS3.sharedGlobal().uploadMultipleImagesOnChatTos3(imgData, type: 0, dictInfo: dict, fromDist: "chat", meldID: name, completion: { ( bool_val : Bool, pathUrl : String!) -> Void in
                    
                    
                    
                    if bool_val == true{
                        
                        count = count - 1
                        
                        /* for  index in  0 ..< (UploadInS3.sharedGlobal().chatImagesFiles as NSMutableArray).count {
                         
                         
                         if let citiesArr = UploadInS3.sharedGlobal().chatImagesFiles{
                         
                         var fileName = Dictionary<String, AnyObject>()
                         if let _:Dictionary<String, AnyObject> = citiesArr[index] as? Dictionary
                         {
                         fileName = citiesArr[index] as! Dictionary
                         let strFileName : String = fileName["chatImagesName"] as! String
                         
                         
                         
                         
                         
                         
                         }
                         else {}
                         }
                         }*/
                        
                        let thumbNameTemp =  thumbArr.lastObject as! String
                        
                      //  self.sendPostToServer("image", isShared: false, createdDict: nil, imgOrVideoUlr: pathUrl , captionText: "", thumNailName:thumbNameTemp)
                        
                        self.sendToServerAPI("image", imgOrVideoUlr: pathUrl, thumNailName: thumbNameTemp)
                        
                        thumbArr.removeLastObject()
                        
                        if count == -1 {
                            AppDelegate.dismissProgressHUD()
                        }
                        
                    }
                    
                    
                    } , completionProgress: { ( bool_val : Bool, progress) -> Void in
                        
                })
            }
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    
    
    //MARK:- Image Picker Delegates
    func imagePickerControllerDidCancel(picker:UIImagePickerController)
    {
        //  isFromGallery = true
        viewWillAppaerCount = 1
        
        self.dismissViewControllerAnimated(true, completion: nil)
        delay(0.1,
              closure: {
                UIApplication.sharedApplication().statusBarHidden = false;
                UIApplication.sharedApplication().statusBarStyle = .LightContent
        })
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        //  isFromGallery = true
        
        self.dismissViewControllerAnimated(true, completion: nil)
        delay(0.1,
              closure: {
                UIApplication.sharedApplication().statusBarHidden = false;
                UIApplication.sharedApplication().statusBarStyle = .LightContent
        })
        
        //UIImagePickerControllerEditedImage
        
        if(info["UIImagePickerControllerMediaType"] as! String == "public.image") {
            
            if ServiceClass.checkNetworkReachabilityWithoutAlert() {
                
               // self.addCaptionOnPost(nil, cameraImage: info[UIImagePickerControllerOriginalImage] as? UIImage, videoUrl: nil)
                self.uploadImage((info[UIImagePickerControllerOriginalImage] as? UIImage)!, captionText: "")
            }
        }else if(info["UIImagePickerControllerMediaType"] as! String == "public.movie")
        {
            if ServiceClass.checkNetworkReachabilityWithoutAlert(){
              //  self.addCaptionOnPost(nil, cameraImage: nil, videoUrl: info[UIImagePickerControllerMediaURL] as? NSURL)
                self.uploadVideo((info[UIImagePickerControllerMediaURL] as? NSURL)!, captionText: "")
                
                
            }
            
        }
    }
    
    //MARK:- upload
    
    func uploadImage(uploadImage:UIImage, captionText: String?) -> Void {
        
        let locId = CommonMethodFunctions.nextIdentifies()
        let strId = String(locId)
        
        let timeStamp = HelpingClass.generateTimeStamp()
        
        
        // let imgData = UIImageJPEGRepresentation(uploadImage, 0.8)
        
        //   let thumbImg = CommonMethodFunctions.generatePhotoThumbnail(uploadImage);
        let thumbData = UIImageJPEGRepresentation(uploadImage, 0.0)
        let thumbNailName = "Thumb" + timeStamp + ".jpg"
        
        
        HelpingClass.writeToPath(directory: "/ChatFile", fileName: thumbNailName, dataToWrite: thumbData!, completion: {(isWritten:Bool, err:NSError?) -> Void in
            
            if isWritten{
                
            }
            
        })
        
        
        NSOperationQueue.mainQueue().addOperationWithBlock() { () in
            
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            
            let name = self.uniqueName("")
            UploadInS3.sharedGlobal().uploadImageTos3( thumbData, type: 0, fromDist: "chat", meldID: name, completion: { ( bool_val : Bool, pathUrl : String!) -> Void in
                
                AppDelegate.dismissProgressHUD()
                
                if bool_val == true
                {
                    let fileName =  UploadInS3.sharedGlobal().strFilesName
                    
                    if fileName != nil{
                        
                        self.sendToServerAPI("image", imgOrVideoUlr: pathUrl, thumNailName: thumbNailName)
                    }
                }
                else{
                    AppDelegate.dismissProgressHUD()
                }
                
                
                }
                , completionProgress: { ( bool_val : Bool, progress) -> Void in
                    
                    
                    
                }
            )
            
        }
        
    }
    
    func uploadVideo(videoUrl:NSURL, captionText:
        String?) -> Void {
        
        let locId = CommonMethodFunctions.nextIdentifies()
        let strId = String(locId)
        
        let timeStamp = HelpingClass.generateTimeStamp()
        
        let videoName = "Video"+timeStamp+".mp4"
        let thumbNailName = "Thumb" + timeStamp + ".jpg"
        
        
        
        // generate thumb image from video url and save to path
        // let thumbImg = CommonMethodFunctions.getThumbNail(videoUrl);
        let thumbImg = CommonMethodFunctions.generateThumbImage(videoUrl)
        let thumbData = UIImageJPEGRepresentation(thumbImg, 1.0)
        
        HelpingClass.writeToPath(directory: "/ChatFile", fileName: thumbNailName, dataToWrite: thumbData!, completion: {(isWritten:Bool, err:NSError?) -> Void in
            
            if isWritten{
                
            }
            
        })
        
        
        //Make low quality and save to DB
        
        let outPutPath = HelpingClass.generateLocalFilePath(directory: "/ChatFile", fileName: videoName)
        
        CommonMethodFunctions.convertVideoToLowQuailtyWithInputURL(videoUrl, outputURL: NSURL.fileURLWithPath(outPutPath), handler: { (exportSession : AVAssetExportSession!) -> Void in
            switch(exportSession.status)
            {
            case .Completed:
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let compressedVideoData =  NSData(contentsOfURL: NSURL.fileURLWithPath(outPutPath))
                    
                    HelpingClass.writeToPath(directory: "/ChatFile", fileName: videoName, dataToWrite: compressedVideoData!, completion: {(isWritten:Bool, err:NSError?) -> Void in
                        
                        if isWritten{
                            
                        }
                        
                    })
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock() { () in
                        AppDelegate.showProgressHUDWithStatus("Please wait..")
                        
                        
                        let name = self.uniqueName("")
                        UploadInS3.sharedGlobal().uploadImageTos3( compressedVideoData, type: 1, fromDist: "chat", meldID: name, completion: { ( bool_val : Bool, pathUrl : String!) -> Void in
                            
                            AppDelegate.dismissProgressHUD()
                            
                            
                            if bool_val == true
                            {
                                let fileName =  UploadInS3.sharedGlobal().strFilesName
                                //  progressV.hidden = true
                                if fileName != nil{
                                 self.sendToServerAPI("video", imgOrVideoUlr: pathUrl, thumNailName: thumbNailName)
                                }
                            }
                            
                            
                            
                            }, completionProgress: { ( bool_val : Bool, progress) -> Void in
                                
                        })
                    }
                    
                    
                });
                break
            default:
                break
                
            }
            
        })
        
        
        
        
        
        //------------------------
        
        
        /*
         
         
         
         
         let videoData =  NSData(contentsOfURL: NSURL.fileURLWithPath(videoUrl.path!))
         */
        
        
        
    }
    
    
    
    func sendToServerAPI(postType:String, imgOrVideoUlr:String, thumNailName:String!) {
        
        
        
        if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {
            
            var dict = Dictionary<String,AnyObject>()
            
            dict["userId"] = ChatHelper.userDefaultForKey(_ID)
            
            dict["url"] = imgOrVideoUlr
            dict["type"] = postType
            
            dict["thumNailName"] = thumNailName
            
            
            //call global web service class latest
            Services.postRequest(ServiceUploadContent, parameters: dict, completionHandler:{
                (status,responseDict) in
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        print_debug(responseDict["result"])
                        
                        let resultDict = responseDict["result"] as?    [String:String]
                        
                        self.delegate?.didFinishUpload(resultDict!)
                        
                        
                    } else {
                        
                        AppHelper.showAlertWithTitle(AppName, message: responseDict["errorMsg"] as! String, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    }
                    
                } else if (status == "Error"){
                    
                    AppHelper.showAlertWithTitle(AppName, message: serviceError, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    
                }
            })
            
        }else {
            AppDelegate.dismissProgressHUD()
            //show internet not available
            AppHelper.showAlertWithTitle(netError, message: netErrorMessage, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
        }
    }
    
    
    //MARK:-
    
    func addCaptionOnPost(assets: [DKAsset]?, cameraImage:UIImage?, videoUrl:NSURL?) -> Void {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: AppName, message: "Say something about this photo...", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            // textField.text = "Some default text."
        })
        
        //3. Grab the value from the text field, and print_debug it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { [weak alert] (action) -> Void in
            let textField = alert!.textFields![0] as UITextField
            print_debug("Text field: \(textField.text)")
            
            if(assets != nil){
                //multiple images
                self.handleMultipleImages(assets!, captionText: textField.text!)
                
            }else if(cameraImage != nil){
                // from camera
                self.uploadImage(cameraImage!, captionText: textField.text)
            }else{
                //either from record or video from gallery
                
                self.uploadVideo(videoUrl!,captionText: textField.text)
                
                
            }
            
            
            
            
            
            
            }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleMultipleImages(assets: [DKAsset]!, captionText:String?) -> Void {
        
        var i = 1
        
        for (_, asset) in assets!.enumerate() {
            
            
            let locId = CommonMethodFunctions.nextIdentifies()
            let strId = String(locId)
            
            let timeStamp = HelpingClass.generateTimeStamp() + String(" ") + String(i)
            i = i + 1
            
            let tempImage = UIImageView(image: asset.fullScreenImage)
            //     let thumbImg = UIImageView(image: asset.thumbnailImage)
            
            let imgData = UIImageJPEGRepresentation(tempImage.image!, 0.8)
            let thumbNailName = "Thumb" + timeStamp + ".jpg"
            
            
            HelpingClass.writeToPath(directory: "/ChatFile", fileName: thumbNailName, dataToWrite: imgData!, completion: {(isWritten:Bool, err:NSError?) -> Void in
                
                if isWritten{
                    
                }
                
            })
            
            var dict = Dictionary<String, AnyObject>()
            
            
            dict["message"] = ""
            dict["type"] = "image"
            dict["mediaUrl"] = ""
            dict["mediaThumbUrl"] = ""
            dict["localmsgid"] = strId
            
            NSOperationQueue.mainQueue().addOperationWithBlock() { () in
                
                AppDelegate.showProgressHUDWithStatus("Please wait..")
                
                let name = self.uniqueName("")   + String(" ") + String(i)
                
                UploadInS3.sharedGlobal().uploadMultipleImagesOnChatTos3(imgData, type: 0, dictInfo: dict, fromDist: "chat", meldID: name, completion: { ( bool_val : Bool, pathUrl : String!) -> Void in
                    
                    AppDelegate.dismissProgressHUD()
                    
                    if bool_val == true{
                        //self.sendPostToServer("image", isShared: false, createdDict: nil, imgOrVideoUlr: pathUrl , captionText: captionText, thumNailName:thumbNailName)
                        //    print_debug("image path~~~~~~ = ", pathUrl)
                        
                    }
                    
                    
                    } , completionProgress: { ( bool_val : Bool, progress) -> Void in
                        
                })
            }
        }
        
        //  self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    

    

}
