//
//  DataBaseController.swift
//  Yumcheck
//
//  Created by Mohd Arif Saifi on 9/17/14.
//  Copyright (c) 2014 Appstudioz. All rights reserved.
//

import Foundation
import CoreData
class DataBaseController : NSObject
{
     let appDelegate = AppDelegate.getAppDelegate()
    
    class var sharedInstance : DataBaseController
        {
    struct Static
    {
        static var onceToken : dispatch_once_t = 0
        static var instance : DataBaseController? = nil
        }
        dispatch_once(&Static.onceToken)
            {
                Static.instance = DataBaseController()
        }
        return Static.instance!
    }
  
    
    //MARK: Insert Phone Contact In Db
    func insertPhoneConatactData(modelName:String, params: Dictionary<String, AnyObject>)
    {
       
        let cdhObj = appDelegate.managedObjectContext
        
//        let newMoc = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
//        newMoc.parentContext = appDelegate.managedObjectContext
//        
//        
//        newMoc.performBlock {
//            
//            var exist:ContactList? = self.checkIfAlreadyExist(modelName, params: params)
//            if (exist != nil)
//            {
//                exist!.name = params["name"] as String
//                exist!.email = params["email"] as String
//                exist!.email1 = params["email1"] as String
//                exist!.email2 = params["email2"] as String
//                exist!.email3 = params["email3"] as String
//                exist!.recordId = params["recordId"] as String
//                exist!.phoneNumber = params["mobile"] as String
//                exist!.phoneNumber1 = params["mobile1"] as String
//                exist!.phoneNumber2 = params["mobile2"] as String
//                exist!.phoneNumber3 = params["mobile3"] as String
//                exist!.updateDate = params["date"] as NSDate
//                exist!.userImgString = params["imageStr"] as String
//                exist!.isRegistered = params["isRegister"] as String
//                exist!.isDelete = "Y"
//                //appDelegate.saveContext()
//                newMoc.save(nil)
//                
//            }
//            else
//            {
//                var newItem: ContactList = NSEntityDescription.insertNewObjectForEntityForName(modelName, inManagedObjectContext: cdhObj!) as ContactList
//                
//                newItem.name = params["name"] as String
//                newItem.email = params["email"] as String
//                newItem.email1 = params["email1"] as String
//                newItem.email2 = params["email2"] as String
//                newItem.email3 = params["email3"] as String
//                newItem.recordId = params["recordId"] as String
//                newItem.phoneNumber = params["mobile"] as String
//                newItem.phoneNumber1 = params["mobile1"] as String
//                newItem.phoneNumber2 = params["mobile2"] as String
//                newItem.phoneNumber3 = params["mobile3"] as String
//                newItem.updateDate = params["date"] as NSDate!
//                newItem.userImgString = params["imageStr"] as String
//                newItem.isRegistered = params["isRegister"] as String
//                newItem.isDelete = "N"
//                //appDelegate.saveContext()
//                newMoc.save(nil)
//            }
//        
        
        
        
        
        
        let exist:ContactList? = checkIfAlreadyExist(modelName, params: params)
        if (exist != nil)
        {
            exist!.name = params["name"] as? String
            exist!.email = params["email"] as? String
            exist!.email1 = params["email1"] as? String
            exist!.email2 = params["email2"] as? String
            exist!.email3 = params["email3"] as? String
            exist!.recordId = params["recordId"]as? String
            exist!.phoneNumber = params["mobile"] as? String
            exist!.phoneNumber1 = params["mobile1"] as? String
            exist!.phoneNumber2 = params["mobile2"] as? String
            exist!.phoneNumber3 = params["mobile3"] as? String
            exist!.updateDate = params["date"] as? NSDate
            exist!.userImgString = params["imageStr"] as! String!
            exist!.isRegistered = params["isRegister"] as! String!
            exist!.isDelete = "Y"
            appDelegate.saveContext()
            
        }
        else
        {
            let newItem: ContactList = NSEntityDescription.insertNewObjectForEntityForName(modelName, inManagedObjectContext: cdhObj) as! ContactList
            
            newItem.name = params["name"] as? String
            newItem.email = params["email"] as? String
            newItem.email1 = params["email1"] as? String
            newItem.email2 = params["email2"] as? String
            newItem.email3 = params["email3"] as? String
            newItem.recordId = params["recordId"] as? String
            newItem.phoneNumber = params["mobile"] as? String
            newItem.phoneNumber1 = params["mobile1"] as? String
            newItem.phoneNumber2 = params["mobile2"] as? String
            newItem.phoneNumber3 = params["mobile3"] as? String
            newItem.updateDate = params["date"] as? NSDate
             newItem.userImgString = params["imageStr"] as? String
             newItem.isRegistered = params["isRegister"] as? String
            newItem.isDelete = "N"
            appDelegate.saveContext()
        }
        //}
    }
   
    func checkIfAlreadyExist(modelName:String, params: Dictionary<String, AnyObject>) -> ContactList!
    {
        let instance = DataBaseController.sharedInstance
        let str1:String = params["recordId"] as! String
        let str:String = "recordId LIKE \"\(str1)\""
        
        var fetchResult=instance.fetchData(modelName,predicate:str,sort:(nil,false))!
        
        if !fetchResult.isEmpty
        {
            return fetchResult[0] as! ContactList
        }
        else
        {
            return nil
        }
    }
    
    
    //MARK: Insert App Contact In Db
    func insertAppContactData(modelName:String, params: Dictionary<String, AnyObject>)
    {
        let cdhObj = appDelegate.managedObjectContext
        
//        var dateStr = params["ModifiedDate"] as String
//        //let now : String = "2014-07-16 03:03:34 PDT"
//        var date : NSDate
//        var dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
//        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
//        date = dateFormatter.dateFromString(dateStr)!
//        //print(date)
        
        let exist:AppContactList? = checkIfAppContAlreadyExist(modelName, params: params)
        if (exist != nil)
        {
            exist!.name = params["phoneName"] as? String
            exist!.phoneName = params["name"] as? String
            //exist!.email = params["email"] as String
            //exist!.updateDate = params["ModifiedDate"] as String
            exist!.userId = params["userId"] as? String
            exist!.phoneNumber = params["mobile"] as? String
            exist!.isFriend = params["isFriend"] as? String
            exist!.userImgString = params["imageStr"] as? String
            exist!.recordId = params["recordId"] as? String
            exist!.loginUserId = ChatHelper .userDefaultForAny("userId") as? String
            exist!.isFromCont = "1"
            appDelegate.saveContext()
            
        }
        else
        {
            let newItem: AppContactList = NSEntityDescription.insertNewObjectForEntityForName(modelName, inManagedObjectContext: cdhObj) as! AppContactList
            
            newItem.name = params["phoneName"] as? String
            newItem.phoneName = params["name"] as? String
           // newItem.recordId = params["recordId"] as String
            //newItem.updateDate = params["ModifiedDate"] as String
            newItem.userId = params["userId"] as? String
            newItem.phoneNumber = params["mobile"] as? String
            newItem.isFriend = params["isFriend"] as? String
            newItem.userImgString = params["imageStr"] as? String
            newItem.recordId = params["recordId"] as? String

            newItem.loginUserId = ChatHelper .userDefaultForAny("userId") as? String
            
            newItem.isFav = "0"
            newItem.isFromCont = "1"
            newItem.isFromFB = "0"
            appDelegate.saveContext()
        }
    }
    
    
    //MARK: Insert Fb Contact In Db
    func insertFbContactData(modelName:String, params: Dictionary<String, AnyObject>)
    {
        let cdhObj = appDelegate.managedObjectContext
        
        let exist:AppContactList? = checkIfAppContAlreadyExist(modelName, params: params)
     
        if (exist != nil)
        {
            //exist!.name = params["name"] as String
            exist!.phoneName = params["phoneName"] as? String
            exist!.userId = params["userId"] as? String
            exist!.phoneNumber = params["mobile"] as? String
            exist!.isFriend = params["isFriend"] as? String
            exist!.userImgString = params["imageStr"] as? String
            exist!.loginUserId = ChatHelper .userDefaultForAny("userId") as? String
            exist!.isFromFB = "1"
            appDelegate.saveContext()
            
        }
        else
        {
            
            let newItem: AppContactList = NSEntityDescription.insertNewObjectForEntityForName(modelName, inManagedObjectContext: cdhObj) as! AppContactList
            
            newItem.name = params["name"] as? String
            newItem.phoneName = params["phoneName"] as? String
            newItem.userId = params["userId"] as? String
            newItem.phoneNumber = params["mobile"] as? String
            newItem.isFriend = params["isFriend"] as? String
            newItem.userImgString = params["imageStr"] as? String
            newItem.loginUserId = ChatHelper .userDefaultForAny("userId") as? String
            newItem.isFav = "0"
            newItem.isFromFB = "1"
            
            appDelegate.saveContext()
        }
    }
    
