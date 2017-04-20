//
//  BroadcastVCCollectionViewController.swift
//  ProactiveLiving
//
//  Created by Affle on 21/10/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class BroadcastVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var lbl_subTitle: UILabel!

    @IBOutlet weak var collectionView: UICollectionView!
    var dataDictArr = [AnyObject]?()
    var subTitle = String?()
    
    var imgArr = [String]()
    var titleArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
    //    self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        

        imgArr = ["http://www.healthyhearthealthyplanet.com/wordpress1/wp-content/uploads/2014/10/25129988.jpg",
                  "https://sites.duke.edu/blogcfm/files/2015/07/group-shot-1024x692.jpg",
                  "https://sites.duke.edu/blogcfm/files/2015/07/group-shot-1024x692.jpg", "https://www.freshology.com/wp-content/uploads/2015/02/PRESS_GMA-TV-logo_800x500-450x280.jpg",
                  "http://www.healthyhearthealthyplanet.com/wordpress1/wp-content/uploads/2014/10/25129988.jpg",
                  "https://sites.duke.edu/blogcfm/files/2015/07/group-shot-1024x692.jpg",
                  "https://sites.duke.edu/blogcfm/files/2015/07/group-shot-1024x692.jpg", "https://www.freshology.com/wp-content/uploads/2015/02/PRESS_GMA-TV-logo_800x500-450x280.jpg"]
        titleArr = ["Healthy Heart", "Reflections from the American College of Lifestyle Medicine conference",
                    "Resident Roundup",
                    "JILLIAN MICHAELS DIGS INTO THE FOOD DELIVERY BUSINESS",
                    "Healthy Heart", "Reflections from the American College of Lifestyle Medicine conference",
                    "Resident Roundup",
                    "JILLIAN MICHAELS DIGS INTO THE FOOD DELIVERY BUSINESS"]
        
        self.collectionView.reloadData()
        lbl_subTitle.text = subTitle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: btnBackClick
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    // MARK: UICollectionViewDataSource

     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.dataDictArr!.count
    }

     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as UICollectionViewCell
    
        let iv_bg = cell.viewWithTag(11) as! UIImageView
        let iv_broadcast = cell.viewWithTag(22) as! UIImageView
        let lbl_title = cell.viewWithTag(2) as! UILabel
        let lbl_author = cell.viewWithTag(3) as! UILabel
        let lbl_views = cell.contentView.viewWithTag(4) as! UILabel
        
        if indexPath.row % 2 == 0 {
            
            iv_broadcast.image = UIImage(named: "broadcast")
        }else{
            iv_broadcast.image = UIImage(named: "broadcast_camera")
        }
        
        if let dict = self.dataDictArr![indexPath.row] as? [String:String] {
            
            if let image_url = NSURL(string: dict["logoLink"]! as String ){
                
                let placeholder = UIImage(named: "no_photo")
                iv_bg.sd_setImageWithURL(image_url, placeholderImage:placeholder)
            }
            
            lbl_title.text = dict["title"]! as String
            lbl_author.text = dict["author"]! as String
            lbl_views.text = "50" //dict["title"]! as String
         
            
            
        }
        
        return cell
    }
    //MARK: - UICollectionView Delegate methods
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let dict = self.dataDictArr![indexPath.row] as? [String:String]
        
        if let aboutUrl = dict!["articleLink"]  {
            
           let titleStr = dict!["title"]! as String
            
            // redirection to next VC for WebView
            let WebVC:WebViewVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("WebViewVC") as! WebViewVC
            WebVC.title = titleStr//"About"
            WebVC.urlStr = aboutUrl 
            self.navigationController?.pushViewController(WebVC, animated: true)
            
           // UIApplication.sharedApplication().openURL(NSURL(string: aboutUrl )!)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        //let cardItem = self.dataArr[indexPath.row]["size"] as! String
        
      return CGSizeMake(collectionView.frame.size.width/2 - 15 , collectionView.frame.size.width/2 - 20 )
        
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
