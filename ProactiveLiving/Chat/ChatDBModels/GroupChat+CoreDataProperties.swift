//
//  GroupChat+CoreDataProperties.swift
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

extension GroupChat {

    @NSManaged var chatDirection: String?
    @NSManaged var groupId: String?
    @NSManaged var localSortID: NSNumber?
    @NSManaged var locMessageId: String?
    @NSManaged var loginUserId: String?
    @NSManaged var message: String?
    @NSManaged var messageDate: String?
    @NSManaged var messageId: String?
    @NSManaged var messageStatus: String?
    @NSManaged var messageTime: String?
    @NSManaged var messageType: String?
    @NSManaged var modifiedDate: String?
    @NSManaged var receiverId: String?
    @NSManaged var senderId: String?
    @NSManaged var senderName: String?
    @NSManaged var sessionId: String?
    @NSManaged var sortDate: String?
    @NSManaged var groupChatFile: GroupChatFile?

}