    func checkIfAppContAlreadyExist(modelName:String, params: Dictionary<String, AnyObject>) -> AppContactList!
    {
        let instance = DataBaseController.sharedInstance
        let str1:String = params["userId"] as! String
        let str:String = "userId == \"\(str1)\""
        
        var fetchResult=instance.fetchData(modelName,predicate:str,sort:(nil,false))!
        
        if !fetchResult.isEmpty
        {
            return fetchResult[0] as! AppContactList
        }
        else
        {
            return nil
        }
    }

    
    
    //MARK:- Insert Reminder in DB
    func insertReminderData(modelName:String, params: Dictionary<String, AnyObject>)
    {
        let cdhObj = appDelegate.managedObjectContext
        
        
        let exist:Reminder? = checkIfReminderAlreadyExist(modelName, params: params)
        if (exist != nil)
        {
            exist!.eventTitle = params["eventId"] as? String
            exist!.eventTitle = params["eventTitle"] as? String
            exist!.reminder_Time = params["reminder_Time"] as? NSDate
            
            appDelegate.saveContext()
            
        }
        else
        {
            let newItem: Reminder = NSEntityDescription.insertNewObjectForEntityForName(modelName, inManagedObjectContext: cdhObj) as! Reminder
            
            newItem.eventId = params["eventId"] as? String
            newItem.eventTitle = params["eventTitle"] as?String
            newItem.reminder_Time = params["reminder_Time"] as? NSDate
            
            appDelegate.saveContext()
        }
    }
    
    
    func checkIfReminderAlreadyExist(modelName:String, params: Dictionary<String, AnyObject>) -> Reminder!
    {
        ////print(params)
        if(params["eventId"] != nil)
        {
            let instance = DataBaseController.sharedInstance
            let str1:NSDate = params["reminder_Time"] as! NSDate
            let str:String = "reminder_Time LIKE \"\(str1)\""
            
            var fetchResult=instance.fetchData(modelName,predicate:str,sort:(nil,false))!
            
            if !fetchResult.isEmpty
            {
                return fetchResult[0] as! Reminder
            }
            else
            {
                return nil
            }
        }
        else
        {
            return nil
        }
    }

    
    // MARK: Fetch
    func fetchData(modelName:String) -> [AnyObject]?
    {
        let cdhObj = appDelegate.managedObjectContext
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: modelName)
        var list = [AnyObject]()
        
        do {
             list = try cdhObj.executeFetchRequest(fReq)
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        return list
    }
    
    
    
    func fetchData(modelName:String, predicate:String?, sort:(sortkey:String?,isAscending:Bool)) -> [AnyObject]?
    {
        let cdhObj = appDelegate.managedObjectContext
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: modelName)
        
        //Check whether predicate is there
        if (predicate != nil)
        {
            fReq.predicate = NSPredicate(format:predicate!)
        }
        
        //Check whether sorting is to be applied
        if (sort.sortkey != nil)
        {
            let sorter: NSSortDescriptor = NSSortDescriptor(key: sort.sortkey! , ascending: sort.isAscending)
            fReq.sortDescriptors = [sorter]
            fReq.returnsObjectsAsFaults = false
        }
        var list = [AnyObject]()
        
        do {
            list = try cdhObj.executeFetchRequest(fReq)
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        return list
        
    }
    func fetchDataWithSorting(modelName:String, predicate:String?, sort:(sortkey:String?,isAscending:Bool),sort2:(sortkey:String?,isAscending:Bool)) -> [AnyObject]?
    {
        let cdhObj = appDelegate.managedObjectContext
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: modelName)
        
        //Check whether predicate is there
        if (predicate != nil)
        {
            fReq.predicate = NSPredicate(format:predicate!)
        }
        
        
       
        
        //Check whether sorting is to be applied
        if (sort.sortkey != nil)
        {
            let sorter: NSSortDescriptor = NSSortDescriptor(key: sort.sortkey! , ascending: sort.isAscending)
            
            if(sort2.sortkey != nil)
            {
                 let sorter1: NSSortDescriptor = NSSortDescriptor(key: sort2.sortkey! , ascending: sort2.isAscending)
            fReq.sortDescriptors = [sorter,sorter1]
            fReq.returnsObjectsAsFaults = false
            }
            else
            {
                fReq.sortDescriptors = [sorter]
                fReq.returnsObjectsAsFaults = false
            }
        }
        
        var list = [AnyObject]()
        
        do {
            list = try cdhObj.executeFetchRequest(fReq)
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        return list
        
    }
    
    func fetchLattestData(modelName:String, predicate:String?, sort:(sortkey:String?,isAscending:Bool)) ->  AppContactList!
    {
        let cdhObj = appDelegate.managedObjectContext
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: modelName)
        
        //Check whether predicate is there
        if (predicate != nil)
        {
            fReq.predicate = NSPredicate(format:predicate!)
        }
        //Check whether sorting is to be applied
        if (sort.sortkey != nil)
        {
            let sorter: NSSortDescriptor = NSSortDescriptor(key: sort.sortkey! , ascending: sort.isAscending)
            fReq.sortDescriptors = [sorter]
            fReq.returnsObjectsAsFaults = false
        }
        
        var list = [AnyObject]()
        
        do {
            list = try cdhObj.executeFetchRequest(fReq)
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        if !list.isEmpty
        {
            return list[0] as!  AppContactList
        }
        else
        {
            return nil
        }
        
        
        
    }

    func fetchUnreadCount()-> NSInteger
    {
        var unreadcount:Int = 0
        let instance = DataBaseController.sharedInstance
        let fetchResult=instance.fetchData("RecentChatList")!
        
        if fetchResult.count > 0
        {
            for myobject : AnyObject in fetchResult
            {
               // print("fetchrrsult=\(fetchResult)")
                let anObject = myobject as! RecentChatList
              //  print("fetchrrsult=\(anObject.notificationCount)")

                if anObject.notificationCount == "0"
                {
                    // print("true");
                }
                else
                {
                    unreadcount = unreadcount + Int(anObject.notificationCount!)!
                    
                }
            }
        }
      //  print("UnreadCount=\(unreadcount)")
       
        return unreadcount
    }
    
