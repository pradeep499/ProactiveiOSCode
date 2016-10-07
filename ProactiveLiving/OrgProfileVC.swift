//
//  OrgProfileVC.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 30/09/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit

class OrgProfileVC: UIViewController {

    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblAboutOrg: UILabel!
    @IBOutlet weak var btnPhone: UIButton!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var gridCollectionView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var arrButtonImages : Array<String> = Array()
    var dataDict = [String : AnyObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgProfile.layer.borderWidth = 1.0
        imgProfile.contentMode = .ScaleAspectFill
        imgProfile.backgroundColor = UIColor.whiteColor()
        imgProfile.layer.masksToBounds = false
        imgProfile.layer.borderColor = UIColor.lightGrayColor().CGColor
        imgProfile.layer.cornerRadius = 5
        imgProfile.clipsToBounds = true

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
        
        btnEmail.addTarget(self, action: #selector(btnLinkClick(_:)), forControlEvents: .TouchUpInside)
        btnPhone.addTarget(self, action: #selector(btnDialUpClick(_:)), forControlEvents: .TouchUpInside)

        
        // Do any additional setup after loading the view.
        
        arrButtonImages=[
        "about",
        "education",
        "videos",
        "promotions",
        "announcements",

        "add_favorite",
        "follow",
        "message",
        "share",
        "social",
        "website"]
        
    }
    
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
        
        if(indexPath.row==10)
        {
            let webUrl = self.dataDict["latestArticleLink"] as! String
            self.btnWebLinkClick(webUrl)
            
        } else if(indexPath.row==2) {
            let videosContainer: VideosContainer = self.storyboard!.instantiateViewControllerWithIdentifier("VideosContainer") as! VideosContainer
            videosContainer.dataDict=dataDict["videos"] as! [String:AnyObject]
            self.navigationController?.pushViewController(videosContainer, animated: true)

        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(collectionView.frame.size.width/3-34, collectionView.frame.size.height/4-44)
        
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
    
    func btnLinkClick(sender: UIButton)  {
        print(sender)
        
        var url : String!
        
        if((self.dataDict["webLink"] as! String).hasPrefix("http://") || (self.dataDict["webLink"] as! String).hasPrefix("https://")){
            
            url = self.dataDict["webLink"] as! String
        }
        else
        {
            url = "http://" + (self.dataDict["webLink"] as! String)
        }
        
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        
    }
    
    func btnDialUpClick(sender: UIButton)  {
        print(sender)
        
        let phoneNumber: String = self.dataDict["dialInNumber"] as! String
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
