//
//  FullScreenImageVC.swift
//  Whatsumm
//
//  Created by mawoon on 22/06/15.
//  Copyright (c) 2015 AppStudioz. All rights reserved.
//

import UIKit

class FullScreenImageVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var activitIndc: UIActivityIndicatorView!
    @IBOutlet weak var fullImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!

    var bottomTabBar : CustonTabBarController!

    var imagePath : String!
    var downLoadPath : String!
    var parentNewsFeed:NewsFeedsAllVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activitIndc.hidden = true
        bottomTabBar = self.tabBarController as? CustonTabBarController
        self.fullImageView.contentMode = .ScaleAspectFit
        self.fullImageView.image = nil
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 10.0
        self.navigationController?.hidesBarsOnTap = true

        if downLoadPath == "0" {
             self.fullImageView.image = UIImage(contentsOfFile: imagePath)
            if self.fullImageView.image == nil {
                activitIndc.hidden = false
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FullScreenImageVC.showDownloadedImage(_:)),name:"showImageFOrFullScreen", object:nil)
            }
        } else if downLoadPath == "3" {
            //load from url path
            self.fullImageView.sd_setImageWithURL(NSURL(string: imagePath), placeholderImage: UIImage(named:  "cell_blured_heigh"))
            self.navigationController?.navigationBarHidden = false
        }else if downLoadPath == "4" {
            //load from local path
            self.fullImageView.image = UIImage(contentsOfFile: imagePath)
            self.navigationController?.navigationBarHidden = false
             
        }else {
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.hidesBarsOnTap = false
        bottomTabBar!.setTabBarVisible(true, animated: true) { (finish) in
            // print(finish)
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.fullImageView

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
        
        if parentNewsFeed != nil{
            parentNewsFeed.isBackFromChildVC = true
        }
    }

  

}