    // MARK:- Delete
    
    
    func deleteEverything() {
        
        let mainContext = appDelegate.managedObjectContext
        let workerContext = NSManagedObjectContext(parentContext: mainContext, concurrencyType: .PrivateQueueConcurrencyType)
        
        workerContext.performBlock {
            var error: NSError?
            workerContext.deleteAllObjects(&error)
            
            if error == nil {
                mainContext.performBlockAndWait {
                    
                    do {
                        
                        try mainContext.save()
                        // success ...
                    } catch let error as NSError {
                        // failure
                        print("Fetch failed: \(error.localizedDescription)")
                    }
           //
                }
            }
            
            if let error = error {
                print("Error deleting all objects: \(error)")
            }
        }
    }
    
    func deleteAllData(modelName:String) -> Bool
    {
        let cdhObj = appDelegate.managedObjectContext
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: modelName)
        
        var list = [AnyObject]()
        do {
            list = try cdhObj.executeFetchRequest(fReq)
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        for resultItem in list
        {
            let countryItem: AnyObject = resultItem
            cdhObj.deleteObject(countryItem as! NSManagedObject)
        }
        appDelegate.saveContext()
        
        return true
        
        
        
    }
    
    
    func deleteData1(modelName:String, predicate:String?)-> Bool
    {

        let cdhObj = appDelegate.managedObjectContext
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: modelName)
        
        //Check whether predicate is there
        if (predicate != nil)
        {
            fReq.predicate = NSPredicate(format:predicate!)
        }
        
        var result = [AnyObject]()
        
        do {
            result = try cdhObj.executeFetchRequest(fReq)
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        for resultItem in result
        {
            let countryItem: AnyObject = resultItem
            
            if countryItem.isRegistered != nil && countryItem.isRegistered == "1"
            {
                let delete:String! = countryItem.phoneNumber
                let str2:String = "phoneNumber contains[cd] \"\(delete)\""
                //print(str2)
                self.deleteData("AppContactList", predicate: str2)
            }
            cdhObj.deleteObject(countryItem as! NSManagedObject)
        }
        appDelegate.saveContext()
        
        return true
    }
    
    func deleteData(modelName:String, predicate:String?)-> Bool
    {
        
        let cdhObj = appDelegate.managedObjectContext
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: modelName)
        
        //Check whether predicate is there
        if (predicate != nil)
        {
            fReq.predicate = NSPredicate(format:predicate!)
        }
        
        var result = [AnyObject]()
        
        do {
            result = try cdhObj.executeFetchRequest(fReq)
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        for resultItem in result
        {
            let countryItem: AnyObject = resultItem
            cdhObj.deleteObject(countryItem as! NSManagedObject)
        }
        appDelegate.saveContext()
        
        return true
        
        
    }
    
    func delete_Outdated_Reminder(modelName:String, predicate:String?)-> Bool
    {
        let cdhObj = appDelegate.managedObjectContext
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: modelName)
        
        //Check whether predicate is there
        if (predicate != nil)
        {
        fReq.predicate = NSPredicate(format:predicate!)
        }
        
        var result = [AnyObject]()
        
        do {
            result = try cdhObj.executeFetchRequest(fReq)
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        for resultItem in result
        {
        let countryItem: AnyObject = resultItem
        cdhObj.deleteObject(countryItem as! NSManagedObject)
        }
        appDelegate.saveContext()
        
        return true
    }
    
//    func clearDatabase()
//    {
//        var storeCoordinator:NSPersistentStoreCoordinator = /* Your already existing NSPersistantStoreCoordinator */
//        var store:NSPersistentStore = storeCoordinator.persistantStores[0] as NSPersistantStore
//        var storeURL:NSURL = store.URL
//        storeCoordinator.removePersistentStore(store, error: nil)
//        NSFileManager.defaultManager().removeItemAtPath(storeURL.path, error: nil)
//    }
    //MARK:- Update Methods
    func updateValue(obj: AppContactList , str: String) -> Void
    {
        obj.isFriend=str
        appDelegate.saveContext()
    }
    
    func updateFavValue(obj: AppContactList , str: String) -> Void
    {
        obj.isFav=str
        appDelegate.saveContext()
    }

       
    func updateAppContObj1(modelName:String, params: Dictionary<String, AnyObject>)
    {
        _ = appDelegate.managedObjectContext
        
        let exist:AppContactList? = checkIfAppContAlreadyExist(modelName, params: params)
        if (exist != nil)
        {
            exist!.isFriend = params["isFriend"] as? String
            appDelegate.saveContext()
        }
    }
    
    func updatePhoneCont(modelName:String, params: Dictionary<String, AnyObject>)
    {
        _ = appDelegate.managedObjectContext
        
        let exist:ContactList? = checkIfAlreadyExist(modelName, params: params)
        if (exist != nil)
        {
            exist!.isDelete = "Y"
            appDelegate.saveContext()
        }
    }
    
    
    func updatePhoneContValue(obj: ContactList) -> Void
    {
        obj.isDelete="N"
        appDelegate.saveContext()
    }

    
    
  /*  func updateOnKey(modelName:String, Key:String, params:Dictionary<String, String>)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let cdhObj = appDelegate.managedObjectContext
        
        var exist:CountriesList? = checkIfAlreadyExist(modelName, params: params)
        if (exist != nil)
        {
            exist!.country = params["country"]!
            exist!.iSDCode = params["ISDCode"]!
            exist!.iSOCode = params["ISOCode"]!
            exist!.currency = params["currency"]!
            // newItem.amtForHundredCredits = params["amtForHundredCredits"] as String
            exist!.priceCategory = params["priceCategory"]!
            
            appDelegate.saveContext()
            
        }
    }*/
    
    
    
    
    func insertRecentChatData1(modelName:String, params: Dictionary<String, AnyObject>)
    {
        let cdhObj = appDelegate.managedObjectContext
       // print("for recent chat insertRecentChatData1 ")
        
       // print(params)
        //old code
        let exist:RecentChatList! = checkIfChatUserAlreadyExist1(modelName, params: params)
        if (exist != nil)
        {
           // print("for recent chat insertRecentChatData1 exist")

            //exist!.friendName = params["name"] as String
            exist!.friendId = params["friendId"] as? String
            
            exist!.friendName = params["name"] as? String
            
            if (params["user_firstName"] as? String) != nil
            {
                exist.friendName  = params["user_firstName"] as? String
            }
            
            if (params["imageStr"] as? String) != nil
            {
                exist.friendImageUrl  = params["imageStr"] as? String
            }
            else {
                exist.friendImageUrl  = ""
            }
            
            
            if let imgStr1: String = params["profile_image"] as? String
            {
                if !imgStr1.isEmpty{
                    
                    //check is with http or not
                    let string = imgStr1
                    if (string.lowercaseString.rangeOfString("http://") != nil || string.lowercaseString.rangeOfString("https://") != nil ) {
                        // print("exists")
                        exist!.friendImageUrl = params["profile_image"] as? String
                    }
                    else
                    {
                        exist!.friendImageUrl = "http://api.mymeldr.com/upload/profile/image/" + imgStr1
                    }
                }
            }
            
            exist!.loginUserId = ChatHelper .userDefaultForAny("userId") as? String
            exist!.lastMessage = params["message"] as? String
            exist!.lastMessageTime = params["messageTime"] as? String
            
            //            let imgStr: String = params["imageStr"] as String
            //            if !imgStr.isEmpty{
            //                exist!.friendImageUrl = params["imageStr"] as String
            //            }
            
            exist!.isNameAvail = params["isNameAvail"] as? String
            if (NSUserDefaults.standardUserDefaults().stringForKey("friendId")) != nil
            {
                if ChatHelper .userDefaultForAny("friendId") as! String == params["friendId"] as! String
                {
                    exist!.notificationCount = "0"
                }else
                {
                    let strCount: String = exist!.notificationCount!
                    //print(strCount)
                    var count : Int = Int(strCount)!
                    //print(count)
                    count = count + 1
                    exist!.notificationCount =  "\(count)"
                    //print(exist!.notificationCount)
                }
            }else
            {
                let strCount: String = exist!.notificationCount!
                //print(strCount)
                var count : Int = Int(strCount)!
                //print(count)
                count = count + 1
                exist!.notificationCount =  "\(count)"
                //print(exist!.notificationCount)
            }
            
            appDelegate.saveContext()
            
        }
        else
        {
            
            let newItem: RecentChatList = NSEntityDescription.insertNewObjectForEntityForName(modelName, inManagedObjectContext: cdhObj) as! RecentChatList
           // print("for recent chat insertRecentChatData1 newItem")

            newItem.friendName = params["name"] as? String
            newItem.friendId = params["friendId"] as? String
            newItem.loginUserId = ChatHelper .userDefaultForAny("userId") as? String
            newItem.lastMessage = params["message"] as? String
            newItem.lastMessageTime = params["messageTime"] as? String
            
            if  (params["imageStr"] as? String) != nil
            {
                newItem.friendImageUrl = params["imageStr"] as? String
            }
            
            newItem.isTyping = "0"
            newItem.isNameAvail = params["isNameAvail"] as? String
            
            //new code by pk 14 dec 2015
            
            
            if (params["user_firstName"] as? String) != nil
            {
                newItem.friendName  = params["user_firstName"] as? String
            }
            if (params["profile_image"] as? String) != nil
            {
                newItem.friendImageUrl  = params["profile_image"] as? String
            }
            //print(newItem)
            
            if (NSUserDefaults.standardUserDefaults().stringForKey("friendId")) != nil
            {
                if ChatHelper .userDefaultForAny("friendId") as! String == params["friendId"] as! String
                {
                    newItem.notificationCount = "0"
                }else
                {
                    newItem.notificationCount = "1"
                }
            }else
            {
                newItem.notificationCount = "1"
            }
            appDelegate.saveContext()
        }
    }
    
