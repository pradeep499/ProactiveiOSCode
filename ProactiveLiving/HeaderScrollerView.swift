//
//  HeaderScrollerView.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 29/09/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit

class CollectionHeaderCustomView: UIView ,UICollectionViewDelegate,UICollectionViewDataSource, UIGestureRecognizerDelegate  {
    var dataSource : [AnyObject] = [AnyObject]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    var w : CGFloat = 0.0
    var scrollTimer = NSTimer()
    
    @IBOutlet weak var lbl_top: UILabel!
    
    @IBOutlet weak var lbl_bottom: UILabel!
    
    override func awakeFromNib()
    {
      super.awakeFromNib()
    
        let nib = UINib(nibName: "HeaderCollectionCell", bundle: nil)
        collectionView?.registerNib(nib, forCellWithReuseIdentifier: "HeaderCollectionCell")
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        //self.fetchDataForHeaderScroller()
    }
    
    func fetchDataForHeaderScroller() {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["userId"] = AppHelper.userDefaultsForKey(_ID)
            
            
            //call global web service class latest
            Services.postRequest(ServiceGetSubscribedStories, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    //dissmiss indicator
                    if ((responseDict["error"] as! Int) == 0) {
                        self.dataSource = responseDict["result"] as! [AnyObject]
                        //self.dataArr = items.map({$0["latestArticleLogoUrl"]! as! String}) as [String]
                        
                        if(self.dataSource.count>0){
                            //self.scrollTimer = NSTimer.scheduledTimerWithTimeInterval(0.03, target: self, selector: #selector(self.autoScrollView), userInfo: nil, repeats: true)
                            self.collectionView.reloadData()
                        }
                        else {
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
    
    func autoScrollView() {
        let initailPoint = CGPoint(x: w, y: 0)
        if CGPointEqualToPoint(initailPoint, self.collectionView!.contentOffset) {
            if w < self.collectionView!.contentSize.width-screenWidth {
                w += 0.5
            }
            else {
                w = 0
            }
            let offsetPoint = CGPoint(x: w, y: 0)
            self.collectionView!.contentOffset = offsetPoint
        }
        else {
            w = self.collectionView!.contentOffset.x
        }
    }
    
    //*** Delegate and Data Source methods of UicollectionView ***//
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HeaderCollectionCell", forIndexPath: indexPath) as! HeaderCollectionCell
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        let lpgrHeader : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(CollectionHeaderCustomView.handleLongPressOnHeader(_:)))
        lpgrHeader.minimumPressDuration = 0.5
        
        lpgrHeader.delegate = self
        lpgrHeader.delaysTouchesBegan = true
        cell.addGestureRecognizer(lpgrHeader)
        
        cell.imgBack.contentMode = .ScaleAspectFill
        cell.imgBack.clipsToBounds = true
        
        cell.imgLogo.layer.borderWidth = 1.0
        cell.imgLogo.contentMode = .ScaleAspectFit
        cell.imgLogo.backgroundColor = UIColor.whiteColor()
        cell.imgLogo.layer.masksToBounds = false
        cell.imgLogo.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.imgLogo.layer.cornerRadius = cell.imgLogo.frame.size.height/2
        cell.imgLogo.clipsToBounds = true
        
        let dataDict = self.dataSource[indexPath.row] as! [String : AnyObject]
  //     cell.title.text = dataDict["name"] as? String
        cell.title.text = dataDict["latestArticleTitle"] as? String
        
        if let imageUrlStr = dataDict["latestArticleLogoUrl"] as? String {
            let image_url = NSURL(string: imageUrlStr )
            if (image_url != nil) {
                let placeholder = UIImage(named: "no_photo")
            //    cell.imgBack.setImageWithURL(image_url, placeholderImage: placeholder)
           /*     cell.imgBack.setImageWithURLRequest(NSURLRequest(URL: image_url!), placeholderImage: placeholder, success: { (request:NSURLRequest!, response:NSHTTPURLResponse?, image:UIImage?)in
                    cell.imgBack.image = image
                    
                    }, failure: { (request:NSURLRequest!, response:NSHTTPURLResponse!, err:NSError!) in
                        
                })*/
                
                cell.imgBack.sd_setImageWithURL((URL: image_url!), placeholderImage: placeholder)
                
                
                
            }
        }
        
        if let logoUrlStr = dataDict["logoUrl"] as? String {
            let image_url = NSURL(string: logoUrlStr )
            if (image_url != nil) {
                let placeholder = UIImage(named: "no_photo")
             //   cell.imgLogo.setImageWithURL(image_url, placeholderImage: placeholder)
                
          /*      cell.imgLogo.setImageWithURLRequest(NSURLRequest(URL: image_url!), placeholderImage: placeholder, success: { (request:NSURLRequest!, response:NSHTTPURLResponse?, image:UIImage?)in
                    cell.imgLogo.image = image
                    
                    }, failure: { (request:NSURLRequest!, response:NSHTTPURLResponse!, err:NSError!) in
                        
                })*/
                
                 cell.imgLogo.sd_setImageWithURL((URL: image_url!), placeholderImage: placeholder)
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print_debug("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        
        self.handleSingleTapAtIndex(indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
                    return CGSizeMake(collectionView.frame.size.width/2-40, collectionView.frame.height-20)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 7
    }
    
    func handleSingleTapAtIndex(indexPath : NSIndexPath)  {
        
        var url : String!
        
        if((self.dataSource[indexPath.row]["latestArticleLink"] as! String).hasPrefix("http://") || (self.dataSource[indexPath.row]["latestArticleLink"] as! String).hasPrefix("https://")){
            
            url = self.dataSource[indexPath.row]["latestArticleLink"] as! String
        }
        else
        {
            url = "http://" + (self.dataSource[indexPath.row]["latestArticleLink"] as! String)
        }
        
        let WebVC:WebViewVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("WebViewVC") as! WebViewVC
        WebVC.title = self.dataSource[indexPath.row]["name"] as? String
        
        if url != nil {
            WebVC.urlStr = url!
            let objTopViewController = UIApplication.topViewController()!
            objTopViewController.navigationController?.pushViewController(WebVC, animated: true)
        }
        
    }
    
    func handleLongPressOnHeader(gestureRecognizer : UILongPressGestureRecognizer){
        
        if (gestureRecognizer.state != UIGestureRecognizerState.Began){
            return
        }
        
        let cell = gestureRecognizer.view as? UICollectionViewCell
        
        if let indexPath : NSIndexPath = (self.collectionView?.indexPathForCell(cell!))!{
            //do whatever you need to do
            print_debug(indexPath)
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let orgProfileVC: OrgProfileVC = storyBoard.instantiateViewControllerWithIdentifier("OrgProfileVC") as! OrgProfileVC
            orgProfileVC.dataDict = self.dataSource[indexPath.row] as! [String : AnyObject]
            self.viewController()!.navigationController?.pushViewController(orgProfileVC, animated: true)

        }
        
    }
}

class HeaderScrollerView: UICollectionReusableView{
    
    
    @IBOutlet weak var customHeaderReusableView: CollectionHeaderCustomView!
    var customView : CollectionHeaderCustomView? = nil
    override init(frame: CGRect) {
        super.init(frame: frame)
     
   customView = NSBundle.mainBundle().loadNibNamed("CollectionHeaderCustomView", owner: nil, options: nil)![0] as? CollectionHeaderCustomView
    customView!.frame = CGRectMake(0, 0,screen.width,370)
    self.addSubview(customView!)

        //self.collectionView.reloadData()
    }
  
    func setDataSource(dataSoure : [AnyObject]) -> Void {
        customView?.dataSource = dataSoure
        customView?.collectionView.reloadData()
    }
    
    func setViewTitle(top topTitle:String, bottomTitle:String) -> Void {
        
        customView?.lbl_top.text = topTitle
        customView?.lbl_bottom.text = bottomTitle
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.myCustomInit()
    }
    
    func myCustomInit() {
        print_debug("hello there from SupView")
    }

}
