//
//  HelpViewController.swift
//  ProactiveLiving
//
//  Created by Aseem Akarshan on 3/28/17.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController,MKMapViewDelegate {

//MARK:-  Outlets
    @IBOutlet weak var tableViewOutlet: UITableView!
    
//MARK:- Properties
    
    var strAddress = String()
    var strPhone   = String()
    var strMail = String()
    var lat = Double()
    var long = Double()
    var strUrl = String()
    
//MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

       // var region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 20000, 20000)
       // mapView.setRegion(region, animated: false)
        
        self.HelpService()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    //MARK:- Button Action
    @IBAction func backButtonAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK:- Service Hit
    
    func HelpService() {
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            
            parameters = ["type":"help"]
            
            //call global web service class latest
            Services.postRequest(ServiceGetPasInstruction, parameters: parameters, completionHandler:{
                (status,responseDict) in
                
                AppDelegate.dismissProgressHUD()
                
                if (status == "Success") {
                    
                    //dissmiss indicator
                    if ((responseDict["error"] as! Int) == 0) {
                        
                        print_debug("VALUE### \(responseDict)")
                        
                        let result = responseDict["result"]
                        
                        self.strPhone = result!["mobile"] as! String
                        self.strMail  = result!["email"] as! String
                        self.strAddress = result!["address"] as! String
                        self.strUrl = result!["faq"] as! String
                        
                        let location = result!["location"] as! [Double]
                        
                        self.lat =  location[0]
                        self.long = location[1]
                        self.tableViewOutlet.reloadData()  // table View reload
                       
                        
                        /*
                         
                         [error: 0, result: {
                         "_id" = 58da333bbebb718adceacb19;
                         address = "300 E 1st St, Greenville, NC 27858, USA";
                         email = "support@proactively.com";
                         faq = "http://www.proactivelivingusa.com/";
                         location =     (
                         "35.614362",
                         "-77.369276"
                         );
                         mobile = 2142188204;
                         type = help;
                         }, errorMsg: Record Found.]
                         
                         */
                        
                        
                        
                        
                        
                        
                        
                    } else {
                        
                        AppHelper.showAlertWithTitle(AppName, message: responseDict["errorMsg"] as! String, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    }
                    
                } else if (status == "Error"){
                    
                    AppHelper.showAlertWithTitle(AppName, message: serviceError, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    
                }
            })
            
        }
        else {
            AppDelegate.dismissProgressHUD()
            //show internet not available
            AppHelper.showAlertWithTitle(netError, message: netErrorMessage, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
        }
        
    }
    
    
    
    
}





//MARK:- UITableView DataSource

extension HelpViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
 
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell :UITableViewCell?
        
       
        
        if indexPath.row == 0 {                                             // FAQs redirection to webView
            cell = tableView.dequeueReusableCellWithIdentifier("FAQCell")
            
        }
        else if indexPath.row == 1 {                                        // Contact number
            cell = tableView.dequeueReusableCellWithIdentifier("CallUsCell")
            let lblNumber = cell?.viewWithTag(10) as! UILabel
            lblNumber.text = self.strPhone
            
        }
        else if indexPath.row == 2 {                                        // Email
            cell = tableView.dequeueReusableCellWithIdentifier("EmailUsCell")
            let lblEmail = cell?.viewWithTag(20) as! UILabel
            lblEmail.text = self.strMail
        }
        else{                                                                // Address and Map
            cell = tableView.dequeueReusableCellWithIdentifier("AddressCell")
            let lblAddress = cell?.viewWithTag(30) as! UILabel
            lblAddress.text = self.strAddress
            let map = cell?.viewWithTag(40) as! MKMapView
            
            // Set map view delegate with controller
            map.delegate = self
          //  let newYorkLocation = CLLocationCoordinate2DMake(40.730872, -74.003066)
            
            // Drop a pin
            let dropPin = MKPointAnnotation()
            let location = CLLocationCoordinate2D(
                latitude: self.lat,
                longitude: self.long
            )
            
            let span = MKCoordinateSpanMake(0.50, 0.50)
            let region = MKCoordinateRegion(center: location, span: span)
            map.setRegion(region, animated: true)
            dropPin.coordinate = location
            dropPin.title = "ProActive"
            map.addAnnotation(dropPin)
            
            
        }
        cell?.selectionStyle = .None
        
        return cell!
    }
    
}

//MARK:- UTTableView Delegate
extension HelpViewController :UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
          
            
            let WebVC:WebViewVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("WebViewVC") as! WebViewVC
            WebVC.title = "FAQs"
            if self.strUrl != "" {
                WebVC.urlStr = self.strUrl
                self.navigationController?.pushViewController(WebVC, animated: true)
            }

            
        }
        else if indexPath.row == 1 {
            
            let mobilePhone = self.strPhone
            if let phoneCallURL:NSURL = NSURL(string: "tel://\(mobilePhone)") {
                let application:UIApplication = UIApplication.sharedApplication()
                if (application.canOpenURL(phoneCallURL)) {
                    application.openURL(phoneCallURL)
                }
            }
            
            
        }
        else if indexPath.row == 2 {
           self.sendMail()
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        // Height for Address field (Map)
        if indexPath.row == 3 {
            
            return 200
            
        }
        else{
            return 60
        }
    }
    
    
}

//MARK:- MFMailComposeViewControllerDelegate
extension HelpViewController: MFMailComposeViewControllerDelegate {
   
    func sendMail() -> Void {
        
        if !MFMailComposeViewController.canSendMail() {
            print_debug("Mail services are not available")
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients([self.strMail])
        composeVC.setSubject("Help")
        
        let body = ""
            
        composeVC.setMessageBody(body , isHTML: true)
        
        // Present the view controller modally.
        self.presentViewController(composeVC, animated: true, completion: nil)
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}




