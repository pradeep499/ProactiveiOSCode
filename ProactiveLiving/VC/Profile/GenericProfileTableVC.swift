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
    
    var genericType:ProfileGenericType?
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_summary: UILabel!
    @IBOutlet weak var tv: UITableView!
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if genericType == .AboutMe{
            self.lbl_title.text = "About Me"
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
    
    //MARK: Btn Click
    
    @IBAction func onClickBackBatn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    
    }

}

extension GenericProfileTableVC: UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let iv = cell.viewWithTag(1) as! UIImageView
        let lbl_title = cell.viewWithTag(2) as! UILabel
        let lbl_details = cell.viewWithTag(3) as! UILabel
        
        
        switch indexPath.row {
        case 0:
            iv.image = UIImage(named: "mp_live_in")
            lbl_title.text = "Live in"
            break
        case 1:
            iv.image = UIImage(named: "mp_work_at")
            lbl_title.text = "Work at"
            break
            
        case 2:
            iv.image = UIImage(named: "mp_grew_up")
            lbl_title.text = "Grew Up In"
            break
            
        case 3:
            iv.image = UIImage(named: "mp_high_school")
            lbl_title.text = "High School"
            break
            
        case 4:
            iv.image = UIImage(named: "mp_sports_play")
            lbl_title.text = "Sports Played"
            break
            
        case 5:
            iv.image = UIImage(named: "mp_college")
            lbl_title.text = "College"
            break
            
        case 6:
            iv.image = UIImage(named: "mp_sports_played")
            lbl_title.text = "Sports Played"
            break
            
        case 7:
            iv.image = UIImage(named: "mp_graduate_school")
            lbl_title.text = "Graduate School"
            break
            
        case 8:
            iv.image = UIImage(named: "mp_current_sports")
            lbl_title.text = "Current Sports"
            break
            
        case 9:
            iv.image = UIImage(named: "mp_intrests")
            lbl_title.text = "Interests"
            break
            
        case 10:
            iv.image = UIImage(named: "mp_quotes")
            lbl_title.text = "Favorite Famous Quote"
            break
            
        case 11:
            iv.image = UIImage(named: "mp_quotes")
            lbl_title.text = "My Not-So-Famous Quote"
            break
            
        case 12:
            iv.image = UIImage(named: "mp_my_bio")
            lbl_title.text = "My Bio"
            break
            
        default:
            break
        }
        
        return cell
    }
}

