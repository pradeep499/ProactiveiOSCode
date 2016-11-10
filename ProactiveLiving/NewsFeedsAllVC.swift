//
//  NewsFeedsAllVC.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 22/09/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit

class NewsFeedsAllVC: UIViewController, UIGestureRecognizerDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var view_share: UIView!
    @IBOutlet weak var view_post: UIView!
    
    //  var dataArr = [AnyObject]()
    var profileArr = [String]()
    var urlArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.registerClass(HeaderScrollerView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderScrollerView")
        
        self.view_post.layer.borderWidth = 1.0
        self.view_post.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        
        
        
        profileArr = ["Rohit Saxena", "Salman Khan", "Venkatish", "Ishika Ghosh", "Ashish Chobra", "Aqib", "Mohd Asim", "Gaurav", "Durjoy Singh"]
        urlArr = ["http://52.23.211.77:3000/uploads/users/boy.jpg",
                  "http://52.23.211.77:3000/uploads/users/girl.jpg",
                  "http://52.23.211.77:3000/uploads/users/rock.jpg",
                  "http://52.23.211.77:3000/uploads/users/girl2.jpg",
                  "http://52.23.211.77:3000/uploads/users/gary.jpg",
                  "http://52.23.211.77:3000/uploads/users/girl.jpg",
                  "http://52.23.211.77:3000/uploads/users/boy.jpg",
                  "http://52.23.211.77:3000/uploads/users/girl.jpg",
                  "http://52.23.211.77:3000/uploads/users/boy.jpg"]
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.fetchExploreDataFromServer()
        self.view_share.hidden = true
    }
    
    //MARK: - onClickLikeBtn
    @IBAction func onClickLikeBtn(sender: AnyObject) {
        
        //   let cell: UITableViewCell = sender.superview!!.superview as! UITableViewCell
        //   let index : NSIndexPath = self.tableView.indexPathForCell(cell)!
        
    }
    
    //MARK: - onClickComments
    @IBAction func onClickComments(sender: AnyObject) {
        
    }
    
    //MARK: - onClickShareBtn
    @IBAction func onClickShareBtn(sender: AnyObject) {
        
    }
    
    //MARK: - onClickFBBtn
    @IBAction func onClickFBBtn(sender: AnyObject) {
        
        UIView.animateWithDuration(0.3, animations: {
            self.view_share.alpha = 0
            self.view_share.hidden = true
        })
    }
    
    
    //MARK: - onClickTwiterBtn
    @IBAction func onClickTwiterBtn(sender: AnyObject) {
        
        UIView.animateWithDuration(0.3, animations: {
            self.view_share.alpha = 0
            self.view_share.hidden = true
        })
    }
    
    
    //MARK: - onClickSnapChatBtn
    @IBAction func onClickSnapChatBtn(sender: AnyObject) {
        
        UIView.animateWithDuration(0.3, animations: {
            self.view_share.alpha = 0
            self.view_share.hidden = true
        })
    }
    
    //MARK: - onClickPhotoBtn
    @IBAction func onClickPhotoBtn(sender: AnyObject) {
        
        UIView.animateWithDuration(0.3, animations: {
            self.view_share.alpha = 0
            self.view_share.hidden = true
        })
        
    }
    
    //MARK: - onClickPlusBtn
    @IBAction func onClickPlusBtn(sender: AnyObject) {
        
        self.view_share.alpha = 0
        UIView.animateWithDuration(0.3, animations: {
            self.view_share.alpha = 1.0
            self.view_share.hidden = false
        })
        
    }
    
    //MARK: - onClickPostBtn
    @IBAction func onClickPostBtn(sender: AnyObject) {
        
    }
    
    //MARK: - TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    //MARK: - Collection Header Footer delegates
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderScrollerView", forIndexPath: indexPath) as! HeaderScrollerView
            
            //     headerView.frame.size.height = 0
            headerView.backgroundColor = UIColor.redColor()
            headerView.setDataSource(dataArrForHeader)
            headerView.setViewTitle(top: "EXPLORE", bottomTitle: "UPDATES")
            return headerView
            
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "FooterAllReUsableView", forIndexPath: indexPath) as! FooterAllReUsableView
            return footerView
            
        default:
            
            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView.init(frame: CGRectMake(0, 0, 0, 0))
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        var secHeight:CGFloat
        
        if dataArrForHeader.count>0 {
            secHeight=370
        } else {
            secHeight=0
        }
        return CGSize(width: self.collectionView.frame.width, height: secHeight)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterSection section: Int) -> CGSize {
        
        
        //   return CGSize(width: self.collectionView.frame.width, height: 160)
        return CGSize(width: 0, height: 0)
        
    }
    
    //MARK:- Collection DataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //let dataArr = self.dataDict["members"] as! [AnyObject]
        return profileArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        /*  if indexPath.row == 0 {
         
         let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellPOST", forIndexPath: indexPath) as UICollectionViewCell
         //    cell.layer.borderWidth = 1.0
         //    cell.layer.borderColor = UIColor.lightGrayColor().CGColor
         
         let txtV_post = cell.viewWithTag(1) as! UITextView
         txtV_post.layer.borderWidth = 1.0
         txtV_post.layer.borderColor = UIColor.lightGrayColor().CGColor
         
         
         return cell
         } */
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellAll", forIndexPath: indexPath) as UICollectionViewCell
        
        let lpgrMain : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ExploreVC.handleLongPress(_:)))
        lpgrMain.minimumPressDuration = 0.5
        
        lpgrMain.delegate = self
        lpgrMain.delaysTouchesBegan = true
        
        
        let iv_profile = cell.viewWithTag(1) as! UIImageView
        let lbl_name = cell.viewWithTag(2) as! UILabel
        let lbl_timeAgo = cell.viewWithTag(3) as! UILabel
        let lbl_details = cell.viewWithTag(4) as! UILabel
        let lbl_subDetails = cell.viewWithTag(5) as! UILabel
        
        let btn_like = cell.viewWithTag(6) as! UIButton
        let btn_comments = cell.viewWithTag(7) as! UIButton
        let btn_share = cell.viewWithTag(8) as! UIButton
        
        
        lbl_name.text = profileArr[indexPath.row ]

        iv_profile.layer.borderWidth = 1.0
        iv_profile.contentMode = .ScaleAspectFill
        iv_profile.backgroundColor = UIColor.whiteColor()
        iv_profile.layer.masksToBounds = false
        iv_profile.layer.borderColor = UIColor.lightGrayColor().CGColor
        iv_profile.layer.cornerRadius = iv_profile.frame.size.height/2
        iv_profile.clipsToBounds = true
        
        if let logoUrlStr = urlArr[indexPath.row  ] as? String {
            
            let image_url = NSURL(string: logoUrlStr )
            if (image_url != nil) {
                
                let placeholder = UIImage(named: "ic_booking_profilepic")
                
                /*   iv_profile.setImageWithURLRequest(NSURLRequest(URL: image_url!), placeholderImage: placeholder, success: { (request:NSURLRequest!, response:NSHTTPURLResponse?, image:UIImage?)in
                 iv_profile.image = image
                 
                 }, failure: { (request:NSURLRequest!, response:NSHTTPURLResponse!, err:NSError!) in
                 
                 })*/
                iv_profile.sd_setImageWithURL((URL: image_url!), placeholderImage: placeholder)
            }
            
        }
        
        //   cell.addGestureRecognizer(lpgrMain)
        
        /*   let imgBackGround = cell.contentView.viewWithTag(111) as! UIImageView
         imgBackGround.contentMode = .ScaleAspectFill
         imgBackGround.clipsToBounds = true
         
         let imgLogo = cell.contentView.viewWithTag(222) as! UIImageView
         imgLogo.layer.borderWidth = 1.0
         imgLogo.contentMode = .ScaleAspectFill
         imgLogo.backgroundColor = UIColor.whiteColor()
         imgLogo.layer.masksToBounds = false
         imgLogo.layer.borderColor = UIColor.lightGrayColor().CGColor
         imgLogo.layer.cornerRadius = imgLogo.frame.size.height/2
         imgLogo.clipsToBounds = true
         
         let lblTitle = cell.contentView.viewWithTag(333) as! UILabel
         
         let dataDict = self.dataArr[indexPath.row] as! [String : AnyObject]
         lblTitle.text = dataDict["name"] as? String
         
         if let imageUrlStr = dataDict["latestArticleLogoUrl"] as? String {
         let image_url = NSURL(string: imageUrlStr )
         if (image_url != nil) {
         let placeholder = UIImage(named: "no_photo")
         imgBackGround.setImageWithURL(image_url, placeholderImage: placeholder)
         }
         }
         
         if let logoUrlStr = dataDict["logoUrl"] as? String {
         let image_url = NSURL(string: logoUrlStr )
         if (image_url != nil) {
         let placeholder = UIImage(named: "no_photo")
         imgLogo.setImageWithURL(image_url, placeholderImage: placeholder)
         }
         }
         */
        
        return cell
    }
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
       /* if (indexPath.row == 0){
            return CGSize(width: collectionView.frame.size.width-20, height: 145)
        } */
        return CGSize(width: collectionView.frame.size.width-20, height: 160)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    //MARK:- Collection Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        //   self.handleSingleTapAtIndex(indexPath)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    
    //MARKS: - Service Call
    
    func fetchExploreDataFromServer() {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            
            //call global web service class latest
            Services.postRequest(ServiceGetAllStories, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        dataArr = responseDict["allStories"] as! [AnyObject]
                        dataArrForHeader = responseDict["subscribeStories"] as! [AnyObject]
                        //self.dataArr = items.map({$0["latestArticleLogoUrl"]! as! String}) as [String]
                        self.collectionView.reloadData()
                        
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

// MARK: - FooterAllReUsableView
class FooterAllReUsableView: UICollectionReusableView{
    
    
    var customView : CollectionHeaderCustomView? = nil
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //self.collectionView.reloadData()
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.myCustomInit()
    }
    
    func myCustomInit() {
        print("hello there from SupView")
    }
    
}
