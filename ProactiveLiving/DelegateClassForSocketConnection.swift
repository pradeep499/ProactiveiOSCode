//
//  DelegateClassForSocketConnection.swift
//  ProactiveLiving
//
//  Created by appstudioz on 5/1/17.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit

class DelegateClassForSocketConnection: NSObject {

    
    class var sharedInstance: DelegateClassForSocketConnection {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: DelegateClassForSocketConnection? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = DelegateClassForSocketConnection()
        }
        return Static.instance!
    }
    
    
    
    
    

}
