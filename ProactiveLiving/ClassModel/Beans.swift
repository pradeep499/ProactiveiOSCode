//
//  Beans.swift
//  ProactiveLiving
//
//  Created by Affle on 12/01/2017.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit

class Beans: NSObject {
    
    class UserDetails: NSObject{
        
        static let sharedInstance:UserDetails = UserDetails()
        
        
        var userName:String = ""
        var userID:String = ""
        var imgUrl:String = ""
        var imgCoverUrl:String = ""
        var summary:String = ""
        var gender:String = ""
        var liveIn:String = ""
        var workAt:String = ""
        var grewUp:String = ""
        var highSchool:String = ""
        var college:String = ""
        var graduateSchool:String = ""
        var sportsPlayed:String = ""
        var intrests:String = ""
        var favFamousQuote:String = ""
        var notFamousQuote:String = ""
        var bio:String = ""
        
        private override init() {
            super.init()
        }
        
        
        
    }

}
