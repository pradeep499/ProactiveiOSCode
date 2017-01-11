//
//  ProfileVC.swift
//  ProactiveLiving
//
//  Created by Affle on 09/01/2017.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbl_profileStatus: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let status = AppHelper.userDefaultsForKey(userProfileStatus) {
            self.lbl_profileStatus.text = "Status: " + (status as! String) as? String
        }
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

}

extension ProfileVC : UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let w = collectionView.bounds.size.width / 3.5
        
         return CGSize(width: w, height: w)
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
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
            
        case 2:
            iv.image = UIImage(named: "pf_")
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
            break
            
        default:
            break
        }
        
        cell.userInteractionEnabled = true
        
        return cell
    }
}

extension ProfileVC: UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let profileStoryBoard = AppHelper.getProfileStoryBoard()
        self.navigationController?.navigationBarHidden = true
        
        switch indexPath.row {
        case 0:
            
            let vc = profileStoryBoard.instantiateViewControllerWithIdentifier("GenericProfileTableVC") as! GenericProfileTableVC
            vc.genericType = .AboutMe
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            break
            
        case 2:
            break
            
        case 3:
            let vc = profileStoryBoard.instantiateViewControllerWithIdentifier("GenericProfileCollectionVC") as! GenericProfileCollectionVC
            vc.genericType = .Photos
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case 4:
            break
            
        case 5:
            let vc = profileStoryBoard.instantiateViewControllerWithIdentifier("GenericProfileCollectionVC") as! GenericProfileCollectionVC
            vc.genericType = .Followers
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case 6:
            break
            
        case 7:
            break
            
        case 8:
            break
            
        case 9:
            break
            
        case 10:
            let vc = profileStoryBoard.instantiateViewControllerWithIdentifier("GenericProfileCollectionVC") as! GenericProfileCollectionVC
            vc.genericType = .Friends
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case 11:
            break
            
        case 12:
            break
            
        case 13:
            break
            
        case 14:
            break
            
        case 15:
            break
            
        default:
            break
        }
    }
}
