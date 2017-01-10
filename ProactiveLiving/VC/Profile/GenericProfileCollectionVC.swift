//
//  GenericProfileCollectionVC.swift
//  ProactiveLiving
//
//  Created by Affle on 10/01/2017.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit


class GenericProfileCollectionVC: UIViewController {

    @IBOutlet weak var lbl_title: UILabel!

    @IBOutlet weak var cv: UICollectionView!
    
    
    var genericType:ProfileGenericType?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if genericType == .Friends {
            self.lbl_title.text = "Friends"
        }else if genericType == .Followers {
            self.lbl_title.text = "Followers"
        }else if genericType == .Photos {
            self.lbl_title.text = "Photos"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickBackBtn(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
 

}

extension GenericProfileCollectionVC:UICollectionViewDataSource{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCellWithReuseIdentifier("FollowerCell", forIndexPath: indexPath) as! UICollectionViewCell
        
        let iv_profile = cell.viewWithTag(1) as! UIImageView
        let lbl_name = cell.viewWithTag(2) as! UILabel
        
        iv_profile.layer.borderWidth = 1.0
        iv_profile.contentMode = .ScaleAspectFill
        iv_profile.backgroundColor = UIColor.whiteColor()
        iv_profile.layer.masksToBounds = false
        iv_profile.layer.borderColor = UIColor.lightGrayColor().CGColor
        iv_profile.layer.cornerRadius = iv_profile.frame.size.height/2
        iv_profile.clipsToBounds = true
        
        
        return cell
    }
}
