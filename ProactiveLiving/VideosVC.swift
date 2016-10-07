//
//  VideosVC.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 05/10/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class VideosVC: UIViewController {

    var arrUrls = [AnyObject]()
    var yourArray = [String]()
    var moviePlayer = MPMoviePlayerViewController()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    //mark- UITableview Delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUrls.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("CellVideos", forIndexPath: indexPath)
        cell.selectionStyle = .None
        
        let thumbVideo = cell.contentView.viewWithTag(111) as! UIImageView
        //thumbVideo.addTarget(self, action: #selector(self.btnPlayVideoClick(_:)), forControlEvents: .TouchUpInside)
     //   var escapedString = self.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)

        if let imageUrlStr = arrUrls[indexPath.row] as? String {
            let customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
            let image_url = NSURL(string: (imageUrlStr.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet))! )
            if (image_url != nil) {
                
                let qualityOfServiceClass = QOS_CLASS_BACKGROUND
                let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
                dispatch_async(backgroundQueue, {
                    
                    let grabTime = 0.5
                    if let image = self.generateThumnail(image_url!, fromTime: Float64(grabTime))
                    {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        //thumbVideo.setImage(image, forState: .Normal)
                        thumbVideo.image = self.addGradientOnImage(image)
                    })
                    }
                    else
                    {
                        print("No image")
                    }
                })
            
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.playVideoOnCellTap(indexPath)

    }
    
    func addGradientOnImage(image: UIImage) -> UIImage
    {
//        let size = CGSize(width:image.size.width, height:image.size.height)
//        let layer = CAGradientLayer()
//        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//        layer.colors = [UIColor.blackColor().CGColor,
//        UIColor.whiteColor().CGColor] // end color
//        UIGraphicsBeginImageContext(size)
//        layer.renderInContext(UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
//        UIGraphicsEndImageContext()

        
        UIGraphicsBeginImageContext(image.size)
        let context = UIGraphicsGetCurrentContext()
        
        image.drawAtPoint(CGPointMake(0, 0))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations:[CGFloat] = [0.0, 1.0]
        let top = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0).CGColor
        let bottom = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).CGColor
        let gradient = CGGradientCreateWithColors(colorSpace,
                                                  [top, bottom], locations)
        
        let startPoint = CGPointMake(image.size.width / 2, image.size.height / 2)
        let endPoint = CGPointMake(image.size.width / 2, image.size.height)
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint,CGGradientDrawingOptions(rawValue: 0))
        let finalImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return finalImage
        
    }
    
    func getPreviewImageForVideoAtURL(videoURL: NSURL, atInterval: Int) -> UIImage? {
        print("Taking pic at \(atInterval) second")
        let asset = AVAsset(URL: videoURL)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(Float64(atInterval), 100)
        do {
            let img = try assetImgGenerate.copyCGImageAtTime(time, actualTime: nil)
            let frameImg = UIImage(CGImage: img)
            return frameImg
        } catch {
            /* error handling here */
        }
        return nil
    }
    
    func generateThumnail(url : NSURL, fromTime:Float64) -> UIImage? {
       
        let asset : AVAsset = AVAsset(URL: url )
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(0.5, 1000)
        var actualTime = kCMTimeZero
        var thumbnail : CGImageRef?
        do {
            thumbnail = try imageGenerator.copyCGImageAtTime(time, actualTime: &actualTime)
            return UIImage(CGImage: thumbnail!)
        }
        catch let error as NSError {
            print(error.localizedDescription)
            return UIImage(named: "ic_instruction_video")!
        }
    
        
        
    }

    
    func thumbnailImageForVideo(url:NSURL) -> UIImage?
    {
        let asset = AVAsset(URL: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        var time = asset.duration
        //If possible - take not the first frame (it could be completely black or white on camara's videos)
        time.value = min(time.value, 4)
        
        do {
            let imageRef = try imageGenerator.copyCGImageAtTime(time, actualTime: nil)
            return UIImage(CGImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return UIImage(named: "bubble")!
        }
    }
    
    func playVideoOnCellTap(indexPath: NSIndexPath ) -> Void {
        
        let urlString = self.arrUrls[indexPath.row] as! String
        self.moviePlayer = MPMoviePlayerViewController(contentURL: NSURL(string:urlString)!)
        self.moviePlayer.moviePlayer.movieSourceType = .Unknown
        self.moviePlayer.moviePlayer.prepareToPlay()
        self.moviePlayer.moviePlayer.shouldAutoplay = true
        //[[self.moviePlayer moviePlayer] setControlStyle:MPMovieControlStyleNone];
        //[[self.moviePlayer moviePlayer] setFullscreen:YES animated:YES];
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.mpMoviePlayerLoadStateDidChange(_:)), name: MPMoviePlayerLoadStateDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.moviePlaybackDidFinish), name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
        self.presentMoviePlayerViewControllerAnimated(self.moviePlayer)
        self.moviePlayer.moviePlayer.play()
        
    }
    
    func btnPlayVideoClick(sender: UIButton) -> Void {
        
        let point = self.tableView.convertPoint(CGPoint.zero, fromView: sender)
        
        guard let indexPath = self.tableView.indexPathForRowAtPoint(point) else {
            fatalError("can't find point in tableView")
        }
        
        let urlString = self.arrUrls[indexPath.row] as! String
        self.moviePlayer = MPMoviePlayerViewController(contentURL: NSURL(string:urlString)!)
        self.moviePlayer.moviePlayer.movieSourceType = .Unknown
        self.moviePlayer.moviePlayer.prepareToPlay()
        self.moviePlayer.moviePlayer.shouldAutoplay = true
        //[[self.moviePlayer moviePlayer] setControlStyle:MPMovieControlStyleNone];
        //[[self.moviePlayer moviePlayer] setFullscreen:YES animated:YES];
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.mpMoviePlayerLoadStateDidChange(_:)), name: MPMoviePlayerLoadStateDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.moviePlaybackDidFinish), name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
        self.presentMoviePlayerViewControllerAnimated(self.moviePlayer)
        self.moviePlayer.moviePlayer.play()
        
    }
    
    func mpMoviePlayerLoadStateDidChange(notification: NSNotification) {
        //    NSLog(@"loadstate change: %lu", (unsigned long)[self.moviePlayer moviePlayer].loadState);
        //
        //    if (([self.moviePlayer moviePlayer].loadState & MPMovieLoadStatePlayable) == MPMovieLoadStatePlayable)
        //    {
        //        NSLog(@"yay, it became playable");
        //    }
    }
    
    func moviePlaybackDidFinish() {
        print("Movie finished!!!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
