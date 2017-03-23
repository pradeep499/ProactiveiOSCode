//
//  MemberContactListVC.swift
//  ProactiveLiving
//
//  Created by Aseem Akarshan on 3/20/17.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit

class MemberContactListVC: UIViewController {

    var contactArr = [[String : AnyObject]]() //[AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//MARK:- Button Action
    @IBAction func backBtnAction(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
}

//MARK:- UITableViewDataSource
extension MemberContactListVC : UITableViewDataSource {
  
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contactArr.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactItemList")! as UITableViewCell
        let nameLbl = cell.viewWithTag(20) as! UILabel
        let profileImg = cell.viewWithTag(10) as! UIImageView
        let memberDict = contactArr[indexPath.row]
        
        profileImg.layer.borderWidth = 1.0
        profileImg.layer.masksToBounds = false
        profileImg.layer.borderColor = UIColor.whiteColor().CGColor
        profileImg.layer.cornerRadius =  profileImg.frame.size.width/2
        profileImg.clipsToBounds = true
        
        let completeName = (memberDict["firstName"] as? String)! + " " + (memberDict["lastName"] as? String)!
        
        nameLbl.text = completeName
        profileImg.sd_setImageWithURL(NSURL.init(string: (memberDict["imgUrl"] as! String)), placeholderImage: UIImage.init(named: "ic_booking_profilepic"))
        return cell
        
        
    }
    
    
}

//MARK:- UITableViewDelegate
extension MemberContactListVC : UITableViewDelegate {
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
  
    }
  
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let memberDict = contactArr[indexPath.row]
        let userId = memberDict["_id"] as? String
       
        
        let profileContainerVC = AppHelper.getProfileStoryBoard().instantiateViewControllerWithIdentifier("ProfileContainerVC") as! ProfileContainerVC
        profileContainerVC.viewerUserID = userId
        self.navigationController?.pushViewController(profileContainerVC, animated: true)
        
    }
    
    
}
