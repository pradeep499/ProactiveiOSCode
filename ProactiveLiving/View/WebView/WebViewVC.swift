//
//  WebViewVC.swift
//  ProactiveLiving
//
//  Created by Affle on 04/11/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit

class WebViewVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var web_view: UIWebView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var pageName:String = "";
    var urlStr:String = "";
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      // self.urlStr = "https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=AIzaSyCofV_YsTjl-9lu2m4rOCj1bMmW4PS1Td0"
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        
        switch pageName {
        case "TERMSNPOLICIES":
            self.lblTitle.text = "Terms & Policies"
            self.performSelectorInBackground(#selector(self.getTermsNPolicyContentfromUrl), withObject: nil)
            break
        case "AboutUs":
            self.lblTitle.text = "AboutUs"
            self.performSelectorInBackground(#selector(self.loadUrlOnWebView), withObject: nil)
            break
        case "Broadcast":
            self.lblTitle.text = "Broadcast"
            self.performSelectorInBackground(#selector(self.loadUrlOnWebView), withObject: nil)
            break
        case "Explore":
            self.lblTitle.text = "Explore"
            self.performSelectorInBackground(#selector(self.loadUrlOnWebView), withObject: nil)
            break
        case "OrgProfile":
            self.lblTitle.text = "OrgProfile"
            self.performSelectorInBackground(#selector(self.loadUrlOnWebView), withObject: nil)
            break
        case "MeetUp":
            self.lblTitle.text = "MeetUp"
            self.performSelectorInBackground(#selector(self.loadUrlOnWebView), withObject: nil)
            break
        case "OrgDetailsLink":
            self.lblTitle.text = "OrgDetailsLink"
            self.performSelectorInBackground(#selector(self.loadUrlOnWebView), withObject: nil)
            break
        default:
            self.lblTitle.text = self.title
            self.performSelectorInBackground(#selector(self.loadUrlOnWebView), withObject: nil)
            break
        }
        
        //if (UIApplication.sharedApplication().canOpenURL(NSURL(string: "comgooglemaps://")!)) {
            //UIApplication.sharedApplication().openURL(NSURL(string:
              //  "comgooglemaps://?center=40.765819,-73.975866&zoom=14&views=traffic")!)
        //} else {
            //print_debug("Can't use comgooglemaps://");
        //}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onClickBackBtn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func getTermsNPolicyContentfromUrl() -> Void{
        self.indicator.startAnimating()
         
        let myURLString =  "http://52.23.211.77:3000/users/termsPolicy"
        guard let myURL = NSURL(string: myURLString) else {
            print_debug("Error: \(myURLString) doesn't seem to be a valid URL")
            return
        }
        
        do {
            let myHTMLString = try String(contentsOfURL: myURL)
            print_debug("HTML : \(myHTMLString)")
            
            let data = myHTMLString.dataUsingEncoding(NSUTF8StringEncoding)
            if let json  = try?NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers){
                print_debug(json)
                if let content = json["content"] as? String{
                    self.web_view.loadHTMLString(content, baseURL: nil)
                    
                }
                self.indicator.stopAnimating()
                self.indicator.hidden = true
                
            }
            
            
            
        } catch let error as NSError {
            print_debug("Error: \(error)")
            self.indicator.stopAnimating()
            self.indicator.hidden = true
        }
    }
    
    func loadUrlOnWebView() -> Void    {
        
        self.web_view.delegate = self
        let  webUrl:String
        if(urlStr.hasPrefix("http://") || urlStr.hasPrefix("https://")){
            webUrl = urlStr
        }
        else {
            webUrl = "http://" + urlStr
        }
        self.web_view.loadRequest(NSURLRequest(URL: NSURL(string: webUrl)!))
        
    }
    
}

extension WebViewVC:UIWebViewDelegate{
    func webViewDidStartLoad(webView: UIWebView) {
        self.indicator.startAnimating()
        self.indicator.hidden = false
    }
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.indicator.stopAnimating()
        self.indicator.hidden = true
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        self.indicator.stopAnimating()
        self.indicator.hidden = true
        
       //AppHelper.showAlertWithTitle(AppName, message: "Invalid url.", tag: 0, delegate: nil, cancelButton: "Ok", otherButton:nil  )
        //"<html><head></head><body><h5 align=\"center\" style=\"color:gray; font-family:roboto-light;\"><br><br><br><br><br><br><br><br><br><br>Server Error!<br><br>The page you are looking for cannot be found.</h5></body></html>"
        
//        let errorHTML = "<html><head></head><body><h4 align=\"center\"><br><br><br><br><br><br><br><br><br><br>Server Error!<br><br>The page you are looking for can not be found.</h4></body></html>"
//        
//        if (error.localizedDescription != "Plug-in handled load") {
//            webView.loadHTMLString(errorHTML, baseURL: nil)
//        } 
        
        
    }
    
    
    
}
