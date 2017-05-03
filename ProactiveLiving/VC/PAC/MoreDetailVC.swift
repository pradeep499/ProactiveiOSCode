//
//  MoreDetailVC.swift
//  ProactiveLiving
//
//  Created by Aseem Akarshan on 3/20/17.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit

class MoreDetailVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var moreDetailTxtView: UITextView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK:- Properties
    
    var detailStr : String?
    var titleStr : String?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = titleStr
        moreDetailTxtView.text = detailStr
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    //MARK:- Button Action
    
    @IBAction func backButtonAction(sender: AnyObject) {
        
        NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_FROM_MOREDETAILVC, object: self)
        self.navigationController?.popViewControllerAnimated(true)
        
    }
}
