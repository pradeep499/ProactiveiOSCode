//
//  UserChatFile+CoreDataProperties.swift
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

extension UserChatFile {

    @NSManaged var mediaLocalPath: String?
    @NSManaged var mediaLocalThumbPath: String?
    @NSManaged var mediaSize: String?
    @NSManaged var mediaThumbUrl: String?
    @NSManaged var mediaTypes: String?
    @NSManaged var mediaUrl: String?
    @NSManaged var messageId: String?
    @NSManaged var userChat: UserChat?

}
