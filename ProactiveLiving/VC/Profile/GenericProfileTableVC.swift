//
//  GenericProfileTableVC.swift
//  ProactiveLiving
//
//  Created by Affle on 10/01/2017.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit

enum ProfileGenericType{
    case AboutMe
    case Friends
    case Followers
    case Photos
}

class GenericProfileTableVC: UIViewController {
    
    @IBOutlet weak var btnRight: UIButton!
    var genericType:ProfileGenericType?
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_summary: UILabel!
    @IBOutlet weak var tv: UITableView!
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if genericType == .AboutMe{
            self.lbl_title.text = "About Me"
            self.btnRight.hidden = false
        }
         
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Btn Click
    
    
    @IBAction func onClickRightBtn(sender: AnyObject) {
        
        let editAboutVC = AppHelper.getProfileStoryBoard().instantiateViewControllerWithIdentifier("EditAboutMeVC") as! EditAboutMeVC
        self.navigationController?.pushViewController(editAboutVC, animated: true)
    }

    
    @IBAction func onClickBackBatn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    
    }

}

extension GenericProfileTableVC: UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if genericType == .AboutMe{
            return 14
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
         if genericType == .AboutMe{
            return AboutMeCell.setUpCell(tableView, indexPath:indexPath );
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        return cell
    }
}


class AboutMeCell: GenericProfileTableVC {
    
    
    class func setUpCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let iv = cell.viewWithTag(1) as! UIImageView
        let lbl_title = cell.viewWithTag(2) as! UILabel
        let lbl_details = cell.viewWithTag(3) as! UILabel
        
        //fetch archive NSData and unarchive as obj type
        let obj:Beans.UserDetails = HelpingClass.getUserDetails()
        
            
            switch indexPath.row {
            case 0:
                iv.image = UIImage(named: "mp_live_in")
                lbl_title.text = "Live in"
                lbl_details.text = obj.liveIn
                break
            case 1:
                iv.image = UIImage(named: "mp_work_at")
                lbl_title.text = "Work at"
                lbl_details.text = obj.workAt
                break
                
            case 2:
                iv.image = UIImage(named: "mp_grew_up")
                lbl_title.text = "Grew Up In"
                lbl_details.text = obj.grewUp
                break
                
            case 3:
                iv.image = UIImage(named: "mp_high_school")
                lbl_title.text = "High School"
                lbl_details.text = obj.highSchool
                break
                
            case 4:
                iv.image = UIImage(named: "mp_sports_play")
                lbl_title.text = "Sports Played"
                lbl_details.text = obj.sportsPlayed
                break
                
            case 5:
                iv.image = UIImage(named: "mp_college")
                lbl_title.text = "College"
                lbl_details.text = obj.college
                break
                
            case 6:
                iv.image = UIImage(named: "mp_sports_played")
                lbl_title.text = "Sports Played"
                lbl_details.text = obj.sportsPlayed
                break
                
            case 7:
                iv.image = UIImage(named: "mp_graduate_school")
                lbl_title.text = "Graduate School"
                lbl_details.text = obj.graduateSchool
                break
                
            case 8:
                iv.image = UIImage(named: "mp_current_sports")
                lbl_title.text = "Current Sports"
                lbl_details.text = obj.sportsPlayed
                break
                
            case 9:
                iv.image = UIImage(named: "mp_intrests")
                lbl_title.text = "Interests"
                lbl_details.text = obj.interests
                break
                
            case 10:
                iv.image = UIImage(named: "mp_quotes")
                lbl_title.text = "Favorite Famous Quote"
                lbl_details.text = obj.favFamousQuote
                break
                
            case 11:
                iv.image = UIImage(named: "mp_quotes")
                lbl_title.text = "My Not-So-Famous Quote"
                lbl_details.text = obj.notFamousQuote
                break
                
            case 12:
                iv.image = UIImage(named: "mp_my_bio")
                lbl_title.text = "My Bio"
                lbl_details.text = obj.bio
                break
                
            default:
                break
            }
        
        
        return cell
    }
}

