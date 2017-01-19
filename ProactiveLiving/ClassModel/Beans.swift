//
//  Beans.swift
//  ProactiveLiving
//
//  Created by Affle on 12/01/2017.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit

@objc
class Beans: NSObject {
    
    
    
    @objc
        class UserDetails: NSObject, NSCoding{
        
       
        
        static var sharedInstance:UserDetails = UserDetails(userName: "", userId: "", imgUrl: "", imgCoverUrl: "", summary: "", gender: "", liveIn: "", workAt: "", grewUp: "", highSchool: "",  highSchoolSportsPlayed:"", college: "",  collegeSportsPlayed: "", graduateSchool: "", currentSport:"",  interest: "", favFamousQuote: "", notFamousQuote: "", bio: "")
        
        
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
        var highSchoolSportsPlayed:String = ""
        var collegeSportsPlayed:String = ""
        var graduateSchool:String = ""
        var currentSport:String = ""
        var interests:String = ""
        var favFamousQuote:String = ""
        var notFamousQuote:String = ""
        var bio:String = ""
        
//        private override init() {
//            super.init()
//        }
        
        init(userName:String, userId:String, imgUrl:String, imgCoverUrl:String, summary:String, gender:String, liveIn:String, workAt:String, grewUp:String, highSchool:String, highSchoolSportsPlayed:String, college:String,
             collegeSportsPlayed:String, graduateSchool:String, currentSport:String,interest:String,  favFamousQuote:String, notFamousQuote:String, bio:String  ) {
            
            self.userName = userName
            self.userID = userId
            self.imgUrl = imgUrl
            self.imgCoverUrl = imgCoverUrl
            self.summary = summary
            self.gender = gender
            self.liveIn = liveIn
            self.workAt = workAt
            self.grewUp = grewUp
            self.highSchool = highSchool
            self.college = college
            self.graduateSchool = graduateSchool
            self.highSchoolSportsPlayed = highSchoolSportsPlayed
            self.collegeSportsPlayed = collegeSportsPlayed
            self.currentSport = currentSport
            self.interests = interest
            self.favFamousQuote = favFamousQuote
            self.notFamousQuote = notFamousQuote
            self.bio = bio
            
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            
            userName = aDecoder.decodeObjectForKey("userName") as! String
            self.userID = aDecoder.decodeObjectForKey("userID") as! String
            self.imgUrl = aDecoder.decodeObjectForKey("imgUrl") as! String
            self.imgCoverUrl = aDecoder.decodeObjectForKey("imgCoverUrl") as! String
            self.summary = aDecoder.decodeObjectForKey("summary") as! String
            self.gender = aDecoder.decodeObjectForKey("gender") as! String
            self.liveIn = aDecoder.decodeObjectForKey("liveIn") as! String
            self.workAt = aDecoder.decodeObjectForKey("workAt") as! String
            self.grewUp = aDecoder.decodeObjectForKey("grewUp") as! String
            self.highSchool = aDecoder.decodeObjectForKey("highSchool") as! String
            self.college = aDecoder.decodeObjectForKey("college") as! String
            self.graduateSchool = aDecoder.decodeObjectForKey("graduateSchool") as! String
            self.highSchoolSportsPlayed = aDecoder.decodeObjectForKey("highSchoolSportsPlayed") as! String
            self.collegeSportsPlayed = aDecoder.decodeObjectForKey("collegeSportsPlayed") as! String
            self.interests = aDecoder.decodeObjectForKey("interests") as! String
            self.currentSport = aDecoder.decodeObjectForKey("currentSport") as! String
            self.favFamousQuote = aDecoder.decodeObjectForKey("favFamousQuote") as! String
            self.notFamousQuote = aDecoder.decodeObjectForKey("notFamousQuote") as! String
            self.bio = aDecoder.decodeObjectForKey("bio") as! String
        }
        
        func encodeWithCoder(aCoder: NSCoder) {
            aCoder.encodeObject(userName, forKey: "userName")
            aCoder.encodeObject(userID, forKey: "userID")
            aCoder.encodeObject(imgUrl, forKey: "imgUrl")
            aCoder.encodeObject(imgCoverUrl, forKey: "imgCoverUrl")
            aCoder.encodeObject(summary, forKey: "summary")
            aCoder.encodeObject(gender, forKey: "gender")
            
            aCoder.encodeObject(liveIn, forKey: "liveIn")
            aCoder.encodeObject(workAt, forKey: "workAt")
            aCoder.encodeObject(grewUp, forKey: "grewUp")
            aCoder.encodeObject(highSchool, forKey: "highSchool")
            aCoder.encodeObject(college, forKey: "college")
            aCoder.encodeObject(graduateSchool, forKey: "graduateSchool")
            aCoder.encodeObject(highSchoolSportsPlayed, forKey: "highSchoolSportsPlayed")
            aCoder.encodeObject(collegeSportsPlayed, forKey: "collegeSportsPlayed")
            aCoder.encodeObject(currentSport, forKey: "currentSport")
            aCoder.encodeObject(interests, forKey: "interests")
            aCoder.encodeObject(favFamousQuote, forKey: "favFamousQuote")
            aCoder.encodeObject(notFamousQuote, forKey: "notFamousQuote")
            aCoder.encodeObject(bio, forKey: "bio")
        }
        
        
    }

}
