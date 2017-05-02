//
//  ProfileVC.swift
//  ProactiveLiving
//
//  Created by Affle on 09/01/2017.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController ,UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbl_profileStatus: UILabel!
    
    @IBOutlet weak var layout_CollectionViewBottomHeight: NSLayoutConstraint!
    
    var cvHeight:CGFloat = 0.0;
    //to check owner or friend not nill all time
    var viewerUserID:String!
    var isFriend = false
    
    var bottomTabBar : CustonTabBarController!
    
    var dictForFriends = [String:AnyObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.lbl_profileStatus.text = "  Status:"
        HelpingClass.setViewWithRoundedCorners(self.lbl_profileStatus, color: UIColor.clearColor(), cornerRadius: 0.0, borderColor: UIColor(0.0,176.0,336.0,1.0), borderWidth: 1.0)
        bottomTabBar = self.tabBarController as? CustonTabBarController
        
        
        if String(AppHelper.userDefaultsForKey(_ID)) == viewerUserID{
            //Owner
            if let status = AppHelper.userDefaultsForKey(userProfileStatus) {
                self.lbl_profileStatus.text = "  Status:" + (status as! String)
            }
        }else{
            NSNotificationCenter.defaultCenter().removeObserver(self, name: "NotifyFrDetails", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileVC.NotifyFrDetails(_:)), name:"NotifyFrDetails", object: nil)
            
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        bottomTabBar = self.tabBarController as? CustonTabBarController
        bottomTabBar!.setTabBarVisible(true, animated: true) { (finish) in
            // print(finish)
        }
        
        if !(String(AppHelper.userDefaultsForKey(_ID)) == viewerUserID){
            isFriend = true
        }else{
            isFriend = false
        }
        
        self.setUpCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func setUpCollectionView() -> Void {
        
        let w = self.collectionView.bounds.size.width - 30
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        
        layout.itemSize = CGSize(width: w/3 - 5, height: w/3 + 30)
        layout.minimumInteritemSpacing = 6
        layout.minimumLineSpacing = 10
        self.collectionView!.collectionViewLayout = layout
        
        self.layout_CollectionViewBottomHeight.constant = cvHeight
    }
    
    
    func NotifyFrDetails(notification: NSNotification){
       
        if let status = friendDetailsDict!["result"]!["userStatus"] ?? ""{
            self.lbl_profileStatus.text = "  Status:" + (status as! String)
            //dictForFriends = notification.userInfo as! [String:AnyObject]
            //print_debug("dictForFriends")
            //print_debug(dictForFriends)
            
        }
        
    }
    


}

extension ProfileVC : UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
       //  layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
       //  layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
      //collectionView.collectionViewLayout = layout
        
        // UICollectionViewDelegateFlowLayout
        
        let w = collectionView.bounds.size.width - 30
       //  let w = collectionView.bounds.size.width
        return CGSize(width: w/3 - 5 , height: w/3 + 30)
        //  return CGSize(width: w/3 , height: w/3)
        
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
       
        return UIEdgeInsets(top: 5, left: 10, bottom:5, right: 10)
       // return UIEdgeInsets(top: 0, left: 0, bottom:0, right: 0)
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        
        let iv = cell.viewWithTag(1) as! UIImageView
        let lbl = cell.viewWithTag(2) as! UILabel
        
        switch indexPath.row {
        case 0:
            iv.image = UIImage(named: "pf_about")
            lbl.text = "About"
            break
        case 1:
            iv.image = UIImage(named: "pf_pacs")
            lbl.text = "PACs"
            break
            
     /*   case 2:
            iv.image = UIImage(named: "pf_promotions")
            lbl.text = "Promotions"
            break
            
        case 3:
            iv.image = UIImage(named: "pf_photos")
            lbl.text = "Photos"
            break
        
        case 4:
            iv.image = UIImage(named: "pf_videos")
            lbl.text = "Videos"
            break
        
        case 5:
            iv.image = UIImage(named: "pf_friends")
            lbl.text = "Friends"
            break
        
        case 6:
            iv.image = UIImage(named: "pf_qanda")
            lbl.text = "Q&A"
            break
        
        case 7:
            iv.image = UIImage(named: "pf_Inspirational")
            lbl.text = "Inspirational"
            break
        
        case 8:
            iv.image = UIImage(named: "pf_pass")
            lbl.text = "My PAS"
            break
            
        case 9:
            iv.image = UIImage(named: "pf_following")
            lbl.text = "Followings"
            break
        
        case 10:
            iv.image = UIImage(named: "pf_followers")
            lbl.text = "Followers"
            break
        
        case 11:
            iv.image = UIImage(named: "pf_social")
            lbl.text = "Social Networks"
            break*/
            
        case 2:
            iv.image = UIImage(named: "pf_friends")
            lbl.text = "Friends"
            break
            
        case 3:
            iv.image = UIImage(named: "pf_photos")
            lbl.text = "Gallery"
            break
            
        case 4:
            iv.image = UIImage(named: "pf_videos")
            lbl.text = "Videos"
            break
            
        case 5:
            iv.image = UIImage(named: "pf_social")
            lbl.text = "Social Networks"
            break
            
       
            
        default:
            break
        }
        
       // cell.userInteractionEnabled = true
        
        return cell
    }
}

extension ProfileVC: UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let profileStoryBoard = AppHelper.getProfileStoryBoard()
        self.navigationController?.navigationBarHidden = true
        
        switch indexPath.row {
        case 0: // About
            
            let vc = profileStoryBoard.instantiateViewControllerWithIdentifier("GenericProfileTableVC") as! GenericProfileTableVC
            vc.genericType = .AboutMe
            vc.viewerUserID = viewerUserID
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1: // PAC
            let profileStoryBoard = AppHelper.getPacStoryBoard()
            let vc = profileStoryBoard.instantiateViewControllerWithIdentifier("PacContainerVC") as! PacContainerVC
            vc.isFromMemberProfile = true
            vc.viewerUserID = viewerUserID
            vc.isFriend = isFriend
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case 2: // Friends
            let vc = profileStoryBoard.instantiateViewControllerWithIdentifier("GenericProfileCollectionVC") as! GenericProfileCollectionVC
            vc.genericType = .Friends
            vc.viewerUserID = viewerUserID
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
            
        case 3:  // Gallery
            let vc = profileStoryBoard.instantiateViewControllerWithIdentifier("GenericProfileCollectionVC") as! GenericProfileCollectionVC
            vc.genericType = .Gallery
            vc.viewerUserID = viewerUserID
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case 4: //Videos
            let videosContainer: VideosContainer = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("VideosContainer") as!VideosContainer
            videosContainer.videoContainerType = .Profile
            videosContainer.viewerUserID = viewerUserID
            self.navigationController?.pushViewController(videosContainer, animated: true)
            
            break
            
        case 5: // Social Network
            let vc = profileStoryBoard.instantiateViewControllerWithIdentifier("GenericProfileCollectionVC") as! GenericProfileCollectionVC
            vc.genericType = .SocialNetworks
            vc.viewerUserID = viewerUserID
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        default:
            break
        }
    }
}