    func insertRecentChatDataFromFlirt(modelName:String, params: Dictionary<String, AnyObject>) -> RecentChatList!
    {
        //print("for recent chat")
        //print(params)
        let cdhObj = appDelegate.managedObjectContext
        
        let exist:RecentChatList? = checkIfChatUserAlreadyExist1(modelName, params: params)
        if (exist != nil)
        {
            //exist!.friendName = params["name"] as String
            exist!.friendName = params["user_firstName"] as? String
            exist!.friendId = params["friendId"] as? String
            exist!.loginUserId = ChatHelper .userDefaultForAny("userId") as? String
            exist!.lastMessage = params["message"] as? String
            exist!.lastMessageTime = params["messageTime"] as? String
          //  exist!.friendImageUrl = params["imageStr"] as String
            if (params["profile_image"] as? String) != nil
            {
                exist!.friendImageUrl  = params["profile_image"] as? String
            }
            exist!.isNameAvail = params["isNameAvail"] as? String
            
            appDelegate.saveContext()
             return exist
        }
        else
        {
            let newItem: RecentChatList = NSEntityDescription.insertNewObjectForEntityForName(modelName, inManagedObjectContext: cdhObj) as! RecentChatList
            
         //   newItem.friendName = params["name"] as String
            
            newItem.friendName = params["user_firstName"] as? String
            
            newItem.friendId = params["friendId"] as? String
            newItem.loginUserId = ChatHelper .userDefaultForAny("userId") as? String
            newItem.lastMessage = params["message"] as? String
            newItem.lastMessageTime = params["messageTime"] as? String
            //newItem.friendImageUrl = params["imageStr"] as String
            // change by pk
            if (params["profile_image"] as? String) != nil
            {
                newItem.friendImageUrl  = params["profile_image"] as? String
            }
            newItem.isTyping = "0"
            newItem.isNameAvail = params["isNameAvail"] as? String
            //print(newItem)
           
            appDelegate.saveContext()
            return newItem
        }
    }
    func checkIfChatUserAlreadyExist1(modelName:String, params: Dictionary<String, AnyObject>) -> RecentChatList!
    {
      //  print(params)
        
        
        let instance = DataBaseController.sharedInstance
        let str1:String = params["friendId"] as! String
        let str2:String = ChatHelper .userDefaultForAny("userId") as! String
        //let str:String = "userId LIKE \"\(str1)\""
        let str:String = "friendId contains[cd] \"\(str1)\" AND  loginUserId contains[cd] \"\(str2)\""
        
        var fetchResult=instance.fetchData(modelName,predicate:str,sort:(nil,false))!
        
        if !fetchResult.isEmpty
        {
            return fetchResult[0] as! RecentChatList
        }
        else
        {
            return nil
        }
    }
    
    func updateBlockUserEntry(modelName:String, predicate:String?, blockStaus:String?, blockID:String?) -> Void
    {
        _ = appDelegate.managedObjectContext
        
       // let  fReq: NSFetchRequest = NSFetchRequest(entityName: modelName)
        
        var params = Dictionary<String, AnyObject>()
        
        params["friendId"] = blockID

        //Check whether predicate is there
        
        let exist:RecentChatList? = checkIfChatUserAlreadyExist1(modelName, params: params)
        if (exist != nil)
        {
            exist!.friendId = blockID!
            exist!.loginUserId = ChatHelper .userDefaultForAny("userId") as? String
            exist!.isBlock = blockStaus!
            appDelegate.saveContext()
        
        }
   

    }
    func updateRecentChatObj1(obj: RecentChatList, msg: String, time: String) -> Void
    {
        obj.lastMessage=msg
        obj.lastMessageTime=time
        appDelegate.saveContext()
    }
    
