//
//  ExploreVC.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 26/09/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit

class ExploreVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        //layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        //layout.minimumInteritemSpacing = 10
        //layout.minimumLineSpacing = 10
        //collectionView!.collectionViewLayout = layout
        
        // Do any additional setup after loading the view.
        
        self.collectionView.registerClass(HeaderScrollerView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderScrollerView")
        
        
        
        //self.collectionView.registerNib( UINib(nibName: "HeaderScrollerView", bundle: nil), forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:"HeaderScrollerView")

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.collectionView.reloadData()
    }

    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        
//        switch kind {
//            
//        case UICollectionElementKindSectionHeader:
//            
//            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath)
//            
//            headerView.backgroundColor = UIColor.blueColor();
//            return headerView
//            
//        case UICollectionElementKindSectionFooter:
//            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Footer", forIndexPath: indexPath) 
//            
//            footerView.backgroundColor = UIColor.greenColor();
//            return footerView
//            
//        default:
//            
//            assert(false, "Unexpected element kind")
//        }
//    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderScrollerView", forIndexPath: indexPath) as! HeaderScrollerView
            
       //     headerView.frame.size.height = 0
            headerView.backgroundColor = UIColor.redColor()
            headerView.setDataSource(dataArrForHeader)
            headerView.setViewTitle(top: "FOLLOWING", bottomTitle: "FOLLOW")
            return headerView
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //let dataArr = self.dataDict["members"] as! [AnyObject]
        return dataArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ExploreCell", forIndexPath: indexPath) as UICollectionViewCell
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        let lpgrMain : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ExploreVC.handleLongPress(_:)))
        lpgrMain.minimumPressDuration = 0.5
        
        lpgrMain.delegate = self
        lpgrMain.delaysTouchesBegan = true
        cell.addGestureRecognizer(lpgrMain)
        
        let imgBackGround = cell.contentView.viewWithTag(111) as! UIImageView
        imgBackGround.contentMode = .ScaleAspectFill
        imgBackGround.clipsToBounds = true

        let imgLogo = cell.contentView.viewWithTag(222) as! UIImageView
        imgLogo.layer.borderWidth = 1.0
        imgLogo.contentMode = .ScaleAspectFit
        imgLogo.backgroundColor = UIColor.whiteColor()
        imgLogo.layer.masksToBounds = false
        imgLogo.layer.borderColor = UIColor.lightGrayColor().CGColor
        imgLogo.layer.cornerRadius = imgLogo.frame.size.height/2
        imgLogo.clipsToBounds = true
        
        let lblTitle = cell.contentView.viewWithTag(333) as! UILabel

        let dataDict = dataArr[indexPath.row] as! [String : AnyObject]
    //    lblTitle.text = dataDict["name"] as? String
        lblTitle.text = dataDict["latestArticleTitle"] as? String
        
        if let imageUrlStr = dataDict["latestArticleLogoUrl"] as? String {
            let image_url = NSURL(string: imageUrlStr )
            if (image_url != nil) {
                let placeholder = UIImage(named: "no_photo")
               // imgBackGround.setImageWithURL(image_url, placeholderImage: placeholder)
             /*   imgBackGround.setImageWithURLRequest(NSURLRequest(URL: image_url!), placeholderImage: placeholder, success: { (request:NSURLRequest!, response:NSHTTPURLResponse?, image:UIImage?)in
                    imgBackGround.image = image
                    
                    }, failure: { (request:NSURLRequest!, response:NSHTTPURLResponse!, err:NSError!) in
                        
                })*/
                
                imgBackGround.sd_setImageWithURL((URL: image_url!), placeholderImage: placeholder)
            }
        }
        
        
        if let logoUrlStr = dataDict["logoUrl"] as? String {
            let image_url = NSURL(string: logoUrlStr )
            if (image_url != nil) {
                let placeholder = UIImage(named: "no_photo")
              //  imgLogo.setImageWithURL(image_url, placeholderImage: placeholder)
                
           /*     imgLogo.setImageWithURLRequest(NSURLRequest(URL: image_url!), placeholderImage: placeholder, success: { (request:NSURLRequest!, response:NSHTTPURLResponse?, image:UIImage?)in
                    imgLogo.image = image
                    
                    }, failure: { (request:NSURLRequest!, response:NSHTTPURLResponse!, err:NSError!) in
                        
                })*/
                imgLogo.sd_setImageWithURL((URL: image_url!), placeholderImage: placeholder)
            }
        }

        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        self.handleSingleTapAtIndex(indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        //let cardItem = self.dataArr[indexPath.row]["size"] as! String
        
       if ((indexPath.row)%3 == 0) {
        
        return CGSizeMake(collectionView.frame.size.width-20, 160)
        
        } else {
        
        return CGSizeMake(collectionView.frame.size.width/2-15, 160)

        }
        
        
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

    
    func handleSingleTapAtIndex(indexPath : NSIndexPath)  {
        
        var url : String!
    
        
        //let dataDict = self.dataSource[indexPath.row] as! [String : AnyObject]
        //cell.title.text = dataDict["name"] as? String
        
        if((dataArr[indexPath.row]["latestArticleLink"] as! String).hasPrefix("http://") || (dataArr[indexPath.row]["latestArticleLink"] as! String).hasPrefix("https://")){
            
            url = dataArr[indexPath.row]["latestArticleLink"] as! String
        }
        else
        {
            url = "http://" + (dataArr[indexPath.row]["latestArticleLink"] as! String)
        }
        
        let WebVC:WebViewVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("WebViewVC") as! WebViewVC
        WebVC.title = dataArr[indexPath.row]["name"] as! String
        
        if url != nil {
            WebVC.urlStr = url!
            self.navigationController?.pushViewController(WebVC, animated: true)
        }
        
    }
    
    func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        
        if (gestureRecognizer.state != UIGestureRecognizerState.Began){
            return
        }
        
        let cell = gestureRecognizer.view as? UICollectionViewCell
        
        if let indexPath : NSIndexPath = (self.collectionView?.indexPathForCell(cell!))!{
            //do whatever you need to do
            print(indexPath)
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let orgProfileVC: OrgProfileVC = storyBoard.instantiateViewControllerWithIdentifier("OrgProfileVC") as! OrgProfileVC
            orgProfileVC.dataDict = dataArr[indexPath.row] as! [String : AnyObject]
            self.navigationController?.pushViewController(orgProfileVC, animated: true)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
