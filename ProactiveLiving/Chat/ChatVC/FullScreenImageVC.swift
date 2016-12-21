//
//  FullScreenImageVC.swift
//  Whatsumm
//
//  Created by mawoon on 22/06/15.
//  Copyright (c) 2015 AppStudioz. All rights reserved.
//

import UIKit

class FullScreenImageVC: UIViewController {

    @IBOutlet weak var activitIndc: UIActivityIndicatorView!
    @IBOutlet weak var fullImageView: UIImageView!
    var bottomTabBar : CustonTabBarController!

    var imagePath : String!
    var downLoadPath : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activitIndc.hidden = true
        bottomTabBar = self.tabBarController as? CustonTabBarController
        
        
        if downLoadPath == "0" {
             fullImageView.image = UIImage(contentsOfFile: imagePath)
            if fullImageView.image == nil {
                activitIndc.hidden = false
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FullScreenImageVC.showDownloadedImage(_:)),name:"showImageFOrFullScreen", object:nil)
            }
        } else if downLoadPath == "3" {
            //load from url path
            fullImageView.sd_setImageWithURL(NSURL(string: imagePath), placeholderImage: UIImage(named:  "cell_blured_heigh"))
            self.navigationController?.navigationBarHidden = false
        } else {
            activitIndc.hidden = false
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FullScreenImageVC.showDownloadedImage(_:)),name:"showImageFOrFullScreen", object:nil)
        }
        // Do any additional setup after loading the view.
        
        let backBtn = UIBarButtonItem(image:UIImage(named: "signupBack")?.imageWithRenderingMode(.AlwaysOriginal), style:UIBarButtonItemStyle.Plain, target: self, action:#selector(self.backBtnClick))
        navigationItem.leftBarButtonItem = backBtn
        
    }
    override func viewWillAppear(animated: Bool) {
        bottomTabBar!.setTabBarVisible(false, animated: true) { (finish) in
            // print(finish)
        }
        super.viewWillAppear(animated)
    }
    
    
    func showDownloadedImage(note:NSNotification) {
            let imgStr : String = note.valueForKey("userInfo")?.valueForKey("imagePath") as! String
            self.fullImageView.image = UIImage(contentsOfFile: imgStr)
            self.activitIndc.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnClick() {
         self.navigationController?.popViewControllerAnimated(true)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "receiveMsgObserverUpdate", object: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
