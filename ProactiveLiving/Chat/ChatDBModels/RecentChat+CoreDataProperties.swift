//
//  RecentChat+CoreDataProperties.swift
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

extension RecentChat {

    @NSManaged var friendId: String?
    @NSManaged var friendImageUrl: String?
    @NSManaged var friendName: String?
    @NSManaged var frndBlock: NSNumber?
    @NSManaged var frndShow: NSNumber?
    @NSManaged var lastmessage: String?
    @NSManaged var lastMessageTime: String?
    @NSManaged var loginUserId: String?
    @NSManaged var notificationCount: String?

}
