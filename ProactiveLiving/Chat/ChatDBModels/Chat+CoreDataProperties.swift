//
//  Chat+CoreDataProperties.swift
//  Five Dots
//
//  Created by Ankur Batham on 7/4/16.
//  Copyright © 2016 Appstudioz. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Chat {

    @NSManaged var localFileUrl: String?
    @NSManaged var localThumbUrl: String?
    @NSManaged var loginUserid: String?
    @NSManaged var message: String?
    @NSManaged var messageId: String?
    @NSManaged var messageStatus: String?
    @NSManaged var messageType: String?
    @NSManaged var msgTime: String?
    @NSManaged var receiverId: String?
    @NSManaged var senderId: String?
    @NSManaged var serverFileUrl: String?
    @NSManaged var serverThumbUrl: String?

}
