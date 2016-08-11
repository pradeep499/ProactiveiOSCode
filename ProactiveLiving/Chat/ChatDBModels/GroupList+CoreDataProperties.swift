//
//  GroupList+CoreDataProperties.swift
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

extension GroupList {

    @NSManaged var adminUserId: String?
    @NSManaged var createdDate: String?
    @NSManaged var groupId: String?
    @NSManaged var groupImage: String?
    @NSManaged var groupName: String?
    @NSManaged var loginUserId: String?
    @NSManaged var userCount: String?

}
