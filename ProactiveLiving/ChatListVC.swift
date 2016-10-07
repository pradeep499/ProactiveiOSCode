//
//  ChatListVC.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 01/07/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit

class ChatListVC: SOMessagingViewController {
    var partnerDict : Dictionary<String,AnyObject>?
    lazy var arrayChatList = [AnyObject]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getMessagesFromServer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
     #pragma mark- service calls
     -(void)getMessagesFromServer{
     //check internet before hitting web service
     if ([AppDelegate checkInternetConnection]) {
     
     //show indicator on screen
     [AppDelegate showProgressHUDWithStatus:@"Please wait.."];
     
     NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
     [parameters setValue:AppKey forKey:@"AppKey"];
     [parameters setValue:[AppHelper userDefaultsForKey:uId] forKey:@"UserID"];
     //[parameters setObject:@"9645454545" forKey:@"senderPhone"];
     [parameters setObject:[AppHelper userDefaultsForKey:cellNum] forKey:@"senderPhone"];
     [parameters setObject:[self.partnerDict[@"userDetails"] valueForKey:@"mobilePhone"] forKey:@"recieverPhone"];
     
     //call global web service class
     [Services serviceCallWithPath:ServiceGetMessages withParam:parameters success:^(NSDictionary *responseDict)
     {
     [AppDelegate dismissProgressHUD];//dissmiss indicator
     
     if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
     {
     if ([[responseDict objectForKey:@"error"] intValue] == 0) {
     //reverse chat array
     NSArray* reversedChatArray = [[[responseDict objectForKey:@"result"] reverseObjectEnumerator] allObjects];
     [self loadMessagesWithResponse:reversedChatArray];
     }
     else
     {
     [AppHelper showAlertWithTitle:[responseDict objectForKey:@"errorMsg"] message:@"" tag:0 delegate:nil cancelButton:ok otherButton:nil];
     }
     
     }
     else
     [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
     
     } failure:^(NSError *error)
     {
     [AppDelegate dismissProgressHUD];//dissmiss indicator
     [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
     }];
     
     }
     else
     //show internet not available
     [AppHelper showAlertWithTitle:netError message:netErrorMessage tag:0 delegate:nil cancelButton:ok otherButton:nil];
     }

    */
    //MARK:- service calls
    func getMessagesFromServer()  {
        //check internet before hitting web service
        if AppDelegate.checkInternetConnection() {
            
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            /*
             NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
             [parameters setValue:AppKey forKey:@"AppKey"];
             [parameters setValue:[AppHelper userDefaultsForKey:uId] forKey:@"UserID"];
             //[parameters setObject:@"9645454545" forKey:@"senderPhone"];
             [parameters setObject:[AppHelper userDefaultsForKey:cellNum] forKey:@"senderPhone"];
             [parameters setObject:[self.partnerDict[@"userDetails"] valueForKey:@"mobilePhone"] forKey:@"recieverPhone"];
             */
            
            var param : Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            param["AppKey"] = AppKey
            param["UserID"] = AppHelper.userDefaultsForKey(_ID)
            param["senderPhone"] = AppHelper.userDefaultsForKey(cellNum)
            param["recieverPhone"] = "9645454545"
            
            Services.serviceCallWithPath(ServiceGetMessages, withParam: param, success: { (responseDict) in
                
                print(responseDict)
                
                let errorCode = (responseDict!["error_code"] as? Int) ?? 0
                
                if errorCode == 0
                {
                    if let dictData : Dictionary<String, AnyObject>?  = responseDict as? Dictionary<String, AnyObject> where dictData != nil
                    {
                        if let data :[AnyObject]? = dictData!["result"] as? [AnyObject] where data != nil
                         {
                            self.arrayChatList = data!
                            print("arrayClassList \(self.arrayChatList)")


                         }
                    }
                    
                    AppHelper.showAlertWithTitle("", message:responseDict["errorMsg"] as? String, tag: 0, delegate: nil, cancelButton: "Ok", otherButton: nil)
                    
                }
                else
                {
                    AppHelper.showAlertWithTitle("", message:responseDict["errorMsg"] as? String, tag: 0, delegate: nil, cancelButton: "Ok", otherButton: nil)
                }
               
                }, failure: { (error) in
                    
                    print(error)
                    AppHelper.showAlertWithTitle("", message: serviceError, tag: 0, delegate: nil, cancelButton: "Ok", otherButton: nil)

            })
        }
    }
    
}
