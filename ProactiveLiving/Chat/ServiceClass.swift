//
//  ServiceClass.swift
//  OurLiveStreaming
//
//  Created by Saurabh Shukla on 10/8/15.
//  Copyright © 2015 Affle AppStudioz India Pvt Ltd. All rights reserved.
//

import UIKit

class ServiceClass: NSObject {
    
    
    class var sharedInstance: ServiceClass {
        struct Static {
            static var instance: ServiceClass?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = ServiceClass()
        }
        
        return Static.instance!
    }
    
    enum ResponseType : Int {
        case   kResponseTypeFail = 0
        case  kresponseTypeSuccess
    }
    
    typealias completionBlockType = (ResponseType,JSON, AnyObject!) ->Void
    var test:completionBlockType = {(type:ResponseType,parseData:JSON, response:AnyObject!) ->Void in
        
    }
    
    
    // AnyObject
    
    class func checkNetworkReachabilityWithoutAlert() ->Bool {
        if Reachability.reachabilityForInternetConnection()!.isReachable() {
            return true
        }else {
            return false
        }
    }
}
