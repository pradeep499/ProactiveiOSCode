//
//  ExploreDynamicVC.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 27/09/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit

class ExploreDynamicVC: UIViewController {

    /**Instance of the JMC Flexible collection view data source */
    var datasource: JMCFlexibleCollectionViewDataSource?
    var dataArr = Array<String>()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchExploreDataFromServer()
        /**Register collection view cell */
        //collectionView.registerClass(FlexibleCollectionCell.self, forCellWithReuseIdentifier: "ExploreCell")
        
        /** Create an instance of the flexible datasource make sure to pass here the collection view and cell identifier */
        datasource  = JMCFlexibleCollectionViewDataSource(collectionView: collectionView, cellIdentifier:"cell")
        
        //prepare items to display in the collection view
        var dataSourceItems = [JMCDataSourceItem]()
        
        for i in 0...8{
            let item = JMCDataSourceItem()
            item.image = UIImage(named: "r\(i).jpg")
            dataSourceItems.append(item)
        }
        
        //assign the items to the datasource
        datasource?.dataItems = dataSourceItems
        
        datasource?.maximumRowHeight = 320
        datasource?.margin = 10
        datasource?.spacing = 10
        
    }
    
    func prepareImagesFromUrlsArray( imageURLArray : [String]) {
        var images = [AnyObject]() /* capacity: imageURLArray.count */
        for i in 0..<imageURLArray.count {
            images.append(imageURLArray[i])
        }
        for i in 0..<imageURLArray.count {
            let urls = imageURLArray[i]
            let url = NSURL(string: urls)

            let request = NSURLRequest(URL:url!)
            let op = AFHTTPRequestOperation(request: request)
            op.responseSerializer = AFImageResponseSerializer()
            op.setCompletionBlockWithSuccess({ (operation : AFHTTPRequestOperation!, responseObject: AnyObject!) in
                let image = responseObject
                images[i] = image

                }, failure: { (operation : AFHTTPRequestOperation!, error:  NSError!) in
                    
            })
            op.start()
        }
    }
    
    func fetchExploreDataFromServer() {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["UserID"] = AppHelper.userDefaultsForKey(uId)
            
            //call global web service class
            Services.serviceCallWithPath(ServiceGetAllStories, withParam: parameters, success: { (responseDict) in
                
                print(responseDict)
                
                AppDelegate.dismissProgressHUD()
                //dissmiss indicator
                if ((responseDict["error"] as! Int) == 0) {
                    let items = responseDict["result"] as! [AnyObject]
                    
                    
                    self.dataArr = items.map({$0["latestArticleLogoUrl"]! as! String}) as [String]
                    self.prepareImagesFromUrlsArray(self.dataArr)
                    self.collectionView.reloadData()
                }
                else {
                    AppHelper.showAlertWithTitle(responseDict["errorMsg"] as! String, message: "", tag: 0, delegate: nil, cancelButton: "Ok", otherButton: nil)
                }
                
                }, failure: { (error) in
                    
                    AppDelegate.dismissProgressHUD()
                    //dissmiss indicator
                    AppHelper.showAlertWithTitle("", message: serviceError, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
            })
        }
        else {
            //show internet not available
            AppHelper.showAlertWithTitle(netError, message: netErrorMessage, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        //At this point all the views have their final dimensions so the size calculations will be accurate
        datasource?.setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