    func fetchDataRecentChatObject(modelName:String, predicate:String?) -> RecentChatList?
    {
        let cdhObj = appDelegate.managedObjectContext
        
        let  fReq: NSFetchRequest = NSFetchRequest(entityName: modelName)
        
        //Check whether predicate is there
        if (predicate != nil)
        {
            fReq.predicate = NSPredicate(format:predicate!)
        }
        
        var result = [AnyObject]()
        
        do {
            result = try cdhObj.executeFetchRequest(fReq)
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        if !result.isEmpty
        {
            return result[0] as?  RecentChatList
        }
        else
        {
            return nil
        }
    }
    
    func fetchDataAppContObject(modelName:String, predicate:String?) -> AppContactList?
    {
        let cdhObj = appDelegate.managedObjectContext
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: modelName)
        
        //Check whether predicate is there
        if (predicate != nil)
        {
            fReq.predicate = NSPredicate(format:predicate!)
        }
        
        var result = [AnyObject]()
        
        do {
            result = try cdhObj.executeFetchRequest(fReq)
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        if !result.isEmpty
        {
            return result[0] as?  AppContactList
        }
        else
        {
            return nil
        }
    }
    
    func fetchLattestData(modelName:String, predicate:String?, sort:(sortkey:String?,isAscending:Bool)) ->  [AnyObject]?
    {
        let cdhObj = appDelegate.managedObjectContext
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: modelName)
        fReq.fetchLimit = 1
        //Check whether predicate is there
        if (predicate != nil)
        {
            fReq.predicate = NSPredicate(format:predicate!)
        }
        //Check whether sorting is to be applied
        if (sort.sortkey != nil)
        {
            let sorter: NSSortDescriptor = NSSortDescriptor(key: sort.sortkey! , ascending: sort.isAscending)
            fReq.sortDescriptors = [sorter]
            fReq.returnsObjectsAsFaults = false
        }
        
        var result = [AnyObject]()
        
        do {
            result = try cdhObj.executeFetchRequest(fReq)
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        return result
        //        if !result.isEmpty
        //        {
        //            return result[0] as  UserChat
        //        }
        //        else
        //        {
        //            return nil
        //        }
        
        
        
    }
    
    //MARK: Chat Contrller
    
    func fetchChatData(modelName:String, predicate:String?, sort:(sortkey:String?,isAscending:Bool)) -> [AnyObject]?
    {
        let cdhObj = appDelegate.managedObjectContext
        
        let  fReq: NSFetchRequest = NSFetchRequest(entityName: modelName)
        fReq.fetchLimit = 30
        //Check whether sorting is to be applied
        if (sort.sortkey != nil)
        {
            let  sorter: NSSortDescriptor = NSSortDescriptor(key: sort.sortkey! , ascending: sort.isAscending)
            fReq.sortDescriptors = [sorter]
            fReq.returnsObjectsAsFaults = false
        }
        //Check whether predicate is there
        if (predicate != nil)
        {
            fReq.predicate = NSPredicate(format:predicate!)
        }
        
        var result = [AnyObject]()
        
        do {
            result = try cdhObj.executeFetchRequest(fReq)
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        return result
        
    }
    func fetchNextChatData(modelName:String, predicate:String?, sort:(sortkey:String?,isAscending:Bool), messageCount:Int) -> [AnyObject]?
    {
        let cdhObj = appDelegate.managedObjectContext
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: modelName)
        fReq.fetchLimit = messageCount + 10
        //Check whether sorting is to be applied
        if (sort.sortkey != nil)
        {
            let sorter: NSSortDescriptor = NSSortDescriptor(key: sort.sortkey! , ascending: sort.isAscending)
            fReq.sortDescriptors = [sorter]
            fReq.returnsObjectsAsFaults = false
        }
        //Check whether predicate is there
        if (predicate != nil)
        {
            fReq.predicate = NSPredicate(format:predicate!)
        }
        var result = [AnyObject]()
        
        do {
            result = try cdhObj.executeFetchRequest(fReq)
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        return result
        
    }

    func fetchChatDataCount(modelName:String, predicate:String?) -> Int
    {
        let cdhObj = appDelegate.managedObjectContext
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: modelName)
 
        //Check whether predicate is there
        if (predicate != nil)
        {
            fReq.predicate = NSPredicate(format:predicate!)
        }
        var result = [AnyObject]()
        
        do {
            result = try cdhObj.executeFetchRequest(fReq)
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        return result.count
        
    }
    
    func insertChatMessageInDb(modelName:String, params: Dictionary<String, AnyObject>)->UserChat!
    {
      //  print(params)
      //  print("insertChatMessageInDb->UserChat")
        

        
        
        let chatObj = appDelegate.managedObjectContext
        
        let exist:UserChat? = checkIfChatMsgAlreadyExist(modelName, params: params)
        if (exist != nil)
        {
            
            exist!.messageStatus = params["status"] as? String
            exist!.modifiedDate = params["modifiedDate"] as? String
            
            appDelegate.saveContext()
            return exist
        }
        else
        {
            
            let newItem: UserChat = NSEntityDescription.insertNewObjectForEntityForName(modelName, inManagedObjectContext: chatObj) as! UserChat
            if params["type"] as! String == "text"
            {
                newItem.message = params["message"] as? String
            }
            else
            {
                newItem.message=""
            }
            newItem.messageType = params["type"] as? String
            
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
            dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
            let str = params["date"] as! String?
            let date1 = dateFormatter.dateFromString(str!)
            let dateStr = dateFormatter.stringFromDate(date1!)
            
            newItem.messageDate = dateStr as String
            newItem.localSortID = CommonMethodFunctions.nextChatIdentifies()
            //newItem.sortDate = dateStr as String
            newItem.messageTime = params["time"] as? String
            newItem.receiverId = params["receiver"] as? String
            newItem.senderId = params["sender"] as? String
            newItem.messageId = params["messageId"] as? String
            newItem.messageStatus = params["status"] as? String
            newItem.modifiedDate = params["modifiedDate"] as? String
            //newItem.locMessageId = params["localmsgid"] as String
     
            
            newItem.loginUserId = ChatHelper .userDefaultForAny("userId") as? String
            
            
            appDelegate.saveContext()
            return newItem
        }
    }
    func updateSenderChatMessageInDb(modelName:String, params: Dictionary<String, AnyObject>)->UserChat!
    {
        //print(params)

        
        let exist:UserChat? = checkIfSenderChatMsgAlreadyExist(modelName, params: params)
        if (exist != nil)
        {
            exist!.messageId = params["messageId"] as? String
            exist!.messageStatus = params["status"] as? String
            exist!.modifiedDate = params["modifiedDate"] as? String
            
            appDelegate.saveContext()
            return exist
        }
        return exist
    }
    func updateSenderGroupChatMessageInDb(modelName:String, params: Dictionary<String, AnyObject>)->GroupChat!
    {
        //print(params)
        _ = appDelegate.managedObjectContext
        
        let exist:GroupChat? = checkIfSenderGroupChatMsgAlreadyExist(modelName, params: params)
        if (exist != nil)
        {
            exist!.messageId = params["messageId"] as? String
            exist!.messageStatus = params["status"] as? String
            exist!.modifiedDate = params["modifiedDate"] as? String
            
            appDelegate.saveContext()
            return exist
        }
        return exist
    }
    func insertChatMessageInDb1(modelName:String, params: Dictionary<String, AnyObject>)->UserChat!
    {
      //  print(params)
        
        // print(insertChatMessageInDb1)
        
        let chatObj = appDelegate.managedObjectContext
        
        let newItem: UserChat = NSEntityDescription.insertNewObjectForEntityForName(modelName, inManagedObjectContext: chatObj) as! UserChat
        
        if params["type"] as! String == "text"
        {
            newItem.message = params["message"] as? String
        }
        else
        {
            newItem.message=""
        }
        
        //newItem.sortDate = params["sortDate"] as String
        newItem.localSortID = CommonMethodFunctions.nextChatIdentifies()
        newItem.messageType = params["type"] as? String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
        dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
        let str = params["date"] as? String
        var date1 = dateFormatter.dateFromString(str!)
        if date1 == nil
        {
            dateFormatter.dateFormat = "YYYY-MM-dd"
            date1 = dateFormatter.dateFromString(str!)
        }
        
        let dateStr = dateFormatter.stringFromDate(date1!)
        
        
        newItem.messageDate = dateStr as String
        
        
        newItem.messageTime = params["time"] as? String
        newItem.receiverId = params["receiver"] as? String
        newItem.senderId = params["sender"] as? String
        newItem.locMessageId = params["localmsgid"] as? String
        if params["type"] as? String == "notification"
        {
            newItem.messageStatus = "4"
        }else
        {
            newItem.messageStatus = "3"
        }
        newItem.loginUserId = ChatHelper .userDefaultForAny("userId") as? String
        appDelegate.saveContext()
        return newItem
        
    }
    
    func multimediaChatStatusChangeSingleChat(chatObj: UserChat)
    {
        
        if(chatObj.messageStatus=="3")
        {
            chatObj.messageStatus="5";
        }
        
        appDelegate.saveContext()
        
    }
    
    func checkIfChatMsgAlreadyExist(modelName:String, params: Dictionary<String, AnyObject>) -> UserChat!
    {
        ////print(params)
        let instance = DataBaseController.sharedInstance
        let str1:String = (params["messageId"] as? String)!
        let str:String = "messageId LIKE \"\(str1)\""
        var fetchResult=instance.fetchData(modelName,predicate:str,sort:(nil,false))!
        if !fetchResult.isEmpty
        {
            return fetchResult[0] as! UserChat
        }
        else
        {
            return nil
        }
    }
    
    
    func checkIfSenderChatMsgAlreadyExist(modelName:String, params: Dictionary<String, AnyObject>) -> UserChat!
    {
        ////print(params)
        let instance = DataBaseController.sharedInstance
        let str1:String = params["locMessageId"] as! String
        let str:String = "locMessageId LIKE \"\(str1)\""
        var fetchResult=instance.fetchData(modelName,predicate:str,sort:(nil,false))!
        if !fetchResult.isEmpty
        {
            return fetchResult[0] as! UserChat
        }
        else
        {
            return nil
        }
    }
    
    func checkIfSenderGroupChatMsgAlreadyExist(modelName:String, params: Dictionary<String, AnyObject>) -> GroupChat!
    {
        ////print(params)
        let instance = DataBaseController.sharedInstance
        let str1:String = params["locMessageId"] as! String
        let str:String = "locMessageId LIKE \"\(str1)\""
        var fetchResult=instance.fetchData(modelName,predicate:str,sort:(nil,false))!
        if !fetchResult.isEmpty
        {
            return fetchResult[0] as! GroupChat
        }
        else
        {
            return nil
        }
    }
    
    func checkIfChatMsgAlreadyExistWithLocId(modelName:String, params: Dictionary<String, AnyObject>) -> UserChat!
    {
        let instance = DataBaseController.sharedInstance
        let str1:String = params["localmsgid"] as! String
        let str:String = "locMessageId LIKE \"\(str1)\""
        var fetchResult=instance.fetchData(modelName,predicate:str,sort:(nil,false))!
        if !fetchResult.isEmpty
        {
            return fetchResult[0] as! UserChat
        }
        else
        {
            return nil
        }
    }
    
    
    func insertChatFileInDb1(modelName:String, params: Dictionary<String, AnyObject>)->UserChatFile!
    {
        let chatObj = appDelegate.managedObjectContext
        
        let newItem: UserChatFile = NSEntityDescription.insertNewObjectForEntityForName(modelName, inManagedObjectContext: chatObj) as! UserChatFile
        
        
        newItem.mediaUrl = params["mediaUrl"] as? String
        newItem.mediaThumbUrl = params["mediaThumbUrl"] as? String
        newItem.mediaLocalThumbPath = params["localThumbPath"] as? String
        newItem.mediaLocalPath = params["localFullPath"] as? String
        newItem.mediaTypes = params["type"] as? String
        appDelegate.saveContext()
        return newItem
        
    }
    func UpdateChatLocalPath(chatObj: UserChat, fullImgStr: String,  thumbImgStr: String)
    {
        chatObj.chatFile!.mediaLocalPath=fullImgStr;
        chatObj.chatFile!.mediaLocalThumbPath=thumbImgStr;
        appDelegate.saveContext()
        
    }
    func UpdateGroupChatLocalPath(chatObj: GroupChat, fullImgStr: String,  thumbImgStr: String)
    {
        chatObj.groupChatFile!.mediaLocalPath=fullImgStr;
        chatObj.groupChatFile!.mediaLocalThumbPath=thumbImgStr;
        appDelegate.saveContext()
        
    }
    //MARK: Group Chat Contrller
    
    func insertGroupInfoData(modelName:String, params: Dictionary<String, AnyObject>)
    {
        let cdhObj = appDelegate.managedObjectContext
        
        let exist:GroupList? = checkIfGroupAlreadyExist(modelName, params: params)
        if (exist != nil)
        {
            exist!.groupName = params["groupname"] as? String
            exist!.groupId = params["groupid"] as? String
            exist!.loginUserId = ChatHelper .userDefaultForAny("userId") as? String
            exist!.createdDate = params["createdDate"] as? String
            exist!.groupImage = params["imgUrl"] as? String
            exist!.adminUserId = params["createdBy"] as? String
            exist!.userCount = params["usercount"] as? String
            appDelegate.saveContext()
            
        }
        else
        {
            let newItem: GroupList = NSEntityDescription.insertNewObjectForEntityForName(modelName, inManagedObjectContext: cdhObj) as! GroupList
            
            newItem.groupName = params["groupname"] as? String
            newItem.groupId = params["groupid"] as? String
            newItem.loginUserId = ChatHelper .userDefaultForAny("userId") as? String
            newItem.createdDate = params["createdDate"] as? String
            newItem.groupImage = params["imgUrl"] as? String
            newItem.adminUserId = params["createdBy"] as? String
            newItem.userCount = params["usercount"] as? String
            
            //            userCount
            appDelegate.saveContext()
            
            
            
            
        }
    }
    
    
    func insertGroupInfoDataWithAdminRole(modelName:String, params: Dictionary<String, AnyObject>,memberArr:NSArray)
    {
        let cdhObj = appDelegate.managedObjectContext
        
        let exist:GroupList? = checkIfGroupAlreadyExist(modelName, params: params)
        if (exist != nil)
        {
            exist!.groupName = params["groupname"] as? String
            exist!.groupId = params["groupid"] as? String
            exist!.loginUserId = ChatHelper .userDefaultForAny("userId") as? String
            exist!.createdDate = params["createdDate"] as? String
            exist!.groupImage = params["imgUrl"] as? String
            for dict in memberArr{
                if (dict["role"] as! String).lowercaseString == "admin"{
                    exist!.adminUserId = dict["userId"] as? String
                     break;
                }
            }
            exist!.userCount = params["usercount"] as? String
            appDelegate.saveContext()
            
        }
        else
        {
            let newItem: GroupList = NSEntityDescription.insertNewObjectForEntityForName(modelName, inManagedObjectContext: cdhObj) as! GroupList
            
            newItem.groupName = params["groupname"] as? String
            newItem.groupId = params["groupid"] as? String
            newItem.loginUserId = ChatHelper .userDefaultForAny("userId") as? String
            newItem.createdDate = params["createdDate"] as? String
            newItem.groupImage = params["imgUrl"] as? String
            //newItem.adminUserId = params["createdBy"] as? String
            newItem.userCount = params["usercount"] as? String
            for dict in memberArr{
                if (dict["role"] as! String).lowercaseString == "admin"{
                    newItem.adminUserId = dict["userId"] as? String
                    break;
                }
            }

            appDelegate.saveContext()
            
            
            
            
        }
    }
    func checkIfGroupAlreadyExist(modelName:String, params: Dictionary<String, AnyObject>) -> GroupList!
    {
        let instance = DataBaseController.sharedInstance
        let str1:String = params["groupid"] as! String
        let str2:String = ChatHelper .userDefaultForAny("userId") as! String
        let str:String = "groupId LIKE \"\(str1)\" AND  loginUserId contains[cd] \"\(str2)\""
        
        var fetchResult=instance.fetchData(modelName,predicate:str,sort:(nil,false))!
        
        if !fetchResult.isEmpty
        {
            return fetchResult[0] as! GroupList
        }
        else
        {
            return nil
        }
    }
    
    //MARK: Group Chat user
    
    func insertGroupUsersInfoData(modelName:String, params: Dictionary<String, AnyObject>)
    {
        let cdhObj = appDelegate.managedObjectContext
        // print(params)
        let exist:GroupUserList? = checkIfGroupUserAlreadyExist(modelName, params: params)
        if (exist != nil)
        {
            
            exist!.groupId = params["groupid"] as? String
            exist!.userId = params["userid"] as? String
            exist!.userName = params["username"] as? String
            //exist!.loginUserId = ChatHelper .userDefaultForAny("userId") as String
            exist!.userImage = params["imgUrl"] as? String
            //exist!.isAdmin = params["role"] as String
            exist!.isDeletedGroup = params["isDeleted"] as? String
            exist!.isNameAvail = params["isNameAvail"] as? String
            appDelegate.saveContext()
            
        }
        else
        {
            let newItem: GroupUserList = NSEntityDescription.insertNewObjectForEntityForName(modelName, inManagedObjectContext: cdhObj) as! GroupUserList
            
            newItem.groupId = params["groupid"] as? String
            newItem.userId = params["userid"] as? String
            newItem.userName = params["username"] as? String
            newItem.loginUserId = ChatHelper .userDefaultForAny("userId") as? String
            newItem.userImage = params["imgUrl"] as? String
            newItem.isAdmin = params["role"] as? String
            newItem.isNameAvail = params["isNameAvail"] as? String
            newItem.isDeletedGroup = params["isDeleted"] as? String
            
            appDelegate.saveContext()
            
        }
    }
    
    
    
    func multimediaChatStatusChangeGroupChat(chatObj: GroupChat)
    {
        
        if(chatObj.messageStatus=="3")
        {
            chatObj.messageStatus="5";
        }
        
        appDelegate.saveContext()
        
    }
    func checkIfGroupUserAlreadyExist(modelName:String, params: Dictionary<String, AnyObject>) -> GroupUserList!
    {
        let instance = DataBaseController.sharedInstance
        let str1:String = params["groupid"] as! String
        let str2:String = ChatHelper .userDefaultForAny("userId") as! String
        let str3:String = params["userid"] as! String
        let str:String = "groupId LIKE \"\(str1)\" AND  loginUserId contains[cd] \"\(str2)\"  AND  userId contains[cd] \"\(str3)\""
        
        var fetchResult=instance.fetchData(modelName,predicate:str,sort:(nil,false))!
        
        if !fetchResult.isEmpty
        {
            return fetchResult[0] as! GroupUserList
        }
        else
        {
            return nil
        }
    }
    
    
    func insertRecentChatFromGroup(modelName:String, params: Dictionary<String, AnyObject>)
    {
       // print("db record for recent ===> \(params)")
        
        let cdhObj = appDelegate.managedObjectContext
        
        let exist:RecentChatList? = checkIfGroupChatUserAlreadyExist(modelName, params: params)
        if (exist != nil)
        {
            if (params["groupname"] as? String) != nil 
            {
                exist!.friendName = params["groupname"] as? String
            }
            if (params["imgUrl"] as? String) != nil
            {
                exist!.friendImageUrl = params["imgUrl"] as? String
            }
            if (params["messageTime"] as? String) != nil
            {
                exist!.lastMessageTime = params["messageTime"] as? String
            }
            exist!.loginUserId = ChatHelper .userDefaultForAny("userId") as? String
            exist!.lastMessage = params["message"] as? String
            
        
            if let latestValue = params["meldDate"] as? String {
                exist!.meldDate = latestValue
            }
            
            if let latestValue1 = params["servertime"] as? String {
                exist!.meldServerTime = latestValue1
            }

        
            /*
        if let latestValue = params["meldDate"] as? String
        {
          if let latestValue1 = params["servertime"] as? String {
                
            var tempMeldDate = params["meldDate"] as? String
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var tempDate = dateFormatter.dateFromString(tempMeldDate!) as NSDate!

            
            var serverMeldDate =  params["servertime"] as? String
            let dateFormat2 = NSDateFormatter()
            dateFormat2.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var serverTimeDate = dateFormat2.dateFromString(serverMeldDate!) as NSDate!
           // print(serverTimeDate)
            if tempDate.compare(serverTimeDate) == NSComparisonResult.OrderedDescending
            {
                
            }
            else if tempDate.compare(serverTimeDate) == NSComparisonResult.OrderedAscending
            {
                //NSLog("date1 after date2");
                 exist!.lastMessage = "CLOSED"
                 exist!.lastMessageTime = ""
            }
            else
            {
               // NSLog("dates are equal");
            }
            }
        }
            */
            if (NSUserDefaults.standardUserDefaults().stringForKey("friendId") != nil)
            {
                if ChatHelper .userDefaultForAny("friendId") as! String == params["groupid"] as! String
                {
                    exist!.notificationCount = "0"
                }else
                {
                    let strCount: String = exist!.notificationCount!
                    var count : Int = Int(strCount)!
                    count = count + 1
                    exist!.notificationCount =  "\(count)"
                }
            }else
            {
                let strCount: String = exist!.notificationCount!
                //print(strCount)
                var count : Int = Int(strCount)!
                //print(count)
                count = count + 1
                exist!.notificationCount =  "\(count)"
                //print(exist!.notificationCount)
            }
            
            appDelegate.saveContext()
            
        }
        else
        {
            let newItem: RecentChatList = NSEntityDescription.insertNewObjectForEntityForName(modelName, inManagedObjectContext: cdhObj) as! RecentChatList
            
            newItem.friendName = params["groupname"] as? String
            newItem.groupId = params["groupid"] as? String
            newItem.friendId = ""
            newItem.loginUserId = ChatHelper .userDefaultForAny("userId") as? String
            newItem.lastMessage = params["message"] as? String
            newItem.lastMessageTime = params["createdDate"] as? String
            if (params["imgUrl"] as? String) != nil
            {
                newItem.friendImageUrl  = params["imgUrl"] as? String
            }
            
            newItem.isTyping = "0"
            
            if let latestValue = params["meldDate"] as? String {
                  newItem.meldDate = latestValue
            }
            
            if let latestValue1 = params["servertime"] as? String {
               newItem.meldServerTime = latestValue1
            }
            
            /*
            if let latestValue = params["meldDate"] as? String
            {
                if let latestValue1 = params["servertime"] as? String {
                    
            var tempMeldDate = params["meldDate"] as? String
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var tempDate = dateFormatter.dateFromString(tempMeldDate!) as NSDate!
            
            
            var serverMeldDate =  params["servertime"] as? String
            let dateFormat2 = NSDateFormatter()
            dateFormat2.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var serverTimeDate = dateFormat2.dateFromString(serverMeldDate!) as NSDate!
          //  print(serverTimeDate)
            if tempDate.compare(serverTimeDate) == NSComparisonResult.OrderedDescending
            {
                
            }
            else if tempDate.compare(serverTimeDate) == NSComparisonResult.OrderedAscending
            {
               // NSLog("date1 after date2");
                newItem.lastMessage = "CLOSED"
                newItem.lastMessageTime = ""
            }
            else
            {
                NSLog("dates are equal");
            }
                }
            }
            */
            //Hidden by Gaurav
            //print(newItem)
            
//            if let name = NSUserDefaults.standardUserDefaults().stringForKey("friendId")
//            {
//                if ChatHelper .userDefaultForAny("friendId") as String == params["groupid"] as String
//                {
//                    newItem.notificationCount = "0"
//                }else
//                {
//                    newItem.notificationCount = "1"
//                }
//            }else
//            {
                if(params["createdBy"] as! String == ChatHelper .userDefaultForAny("userId") as! String)
                {
                    newItem.notificationCount = "0"
                    
                }else
                {
                    
                   // newItem.notificationCount = "1"
                    // check this code need to keep zero 23 dec - 2015
                    
                    newItem.notificationCount = "0"
                }
           // }
            appDelegate.saveContext()
        }
    }
    func checkIfGroupChatUserAlreadyExist(modelName:String, params: Dictionary<String, AnyObject>) -> RecentChatList!
    {
       // print(params)
        let instance = DataBaseController.sharedInstance
        let str1:String = params["groupid"] as! String
        let str2:String = ChatHelper .userDefaultForAny("userId") as! String
        //let str:String = "userId LIKE \"\(str1)\""
        let str:String = "groupId LIKE \"\(str1)\" AND  loginUserId contains[cd] \"\(str2)\""
        
        var fetchResult=instance.fetchData(modelName,predicate:str,sort:(nil,false))!
        
        if !fetchResult.isEmpty
        {
            return fetchResult[0] as! RecentChatList
        }
        else
        {
            return nil
        }
    }
    
    
    func insertGroupChatMessageInDb(modelName:String, params: Dictionary<String, AnyObject>)->GroupChat!
    {
        let chatObj = appDelegate.managedObjectContext
        
        let exist:GroupChat? = checkIfGroupChatMsgAlreadyExist(modelName, params: params)
        if (exist != nil)
        {
            
            exist!.messageStatus = params["status"] as? String
            exist!.modifiedDate = params["modifiedDate"] as? String
            
            appDelegate.saveContext()
            return exist
        }
        else
        {
            
            let newItem: GroupChat = NSEntityDescription.insertNewObjectForEntityForName(modelName, inManagedObjectContext: chatObj) as! GroupChat
            if params["type"] as! String == "text"
            {
                newItem.message = params["message"] as? String
            }
            else
            {
                newItem.message=""
            }
            newItem.senderName = params["sendername"] as? String
            //newItem.sortDate = dateStr as String
            newItem.groupId = params["groupid"] as? String
            newItem.messageType = params["type"] as? String
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
            dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
            let str = params["date"] as? String
            var date1 = dateFormatter.dateFromString(str!)
            
            if date1 == nil
            {
                dateFormatter.dateFormat = "YYYY-MM-dd"
                date1 = dateFormatter.dateFromString(str!)
            }
            
            let dateStr = dateFormatter.stringFromDate(date1!)
            
            
            newItem.messageDate = dateStr as String
            
            
            // newItem.messageDate = params["date"] as String
            newItem.messageTime = params["time"] as? String
            newItem.receiverId = params["receiver"] as? String
            newItem.senderId = params["sender"] as? String
            newItem.messageId = params["messageId"] as? String
            newItem.messageStatus = params["status"] as? String
            newItem.modifiedDate = params["modifiedDate"] as? String
            newItem.localSortID = CommonMethodFunctions.nextChatIdentifies()
           
            //newItem.locMessageId = params["localmsgid"] as String
            
            newItem.loginUserId = ChatHelper .userDefaultForAny("userId") as? String
            
            
            appDelegate.saveContext()
            return newItem
        }
    }
    func insertGroupChatMessageInDb1(modelName:String, params: Dictionary<String, AnyObject>)->GroupChat!
    {
        //print(params)
        let chatObj = appDelegate.managedObjectContext
        
        let newItem: GroupChat = NSEntityDescription.insertNewObjectForEntityForName(modelName, inManagedObjectContext: chatObj) as! GroupChat
        
        if params["type"] as! String == "text"
        {
            newItem.message = params["message"] as? String
        }
        else
        {
            newItem.message=""
        }
        newItem.localSortID = CommonMethodFunctions.nextChatIdentifies()
        newItem.messageType = params["type"] as? String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
        dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss.sss"
        let str = params["date"] as! String
        var date1 = dateFormatter.dateFromString(str)
        
        if date1 == nil
        {
            dateFormatter.dateFormat = "YYYY-MM-dd"
            date1 = dateFormatter.dateFromString(str)
        }
        
        let dateStr = dateFormatter.stringFromDate(date1!)
        
        newItem.messageDate = dateStr as String
        
        
        
        
        //newItem.messageDate = params["date"] as String
        //newItem.sortDate = params["sortDate"] as String
        newItem.messageTime = params["time"] as? String
        newItem.senderId = params["sender"] as? String
        newItem.locMessageId = params["localmsgid"] as? String
        newItem.groupId = params["groupid"] as? String
        newItem.senderName = params["sendername"] as?
        String
        newItem.messageStatus = "3"
        newItem.loginUserId = ChatHelper .userDefaultForAny("userId") as? String
        appDelegate.saveContext()
        return newItem
        
    }
    
    func checkIfGroupChatMsgAlreadyExist(modelName:String, params: Dictionary<String, AnyObject>) -> GroupChat!
    {
        ////print(params)
        let instance = DataBaseController.sharedInstance
        let str1:String = params["messageId"] as! String
        let str:String = "messageId LIKE \"\(str1)\""
        var fetchResult=instance.fetchData(modelName,predicate:str,sort:(nil,false))!
        if !fetchResult.isEmpty
        {
            return fetchResult[0] as! GroupChat
        }
        else
        {
            return nil
        }
    }
    
    
    func checkIfGroupChatMsgAlreadyExistWithLocId(modelName:String, params: Dictionary<String, AnyObject>) -> GroupChat!
    {
        let instance = DataBaseController.sharedInstance
        let str1:String = params["localmsgid"] as! String
        let str:String = "locMessageId LIKE \"\(str1)\""
        var fetchResult=instance.fetchData(modelName,predicate:str,sort:(nil,false))!
        if !fetchResult.isEmpty
        {
            return fetchResult[0] as! GroupChat
        }
        else
        {
            return nil
        }
    }
    
    
    func insertGroupChatFileInDb1(modelName:String, params: Dictionary<String, AnyObject>)->GroupChatFile!
    {
        let chatObj = appDelegate.managedObjectContext
        let newItem: GroupChatFile = NSEntityDescription.insertNewObjectForEntityForName(modelName, inManagedObjectContext: chatObj) as! GroupChatFile
        
        newItem.mediaUrl = params["mediaUrl"] as? String
        newItem.mediaThumbUrl = params["mediaThumbUrl"] as? String
        newItem.mediaLocalThumbPath = params["localThumbPath"] as? String
        newItem.mediaLocalPath = params["localFullPath"] as? String
        newItem.mediaTypes = params["type"] as? String
        newItem.groupId = params["groupid"] as? String
        appDelegate.saveContext()
        return newItem
    }
    
    
    func fetchDataGrpUserObj(modelName:String, predicate:String?) -> GroupUserList?
    {
        let cdhObj = appDelegate.managedObjectContext
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: modelName)
        
        //Check whether predicate is there
        if (predicate != nil)
        {
            fReq.predicate = NSPredicate(format:predicate!)
        }
        
        var result = [AnyObject]()
        
        do {
            result = try cdhObj.executeFetchRequest(fReq)
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        if !result.isEmpty
        {
            return result[0] as?  GroupUserList
        }
        else
        {
            return nil
        }
    }
 
    func fetchDataGroupObject(modelName:String, predicate:String?) -> GroupList?
    {
        let cdhObj = appDelegate.managedObjectContext
        
        let  fReq: NSFetchRequest = NSFetchRequest(entityName: modelName)
        
        //Check whether predicate is there
        if (predicate != nil)
        {
            fReq.predicate = NSPredicate(format:predicate!)
        }
        
        var result = [AnyObject]()
        
        do {
            result = try cdhObj.executeFetchRequest(fReq)
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        if !result.isEmpty
        {
            return result[0] as?  GroupList
        }
        else
        {
            return nil
        }
    }


}

extension NSManagedObjectContext {
    
    convenience init(parentContext parent: NSManagedObjectContext, concurrencyType: NSManagedObjectContextConcurrencyType) {
        self.init(concurrencyType: concurrencyType)
        parentContext = parent
    }
    
    func deleteAllObjects(error: NSErrorPointer) {
        
        if let entitesByName = persistentStoreCoordinator?.managedObjectModel.entitiesByName   {
            
            for (name, entityDescription) in entitesByName {
             //   deleteAllObjectsForEntity(entityDescription, error: error)
                DataBaseController.sharedInstance.deleteAllData(name)
                
                print("Entity Name = ", name)
                
                // If there's a problem, bail on the whole operation.
                if error.memory != nil {
                    return
                }
            }
        }
}
    
    
}

